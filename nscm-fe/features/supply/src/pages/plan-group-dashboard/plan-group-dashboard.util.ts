import dayjs from '@foundation/dayjs';

import { MAX_PERIOD_DAYS } from './plan-group-dashboard.constants';

// 콤보 레지스트리(ComboResponse: [key]=string)와 proc 커서 행([key]=string|number + CRUD_TYPE?)을
//   모두 받는다 — 값은 전부 String() 으로 읽으므로 넓은 행 타입으로 둔다.
type FilterableRow = Record<string, string | number | null | undefined>;

/**
 * 조회기간 검증 — AS-IS `DateUtil.Check_PeriodDate`(cs:115-154) 1:1 이식. 유효하면 null,
 * 아니면 표시할 메시지(id/fallback/{0} 치환값)를 돌려준다. Search 직전(onSearch·F6 양 경로)에 쓴다.
 *   · 빈값/무효 날짜 → MSG00665 "조회 기간을 입력하세요."
 *   · From > To    → MSG00108 "조회 기간이 잘못되었습니다 (시작일 > 종료일)."
 *   · To ≥ From+1년+7일 → MSG01187 "최대 조회일은 From Date + {0} 입니다."({0}=371)
 */
export const validatePeriodRange = (
  startDate: string,
  endDate: string
): { id: string; fallback: string; arg?: string } | null => {
  const from = dayjs(startDate, 'YYYYMMDD');
  const to = dayjs(endDate, 'YYYYMMDD');
  if (!startDate || !endDate || !from.isValid() || !to.isValid())
    return { id: 'MSG00665', fallback: '_Please enter the search period.' };
  if (from.isAfter(to, 'day'))
    return { id: 'MSG00108', fallback: '_Invalid period (start > end).' };
  if (!to.isBefore(from.add(1, 'year').add(7, 'day'), 'day'))
    return { id: 'MSG01187', fallback: '_Maximum Period is From Date + {0}.', arg: String(MAX_PERIOD_DAYS) };
  return null;
};

/** 'ALL' / 빈 값을 sentinel 로 걸러 콤마 코드 배열만 남긴다 — cascade-combo-filter.md §2.2. */
const toSelectedCodes = (value: string): string[] =>
  (value ?? '')
    .split(',')
    .map(code => code.trim())
    .filter(code => code !== '' && code.toUpperCase() !== 'ALL');

/**
 * Division 선택값으로 Plan Group 콤보 행을 client-side 필터링 — AS-IS `RefreshPlanGroupByDivision`
 * (`DBUtils.Filter(dtPlanGroupAll, "DIVISION_ID = division")`, 02_search-combo.md §2.4)을
 * 재조회 없는 필터 방식으로 재현한다(bod.util.ts `buildDivisionFilteredOptions` 표준 패턴).
 */
export const buildDivisionFilteredOptions = (
  rows: readonly FilterableRow[] | undefined,
  divisionId: string,
  codeColumn = 'CODE',
  nameColumn = 'NAME'
): { label: string; value: string }[] => {
  const divisionCodes = toSelectedCodes(divisionId);

  const byCode = new Map<string, { label: string; value: string }>();
  for (const row of rows ?? []) {
    const code = String(row[codeColumn] ?? '').trim();
    if (code === '') continue;
    if (divisionCodes.length > 0) {
      const rowDivision = String(row.DIVISION_ID ?? '').trim();
      if (rowDivision !== '' && !divisionCodes.includes(rowDivision)) continue;
    }
    if (byCode.has(code)) continue;
    byCode.set(code, { label: String(row[nameColumn] ?? code), value: code });
  }
  return [...byCode.values()];
};
