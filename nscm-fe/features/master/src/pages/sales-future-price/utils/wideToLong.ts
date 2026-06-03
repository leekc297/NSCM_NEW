// AS-IS 메인 그리드 SP DMF0020_GET_SCM_MST_FUTURE_PRICE 는 wide format (PIVOT) — 1,891 lines
// To-Be P_DMF0020_GET_FUTUREPRICE_INFO 도 wide format (W_yyyymmdd / M_yyyymm prefix 컬럼)
// PivotGrid Tab2 에서는 long format 필요 → 클라이언트 측 unpivot
//
// long row schema:
//   {DIVISION_ID, TEAM_INCHARGE, END_CUSTOMER, ..., MEASURE, BASIS_BINDING, BASIS_TYPE, PRICE}
//   BASIS_BINDING = 'W_yyyymmdd' or 'M_yyyymm'
//   BASIS_TYPE    = 'W' or 'M'
//   PRICE         = NUMBER

import { GROUP_COLS } from '../sales-future-price.constants';
import type { FuturePriceRow } from '../sales-future-price.types';

const TIME_AXIS_RE = /^[WM]_\d{6,8}$/;

export interface LongRow {
  [k: string]: unknown;
  BASIS_BINDING: string;
  BASIS_TYPE: 'W' | 'M';
  PRICE: number;
}

export const wideToLong = (rows: FuturePriceRow[]): LongRow[] => {
  const out: LongRow[] = [];
  for (const r of rows) {
    // 좌측 고정 컬럼 (group key + descriptive)
    const baseEntries: Array<[string, unknown]> = [];
    const dynamicEntries: Array<[string, number]> = [];
    for (const [k, v] of Object.entries(r)) {
      if (TIME_AXIS_RE.test(k)) {
        const num = typeof v === 'number' ? v : Number(v);
        if (!Number.isNaN(num)) dynamicEntries.push([k, num]);
      } else if (k !== 'CRUD_TYPE') {
        baseEntries.push([k, v]);
      }
    }
    if (dynamicEntries.length === 0) continue;
    const base = Object.fromEntries(baseEntries);
    for (const [bind, price] of dynamicEntries) {
      out.push({
        ...base,
        BASIS_BINDING: bind,
        BASIS_TYPE: bind.startsWith('W_') ? 'W' : 'M',
        PRICE: price,
      });
    }
  }
  return out;
};

// 그룹 키 — 11개 컬럼 (Measure 제외) 의 동일 값 행 묶음
//   AS-IS .cs Raw_CellClick + 사용자 캡쳐 group RowSpan 매칭
export const groupKeyOf = (row: FuturePriceRow): string =>
  GROUP_COLS.map(c => String(row[c] ?? '')).join('|');
