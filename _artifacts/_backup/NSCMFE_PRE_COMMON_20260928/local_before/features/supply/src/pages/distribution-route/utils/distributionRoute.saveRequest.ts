// SCP0005 Route 저장 — payload 조립 + POST + false-success 판별.
//   SAVE SP(PKG_SCP0005.P_SCP0005_SAVE_ROUTE)는 각 컬럼을 '^'-delim 배치 문자열(CLOB)로 받는다
//   (proc 본문 P_SPLIT(P_x,'^',...)). BE execBtn 은 CLOB 파라미터를 접지 않으므로(폴딩은 JVARCHAR 전용)
//   FE 가 컬럼별로 '^'-join 해 보내야 한다 — 자매 SCP0006 projectRoute.plantSaveRequest 와 동일 규약.
//   COL_NM(payload 키)은 SCM_ADM_PROC_M 등록 키(camelCase, all_arguments P_ 제거+camel)와 정합해야 한다.

import { apiClient } from '@foundation/apis';
import { t } from '@foundation/i18n';
import { safeString } from '@foundation/utils';

import { MENU_ID, MSG, SHEETS } from '../distribution-route.constants';
import type { DistributionRouteRow } from '../distribution-route.types';

export interface RouteSaveResult {
  ok: boolean;
  message?: string;
}

// payload 키(=SCM_ADM_PROC_M COL_NM) → 그리드 행 필드. activeFlag 만 CRUD 마커로 파생, 나머지는 컬럼 직송.
//   순서는 참고용(BE 는 키로 바인드) — SP all_arguments 순서와 동일하게 유지해 대조를 쉽게 한다.
const COLUMN_MAP: { key: string; field: string }[] = [
  { key: 'routeId', field: 'ROUTE_ID' },
  { key: 'fromCountry', field: 'FROM_COUNTRY' },
  { key: 'fromCity', field: 'FROM_CITY' },
  { key: 'fromCityName', field: 'FROM_CITY_NAME' },
  { key: 'transportMode', field: 'TRANSPORT_MODE' },
  { key: 'priority', field: 'PRIORITY' },
  { key: 'daysMon', field: 'DAYS_MON' },
  { key: 'daysTue', field: 'DAYS_TUE' },
  { key: 'daysWed', field: 'DAYS_WED' },
  { key: 'daysThu', field: 'DAYS_THU' },
  { key: 'daysFri', field: 'DAYS_FRI' },
  { key: 'daysSat', field: 'DAYS_SAT' },
  { key: 'daysSun', field: 'DAYS_SUN' },
  { key: 'dCountry', field: 'D_COUNTRY' },
  { key: 'dPortCode', field: 'D_PORT_CODE' },
  { key: 'dPortName', field: 'D_PORT_NAME' },
  { key: 'aCountry', field: 'A_COUNTRY' },
  { key: 'aPortCode', field: 'A_PORT_CODE' },
  { key: 'aPortName', field: 'A_PORT_NAME' },
  { key: 'shippingCompany', field: 'SHIPPING_COMPANY' },
  { key: 'toCountry', field: 'TO_COUNTRY' },
  { key: 'toCity', field: 'TO_CITY' },
  { key: 'toCityName', field: 'TO_CITY_NAME' },
  { key: 'shipDocPreparationDate', field: 'SHIP_DOC_PREPARATION_DATE' },
  { key: 'ltDepartureInland', field: 'LT_DEPARTURE_INLAND' },
  { key: 'ltWaitShipping', field: 'LT_WAIT_SHIPPING' },
  { key: 'ltVoyage', field: 'LT_VOYAGE' },
  { key: 'ltLayOffClearance', field: 'LT_LAY_OFF_CLEARANCE' },
  { key: 'ltArrivalInland', field: 'LT_ARRIVAL_INLAND' },
  { key: 'validYn', field: 'VALID_YN' },
  { key: 'ltType', field: 'LT_TYPE' },
  // 비용 3컬럼은 그리드 키가 혼합케이스(One_/Two_/Three_) — 컬럼메타 그대로 참조.
  { key: 'oneSegmentCost', field: 'One_SEGMENT_COST' },
  { key: 'twoSegmentCost', field: 'Two_SEGMENT_COST' },
  { key: 'threeSegmentCost', field: 'Three_SEGMENT_COST' },
];

/**
 * 변경된 Route 행들을 SP payload('^'-delim CLOB + 세션 userId)로 조립해 SAVE 호출.
 * userId 는 CREATED_BY/LAST_UPDATED_BY 갱신용 — 호출부가 세션에서 읽어 전달한다.
 */
export const submitRouteSaveRequest = async (
  changed: DistributionRouteRow[],
  userId: string
): Promise<RouteSaveResult> => {
  const activeFlag: string[] = [];
  const cols: Record<string, string[]> = {};
  for (const { key } of COLUMN_MAP) cols[key] = [];

  for (const r of changed) {
    const rec = r as Record<string, unknown>;
    // proc 는 V_ACTIVE_FLAG IN ('M','I') 로 분기 — 신규='I', 그 외(수정)='M'. SCP0005 는 기존행
    //   삭제를 막으므로(deleteOnlyNew) 'D' 는 발생하지 않는다.
    activeFlag.push(rec.CRUD_TYPE === 'I' ? 'I' : 'M');
    for (const { key, field } of COLUMN_MAP) cols[key].push(safeString(rec[field]));
  }

  const payload: Record<string, string> = { activeFlag: activeFlag.join('^') };
  for (const { key } of COLUMN_MAP) payload[key] = cols[key].join('^');
  payload.userId = userId; // 단일 스칼라(P_USER_ID VARCHAR) — '^'-join 대상 아님.

  try {
    const res = await apiClient.post<Record<string, unknown>>(
      `/${MENU_ID}/${SHEETS.ROUTE}/SAVE/call-proc`,
      payload
    );
    // false-success 차단 — 인터셉터가 500 도 resolve 하므로 status/code 를 직접 본다.
    if (res.status >= 400 || Number(res.data?.code)) {
      const reason =
        (res.data as { message?: string })?.message?.trim() ||
        t(MSG.SAVE_DUP, '_저장 중 오류가 발생했습니다.');
      return { ok: false, message: reason };
    }
    return { ok: true };
  } catch (e) {
    const msg = e instanceof Error ? e.message : t(MSG.SAVE_DUP, '_저장 중 오류가 발생했습니다.');
    return { ok: false, message: msg };
  }
};
