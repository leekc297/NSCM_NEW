import { describe, expect, it } from 'vitest';

import { BUCKET_TYPE } from '../production-plan-waterfall.constants';

import { baseVisibleOf, isIsoWeek } from './waterfall.periods';

// AS-IS SetSpreadColumn(SCP0017.cs:849-906) 버킷별 Visible 분기 1:1 검증.
//   Daily     : D 표시 · W 표시 · M=chkSum
//   Weekly    : D 숨김 · W 표시 · M=chkSum
//   WeeklyISO : Visible = isWeeklyISO(cs:892-894) → W(_ISO)만 표시, 그 외 전부 숨김
//   Monthly   : M만 표시

describe('isIsoWeek', () => {
  it('_ISO 접미만 ISO 주로 판정', () => {
    expect(isIsoWeek('W_2026011_ISO')).toBe(true);
    expect(isIsoWeek('W_2026011')).toBe(false);
    expect(isIsoWeek('D_20260101')).toBe(false);
    expect(isIsoWeek('M_202601')).toBe(false);
  });
});

describe('baseVisibleOf — 버킷별 기간컬럼 표시 (AS-IS SetSpreadColumn 1:1)', () => {
  it('Daily: D=표시 / W=chkSum / M=chkSum (AS-IS cs:867-869 W_ 를 chkSum 으로 덮어씀 — W1 해소)', () => {
    expect(baseVisibleOf(BUCKET_TYPE.DAILY, false, 'D', false)).toBe(true);
    expect(baseVisibleOf(BUCKET_TYPE.DAILY, false, 'W', false)).toBe(false);
    expect(baseVisibleOf(BUCKET_TYPE.DAILY, true, 'W', false)).toBe(true);
    expect(baseVisibleOf(BUCKET_TYPE.DAILY, false, 'M', false)).toBe(false);
    expect(baseVisibleOf(BUCKET_TYPE.DAILY, true, 'M', false)).toBe(true);
  });

  it('Weekly: D=숨김 / W=표시 / M=chkSum', () => {
    expect(baseVisibleOf(BUCKET_TYPE.WEEKLY, false, 'D', false)).toBe(false);
    expect(baseVisibleOf(BUCKET_TYPE.WEEKLY, false, 'W', false)).toBe(true);
    expect(baseVisibleOf(BUCKET_TYPE.WEEKLY, false, 'M', false)).toBe(false);
    expect(baseVisibleOf(BUCKET_TYPE.WEEKLY, true, 'M', false)).toBe(true);
  });

  it('WeeklyISO: _ISO 주만 표시 / 비ISO W_·D_·M_ 전부 숨김 (AS-IS Visible=isWeeklyISO)', () => {
    expect(baseVisibleOf(BUCKET_TYPE.WEEKLY_ISO, false, 'W', true)).toBe(true);
    expect(baseVisibleOf(BUCKET_TYPE.WEEKLY_ISO, false, 'W', false)).toBe(false); // 이전 결함: 전 W_ 표시
    expect(baseVisibleOf(BUCKET_TYPE.WEEKLY_ISO, false, 'D', false)).toBe(false);
    expect(baseVisibleOf(BUCKET_TYPE.WEEKLY_ISO, false, 'M', false)).toBe(false);
    expect(baseVisibleOf(BUCKET_TYPE.WEEKLY_ISO, true, 'M', false)).toBe(false);
  });

  it('Monthly: M만 표시 / D_·W_ 숨김', () => {
    expect(baseVisibleOf(BUCKET_TYPE.MONTHLY, false, 'M', false)).toBe(true);
    expect(baseVisibleOf(BUCKET_TYPE.MONTHLY, false, 'D', false)).toBe(false);
    expect(baseVisibleOf(BUCKET_TYPE.MONTHLY, false, 'W', true)).toBe(false);
  });
});
