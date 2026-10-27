import { isDiv40 } from './shipment-request.division';

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
// AS-IS UP_FX_GetCommonDataList 의 @Code 분기명 그대로의 기존 TO-BE CMBO 를 쓴다(신규 생성 금지).
//   team/salesSite 는 과거 'User*' 변형(UserTeamByDivision=@divisionId 없음·SITE_ITEM /
//   UserSiteByEndCustomer=OPERATION_GROUP·AS_SITE_PLANT 군더더기)을 썼으나, AS-IS 분기와 어긋나
//   AS-IS명 콤보(TeambyDivision=@divisionId 분기 / SiteByEndCustomer=SALES+40 PROJECT_CODE)로 교체.
export const SEARCH_COMBO = {
  division: 'MyDivision', // @Code='MyDivision'
  // AS-IS 정확일치 전용 콤보 — 공유 'TeambyDivision'(SCM_MST_SITE_ITEM 아이템-레벨 DEPT, div81 108건)
  //   대신 AS-IS TeambyDivision 분기(SCM_MST_SITE SALES + 사이트-레벨 DEPT) Oracle 이식본.
  //   Oracle SCM_MST_SITE 엔 DEPT_ID 가 없어 ETL_DEPT_ID(AS-IS DEPT_ID 이관본) 사용. div81 30건=AS-IS.
  //   등록 SQL: _artifacts/2026-10-15_dmf0045_team_combo_asis.sql. (@divisionId,@sesUserId)
  team: 'DMF0045_TeambyDivision',
  // AS-IS 정확일치 전용 콤보 — 공유 'EndCustomerByDivisionDept'(SITE_ITEM EXISTS + LOOKUP union, 6화면 공유)
  //   대신 AS-IS UP_FX @Code 분기(A.DEPT_ID·union 없음) Oracle 이식본. 등록 SQL:
  //   _artifacts/2026-10-15_dmf0045_endcustomer_combo_asis.sql. (@divisionId,@deptId,@sesUserId)
  endCustomer: 'DMF0045_EndCustomerByDivisionDept',
  salesSite: 'SiteByEndCustomer', // @Code='SiteByEndCustomer' (@divisionId,@endCustomer,@validYn='Y')
  // AS-IS Data.UserPlantSiteByDivision → @Code='FromSiteByDivision'(PLANT+권한, NAME=SCM_SITE_ID 코드).
  //   'PlantSiteByDivision'(권한 없음·NAME=설명)이 아니다. 공유 콤보라 repoint 만(validYn='N' 은 Form).
  plantSite: 'FromSiteByDivision',
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
