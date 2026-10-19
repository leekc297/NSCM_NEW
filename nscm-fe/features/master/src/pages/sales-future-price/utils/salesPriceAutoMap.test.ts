import { describe, expect, it } from 'vitest';

import type { ComboResponse } from '@foundation/models';

import {
  buildSiteEndCustomerMap,
  deriveEndCustomer,
  isAutoMappedColumn,
  stripEndCustomerComboBinding,
} from './salesPriceAutoMap';

const rows = [
  { CODE: 'SITE_A', NAME: 'Volvo' },
  { CODE: 'SITE_B', NAME: 'BMW' },
  { CODE: 'SITE_C', NAME: '-' }, // END_CUSTOMER NULL 센티널
  { CODE: 'SITE_A', NAME: 'Ford' }, // 중복 CODE — 첫 행이 이긴다
  { CODE: '', NAME: 'Ignored' }, // 코드 없는 행 무시
] as unknown as ComboResponse[];

describe('isAutoMappedColumn', () => {
  it('Team(DEPT_ID) / End Customer(END_CUSTOMER) 는 자동 매핑 컬럼', () => {
    expect(isAutoMappedColumn('DEPT_ID')).toBe(true);
    expect(isAutoMappedColumn('END_CUSTOMER')).toBe(true);
  });

  it('그 외 컬럼은 아님', () => {
    expect(isAutoMappedColumn('SCM_SITE_ID')).toBe(false);
    expect(isAutoMappedColumn('PROJECT_CODE')).toBe(false);
    expect(isAutoMappedColumn('END_CUSTOMER40')).toBe(false);
  });
});

describe('buildSiteEndCustomerMap', () => {
  it('CODE→NAME 맵을 만들고 센티널/공란/중복을 정리한다', () => {
    const map = buildSiteEndCustomerMap(rows);
    expect(map.get('SITE_A')).toBe('Volvo'); // 첫 행 우선
    expect(map.get('SITE_B')).toBe('BMW');
    expect(map.has('SITE_C')).toBe(false); // '-' 센티널 = 유효 매핑 없음
    expect(map.has('')).toBe(false);
  });

  it('undefined / 빈 배열이면 빈 맵', () => {
    expect(buildSiteEndCustomerMap(undefined).size).toBe(0);
    expect(buildSiteEndCustomerMap([]).size).toBe(0);
  });
});

describe('deriveEndCustomer', () => {
  const map = buildSiteEndCustomerMap(rows);

  it('Sales Site 코드로 End Customer 를 찾는다', () => {
    expect(deriveEndCustomer(map, 'SITE_B')).toBe('BMW');
  });

  it('Sales Site 공란이면 "" (clear)', () => {
    expect(deriveEndCustomer(map, '')).toBe('');
    expect(deriveEndCustomer(map, null)).toBe('');
    expect(deriveEndCustomer(map, undefined)).toBe('');
  });

  it('유효 매핑이 없으면 "" (clear)', () => {
    expect(deriveEndCustomer(map, 'SITE_C')).toBe(''); // 센티널로 제외됨
    expect(deriveEndCustomer(map, 'SITE_X')).toBe(''); // 미등록
  });

  it('앞뒤 공백은 무시', () => {
    expect(deriveEndCustomer(map, '  SITE_A  ')).toBe('Volvo');
  });
});

describe('stripEndCustomerComboBinding', () => {
  it('End Customer 축 바인딩만 떼고 나머지는 유지', () => {
    expect(
      stripEndCustomerComboBinding('DIVISION_ID:divisionId,END_CUSTOMER:endCustomer,DEPT_ID:deptId')
    ).toBe('DIVISION_ID:divisionId,DEPT_ID:deptId');
    expect(stripEndCustomerComboBinding('SCM_SITE_ID:endCustomer')).toBe('');
  });

  it('End Customer 바인딩이 없으면 원본 그대로', () => {
    expect(stripEndCustomerComboBinding('DIVISION_ID:divisionId')).toBe('DIVISION_ID:divisionId');
  });

  it('undefined / 공란은 그대로', () => {
    expect(stripEndCustomerComboBinding(undefined)).toBeUndefined();
    expect(stripEndCustomerComboBinding('')).toBe('');
  });
});
