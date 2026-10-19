import { describe, expect, it } from 'vitest';

import { clampNowYyyymmdd } from './business-plan.editLock';

// 조회 p_now_yyyymmdd — AS-IS FindData L790~796 클램프 1:1.
//   금주 월요일을 조회 기간 안으로 자른다. 안 자르면 기간이 통째로 미래/과거일 때
//   SP 의 실적·계획 경계가 AS-IS 와 달라진다 (2026-08-26 대조).
describe('clampNowYyyymmdd', () => {
  const MON = '20260824'; // 금주 월요일

  it('기간이 금주 월요일을 포함하면 월요일 그대로', () => {
    expect(clampNowYyyymmdd(MON, '20260801', '20270228')).toBe(MON);
  });

  it('기간이 통째로 미래면 시작일 (시작일 >= 월요일)', () => {
    expect(clampNowYyyymmdd(MON, '20260901', '20270228')).toBe('20260901');
  });

  it('시작일 == 월요일도 시작일 분기 (AS-IS 비교가 >=)', () => {
    expect(clampNowYyyymmdd(MON, MON, '20270228')).toBe(MON);
  });

  it('기간이 통째로 과거면 종료일 + 1일', () => {
    expect(clampNowYyyymmdd(MON, '20260101', '20260731')).toBe('20260801');
  });

  it('종료일 + 1 이 연을 넘겨도 정상 (12/31 → 다음해 1/1)', () => {
    expect(clampNowYyyymmdd('20270301', '20260101', '20261231')).toBe('20270101');
  });

  it('형식이 아니면 원값 유지 (방어)', () => {
    expect(clampNowYyyymmdd(MON, '', '')).toBe(MON);
    expect(clampNowYyyymmdd('', '20260901', '20270228')).toBe('');
  });
});
