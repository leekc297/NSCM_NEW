import { describe, expect, it } from 'vitest';

import { createSameCellDblClickGuard } from './shipment-plan.dblClickGuard';

const A = { row: 3, col: 5 };
const B = { row: 3, col: 6 };
const C = { row: 4, col: 5 };

describe('createSameCellDblClickGuard', () => {
  it('같은 셀 2회 클릭 뒤의 dblclick 은 통과한다', () => {
    const g = createSameCellDblClickGuard();
    g.track(A);
    g.track(A);
    expect(g.accepts(A)).toBe(true);
  });

  it('다른 셀을 연속 클릭하면 통과하지 않는다 — 보고된 오조회 경로', () => {
    const g = createSameCellDblClickGuard();
    g.track(A);
    g.track(B);
    expect(g.accepts(B)).toBe(false);
  });

  it('같은 열 다른 행도 다른 셀로 본다', () => {
    const g = createSameCellDblClickGuard();
    g.track(A);
    g.track(C);
    expect(g.accepts(C)).toBe(false);
  });

  it('헤더·빈 영역(null) 뒤의 셀 클릭은 같은 셀 2회가 아니다', () => {
    const g = createSameCellDblClickGuard();
    g.track(null);
    g.track(A);
    expect(g.accepts(A)).toBe(false);
  });

  it('클릭 1회만으로는 통과하지 않는다', () => {
    const g = createSameCellDblClickGuard();
    g.track(A);
    expect(g.accepts(A)).toBe(false);
  });

  it('클릭 기록이 없으면 통과하지 않는다', () => {
    const g = createSameCellDblClickGuard();
    expect(g.accepts(A)).toBe(false);
  });

  it('dblclick 위치가 직전 클릭 셀과 다르면 통과하지 않는다', () => {
    const g = createSameCellDblClickGuard();
    g.track(A);
    g.track(A);
    expect(g.accepts(B)).toBe(false);
  });

  it('판정 후 초기화된다 — 세 번째 클릭이 직전 쌍에 얹혀 재발화하지 않는다', () => {
    const g = createSameCellDblClickGuard();
    g.track(A);
    g.track(A);
    expect(g.accepts(A)).toBe(true);
    g.track(A); // 세 번째 클릭
    expect(g.accepts(A)).toBe(false);
  });

  it('통과 실패 후에도 같은 셀 2회면 다시 통과한다', () => {
    const g = createSameCellDblClickGuard();
    g.track(A);
    g.track(B);
    expect(g.accepts(B)).toBe(false);
    g.track(B);
    g.track(B);
    expect(g.accepts(B)).toBe(true);
  });
});
