import { describe, expect, test } from 'vitest';

import { mapExcess } from './excessStatus.map';

// 실제 o_rc1 컬럼(P_DMD0001_GET_EXCESS): NICK_NAME·STOCK·DEMAND_12M·EXCESS_AMOUNT(억원, null 가능).
//   Excess(EA)=STOCK−DEMAND_12M(0 이하 '–'), 합계행·위험금액은 FE 산출(handoff §5, rules.computeExcessEa).
const ROWS = [
  { NICK_NAME: 'P39', STOCK: 2100, DEMAND_12M: 800, EXCESS_AMOUNT: 10.4 },
  { NICK_NAME: 'P30B', STOCK: 1200, DEMAND_12M: 1100, EXCESS_AMOUNT: 0.8 },
  { NICK_NAME: 'N2.2A', STOCK: 500, DEMAND_12M: 1200, EXCESS_AMOUNT: null },
];

describe('mapExcess', () => {
  test('제품행 매핑 + Excess(EA) 산출(음수 → –) + 합계행 + 위험금액', () => {
    const { rows, riskAmount } = mapExcess(ROWS, '합계');
    expect(rows[0]).toEqual({
      product: 'P39',
      stock: '2,100',
      demand12m: '800',
      excessEa: '1,300',
      excessAmount: '10.4',
    });
    // N2.2A: 500−1200 < 0 → Excess 없음 '–', 금액 null → '–'
    expect(rows[2]).toEqual({
      product: 'N2.2A',
      stock: '500',
      demand12m: '1,200',
      excessEa: '–',
      excessAmount: '–',
    });
    // 합계행: Excess(EA) 1300+100+0=1400, 금액 10.4+0.8+0=11.2
    expect(rows[3]).toEqual({
      product: '합계',
      stock: '–',
      demand12m: '–',
      excessEa: '1,400',
      excessAmount: '11.2',
    });
    expect(riskAmount).toBe('11.2');
  });

  test('빈 응답 → 합계행만(0) + 위험금액 0.0', () => {
    const { rows, riskAmount } = mapExcess([], '합계');
    expect(rows).toEqual([
      { product: '합계', stock: '–', demand12m: '–', excessEa: '0', excessAmount: '0.0' },
    ]);
    expect(riskAmount).toBe('0.0');
  });
});
