import { describe, expect, it } from 'vitest';

import {
  clampTactTime,
  deriveJumboMin,
  deriveTactTimeFromDaily,
  round5,
  toNum,
  toYmd,
} from './tactTimeDerive';

describe('tactTimeDerive', () => {
  it('toNum parses / rejects', () => {
    expect(toNum('12.5')).toBe(12.5);
    expect(toNum('1,200')).toBe(1200);
    expect(toNum('')).toBeNull();
    expect(toNum(null)).toBeNull();
    expect(toNum('abc')).toBeNull();
  });

  it('round5 rounds to 5 decimals', () => {
    expect(round5(1.234567)).toBe(1.23457);
  });

  it('deriveJumboMin = round5(tact*lane*60), blank -> 0', () => {
    expect(deriveJumboMin(2, 3)).toBe(360); // 2*3*60
    expect(deriveJumboMin('', 3)).toBe(0);
    expect(deriveJumboMin(2, null)).toBe(0);
  });

  it('deriveTactTimeFromDaily = round5(86400/daily), blank/0 -> 0', () => {
    expect(deriveTactTimeFromDaily(86400)).toBe(1);
    expect(deriveTactTimeFromDaily(2)).toBe(43200);
    expect(deriveTactTimeFromDaily(0)).toBe(0);
    expect(deriveTactTimeFromDaily('')).toBe(0);
  });

  it('clampTactTime clamps out-of-range to MIN', () => {
    expect(clampTactTime(100, 50000)).toEqual({ value: 100, clamped: false });
    expect(clampTactTime(0, 50000)).toEqual({ value: 0.01, clamped: true }); // < MIN
    expect(clampTactTime(60000, 50000)).toEqual({ value: 0.01, clamped: true }); // > max
    expect(clampTactTime('x', 50000)).toEqual({ value: 0.01, clamped: true }); // parse fail
  });

  it('toYmd normalizes Date / string to yyyyMMdd', () => {
    const today = new Date();
    const ymd = toYmd(today);
    expect(ymd).toMatch(/^\d{8}$/);
    // yyyyMMdd 를 다시 Date 로 만들면 원래 날짜와 같아야 한다
    const back = new Date(+ymd.slice(0, 4), +ymd.slice(4, 6) - 1, +ymd.slice(6, 8));
    expect(back.toDateString()).toBe(today.toDateString());
    expect(toYmd(`${ymd.slice(0, 4)}-${ymd.slice(4, 6)}-${ymd.slice(6, 8)}`)).toBe(ymd);
    expect(toYmd(ymd)).toBe(ymd);
    expect(toYmd(new Date('x'))).toBe('');
    expect(toYmd(undefined)).toBe('');
  });
});
