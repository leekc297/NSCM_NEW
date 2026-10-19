import { describe, expect, it } from 'vitest';

import { BUCKET_TYPE } from '../production-plan-line.constants';

import {
  EMPTY_DRILLDOWN,
  isPivotVisibleWithDrilldown,
  toggleDrilldown,
} from './productionPlanLineDrilldown';

// 태그 형식(PKG_SCP0013 실측): M_yyyymm · W_(BASIS_YYYYMM+ISO_WEEK) · D_yyyymmdd.
// 2026-08: ISO_WEEK 35=08-24~08-30(월~일). D_20260824 ∈ W_20260835.
const M = 'M_202608';
const W35 = 'W_20260835';
const W36 = 'W_20260836';
const D24 = 'D_20260824'; // W35 월요일
const D31 = 'D_20260831'; // W36 월요일
const ALL = [M, W35, W36, D24, D31];

describe('isPivotVisibleWithDrilldown', () => {
  it('오버라이드 없으면 bucket 기본 가시성(isPivotVisible) 그대로', () => {
    // Monthly: M_ 만 표시, W_/D_ 숨김
    expect(isPivotVisibleWithDrilldown(M, BUCKET_TYPE.MONTHLY, false, EMPTY_DRILLDOWN)).toBe(true);
    expect(isPivotVisibleWithDrilldown(W35, BUCKET_TYPE.MONTHLY, false, EMPTY_DRILLDOWN)).toBe(false);
    expect(isPivotVisibleWithDrilldown(D24, BUCKET_TYPE.MONTHLY, false, EMPTY_DRILLDOWN)).toBe(false);
  });

  it('오버라이드가 있으면 그 값이 우선', () => {
    const state = new Map([[W35, true]]);
    expect(isPivotVisibleWithDrilldown(W35, BUCKET_TYPE.MONTHLY, false, state)).toBe(true);
  });
});

describe('toggleDrilldown — 월(M_) 헤더', () => {
  it('Monthly+chkAll: 월 클릭 → 그 달의 주(W_)가 표시된다', () => {
    const next = toggleDrilldown(EMPTY_DRILLDOWN, M, ALL, BUCKET_TYPE.MONTHLY, false, true);
    expect(isPivotVisibleWithDrilldown(W35, BUCKET_TYPE.MONTHLY, false, next)).toBe(true);
    expect(isPivotVisibleWithDrilldown(W36, BUCKET_TYPE.MONTHLY, false, next)).toBe(true);
  });

  it('Monthly+!chkAll: 월 클릭은 가드로 무시(상태 불변)', () => {
    const next = toggleDrilldown(EMPTY_DRILLDOWN, M, ALL, BUCKET_TYPE.MONTHLY, false, false);
    expect(next).toBe(EMPTY_DRILLDOWN);
  });

  it('월 두 번 클릭(전개→접기): 주가 다시 숨겨지고, 보이던 일도 숨긴다', () => {
    const expanded = toggleDrilldown(EMPTY_DRILLDOWN, M, ALL, BUCKET_TYPE.MONTHLY, false, true);
    // 주 전개 상태에서 그 주의 일을 강제 표시해 둔다(사용자가 주를 또 드릴다운한 셈)
    const withDay = new Map(expanded).set(D24, true);
    const collapsed = toggleDrilldown(withDay, M, ALL, BUCKET_TYPE.MONTHLY, false, true);
    expect(isPivotVisibleWithDrilldown(W35, BUCKET_TYPE.MONTHLY, false, collapsed)).toBe(false);
    expect(isPivotVisibleWithDrilldown(D24, BUCKET_TYPE.MONTHLY, false, collapsed)).toBe(false);
  });
});

describe('toggleDrilldown — 주(W_) 헤더', () => {
  it('Weekly+chkAll: 주 클릭 → 그 주의 일(D_)만 표시(다른 주의 일은 불변)', () => {
    const next = toggleDrilldown(EMPTY_DRILLDOWN, W35, ALL, BUCKET_TYPE.WEEKLY, false, true);
    expect(isPivotVisibleWithDrilldown(D24, BUCKET_TYPE.WEEKLY, false, next)).toBe(true);
    expect(isPivotVisibleWithDrilldown(D31, BUCKET_TYPE.WEEKLY, false, next)).toBe(false);
  });

  it('Weekly+!chkAll: 주 클릭은 가드로 무시(상태 불변)', () => {
    const next = toggleDrilldown(EMPTY_DRILLDOWN, W35, ALL, BUCKET_TYPE.WEEKLY, false, false);
    expect(next).toBe(EMPTY_DRILLDOWN);
  });
});

describe('toggleDrilldown — 드릴 불가 대상', () => {
  it('일(D_) 헤더 클릭은 no-op', () => {
    const next = toggleDrilldown(EMPTY_DRILLDOWN, D24, ALL, BUCKET_TYPE.DAILY, false, true);
    expect(next).toBe(EMPTY_DRILLDOWN);
  });
});
