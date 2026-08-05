import { apiClient } from '@foundation/apis';

import { DIVISION_40, MENU_ID, SHEETS } from '../demand-manager.constants';
import type { SaveOrderRow } from '../demand-manager.types';

// ⭐ 저장·삭제는 컬렉션 IN 을 바인딩할 수 없어 CLOB(JSON) 래퍼 멤버를 부른다.
//   BE generic call-proc 이 `data` 배열을 JSON 문자열(CLOB)로 직렬화해 넘긴다.
//   결과 커서는 CODE / MSG / EVENT 3열 — CODE '0' 성공(EVENT=건수), 'DUPLICATE' 기간 중첩.
//   useProcMutation 의 배열 wrap 매핑 결함을 피하려고 apiClient.post 를 직접 쓴다
//   (메모리 feedback_save_sp_bulk_payload_apiclient_post).

export interface OrderProcResult {
  ok: boolean;
  code?: string;
  count?: string;
  message?: string;
}

/** 결과 커서 첫 행에서 CODE / MSG / EVENT 를 뽑는다 (커서 이름에 의존하지 않는다) */
const parseResultRow = (data: unknown): Record<string, unknown> | undefined => {
  const result = (data as { result?: unknown })?.result;
  const rows = Array.isArray(result)
    ? (result as unknown[])
    : result && typeof result === 'object'
      ? (Object.values(result as Record<string, unknown>).find(v => Array.isArray(v)) as
          | unknown[]
          | undefined)
      : undefined;
  const first = rows?.[0];
  return first && typeof first === 'object' ? (first as Record<string, unknown>) : undefined;
};

const toResult = (data: unknown, status: number): OrderProcResult => {
  if (status >= 400 || Number((data as { code?: string })?.code)) {
    return { ok: false, message: (data as { message?: string })?.message?.trim() };
  }
  const row = parseResultRow(data);
  const code = row ? String(row.CODE ?? row.code ?? '') : '';
  const event = row ? String(row.EVENT ?? row.event ?? '') : '';
  if (code === '0') return { ok: true, code, count: event };
  return { ok: false, code: code || undefined, count: event || undefined };
};

/** 저장 — PKG_DMF0068.P_DMF0068_SAVE_ORDERLIST_JSON */
export const callSaveOrderList = async (
  rows: SaveOrderRow[],
  versionNo: string
): Promise<OrderProcResult> => {
  const res = await apiClient.post<Record<string, unknown>>(
    `/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`,
    { data: rows, divisionId: DIVISION_40, versionNo }
  );
  return toResult(res.data, res.status);
};

/** 삭제 — PKG_DMF0068.P_DMF0068_DEL_ORDERLIST_JSON (그룹 키만 있으면 짝까지 지운다) */
export const callDeleteOrderList = async (
  groupKeys: string[]
): Promise<OrderProcResult> => {
  const res = await apiClient.post<Record<string, unknown>>(
    `/${MENU_ID}/${SHEETS.MAIN}/DELETE/call-proc`,
    { data: groupKeys.map(k => ({ ATTRIBUTE2: k })) }
  );
  return toResult(res.data, res.status);
};
