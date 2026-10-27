/**
 * SSP0201 변경요청 취소(btnCancel) — **서버에 초안 무효화를 보낸다.**
 *
 * AS-IS: GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0201_ShipmentChangeRequest.cs
 *   `BtnCancel_Click`(L3021~3040):
 *     1. `siSub.ActiveSheet.RowCount == 0` 이면 return                (호출부 가드)
 *     2. MSG00195 확인창, No 면 return                                 (호출부)
 *     3. `sShipStatus` = changeType 이 C/N 이면 'C' 아니면 'P'          (화면 변수 — 취소 경로에서 미사용)
 *     4. `bDeleClickYn = true`                                        (화면 변수)
 *     5. changeType 이 C/N 이면 `bErpIFCheck = true`                   -> p_if_send_flag
 *     6. **`DeleteDataDrafting("C")`**                                 <- 이 파일
 *     7. `ClearRequestInfo()`                                         (호출부)
 *
 *   종전 TO-BE 는 6번을 **아예 호출하지 않았다** — 확인창을 누르면 요청정보 폼만 비우고 재조회해서,
 *   초안이 그대로 남아 하위 그리드에 다시 올라왔다(사용자 신고 2026-10-13 "취소가 동작하지 않는다").
 *
 * `DeleteDataDrafting(sFlag)`(L2328~2425)의 **취소 분기**(sFlag='C' = `!= "D"`):
 *   하위 그리드 **전 행**의 CONFIRM_ID / CHANGE_REQ_NO 를 `^` 로 접어 보낸다(`CString.AppendString`
 *   기본 구분자 '^', CString.cs:583). 체크박스(CHK)를 보지 않는다 — 그건 toolbar Delete 의 'D'
 *   분기이고, 취소는 그 변경요청 전체를 되돌린다. 그래서 MSG00198(최초 선택행 삭제 불가) 가드도
 *   취소 경로에는 걸리지 않는다.
 *   `p_del_flag` 는 sFlag 가 아니라 **'D' 고정**이다(L2388 — 취소/삭제 모두 'D').
 *
 * 서버 실측(ora.py 2026-10-13):
 *   `PKG_SSP0201.P_SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING` VALID. 본문(L3243~)은
 *     - `SSP_ANL_SHIP_CONFIRM_CHG_REQ`    VALID_YN='N'
 *     - `SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE` VALID_YN='N'
 *     - `SSP_ANL_SHIP_CONFIRM`            SHIPMENT_STATUS='C', CHANGE_REQ_NO=NULL, ATTRIBUTE1=NULL
 *   즉 **확정행을 변경요청 전 상태로 되돌린다**. 루프 수는 `F_SPL_CNT(P_CHANGE_REQUEST_NO)` 가 정하고
 *   `P_SPL_ARR` 가 두 CLOB 를 그 수로 split 하므로 **두 인자의 토큰 수가 같아야 한다** — 하나만
 *   어긋나면 엉뚱한 CONFIRM_ID 가 되돌려진다. 빈 값도 자리를 지켜 join 한다.
 *   `API_M`: `SSP0201_main_CANCEL` -> 위 SP (이미 등록돼 있었다 — 신규 생성 불요).
 *   `PROC_M`: 9행 등록. confirmId/changeRequestNo = **CLOB**(FE 가 접어 보낸다), 나머지 5개 VARCHAR 스칼라.
 *   버튼 매핑·권한은 `23_register_cancel_btn_auth.sql` 로 등록한다(사용자 실행).
 *
 * SP 주석(L3230) "2026.10.08 AJS — SSP0200 처럼 결과 X 반환 제거(항상 S)": 이 SP 는 사실상 항상
 *   'S' 를 돌려준다. 그래도 응답 판정을 생략하지 않는다 — HTTP 403(버튼권한 미등록)·통신오류는
 *   여전히 구분해야 하고, 그걸 성공으로 넘기면 "취소했는데 그대로"가 재발한다.
 */

import { apiClient } from '@foundation/apis';

import { MENU_ID, SHEETS } from '../shipment-change-request.constants';

import { FOLD, s } from './shipmentChangeRequestNewSave';
import {
  judgeSaveError,
  judgeSaveResponse,
  readResultCode,
  type SaveOutcome,
} from './shipmentChangeRequestResult';

type Row = Record<string, unknown>;

/** 버튼 코드 — `API_M` 의 `{MNU_ID}_{SHT_NM}_{MNU_BTN_CD}` 규약상 `SSP0201_main_CANCEL` 에 대응한다. */
export const BTN_CANCEL = 'CANCEL';

/** `p_del_flag` — AS-IS L2388 이 sFlag 와 무관하게 'D' 를 박아 보낸다. */
const DEL_FLAG = 'D';

/**
 * ERP 전송 여부 — AS-IS `bErpIFCheck`(L3035~3036)가 changeType 이 C/N 일 때만 true 다.
 *   'P'(Plan) 취소는 ERP 로 보내지 않는다.
 */
const ERP_IF_CHANGE_TYPES: readonly string[] = ['C', 'N'];

export interface CancelContext {
  userId: string;
  timeZone: string;
  /** 조회조건 Plan Type(cboChangeType) — p_change_type + p_if_send_flag 판정에 쓴다. */
  changeType: string;
}

export interface CancelResult {
  outcome: SaveOutcome;
  /** 보낼 대상이 없었다(하위 그리드가 비었거나 CHANGE_REQ_NO 가 전무). 서버 호출을 하지 않았다. */
  nothingToSend: boolean;
}

/**
 * 하위 그리드 전 행에서 (CONFIRM_ID, CHANGE_REQ_NO) 쌍을 뽑는다.
 *
 * `CHANGE_REQ_NO` 가 빈 행은 **제외**한다 — SP 가 `WHERE CHANGE_REQ_NO = <토큰>` 으로 UPDATE 하므로
 * 빈 토큰은 0건 UPDATE 로 조용히 지나가고, 그만큼 CONFIRM_ID 쪽 토큰이 밀려 **다른 확정행이
 * 되돌려진다**(두 CLOB 는 인덱스로 짝지어진다). AS-IS 는 빈 값도 그대로 실었지만, 그건 FarPoint
 * 그리드가 CHANGE_REQ_NO 를 항상 채워주던 전제에 기댄 것이다.
 */
export const cancelTargets = (subRows: Row[]): { confirmIds: string[]; changeReqNos: string[] } => {
  const confirmIds: string[] = [];
  const changeReqNos: string[] = [];
  for (const row of subRows) {
    const changeReqNo = s(row.CHANGE_REQ_NO);
    if (!changeReqNo) continue;
    confirmIds.push(s(row.CONFIRM_ID));
    changeReqNos.push(changeReqNo);
  }
  return { confirmIds, changeReqNos };
};

/** AS-IS DeleteDataDrafting("C") 등가 — 하위 그리드 전 행의 변경요청 초안을 무효화한다. */
export const submitCancelDrafting = async (
  subRows: Row[],
  ctx: CancelContext
): Promise<CancelResult> => {
  const { confirmIds, changeReqNos } = cancelTargets(subRows);
  // AS-IS `if (iCount > 0)` — 대상이 없으면 호출하지 않는다.
  if (changeReqNos.length === 0) return { outcome: 'ok', nothingToSend: true };

  const payload = {
    confirmId: confirmIds.join(FOLD),
    changeRequestNo: changeReqNos.join(FOLD),
    delFlag: DEL_FLAG,
    lastUpdatedBy: ctx.userId,
    // call-proc 은 세션을 주입하지 않으므로 FE 가 싣는다(신규/수정 저장 경로와 같은 규약).
    timeZone: ctx.timeZone,
    ifSendFlag: ERP_IF_CHANGE_TYPES.includes(ctx.changeType) ? 'Y' : 'N',
    changeType: ctx.changeType,
  };

  try {
    const res = await apiClient.post<Record<string, unknown>>(
      `/${MENU_ID}/${SHEETS.MAIN}/${BTN_CANCEL}/call-proc`,
      payload
    );
    const outer = judgeSaveResponse(res);
    if (outer !== 'ok') return { outcome: outer, nothingToSend: false };
    // RESULT_CODE 는 이름으로 읽는다(위치 폴백 금지 — 부가열을 코드로 오인한다).
    const code = readResultCode(res.data);
    return { outcome: code === 'S' ? 'ok' : 'fail', nothingToSend: false };
  } catch (error) {
    return { outcome: judgeSaveError(error), nothingToSend: false };
  }
};
