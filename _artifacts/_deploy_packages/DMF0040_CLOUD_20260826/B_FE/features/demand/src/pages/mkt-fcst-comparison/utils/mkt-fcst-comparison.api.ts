import { apiClient } from '@foundation/apis';

import { MENU_ID } from '../mkt-fcst-comparison.constants';

// titleSet(SCM_MST_TITLESET_USER) 저장 시트명 — PKG_DMF0040 BODY L285~363 실측 (SHEET_NAME 원문).
const TITLESET_SHEET = 'Mkt Fcst Waterfall';

/**
 * titleSet 영구 저장 (SCM0002_SET_TITLESET_POPUP — BE 고정 매핑 `/{MENU_ID}/titleSet/SAVE/call-proc`).
 * 'C'=Column / 'M'=Measure. forecast-price 판 이식 (성공 판정 = 결과커서 CODE — 위치기반 금지 계보).
 * ⭐ Measure 축도 PROGRAM_ID=DMF0040 — AS-IS 는 DMF0035 공유(btnMeasure L1350)였으나 TO-BE 는
 *   PKG_DMF0040 이 PROGRAM_ID='DMF0040' 으로 SHEET_MEASURE/TITLESET 를 읽으므로(BODY L362~363)
 *   독립 축으로 전환 (SHEET_MEASURE 49행 시딩 — seed_meta.py).
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
