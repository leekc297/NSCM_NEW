import type { DropdownOption } from '@lges/design-system';
import { createFilterOptions } from '@mui/material';

// MUI 기본 목록 필터(대소문자 무시, 부분일치). CustomDropdown 의 두 곳(filterOptions 와
// handleSelectAll)에서 같은 기준을 써야 '목록에 보이는 것'과 'SELECT ALL 이 고르는 것'이
// 어긋나지 않는다. 그래서 필터는 이 모듈 한 곳에 모은다.
export const listFilter = createFilterOptions<DropdownOption>();

/**
 * 목록 검색 필터. 검색어에 콤마가 있으면 여러 검색어로 갈라 OR 로 거른다(다중 조회 — 사용자
 * 요구 2026-09-30). 콤마가 없으면 종전과 100% 동일한 단일 부분일치라 회귀가 없다.
 *   - 각 검색어는 위 listFilter 를 그대로 태운다 — '목록에 보이는 것'(filterOptions)과
 *     'SELECT ALL 이 고르는 것'(handleSelectAll)이 같은 기준을 써야 하기 때문.
 *   - 콤마 주변 공백은 버리고 빈 토큰은 무시한다. 결과는 원본 옵션 순서를 유지한다.
 */
export const filterBySearch = (
  opts: DropdownOption[],
  inputValue: string,
  getOptionLabel: (opt: DropdownOption) => string
): DropdownOption[] => {
  if (!inputValue.includes(',')) return listFilter(opts, { inputValue, getOptionLabel });

  const terms = inputValue
    .split(',')
    .map(term => term.trim())
    .filter(Boolean);
  if (terms.length === 0) return listFilter(opts, { inputValue, getOptionLabel });

  const matched = new Set<DropdownOption>();
  for (const term of terms)
    for (const opt of listFilter(opts, { inputValue: term, getOptionLabel })) matched.add(opt);
  return opts.filter(opt => matched.has(opt));
};
