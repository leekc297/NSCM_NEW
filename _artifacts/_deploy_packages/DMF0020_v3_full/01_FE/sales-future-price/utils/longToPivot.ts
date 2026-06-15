// AS-IS DMF0020 메인 그리드 3단 pivot 변환 (사용자 요구 2026-06-03):
//   SP 결과 (long format) → 클라이언트 측 pivot (wide format) + 3단 동적 헤더 트리
//
// 입력 (SP P_DMF0020_GET_FUTUREPRICE_INFO 결과):
//   { DIVISION_ID, YYYYMMDD, YYYYMM, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, EDIT_YN }
//
// 출력 1 — pivot rows (좌측 고정 3 cols + 동적 날짜 컬럼):
//   { DIVISION_ID, CURRENCY, UNIT_CURRENCY, '20260101': 970, '20260201': 950, ... }
//
// 출력 2 — 동적 헤더 트리 (3단: YYYY > YYYY-MM > MMDD):
//   [{ year: '2026', months: [{ ym: '2026-01', days: [{ binding: '20260101', label: '0101' }] }] }]

import type { ExchangeRow, PivotHeaderTree, PivotRow } from '../sales-future-price.types';

export const longToPivot = (rows: ExchangeRow[]): {
  pivotRows: PivotRow[];
  headerTree: PivotHeaderTree[];
  allDates: string[];
} => {
  if (!rows || rows.length === 0) {
    return { pivotRows: [], headerTree: [], allDates: [] };
  }

  // ----- 1. 동적 헤더 트리 구성 (YYYY > YYYY-MM > MMDD) -----
  // unique 날짜 정렬
  const dateSet = new Set<string>();
  for (const r of rows) {
    const d = String(r.YYYYMMDD ?? '');
    if (d.length === 8) dateSet.add(d);
  }
  const allDates = [...dateSet].sort();

  // YYYY > YM > MMDD 트리
  const yearMap = new Map<string, Map<string, Array<{ binding: string; label: string }>>>();
  for (const d of allDates) {
    const yyyy = d.slice(0, 4);
    const ym = `${yyyy}-${d.slice(4, 6)}`;
    const mmdd = `${d.slice(4, 6)}${d.slice(6, 8)}`;
    if (!yearMap.has(yyyy)) yearMap.set(yyyy, new Map());
    const monthMap = yearMap.get(yyyy)!;
    if (!monthMap.has(ym)) monthMap.set(ym, []);
    monthMap.get(ym)!.push({ binding: d, label: mmdd });
  }
  const headerTree: PivotHeaderTree[] = [...yearMap.entries()].map(([year, mm]) => ({
    year,
    months: [...mm.entries()].map(([ym, days]) => ({ ym, days })),
  }));

  // ----- 2. pivot rows (Division x Currency x UnitCurrency 별 row) -----
  //   캡쳐 좌측 11 cols 매핑 (사용자 요구 2026-06-03):
  //     DIVISION_ID = Div / TEAM_INCHARGE = '' / END_CUSTOMER = '' / SCM_SITE_ID = '' /
  //     ITEM_ID = '' / INCOTERMS = '' / FCST_TYPE = '' / DOM_EXP = '' / CURRENCY = Currency /
  //     PRICE_EXIST = '' / UNIT_CURRENCY = Measure (단위 통화 표시)
  const groupMap = new Map<string, PivotRow>();
  for (const r of rows) {
    const key = `${r.DIVISION_ID ?? ''}|${r.CURRENCY ?? ''}|${r.UNIT_CURRENCY ?? ''}`;
    if (!groupMap.has(key)) {
      groupMap.set(key, {
        DIVISION_ID: String(r.DIVISION_ID ?? ''),
        TEAM_INCHARGE: '',
        END_CUSTOMER: '',
        SCM_SITE_ID: '',
        PROJECT_CODE: '',
        PROJECT_STATUS: '',
        BIZ_TYPE: '',
        ITEM_ID: '',
        INCOTERMS: '',
        FCST_TYPE: '',
        DOM_EXP: '',
        PLANT_SITE_ID: '',
        CURRENCY: String(r.CURRENCY ?? ''),
        PRICE_EXIST: '',
        UNIT_CURRENCY: String(r.UNIT_CURRENCY ?? ''),
        EDIT_YN: String(r.EDIT_YN ?? ''),
      });
    }
    const row = groupMap.get(key)!;
    const d = String(r.YYYYMMDD ?? '');
    const price = typeof r.EXCHANGE_PRICE === 'number' ? r.EXCHANGE_PRICE : Number(r.EXCHANGE_PRICE);
    if (d && !Number.isNaN(price)) {
      row[d] = price;
    }
  }

  // Division → Currency 정렬
  const pivotRows = [...groupMap.values()].sort((a, b) => {
    if (a.DIVISION_ID !== b.DIVISION_ID) return a.DIVISION_ID.localeCompare(b.DIVISION_ID);
    if (a.CURRENCY !== b.CURRENCY) return a.CURRENCY.localeCompare(b.CURRENCY);
    return a.UNIT_CURRENCY.localeCompare(b.UNIT_CURRENCY);
  });

  return { pivotRows, headerTree, allDates };
};
