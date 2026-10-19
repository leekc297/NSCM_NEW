import { parseDynamicColumnTag } from './shipment-request-pack.dynamicColumn';

// Auto-Sync 3방향 배분(D↔W↔M, 03_grid-columns.md R20) — production-plan-line
// (productionPlanLineDerive.ts)의 검증된 "균등분배 + 나머지 마지막 셀 가산" 산식을 그대로 따른다.
// design 03 §2-4가 서술하는 `DefaultBucketDay`(기본요일 전량배정) 분기는 그 콤보의 DB 실측이
// 이번 회차에도 없어(§6 확인 필요) 구현하지 않는다 — production-plan-line도 동일 분기 없이
// 균등분배만 구현한 선례를 따른다(임의 추정 금지, 04_react-gap.md 이월).

const toNum = (v: unknown): number | null => {
  if (v === undefined || v === null || v === '') return null;
  const n = typeof v === 'number' ? v : typeof v === 'string' ? Number(v.replace(/,/g, '')) : NaN;
  return Number.isFinite(n) ? n : null;
};

const roundQty = (n: number): number => Math.round(n);

export const sumValues = (values: unknown[]): number =>
  roundQty(values.reduce<number>((acc, v) => acc + (toNum(v) ?? 0), 0));

// ISO 8601 주차(월요일 기준) — production-plan-line isoWeek 과 동일 산식.
const isoWeekYear = (yyyymmdd: string): { week: number; year: number } => {
  const d = new Date(
    Date.UTC(+yyyymmdd.slice(0, 4), +yyyymmdd.slice(4, 6) - 1, +yyyymmdd.slice(6, 8))
  );
  const day = d.getUTCDay() || 7;
  d.setUTCDate(d.getUTCDate() + 4 - day);
  const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
  const week = Math.ceil(((d.getTime() - yearStart.getTime()) / 86400000 + 1) / 7);
  return { week, year: d.getUTCFullYear() };
};

// W_ 입력값을 하위 D_ 셀에 균등분배 + 나머지 마지막 셀 가산.
export const distributeToDaily = (total: number, dayCount: number): number[] => {
  if (dayCount <= 0) return [];
  const t = roundQty(total);
  const base = Math.trunc(t / dayCount);
  const remainder = t - base * dayCount;
  const out = new Array<number>(dayCount).fill(base);
  out[dayCount - 1] = base + remainder;
  return out;
};

/** row의 모든 바인딩 중 D_ 바인딩이면서 `weekBinding`(W_yyyymmdd)과 같은 ISO 주차에 속하는 것들. */
export const dailyKeysOfWeek = (rowKeys: string[], weekBinding: string): string[] => {
  const wTag = parseDynamicColumnTag(weekBinding);
  if (!wTag) return [];
  const target = isoWeekYear(wTag.yyyymmdd);
  return rowKeys.filter(k => {
    const tag = parseDynamicColumnTag(k);
    if (!tag || tag.bucket !== 'D') return false;
    const iw = isoWeekYear(tag.yyyymmdd);
    return iw.week === target.week && iw.year === target.year;
  });
};

/** row의 모든 바인딩 중 D_ 바인딩이면서 `monthBinding`(M_yyyymmdd)과 같은 연월에 속하는 것들. */
export const dailyKeysOfMonth = (rowKeys: string[], monthBinding: string): string[] => {
  const mTag = parseDynamicColumnTag(monthBinding);
  if (!mTag) return [];
  const ym = mTag.yyyymmdd.slice(0, 6);
  return rowKeys.filter(k => {
    const tag = parseDynamicColumnTag(k);
    return !!tag && tag.bucket === 'D' && tag.yyyymmdd.slice(0, 6) === ym;
  });
};

/** D_yyyymmdd 하나가 속한 W_ 바인딩(같은 ISO 주차)을 row 바인딩 중에서 찾는다. */
export const weekKeyOfDaily = (rowKeys: string[], dayBinding: string): string | undefined => {
  const dTag = parseDynamicColumnTag(dayBinding);
  if (!dTag) return undefined;
  const target = isoWeekYear(dTag.yyyymmdd);
  return rowKeys.find(k => {
    const tag = parseDynamicColumnTag(k);
    if (!tag || tag.bucket !== 'W') return false;
    const iw = isoWeekYear(tag.yyyymmdd);
    return iw.week === target.week && iw.year === target.year;
  });
};

/** D_yyyymmdd 하나가 속한 M_ 바인딩(같은 연월)을 row 바인딩 중에서 찾는다. */
export const monthKeyOfDaily = (rowKeys: string[], dayBinding: string): string | undefined => {
  const dTag = parseDynamicColumnTag(dayBinding);
  if (!dTag) return undefined;
  const ym = dTag.yyyymmdd.slice(0, 6);
  return rowKeys.find(k => {
    const tag = parseDynamicColumnTag(k);
    return !!tag && tag.bucket === 'M' && tag.yyyymmdd.slice(0, 6) === ym;
  });
};

/** monthBinding(M_yyyymmdd)에 속한 W_ 바인딩(그 달에 걸친 주차) 전체(중복 없이). */
export const weekKeysOfMonth = (rowKeys: string[], monthBinding: string): string[] => {
  const dayKeys = dailyKeysOfMonth(rowKeys, monthBinding);
  const weekKeys = new Set<string>();
  dayKeys.forEach(d => {
    const w = weekKeyOfDaily(rowKeys, d);
    if (w) weekKeys.add(w);
  });
  return [...weekKeys];
};
