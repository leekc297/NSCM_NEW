import { describe, expect, it } from 'vitest';

import type { ComboResponse } from '@foundation/models';

import { buildSalesSite, resolveComboCodeByDivision } from './sales-site.util';

/**
 * Sales Site 채번은 Sold To Customer 의 CODE 로 한다. 셀에 NAME 이 들어와 있으면
 * 콤보에서 CODE 를 되찾아 써야 한다 - NAME 이 그대로 나가면 '코람(논산)_NZ_WKE' 같은
 * 사람 이름이 박힌 ID 가 만들어진다.
 */
const COMBO = [
  { DIVISION_ID: '81', CODE: 'KRM', NAME: '코람(논산)' },
  { DIVISION_ID: '81', CODE: 'LGE', NAME: 'LG전자' },
  { DIVISION_ID: '90', CODE: 'LGE', NAME: 'LG ENERGY SOLUTION' },
] as unknown as ComboResponse[];

describe('resolveComboCodeByDivision', () => {
  it('셀에 NAME 이 들어와 있으면 같은 division 의 CODE 로 되돌린다', () => {
    expect(resolveComboCodeByDivision(COMBO, '81', '코람(논산)')).toBe('KRM');
  });

  it('셀 값이 이미 CODE 면 그대로 둔다', () => {
    expect(resolveComboCodeByDivision(COMBO, '81', 'LGE')).toBe('LGE');
  });

  it('CODE 가 division 별로 중복돼도 자기 division 의 NAME 을 먼저 본다', () => {
    expect(resolveComboCodeByDivision(COMBO, '90', 'LG ENERGY SOLUTION')).toBe('LGE');
    expect(resolveComboCodeByDivision(COMBO, '81', 'LG전자')).toBe('LGE');
  });

  it('콤보의 DIVISION_ID 가 숫자로 내려와도 문자열 행과 맞춘다', () => {
    const numeric = [
      { DIVISION_ID: 81, CODE: 'KRM', NAME: '코람(논산)' },
    ] as unknown as ComboResponse[];
    expect(resolveComboCodeByDivision(numeric, '81', '코람(논산)')).toBe('KRM');
  });

  it('division 컬럼이 DIVISION_CODE 로 내려와도 맞춘다', () => {
    const renamed = [
      { DIVISION_CODE: '81', CODE: 'KRM', NAME: '코람(논산)' },
    ] as unknown as ComboResponse[];
    expect(resolveComboCodeByDivision(renamed, '81', '코람(논산)')).toBe('KRM');
  });

  it('division 으로 못 찾으면 division 을 무시하고 NAME 으로 다시 찾는다', () => {
    expect(resolveComboCodeByDivision(COMBO, '99', '코람(논산)')).toBe('KRM');
  });

  it('콤보에 없는 값은 그대로 돌려준다', () => {
    expect(resolveComboCodeByDivision(COMBO, '81', '없는고객')).toBe('없는고객');
    expect(resolveComboCodeByDivision([], '81', '코람(논산)')).toBe('코람(논산)');
  });
});

describe('buildSalesSite', () => {
  it('CODE + Country + City 뒤 3자리로 조합한다', () => {
    const row = { SOLDTO_CUSTOMER: '코람(논산)', COUNTRY: 'NZ', CITY: 'NZWKE' };
    expect(buildSalesSite(row, resolveComboCodeByDivision(COMBO, '81', '코람(논산)'))).toBe(
      'KRM_NZ_WKE'
    );
  });

  it('Country 나 City 가 비면 채번하지 않는다', () => {
    expect(buildSalesSite({ SOLDTO_CUSTOMER: 'KRM', COUNTRY: '', CITY: 'NZWKE' })).toBe('');
    expect(buildSalesSite({ SOLDTO_CUSTOMER: 'KRM', COUNTRY: 'NZ', CITY: '' })).toBe('');
  });
});

/**
 * 실제 EndCustomer 콤보는 CODE 와 NAME 이 똑같은 한글 값으로 내려온다
 * (admin/combo {comboId:'EndCustomer'} -> {CODE:'중국Mobile(개발)', NAME:'중국Mobile(개발)', DIVISION_ID:'40'}).
 * 그래서 CODE 로 채번해도 결과가 이름처럼 보인다. 저장에 나가는 값이 CODE 인지 여기서 못박는다.
 */
describe('CODE 와 NAME 이 같은 한글 콤보', () => {
  const KOREAN_COMBO = [
    {
      SRC_TYPE: 'LOOKUP',
      CODE: '중국Mobile(개발)',
      NAME: '중국Mobile(개발)',
      DIVISION_ID: '40',
      DIVISION_NAME: 'Mobility & IT Battery',
      KEEP_STRICT: 'Y',
    },
  ] as unknown as ComboResponse[];

  it('셀 값(CODE)을 그대로 CODE 로 돌려준다', () => {
    expect(resolveComboCodeByDivision(KOREAN_COMBO, '40', '중국Mobile(개발)')).toBe(
      '중국Mobile(개발)'
    );
  });

  it('SalesSite.tsx handleSave 와 같은 매핑을 거쳐도 CODE 가 payload 에 실린다', () => {
    const row = {
      DIVISION_ID: '40',
      END_CUSTOMER: '중국Mobile(개발)',
      SOLDTO_CUSTOMER: '중국Mobile(개발)',
      COUNTRY: 'NZ',
      CITY: 'NZWKE',
    };

    const payload = {
      ...row,
      END_CUSTOMER: resolveComboCodeByDivision(
        KOREAN_COMBO,
        row.DIVISION_ID,
        String(row.END_CUSTOMER)
      ),
      SOLDTO_CUSTOMER: resolveComboCodeByDivision(
        KOREAN_COMBO,
        row.DIVISION_ID,
        String(row.SOLDTO_CUSTOMER)
      ),
    };

    expect(payload.END_CUSTOMER).toBe(KOREAN_COMBO[0].CODE);
    expect(payload.SOLDTO_CUSTOMER).toBe(KOREAN_COMBO[0].CODE);
    expect(buildSalesSite(row, payload.SOLDTO_CUSTOMER)).toBe('중국Mobile(개발)_NZ_WKE');
  });
});
