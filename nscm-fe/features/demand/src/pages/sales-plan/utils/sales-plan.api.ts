// ⭐ DMF0021 — call-proc 직접 호출 헬퍼 (titleSet 영구 저장 + SAVE '^' bulk 결과 파싱).
//   '^' delim 다건 SAVE 는 apiClient.post 직접 — useProcMutation array unfold 회피 표준
//   (memory feedback_save_sp_bulk_payload_apiclient_post).
import { apiClient } from '@foundation/apis';

import { MENU_ID, SHEETS } from '../sales-plan.constants';

// titleSet(SCM_MST_TITLESET_USER) 영구 저장 — SCM0002_SET_TITLESET_POPUP ('C'=Column / 'M'=Measure).
//   AS-IS DM0002_TitleSetForm_Popup OK 1:1 (btnColumn L4427 / btnMeasure L4440 — DMF0003/0082 선례).
export const saveTitleSet = async (
  columnType: 'C' | 'M',
  saveRows: { name: string; sortOrderNo?: number; subTotalFlag?: string; sortMethodCode?: string }[]
): Promise<boolean> => {
  if (saveRows.length === 0) return false;
  try {
    const payload = {
      programId: MENU_ID,
      sheetName: SHEETS.MAIN, // 'Sales Plan' — SP 리터럴·SHEET_COLUMNS/MEASURE 일치 (rename 불가 근거)
      columnType,
      activeFlag: saveRows.map(() => 'Y').join('^'),
      columnName: saveRows.map(r => r.name).join('^'),
      sortOrderNo: saveRows.map((r, i) => String(r.sortOrderNo ?? i + 1)).join('^'),
      subTotalFlag: saveRows.map(r => r.subTotalFlag ?? 'N').join('^'),
      sortMethodCode: saveRows.map(r => r.sortMethodCode ?? 'ASC').join('^'),
    };
    const res = await apiClient.post<{ CODE?: string }[]>(
      `/${MENU_ID}/${SHEETS.TITLE_SET}/SAVE/call-proc`,
      payload
    );
    if (res.status >= 400 || Number((res.data as { code?: string })?.code)) return false;
    const row = (res.data.result ?? [])[0];
    return !row || row.CODE === undefined || String(row.CODE) === '0';
  } catch {
    return false;
  }
};

// SAVE 결과 — AS-IS L2717~2794: 첫 셀 == 'success' 성공 / ≠ 'success' 는 'messageCode^addmessage'
//   (SP 내장 중복검증 등 — [E20250520-000572] 통합 방식. msgCode = MSG ID → 호출측 t() 변환).
export interface SaveSalesPlanResult {
  ok: boolean;
  msgCode?: string;
  addMessage?: string;
}

export const callSaveSalesPlan = async (
  payload: Record<string, string>
): Promise<SaveSalesPlanResult> => {
  const res = await apiClient.post<Record<string, unknown>>(
    `/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`,
    payload
  );
  // status 500/403 은 responseErrorInterceptor 가 resolve → 직접 차단 (false success 방지).
  if (res.status >= 400 || Number((res.data as { code?: string })?.code)) {
    return { ok: false, addMessage: (res.data as { message?: string })?.message?.trim() };
  }
  // 결과 커서 첫 행 첫 값 판정 — 커서명 비의존(방어적): result 가 배열이면 그대로, 객체면 첫 배열 값.
  const result = (res.data as { result?: unknown })?.result;
  const rows = Array.isArray(result)
    ? (result as unknown[])
    : result && typeof result === 'object'
      ? (Object.values(result as Record<string, unknown>).find(v => Array.isArray(v)) as
          | unknown[]
          | undefined)
      : undefined;
  const first = rows?.[0];
  if (first && typeof first === 'object') {
    const firstVal = Object.values(first as Record<string, unknown>).find(
      v => typeof v === 'string' && String(v).trim() !== ''
    );
    if (typeof firstVal === 'string' && firstVal.trim().toLowerCase() !== 'success') {
      // 'messageCode^addmessage' 분해 (AS-IS L2776~2782)
      const [msgCode, ...rest] = firstVal.split('^');
      return { ok: false, msgCode: msgCode.trim(), addMessage: rest.join('^').trim() || undefined };
    }
  }
  return { ok: true };
};
