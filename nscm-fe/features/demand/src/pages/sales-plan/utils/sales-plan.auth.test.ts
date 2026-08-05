import { describe, expect, it } from 'vitest';

import { resolveSalesPlanAuthGroup } from './sales-plan.auth';

describe('resolveSalesPlanAuthGroup', () => {
  it('CMBO 결과 1행을 그대로 사용한다 (SQL이 ADMIN 우선 정렬 완료)', () => {
    expect(resolveSalesPlanAuthGroup([{ CODE: 'ADMIN' }, { CODE: 'DM Planner' }])).toBe('ADMIN');
  });

  it('CMBO 결과가 단일 행이면 그 그룹을 사용한다', () => {
    expect(resolveSalesPlanAuthGroup([{ CODE: 'SCM PI Admin' }])).toBe('SCM PI Admin');
  });

  it('CMBO 결과가 없으면 미확정(빈 문자열) 처리한다', () => {
    expect(resolveSalesPlanAuthGroup([])).toBe('');
    expect(resolveSalesPlanAuthGroup(undefined)).toBe('');
  });
});
