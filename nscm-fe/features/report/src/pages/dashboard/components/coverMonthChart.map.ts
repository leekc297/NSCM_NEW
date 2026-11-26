// Cover Month 추이 — P_DMD0001_GET_COVER_TREND 의 Long o_rc1(CATEGORY·SERIES·VALUE)을
//   멀티라인 Wide 로 피벗한다. SERIES = 모델코드(동적). 바인딩 키는 인덱스(v0·v1…)를 쓰고
//   표시명만 모델코드로 둔다('N2.2A' 처럼 점 포함 코드가 wijmo 바인딩 경로로 분해되는 것을 피함).

export type CoverTrendApiRow = Record<string, string | number | null | undefined>;

export interface CoverTrendSeries {
  key: string; // 바인딩 키 (v0, v1, …)
  name: string; // 표시명 (모델코드)
}

export interface CoverTrendVm {
  series: CoverTrendSeries[];
  points: Array<Record<string, string | number | null>>;
}

const num = (v: string | number | null | undefined): number | null => {
  if (v == null || v === '') return null;
  const n = Number(v);
  return Number.isNaN(n) ? null : n;
};

export const mapCoverTrend = (rows: CoverTrendApiRow[]): CoverTrendVm => {
  // 1패스: 시리즈(모델코드)와 카테고리를 최초 등장 순서로 수집.
  const keyByName = new Map<string, string>();
  const series: CoverTrendSeries[] = [];
  const categories: string[] = [];
  const seen = new Set<string>();
  for (const r of rows) {
    const name = String(r.SERIES);
    if (!keyByName.has(name)) {
      const key = `v${series.length}`;
      keyByName.set(name, key);
      series.push({ key, name });
    }
    const category = r.CATEGORY == null ? '' : String(r.CATEGORY);
    if (!seen.has(category)) {
      seen.add(category);
      categories.push(category);
    }
  }

  // 2패스: 카테고리별 포인트를 모든 시리즈 키 null 로 초기화 후 값 채움.
  const points = categories.map(category => {
    const point: Record<string, string | number | null> = { x: category };
    for (const s of series) point[s.key] = null;
    return point;
  });
  const indexByCategory = new Map(categories.map((c, i) => [c, i]));
  for (const r of rows) {
    const category = r.CATEGORY == null ? '' : String(r.CATEGORY);
    const key = keyByName.get(String(r.SERIES));
    const idx = indexByCategory.get(category);
    if (key && idx !== undefined) points[idx][key] = num(r.VALUE);
  }

  return { series, points };
};
