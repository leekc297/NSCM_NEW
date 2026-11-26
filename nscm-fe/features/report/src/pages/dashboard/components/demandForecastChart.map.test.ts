import { describe, expect, test } from 'vitest';

import { mapDemandTrend } from './demandForecastChart.map';

// 실제 o_rc1 = Long(CATEGORY·SERIES·VALUE). SERIES 는 actual·mktFcst·aiFcst 3종(DB 실측, handoff §4-1).
//   FE 가 카테고리 공유 Wide({x, actual, mktFcst, aiFcst})로 피벗한다. 없는 값은 null(점 없음) 보존.
const ROWS = [
  { CATEGORY: '2024-06', SERIES: 'actual', VALUE: 1300 },
  { CATEGORY: '2025-06', SERIES: 'actual', VALUE: 1340 },
  { CATEGORY: '2025-06', SERIES: 'mktFcst', VALUE: 1340 },
  { CATEGORY: '2025-06', SERIES: 'aiFcst', VALUE: 1360 },
  { CATEGORY: '2025-09', SERIES: 'mktFcst', VALUE: 1280 },
];

describe('mapDemandTrend', () => {
  test('Long → Wide 피벗, 카테고리 최초 등장 순서, 없는 값 null 보존', () => {
    expect(mapDemandTrend(ROWS)).toEqual([
      { x: '2024-06', actual: 1300, mktFcst: null, aiFcst: null },
      { x: '2025-06', actual: 1340, mktFcst: 1340, aiFcst: 1360 },
      { x: '2025-09', actual: null, mktFcst: 1280, aiFcst: null },
    ]);
  });

  test('VALUE null 행은 null 로 보존(0 으로 떨구지 않음)', () => {
    expect(mapDemandTrend([{ CATEGORY: '2025-06', SERIES: 'actual', VALUE: null }])).toEqual([
      { x: '2025-06', actual: null, mktFcst: null, aiFcst: null },
    ]);
  });

  test('빈 응답 → []', () => {
    expect(mapDemandTrend([])).toEqual([]);
  });
});
