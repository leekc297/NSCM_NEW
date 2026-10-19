// SCP0011 pivot 파생 산식 (design 03 §2.4) — 자매 SCP0013 derive 이식. 순수 함수(그리드 핸들러가 호출).

// 숫자 파싱 — 공백/빈값/파싱실패 = null.
export const toNum = (v: unknown): number | null => {
  if (v === undefined || v === null || v === '') return null;
  const n = typeof v === 'number' ? v : typeof v === 'string' ? Number(v.replace(/,/g, '')) : NaN;
  return Number.isFinite(n) ? n : null;
};

// QTY 는 정수(반올림) — design 03 §4.1. 비율 measure 만 소수2(그리드 format).
export const roundQty = (n: number): number => Math.round(n);

// ISO 8601 주차(월요일 기준) — 3단 헤더 주 span 라벨/그룹핑.
export const isoWeek = (yyyymmdd: string): number => {
  const d = new Date(
    Date.UTC(+yyyymmdd.slice(0, 4), +yyyymmdd.slice(4, 6) - 1, +yyyymmdd.slice(6, 8))
  );
  const day = d.getUTCDay() || 7;
  d.setUTCDate(d.getUTCDate() + 4 - day);
  const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
  return Math.ceil(((d.getTime() - yearStart.getTime()) / 86400000 + 1) / 7);
};

// W_ 입력값을 하위 D_ 셀에 균등분배 + 나머지 마지막 셀 (design 03 §2.4 CalculateSum 역산).
export const distributeWeeklyToDaily = (weekTotal: number, dayCount: number): number[] => {
  if (dayCount <= 0) return [];
  const total = roundQty(weekTotal);
  const base = Math.trunc(total / dayCount);
  const remainder = total - base * dayCount;
  const out = new Array<number>(dayCount).fill(base);
  out[dayCount - 1] = base + remainder;
  return out;
};

// 일합계 — 음수 원복 + 주/월 재집계 SUM (design 03 §2.4).
export const sumValues = (values: unknown[]): number =>
  roundQty(values.reduce<number>((acc, v) => acc + (toNum(v) ?? 0), 0));

const pivotTag = (binding: string): string => binding.slice(2).replace(/[^0-9]/g, '');

// W_ 바인딩의 주차 번호 — 'W_'||yyyymm||ISO_WEEK.
export const weekNoOf = (weekBinding: string): number => {
  const tag = pivotTag(weekBinding);
  return Number(tag.slice(6)) || Number(tag.slice(4, 6));
};

// W_ 의 하위 D_ 키 — 같은 달(yyyymm) 안의 같은 주(ISO)만. 월에 걸친 주는 달별로 나눠 합산해
//   월 SUM = 그 달 주 SUM 합이 되게 한다(AS-IS 화면 확인 2026-10-13).
export const dailyKeysOfWeek = (rowKeys: string[], weekBinding: string): string[] => {
  const ym = pivotTag(weekBinding).slice(0, 6);
  const weekNum = weekNoOf(weekBinding);
  return rowKeys.filter(k => {
    if (!k.startsWith('D_')) return false;
    const d = pivotTag(k);
    return d.slice(0, 6) === ym && isoWeek(d) === weekNum;
  });
};

export const dailyKeysOfMonth = (rowKeys: string[], ym: string): string[] =>
  rowKeys.filter(k => k.startsWith('D_') && pivotTag(k).slice(0, 6) === ym);

// LINE 행에 빠진 기간 키를 빈 값으로 채운다 — 값이 전부 빈 컬럼은 응답에서 빠져 그 달/주 열이
//   통째로 사라진다. 기준은 MODEL 첫 행의 기간 키(같은 Period) 중 조회 기간 안의 것 + LINE 행 키 합집합.
export const alignPivotKeys = (
  rows: Record<string, unknown>[],
  refRow: Record<string, unknown> | undefined,
  fromYmd: string,
  toYmd: string
): Record<string, unknown>[] => {
  if (rows.length === 0) return rows;
  const keys = new Set<string>();
  for (const k of Object.keys(refRow ?? {})) {
    if (!/^[DWM]_/.test(k)) continue;
    const tag = pivotTag(k);
    const inRange =
      !fromYmd || !toYmd
        ? true
        : k.startsWith('D_')
          ? tag >= fromYmd && tag <= toYmd
          : tag.slice(0, 6) >= fromYmd.slice(0, 6) && tag.slice(0, 6) <= toYmd.slice(0, 6);
    if (inRange) keys.add(k);
  }
  for (const r of rows) {
    for (const k of Object.keys(r)) if (/^[DWM]_/.test(k)) keys.add(k);
  }
  return rows.map(row => {
    let next: Record<string, unknown> | undefined;
    for (const k of keys) {
      if (k in row) continue;
      next ??= { ...row };
      next[k] = null;
    }
    return next ?? row;
  });
};

// 조회 직후 W_/M_ SUM 채움 — AS-IS CalculateSum(design 03 §2.4). 서버는 D_ 만 채우므로 행별로 D_ 합산,
//   비율 measure 는 평균, lastValueMeasures(ONHAND_EOH)는 합이 아니라 구간 마지막 값(AS-IS 화면 확인
//   2026-10-13). 하위 D_ 가 없는 W_/M_ 는 서버값 유지.
export const fillPivotSums = (
  rows: Record<string, unknown>[],
  ratioMeasures: readonly string[],
  lastValueMeasures: readonly string[]
): Record<string, unknown>[] => {
  if (rows.length === 0) return rows;
  const plans = new Map<string, [string, string[]][]>();
  const planOf = (rowKeys: string[]): [string, string[]][] => {
    const sig = String(rowKeys.length) + '|' + (rowKeys[rowKeys.length - 1] ?? '');
    let plan = plans.get(sig);
    if (!plan) {
      plan = [];
      for (const k of rowKeys) {
        const dayKeys = k.startsWith('W_')
          ? dailyKeysOfWeek(rowKeys, k)
          : k.startsWith('M_')
            ? dailyKeysOfMonth(rowKeys, pivotTag(k).slice(0, 6))
            : [];
        if (dayKeys.length > 0) plan.push([k, dayKeys.sort()]);
      }
      plans.set(sig, plan);
    }
    return plan;
  };

  return rows.map(row => {
    const measure = typeof row.MEASURE === 'string' ? row.MEASURE : '';
    const isLast = lastValueMeasures.includes(measure);
    const plan = planOf(Object.keys(row));
    if (plan.length === 0) return row;
    const isRatio = ratioMeasures.includes(measure);
    const next = { ...row };
    for (const [sumKey, dayKeys] of plan) {
      const values = dayKeys.map(k => toNum(row[k])).filter((v): v is number => v !== null);
      // 하위 D_ 가 전부 빈 값이면 서버값(빈칸)을 그대로 둔다 — LINE SP 는 값 없는 구간을 NULL 로 준다.
      if (values.length === 0) continue;
      if (isLast) {
        next[sumKey] = values[values.length - 1];
        continue;
      }
      const total = values.reduce((acc, v) => acc + v, 0);
      next[sumKey] = isRatio ? total / dayKeys.length : roundQty(total);
    }
    return next;
  });
};

// ===== O_RC3(주)/O_RC4(월) ratio 적용 (design 03 §2.4 — 비율 measure W_/M_ 는 평균이라 서버 ratio 덮어씀) =====
//   비율 measure(MODEL FORMATION_YIELD / LINE LINE_TOTAL_LOAD) 행의 W_/M_ 를 ratio 커서 값으로 주입.
const ratioMatchKey = (row: Record<string, unknown>): string => {
  const g = (k: string): string => {
    const v = row[k];
    return typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
  };
  return [g('DIVISION_ID'), g('SCM_SITE_ID'), g('OPERATION_ID'), g('LINE_ID'), g('MEASURE')].join('|');
};

export const applyRatio = (
  rows: Record<string, unknown>[],
  weekRatio: Record<string, unknown>[],
  monthRatio: Record<string, unknown>[],
  ratioMeasures: readonly string[]
): Record<string, unknown>[] => {
  if (rows.length === 0) return rows;
  if (weekRatio.length === 0 && monthRatio.length === 0) return rows;
  const wMap = new Map<string, Record<string, unknown>>();
  for (const r of weekRatio) wMap.set(ratioMatchKey(r), r);
  const mMap = new Map<string, Record<string, unknown>>();
  for (const r of monthRatio) mMap.set(ratioMatchKey(r), r);

  const overlay = (target: Record<string, unknown>, src: Record<string, unknown> | undefined, prefix: string) => {
    if (!src) return;
    for (const key of Object.keys(src)) {
      if (key.startsWith(prefix)) target[key] = src[key];
    }
  };

  return rows.map(row => {
    const measure = typeof row.MEASURE === 'string' ? row.MEASURE : '';
    if (!ratioMeasures.includes(measure)) return row;
    const key = ratioMatchKey(row);
    const next = { ...row };
    overlay(next, wMap.get(key), 'W_');
    overlay(next, mMap.get(key), 'M_');
    return next;
  });
};
