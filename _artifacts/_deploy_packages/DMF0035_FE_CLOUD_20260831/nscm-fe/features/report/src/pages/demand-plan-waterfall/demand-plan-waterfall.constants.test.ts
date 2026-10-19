import { describe, expect, it } from 'vitest';

import {
  BUCKET_TYPE,
  BUCKET2_TYPE,
  formatByNotation,
  GUBUN,
  isBucketResetBoundary,
  scaleOf,
} from './demand-plan-waterfall.constants';

// UM-08 — AS-IS DMF0035 cboBucketType_SelectedIndexChanged .cs:1594~1610
describe('isBucketResetBoundary (UM-08, DMF0035)', () => {
  it('ONLY_WEEKLY 진입/이탈 = 경계 (InitSpread)', () => {
    expect(isBucketResetBoundary(GUBUN.MKT_FCST, BUCKET_TYPE.MONTHLY, BUCKET_TYPE.ONLY_WEEKLY)).toBe(true);
    expect(isBucketResetBoundary(GUBUN.SALES_PLAN, BUCKET_TYPE.ONLY_WEEKLY, BUCKET_TYPE.WEEKLY)).toBe(true);
  });
  it('WEEKLY/MONTHLY → DAILY = 경계 (.cs:1600~1602)', () => {
    expect(isBucketResetBoundary(GUBUN.MKT_FCST, BUCKET_TYPE.WEEKLY, BUCKET_TYPE.DAILY)).toBe(true);
    expect(isBucketResetBoundary(GUBUN.MKT_FCST, BUCKET_TYPE.MONTHLY, BUCKET_TYPE.DAILY)).toBe(true);
  });
  it('DAILY → W/M, W ↔ M = 표시 접두 토글뿐', () => {
    expect(isBucketResetBoundary(GUBUN.MKT_FCST, BUCKET_TYPE.DAILY, BUCKET_TYPE.WEEKLY)).toBe(false);
    expect(isBucketResetBoundary(GUBUN.MKT_FCST, BUCKET_TYPE.WEEKLY, BUCKET_TYPE.MONTHLY)).toBe(false);
  });
  it('BIZ(M/Q/Y) 는 경계 없음 — 0051 은 FE 컬럼 토글만', () => {
    expect(isBucketResetBoundary(GUBUN.BIZ_PLAN, BUCKET2_TYPE.MONTHLY, BUCKET2_TYPE.YEARLY)).toBe(false);
  });
});

// UM-04 — MKT 타이틀 기간 컬럼 DATA_SCALE_NUMBER=NULL → 0자리
describe('scaleOf (UM-04)', () => {
  it('NULL/빈값 = 0, 양수만 채택', () => {
    expect(scaleOf(null)).toBe(0);
    expect(scaleOf('')).toBe(0);
    expect(scaleOf('3')).toBe(3);
    expect(scaleOf('0')).toBe(0);
  });
});

// UM-04 — AS-IS [E20231106-000212] 행별 NOTATION (.cs:1199~1273)
describe('formatByNotation (UM-04)', () => {
  it('INTEGER = 정수·천단위 (0.000 → 0)', () => {
    expect(formatByNotation(1234.567, 'INTEGER')).toBe('1,235');
    expect(formatByNotation(0, 'INTEGER')).toBe('0');
  });
  it('POINT = 정수면 정수, 소수면 최대 3자리(꼬리 0 제거)', () => {
    expect(formatByNotation(12, 'POINT')).toBe('12');
    expect(formatByNotation(0.5, 'POINT')).toBe('0.5');
    expect(formatByNotation(1234.5678, 'POINT')).toBe('1,234.568');
  });
  it('POINT3 = 무조건 3자리 (0.000 → 0)', () => {
    expect(formatByNotation(1234.5, 'POINT3')).toBe('1,234.500');
    expect(formatByNotation(0.0001, 'POINT3')).toBe('0');
  });
  it('DEFAULT/\'\' = null (컬럼 기본 포맷 유지)', () => {
    expect(formatByNotation(1, 'DEFAULT')).toBeNull();
    expect(formatByNotation(1, '')).toBeNull();
  });
});
