import { describe, expect, it } from 'vitest';

import { computeDrillToggles, type DynColState } from './shipment-plan-fg.drilldown';

const col = (binding: string, visible: boolean): DynColState => ({ binding, visible });

// 2월(M_202602: W 2개, 각 D 2개) 뒤에 3월(M_202603)이 이어지는 표시 순서.
const monthly = (): DynColState[] => [
  col('M_202602', true),
  col('W_20260202', false),
  col('D_20260202', false),
  col('D_20260203', false),
  col('W_20260209', false),
  col('D_20260209', false),
  col('M_202603', true),
  col('W_20260302', false),
];

describe('computeDrillToggles', () => {
  it('M_ 헤더: 다음 M_ 직전까지 W_ 를 펼치고 닫힌 D_ 는 건드리지 않는다', () => {
    const r = computeDrillToggles('M_202602', monthly());
    expect(r.get('W_20260202')).toBe(true);
    expect(r.get('W_20260209')).toBe(true);
    expect(r.has('D_20260202')).toBe(false);
    expect(r.has('M_202603')).toBe(false);
    expect(r.has('W_20260302')).toBe(false);
  });

  it('M_ 헤더: 이미 펼쳐진 W_ 는 접고 보이는 D_ 는 숨긴다', () => {
    const cols = monthly().map(c => (c.binding.startsWith('W_2026020') || c.binding === 'D_20260202' ? { ...c, visible: true } : c));
    const r = computeDrillToggles('M_202602', cols);
    expect(r.get('W_20260202')).toBe(false);
    expect(r.get('W_20260209')).toBe(false);
    expect(r.get('D_20260202')).toBe(false);
    expect(r.has('D_20260203')).toBe(false);
  });

  it('W_ 헤더: 다음 W_/M_ 직전까지 D_ 만 뒤집는다', () => {
    const r = computeDrillToggles('W_20260202', monthly());
    expect([...r.entries()]).toEqual([
      ['D_20260202', true],
      ['D_20260203', true],
    ]);
  });

  it('마지막 컬럼까지 이어지는 구간에서 종료한다', () => {
    const r = computeDrillToggles('M_202603', monthly());
    expect([...r.entries()]).toEqual([['W_20260302', true]]);
  });

  it('M_/W_ 가 아니거나 목록에 없으면 빈 결과를 돌려준다', () => {
    expect(computeDrillToggles('D_20260202', monthly()).size).toBe(0);
    expect(computeDrillToggles('M_209912', monthly()).size).toBe(0);
  });
});
