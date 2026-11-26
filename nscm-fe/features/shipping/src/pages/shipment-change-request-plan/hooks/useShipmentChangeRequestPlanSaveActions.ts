import type { FlexGrid } from '@mescius/wijmo.grid';
import type { MutableRefObject } from 'react';

import { CRUD_MSG } from '@foundation/constants';
import { GridAction, sessionTimeZone, type EditTracker } from '@foundation/utils';
import { useSaveWithValidation } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  BTN_DELETE_DRAFTING,
  BTN_SAVE_COMPLETE,
  CHANGE_STATUS_REQUESTED,
  CHANGE_TYPE_CONFIRM,
  CHANGE_TYPE_NEW,
  COLUMN,
  ERP_IF_ERROR,
  ERP_IF_NO_DATA,
  ERP_IF_PARTIAL_ERROR,
  ERP_IF_PI_FAIL,
  ERP_IF_SUCCESS,
  IF_SEND_OFF,
  IF_SEND_ON,
  MSG,
  MSG_ERP,
  RESULT_SUCCESS,
  SCREEN_TEXT,
  SHIP_STATUS_REQUEST_DONE,
} from '../shipment-change-request-plan.constants';
import type { RequestInfo } from '../shipment-change-request-plan.types';
import {
  findPartialSoSelection,
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
import {
  draftingModifyGroups,
  parseErpErrorConfirms,
  saveTargetRows,
  submitConfirmNewSave,
  submitDeleteDraftingByConfirm,
  submitDraftingModifySave,
  submitErpErrorConfirm,
  submitErpIfSeqMerge,
  submitErpInterface,
  type ErpErrorConfirm,
} from '../utils/shipmentChangeRequestPlanSave';

import { useShipmentChangeRequestPlanPreChecks } from './useShipmentChangeRequestPlanPreChecks';
import {
  checkRequestInfoRequired,
  checkRequestShipDates,
  hasZeroQty,
  useShipmentChangeRequestPlanValidation,
} from './useShipmentChangeRequestPlanValidation';

/**
 * `saveWithValidation` 4번째 인자(검증 전용 행) 타입. 공용 훅은 셀 값을 `WijmoPrimitive` 로 좁혀 두는데
 *   이 화면의 행은 SP 반환 원본(`Record<string, unknown>`)이라 구조적으로 대입되지 않는다 —
 *   검증은 값을 읽기만 하므로(findMissingMandatory) 호출부에서 좁히지 않고 그대로 넘긴다.
 */
type ValidationRows = Parameters<ReturnType<typeof useSaveWithValidation>['saveWithValidation']>[3];

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
  /**
   * New(CONFIRM_NEW) 저장 성공 직후 2단계 — AS-IS GetNewERPInterface->NewNonSoNo(cs:1111/4180) 등가.
   *   방금 만든 확정행(_N 재조회 후 ATTRIBUTE10='I')마다 DRAFTING 저장을 호출해 변경요청 초안을 만들고
   *   원본 확정을 SHIPMENT_STATUS='D' 로 바꿔 아래(sub) grid 에 조회되게 한다. changeReqNo 는 채번값이다.
   *   구현·재조회는 페이지가 소유한다(refetchNew/refetchSub 가 페이지 스코프라).
   */
  draftNewRowsAfterSave: (changeReqNo: string) => Promise<void>;
  clearRequestInfo: () => void;
  setRequestNo: (requestNo: string) => void;
  /**
   * 저장/요청확정/요청취소 서버 작업 중 로딩 표시 토글 — 조회 로딩(전역 useIsBusy 스피너)과 동일한
   *   딤 오버레이 + 원형 스피너를 페이지가 렌더한다. 수동 apiClient post 경로라 전역 스피너가 안 잡혀
   *   여기서 직접 켠다(사용자 보고 2026-10-01). 확인/알림 다이얼로그 중에는 꺼서 가리지 않는다.
   */
  setSaving: (saving: boolean) => void;
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
  draftNewRowsAfterSave,
  clearRequestInfo,
  setRequestNo,
  setSaving,
}: Params) => {
  const setToast = useMessageStore.getState().setToast;
  const session = useSessionStore(s => s.session);
  const { saveWithValidation } = useSaveWithValidation();
  const { checkErpBlock } = useShipmentChangeRequestPlanValidation();
  const { fetchChangeReqNo, checkErpInterface } = useShipmentChangeRequestPlanPreChecks();

  const chainSession: RequestChainSession = {
    userId: String(session.userId ?? ''),
    // 사용자 TZ(SCM_ADM_USER_M.TMZ_CD). CONFIRM_NEW 2430행이 새 Confirm ID 날짜부
    //   'C'+YYYYMMDD 를 FN_MULTY_TIME(P_TIME_ZONE) 으로 잡는다 — 이 값이 ID 날짜를 결정한다.
    //   DRAFTING·DELETE_DRAFTING·REQUEST_COMPLETE 는 받기만 하고 미사용(SYSDATE).
    timeZone: sessionTimeZone(session),
    groupId: String(session.groupId ?? ''),
  };

  const mainSource = (): GridRowData[] => {
    const grid = mainGridRef.current;
    grid?.finishEditing();
    return (grid?.collectionView?.sourceCollection ?? []) as GridRowData[];
  };

  /** 취소 대상 요청번호 — 하단 그리드 행들은 한 요청에 속하므로 중복을 제거한다(AS-IS 는 단일 값). */
  const cancelRequestNo = (rows: GridRowData[]): string => {
    const seen = new Set(rows.map(r => str(r[COLUMN.CHANGE_REQ_NO])).filter(no => no !== ''));
    return [...seen].join('^'); // 실시간 SP 는 '^' 다건을 받는다(SCM_ARR_SPL_CNT)
  };

  /**
   * 취소 후 ERP 송신 결과 안내 — AS-IS `GetErpIFCheck`(cs:4946~4965).
   *   Save 경로(`GetErpIFCheckNew`)와 달리 C_E 를 MSG00306 으로 따로 가른다. 성공은 알리지 않는다.
   */
  const notifyCancelErpResult = async (requestNo: string): Promise<void> => {
    if (!requestNo) return;
    const erp = await submitErpInterface(requestNo);
    const eType = erp.ok ? erp.eType : ERP_IF_PI_FAIL;
    if (!eType || eType === ERP_IF_SUCCESS) return;
    if (eType === ERP_IF_NO_DATA) {
      alert(MSG_ERP.SYSTEM_ERROR, 'System error. Request No : {0}', requestNo);
    } else if (eType === ERP_IF_PI_FAIL) {
      alert(MSG_ERP.PI_FAIL, 'An error occurred while transferring data.');
    } else {
      alert(MSG_ERP.ISSUE, 'ERP cannot be processed due to an ISSUE. {0}', erp.eMessage || eType);
    }
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

  /**
   * 수정행 묶음 저장 — AS-IS `GetERPInterface` **2번째 루프**(cs:3593~3640)의 이식이다.
   *   묶음마다 DRAFTING SP 1콜(`SoNo`/`NonSoNo`) -> 2행 이상이면 IFSEQ 병합(cs:4514) -> ERP I/F(cs:4516).
   *
   *   실패해도 다음 묶음을 계속 돌린다 — AS-IS 도 `bReturn = false` 만 세우고 `//return false;` 는
   *   주석이다(cs:3616/3631). 사유는 묶음별로 바로 알린다.
   *   반환값은 "한 묶음이라도 DRAFTING 저장에 성공했는지" 다 — 재조회 여부를 가르는 기준이다.
   *
   *   AS-IS 차이(의도적, 사용자 승인 2026-10-03): ERP I/F 결과는 저장 성패(= 재조회 여부)로 올리지 않는다.
   *   단 **보상은 한다** — 2026-10-25 DB 실측으로 SP 가 배포돼 있음을 확인해 배선했다(종전 주석의
   *   "TO-BE 미배포" 는 사실이 아니었다). AS-IS 정본 cs:4978~5057 + 뒤처리 cs:3931~4015 를 따른다:
   *     E · S_E → 실패 CONFIRM 초안 되돌림(cs:5011) → 전 묶음 종료 후 오류 적재(cs:3952) + MSG00197
   *     F · C_E → 해당 요청 초안 전체 되돌림 + ERP 취소 송신(cs:3991~4007) + MSG00204
   *   보상은 ERP 가 거절했을 때만 돈다 — 연계 미구성 환경(BE stub)은 항상 'S' 라 발동하지 않는다.
   */
  const saveModifyGroups = async (
    groups: GridRowData[][],
    changeReqNo: string
  ): Promise<boolean> => {
    let savedAny = false;
    // AS-IS errConfirmList / F_CE_requestNo 등가(cs:93~94). 묶음 루프가 끝난 뒤 한 번에 처리한다.
    const errConfirms: ErpErrorConfirm[] = [];
    let fCeRequestNo = '';
    let fCeConfirmIds: string[] = [];

    for (const group of groups) {
      const result = await submitDraftingModifySave(group, {
        userId: chainSession.userId,
        // AS-IS `UserInfoContext.Current["Dept_ID"]`(cs:4354) 등가 — 신규 2단계와 같은 원천이다.
        userDeptId: requestInfo.requestDeptId,
        changeReqNo,
      });
      if (!result.ok || result.code !== RESULT_SUCCESS) {
        if (result.code === 'X') {
          // BOD(Trans mode, Incoterms) 무효 — AS-IS cs:4525 MSG00293.
          if (result.message) {
            alert(SCREEN_TEXT.SAVE_REASON_DETAIL, '{0}', result.message);
          } else {
            alert(
              MSG.BOD_INVALID,
              'BOD (Trans mode, Incoterms) information corresponding to Div, From Site, To Site is invalid.'
            );
          }
        } else {
          const detail = result.message || `code=${result.code || 'ERR'}`;
          alert(
            SCREEN_TEXT.MODIFY_SAVE_FAILED,
            'Failed to save the change request. ({0})',
            detail
          );
        }
        continue;
      }
      if (!result.requestNo) {
        // AS-IS cs:4518~4522 — 'S' 인데 요청번호가 비면 실패로 본다(후속 ERP 전송 키가 없다).
        alert(
          SCREEN_TEXT.MODIFY_SAVE_FAILED,
          'Failed to save the change request. ({0})',
          'no request no'
        );
        continue;
      }
      savedAny = true;
      // 한 요청번호 아래 전송행이 2건 이상일 때만 IFSEQNO 를 병합한다(cs:4514 `if (iCount > 1)`).
      if (group.length > 1) await submitErpIfSeqMerge(result.requestNo);

      const erp = await submitErpInterface(result.requestNo);
      // 호출 자체 실패는 AS-IS catch 와 같이 C_E 로 본다(= F 와 같은 묶음 처리).
      const eType = erp.ok ? erp.eType : ERP_IF_PI_FAIL;

      if (eType === ERP_IF_ERROR || eType === ERP_IF_PARTIAL_ERROR) {
        // cs:4993~5024 — 실패 CONFIRM 만 초안을 되돌리고, 사유는 모아 두었다가 루프 뒤 한 번에 적재한다.
        const parsed = parseErpErrorConfirms(erp.eMessage, result.requestNo);
        if (parsed.length > 0) {
          await submitDeleteDraftingByConfirm(
            parsed.map(e => e.confirmId),
            result.requestNo,
            chainSession
          );
          errConfirms.push(...parsed);
        }
      } else if (eType === ERP_IF_NO_DATA || eType === ERP_IF_PI_FAIL) {
        // cs:5041~5046 — 요청번호와 그 묶음 CONFIRM 을 남겨 두고 루프 뒤에 통째로 되돌린다.
        fCeRequestNo = result.requestNo;
        fCeConfirmIds = group.map(r => str(r[COLUMN.CONFIRM_ID])).filter(id => id !== '');
      }
    }

    // 묶음 루프 종료 후 — AS-IS cs:3931~4015
    if (errConfirms.length > 0) {
      await submitErpErrorConfirm(errConfirms, chainSession.userId);
      alert(
        MSG_ERP.ISSUE,
        'ERP cannot be processed due to an ISSUE. {0}',
        errConfirms.map(e => `${e.confirmId}:${e.message}`).join('\n')
      );
    } else if (fCeRequestNo) {
      // cs:3970~4008 — 해당 요청 초안 전체를 되돌리고 ERP 로 취소를 보낸 뒤 안내한다.
      if (fCeConfirmIds.length > 0) {
        await submitDeleteDraftingByConfirm(fCeConfirmIds, fCeRequestNo, chainSession);
        await submitErpInterface(fCeRequestNo);
      }
      alert(MSG_ERP.SYSTEM_ERROR, 'System error. Request No : {0}', fCeRequestNo);
    }
    return savedAny;
  };

  /**
   * SaveButton(cs:807~1109). AS-IS 순서를 그대로 따른다:
   *   변경분 유무(cs:840) -> ERP 중단기간 게이트 -> 채번(cs:864)
   *   -> `GetERPInterface()` 1번 루프 = 사전 서버검증(출하상태 3종 + SO 건수)
   *   -> `GetERPInterface()` 2번 루프 = **수정행 DRAFTING 저장**(+IFSEQ 병합 +ERP I/F)
   *   -> 신규행 `CONFIRM_NEW` 저장(cs:918~1045) -> 2단계 초안화 -> 재조회(cs:1092 FindButton).
   *
   *   2번 루프는 2026-10-03 까지 미이식 상태였다 — 그래서 수정 저장이 영구 무동작이었고
   *   "요청확정으로 저장됩니다" 안내는 사실과 달랐다(요청확정은 shtSub 를 COMPLETE SP 로 보낼 뿐
   *   main 수정행을 저장하지 않는다). 상세 근거는 utils/shipmentChangeRequestPlanSave.ts 헤더.
   *
   *   AS-IS 차이(의도적): 확인창(MSG00012)을 수정·신규 **공통 1회**로 앞세운다. AS-IS 는 확인 없이
   *   수정분을 먼저 저장하고(ERP 전송까지) 신규행이 있을 때만 물었다 — ERP 전송을 묻지 않고 하는 쪽이
   *   더 위험하다. 묻는 위치만 다르고 저장 대상·순서는 같다.
   */
  const handleSave = () => {
    const source = mainSource();
    const changed = changedRows(source);
    if (changed.length === 0) {
      alert(MSG.NO_CHANGES, 'No modifications have been made.');
      return;
    }
    // 수정행(action M/D, CHANGE_TYPE≠'P') 묶음 + 신규행(action I). 둘 다 0건이면 보낼 것이 없다.
    const modifyGroups = draftingModifyGroups(source);
    const targets = saveTargetRows(source);
    if (modifyGroups.length === 0 && targets.length === 0) {
      alert(MSG.NO_CHANGES, 'No modifications have been made.');
      return;
    }
    void (async () => {
      if (savingRef.current) return;
      if (!(await passErpBlockGate())) return;
      // 채번(cs:864) — 실패해도 AS-IS 는 저장을 계속한다(_ChangeReqno 가 빈 값으로 남고 SP 가 자체
      //   채번한다 — PKG body 1298~1307). CONFIRM_NEW SP 에는 changeReqNo IN 이 없어 신규 1단계엔
      //   안 싣고, 수정 저장(cs:4493)과 신규 2단계(cs:4336)에 싣는다.
      setSaving(true);
      const changeReqNo = await fetchChangeReqNo();
      // 사전 서버검증 = GetERPInterface 1번 루프(cs:3553~3591) — 출하상태 3종 + 동일 SO 건수.
      const preFail = await checkErpInterface(changed, source);
      // 확인/알림 다이얼로그 전에는 로딩을 끈다 — 딤 오버레이가 다이얼로그를 가리지 않도록.
      setSaving(false);
      if (preFail) {
        alert(preFail.msgId, preFail.defaultText, preFail.arg);
        return;
      }
      if (!(await confirm(MSG.SAVE_CONFIRM, 'Would you like to save it?'))) return;
      // 메타 기반 필수검증 — 커스텀 검증만 두면 필수 컬럼 공백 저장이 통과한다(V-15 / CP-9).
      //   검증 대상은 **변경행 전체**(수정+신규)다. 신규행만 검증하면 수정행의 필수 공백이 ERP 로 새어
      //   나간다. 저장 payload 는 신규행(targets)이라 4번째 인자로 검증행을 따로 넘긴다.
      //   전제: INPUT_TP_CD 가 M/IM 으로 정비돼야 실효(2026-09-29 적용 — 편집가능 24컬럼).
      saveWithValidation(
        targets,
        staticColumns,
        rows => {
          void (async () => {
            if (savingRef.current) return;
            savingRef.current = true;
            setSaving(true);
            try {
              // 1) 수정행 저장 — AS-IS 는 신규 저장보다 **먼저** 한다(cs:851 이 cs:918 보다 앞).
              let modifySavedAny = false;
              if (modifyGroups.length > 0) {
                modifySavedAny = await saveModifyGroups(modifyGroups, changeReqNo);
                // 한 묶음도 저장되지 않았고 신규행도 없으면 끝낸다 — 사유는 묶음별로 이미 알렸고,
                //   AS-IS 도 "변경 실패" 후 재조회하지 않는다(cs:851~856, finally 의 FindButton 은 주석).
                if (!modifySavedAny && rows.length === 0) return;
              }
              // 2) 신규행이 없으면 여기서 끝낸다 — AS-IS 도 iCount==0 이면 CONFIRM_NEW 를 부르지 않는다(cs:980).
              if (rows.length === 0) {
                if (modifySavedAny) {
                  void setToast({
                    type: 'success',
                    message: translate(CRUD_MSG.SAVED.id, 'Saved successfully.'),
                  });
                  GridAction.discardChanges(mainGridRef.current, editTrackerRef.current);
                  // AS-IS cs:1092 finally 의 FindButton 등가 — 저장분이 아래(sub) grid 로 넘어간다.
                  refetchAll();
                }
                return;
              }
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
                // clearChanges 는 셀수정('M')만 지운다 — 신규('I') 행은 CRUD_TYPE 이 남아 다음 조회에서
                //   GridUtils.isDirty=true 로 "저장되지 않은 내역"(MSG00703)이 뜬다. 저장 성공분은 이미
                //   서버에 있으므로 discardChanges 로 그리드의 신규/수정 행 자체를 걷어낸다(재조회로 교체).
                GridAction.discardChanges(mainGridRef.current, editTrackerRef.current);
                // 2단계(AS-IS GetNewERPInterface->NewNonSoNo cs:1111) — 방금 만든 확정을 변경요청 초안으로
                //   승격해 아래(sub) grid 에 조회되게 한다. 확정(1단계)은 이미 저장됐으므로 초안 실패만 별도 처리.
                await draftNewRowsAfterSave(changeReqNo);
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
              // 신규 저장이 실패해도 앞서 저장된 수정분은 서버에 남아 있다 — 그리드를 맞춘다.
              if (modifySavedAny) refetchAll();
            } finally {
              savingRef.current = false;
              setSaving(false);
            }
          })();
        },
        changed as unknown as ValidationRows
      );
    })();
  };

  /** 요청확정/취소 공통 실패 분기 (AS-IS cs:2545~2578 / cs:2654~2670).
   *   업무 태그는 두 경로로 온다: (1) 성공커서 밖 2커서 reason(ok=true), (2) SP 가
   *   RAISE_APPLICATION_ERROR(-20001,'UnModelItem') 로 직접 raise(ok=false, reason=ORA 원문).
   *   어느 경로든 reason 문자열로 판정해 원문 ORA 노출 대신 안내 메시지로 매핑한다
   *   (2026-09-30: "ORA-20001: UnModelItem" 원문 노출 해소). */
  const reportChainFailure = (result: RequestChainResult): void => {
    const reason = result.reason || '';
    if (reason.includes('Unauthorized')) {
      alert(
        MSG.UNAUTHORIZED_APPROVER,
        'The approver cannot be specified because there is no registered model owner.'
      );
      return;
    }
    if (reason.includes('UnModelPic')) {
      alert(MSG.DIFFERENT_MODEL_PIC, 'There are different Model PICs. You can request for the same PIC.');
      return;
    }
    if (reason.includes('UnModelItem')) {
      alert(MSG.DIFFERENT_MODEL, 'There are different Model. You can request for the same model.');
      return;
    }
    // 분기 미해당 — AS-IS 는 MSG00284 지만 TO-BE MSG00284 는 'The grid is not ready.' 로 뜻이 다르다.
    alert(SCREEN_TEXT.SAVE_FAILED, reason || 'Save failed.');
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
      const partialSoNo = findPartialSoSelection(source, changed);
      if (partialSoNo) {
        alert(
          MSG.SO_PARTIAL_SELECT,
          'There other cases SO generated by the same number.\nMake the same changes based on the SO number.\n[ SO NO : {0} ]',
          partialSoNo
        );
        return;
      }
      void (async () => {
        if (savingRef.current) return;
        if (!(await passErpBlockGate())) return;
        savingRef.current = true;
        setSaving(true);
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
          setSaving(false);
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
      setSaving(true);
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
        // 성공('S')·부분성공('X') 모두 재조회한다.
        // 취소 후 ERP 전송 — AS-IS cs:2650 `GetErpIFCheck(p_change_request_no)`.
        //   위 DELETE_DRAFTING 이 ifSendFlag='Y' 로 송신표에 취소('D') 줄을 쌓고, 그걸 여기서 내보낸다.
        //   분기는 Save 경로와 다르다(cs:4946~4965): E → MSG00197 / F → MSG00204 / C_E → MSG00306.
        //   AS-IS 의 실패 시 DELETE_DRAFTING 재호출(cs:4930~4943, del_flag='E'·if_send_flag='N')은
        //   **일부러 이식하지 않는다**. 미배선 누락이 아니라 TO-BE SP 기준 무동작이기 때문이다
        //   (DB 실측 2026-10-25, PKG_SSP0200 BODY 3147~3279):
        //     P_DEL_FLAG 는 전체에서 두 번만 나온다 — 선언(3151)과 3227 `IF P_DEL_FLAG='D' AND
        //     P_IF_SEND_FLAG='Y'` 뿐이고, 그 안의 PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW('D',…)
        //     (ERP 취소 적재)를 가르는 게이트로만 쓰인다.
        //     무효화 UPDATE 들은 플래그와 무관한 리터럴이다 —
        //       3199/3205 VALID_YN='N' · 3211 SHIPMENT_STATUS='C', CHANGE_REQ_NO=NULL, ATTRIBUTE1=NULL
        //       3221 DELETE ... CHANGE_TYPE='N'
        //     따라서 'D'/'Y' 로 이미 부른 뒤 'E'/'N' 으로 다시 부르면 같은 멱등 UPDATE 를 반복하고
        //     유일하게 달라질 적재만 건너뛴다 = 아무 효과가 없다. DB 왕복만 늘어난다.
        //   (AS-IS 는 그 호출에서 p_confirm_id 자리에 CONFIRM_ID 가 아니라 RequestNo 를 넘긴다(cs:4932).)
        await notifyCancelErpResult(cancelRequestNo(subRows));
        clearRequestInfo();
        editTrackerRef.current?.clearChanges();
        refetchAll();
      } finally {
        savingRef.current = false;
        setSaving(false);
      }
    })();
  };

  return { handleSave, handleRequestComplete, handleCancel };
};
