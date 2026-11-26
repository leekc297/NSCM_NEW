// 재고 전망 — P_DMD0001_GET_INVENTORY_PROJECTION 의 Long o_rc1(CATEGORY·SERIES·VALUE·LABEL)을
//   Wide 포인트[{x, onHand, demand, inbound, safety}] + 부족 마커로 피벗한다.
//   SERIES: 수치 4종 + shortageMark(VALUE 없음·LABEL 에 문구). 없는 값은 null 보존.

export type InventoryApiRow = Record<string, string | number | null | undefined>;

export interface InventoryPoint {
  x: string;
  onHand: number | null;
  demand: number | null;
  inbound: number | null;
  safety: number | null;
}

export interface InventoryVm {
  points: InventoryPoint[];
  shortageMark: { x: string; label: string } | null;
}

type NumericSeries = 'onHand' | 'demand' | 'inbound' | 'safety';
const NUMERIC_SERIES: readonly NumericSeries[] = ['onHand', 'demand', 'inbound', 'safety'];

const num = (v: string | number | null | undefined): number | null => {
  if (v == null || v === '') return null;
  const n = Number(v);
  return Number.isNaN(n) ? null : n;
};

export const mapInventoryProjection = (rows: InventoryApiRow[]): InventoryVm => {
  const byCategory = new Map<string, InventoryPoint>();
  let shortageMark: InventoryVm['shortageMark'] = null;

  for (const r of rows) {
    const series = String(r.SERIES);
    const category = r.CATEGORY == null ? '' : String(r.CATEGORY);
    if (series === 'shortageMark') {
      shortageMark = { x: category, label: r.LABEL == null ? '' : String(r.LABEL) };
      continue;
    }
    if (!NUMERIC_SERIES.includes(series as NumericSeries)) continue;
    let point = byCategory.get(category);
    if (!point) {
      point = { x: category, onHand: null, demand: null, inbound: null, safety: null };
      byCategory.set(category, point);
    }
    point[series as NumericSeries] = num(r.VALUE);
  }

  return { points: [...byCategory.values()], shortageMark };
};
