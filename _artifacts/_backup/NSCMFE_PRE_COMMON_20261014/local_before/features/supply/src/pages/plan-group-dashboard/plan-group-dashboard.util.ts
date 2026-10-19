import type { ComboResponse } from '@foundation/models';

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
  rows: ComboResponse[] | undefined,
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
