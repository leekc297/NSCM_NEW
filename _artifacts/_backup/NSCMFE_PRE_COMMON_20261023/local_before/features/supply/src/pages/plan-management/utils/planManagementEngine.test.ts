import { describe, expect, it } from 'vitest';

import type { EngineRow } from '../plan-management.types';

import {
  advanceProgress,
  engineRowKey,
  nextProgress,
  shouldKeepPolling,
} from './planManagementEngine';

describe('nextProgress (R20~R22)', () => {
  it('완료(\'1\')는 4칸 일괄', () => {
    expect(nextProgress(0, '1')).toBe(4);
    expect(nextProgress(2, '1')).toBe(4);
  });
  it('진행중(\'0\')은 1칸씩 순차 증가', () => {
    expect(nextProgress(0, '0')).toBe(1);
    expect(nextProgress(3, '0')).toBe(4);
  });
  it('진행중인데 이미 4칸(이전 사이클 잔재)이면 리셋 후 1칸부터 (R21)', () => {
    expect(nextProgress(4, '0')).toBe(1);
  });
  it('그 외 상태(-1/공백)는 0칸', () => {
    expect(nextProgress(3, '-1')).toBe(0);
    expect(nextProgress(3, '')).toBe(0);
  });
});

describe('advanceProgress', () => {
  const row = (stepName: string, stepStatus: string): EngineRow =>
    ({
      MODELING_ID: 'M001',
      PLAN_ID: '',
      PLAN_NAME: '',
      DIVISION_ID: '40',
      PLAN_TYPE: 'MA',
      PLAN_SEQ: '1',
      STEP_NAME: stepName,
      STEP_PROCESS1: '',
      STEP_PROCESS2: '',
      STEP_PROCESS3: '',
      STEP_PROCESS4: '',
      STEP_STATUS: stepStatus,
      START_TIME: '',
      END_TIME: '',
    }) as EngineRow;

  it('폴링마다 행별 카운터가 독립 진행된다', () => {
    const rows = [row('SDB -> ODB', '1'), row('Engine Running', '0')];
    const first = advanceProgress(new Map(), rows);
    expect(first.get(engineRowKey(rows[0]))).toBe(4);
    expect(first.get(engineRowKey(rows[1]))).toBe(1);
    const second = advanceProgress(first, rows);
    expect(second.get(engineRowKey(rows[1]))).toBe(2);
  });
});

describe('shouldKeepPolling (design 03 §4.4)', () => {
  it('실행중(0)/종료중(-2)만 지속', () => {
    expect(shouldKeepPolling('0')).toBe(true);
    expect(shouldKeepPolling('-2')).toBe(true);
  });
  it('정상(1)/에러(-1)/공백은 중지', () => {
    expect(shouldKeepPolling('1')).toBe(false);
    expect(shouldKeepPolling('-1')).toBe(false);
    expect(shouldKeepPolling(undefined)).toBe(false);
  });
});
