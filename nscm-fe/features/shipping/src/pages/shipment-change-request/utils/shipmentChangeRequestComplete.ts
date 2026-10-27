/**
 * SSP0201 변경요청 완료(btnChangeRe2) — **서버 저장 실행체인**.
 *
 * AS-IS: GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0201_ShipmentChangeRequest.cs
 *   `BtnChangeRe_Click`(L2801~) 사전검증 통과 후
 *     L2898~2899  sChangeStatus = 'Q'(Requested) / sShipStatus = 'R'(Request Complete)
 *     L2142~2205  하위 그리드 **전 행**을 `^` 로 접어 28개 CLOB 조립
 *     L2220~2281  SP `SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` 호출(45 IN)
 *     L2284~2300  RESULT='S' -> txtRequestNo = 반환 변경요청번호
 *                               sShipStatus=='R' 이면 MSG00173 + ClearRequestInfo() + InitSpread(siSub)
 *                               FindButton()(재조회)
 *
 *   **종전 TO-BE 는 이 SP 를 아예 호출하지 않았다** — 사전검증만 돌고 성공 토스트를 띄웠다
 *   ("완료 mutate 배선은 convert-sp 배포 후" 주석 상태). 그래서 저장도, 하위 그리드 초기화도
 *   일어나지 않았다(사용자 신고 2026-10-13 "Request Complete 가 동작했지만 아래 그리드가 초기화되지 않았다").
 *   DB 로그로 확인: `SCM_SYS_LOG_BATCH` 에 `SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE` 실행 흔적 0건.
 *
 * 전송 규약(PROC_M 실측 2026-10-13 — 45 IN + 2 OUT):
 *   VARCHAR 스칼라 14개 — title·requestId·requestDeptId·approvalId·approvalDeptId·changeReason·
 *     reasonDetail·lastUpdatedBy·changeStatus·shipStatus·timeZone·ifSendFlag·changeType·requestor·auth
 *   나머지 31개가 CLOB = **행 단위**다. SP 가 토큰 수로 루프를 돌므로 **전 CLOB 의 토큰 수가 같아야
 *   한다** — 한 인자만 어긋나면 값이 행 경계를 넘어 밀려 엉뚱한 확정행이 요청완료된다.
 *   빈 값도 자리를 지켜 join 한다(그래서 `?? ''` 가 아니라 항상 push).
 */

import { apiClient } from '@foundation/apis';

import { MENU_ID, SHEETS } from '../shipment-change-request.constants';
import type { RequestInfo } from '../shipment-change-request.types';

import { FOLD, s, toSpDateTime } from './shipmentChangeRequestNewSave';
import {
  judgeSaveError,
  judgeSaveResponse,
  readResultCode,
  type SaveOutcome,
} from './shipmentChangeRequestResult';

type Row = Record<string, unknown>;

/** API_M `SSP0201_main_COMPLETE` 가 아니라 **`P_SSP0201_COMPLETE`** 가 등록돼 있다(ora.py 실측).
 *    버튼코드는 `29_register_complete_btn_auth.sql` 이 `COMPLETE` 로 매핑한다. */
export const BTN_COMPLETE = 'COMPLETE';

/** AS-IS L2898~2899 — 완료 시 고정값. */
const CHANGE_STATUS_REQUESTED = 'Q';
const SHIP_STATUS_REQUEST_COMPLETE = 'R';

/** ERP 전송 플래그 — AS-IS `bErpIFCheck`(changeType C/N 에서 true). 취소 경로와 같은 규칙이다. */
const ERP_IF_CHANGE_TYPES: readonly string[] = ['C', 'N'];

export interface CompleteContext {
  requestInfo: RequestInfo;
  changeType: string;
  userId: string;
  /** TO-BE UserSession 에 타임존 필드가 없다 — 빈 값(SP 가 보정). */
  timeZone: string;
  /** AS-IS `UserInfoContext.Current["NowGroupID"]` = p_auth(45번). */
  groupId: string;
}

export interface CompleteResult {
  outcome: SaveOutcome;
  /** 보낼 하위 행이 없었다(AS-IS `if (iCount > 0)`). 서버 호출을 하지 않았다. */
  nothingToSend: boolean;
  /** 날짜로 해석되지 않는 NEW_SHIPMENT_DATE 가 있었다(AS-IS MSG00049 차단, L2152~2156). */
  invalidDate?: string;
  /** SP 가 돌려준 변경요청번호(AS-IS txtRequestNo). */
  changeReqNo?: string;
  /** 실패 분기 식별 — AS-IS L2305~2320 의 Unauthorized / UnModelPic / UnModelItem. */
  failKind?: 'unauthorized' | 'modelPic' | 'modelItem' | 'unknown';
}

/** 하위 그리드 1행 -> CLOB 28열의 한 토큰씩. 키 순서는 payload 조립과 1:1이다. */
const SUB_CLOB_KEYS = [
  ['divisionId', 'DIVISION_ID'],
  ['fromSite', 'FROM_SITE'],
  ['changeReqNo', 'CHANGE_REQ_NO'],
  ['confirmId', 'CONFIRM_ID'],
  ['newBodId', 'NEW_BOD_ID'],
  ['newRouteId', 'NEW_ROUTE_ID'],
  ['newIncoterms', 'NEW_INCOTERMS'],
  ['newDContry', 'NEW_D_COUNTRY'],
  ['newDPortCode', 'NEW_D_PORT_CODE'],
  ['newACountry', 'NEW_A_COUNTRY'],
  ['newAPortCode', 'NEW_A_PORT_CODE'],
  ['newToCountry', 'NEW_TO_COUNTRY'],
  ['newToCity', 'NEW_TO_CITY'],
  ['newEtdDate', 'NEW_ETD'],
  ['newEtaDate', 'NEW_ETA'],
  ['newLtDay', 'NEW_LT_DAY'],
  ['newTransportMode', 'NEW_TRANSPORT_MODE'],
  ['planConfirmId', 'PLAN_CONFIRM_ID'],
  ['electrodeYn', 'ELECTRODE_YN'],
  ['electrodeType', 'ELECTRODE_TYPE'],
  ['originFromDivisionId', 'ORIGIN_FROM_DIVISION_ID'],
  ['origionToDivisionId', 'ORIGIN_TO_DIVISION_ID'],
  ['remarks', 'REMARKS'],
  ['remarks2', 'REMARKS2'],
  ['remarks3', 'REMARKS3'],
] as const;

/**
 * 실패 사유를 AS-IS 분기로 번역한다(L2305~2320).
 *   SP 는 `RAISE_APPLICATION_ERROR(-20001, '<사유>')` 로 던지고, 그 문자열이
 *   `o_result_cursor` 의 MSG(`ORA-20001: Unauthorized`)로 온다.
 *
 *   **응답·예외 어느 경로로 와도 같은 분류기를 태운다.** 종전엔 봉투 code 가 실패(-1)면
 *   본문을 보지도 않고 `'unknown'` 으로 접어 "저장 실패" 한 줄만 띄웠다 — SP 가 사유를 정확히
 *   돌려주는데도 사용자는 왜 막혔는지 알 수 없었다(사용자 신고 2026-10-13).
 *   인터셉터는 DB 오류행을 `new Error(MSG, { cause: resultRow })` 로 던지므로 message·cause 도 본다.
 */
const classifyFail = (...sources: unknown[]): CompleteResult['failKind'] => {
  const raw = sources
    .map(src => {
      if (src instanceof Error) return `${src.message} ${JSON.stringify(src.cause ?? '')}`;
      try {
        return JSON.stringify(src ?? '');
      } catch {
        return '';
      }
    })
    .join(' ');
  if (raw.includes('Unauthorized')) return 'unauthorized';
  if (raw.includes('UnModelPic')) return 'modelPic';
  if (raw.includes('UnModelItem')) return 'modelItem';
  return 'unknown';
};

/**
 * `p_auth`(45번) — AS-IS `UserInfoContext.Current["NowGroupID"]`.
 *
 *   SP 가드(PKG BODY L3024~3029): 요청자==승인자(자가 승인)인데 모델 담당자도 아니면
 *   `UPPER(NVL(P_AUTH,'#')) NOT IN ('ADMIN','SCM PI ADMIN')` 일 때 `Unauthorized` 를 던진다.
 *   즉 **이 값이 비면 ADMIN 사용자도 자가 승인이 막힌다** — 실제로 그렇게 막혔다(2026-10-13).
 *
 *   TO-BE `session.groupId` 는 비어 있는 계정이 많다(실측). 그룹 판정의 정본은
 *   `session.groups`(USER_GR_NM 배열, BE User.xml retrieveUserGroups)이고 다른 화면들도 그걸 쓴다
 *   (master/sales-site-project-model, supply/plan-control).
 *   -> groupId 가 있으면 그대로, 없으면 **SP 가 인정하는 그룹을 보유했을 때 그 이름**을 보낸다.
 *      보유하지 않은 그룹을 지어내지 않는다(권한 상승 아님 — 실제 보유 그룹만 보고한다).
 */
const SP_PRIVILEGED_GROUPS = ['ADMIN', 'SCM PI Admin'] as const;

export const resolveAuthGroup = (groupId: string, groups: readonly string[] = []): string => {
  if (groupId) return groupId;
  const privileged = groups.find(g =>
    SP_PRIVILEGED_GROUPS.some(p => p.toUpperCase() === g.toUpperCase())
  );
  return privileged ?? groups[0] ?? '';
};

export const submitRequestComplete = async (
  subRows: Row[],
  ctx: CompleteContext
): Promise<CompleteResult> => {
  if (subRows.length === 0) return { outcome: 'ok', nothingToSend: true };

  const acc: Record<string, string[]> = {};
  for (const [key] of SUB_CLOB_KEYS) acc[key] = [];
  acc.newShipDate = [];
  acc.newQty = [];
  acc.newYn = [];

  // changeType 'P'/'N' 이면 newYn 을 'Y' 로 강제한다(AS-IS L2193~2196).
  const forceNewYn = ctx.changeType === 'P' || ctx.changeType === 'N';

  for (const row of subRows) {
    // AS-IS 는 날짜 파싱 실패를 MSG00049 로 **차단**한다(조용히 넘기지 않는다, L2152~2156).
    const shipDate = toSpDateTime(row.NEW_SHIPMENT_DATE);
    if (!shipDate) {
      return { outcome: 'fail', nothingToSend: false, invalidDate: s(row.NEW_SHIPMENT_DATE) };
    }
    for (const [key, col] of SUB_CLOB_KEYS) acc[key].push(s(row[col]));
    acc.newShipDate.push(shipDate);
    //   수량은 정수로 보낸다(AS-IS `Convert.ToInt64`, L2187). 빈 값은 빈 토큰 그대로 — 자리는 지킨다.
    const qty = s(row.NEW_SHIPMENT_CONFIRM_QTY);
    acc.newQty.push(qty === '' ? '' : String(Math.trunc(Number(qty) || 0)));
    acc.newYn.push(forceNewYn ? 'Y' : s(row.NEW_YN));
  }

  const payload: Record<string, string> = {};
  for (const [key, values] of Object.entries(acc)) payload[key] = values.join(FOLD);

  //   AS-IS L2282: p_main_confirm_id = p_confirm_id (같은 값을 두 인자로 보낸다).
  payload.mainConfirmId = payload.confirmId;
  //   AS-IS 는 p_new_confirm_id 대입이 **주석**이라 항상 빈 값이다(L2139~2140). 자리만 채운다.
  payload.newConfirmId = '';

  // ── VARCHAR 스칼라 14개 — call-proc 은 세션을 주입하지 않으므로 FE 가 전부 싣는다 ──
  payload.title = ctx.requestInfo.title;
  payload.requestId = ctx.userId;
  payload.requestDeptId = ctx.requestInfo.requestDeptId;
  payload.approvalId = ctx.requestInfo.approvalId;
  payload.approvalDeptId = ctx.requestInfo.appDeptId;
  payload.changeReason = ctx.requestInfo.changeReason;
  payload.reasonDetail = ctx.requestInfo.reasonDetail;
  payload.lastUpdatedBy = ctx.userId;
  payload.changeStatus = CHANGE_STATUS_REQUESTED;
  payload.shipStatus = SHIP_STATUS_REQUEST_COMPLETE;
  payload.timeZone = ctx.timeZone;
  payload.ifSendFlag = ERP_IF_CHANGE_TYPES.includes(ctx.changeType) ? 'Y' : 'N';
  payload.changeType = ctx.changeType;
  payload.requestor = ctx.userId; // AS-IS p_requestor = sRequestID(요청자 ID)
  payload.auth = ctx.groupId;

  try {
    const res = await apiClient.post<Record<string, unknown>>(
      `/${MENU_ID}/${SHEETS.MAIN}/${BTN_COMPLETE}/call-proc`,
      payload
    );
    const outer = judgeSaveResponse(res);
    //   봉투가 실패여도 **본문을 분류한다** — SP 가 사유를 o_result_cursor 에 싣기 때문이다.
    if (outer !== 'ok') {
      return { outcome: outer, nothingToSend: false, failKind: classifyFail(res.data) };
    }

    const code = readResultCode(res.data);
    if (code !== 'S') {
      return { outcome: 'fail', nothingToSend: false, failKind: classifyFail(res.data) };
    }
    //   성공 커서 2번째 열이 변경요청번호다(AS-IS txtRequestNo = Rows[0][1], L2286).
    //   **열 이름은 `REQUEST_NO` 다** — 실측 응답 `[{"REQUEST_NO":"R20261013542760","RESULT_CODE":"S"}]`
    //   (SCM_COM_SQL_LOG, 2026-10-14 08:30:54). `CHANGE_REQ_NO` 로 읽으면 항상 빈 값이 된다.
    //   위치([1])로 읽지 않는 이유는 readResultCode 주석 참조(결과맵이 열 순서를 보장하지 않는다).
    const rows =
      (res.data as { result?: { o_rc1?: Row[] } } | undefined)?.result?.o_rc1 ?? ([] as Row[]);
    const first = rows[0] ?? {};
    return {
      outcome: 'ok',
      nothingToSend: false,
      changeReqNo: s(first.REQUEST_NO ?? first.request_no),
    };
  } catch (error) {
    //   인터셉터가 DB 오류행을 Error(message, { cause }) 로 던진다 — 거기서도 사유를 읽는다.
    return { outcome: judgeSaveError(error), nothingToSend: false, failKind: classifyFail(error) };
  }
};
