import { apiClient } from '@foundation/apis';
import { useSessionStore } from '@shared/stores';

import { MENU_ID, SHEETS } from '../cust-psi-upload.constant';

import type { ExcelFormRow } from './cust-psi-upload.excelForm';

/**
 * Excel Form 조회 — `FORM_DATA` 배선
 *   (BTN_MPG 'FORM_DATA' → API 'DMF0013_GET_EXCEL_FORM' → `PKG_DMF0013.P_DMF0013_GET_EXCEL_FORM_DATA`).
 *
 * hook #135 §3-1 계약: 메인 그리드 조회조건(store.filters)을 가공 없이 그대로 전달한다.
 *   Form SP 의 IN 은 메인 GET 과 동일 축·동일 이름이라 그대로 성립한다(이름이 어긋나면 NULL 바인딩 → 전건 조회).
 * 판정은 결과커서 CODE 이름으로 한다 — HTTP 200 + code=0 이어도 SP 가 실패했을 수 있다.
 */
export const fetchExcelFormData = async (
  filters: Record<string, unknown>
): Promise<{ ok: boolean; message?: string; rows: ExcelFormRow[] }> => {
  const sesUserId = useSessionStore.getState().session.userId ?? '';
  try {
    const res = await apiClient.post<Record<string, unknown>>(
      `/${MENU_ID}/${SHEETS.MAIN}/FORM_DATA/call-proc`,
      { ...filters, sesUserId }
    );
    const code = Number((res.data as { code?: string })?.code ?? 0);
    const result = (res.data?.result ?? {}) as {
      o_rc1?: ExcelFormRow[];
      o_result_cursor?: {
        CODE?: string;
        MSG?: string;
        RESULT_CODE?: string;
        RESULT_MSG?: string;
      }[];
    };
    const inner = result.o_result_cursor?.[0];
    const innerCode = inner?.RESULT_CODE ?? inner?.CODE;
    if (res.status >= 400 || code || (innerCode !== undefined && String(innerCode) !== '0')) {
      return {
        ok: false,
        message: inner?.RESULT_MSG || inner?.MSG || (res.data as { message?: string })?.message,
        rows: [],
      };
    }
    return { ok: true, rows: result.o_rc1 ?? [] };
  } catch (e) {
    return { ok: false, message: e instanceof Error ? e.message : undefined, rows: [] };
  }
};
