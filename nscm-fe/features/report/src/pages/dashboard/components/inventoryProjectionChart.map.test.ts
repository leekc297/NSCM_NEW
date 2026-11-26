import { describe, expect, test } from 'vitest';

import { mapInventoryProjection } from './inventoryProjectionChart.map';

// 실제 o_rc1 = Long(CATEGORY·SERIES·VALUE·LABEL). SERIES: onHand·demand·inbound·safety + shortageMark
//   (부족 시작 마커 — VALUE 없음, LABEL 에 문구). FE 가 4개 수치 시리즈를 Wide 로 피벗 + 마커 추출.
const ROWS = [
  { CATEGORY: '2025-05', SERIES: 'onHand', VALUE: 1500, LABEL: null },
  { CATEGORY: '2025-05', SERIES: 'demand', VALUE: 1500, LABEL: null },
  { CATEGORY: '2025-05', SERIES: 'safety', VALUE: 400, LABEL: null },
  { CATEGORY: '2025-07', SERIES: 'onHand', VALUE: 1286, LABEL: null },
  { CATEGORY: '2026-03', SERIES: 'shortageMark', VALUE: null, LABEL: '예상 부족 시작\n2026-03' },
];

describe('mapInventoryProjection', () => {
  test('4개 수치 시리즈 피벗(없는 값 null) + shortageMark 추출', () => {
    expect(mapInventoryProjection(ROWS)).toEqual({
      points: [
        { x: '2025-05', onHand: 1500, demand: 1500, inbound: null, safety: 400 },
        { x: '2025-07', onHand: 1286, demand: null, inbound: null, safety: null },
      ],
      shortageMark: { x: '2026-03', label: '예상 부족 시작\n2026-03' },
    });
  });

  test('shortageMark 행 없으면 null, 그 category 로 빈 포인트 만들지 않음', () => {
    const { points, shortageMark } = mapInventoryProjection([
      { CATEGORY: '2025-05', SERIES: 'onHand', VALUE: 1500, LABEL: null },
    ]);
    expect(points).toEqual([{ x: '2025-05', onHand: 1500, demand: null, inbound: null, safety: null }]);
    expect(shortageMark).toBeNull();
  });
});
