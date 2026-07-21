import { apiClient } from '@foundation/apis';
import { useSessionStore } from '@shared/stores';

import { MENU_ID } from '../forecast-price.constants';

// titleSet(SCM_MST_TITLESET_USER) 저장 시트명 — PKG_DMF0082 L603 실측('fcstNPrice').
export const TITLESET_SHEET = 'FcstNPrice';

/** titleSet 영구 저장 (SCM0002_SET_TITLESET_POPUP — DMF0003/0048 선례. 'C'=Column / 'M'=Measure). */
export const saveTitleSet = async (
  columnType: 'C' | 'M',
  saveRows: { name: string; sortOrderNo?: number }[]
): Promise<boolean> => {
  if (saveRows.length === 0) return false;
  try {
    const payload = {
      programId: MENU_ID,
      sheetName: TITLESET_SHEET,
      columnType,
      activeFlag: saveRows.map(() => 'Y').join('^'),
      columnName: saveRows.map(r => r.name).join('^'),
      sortOrderNo: saveRows.map((r, i) => String(r.sortOrderNo ?? i + 1)).join('^'),
      subTotalFlag: saveRows.map(() => 'N').join('^'),
      sortMethodCode: saveRows.map(() => 'ASC').join('^'),
    };
    const res = await apiClient.post<{ CODE?: string }[]>(
      `/${MENU_ID}/titleSet/SAVE/call-proc`,
      payload
    );
    const row = (res.data.result ?? [])[0];
    return !row || row.CODE === undefined || String(row.CODE) === '0';
  } catch {
    return false;
  }
};

/**
 * Excel 업로드 확정 저장 (2-Step OK — DMF0082_EXCEL_UPLOAD mode=1, DMF0074 P_MODE 패턴 1:1).
 * 반환 { ok, message } — FcstUploadModal onSave 계약.
 */
export const saveExcelUpload = async (): Promise<{ ok: boolean; message?: string }> => {
  const sesUserId = useSessionStore.getState().session.userId ?? '';
  try {
    const res = await apiClient.post<Record<string, unknown>>(
      `/${MENU_ID}/FcstNPrice/UPLOAD_SAVE/call-proc`,
      { mode: 1, createdBy: sesUserId }
    );
    const code = Number((res.data as { code?: string })?.code ?? 0);
    const inner = (
      res.data?.result as { o_result_cursor?: { CODE?: string; MSG?: string }[] }
    )?.o_result_cursor?.[0];
    if (res.status >= 400 || code || (inner && inner.CODE !== '0')) {
      return { ok: false, message: inner?.MSG || (res.data as { message?: string })?.message };
    }
    return { ok: true };
  } catch (e) {
    return { ok: false, message: e instanceof Error ? e.message : undefined };
  }
};
