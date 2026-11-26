import { describe, expect, test } from 'vitest';

import { mapProductStatus } from './productStatusGrid.map';

// 실제 o_rc1 컬럼(P_DMD0001_GET_PRODUCT_STATUS):
//   NICK_NAME·END_CUSTOMER·BIZ_TYPE·STOCK(숫자)·COVER(숫자)·SHORTAGE_MONTH(null 가능)·ACTION_CODE.
const ROWS = [
  { NICK_NAME: 'P30B', END_CUSTOMER: 'Volvo', BIZ_TYPE: 'Module', STOCK: 1200, COVER: 18, SHORTAGE_MONTH: null, ACTION_CODE: 'KEEP' },
  { NICK_NAME: 'N2.2A', END_CUSTOMER: 'GM', BIZ_TYPE: 'Pack', STOCK: 500, COVER: 4, SHORTAGE_MONTH: '2026-03', ACTION_CODE: 'PRODUCE' },
];

describe('mapProductStatus', () => {
  test('컬럼 매핑 + ACTION_CODE→코드/톤/신호등(라벨은 컴포넌트 i18n), null shortage→–, 숫자 포맷', () => {
    const rows = mapProductStatus(ROWS);
    expect(rows[0]).toEqual({
      product: 'P30B',
      oem: 'Volvo',
      bizType: 'Module',
      stock: '1,200',
      cover: '18.0',
      shortageMonth: '–',
      actionCode: 'KEEP',
      actionTone: 'keep',
      status: 'green',
    });
    expect(rows[1]).toMatchObject({
      stock: '500',
      cover: '4.0',
      shortageMonth: '2026-03',
      actionCode: 'PRODUCE',
      actionTone: 'produce',
      status: 'red',
    });
  });

  test('빈 응답 → 빈 배열', () => {
    expect(mapProductStatus([])).toEqual([]);
  });
});
