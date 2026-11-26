import { describe, expect, test } from 'vitest';

import { mapCoverTrend } from './coverMonthChart.map';

// 실제 o_rc1 = Long(CATEGORY·SERIES·VALUE). SERIES = 모델코드(동적). FE 가 멀티라인으로 피벗한다.
//   바인딩 키는 모델코드(점 포함 'N2.2A' 는 wijmo 경로로 깨짐)가 아니라 인덱스 키(v0·v1…)를 쓰고
//   표시명만 모델코드로 둔다. PRODUCT_COLORS 에 없는 미지 모델코드도 시리즈로 포함한다.
const ROWS = [
  { CATEGORY: '2025-05', SERIES: 'P30B', VALUE: 24 },
  { CATEGORY: '2025-05', SERIES: 'N2.2A', VALUE: 16 },
  { CATEGORY: '2025-07', SERIES: 'P30B', VALUE: 22.8 },
  { CATEGORY: '2025-07', SERIES: 'ZZ9', VALUE: 5 },
];

describe('mapCoverTrend', () => {
  test('동적 모델코드 시리즈를 인덱스 키로 피벗 + 미지 코드 포함 + 없는 값 null', () => {
    const vm = mapCoverTrend(ROWS);
    expect(vm.series).toEqual([
      { key: 'v0', name: 'P30B' },
      { key: 'v1', name: 'N2.2A' },
      { key: 'v2', name: 'ZZ9' },
    ]);
    expect(vm.points).toEqual([
      { x: '2025-05', v0: 24, v1: 16, v2: null },
      { x: '2025-07', v0: 22.8, v1: null, v2: 5 },
    ]);
  });

  test('빈 응답 → 시리즈/포인트 모두 빈 배열', () => {
    expect(mapCoverTrend([])).toEqual({ series: [], points: [] });
  });
});
