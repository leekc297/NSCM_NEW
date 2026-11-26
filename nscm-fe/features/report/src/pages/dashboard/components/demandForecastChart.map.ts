// 수요 예측 추이 — P_DMD0001_GET_DEMAND_TREND 의 Long o_rc1(CATEGORY·SERIES·VALUE)을
//   카테고리 공유 Wide 포인트[{x, actual, mktFcst, aiFcst}]로 피벗한다. SERIES 3종, 없는 값은 null 보존.

export type DemandTrendApiRow = Record<string, string | number | null | undefined>;

export interface DemandTrendPoint {
  x: string;
  actual: number | null;
  mktFcst: number | null;
  aiFcst: number | null;
}

type SeriesKey = 'actual' | 'mktFcst' | 'aiFcst';
const SERIES_KEYS: readonly SeriesKey[] = ['actual', 'mktFcst', 'aiFcst'];

const num = (v: string | number | null | undefined): number | null => {
  if (v == null || v === '') return null;
  const n = Number(v);
  return Number.isNaN(n) ? null : n;
};

export const mapDemandTrend = (rows: DemandTrendApiRow[]): DemandTrendPoint[] => {
  const byCategory = new Map<string, DemandTrendPoint>();
  for (const r of rows) {
    const category = r.CATEGORY == null ? '' : String(r.CATEGORY);
    let point = byCategory.get(category);
    if (!point) {
      point = { x: category, actual: null, mktFcst: null, aiFcst: null };
      byCategory.set(category, point);
    }
    const series = String(r.SERIES) as SeriesKey;
    if (SERIES_KEYS.includes(series)) point[series] = num(r.VALUE);
  }
  return [...byCategory.values()];
};
