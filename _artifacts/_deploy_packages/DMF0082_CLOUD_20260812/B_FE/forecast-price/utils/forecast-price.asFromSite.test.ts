import { describe, expect, it } from 'vitest';

import { isAsFromSiteEditable, type AsFromSiteContext } from './forecast-price.asFromSite';

// 실측 기반 픽스처 (2026-08-11 사내):
//   AS_FROM_SITE(81) 콤보 NAME = 'EG01-81-AS' 등 7행 — 통합테스트 문서 예시와 동일.
//   FcstTypeWs = SALES_TYPE_CODE2 4종.
const ctx: AsFromSiteContext = {
  asSiteNames: new Set(['EG01-81-AS', 'WA00-81-AS', 'HQ05-81-AS', 'MI03-81-AS']),
  wsFcstTypes: new Set(['WS', 'WSF', 'AS', 'ASF']),
  fallbackDivisionId: '81',
};

describe('isAsFromSiteEditable — AS-IS DMF0003_MktFcst.cs [E20260211-001189] 계약', () => {
  it('① division 40 은 어떤 조합이든 비활성 (No.35 입력 8컬럼 유지)', () => {
    expect(
      isAsFromSiteEditable({ DIVISION_ID: '40', SCM_SITE_ID: 'ANY-SITE', FCST_TYPE: 'WS' }, ctx)
    ).toBe(false);
  });

  it('② 비축향 Sales Site(EG01-81-AS) → 비활성 — 문서 No.63-① 시나리오', () => {
    expect(
      isAsFromSiteEditable({ DIVISION_ID: '81', SCM_SITE_ID: 'EG01-81-AS', FCST_TYPE: 'WS' }, ctx)
    ).toBe(false);
  });

  it('③ 고객향 + W/S FCST Type → 활성 — 문서 No.63-② 시나리오', () => {
    expect(
      isAsFromSiteEditable({ DIVISION_ID: '81', SCM_SITE_ID: 'CUST-SITE-01', FCST_TYPE: 'WS' }, ctx)
    ).toBe(true);
  });

  it('③ 고객향이어도 FCST Type 이 W/S 계열이 아니면 비활성 (.cs L3498~3507)', () => {
    expect(
      isAsFromSiteEditable({ DIVISION_ID: '81', SCM_SITE_ID: 'CUST-SITE-01', FCST_TYPE: 'MPS' }, ctx)
    ).toBe(false);
  });

  it('FCST Type 미입력이면 비활성 (아직 판정 불가 → 잠금 유지)', () => {
    expect(
      isAsFromSiteEditable({ DIVISION_ID: '81', SCM_SITE_ID: 'CUST-SITE-01', FCST_TYPE: '' }, ctx)
    ).toBe(false);
  });

  it('Sales Site 미입력 + W/S FCST Type → 활성 (비축향 미확정이므로 ② 통과)', () => {
    expect(isAsFromSiteEditable({ DIVISION_ID: '81', SCM_SITE_ID: '', FCST_TYPE: 'ASF' }, ctx)).toBe(
      true
    );
  });

  it('행에 DIVISION_ID 가 없으면 조회조건 division 으로 판정', () => {
    expect(isAsFromSiteEditable({ SCM_SITE_ID: 'CUST-SITE-01', FCST_TYPE: 'AS' }, ctx)).toBe(true);
    expect(
      isAsFromSiteEditable(
        { SCM_SITE_ID: 'CUST-SITE-01', FCST_TYPE: 'AS' },
        { ...ctx, fallbackDivisionId: '40' }
      )
    ).toBe(false);
  });

  it('81 하위 division(81_UC 등)도 ① 을 통과한다 (.cs Substring(0,2)=="81")', () => {
    expect(
      isAsFromSiteEditable({ DIVISION_ID: '81_UC', SCM_SITE_ID: 'CUST-SITE-01', FCST_TYPE: 'WSF' }, ctx)
    ).toBe(true);
  });

  it('82 도 ① 을 통과한다 (.cs `|| =="82"`)', () => {
    expect(
      isAsFromSiteEditable({ DIVISION_ID: '82', SCM_SITE_ID: 'CUST-SITE-01', FCST_TYPE: 'WS' }, ctx)
    ).toBe(true);
  });

  it('AS 사이트 판정은 NAME 만 대조 — CODE 형태(EG01_81-W)는 비축향이 아니다', () => {
    expect(
      isAsFromSiteEditable({ DIVISION_ID: '81', SCM_SITE_ID: 'EG01_81-W', FCST_TYPE: 'WS' }, ctx)
    ).toBe(true);
  });
});
