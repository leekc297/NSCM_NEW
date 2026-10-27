/**
 * SSP0202 승인/반려/자기반려 — **서버 저장 실행체인 + 사전체크 3종**.
 *
 * AS-IS: GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0202_ShipmentChangeRequestConfirm.cs
 *   `SaveData(sStatus)`(L756~964) / `chkSaveYN`(L1119~1175) / `EngProcessingChk`(L1081~1116) /
 *   `GetErpIFCheck`(L966~1036) / `BtnApproval_Click`(L1372~1413)
 *
 * **왜 이 파일이 생겼나(사용자 신고 2026-10-14 "승인했는데 정상처리 안 됨")**
 *   종전 TO-BE 는 공용 `useProcMutation` 으로 `mutateSave([payload])` 를 보냈다. 그 경로는 BE 가
 *   PROC_M 의 `JVARCHAR` 항목을 보고 행 배열을 인자로 펼치는데, 이 SP 의 PROC_M 에는 JVARCHAR 가
 *   **없다** → 인자가 치환되지 않아 BE 가 실제로 던진 SQL 이 이랬다(SCM_COM_SQL_LOG 실측 09:02:42):
 *     {call PKG_SSP0202.P_SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM( NULL, NULL, … NULL )}  -- 33개 전부 NULL
 *   SP 는 빈 입력으로 돌고 성공을 돌려줘 **성공 토스트만 뜨고 아무것도 저장되지 않았다**
 *   (자매 SSP0201 저장이 겪은 것과 같은 함정 — 그래서 거기도 apiClient.post 평탄 객체로 바꿨다).
 *   게다가 payload 가 7키뿐이고 키 이름도 계약과 달랐다(`confirmYn`≠`changeStatus`,
 *   `changeReqNo`≠`changeRequestNo`, `delegateYn`/`language` 는 파라미터에 없음).
 *
 * 전송 규약(ALL_ARGUMENTS 실측 2026-10-14):
 *   `P_SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM`      33 IN + 2 OUT
 *   `P_SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40`   34 IN + 2 OUT (**P_SHIPTO_CODE 추가**)
 *   VARCHAR 스칼라 8개(changeRequestNo·changeStatus·rejectReason·lastUpdatedBy·timeZone·changeType·
 *   delegatee·delegateeDept), 나머지는 **CLOB = 하위 그리드 행단위**다. SP 가 토큰 수로 루프를 도므로
 *   **전 CLOB 토큰 수가 같아야 한다** — 하나만 어긋나면 값이 행 경계를 넘어 밀린다. 빈 값도 자리를 지킨다.
 *
 * **ERP 인터페이스 웹서비스 호출은 이식하지 않는다(잔여, 사용자 지시 2026-10-14).**
 *   AS-IS 도 `CallClient.FN_ERP_UIWebService(...)`(L1000~1028)가 **전면 주석 처리** 상태다 —
 *   즉 미이식이 곧 AS-IS 패리티다. 여기서 구현하는 `IF_CHECK` 는 그 웹서비스가 아니라
 *   **DB 프로시저** `P_SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` 다(혼동 금지).
 */

import { apiClient } from '@foundation/apis';
import { safeString } from '@foundation/utils';

import {
  ACTION,
  FIXED_DIVISION,
  MENU_ID,
  SHEETS,
  SUB_COLUMN,
} from '../shipment-change-request-confirm.constants';

import {
  judgeSaveError,
  judgeSaveResponse,
  readResultCode,
  type SaveOutcome,
} from './shipmentChangeRequestConfirmResult';

type Row = Record<string, unknown>;

const s = (v: unknown): string => safeString(v).trim();

/** CLOB 인자의 행 구분자(AS-IS `CString.AppendString` 기본 구분자). */
const FOLD = '^';

/** 버튼 코드 — `SCM_ADM_MNU_BTN_MPG_M` 실측 등록분. */
export const BTN = {
  SAVE: 'SAVE',
  SAVE_40: 'SAVE_40',
  SCS_CHECK: 'SCS_CHECK',
  PLAN_CHECK: 'PLAN_CHECK',
  IF_CHECK: 'IF_CHECK',
} as const;

export interface ConfirmSaveContext {
  /** 마스터 선택행의 CHANGE_REQ_NO. */
  changeRequestNo: string;
  /** 'A' 승인 / 'R' 반려 / 'S' 자기반려. */
  action: ACTION;
  rejectReason: string;
  /** 마스터 선택행의 CHANGE_TYPE(`_sChangeType`). */
  changeType: string;
  userId: string;
  /** TO-BE UserSession 에 타임존 필드가 없다 — 빈 값(SP 보정). */
  timeZone: string;
  /** A7 위임 분기 — 위임자일 때만 값을 싣는다. */
  delegatee: string;
  delegateeDept: string;
}

export interface ConfirmSaveResult {
  outcome: SaveOutcome;
  /** 하위 행 0건 — AS-IS 는 버튼 진입에서 이미 막는다(여기서도 호출하지 않는다). */
  nothingToSend: boolean;
}

/**
 * 승인 payload — AS-IS `SaveData` L799~861 의 **승인(`sStatus=='A'`) 분기** 그대로.
 *
 *  - `confirmId` : **모든 행에 같은 값**을 넣는다. `NEW_BASE_CONFIRM_YN='Y'` 인 **첫 행의 CONFIRM_ID**
 *                  (`sBaseConfirmID`, L809~816). 행별 값이 아니다 — 베껴 쓰면 틀린다.
 *  - `newConfirmId` : 행의 **`CONFIRM_ID`** 다(L826). 이름에 속지 말 것 — `NEW_CONFIRM_ID` 컬럼이 아니고,
 *                  TO-BE 조회 응답에 `NEW_CONFIRM_ID` 키 자체가 없다(실측).
 *  - `newRouteId`: 행의 **`NEW_ROUTE`**(L842). `NEW_ROUTE_ID` 가 아니다.
 *  - `shipToCode`: AS-IS 가 `GetColumnIndex(NEW_SHIPMENT_DATE) + 2` 라는 **컬럼 인덱스 오프셋**으로 읽는다
 *                  (L858). 메타 실측으로 그 자리는 `NEW_SHIPTO_CODE`(SORT 20→22)다. 인덱스 의존은
 *                  컬럼 순서가 바뀌면 깨지므로 TO-BE 는 **이름으로** 읽는다.
 *  - `itemId`/`fromSite`/`yyyymmdd` : **0번 행 1건 스칼라**다(L804~806). `yyyymmdd` 는 YYYYMMDD 컬럼이
 *                  아니라 0번 행의 **`NEW_SHIPMENT_DATE`** 다(L806).
 *  - 행 제외 조건 없음 — `if (sNewYn == "N") continue;` 는 **주석**이다(L822). 전 행을 보낸다.
 */
const SUB_CLOB_KEYS = [
  ['divisionId', SUB_COLUMN.DIVISION_ID],
  ['newConfirmId', SUB_COLUMN.CONFIRM_ID], // 주의: 행의 CONFIRM_ID (L826)
  ['newEtdDate', SUB_COLUMN.NEW_ETD],
  ['newEtaDate', SUB_COLUMN.NEW_ETA],
  ['newShipDate', SUB_COLUMN.NEW_SHIPMENT_DATE],
  ['newYn', SUB_COLUMN.NEW_YN],
  ['newBodId', SUB_COLUMN.NEW_BOD_ID],
  ['newRouteId', SUB_COLUMN.NEW_ROUTE], // 주의: NEW_ROUTE (L842)
  ['newIncoterms', SUB_COLUMN.NEW_INCOTERMS],
  ['newDContry', SUB_COLUMN.NEW_D_COUNTRY],
  ['newDPortCode', SUB_COLUMN.NEW_D_PORT_CODE],
  ['newACountry', SUB_COLUMN.NEW_A_COUNTRY],
  ['newAPortCode', SUB_COLUMN.NEW_A_PORT_CODE],
  ['newToCountry', SUB_COLUMN.NEW_TO_COUNTRY],
  ['newToCity', SUB_COLUMN.NEW_TO_CITY],
  ['newLtDay', SUB_COLUMN.NEW_LT_DAY],
  ['newTransportMode', SUB_COLUMN.NEW_TRANSPORT_MODE],
  ['remarks', SUB_COLUMN.REMARKS],
  ['remarks2', SUB_COLUMN.REMARKS2],
  ['remarks3', SUB_COLUMN.REMARKS3],
  ['shipToCode', SUB_COLUMN.NEW_SHIPTO_CODE], // AS-IS 인덱스 +2 자리(L858)
] as const;

/** `NEW_BASE_CONFIRM_YN='Y'` 인 첫 행의 CONFIRM_ID(AS-IS sBaseConfirmID, L809~816). */
export const baseConfirmId = (subRows: Row[]): string => {
  const base = subRows.find(r => s(r[SUB_COLUMN.NEW_BASE_CONFIRM_YN]) === 'Y');
  return base ? s(base[SUB_COLUMN.CONFIRM_ID]) : '';
};

export const buildConfirmPayload = (
  subRows: Row[],
  ctx: ConfirmSaveContext
): Record<string, string> => {
  const payload: Record<string, string> = {};

  if (ctx.action === ACTION.APPROVAL) {
    const acc: Record<string, string[]> = { confirmId: [], newQty: [] };
    for (const [key] of SUB_CLOB_KEYS) acc[key] = [];

    const base = baseConfirmId(subRows);
    for (const row of subRows) {
      acc.confirmId.push(base); // 전 행 동일값(L825)
      for (const [key, col] of SUB_CLOB_KEYS) acc[key].push(s(row[col]));
      //   수량은 정수로 보낸다(AS-IS Convert.ToInt64, L835). 빈 값은 빈 토큰 — 자리는 지킨다.
      const qty = s(row[SUB_COLUMN.NEW_SHIPMENT_CONFIRM_QTY]);
      acc.newQty.push(qty === '' ? '' : String(Math.trunc(Number(qty) || 0)));
    }
    for (const [key, values] of Object.entries(acc)) payload[key] = values.join(FOLD);

    //   0번 행 스칼라 3종(L804~806) — yyyymmdd 는 NEW_SHIPMENT_DATE 다.
    const first = subRows[0] ?? {};
    payload.itemId = s(first[SUB_COLUMN.ITEM_ID]);
    payload.fromSite = s(first[SUB_COLUMN.FROM_SITE]);
    payload.yyyymmdd = s(first[SUB_COLUMN.NEW_SHIPMENT_DATE]);
  } else {
    //   반려/자기반려는 **divisionId 만** 0번 행에서 읽고 나머지 CLOB 은 비운다(AS-IS L864~867 else).
    payload.divisionId = s((subRows[0] ?? {})[SUB_COLUMN.DIVISION_ID]);
    payload.itemId = '';
    payload.fromSite = '';
    payload.yyyymmdd = '';
    payload.confirmId = '';
    payload.newQty = '';
    for (const [key] of SUB_CLOB_KEYS) if (key !== 'divisionId') payload[key] = '';
  }

  // ── VARCHAR 스칼라 ── call-proc 은 세션을 주입하지 않으므로 FE 가 전부 싣는다.
  payload.changeRequestNo = ctx.changeRequestNo;
  payload.changeStatus = ctx.action;
  payload.rejectReason = ctx.action === ACTION.APPROVAL ? '' : ctx.rejectReason;
  payload.lastUpdatedBy = ctx.userId;
  payload.timeZone = ctx.timeZone;
  payload.changeType = ctx.changeType;
  payload.delegatee = ctx.delegatee;
  payload.delegateeDept = ctx.delegateeDept;
  return payload;
};

/**
 * 저장 실행. AS-IS L867~874: `p_division_id.Substring(0,2) == "40"` 이면 `_40` SP 를 탄다.
 *   `_40` 쪽만 `P_SHIPTO_CODE`(34번)를 받으므로 **버튼코드와 payload 가 짝**이어야 한다.
 *   SSP0202 는 Division '40' 고정(C1)이라 실질적으로 항상 `_40` 이지만, 분기는 AS-IS 대로 둔다.
 */
export const submitConfirmSave = async (
  subRows: Row[],
  ctx: ConfirmSaveContext
): Promise<ConfirmSaveResult> => {
  if (subRows.length === 0) return { outcome: 'ok', nothingToSend: true };

  const payload = buildConfirmPayload(subRows, ctx);
  const isDiv40 = payload.divisionId.slice(0, 2) === FIXED_DIVISION;
  //   기본 SP 는 shipToCode 인자가 없다 — 보내면 BE 가 모르는 키라 무시되지만, 계약을 흐리지 않게 뺀다.
  if (!isDiv40) delete payload.shipToCode;

  try {
    const res = await apiClient.post<Record<string, unknown>>(
      `/${MENU_ID}/${SHEETS.MAIN}/${isDiv40 ? BTN.SAVE_40 : BTN.SAVE}/call-proc`,
      payload
    );
    const outer = judgeSaveResponse(res);
    if (outer !== 'ok') return { outcome: outer, nothingToSend: false };
    const code = readResultCode(res.data);
    return { outcome: code === 'S' ? 'ok' : 'fail', nothingToSend: false };
  } catch (error) {
    return { outcome: judgeSaveError(error), nothingToSend: false };
  }
};
