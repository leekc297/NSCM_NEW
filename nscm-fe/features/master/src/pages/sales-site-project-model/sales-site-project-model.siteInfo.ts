import type { ComboResponse } from '@foundation/models';
import { safeString } from '@foundation/utils';

/**
 * Sales Site 로 정해지는 사이트 정보 칸 — Sold-To / Rep Ship-To (코드·설명 4칸).
 *
 * AS-IS DMF0005_SaleSite_PjtModelMapping.cs L2286~2310: SCM_SITE_ID 셀이 바뀌면
 *   SCM0001_GET_SITE_INFO_BY_DIVISION 을 호출해 결과 1행의 네 칸을 그대로 넣고, 결과가 없으면
 *   네 칸을 비운다. 설계서 .atlas/gscm-design/DMF0005/design/03_grid-columns.md D8~D15.
 * 네 칸은 저장 입력이 아니라 SCM_MST_SITE_CUSTOMER(REP_YN='Y') 에서 파생되는 표시 전용 값이다.
 *   조회 SP(PKG_DMF0005 BASE CTE)가 같은 조인으로 내려 주므로 재조회하면 같은 값이 보인다.
 */
export const SITE_INFO_BINDINGS = [
  'SOLDTO_CODE',
  'SOLDTO_DESCRIPTION',
  'SHIPTO_CODE',
  'SHIPTO_DESCRIPTION',
] as const;
export type SiteInfoBinding = (typeof SITE_INFO_BINDINGS)[number];

/**
 * 사이트 정보 조회 콤보(SCM_ADM_CMBO_SQL_M.SQL_ID). 파라미터 @divisionId / @scmSiteId, 결과에
 *   CODE·NAME 외에 위 네 컬럼이 그대로 실린다(BE 콤보 API 는 SQL 결과 컬럼을 전부 돌려준다).
 *
 * 콤보 ID 를 화면에 적는 것은 salesCompanyGuard 의 "콤보 ID 하드코딩 금지"(2026-09-18) 예외다.
 *   그 금지는 드롭다운 후보와 판정이 갈리는 사고를 막기 위한 것인데, 이 조회는 어떤 컬럼의
 *   드롭다운도 아니라 메타에서 가져올 자리가 없다(사용자 결정 2026-10-07).
 */
export const SITE_INFO_COMBO_ID = 'SCM0001_GET_SITE_INFO_BY_DIVISION';

export type SiteInfoCellValues = Record<SiteInfoBinding, string>;

const cellText = (value: unknown): string => safeString(value).trim();

/**
 * 조회 결과 -> 네 칸 값. AS-IS 와 같이 첫 행만 본다(Site 하나로 조회하므로 0 또는 1행).
 *   결과가 없거나 컬럼이 비어 있으면 빈 문자열 — 호출부가 그대로 셀에 넣어 AS-IS clear 와 같아진다.
 */
export const siteInfoCellValues = (rows: readonly ComboResponse[] | undefined): SiteInfoCellValues => {
  const first = rows?.[0];
  return {
    SOLDTO_CODE: cellText(first?.SOLDTO_CODE),
    SOLDTO_DESCRIPTION: cellText(first?.SOLDTO_DESCRIPTION),
    SHIPTO_CODE: cellText(first?.SHIPTO_CODE),
    SHIPTO_DESCRIPTION: cellText(first?.SHIPTO_DESCRIPTION),
  };
};
