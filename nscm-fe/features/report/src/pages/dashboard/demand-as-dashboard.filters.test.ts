import { describe, expect, test } from 'vitest';

import { buildBaseFilters, toBizTypeToken } from './demand-as-dashboard.filters';

describe('demand-as-dashboard.filters', () => {
  test('toBizTypeToken: 전체 → ALL, 그 외 라벨 그대로', () => {
    expect(toBizTypeToken('전체')).toBe('ALL');
    expect(toBizTypeToken('Cell')).toBe('Cell');
  });

  test('buildBaseFilters: searchParams → proc 요청 키(camel). baseMonth(YYYYMMDD CODE)는 그대로 yyyymmdd', () => {
    expect(buildBaseFilters({ baseMonth: '20261116', bizType: '전체', oem: '전체' })).toEqual({
      divisionId: '81',
      yyyymmdd: '20261116',
      bizType: 'ALL',
      endCustomer: 'ALL',
    });
  });
});
