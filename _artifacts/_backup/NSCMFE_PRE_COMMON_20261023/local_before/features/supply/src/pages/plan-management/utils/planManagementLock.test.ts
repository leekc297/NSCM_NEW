import { describe, expect, it } from 'vitest';

import type { PlanRow } from '../plan-management.types';

import {
  hasRunningPlan,
  isConfirmLocked,
  isRunLocked,
  isStopEnabled,
} from './planManagementLock';

const row = (over: Partial<PlanRow> = {}): PlanRow =>
  ({
    DIVISION_ID: '40',
    DIVISION_NAME: 'AUTO',
    PLAN_TYPE_DESCRIPTION: 'Main Plan',
    PLAN_TYPE: 'MA',
    MODELING_ID: 'M001',
    REVISION_NO: 'R01',
    REVISION_DESC: '',
    PLAN_STATUS_NAME: 'Done',
    PLAN_STATUS: '1',
    CONFIRM_YN: 'N',
    CONFIRM_TIME: '',
    CONFIRM_USER: '',
    CONFIRM_AUTH: 'Y',
    RUN_AUTH: 'Y',
    CANCEL_AUTH: 'N',
    ...over,
  }) as PlanRow;

const ctx = { weekCurrent: true, anyRunning: false };

describe('hasRunningPlan (R8 전행 스캔)', () => {
  it('실행중(0)/종료중(-2) 행이 있으면 true', () => {
    expect(hasRunningPlan([row(), row({ PLAN_STATUS: '0' })])).toBe(true);
    expect(hasRunningPlan([row({ PLAN_STATUS: '-2' })])).toBe(true);
  });
  it('정상종료(1)/에러종료(-1)뿐이면 false', () => {
    expect(hasRunningPlan([row(), row({ PLAN_STATUS: '-1' })])).toBe(false);
  });
});

describe('isRunLocked (R8+R9+R10)', () => {
  it('권한 Y + 실행중 없음 + 현재주차 + 필수값 → unlock', () => {
    expect(isRunLocked(row(), ctx)).toBe(false);
  });
  it('RUN_AUTH!=Y → lock', () => {
    expect(isRunLocked(row({ RUN_AUTH: 'N' }), ctx)).toBe(true);
  });
  it('다른 행 실행중(anyRunning) → lock', () => {
    expect(isRunLocked(row(), { ...ctx, anyRunning: true })).toBe(true);
  });
  it('현재 주차 아님 → lock (R9)', () => {
    expect(isRunLocked(row(), { ...ctx, weekCurrent: false })).toBe(true);
  });
  it('PLAN_TYPE/MODELING_ID 공백 → lock (R10)', () => {
    expect(isRunLocked(row({ PLAN_TYPE: '' }), ctx)).toBe(true);
    expect(isRunLocked(row({ MODELING_ID: ' ' }), ctx)).toBe(true);
  });
});

describe('isConfirmLocked (R7+R9+R10)', () => {
  it('권한 Y + PLAN_STATUS=1 + 현재주차 + 필수값 → unlock', () => {
    expect(isConfirmLocked(row(), ctx)).toBe(false);
  });
  it('CONFIRM_AUTH!=Y → lock', () => {
    expect(isConfirmLocked(row({ CONFIRM_AUTH: 'N' }), ctx)).toBe(true);
  });
  it('PLAN_STATUS!=1(0/-1/-2/공백) → lock', () => {
    for (const s of ['0', '-1', '-2', '']) {
      expect(isConfirmLocked(row({ PLAN_STATUS: s }), ctx)).toBe(true);
    }
  });
  it('현재 주차 아님 → lock (R9)', () => {
    expect(isConfirmLocked(row(), { ...ctx, weekCurrent: false })).toBe(true);
  });
});

describe('isStopEnabled (design 01 §2 행4)', () => {
  it('PLAN_STATUS=\'0\'(실행중)만 enable', () => {
    expect(isStopEnabled('0')).toBe(true);
    for (const s of ['1', '-1', '-2', '', undefined]) {
      expect(isStopEnabled(s)).toBe(false);
    }
  });
});
