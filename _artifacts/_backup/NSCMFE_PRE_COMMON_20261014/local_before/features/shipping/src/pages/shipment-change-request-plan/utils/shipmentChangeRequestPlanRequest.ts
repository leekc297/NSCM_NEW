// SSP0200 요청확정(Request Complete) / 요청취소(Cancel) 실행체인 payload 조립.
//
// 두 SP 모두 행 값을 '^' 로 이어받는 평면 문자열 계약이다(SaveButton 과 동일 구조) —
//   `useProcMutation`(행 배열 전송)으로는 전 파라미터가 NULL 로 바인딩된다
//   (메모리 scp-clob-save-needs-flat-caret-payload). 그래서 수동 조립 + apiClient.post 다.
//
// 파라미터명은 SCM_ADM_PROC_M.COL_NM 실측(2026-09-27 ora.py) camelCase 그대로다.
//   COMPLETE = PKG_SSP0200.P_SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE (IN 45 + 커서 2 = 47행)
//   CANCEL   = PKG_SSP0200.P_SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING (IN 7 + 커서 2 = 9행)
//   주의: SP 실명 오타 `newDContry`/`origionToDivisionId` 를 그대로 보낸다 — 고치면 NULL 바인딩된다.
//
// 행→인자 대응은 AS-IS 정본 cs:2318~2560(SaveDataDrafting) / cs:2573~2672(DeleteDataDrafting) 실측이다.
//   원천 그리드는 **spdSub(detail)** 이다 — master 가 아니다(AS-IS 가 siSub 만 순회한다).

import { apiClient } from '@foundation/apis';

import {
  CHANGE_TYPE_NEW,
  CHANGE_TYPE_PLAN,
  COLUMN,
  DELETE_FLAG,
  MENU_ID,
  NEW_YN_ON,
  RESULT_PARTIAL,
  RESULT_SUCCESS,
  SHEETS,
} from '../shipment-change-request-plan.constants';
import type { RequestInfo } from '../shipment-change-request-plan.types';

import { str, type GridRowData } from './shipmentChangeRequestPlanDerive';

export interface RequestChainSession {
  userId: string;
  /** TO-BE UserSession 에 타임존 필드가 없다(실측) — 빈 값으로 보내 SP 기본 처리에 맡긴다. */
  timeZone: string;
  /** AS-IS `UserInfoContext.Current["NowGroupID"]` = p_auth(45번). */
  groupId: string;
}

export interface RequestChainResult {
  /** 통신·false-success 판정. false 면 code 를 신뢰할 수 없다. */
  ok: boolean;
  /** SP 1커서 1행 1열 — 'S' 성공 / 'X' 부분성공 / 그 외 실패. */
  code: string;
  /** 성공 시 채번된 변경요청번호(1행 2열). */
  requestNo: string;
  /** 실패 시 2커서 1행 1열 원문('Unauthorized'/'UnModelPic'/'UnModelItem' 판정용) 또는 HTTP 오류. */
  reason: string;
}

/** 날짜 인자 8자리 통일 — SaveButton 경로와 같은 근거(PKG 본문이 8자리 VARCHAR 와 직접 비교). */
const ymd8 = (v: unknown): string => str(v).replace(/\D/g, '').slice(0, 8);

/** 수량은 소수 3자리로 반올림해 보낸다(AS-IS cs:2428 `Math.Round(d_value, 3)`). 빈 값은 빈 값. */
const qty3 = (v: unknown): string => {
  const raw = str(v).trim();
  if (raw === '') return '';
  const num = Number(raw);
  return Number.isFinite(num) ? String(Math.round(num * 1000) / 1000) : raw;
};

// 행 단위로 '^' 결합되는 42개 인자 ← detail 행 컬럼 대응(AS-IS cs:2397~2445).
//   값 변환이 없는 인자만 여기 둔다.
const ROW_PARAM_SOURCE: Record<string, string> = {
  divisionId: COLUMN.DIVISION_ID,
  fromSite: COLUMN.FROM_SITE,
  confirmId: COLUMN.CONFIRM_ID,
  changeReqNo: COLUMN.CHANGE_REQ_NO,
  newBodId: COLUMN.NEW_BOD_ID,
  newRouteId: COLUMN.NEW_ROUTE_ID,
  newIncoterms: COLUMN.INCOTERMS,
  newDContry: COLUMN.NEW_D_COUNTRY, // SP 실명 오타 유지
  newDPortCode: COLUMN.NEW_D_PORT_CODE,
  newACountry: COLUMN.NEW_A_COUNTRY,
  newAPortCode: COLUMN.NEW_A_PORT_CODE,
  newToCountry: COLUMN.NEW_TO_COUNTRY,
  newToCity: COLUMN.NEW_TO_CITY,
  newLtDay: COLUMN.NEW_LT_DAY,
  newTransportMode: COLUMN.NEW_TRANSPORT_MODE,
  planConfirmId: COLUMN.PLAN_CONFIRM_ID,
  electrodeYn: COLUMN.ELECTRODE_YN,
  electrodeType: COLUMN.ELECTRODE_TYPE,
  originFromDivisionId: COLUMN.ORIGIN_FROM_DIVISION_ID,
  origionToDivisionId: COLUMN.ORIGIN_TO_DIVISION_ID, // SP 실명 오타 유지
  remarks: COLUMN.REMARKS,
  remarks2: COLUMN.REMARKS2,
  remarks3: COLUMN.REMARKS3,
};

const ROW_DATE_PARAM_SOURCE: Record<string, string> = {
  newEtdDate: COLUMN.NEW_ETD,
  newEtaDate: COLUMN.NEW_ETA,
  newShipDate: COLUMN.NEW_SHIPMENT_DATE,
};

interface CompleteContext {
  requestInfo: RequestInfo;
  changeType: string;
  /** sChangeStatus(cs:3316) — 요청확정은 'Q'. */
  changeStatus: string;
  /** sShipStatus(cs:3317) — 요청확정은 'R'. 완료 안내 노출 판정에도 쓰인다. */
  shipStatus: string;
  /** bErpIFCheck — 요청확정 경로는 false(cs:3318) -> 'N'. */
  ifSendFlag: string;
  session: RequestChainSession;
}

/**
 * 요청확정 45 IN payload. 행 단위 인자는 '^' 결합, 요청정보·세션 인자는 스칼라다.
 *   `mainConfirmId` 는 AS-IS 가 `p_confirm_id` 를 그대로 재사용한다(cs:2452) — 별도 원천이 아니다.
 *   `newConfirmId` 는 AS-IS 가 대입을 주석 처리해 항상 공백이다(cs:2379).
 */
export const buildRequestCompletePayload = (
  subRows: GridRowData[],
  { requestInfo, changeType, changeStatus, shipStatus, ifSendFlag, session }: CompleteContext
): Record<string, string> => {
  const acc: Record<string, string[]> = { newQty: [], newYn: [] };
  for (const key of Object.keys(ROW_PARAM_SOURCE)) acc[key] = [];
  for (const key of Object.keys(ROW_DATE_PARAM_SOURCE)) acc[key] = [];

  // ChangeType P/N 은 전 행 'Y' 고정, 그 외는 행의 NEW_YN 그대로(cs:2436~2439).
  const forcedNewYn = changeType === CHANGE_TYPE_PLAN || changeType === CHANGE_TYPE_NEW;

  for (const row of subRows) {
    for (const [param, column] of Object.entries(ROW_PARAM_SOURCE)) {
      acc[param].push(str(row[column]));
    }
    for (const [param, column] of Object.entries(ROW_DATE_PARAM_SOURCE)) {
      acc[param].push(ymd8(row[column]));
    }
    acc.newQty.push(qty3(row[COLUMN.NEW_SHIPMENT_CONFIRM_QTY]));
    acc.newYn.push(forcedNewYn ? NEW_YN_ON : str(row[COLUMN.NEW_YN]));
  }

  const payload: Record<string, string> = {};
  for (const [key, values] of Object.entries(acc)) payload[key] = values.join('^');
  payload.mainConfirmId = payload.confirmId; // cs:2452
  payload.newConfirmId = ''; // cs:2379 — AS-IS 대입이 주석이라 항상 공백

  // 요청정보 폼 + 세션 스칼라(cs:2330~2345 / 2536~2548).
  payload.title = requestInfo.title;
  payload.requestId = session.userId;
  payload.requestDeptId = requestInfo.requestDeptId;
  payload.approvalId = requestInfo.approvalId;
  payload.approvalDeptId = requestInfo.appDeptId;
  payload.changeReason = requestInfo.changeReason;
  payload.reasonDetail = requestInfo.reasonDetail;
  payload.lastUpdatedBy = session.userId; // 감사키 빈문자열 금지 — /call-proc 은 세션을 주입하지 않는다
  payload.changeStatus = changeStatus;
  payload.shipStatus = shipStatus;
  payload.timeZone = session.timeZone;
  payload.ifSendFlag = ifSendFlag;
  payload.changeType = changeType;
  payload.requestor = session.userId; // cs:2374 p_requestor = sRequestID
  payload.auth = session.groupId;
  return payload;
};

interface CancelContext {
  changeType: string;
  /** bErpIFCheck — ChangeType C/N 취소는 true(cs:3452) -> 'Y'. */
  ifSendFlag: string;
  session: RequestChainSession;
}

/**
 * 요청취소 7 IN payload (DeleteDataDrafting("C") — 체크 무관 전 행 대상, cs:2605~2609).
 *   `delFlag` 는 호출 플래그가 'C' 여도 SP 에는 'D' 를 보낸다(cs:2632 하드코딩).
 */
export const buildCancelDraftingPayload = (
  subRows: GridRowData[],
  { changeType, ifSendFlag, session }: CancelContext
): Record<string, string> => {
  const confirmIds: string[] = [];
  const changeRequestNos: string[] = [];
  for (const row of subRows) {
    confirmIds.push(str(row[COLUMN.CONFIRM_ID]));
    changeRequestNos.push(str(row[COLUMN.CHANGE_REQ_NO]));
  }
  return {
    confirmId: confirmIds.join('^'),
    changeRequestNo: changeRequestNos.join('^'),
    delFlag: DELETE_FLAG,
    lastUpdatedBy: session.userId,
    timeZone: session.timeZone,
    ifSendFlag,
    changeType,
  };
};

type ProcResult = Record<string, Record<string, unknown>[] | undefined>;

/** 커서 1행의 n번째 열을 순서로 읽는다 — 커서 별칭이 SP 마다 달라 키 이름에 의존하지 않는다. */
const cell = (row: Record<string, unknown> | undefined, index: number): string =>
  row ? str(Object.values(row)[index]) : '';

/**
 * 오류 커서에서 사유 문자열을 집는다.
 *   PKG_SSP0200.P_OPEN_ERROR 본문 실측(ALL_SOURCE 155~158):
 *   `SELECT '-1' AS CODE, P_MESSAGE AS MSG FROM DUAL` — **0번 열은 항상 '-1'** 이다.
 *   0번을 읽으면 Unauthorized/UnModelPic/UnModelItem 분기가 영구 미도달이 된다(2026-09-28 교정).
 *   BE 별칭이 바뀌어도 살아 있도록 MSG 키를 먼저 보고, 없으면 2번째 열로 떨어진다.
 */
const errorReason = (row: Record<string, unknown> | undefined): string => {
  if (!row) return '';
  const byKey = str(row.MSG ?? row.msg);
  return byKey || cell(row, 1);
};

/**
 * 공통 실행 — false-success 판정 의무(nscm-patterns §5-10).
 *   인터셉터가 500/403 도 resolve 하므로 status/code 분기 없이는 실패가 성공으로 새어 나간다.
 *   2커서(`O_RESULT_CURSOR`)는 BE 별칭이 SP 마다 달라 o_rc1 이 아닌 첫 커서를 원문으로 집는다.
 */
const submit = async (
  buttonCode: string,
  payload: Record<string, string>
): Promise<RequestChainResult> => {
  try {
    const res = await apiClient.post<ProcResult>(
      `/${MENU_ID}/${SHEETS.MAIN}/${buttonCode}/call-proc`,
      payload
    );
    if (res.status >= 400 || Number(res.data?.code)) {
      return {
        ok: false,
        code: '',
        requestNo: '',
        reason: str((res.data as { message?: string })?.message),
      };
    }
    const result = res.data.result ?? {};
    const first = result.o_rc1?.[0];
    const code = cell(first, 0);
    let reason = '';
    if (code !== RESULT_SUCCESS) {
      const other = Object.entries(result).find(([key, rows]) => key !== 'o_rc1' && !!rows?.length);
      reason = errorReason(other?.[1]?.[0]);
    }
    return { ok: true, code, requestNo: cell(first, 1), reason };
  } catch (e) {
    return { ok: false, code: '', requestNo: '', reason: e instanceof Error ? e.message : '' };
  }
};

export const submitRequestComplete = (
  buttonCode: string,
  payload: Record<string, string>
): Promise<RequestChainResult> => submit(buttonCode, payload);

export const submitCancelDrafting = (
  buttonCode: string,
  payload: Record<string, string>
): Promise<RequestChainResult> => submit(buttonCode, payload);

/** 재조회만 하고 오류로 보지 않는 코드(AS-IS cs:2654 `== "X"` 분기). */
export const isRefetchOnlyResult = (code: string): boolean => code === RESULT_PARTIAL;
