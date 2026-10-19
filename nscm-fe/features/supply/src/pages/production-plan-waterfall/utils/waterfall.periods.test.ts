import { describe, expect, it } from 'vitest';

import { BUCKET_TYPE } from '../production-plan-waterfall.constants';

import { baseVisibleOf } from './waterfall.periods';

// AS-IS SetSpreadColumn(SCP0017.cs:849-906) 버킷별 Visible 분기 1:1 검증.
//   Daily     : D 표시 · W 표시 · M=chkSum
//   Weekly    : D 숨김 · W 표시 · M=chkSum
//   WeeklyISO : W 표시 · D_·M_ 숨김 (TO-BE 캘린더 SP 가 W_ 를 이미 ISO 주차로 생성 — _ISO 접미 없음)
//   Monthly   : M만 표시

describe('baseVisibleOf — 버킷별 기간컬럼 표시 (AS-IS SetSpreadColumn 1:1)', () => {
  it('Daily: D=표시 / W=chkSum / M=chkSum (AS-IS cs:867-869 W_ 를 chkSum 으로 덮어씀 — W1 해소)', () => {
    expect(baseVisibleOf(BUCKET_TYPE.DAILY, false, 'D')).toBe(true);
    expect(baseVisibleOf(BUCKET_TYPE.DAILY, false, 'W')).toBe(false);
    expect(baseVisibleOf(BUCKET_TYPE.DAILY, true, 'W')).toBe(true);
    expect(baseVisibleOf(BUCKET_TYPE.DAILY, false, 'M')).toBe(false);
    expect(baseVisibleOf(BUCKET_TYPE.DAILY, true, 'M')).toBe(true);
  });

  it('Weekly: D=숨김 / W=표시 / M=chkSum', () => {
    expect(baseVisibleOf(BUCKET_TYPE.WEEKLY, false, 'D')).toBe(false);
    expect(baseVisibleOf(BUCKET_TYPE.WEEKLY, false, 'W')).toBe(true);
    expect(baseVisibleOf(BUCKET_TYPE.WEEKLY, false, 'M')).toBe(false);
    expect(baseVisibleOf(BUCKET_TYPE.WEEKLY, true, 'M')).toBe(true);
  });

  it('WeeklyISO(Only Weekly): W 표시 / D_·M_ 숨김 (TO-BE SP 가 W_ 를 ISO 주차로 생성, _ISO 접미 없음)', () => {
    expect(baseVisibleOf(BUCKET_TYPE.WEEKLY_ISO, false, 'W')).toBe(true);
    expect(baseVisibleOf(BUCKET_TYPE.WEEKLY_ISO, false, 'D')).toBe(false);
    expect(baseVisibleOf(BUCKET_TYPE.WEEKLY_ISO, false, 'M')).toBe(false);
    expect(baseVisibleOf(BUCKET_TYPE.WEEKLY_ISO, true, 'M')).toBe(false);
  });

  it('Monthly: M만 표시 / D_·W_ 숨김', () => {
    expect(baseVisibleOf(BUCKET_TYPE.MONTHLY, false, 'M')).toBe(true);
    expect(baseVisibleOf(BUCKET_TYPE.MONTHLY, false, 'D')).toBe(false);
    expect(baseVisibleOf(BUCKET_TYPE.MONTHLY, false, 'W')).toBe(false);
  });
});
