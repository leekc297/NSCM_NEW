import { describe, expect, it } from 'vitest';

import {
  aggregateSum,
  distributeWeeklyToDaily,
  isoWeek,
  roundQty,
  sumValues,
  toNum,
} from './productionPlanLineDerive';

describe('productionPlanLineDerive', () => {
  it('toNum — 콤마/공백/빈값 처리', () => {
    expect(toNum('1,234')).toBe(1234);
    expect(toNum('')).toBeNull();
    expect(toNum(null)).toBeNull();
    expect(toNum('abc')).toBeNull();
    expect(toNum(42)).toBe(42);
  });

  it('roundQty — 정수 반올림', () => {
    expect(roundQty(10.4)).toBe(10);
    expect(roundQty(10.5)).toBe(11);
  });

  it('distributeWeeklyToDaily — 균등분배 + 나머지 마지막 셀 (cs:1621~1649)', () => {
    // 10 / 3 = 3,3,4 (나머지 1 → 마지막)
    expect(distributeWeeklyToDaily(10, 3)).toEqual([3, 3, 4]);
    // 나눠떨어지면 균등
    expect(distributeWeeklyToDaily(9, 3)).toEqual([3, 3, 3]);
    // 합은 항상 원래 주합계와 일치
    const d = distributeWeeklyToDaily(100, 7);
    expect(sumValues(d)).toBe(100);
    expect(distributeWeeklyToDaily(5, 0)).toEqual([]);
  });

  it('distributeWeeklyToDaily — 음수 주합계도 합 보존', () => {
    const d = distributeWeeklyToDaily(-10, 4);
    expect(sumValues(d)).toBe(-10);
  });

  it('sumValues / aggregateSum — 일→주 재집계, 파싱실패는 0', () => {
    expect(sumValues([1, '2', '', null, '3'])).toBe(6);
    expect(aggregateSum(['10', 20, 'x'])).toBe(30);
  });

  it('isoWeek — ISO 8601 월요일 기준', () => {
    // 2026-01-01(목) = ISO week 1
    expect(isoWeek('20260101')).toBe(1);
    // 2026-01-05(월) = week 2
    expect(isoWeek('20260105')).toBe(2);
  });
});
