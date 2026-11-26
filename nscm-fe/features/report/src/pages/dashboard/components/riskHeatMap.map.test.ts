import { describe, expect, test } from 'vitest';

import { mapRiskHeatmap } from './riskHeatMap.map';

// 실제 o_rc1 컬럼(P_DMD0001_GET_RISK_HEATMAP): NICK_NAME·M3·M6·M12 (값 low|medium|high).
//   구간은 SP 가 3/6/12 로 확정(현재 화면과 동일).
const ROWS = [
  { NICK_NAME: 'P30B', M3: 'low', M6: 'low', M12: 'medium' },
  { NICK_NAME: 'N2.2A', M3: 'medium', M6: 'high', M12: 'high' },
];

describe('mapRiskHeatmap', () => {
  test('NICK_NAME/M3/M6/M12 → RiskRow', () => {
    expect(mapRiskHeatmap(ROWS)).toEqual([
      { product: 'P30B', m3: 'low', m6: 'low', m12: 'medium' },
      { product: 'N2.2A', m3: 'medium', m6: 'high', m12: 'high' },
    ]);
  });

  test('미지 등급값은 low 로 방어', () => {
    expect(mapRiskHeatmap([{ NICK_NAME: 'X', M3: '', M6: 'zzz', M12: null }])).toEqual([
      { product: 'X', m3: 'low', m6: 'low', m12: 'low' },
    ]);
  });

  test('빈 응답 → []', () => {
    expect(mapRiskHeatmap([])).toEqual([]);
  });
});
