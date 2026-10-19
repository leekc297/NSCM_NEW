import type { DropdownOption } from '@lges/design-system';
import { describe, expect, it } from 'vitest';

import { filterBySearch } from './filterBySearch';

const OPTIONS: DropdownOption[] = [
  { value: 'a', label: 'Micro_Cyl' },
  { value: 'b', label: 'Prismatic' },
  { value: 'c', label: 'Pouch' },
  { value: 'd', label: 'Cylindrical' },
];

const label = (opt: DropdownOption) => (opt.label) || '';

describe('filterBySearch — 콤마 다중 검색', () => {
  it('콤마가 없으면 단일 부분일치(기존 동작)', () => {
    const result = filterBySearch(OPTIONS, 'cyl', label);
    // 대소문자 무시 부분일치: Micro_Cyl, Cylindrical
    expect(result.map(o => o.value)).toEqual(['a', 'd']);
  });

  it('빈 검색어는 전체를 돌려준다', () => {
    expect(filterBySearch(OPTIONS, '', label)).toHaveLength(OPTIONS.length);
  });

  it('콤마로 갈라 OR 로 거른다', () => {
    const result = filterBySearch(OPTIONS, 'prismatic,pouch', label);
    expect(result.map(o => o.value)).toEqual(['b', 'c']);
  });

  it('콤마 주변 공백을 버리고 빈 토큰은 무시한다', () => {
    const result = filterBySearch(OPTIONS, ' prismatic , , pouch ', label);
    expect(result.map(o => o.value)).toEqual(['b', 'c']);
  });

  it('OR 결과는 원본 옵션 순서를 유지하고 중복 없이 합친다', () => {
    // 두 검색어가 같은 항목(Micro_Cyl)을 함께 잡아도 한 번만.
    const result = filterBySearch(OPTIONS, 'cyl,micro', label);
    expect(result.map(o => o.value)).toEqual(['a', 'd']);
  });

  it('어느 검색어에도 안 맞으면 빈 목록', () => {
    expect(filterBySearch(OPTIONS, 'xxx,yyy', label)).toEqual([]);
  });
});
