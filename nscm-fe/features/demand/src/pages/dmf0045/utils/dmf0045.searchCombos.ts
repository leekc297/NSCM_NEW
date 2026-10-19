import { isDiv40 } from './dmf0045.division';

/**
 * 조회조건 콤보 원천 (design 02 §2 — SCM_ADM_CMBO_SQL_M / LOOKUP 실측 SQL_ID).
 *
 * cascade root 는 Division 이며, Team/Customer/SalesSite/PlantSite 는 상위 파라미터를 queryKey 에
 * 실어 자동 refetch 된다(useCascadeFields). refetch 직접 호출 금지(memory: 파라미터 의존 자동 재조회).
 *
 *   콤보 ID(SQL_ID = SCM_ADM_CMBO_SQL_M 등록명)   목록 구성 조건        AS-IS 근거(cs)
 *   MyDivision                       권한조인(@mnuId,@sesUserId) + ATTRIBUTE3<>'EE'   200-207
 *   UserTeamByDivision               Division                  209-213
 *   EndCustomerByDivisionDept        Division + Team(@divisionId,@deptId)   214-217
 *   UserSiteByEndCustomer            Division + End Customer    219-220
 *   PlantSiteByDivision              Division(@divisionId, SITE_TYPE='PLANT')   222-223
 *   BUCKET_TYPE_CODE (LOOKUP)        정적(D/W/M)                225-226
 *
 * 주의: SQL_ID 는 AS-IS C# 헬퍼명(Data.UserEndCustomerByDivisionDept 등)이 아니라 TO-BE
 *   SCM_ADM_CMBO_SQL_M 실등록명이다 — 헬퍼명을 그대로 쓰면 미등록으로 조용히 0행(빈 드롭다운).
 *   End Customer/Plant Site 는 C# 헬퍼의 User 접두가 등록명에 없다(실측 2026-09-27, design 02 §2).
 *
 * 콤보 5층 대조 경고(convert-core §2.6): cboDivision 은 MyDivision(권한 사업부, 권한조인+EE제외)
 * 이지 Division(=@param 검색콤보) SQL_ID 가 아니다 — 이름만 보고 재사용 금지.
 */
export const SEARCH_COMBO = {
  division: 'MyDivision',
  team: 'UserTeamByDivision',
  endCustomer: 'EndCustomerByDivisionDept',
  salesSite: 'UserSiteByEndCustomer',
  plantSite: 'PlantSiteByDivision',
} as const;

// Bucket 은 CMBO SQL 이 아니라 LOOKUP 정적 콤보다(design 02 §2-6/§5). BUCKET_TYPE_CODE 는
//   SCM_ADM_CMBO_SQL_M SQL_ID 로는 미등록이고 SCM_ADM_LOOKUP_MASTER_DETAIL.LOOKUP_TYPE 으로만 존재한다
//   — useTabComboQueries(CMBO 경로)가 아니라 useTabLookupQueries(LOOKUP 경로)로 조회해야 한다.
export const BUCKET_LOOKUP_TYPE = 'BUCKET_TYPE_CODE';

/** Sales Site 목록을 다시 만든 계기 — 무엇을 바꿨느냐로 cascade 파라미터가 갈린다. */
export type SearchComboTrigger = 'entry' | 'division' | 'team' | 'endCustomer';

/** Plant Site 목록의 원천 — 진입과 Division 변경이 서로 다른 파라미터를 쓴다. */
export type PlantSiteSource = 'entry' | 'division';

/** 전체선택('ALL')과 전체해제는 필터상 같다 — 둘 다 빈 목록 = 그 축 미적용이다. */
const toCodes = (values: readonly string[]): string[] =>
  values
    .map(value => String(value).trim())
    .filter(value => value !== '' && value.toUpperCase() !== 'ALL');

/**
 * Sales Site 에 걸 DEPT_ID — AS-IS UserSiteByEndCustomer 는 Division 40 의 Team 변경 시에만 팀을 넘긴다
 * (design 02 §2-4 cs:219, sales-plan 동형 함정). 그 외 계기는 팀 미전달.
 */
export const resolveSalesSiteDeptIds = (
  trigger: SearchComboTrigger,
  divisionId: string,
  deptIds: readonly string[]
): string[] => (trigger === 'team' && isDiv40(divisionId) ? toCodes(deptIds) : []);
