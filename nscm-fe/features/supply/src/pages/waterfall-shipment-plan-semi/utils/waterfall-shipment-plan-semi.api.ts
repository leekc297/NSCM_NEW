import { apiClient } from '@foundation/apis';

import { ADMIN_SHEET_NAME, MENU_ID } from '../waterfall-shipment-plan-semi.constants';

/**
 * titleSet(SCM_MST_TITLESET_USER) 저장 — `btnMeasure_Click`(AS-IS `SCM0002_TitleSetForm_Popup`)
 * 대응. 이 화면은 Measure('M') 축만 쓴다(03_grid-columns.md §4.3 — Column('C') 설정 버튼은 없음).
 * DMF0053(cust-fcst-waterfall) 판 이식.
 */
export const saveTitleSet = async (
  columnType: 'C' | 'M',
  saveRows: { name: string; sortOrderNo?: number }[]
): Promise<boolean> => {
  if (saveRows.length === 0) return false;
  try {
    const payload = {
      programId: MENU_ID,
      sheetName: ADMIN_SHEET_NAME,
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
    if (res.status >= 400 || Number((res.data as { code?: string }).code)) return false;
    const row = (res.data.result ?? [])[0];
    return !row || row.CODE === undefined || String(row.CODE) === '0';
  } catch {
    return false;
  }
};
