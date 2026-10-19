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
