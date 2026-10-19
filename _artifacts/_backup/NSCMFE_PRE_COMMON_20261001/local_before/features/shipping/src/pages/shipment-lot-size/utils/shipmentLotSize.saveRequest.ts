// SCP0028 Shipment Lot Size 저장 — payload 조립 + POST + false-success 판별.
//   SAVE SP(PKG_SCP0028.P_SCP0028_SAVE_SHIPMENT_LOT_SIZE)는 각 컬럼을 CLOB '^'-delim 배치 문자열로 받는다
//   (all_arguments 실측: P_ACTIVE_FLAG~P_VALID_YN CLOB, P_USER_ID/P_DEBUG_MODE VARCHAR). BE 는 키(=PROC_M
//   COL_NM camelCase)로 바인드하므로 FE 가 컬럼별 '^'-join 해 보낸다 — 자매 SCP0005 submitRouteSaveRequest 동형.
//   PROC_M COL_NM 실측(2026-09-26): activeFlag/divisionId/operationGroup/fromSite/toSite/itemId/transportMode/
//   lotSize/increment/splitYn/validYn/userId/debugMode.

import { apiClient } from '@foundation/apis';
import { t } from '@foundation/i18n';
import { safeString } from '@foundation/utils';

import { MENU_ID, MSG, SHEETS } from '../shipment-lot-size.constants';

export interface LotSizeSaveRow {
  activeFlag: string; // 'I'(신규 후보) | 'M'(수정) | 'D'(일괄삭제)
  DIVISION_ID: unknown;
  OPERATION_GROUP_ID: unknown;
  FROM_SITE: unknown; // hidden 저장 키
  TO_SITE: unknown; // hidden 저장 키
  ITEM_ID: unknown;
  TRANS_MODE_CODE: unknown; // hidden 저장 키
  LOT_SIZE: unknown;
  INCREMENT: unknown;
  SPLIT_YN: unknown;
  VALID_YN: unknown;
}

export interface LotSizeSaveResult {
  ok: boolean;
  message?: string;
}

// payload 키(=PROC_M COL_NM) → 행 필드. activeFlag 만 CRUD 마커, 나머지는 컬럼 직송. all_arguments 순서 유지.
const COLUMN_MAP: { key: string; field: keyof LotSizeSaveRow }[] = [
  { key: 'divisionId', field: 'DIVISION_ID' },
  { key: 'operationGroup', field: 'OPERATION_GROUP_ID' },
  { key: 'fromSite', field: 'FROM_SITE' },
  { key: 'toSite', field: 'TO_SITE' },
  { key: 'itemId', field: 'ITEM_ID' },
  { key: 'transportMode', field: 'TRANS_MODE_CODE' },
  { key: 'lotSize', field: 'LOT_SIZE' },
  { key: 'increment', field: 'INCREMENT' },
  { key: 'splitYn', field: 'SPLIT_YN' },
  { key: 'validYn', field: 'VALID_YN' },
];

/**
 * 변경/삭제 행들을 SP payload('^'-delim CLOB + 세션 userId)로 조립해 SAVE 호출.
 * userId 는 CREATED_BY/LAST_UPDATED_BY 갱신용 — 호출부가 세션에서 읽어 전달한다.
 * isDelete=true 면 실패 메시지를 삭제 실패(MSG.DELETE_FAIL)로 노출한다.
 */
export const submitLotSizeSaveRequest = async (
  rows: LotSizeSaveRow[],
  userId: string,
  isDelete = false
): Promise<LotSizeSaveResult> => {
  const activeFlag: string[] = [];
  const cols: Record<string, string[]> = {};
  for (const { key } of COLUMN_MAP) cols[key] = [];

  for (const r of rows) {
    activeFlag.push(r.activeFlag);
    for (const { key, field } of COLUMN_MAP) cols[key].push(safeString(r[field]));
  }

  const payload: Record<string, string> = { activeFlag: activeFlag.join('^') };
  for (const { key } of COLUMN_MAP) payload[key] = cols[key].join('^');
  payload.userId = userId; // 단일 스칼라(P_USER_ID VARCHAR) — '^'-join 대상 아님.
  payload.debugMode = 'N'; // P_DEBUG_MODE (VARCHAR)

  const failMsg = isDelete
    ? t(MSG.DELETE_FAIL, '_Failed to delete.')
    : t(MSG.SAVE_FAIL, '_Failed to save.');

  try {
    const res = await apiClient.post<Record<string, unknown>>(
      `/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`,
      payload
    );
    // false-success 차단 — 인터셉터가 500 도 resolve 하므로 status/code 를 직접 본다(nscm-patterns §5-10).
    if (res.status >= 400 || Number(res.data?.code)) {
      const reason = (res.data as { message?: string })?.message?.trim() || failMsg;
      return { ok: false, message: reason };
    }
    return { ok: true };
  } catch (e) {
    const msg = e instanceof Error && e.message ? e.message : failMsg;
    return { ok: false, message: msg };
  }
};
