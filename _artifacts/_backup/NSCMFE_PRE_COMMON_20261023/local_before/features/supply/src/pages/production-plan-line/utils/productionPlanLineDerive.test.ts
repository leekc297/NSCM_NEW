import { describe, expect, it } from 'vitest';

import {
  aggregateSum,
  applyRatio,
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

  it('applyRatio — LINE_TOTAL 행의 W_/M_ 만 ratio 로 덮어씀 (M4b)', () => {
    const key = { DIVISION_ID: '81', SCM_SITE_ID: 'S1', OPERATION_ID: 'O1', LINE_ID: 'L1' };
    const rows = [
      // LINE_TOTAL 행 — W_/M_ 가 ratio 로 교체되어야 함(D_ 는 보존)
      { ...key, MEASURE: 'LINE_TOTAL_LOAD_ENGINE', D_20260105: 7, W_202602: 0, M_202601: 0 },
      // 일반 QTY 행 — 보정 안 함
      { ...key, MEASURE: 'PROD_PLAN_AMEND', W_202602: 123, M_202601: 456 },
    ];
    const week = [{ ...key, MEASURE: 'LINE_TOTAL_LOAD_ENGINE', W_202602: 95.5 }];
    const month = [{ ...key, MEASURE: 'LINE_TOTAL_LOAD_ENGINE', M_202601: 88.2 }];
    const out = applyRatio(rows, week, month, 'LINE_TOTAL');
    expect(out[0].W_202602).toBe(95.5); // ratio 주입
    expect(out[0].M_202601).toBe(88.2);
    expect(out[0].D_20260105).toBe(7); // D_ 보존
    expect(out[1].W_202602).toBe(123); // 비 LINE_TOTAL 행 불변
    expect(out[1].M_202601).toBe(456);
  });

  it('applyRatio — ratio 커서 비면 원본 반환(참조 동일)', () => {
    const rows = [{ MEASURE: 'LINE_TOTAL_LOAD_ENGINE', W_202602: 1 }];
    expect(applyRatio(rows, [], [], 'LINE_TOTAL')).toBe(rows);
  });
});
