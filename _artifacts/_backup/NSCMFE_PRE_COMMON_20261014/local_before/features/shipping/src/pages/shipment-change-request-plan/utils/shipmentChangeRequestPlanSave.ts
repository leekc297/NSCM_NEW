// SSP0200 SaveButton 저장 — PKG_SSP0200.P_SSP0200_SAVE_SHIPMENT_CONFIRM_NEW(31 IN) payload 조립.
//
// 이 SP 는 31개 IN 인자가 전부 **CLOB 평면 문자열**이고 행들을 '^' 로 이어 받는다
//   (ALL_ARGUMENTS 실측: P_ACTIVE_FLAG~P_ERP_ATTR3 CLOB, P_USER_ID/P_TIME_ZONE 만 VARCHAR2.
//    PKG 본문 주석 "저장 계열의 '^' 구분 문자열 분리 규칙은 SCM_ARR_SPL_CNT·SCM_ARR_SPL_VAL 과 같다").
//   그래서 `useProcMutation`(행 배열 전송)으로는 바인딩되지 않는다 — BaseService 는 `params.get(COL_NM)`
//   으로 파라미터를 찾는데 행 키는 UPPER_SNAKE 라 31개 전건 NULL 이 되고, 성공 토스트만 뜬다
//   (메모리 scp-clob-save-needs-flat-caret-payload / procedures-dts-save-request-never-typechecked).
//   정본 패턴 = features/supply/.../projectRoute.plantSaveRequest.ts.
//
// 파라미터명은 SCM_ADM_PROC_M.COL_NM 실측(camelCase) 그대로다 — **오타 `aConuntry` 도 그대로 보낸다**.
//   맞춤법을 고치면 그 인자가 NULL 로 바인딩된다(design 03 §4.4).
// 행→인자 대응은 AS-IS 정본 cs:1010~1030(SaveButton) 실측이다. 추측 없음.

import { apiClient } from '@foundation/apis';

import { COLUMN, CRUD_INSERT, MENU_ID, SHEETS } from '../shipment-change-request-plan.constants';

import { str, type GridRowData } from './shipmentChangeRequestPlanDerive';

export interface SaveResult {
  /** SP o_rc1 1행 1열 — 'S' 성공 / 'N' Model 미조회 / 'F' 저장실패 / 'X' SoldTo·ShipTo 오류. */
  code: 'S' | 'N' | 'F' | 'X' | '';
  /** 'X' 경로의 상세(reason_id + division_id + to_site) 또는 HTTP/BE 오류 문구. */
  message: string;
  /** 통신·false-success 판정 결과. false 면 code 는 신뢰할 수 없다. */
  ok: boolean;
}

interface SaveSession {
  userId: string;
  /** TO-BE UserSession 에 타임존 필드가 없다(실측) — 빈 값으로 보내 SP 기본 처리에 맡긴다. */
  timeZone: string;
}

// 날짜 인자는 8자리 숫자로 보낸다.
//   근거: 이관된 SP 가 토큰을 8자리 VARCHAR 칼럼과 직접 비교한다
//   (PKG_SSP0200 본문 2182~2183 `A.FROM_YYYYMMDD <= V_SHIPMENT_DATE` / SCP_MST_BOD_N_V 실측 '20220411').
//   AS-IS 는 'yyyy-MM-dd HH:mm:ss.fff' 를 보냈지만(MSSQL 은 datetime 변환) 그 문자열을 그대로 보내면
//   하이픈 때문에 범위 비교가 전건 참이 되어 BOD 가 조용히 잘못 잡힌다 — 차이와 근거를 04 에 기록했다.
const ymd8 = (v: unknown): string => str(v).replace(/\D/g, '').slice(0, 8);

// 31 IN 인자 ← 행 컬럼 대응(AS-IS cs:1010~1030). 값 그대로 보내는 인자만 여기 둔다.
const PLAIN_PARAM_SOURCE: Record<string, string> = {
  divisionId: COLUMN.DIVISION_ID,
  fromSite: COLUMN.FROM_SITE_DESCRIPTION, // GetValue = 코드값(SCM_SITE_ID)
  toSite: COLUMN.TO_SITE_DESCRIPTION,
  projectCode40: COLUMN.END_CUSTOMER, // 주의: projectCode 와 별개 인자다(div40 분기)
  projectCode: COLUMN.PROJECT_CODE,
  fcstType: COLUMN.FCST_TYPE,
  itemId: COLUMN.ITEM_ID,
  shipmentQty: COLUMN.SHIPMENT_CONFIRM_QTY,
  incoterms: COLUMN.INCOTERMS,
  transportMode: COLUMN.TRANSPORT_MODE,
  lt: COLUMN.NEW_CUSTOMER_LT,
  routeId: COLUMN.NEW_ROUTE_ID,
  bodId: COLUMN.NEW_BOD_ID,
  dCountry: COLUMN.NEW_D_COUNTRY,
  dPortCode: COLUMN.NEW_D_PORT_CODE,
  aConuntry: COLUMN.NEW_A_COUNTRY, // SP 실명 오타 유지
  aPortCode: COLUMN.NEW_A_PORT_CODE,
  toCountry: COLUMN.NEW_TO_COUNTRY,
  toCity: COLUMN.NEW_TO_CITY,
  remarks: COLUMN.REMARKS,
  remarks2: COLUMN.REMARKS2,
  remarks3: COLUMN.REMARKS3,
  erpAttr1: COLUMN.ERP_ATTR1,
  erpAttr2: COLUMN.ERP_ATTR2,
  erpAttr3: COLUMN.ERP_ATTR3,
};

const DATE_PARAM_SOURCE: Record<string, string> = {
  shipmentDate: COLUMN.SHIPMENT_DATE,
  etd: COLUMN.NEW_ETD,
  eta: COLUMN.NEW_ETA,
};

/** SaveButton 대상 행 = `CRUD_TYPE='I'` 만이다(AS-IS cs:1005 `if (action != FlagI) continue`). */
export const saveTargetRows = (rows: GridRowData[]): GridRowData[] =>
  rows.filter(r => str(r.CRUD_TYPE) === CRUD_INSERT);

export const buildConfirmNewPayload = (
  targets: GridRowData[],
  session: SaveSession
): Record<string, string> => {
  const acc: Record<string, string[]> = { activeFlag: [] };
  for (const key of Object.keys(PLAIN_PARAM_SOURCE)) acc[key] = [];
  for (const key of Object.keys(DATE_PARAM_SOURCE)) acc[key] = [];

  for (const row of targets) {
    acc.activeFlag.push(CRUD_INSERT);
    for (const [param, column] of Object.entries(PLAIN_PARAM_SOURCE)) {
      acc[param].push(str(row[column]));
    }
    for (const [param, column] of Object.entries(DATE_PARAM_SOURCE)) {
      acc[param].push(ymd8(row[column]));
    }
  }

  const payload: Record<string, string> = {};
  for (const [key, values] of Object.entries(acc)) payload[key] = values.join('^');
  // 감사·세션 인자는 행 단위가 아니라 스칼라다(PROC_M 27·28번 = VARCHAR2).
  //   /call-proc 은 세션을 주입하지 않으므로 FE 가 반드시 실어야 한다
  //   (메모리 call-proc-does-not-inject-session-only-call-proc2). 빈 문자열 감사키 금지.
  payload.userId = session.userId;
  payload.timeZone = session.timeZone;
  return payload;
};

/**
 * 저장 실행. 성공 판정은 **SP 반환코드까지** 본다 —
 *   HTTP 200 + `code:0` 이어도 o_rc1 의 첫 칸이 'S' 가 아니면 저장되지 않았다(AS-IS cs:1107~1130).
 *   인터셉터가 500/403 도 resolve 하므로 status/code 분기가 없으면 실패가 성공 토스트로 새어 나간다.
 */
export const submitConfirmNewSave = async (
  targets: GridRowData[],
  session: SaveSession
): Promise<SaveResult> => {
  const payload = buildConfirmNewPayload(targets, session);
  try {
    const res = await apiClient.post<Record<string, Record<string, unknown>[]>>(
      `/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`,
      payload
    );
    if (res.status >= 400 || Number(res.data?.code)) {
      return { ok: false, code: '', message: str((res.data as { message?: string })?.message) };
    }
    const first = res.data.result?.o_rc1?.[0];
    const code = first ? str(Object.values(first)[0]) : '';
    if (code === 'X') {
      // SoldTo/ShipTo 코드 누락 상세(AS-IS cs:1140~1164 와 동일 필드).
      const reason = str(first?.reason_id ?? first?.REASON_ID);
      const division = str(first?.division_id ?? first?.DIVISION_ID);
      const site = str(first?.to_site ?? first?.TO_SITE);
      return {
        ok: true,
        code: 'X',
        message: reason ? `${reason} from ${division} - ${site}` : '',
      };
    }
    return { ok: true, code: (code as SaveResult['code']) || '', message: '' };
  } catch (e) {
    return { ok: false, code: '', message: e instanceof Error ? e.message : '' };
  }
};
