import { apiClient } from '@foundation/apis';

import { MENU_ID } from '../cust-fcst-waterfall.constants';

// titleSet(SCM_MST_TITLESET_USER) 저장 시트명 — PKG_DMF0053 BODY L18·L310 실측 (SHEET_NAME 원문).
const TITLESET_SHEET = 'CUST Fcst Waterfall';

/**
 * titleSet 영구 저장 (SCM0002_SET_TITLESET_POPUP — BE 고정 매핑 `/{MENU_ID}/titleSet/SAVE/call-proc`).
 * 'C'=Column / 'M'=Measure. DMF0040 판 이식 (성공 판정 = 결과커서 CODE — 위치기반 금지 계보).
 * Measure 축은 PROGRAM_ID='DMF0053' 독립 (SHEET_MEASURE 기시딩 2행 — CUST_FCST/CUST_FCST_EDI).
 */
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
