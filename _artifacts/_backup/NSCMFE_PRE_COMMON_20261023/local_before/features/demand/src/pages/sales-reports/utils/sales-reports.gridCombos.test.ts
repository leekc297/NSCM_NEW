import { describe, expect, it } from 'vitest';

import type { SalesReportRow } from '../sales-reports.types';

import {
  applyDeptIdChange,
  buildDataMap,
  DEPT_CHANGE_CLEAR,
  ETC_SALES_ITEM,
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

// REQ:CHAT-20260828-05 — DEPT_ID(팀) 변경 cascade (AS-IS spdMain_Changed L1370~1452 3분기 1:1)
describe('applyDeptIdChange', () => {
  const base = (): SalesReportRow =>
    ({
      DEPARTMENT_ID: 'D1',
      DEPT_ID: 'T1',
      ITEM_ID: 'M-1',
      NICK_NAME: 'Model 1',
      END_CUST_REPORT: 'E',
      CUST_REPORT: 'C',
      PRODUCT_GROUP: 'P',
    }) as unknown as SalesReportRow;

  it('DEPARTMENT_ID 공란 → 하위 3컬럼만 clear, MODEL 은 보존 (else 분기)', () => {
    const row = base();
    (row as Record<string, unknown>).DEPARTMENT_ID = '';
    const changed = applyDeptIdChange(row);
    expect(changed).toEqual([...DEPT_CHANGE_CLEAR]);
    expect(row.ITEM_ID).toBe('M-1');
    expect(row.END_CUST_REPORT).toBe('');
    expect(row.CUST_REPORT).toBe('');
    expect(row.PRODUCT_GROUP).toBe('');
  });

  it("팀 != 'MDF' → MODEL/모델명 = '기타매출' 강제 + 3컬럼 clear", () => {
    const row = base();
    const changed = applyDeptIdChange(row);
    expect(row.ITEM_ID).toBe(ETC_SALES_ITEM);
    expect(row.NICK_NAME).toBe(ETC_SALES_ITEM);
    expect(changed).toEqual([...DEPT_CHANGE_CLEAR, 'ITEM_ID', 'NICK_NAME']);
  });

  it("팀 == 'MDF'(코드) → MODEL/모델명 clear (팝업으로 고르게)", () => {
    const row = base();
    (row as Record<string, unknown>).DEPT_ID = 'MDF';
    applyDeptIdChange(row);
    expect(row.ITEM_ID).toBe('');
    expect(row.NICK_NAME).toBe('');
  });

  it("표시명이 'MDF' 인 코드도 teamNameOf 로 MDF 판정 (코드 우선)", () => {
    const row = base();
    (row as Record<string, unknown>).DEPT_ID = 'T9';
    applyDeptIdChange(row, code => (code === 'T9' ? 'MDF' : ''));
    expect(row.ITEM_ID).toBe('');
  });
});
