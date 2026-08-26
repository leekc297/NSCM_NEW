import { describe, expect, it } from 'vitest';

import type { SalesReportRow } from '../sales-reports.types';

import {
  buildDataMap,
  filterComboRowsByRow,
  GRID_CASCADE_FILTERS,
  toCellStr,
} from './sales-reports.gridCombos';

describe('toCellStr', () => {
  it('string/number 는 그대로, 그 외 타입은 빈 문자열', () => {
    expect(toCellStr('A')).toBe('A');
    expect(toCellStr(1)).toBe('1');
    expect(toCellStr(null)).toBe('');
    expect(toCellStr(undefined)).toBe('');
  });
});

// TC-DMF0044-E/권한상세 — DEPARTMENT_ID → DEPT_ID cascade (AS-IS ComboSelChange M-6).
describe('filterComboRowsByRow (cascade)', () => {
  const src = [
    { DIVISION_ID: '40', CODE: 'T1', NAME: 'Team1', DEPARTMENT_ID: 'D1' },
    { DIVISION_ID: '40', CODE: 'T2', NAME: 'Team2', DEPARTMENT_ID: 'D2' },
  ];

  it('상위 조건(DEPARTMENT_ID)과 일치하는 콤보 행만 통과', () => {
    const row: SalesReportRow = { DEPARTMENT_ID: 'D1' };
    const result = filterComboRowsByRow(src, row, GRID_CASCADE_FILTERS.DEPT_ID);
    expect(result).toStrictEqual([src[0]]);
  });

  it('상위 조건이 공란/ALL 이면 전부 통과 (관대 통과)', () => {
    expect(
      filterComboRowsByRow(src, { DEPARTMENT_ID: '' }, GRID_CASCADE_FILTERS.DEPT_ID)
    ).toHaveLength(2);
    expect(
      filterComboRowsByRow(src, { DEPARTMENT_ID: 'ALL' }, GRID_CASCADE_FILTERS.DEPT_ID)
    ).toHaveLength(2);
  });

  it('DIVISION_ID+CODE 기준으로 중복 제거된다', () => {
    const dup = [...src, { DIVISION_ID: '40', CODE: 'T1', NAME: 'Team1-dup', DEPARTMENT_ID: 'D1' }];
    const result = filterComboRowsByRow(dup, { DEPARTMENT_ID: 'D1' }, GRID_CASCADE_FILTERS.DEPT_ID);
    expect(result).toHaveLength(1);
  });
});

describe('buildDataMap', () => {
  it('0건이면 null (하드코딩 fallback 금지)', () => {
    expect(buildDataMap([])).toBeNull();
  });

  it('행이 있으면 DataMap 인스턴스를 만든다', () => {
    const map = buildDataMap([{ CODE: 'A', NAME: 'Alpha' }]);
    expect(map).not.toBeNull();
  });
});
