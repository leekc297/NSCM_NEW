import dayjs, { type Dayjs } from 'dayjs';

// ====================================================================================
// YearField 값 변환 (SearchFields.tsx §11-1)
//   조회조건 스토어의 yyyy 는 'YYYY' 4자리 문자열이고, 피커는 Dayjs 를 주고받는다.
//   그 사이 변환만 모아 둔다 - 잘못된 값이 조회키로 새는 경로가 여기 하나뿐이어야 한다.
// ====================================================================================

// dayjs customParseFormat plugin 미등록 환경 - YYYY-MM-DD 로 만들어 넘긴다
//   (SearchFields 의 toDayjs/ymToDayjs 와 같은 규약).
export const yearToDayjs = (value: string) =>
  /^\d{4}$/.test(value) ? dayjs(`${value}-01-01`) : null;

/**
 * 피커가 준 날짜에서 조회키로 쓸 'YYYY' 를 뽑는다. 쓸 수 없는 값이면 null.
 *
 * 주의: 입력칸을 비우면 MUI DatePicker 가 null 로 onChange 를 부르고, design-system
 *   YearPicker 가 그것을 dayjs(null) 로 감싸 넘긴다. 그 결과는 null 이 아니라 Invalid Date
 *   객체라 옵셔널 체이닝(date?.format)으로는 안 걸러지고 'Invalid Date' 문자열이 나온다.
 *   그 문자열이 스토어에 들어가면 조회 파라미터가 'Invalid Date0101' 이 되고, 편집 잠금 판정의
 *   Number(yyyy) 비교가 NaN 이 되어 과거연도 잠금이 통과된다. 반드시 isValid 로 거른다.
 */
export const yearValueOf = (date: Dayjs | null | undefined) => {
  if (!date?.isValid()) return null;
  return date.format('YYYY');
};

/**
 * 달력 마스터 콤보(CALENDAR_YYYY) 행에서 선택 가능 연도 경계를 뽑는다. CODE 가 연도 4자리다.
 * 행이 없으면 undefined - 피커가 자기 기본 범위를 쓴다.
 */
export const yearBoundsOf = (rows: Array<Record<string, unknown>> | undefined) => {
  const years = ((rows ?? []) as unknown as Array<Record<string, string>>)
    .map(row => Number(row.CODE))
    .filter(year => Number.isInteger(year) && year >= 1000 && year <= 9999);

  if (years.length === 0) return { minYear: undefined, maxYear: undefined };
  return { minYear: Math.min(...years), maxYear: Math.max(...years) };
};
