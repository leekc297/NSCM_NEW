import type { FlexGrid } from '@mescius/wijmo.grid';
import type { MutableRefObject } from 'react';

import { CRUD_MSG } from '@foundation/constants';
import type { EditTracker } from '@foundation/utils';
import { useSaveWithValidation } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  BTN_DELETE_DRAFTING,
  BTN_SAVE_COMPLETE,
  CHANGE_STATUS_REQUESTED,
  CHANGE_TYPE_CONFIRM,
  CHANGE_TYPE_NEW,
  COLUMN,
  IF_SEND_OFF,
  IF_SEND_ON,
  MSG,
  SCREEN_TEXT,
  SHIP_STATUS_REQUEST_DONE,
} from '../shipment-change-request-plan.constants';
import type { RequestInfo } from '../shipment-change-request-plan.types';
import {
  hasPartialSoSelection,
  str,
  type GridRowData,
} from '../utils/shipmentChangeRequestPlanDerive';
import {
  buildCancelDraftingPayload,
  buildRequestCompletePayload,
  isRefetchOnlyResult,
  submitCancelDrafting,
  submitRequestComplete,
  type RequestChainResult,
  type RequestChainSession,
} from '../utils/shipmentChangeRequestPlanRequest';
import { saveTargetRows, submitConfirmNewSave } from '../utils/shipmentChangeRequestPlanSave';

import { useShipmentChangeRequestPlanPreChecks } from './useShipmentChangeRequestPlanPreChecks';
import {
  checkRequestInfoRequired,
  checkRequestShipDates,
  hasZeroQty,
  useShipmentChangeRequestPlanValidation,
} from './useShipmentChangeRequestPlanValidation';

interface Params {
  mainGridRef: MutableRefObject<FlexGrid | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  savingRef: MutableRefObject<boolean>;
  staticColumns: Parameters<ReturnType<typeof useSaveWithValidation>['saveWithValidation']>[1];
  /**
   * shtSub 파생 컬럼셋 — 요청확정의 메타 필수검증(`checkRequiredOfSpread(siSub)` cs:3232) 대상이다.
   *   페이지가 만들어 내려준다(그리드 로컬 useMemo 로 두면 검증에 닿지 않는다 —
   *   메모리 dynamic-collbl-required-never-reaches-savevalidation).
   */
  subColumns: Parameters<ReturnType<typeof useSaveWithValidation>['saveWithValidation']>[1];
  requestInfo: RequestInfo;
  subRows: GridRowData[];
  changeType: string;
  /** CHANGE_REQ_DAY 기준일수. undefined 면 출하일 상·하한 검증을 수행하지 않는다(미검증). */
  changeReqDay?: number;
  /** `{0}` 치환까지 처리하는 화면 공용 alert. */
  alert: (msgId: string, defaultText: string, arg?: string) => void;
  translate: (key: string, defaultValue: string) => string;
  confirm: (msgId: string, defaultText: string) => Promise<boolean>;
  refetchAll: () => void;
  clearRequestInfo: () => void;
  setRequestNo: (requestNo: string) => void;
}

/**
 * 저장·요청확정·요청취소 액션 (design 01 §2 L-079~L-083 / 03 §4.4).
 *
 *   Save    : ERP 중단기간 게이트 -> 채번 -> 사전 서버검증(출하상태 3종 + SO 건수) -> 저장확인
 *             -> 메타 필수검증 -> `^` 평면 payload POST -> SP 반환코드 분기.
 *   요청확정 : 필수 4항목 -> 수량 0 -> 출하일 상·하한 -> 동일 SO 부분선택 -> ERP 게이트
 *             -> SAVE_SHIPMENT_REQUEST_COMPLETE(45 IN) -> 반환코드 분기.
 *   요청취소 : detail 0행이면 무동작 -> 확인 -> DELETE_SHIPMENT_REQUEST_DRAFTING(7 IN) -> 반환코드 분기.
 *
 *   페이지에서 분리한 이유는 화면 파일 400행 상한(hook #9)뿐이다 — 로직은 그대로다.
 */
export const useShipmentChangeRequestPlanSaveActions = ({
  mainGridRef,
  editTrackerRef,
  savingRef,
  staticColumns,
  subColumns,
  requestInfo,
  subRows,
  changeType,
  changeReqDay,
  alert,
  translate,
  confirm,
  refetchAll,
  clearRequestInfo,
  setRequestNo,
}: Params) => {
  const setToast = useMessageStore.getState().setToast;
  const session = useSessionStore(s => s.session);
  const { saveWithValidation } = useSaveWithValidation();
  const { checkErpBlock } = useShipmentChangeRequestPlanValidation();
  const { fetchChangeReqNo, checkErpInterface } = useShipmentChangeRequestPlanPreChecks();

  const chainSession: RequestChainSession = {
    userId: String(session.userId ?? ''),
    // TO-BE UserSession 에 타임존 필드가 없다(실측) — 빈 값으로 보내 SP 기본 처리에 맡긴다.
    timeZone: '',
    groupId: String(session.groupId ?? ''),
  };

  const mainSource = (): GridRowData[] => {
    const grid = mainGridRef.current;
    grid?.finishEditing();
    return (grid?.collectionView?.sourceCollection ?? []) as GridRowData[];
  };

  // 변경분 판정은 CRUD_TYPE + EDIT_MAIN 두 축 모두 본다(CP-12) — "수정한 내용 없음" 오판 방지.
  const changedRows = (source: GridRowData[]): GridRowData[] =>
    source.filter(r => str(r.CRUD_TYPE) || str(r[COLUMN.EDIT_MAIN]) === 'Y');

  /**
   * ERP 중단기간 게이트 공통 처리. 'blocked' 면 차단, 'unknown' 이면 **고지 후 진행**한다.
   *   콤보 SQL 자체가 실패하는 상태(SEGMENT2 형식 ↔ TO_DATE 마스크 불일치, 공용 SSP0200/0201/0202)라
   *   'unknown' 을 차단으로 올리면 저장이 영구 불가가 된다. 조용히 통과시키지도 않는다(V-13 정직 판정).
   *   근본 교정(콤보 SQL 마스크)은 `design/05_register_erp_block_combo.sql` 로 분리 산출했다.
   */
  const passErpBlockGate = async (): Promise<boolean> => {
    const block = await checkErpBlock();
    if (block.status === 'blocked') {
      alert(MSG.ERP_BLOCK_PERIOD, 'ERP interface is blocked. ({0})', block.period);
      return false;
    }
    if (block.status === 'unknown') {
      alert(
        SCREEN_TEXT.ERP_BLOCK_UNKNOWN,
        'The ERP interface block period could not be verified. Proceeding without the check.'
      );
    }
    return true;
  };

  // SaveButton(cs:845). 대상 행은 `CRUD_TYPE='I'`(신규) 뿐이다 — AS-IS cs:1005 가 `action != 'I'` 를 skip.
  //   수정행은 요청확정 경로(SAVE_SHIPMENT_REQUEST_COMPLETE) 소관이다.
  const handleSave = () => {
    const source = mainSource();
    const changed = changedRows(source);
    if (changed.length === 0) {
      alert(MSG.NO_CHANGES, 'No modifications have been made.');
      return;
    }
    const targets = saveTargetRows(source);
    if (targets.length === 0) {
      // 신규행이 없으면 이 SP 로 저장할 것이 없다(수정분은 요청확정 경로 소관).
      alert(MSG.NO_CHANGES, 'No modifications have been made.');
      return;
    }
    void (async () => {
      if (savingRef.current) return;
      if (!(await passErpBlockGate())) return;
      // 채번(cs:864) — 실패해도 AS-IS 는 저장을 계속한다(_ChangeReqno 가 null 로 남는다).
      //   현재 CONFIRM_NEW SP 에는 changeReqNo IN 이 없어(PROC_M 31 IN 실측) payload 에 싣지 않는다 —
      //   AS-IS 는 ERP I/F 호출(cs:4336 등)에서 쓰는데 그 경로는 미배선이다. 04 에 기록.
      await fetchChangeReqNo();
      // 사전 서버검증(GetERPInterface cs:3826~3875) — 출하상태 3종 + 동일 SO 건수.
      const preFail = await checkErpInterface(changed, source);
      if (preFail) {
        alert(preFail.msgId, preFail.defaultText, preFail.arg);
        return;
      }
      if (!(await confirm(MSG.SAVE_CONFIRM, 'Would you like to save it?'))) return;
      // 메타 기반 필수검증 — 커스텀 검증만 두면 필수 컬럼 공백 저장이 통과한다(V-15 / CP-9).
      //   전제: INPUT_TP_CD 가 M/IM 으로 정비돼야 실효(현재 전건 'S' — 05_register_input-tp-cd.sql 미적용).
      saveWithValidation(targets, staticColumns, rows => {
        void (async () => {
          if (savingRef.current) return;
          savingRef.current = true;
          try {
            const result = await submitConfirmNewSave(rows, {
              userId: chainSession.userId,
              timeZone: chainSession.timeZone,
            });
            if (!result.ok) {
              // 통신·BE 오류. MSG00328('판가 미입력')은 SP 결과 'F' 전용이라 여기서 쓰지 않는다.
              alert(SCREEN_TEXT.SAVE_FAILED, result.message || 'Save failed.');
              return;
            }
            // 성공 toast 전에 SP 반환코드를 본다(AS-IS cs:1107~1130 분기) — 'S' 만 성공이다.
            if (result.code === 'S') {
              // 수동 post 경로라 useProcMutation 의 자동 toast 가 없다. 코드는 공용 CRUD_MSG 심볼로
              //   참조한다 — 화면이 AS-IS 번호를 직접 적지 않는다(hook #114).
              void setToast({
                type: 'success',
                message: translate(CRUD_MSG.SAVED.id, 'Saved successfully.'),
              });
              editTrackerRef.current?.clearChanges();
              refetchAll();
              return;
            }
            // 반환코드별 분기 — AS-IS cs:1118~1197 을 코드 단위로 그대로 옮긴다.
            //   'N' Model 미조회 / 'F' 판가 미입력 / 'X' SoldTo·ShipTo 상세 or BOD 무효 / 그 외 일반 실패.
            if (result.code === 'N') {
              alert(MSG.MODEL_NOT_SELECTED, 'Please search and enter the Model.');
            } else if (result.code === 'F') {
              alert(
                MSG.SALES_PRICE_MISSING,
                'The sales price has not been entered. Please enter the sales price before proceeding.'
              );
            } else if (result.code === 'X') {
              if (result.message) {
                alert(SCREEN_TEXT.SAVE_REASON_DETAIL, '{0}', result.message);
              } else {
                alert(
                  MSG.BOD_INVALID,
                  'BOD (Trans mode, Incoterms) information corresponding to Div, From Site, To Site is invalid.'
                );
              }
            } else {
              alert(SCREEN_TEXT.SAVE_FAILED, result.message || 'Save failed.');
            }
          } finally {
            savingRef.current = false;
          }
        })();
      });
    })();
  };

  /** 요청확정/취소 공통 실패 분기 (AS-IS cs:2545~2578 / cs:2654~2670). */
  const reportChainFailure = (result: RequestChainResult): void => {
    if (!result.ok) {
      alert(SCREEN_TEXT.SAVE_FAILED, result.reason || 'Save failed.');
      return;
    }
    if (result.reason.includes('Unauthorized')) {
      alert(
        MSG.UNAUTHORIZED_APPROVER,
        'The approver cannot be specified because there is no registered model owner.'
      );
      return;
    }
    if (result.reason.includes('UnModelPic')) {
      alert(MSG.DIFFERENT_MODEL_PIC, 'There are different Model PICs. You can request for the same PIC.');
      return;
    }
    if (result.reason.includes('UnModelItem')) {
      alert(MSG.DIFFERENT_MODEL, 'There are different Model. You can request for the same model.');
      return;
    }
    // 분기 미해당 — AS-IS 는 MSG00284 지만 TO-BE MSG00284 는 'The grid is not ready.' 로 뜻이 다르다.
    alert(SCREEN_TEXT.SAVE_FAILED, result.reason || 'Save failed.');
  };

  // BtnChangeRe_Click(cs:3213) — 필수 4항목 -> 수량 0 -> 출하일 상·하한 -> 동일 SO 부분선택
  //   -> ERP 게이트 -> SaveDataDrafting(cs:2318, sChangeStatus='Q'/sShipStatus='R').
  const handleRequestComplete = () => {
    const miss = checkRequestInfoRequired(requestInfo);
    if (miss) {
      // 항목별 코드 분기 — 콤보 미선택은 MSG00429(design 02 §4.7), 입력값은 MSG00614.
      alert(miss.msgId, 'The {0} value is required.', translate(miss.labelKey, miss.defaultLabel));
      return;
    }
    if (subRows.length === 0) {
      // AS-IS 는 detail 0행이면 iCount==0 으로 SP 를 부르지 않는다(cs:2462) — 조용히 끝나는 것이 패리티다.
      return;
    }
    const source = mainSource();
    const changed = changedRows(source);
    // shtSub 메타 필수검증 — AS-IS `DataUtil.checkRequiredOfSpread(siSub)`(cs:3232) 등가.
    //   커스텀 검증만 두면 라벨 `*` 컬럼이 공백이어도 요청확정이 통과한다
    //   (메모리 dynamic-collbl-required-never-reaches-savevalidation).
    //   호출 위치 = 필수 4항목 직후 2번째. AS-IS cs:3229~3271 순서가
    //   ①checkRequired ②checkRequiredOfSpread(siSub) ③수량 0 ④출하일 상·하한 이고,
    //   빈 셀을 먼저 걸러야 아래 수량·날짜 검사가 공백을 조용히 통과시키지 않는다
    //   (`Convert.ToDouble("")`/`Convert.ToDateTime("")` 예외 자리를 AS-IS 가 이 순서로 피한다).
    //   전제: shtSub INPUT_TP_CD 가 M/O 로 정비돼야 실효(현재 전건 'S' — 05_register_input-tp-cd.sql 미적용).
    saveWithValidation(subRows, subColumns, rows => {
      // 수량 0 차단 — ChangeType='P' 는 전 행 합계, 그 외는 NEW_YN='Y' 행별(§4e #21·#22 / MSG01213).
      if (hasZeroQty(subRows, changeType)) {
        alert(MSG.QTY_ZERO, 'Enter a number greater than 0.');
        return;
      }
      // 출하일 상·하한(cs:3271~3297) — 기준일수는 CHANGE_REQ_DAY lookup 실측값이다.
      const dateFail = checkRequestShipDates(subRows, changeReqDay);
      if (dateFail) {
        alert(dateFail.msgId, dateFail.defaultText, dateFail.arg);
        return;
      }
      // 동일 SO 부분선택 금지(C10 / §4e #35) — 같은 ERP_SO_NO 는 전 행이 함께 요청돼야 한다.
      if (hasPartialSoSelection(source, changed)) {
        alert(MSG.SO_PARTIAL_SELECT, 'All rows of the same SO must be selected.');
        return;
      }
      void (async () => {
        if (savingRef.current) return;
        if (!(await passErpBlockGate())) return;
        savingRef.current = true;
        try {
          const payload = buildRequestCompletePayload(rows, {
            requestInfo,
            changeType,
            changeStatus: CHANGE_STATUS_REQUESTED,
            shipStatus: SHIP_STATUS_REQUEST_DONE,
            ifSendFlag: IF_SEND_OFF, // bErpIFCheck=false(cs:3318)
            session: chainSession,
          });
          const result = await submitRequestComplete(BTN_SAVE_COMPLETE, payload);
          if (!result.ok || result.code !== 'S') {
            reportChainFailure(result);
            return;
          }
          // 채번된 변경요청번호를 폼에 반영한 뒤 완료 안내 -> 요청정보 초기화 -> 재조회(cs:2545~2560).
          setRequestNo(result.requestNo);
          alert(
            MSG.REQUEST_COMPLETED,
            'Your confirmed shipment plan change request has been completed.'
          );
          clearRequestInfo();
          editTrackerRef.current?.clearChanges();
          refetchAll();
        } finally {
          savingRef.current = false;
        }
      })();
    });
  };

  // BtnCancel_Click(cs:3438) — detail 0행이면 알림 없이 무동작이 AS-IS 패리티다(V-18).
  //   ChangeType C/N 은 ERP I/F 송신 플래그를 켠다(cs:3452). p_del_flag 는 'D' 고정(cs:2632).
  const handleCancel = () => {
    if (subRows.length === 0) return;
    void (async () => {
      if (savingRef.current) return;
      if (!(await confirm(MSG.CANCEL_CONFIRM, 'Are you sure you want to cancel?'))) return;
      savingRef.current = true;
      try {
        const payload = buildCancelDraftingPayload(subRows, {
          changeType,
          ifSendFlag:
            changeType === CHANGE_TYPE_CONFIRM || changeType === CHANGE_TYPE_NEW
              ? IF_SEND_ON
              : IF_SEND_OFF,
          session: chainSession,
        });
        const result = await submitCancelDrafting(BTN_DELETE_DRAFTING, payload);
        if (!result.ok || (result.code !== 'S' && !isRefetchOnlyResult(result.code))) {
          reportChainFailure(result);
          return;
        }
        // 성공('S')·부분성공('X') 모두 재조회한다. ERP I/F 후속(GetErpIFCheck cs:2650)은
        //   PKG_SSP0200.P_SSP0200_ERP_IFSEQ_MERGE 가 버튼/API 메타에 없어 미배선이다(04 기록).
        clearRequestInfo();
        editTrackerRef.current?.clearChanges();
        refetchAll();
      } finally {
        savingRef.current = false;
      }
    })();
  };

  return { handleSave, handleRequestComplete, handleCancel };
};
