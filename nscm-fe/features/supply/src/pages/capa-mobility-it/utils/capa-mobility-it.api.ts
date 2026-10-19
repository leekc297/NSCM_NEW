import { apiClient } from '@foundation/apis';

import { ADMIN_SHEET_NAME, MENU_ID } from '../capa-mobility-it.constants';

/** titleSet(SCM_MST_TITLESET_USER) 저장/조회 시트명 — admin 컬럼 메타 시트명과 동일(CAPA_SMALL). */
export const TITLESET_SHEET = ADMIN_SHEET_NAME;

/** titleSet 영구 저장 (공용 SCM0002_SET_TITLESET_POPUP — 'C'=Column / 'M'=Measure). ForecastPrice 선례 1:1. */
export const saveTitleSet = async (
  columnType: 'C' | 'M',
  saveRows: {
    name: string;
    sortOrderNo?: number;
    colWidth?: number;
    cellColor?: string;
    textColor?: string;
  }[]
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
      columnWidth: saveRows.map(r => String(r.colWidth ?? '')).join('^'),
      cellColor: saveRows.map(r => r.cellColor ?? '').join('^'),
      textColor: saveRows.map(r => r.textColor ?? '').join('^'),
    };
    const res = await apiClient.post<{ CODE?: string }[]>(
      `/${MENU_ID}/titleSet/SAVE/call-proc`,
      payload
    );
    if (res.status >= 400 || Number((res.data as { code?: string }).code)) return false;
    const row = (res.data.result ?? [])[0];
    return !row || row.CODE === undefined || String(row.CODE) === '0';
  } catch {
    return false;
  }
};
