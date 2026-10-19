// ⭐ 수량/금액 Bucket 배분 공통 유틸 (2026-07-21 사용자 확정 룰 — DMF0021 최초 적용, 전 화면 공통 표준).
//
//   룰1 (월 → 주): 월 수량 입력 시 주별 "월내 기여 일수" Rate 산출 후 주별 배분.
//        끝자리(rounding 잔여)는 마지막 주차에 +/- 로 처리 (음수 잔여 포함 — 총합 보존).
//   룰2 (주 → 일): 주 수량 입력 시 주내 적용요일(7bit)이 있으면 적용요일에 배분(잔여=마지막 적용일),
//        적용요일 정보가 없으면 월요일에 전량.
//
//   순수 함수(의존성 0) — 화면별 그리드/저장 구조와 무관하게 재사용.
//   주 태그 규약 = GET_SPREAD_TITLE 공통: 'W_' + yyyymm + ISO주차 2자리 (월경계 주는 월별 분할 — 각 월 컨텍스트 유지).
//   요일 비트 규약 = SUN-first 7자리 ('V_SUN..V_SAT', index 0=일 … 6=토) — DM_MST_BUCKET_CONVERSION 표준.
//
//   사용처: DMF0021 sales-plan(save 월→주 분할). DMF0082/DMF0003 은 AS-IS 1:1 자체 배분 보유(동일 룰 정합 교정 완료)
//   — 신규 화면에 배분이 필요하면 본 유틸 사용.

// 월 안의 한 주 (월경계 분할 컨텍스트) — daysInMonth = 그 주가 해당 월에 기여하는 일수(1~7).
export interface WeekOfMonth {
  /** 'W_' + yyyymm + ISO주차 2자리 (예: W_20260729) */
  key: string;
  /** ISO 주차 (1~53) */
  isoWeek: number;
  /** 이 주가 해당 월에 포함하는 일수 (월경계 주는 7 미만) */
  daysInMonth: number;
}

// ── ISO 주차 산출 (UTC 산술 — 시차 오차 배제) ──────────────────────────────
const isoWeekOfUtc = (d: Date): { year: number; week: number } => {
  // ISO-8601: 목요일 기준 — 해당 주 목요일이 속한 연도의 주차
  const t = new Date(Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate()));
  const day = t.getUTCDay() || 7; // 1=월 … 7=일
  t.setUTCDate(t.getUTCDate() + 4 - day); // 그 주 목요일
  const isoYear = t.getUTCFullYear();
  const yearStart = new Date(Date.UTC(isoYear, 0, 1));
  const week = Math.ceil(((t.getTime() - yearStart.getTime()) / 86400000 + 1) / 7);
  return { year: isoYear, week };
};

/**
 * yyyymm 의 ISO 주 분해 — 달력 순서, 월경계 주는 "월내 기여 일수"만 계상.
 * 주 태그의 yyyymm 은 항상 입력 월 (GET_SPREAD_TITLE 월경계 분할 규약과 동일).
 */
export const isoWeeksOfMonth = (yyyymm: string): WeekOfMonth[] => {
  if (!/^\d{6}$/.test(yyyymm)) return [];
  const y = Number(yyyymm.slice(0, 4));
  const m = Number(yyyymm.slice(4, 6)) - 1;
  const lastDay = new Date(Date.UTC(y, m + 1, 0)).getUTCDate();
  const out: WeekOfMonth[] = [];
  for (let day = 1; day <= lastDay; day++) {
    const { week } = isoWeekOfUtc(new Date(Date.UTC(y, m, day)));
    const key = `W_${yyyymm}${String(week).padStart(2, '0')}`;
    const prev = out[out.length - 1];
    if (prev && prev.key === key) prev.daysInMonth += 1;
    else out.push({ key, isoWeek: week, daysInMonth: 1 });
  }
  return out;
};

export interface WeekDistribution {
  key: string;
  qty: number;
}

/**
 * 룰1 — 월 수량 → 주별 배분.
 *   perDay = trunc(monthQty / 월 총일수) → 주별 = perDay × 주 월내일수.
 *   끝자리(monthQty − Σ주별)는 마지막 주에 +/- 가산 (음수 포함 — 총합 = monthQty 보존).
 *   unit: 배분 최소 단위 (수량=1 기본, 금액 등 소수 measure 는 0.001 등) — trunc 를 unit 배수로.
 */
export const distributeMonthToWeeks = (
  monthQty: number,
  weeks: WeekOfMonth[],
  unit = 1
): WeekDistribution[] => {
  if (weeks.length === 0) return [];
  const totalDays = weeks.reduce((s, w) => s + w.daysInMonth, 0);
  if (totalDays <= 0) return weeks.map(w => ({ key: w.key, qty: 0 }));

  // 부동소수 오차 배제 — unit 역수(scale) 정수 산술 (0.001 단위 등)
  const scale = Math.round(1 / unit);
  const perDayScaled = Math.trunc((monthQty * scale) / totalDays); // trunc(월값/월일수) @unit
  const out: WeekDistribution[] = weeks.map(w => ({
    key: w.key,
    qty: (perDayScaled * w.daysInMonth) / scale,
  }));
  const distributedScaled = perDayScaled * totalDays;
  // 끝자리(±) = 마지막 주차 (음수 포함 — 총합 = monthQty 보존)
  const remnantScaled = Math.round(monthQty * scale) - distributedScaled;
  if (remnantScaled !== 0) {
    const last = out[out.length - 1];
    last.qty = (perDayScaled * weeks[weeks.length - 1].daysInMonth + remnantScaled) / scale;
  }
  return out;
};

// 주내 하루 (요일 포함) — dow: SUN-first (0=일 … 6=토, JS getUTCDay 규약)
export interface DayOfWeekCell {
  key: string;
  dow: number;
}

export interface DayDistribution {
  key: string;
  qty: number;
}

/**
 * 룰2 — 주 수량 → 주내 일 배분.
 *   applicableMask(7bit SUN-first) 의 적용요일에 trunc 균등 배분 + 잔여 = 마지막 적용일.
 *   적용요일이 하나도 없으면(마스크 없음·전부 0·주 범위 밖) 월요일(dow===1)에 전량 —
 *   주 범위에 월요일이 없으면(월경계 분할 주) 첫 일자에 전량.
 *   나머지 일자는 0.
 */
export const distributeWeekToDays = (
  weekQty: number,
  days: DayOfWeekCell[],
  applicableMask: string,
  unit = 1
): DayDistribution[] => {
  if (days.length === 0) return [];
  const mask = /^[01]{7}$/.test(applicableMask) ? applicableMask : '0000000';
  const applicable = days.filter(d => mask.charAt(d.dow) === '1');

  const out = new Map<string, number>(days.map(d => [d.key, 0]));

  if (applicable.length === 0) {
    // 적용요일 없음 → 월요일 전량 (없으면 첫 일자)
    const monday = days.find(d => d.dow === 1) ?? days[0];
    out.set(monday.key, weekQty);
  } else {
    // 부동소수 오차 배제 — unit 역수(scale) 정수 산술
    const scale = Math.round(1 / unit);
    const perScaled = Math.trunc((weekQty * scale) / applicable.length);
    let remainedScaled = Math.round(weekQty * scale);
    applicable.forEach((d, i) => {
      const qScaled = i === applicable.length - 1 ? remainedScaled : perScaled; // 마지막 적용일 = 잔여 전액(±)
      out.set(d.key, qScaled / scale);
      remainedScaled -= qScaled;
    });
  }
  return days.map(d => ({ key: d.key, qty: out.get(d.key) ?? 0 }));
};
