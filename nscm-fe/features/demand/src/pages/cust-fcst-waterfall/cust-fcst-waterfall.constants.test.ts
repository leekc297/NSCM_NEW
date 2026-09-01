import { describe, expect, it } from 'vitest';

import {
  BUCKET_TYPE,
  DEFAULT_DYN_SCALE,
  isBucketResetBoundary,
  scaleOf,
  widthOf,
} from './cust-fcst-waterfall.constants';

// UM-04 — P_DMF0053_GET_SPREAD_TITLE 기간 컬럼 `3 AS DATA_SCALE_NUMBER` → AS-IS decimalPlaces=3
describe('scaleOf (UM-04, DMF0053)', () => {
  it('\'\'/NULL = 화면 fallback(3) — DMF0040(0) 과 다르다', () => {
    expect(DEFAULT_DYN_SCALE).toBe(3);
    expect(scaleOf('')).toBe(3);
    expect(scaleOf(null)).toBe(3);
  });
  it('양수만 채택 (AS-IS `int > 0`)', () => {
    expect(scaleOf('3')).toBe(3);
    expect(scaleOf('0')).toBe(3);
    expect(scaleOf('1')).toBe(1);
  });
});

describe('widthOf (UM-04)', () => {
  it('SP COLUMN_WIDTH 채택, 공란은 90', () => {
    expect(widthOf('50')).toBe(50);
    expect(widthOf(undefined)).toBe(90);
  });
});

// UM-08 — AS-IS cboBucketType_SelectedIndexChanged L1123~1146: ONLY_WEEKLY 진출입 + (W|M → DAILY) 에 InitSpread()
describe('isBucketResetBoundary (UM-08, DMF0053)', () => {
  it('ONLY_WEEKLY 진입/이탈 = 경계', () => {
    expect(isBucketResetBoundary(BUCKET_TYPE.MONTHLY, BUCKET_TYPE.ONLY_WEEKLY)).toBe(true);
    expect(isBucketResetBoundary(BUCKET_TYPE.ONLY_WEEKLY, BUCKET_TYPE.WEEKLY)).toBe(true);
  });
  it('WEEKLY/MONTHLY → DAILY = 경계 (L1129~1132 — DMF0040 에는 없는 분기)', () => {
    expect(isBucketResetBoundary(BUCKET_TYPE.MONTHLY, BUCKET_TYPE.DAILY)).toBe(true);
    expect(isBucketResetBoundary(BUCKET_TYPE.WEEKLY, BUCKET_TYPE.DAILY)).toBe(true);
  });
  it('DAILY → W/M, W ↔ M = 가시성 토글뿐', () => {
    expect(isBucketResetBoundary(BUCKET_TYPE.DAILY, BUCKET_TYPE.MONTHLY)).toBe(false);
    expect(isBucketResetBoundary(BUCKET_TYPE.WEEKLY, BUCKET_TYPE.MONTHLY)).toBe(false);
    expect(isBucketResetBoundary(BUCKET_TYPE.MONTHLY, BUCKET_TYPE.WEEKLY)).toBe(false);
  });
});
