import { parseDynamicColumnTag } from './shipment-request-pack.dynamicColumn';

// Auto-Sync 3방향 배분(D↔W↔M, 03_grid-columns.md R20).
//   - D→W/M: 합산(sumValues).
//   - W→D / M→D: **AS-IS DefaultBucketDay(기본요일) 배분**(사용자 지시 2026-11-09). AS-IS spdMain_Changed
//     (cs:2541~2924)는 DefaultBucketDay 콤보(SCM_ADM_LOOKUP_MASTER_DETAIL DEFAULT_BUCKET_DAY, division별
//     요일 — 40=MON·81/82=FRI, ora.py 실측 2026-11-09)로 분배한다: W→D 는 그 주 기본요일 1일에 전량,
//     M→D 는 그 달 기본요일 날짜들에 균등분배(+나머지 마지막). TO-BE 조회 SP(PKG_SSP0026)는 DB_(day-bucket
//     플래그) 컬럼을 만들지 않으므로(ora.py 실측 0건) AS-IS 의 DB_ 균등분배 분기는 데이터가 없어 항상
//     bWeekAll/bMonthAll(기본요일) 경로를 탄다 — 전 division 에 기본요일이 설정돼 있어 이 경로가 전부다.
//   저장은 D_(일)만 전송한다(AS-IS SaveData cs:1621 과 동일, shipment-request-pack.save.ts collectPivotChanges).
//   종전 균등분배(distributeToDaily)는 기본요일 미확보(콤보 0행) 시 폴백으로만 남긴다.

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

// yyyymmdd → 요일코드(SUN/MON/.../SAT). AS-IS 가 DefaultBucketDay(SCM_ADM_LOOKUP_MASTER_DETAIL
//   DEFAULT_BUCKET_DAY SEGMENT3)와 `dtWekk.ToString("ddd", en-US).ToUpper()` 를 비교하는 것과 동일 코드체계.
//   isoWeekYear 와 동일하게 UTC 로 계산해 TZ 영향(월말/주말 경계 오류)을 없앤다.
const WEEKDAY_CODES = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'] as const;
export const weekdayCode = (yyyymmdd: string): string => {
  const d = new Date(
    Date.UTC(+yyyymmdd.slice(0, 4), +yyyymmdd.slice(4, 6) - 1, +yyyymmdd.slice(6, 8))
  );
  return WEEKDAY_CODES[d.getUTCDay()] ?? '';
};

const byDate = (a: string, b: string): number =>
  (parseDynamicColumnTag(a)?.yyyymmdd ?? '').localeCompare(parseDynamicColumnTag(b)?.yyyymmdd ?? '');

/**
 * W→D 배분(AS-IS spdMain_Changed Weekly bWeekAll, cs:2645~2695) — 그 주의 **기본요일(defaultDay) 1일에
 * 전량 배정**, 나머지 일자는 0. 주에 기본요일 날짜가 없으면(부분주) **마지막 날**에 전량(AS-IS iSetCol fallback).
 * 반환: 그 주 전 D_ 키의 {key, qty}(0 포함) — 호출측이 전부 setCell 해 하위 일자를 확정한다.
 */
export const splitWeeklyByDefaultDay = (
  dayKeys: string[],
  weeklyTotal: number,
  defaultDay: string
): Array<{ key: string; qty: number }> => {
  const sorted = [...dayKeys].sort(byDate);
  if (sorted.length === 0) return [];
  const total = roundQty(weeklyTotal);
  const targetKey =
    sorted.find(k => weekdayCode(parseDynamicColumnTag(k)?.yyyymmdd ?? '') === defaultDay) ??
    sorted[sorted.length - 1];
  return sorted.map(k => ({ key: k, qty: k === targetKey ? total : 0 }));
};

/**
 * M→D 배분(AS-IS spdMain_Changed Monthly bMonthAll, cs:2846~2924) — 그 달의 **기본요일 날짜들에 균등분배
 * + 나머지 마지막 날짜 가산**, 나머지 일자는 0. 기본요일 날짜가 없으면 마지막 날 1곳에 전량.
 * 주의: AS-IS 는 "이번주 월요일 이후" 날짜만 대상(과거 제외, cs:2743/2753)인데, 그 실시간 필터는
 *   이식하지 않고(런타임 Today 의존 회피) 그 달의 전 기본요일에 배분한다 — 과거 일자 보호는 확정구간
 *   잠금(editLock)이 별도로 담당. (Monthly 는 미검증 — 사용자/담당자 확인 필요.)
 */
export const splitMonthlyByDefaultDay = (
  dayKeys: string[],
  monthlyTotal: number,
  defaultDay: string
): Array<{ key: string; qty: number }> => {
  const sorted = [...dayKeys].sort(byDate);
  if (sorted.length === 0) return [];
  const targets = sorted.filter(
    k => weekdayCode(parseDynamicColumnTag(k)?.yyyymmdd ?? '') === defaultDay
  );
  const useTargets = targets.length > 0 ? targets : [sorted[sorted.length - 1]];
  const amounts = distributeToDaily(monthlyTotal, useTargets.length);
  const qtyByKey = new Map(useTargets.map((k, i) => [k, amounts[i]]));
  return sorted.map(k => ({ key: k, qty: qtyByKey.get(k) ?? 0 }));
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
