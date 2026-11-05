import { describe, expect, it } from 'vitest';

import { BUCKET_TYPE } from '../waterfall-shipment-plan-fg.constants';

import { baseVisibleOf, isIsoWeek, weekKeyOf } from './waterfall.periods';

// AS-IS SetSpreadColumn(SCP0016.cs:1213-1281) 버킷별 Visible 분기 1:1 검증.
//   isDaily=D_ / isWeekly=W_ / isWeeklyISO=(W_ && _ISO 접미) / isMonthly=M_.
//   Daily     : (D||W)=true 후 (M||W)=chkSum → D=표시, W=chkSum, M=chkSum
//   Weekly    : D=false, W=true, M=chkSum
//   WeeklyISO : Visible = isWeeklyISO → W(_ISO)만 표시, 그 외 전부 숨김
//   Monthly   : (D||W)=false, else true → M만 표시

describe('isIsoWeek', () => {
  it('_ISO 접미만 ISO 주로 판정', () => {
    expect(isIsoWeek('W_2026011_ISO')).toBe(true);
    expect(isIsoWeek('W_2026011')).toBe(false);
    expect(isIsoWeek('D_20260101')).toBe(false);
    expect(isIsoWeek('M_202601')).toBe(false);
  });
});

// 2단(주) 헤더 가로병합 키 — Sum 체크로 W_(주합) 가 보일 때 'Wxx' 헤더가 주합 칸과 일자 칸으로
//   쪼개지던 결함의 회귀 가드. W_ 롤업과 그 주의 D_ 일자들이 같은 키를 공유해야 한 칸으로 병합된다.
describe('weekKeyOf — W_ 롤업과 소속 D_ 가 같은 2단 주차 키를 공유', () => {
  it('W_ 는 인코딩 ISO주차, 같은 주 D_ 는 날짜에서 ISO주차 계산 → 일치', () => {
    // 2026 ISO 35주(08.24 월 ~ 08.30 일). W_ binding = yyyymm(202608)+ISO_WEEK(35).
    expect(weekKeyOf('W_20260835')).toBe('35');
    expect(weekKeyOf('D_20260824')).toBe('35'); // 월
    expect(weekKeyOf('D_20260830')).toBe('35'); // 일
    // 다음 주(36)로 넘어가면 키가 달라져 병합 경계가 생긴다.
    expect(weekKeyOf('D_20260831')).toBe('36');
  });

  it('M_ 등 비주차 kind 는 빈 키', () => {
    expect(weekKeyOf('M_202608')).toBe('');
    expect(weekKeyOf('x')).toBe('');
  });

  it('ISO 접미(_ISO)는 slice 경계 밖이라 주차 파싱에 영향 없음', () => {
    expect(weekKeyOf('W_20260835_ISO')).toBe('35');
  });
});

describe('baseVisibleOf — 버킷별 기간컬럼 표시 (AS-IS SetSpreadColumn 1:1)', () => {
  it('Daily: D=표시 / W=chkSum / M=chkSum', () => {
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
    // W_ 이면서 isIso=true 만 표시
    expect(baseVisibleOf(BUCKET_TYPE.WEEKLY_ISO, false, 'W', true)).toBe(true);
    // 비ISO W_ = 숨김 (이전 결함: 전 W_ 표시)
    expect(baseVisibleOf(BUCKET_TYPE.WEEKLY_ISO, false, 'W', false)).toBe(false);
    // D_/M_ 는 isIso 무관 숨김
    expect(baseVisibleOf(BUCKET_TYPE.WEEKLY_ISO, false, 'D', false)).toBe(false);
    expect(baseVisibleOf(BUCKET_TYPE.WEEKLY_ISO, false, 'M', false)).toBe(false);
    // chkSum 은 WeeklyISO 표시에 영향 없음
    expect(baseVisibleOf(BUCKET_TYPE.WEEKLY_ISO, true, 'M', false)).toBe(false);
  });

  it('Monthly: M만 표시 / D_·W_ 숨김', () => {
    expect(baseVisibleOf(BUCKET_TYPE.MONTHLY, false, 'M', false)).toBe(true);
    expect(baseVisibleOf(BUCKET_TYPE.MONTHLY, false, 'D', false)).toBe(false);
    expect(baseVisibleOf(BUCKET_TYPE.MONTHLY, false, 'W', false)).toBe(false);
    expect(baseVisibleOf(BUCKET_TYPE.MONTHLY, true, 'W', true)).toBe(false);
  });
});
