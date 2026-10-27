// SCP0013 pivot 파생 Auto-Sync 산식 (design 03 §2.3 / §3 gridSignals #7~#9 — cs:1610/1644/1649).
//   순수 함수로 분리해 단위 테스트로 산식을 검증한다(그리드 cellEditEnded 핸들러가 호출).

// 숫자 파싱 — 공백/빈값/파싱실패 = null.
export const toNum = (v: unknown): number | null => {
  if (v === undefined || v === null || v === '') return null;
  const n = typeof v === 'number' ? v : typeof v === 'string' ? Number(v.replace(/,/g, '')) : NaN;
  return Number.isFinite(n) ? n : null;
};

// QTY 는 정수(반올림) — design 03 §4.1 "값 타입 = 정수 QTY(반올림)". % measure(LINE_TOTAL)만 소수2(그리드 format).
export const roundQty = (n: number): number => Math.round(n);

// ISO 8601 주차 (월요일 기준) — 3단 헤더 주 span 라벨/그룹핑용 (sales-future-price isoWeek 동일).
export const isoWeek = (yyyymmdd: string): number => {
  const d = new Date(
    Date.UTC(+yyyymmdd.slice(0, 4), +yyyymmdd.slice(4, 6) - 1, +yyyymmdd.slice(6, 8))
  );
  const day = d.getUTCDay() || 7;
  d.setUTCDate(d.getUTCDate() + 4 - day);
  const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
  return Math.ceil(((d.getTime() - yearStart.getTime()) / 86400000 + 1) / 7);
};

// W_ 입력값을 하위 D_ 셀에 균등분배 + 나머지 마지막 셀 가산 (design 03 §3 #8/#9 — cs:1621~1649).
//   nDivDay = weekTotal / dayCount (정수), nDivDayMod = weekTotal % dayCount → 마지막 셀에 가산.
//   음수 weekTotal 은 분배 없이 그대로(원복은 호출부에서 nDaySum 으로 처리 — design 03 §3 #7 cs:1610).
export const distributeWeeklyToDaily = (weekTotal: number, dayCount: number): number[] => {
  if (dayCount <= 0) return [];
  const total = roundQty(weekTotal);
  const base = Math.trunc(total / dayCount);
  const remainder = total - base * dayCount;
  const out = new Array<number>(dayCount).fill(base);
  out[dayCount - 1] = base + remainder; // 나머지는 마지막 D_ 셀에 가산
  return out;
};

// 일합계 — W_ 셀 음수 입력 시 하위 D_ 합으로 원복(design 03 §3 #7 nDaySum) + 주/월 재집계 SUM.
export const sumValues = (values: unknown[]): number =>
  roundQty(values.reduce<number>((acc, v) => acc + (toNum(v) ?? 0), 0));

// 일→주, 주→월 재집계 (design 03 §2.4 CalculateSum — LINE_TOTAL% 는 평균이라 제외, 여기선 단순 SUM).
export const aggregateSum = (childValues: unknown[]): number => sumValues(childValues);

// ===== O_RC3/O_RC4 ratio 적용 (M4b — design 03 §4.2 / AS-IS Set_Ratio cs:2147~2225) =====
//   O_RC1 의 LINE_TOTAL_LOAD(%) measure 행은 pivot 집계가 아니라 working-time 비율로 표시해야 한다.
//   조회 SP 가 주(O_RC3)/월(O_RC4) ratio 를 별도 커서로 반환하므로(PKG body LINE 3581~3620, 고정 5키
//   DIVISION_ID/SCM_SITE_ID/OPERATION_ID/LINE_ID/MEASURE + 동적 W_/M_ pivot), 그 값으로 LINE_TOTAL 행의
//   W_/M_ 셀을 덮어쓴다(AS-IS 는 Tables[0] W_/M_ 를 Tables[2]/[3] 값으로 주입 cs:2184~2191). D_ 는 ratio
//   대상 아님(SP 가 D_ ratio 를 O_RC1 에 이미 포함). 비-LINE_TOTAL 행은 원본 그대로.
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
  lineTotalPrefix: string
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
    if (!measure.startsWith(lineTotalPrefix)) return row; // LINE_TOTAL_LOAD 행만 ratio 보정
    const key = ratioMatchKey(row);
    const next = { ...row };
    overlay(next, wMap.get(key), 'W_');
    overlay(next, mMap.get(key), 'M_');
    return next;
  });
};
