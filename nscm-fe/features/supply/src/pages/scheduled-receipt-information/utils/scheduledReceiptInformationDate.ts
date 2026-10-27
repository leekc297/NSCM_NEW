import dayjs from 'dayjs';

// From Date 기본값 — AS-IS setDatePicker() 재현(gap-resolve/iter-1 정정, .cs:215-229):
//   `DateTime.Today.AddDays(DayOfWeek.Monday - Today.DayOfWeek)`. C# DayOfWeek 은 Sunday=0 ~
//   Saturday=6(dayjs().day()와 동일 체계) — 일요일(0)엔 AddDays(1-0)=+1(다음날인 월요일)이 되어
//   ISO 기준 "그 주의 월요일"이 아니라 "다음날"을 반환한다. 이전 회차 구현(ISO 기준 dow=7 취급,
//   일요일에 -6일)은 이 지점에서 AS-IS 와 정반대 방향이었다(gap-resolve/iter-1 G6 로 발견).
export const thisWeekMonday = (): string => {
  const d = dayjs();
  return d.add(1 - d.day(), 'day').format('YYYYMMDD');
};

// Scheduled Receipt 조회 proc 은 TO_YYYYMMDD 를 날짜형(TO_DATE)으로 돌려줘(BE 직렬화 시
//   "2026-10-19 00:00:00") 그리드에 시간까지 노출된다. Arrival Date 는 날짜 필드(design 03 §1.1,
//   Virtual Bom 의 'YYYY-MM-DD' 문자열과 동형)라 날짜-only 로 정규화한다. 표시뿐 아니라 저장도
//   바로잡힌다 — 정규화 안 하면 재저장 시 셀값 "2026-10-19 00:00:00" 이 payload 로 새어
//   TO_YYYYMMDD='20261019 00:00:00' 가 된다(저장 빌더 ymd8 은 하이픈만 제거). 멱등(이미 날짜-only
//   면 그대로). 입력: 날짜형 문자열 / 'YYYY-MM-DD' / 'YYYYMMDD' 모두 허용.
export const toDisplayYmd = (value: WijmoPrimitive): string => {
  if (value == null) return '';
  if (value instanceof Date) return dayjs(value).format('YYYY-MM-DD');
  const s = String(value).trim();
  if (!s) return '';
  const datePart = s.split(/[ T]/)[0];
  const digits = datePart.replace(/-/g, '');
  return /^\d{8}$/.test(digits)
    ? `${digits.slice(0, 4)}-${digits.slice(4, 6)}-${digits.slice(6, 8)}`
    : datePart;
};
