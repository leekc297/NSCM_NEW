import type { FlexGrid } from '@mescius/wijmo.grid';
import type { MutableRefObject } from 'react';

import { CRUD_MSG } from '@foundation/constants';
import { GridAction, type EditTracker } from '@foundation/utils';
import { useSaveWithValidation } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  BTN_DELETE_DRAFTING,
  BTN_SAVE_COMPLETE,
  CHANGE_STATUS_REQUESTED,
  CHANGE_TYPE_CONFIRM,
  CHANGE_TYPE_NEW,
  COLUMN,
  ERP_IF_SUCCESS,
  IF_SEND_OFF,
  IF_SEND_ON,
  MSG,
  RESULT_SUCCESS,
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
import {
  draftingModifyGroups,
  saveTargetRows,
  submitConfirmNewSave,
  submitDraftingModifySave,
  submitErpIfSeqMerge,
  submitErpInterface,
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

  /**
   * 수정행 묶음 저장 — AS-IS `GetERPInterface` **2번째 루프**(cs:3593~3640)의 이식이다.
   *   묶음마다 DRAFTING SP 1콜(`SoNo`/`NonSoNo`) -> 2행 이상이면 IFSEQ 병합(cs:4514) -> ERP I/F(cs:4516).
   *
   *   실패해도 다음 묶음을 계속 돌린다 — AS-IS 도 `bReturn = false` 만 세우고 `//return false;` 는
   *   주석이다(cs:3616/3631). 사유는 묶음별로 바로 알린다.
   *   반환값은 "한 묶음이라도 DRAFTING 저장에 성공했는지" 다 — 재조회 여부를 가르는 기준이다.
   *
   *   AS-IS 차이(의도적, 사용자 승인 2026-10-03): ERP I/F 결과는 저장 성패로 올리지 않는다.
   *   AS-IS 는 E_TYPE 'S_E'/'E' 면 전송 실패분 초안을 되돌리지만(cs:4656
   *   `SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`) 그 SP 가 TO-BE 미배포라 롤백이 불가하다.
   *   되돌릴 수 없는데 "저장 실패" 로 알리면 사용자가 재저장해 ERP 전송행만 중복 누적된다 —
   *   초안은 저장됐음을 유지하고 전송 사유만 별도 안내한다(04 확인필요로 기록).
   */
  const saveModifyGroups = async (
    groups: GridRowData[][],
    changeReqNo: string
  ): Promise<boolean> => {
    let savedAny = false;
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
      if (!erp.ok) {
        alert(SCREEN_TEXT.ERP_IF_FAILED, 'ERP interface call failed. ({0})', 'call failed');
      } else if (erp.eType && erp.eType !== ERP_IF_SUCCESS) {
        alert(SCREEN_TEXT.ERP_IF_FAILED, 'ERP interface failed. ({0})', erp.eMessage || erp.eType);
      }
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
      if (hasPartialSoSelection(source, changed)) {
        alert(MSG.SO_PARTIAL_SELECT, 'All rows of the same SO must be selected.');
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
        // 성공('S')·부분성공('X') 모두 재조회한다. ERP I/F 후속(GetErpIFCheck cs:2650)은
        //   PKG_SSP0200.P_SSP0200_ERP_IFSEQ_MERGE 가 버튼/API 메타에 없어 미배선이다(04 기록).
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
