/**
 * 편집 기준일 — AS-IS SetEditList(.cs L9128~9138) 1:1:
 * "금주 월요일(sResultYYYYMMDD) 포함 이후 Day 는 Unlock 대상".
 */
export const thisWeekMondayYmd = (today = new Date()): string => {
  const d = new Date(today);
  d.setHours(0, 0, 0, 0);
  const dow = d.getDay(); // Sun=0
  d.setDate(d.getDate() + (dow === 0 ? -6 : -(dow - 1)));
  return `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}${String(
    d.getDate()
  ).padStart(2, '0')}`;
};

/** D_yyyymmdd binding 목록에서 편집가능(금주 월요일 이후) 일자만. */
export const editableDayColumnsOf = (dayBindings: string[], today = new Date()): string[] => {
  const cutoff = thisWeekMondayYmd(today);
  return dayBindings.filter(b => b.replace('D_', '') >= cutoff);
};

/** 'YYYYMM' (당월). */
const thisYyyymm = (today: Date): string =>
  `${today.getFullYear()}${String(today.getMonth() + 1).padStart(2, '0')}`;

/** ISO 주차 번호 (1~53) — W_ 폴백 비교용. */
const isoWeekNo = (today: Date): number => {
  const d = new Date(Date.UTC(today.getFullYear(), today.getMonth(), today.getDate()));
  const dow = d.getUTCDay() || 7; // Mon=1 … Sun=7
  d.setUTCDate(d.getUTCDate() + 4 - dow); // 그 주의 목요일 = ISO 주차 소속 연도/주 결정
  const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
  return Math.ceil(((d.getTime() - yearStart.getTime()) / 86400000 + 1) / 7);
};

/**
 * 과거 구간 잠금 — M_/W_/D_ 공통. 기준은 월 컬럼 = 당월 / 주·일 컬럼 = 금주 월요일.
 *   · `M_YYYYMM`   : 당월 미만이면 잠금. 당월은 열어둔다
 *                    (현업 검수 40번 "Monthly Bucket 조회 시 Unit Price(LOC) 는 당월부터 입력 가능").
 *   · `W_YYYYMMWW` : 그 주에 속한 최소 일자가 금주 월요일 미만이면 잠금 (weekMap 없으면 년월·주차 비교로 폴백).
 *   · `D_YYYYMMDD` : 금주 월요일 미만이면 잠금 (AS-IS SetEditList — 금주 월요일 포함 이후가 Unlock).
 *
 * 공용 `@foundation/utils isNonEditableDateColumn` 을 쓰지 않는 이유 (2026-08-05 실측, 2026-08-13 재확인):
 *   그 함수는 binding 을 `substring(1)` 로 잘라 `'M_202608'` → `'_202608'` 을 dayjs 에 넘긴다.
 *   언더스코어가 남는 데다 `customParseFormat` 플러그인도 없어 파싱이 항상 Invalid 이고
 *   (`dayjs('_202608','YYYYMM').isValid() === false`), Invalid 의 `isBefore/isSame` 은 false 라
 *   결과가 언제나 false(=잠금 없음) 였다. 즉 이 화면의 과거 구간 잠금은 그동안 죽어 있었다.
 *   ⇒ 공용 함수를 고치면 이 유틸을 쓰는 다른 화면들이 (지금은 전부 잠금 없음 상태에서) 한꺼번에
 *     잠기기 시작하므로 별도 과제로 분리하고, 여기서는 화면 안에서 해결한다.
 *
 * 저장 측 `editableDayColumnsOf` 가 이미 금주 월요일 이전 D_ 를 제외하므로, 이 판정이 없으면
 * "입력은 되는데 저장에서 조용히 잘리는" 구간이 생긴다 — 두 기준을 같은 금주 월요일로 맞춘다.
 */
export const isPastPeriodLocked = (
  binding: string,
  weekMap: Map<string, Set<string>>,
  today = new Date()
): boolean => {
  if (binding.startsWith('M_')) return binding.slice(2, 8) < thisYyyymm(today);

  if (binding.startsWith('D_')) return binding.slice(2) < thisWeekMondayYmd(today);

  if (binding.startsWith('W_')) {
    // 주에 속한 일자를 알면 그게 가장 정확하다 (월경계 주 분할까지 반영).
    let minDay = '';
    weekMap.get(binding)?.forEach(day => {
      const ymd = day.replace('D_', '');
      if (minDay === '' || ymd < minDay) minDay = ymd;
    });
    if (minDay !== '') return minDay < thisWeekMondayYmd(today);
    // 폴백 — Weekly 조회처럼 D_ 컬럼이 아예 없을 때. binding = W_YYYYMM + 주차.
    const ym = binding.slice(2, 8);
    const currentYm = thisYyyymm(today);
    if (ym !== currentYm) return ym < currentYm;
    return Number(binding.slice(8)) < isoWeekNo(today);
  }

  return false;
};
