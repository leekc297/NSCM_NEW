import { describe, expect, it } from 'vitest';

import {
  BUCKET_TYPE,
  DEFAULT_DYN_SCALE,
  isBucketResetBoundary,
  scaleOf,
  widthOf,
} from './mkt-fcst-comparison.constants';

// UM-04 — DMF0040_GET_SPREAD_TITLE 기간 컬럼 DATA_SCALE_NUMBER='' → AS-IS decimalPlaces=0 (SpreadInfo.cs L1433~1440)
describe('scaleOf (UM-04)', () => {
  it("''/NULL/undefined = 화면 fallback(0)", () => {
    expect(DEFAULT_DYN_SCALE).toBe(0);
    expect(scaleOf('')).toBe(0);
    expect(scaleOf(null)).toBe(0);
    expect(scaleOf(undefined)).toBe(0);
  });
  it('양수만 채택 (AS-IS `int > 0`) — 0/음수/NaN 은 fallback', () => {
    expect(scaleOf('3')).toBe(3);
    expect(scaleOf(2)).toBe(2);
    expect(scaleOf('0')).toBe(0);
    expect(scaleOf('-1')).toBe(0);
    expect(scaleOf('abc')).toBe(0);
    expect(scaleOf('2.7')).toBe(2);
  });
  it('fallback 을 호출측이 바꿀 수 있다 (DMF0053 = 3)', () => {
    expect(scaleOf('', 3)).toBe(3);
  });
});

describe('widthOf (UM-04)', () => {
  it('SP COLUMN_WIDTH 채택, 공란/0 은 90', () => {
    expect(widthOf('100')).toBe(100);
    expect(widthOf(50)).toBe(50);
    expect(widthOf('')).toBe(90);
    expect(widthOf('0')).toBe(90);
  });
});

// UM-08 — AS-IS cboBucketType_SelectedIndexChanged L1141~1160: ONLY_WEEKLY 진출입에만 InitSpread()
describe('isBucketResetBoundary (UM-08, DMF0040)', () => {
  it('ONLY_WEEKLY 진입/이탈 = 경계', () => {
    expect(isBucketResetBoundary(BUCKET_TYPE.MONTHLY, BUCKET_TYPE.ONLY_WEEKLY)).toBe(true);
    expect(isBucketResetBoundary(BUCKET_TYPE.ONLY_WEEKLY, BUCKET_TYPE.DAILY)).toBe(true);
  });
  it('그 외 전환(D/W/M 상호) = 가시성 토글뿐, 경계 아님', () => {
    expect(isBucketResetBoundary(BUCKET_TYPE.MONTHLY, BUCKET_TYPE.DAILY)).toBe(false);
    expect(isBucketResetBoundary(BUCKET_TYPE.WEEKLY, BUCKET_TYPE.DAILY)).toBe(false);
    expect(isBucketResetBoundary(BUCKET_TYPE.DAILY, BUCKET_TYPE.MONTHLY)).toBe(false);
  });
  it('동일 값 재선택 = 경계 아님', () => {
    expect(isBucketResetBoundary(BUCKET_TYPE.ONLY_WEEKLY, BUCKET_TYPE.ONLY_WEEKLY)).toBe(false);
  });
});
