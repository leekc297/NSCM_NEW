import dayjs from 'dayjs';
import timezone from 'dayjs/plugin/timezone';
import utc from 'dayjs/plugin/utc';
import { describe, expect, it } from 'vitest';

import { todayInTimeZone } from './todayInTimeZone';

dayjs.extend(utc);
dayjs.extend(timezone);

describe('todayInTimeZone', () => {
  it('매핑에 없는 코드·빈 값은 브라우저 시계(오늘)로 폴백한다', () => {
    // 종전 동작과 동일 — 달력이 PC 시계로 '오늘' 을 잡던 폴백.
    expect(todayInTimeZone('').isSame(dayjs(), 'day')).toBe(true);
    expect(todayInTimeZone(undefined).isSame(dayjs(), 'day')).toBe(true);
    expect(todayInTimeZone('ZZ999').isSame(dayjs(), 'day')).toBe(true);
  });

  it('등록된 코드는 해당 존의 달력일을 플레인 로컬 Dayjs 로 돌려준다', () => {
    // dayjs-tz 로 계산한 대상 존의 오늘 날짜와 일치해야 한다(서버 FN_MULTY_TIME 과 같은 날짜).
    for (const [code, zone] of [
      ['AM073', 'America/New_York'],
      ['AS054', 'Asia/Seoul'],
      ['AS055', 'Asia/Shanghai'],
      ['EU042', 'Europe/Warsaw'],
    ] as const) {
      const expected = dayjs().tz(zone).format('YYYY-MM-DD');
      expect(todayInTimeZone(code).format('YYYY-MM-DD')).toBe(expected);
    }
  });

  it('달력일만 보존하고 오프셋을 섞지 않는다(자정 플레인 로컬)', () => {
    const d = todayInTimeZone('AS054');
    expect(d.isValid()).toBe(true);
    expect(d.format('HH:mm:ss')).toBe('00:00:00');
  });
});
