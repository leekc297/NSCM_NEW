import { describe, expect, test } from 'vitest';

import { mapMape } from './mapeChart.map';

// 실제 o_rc1 컬럼(P_DMD0001_GET_MAPE): NICK_NAME·MAPE(제품 오차율%)·OVERALL_ACCURACY(행마다 동일).
//   전체 정확도는 막대 평균이 아니라 SP 가 내려주는 별개 값(100−평균오차율 아님, handoff §6).
const ROWS = [
  { NICK_NAME: 'P30B', MAPE: 18, OVERALL_ACCURACY: 82 },
  { NICK_NAME: 'N2.2A', MAPE: 24, OVERALL_ACCURACY: 82 },
];

describe('mapMape', () => {
  test('막대(제품별 오차율) + 전체 정확도(별개 값)', () => {
    expect(mapMape(ROWS)).toEqual({
      bars: [
        { product: 'P30B', value: 18 },
        { product: 'N2.2A', value: 24 },
      ],
      avg: '82',
    });
  });

  test('빈 응답 → 빈 막대 + 빈 정확도', () => {
    expect(mapMape([])).toEqual({ bars: [], avg: '' });
  });
});
