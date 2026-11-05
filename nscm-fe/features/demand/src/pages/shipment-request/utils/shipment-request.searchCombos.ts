import type { ComboOption } from 'features/master/src/components';

import type { ComboResponse } from '@foundation/models';

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

/**
 * DMF0045 전용 콤보 옵션 빌더 — 서버 순서 보존판(이 화면만. 공통 buildComboOptions 는 미변경).
 *
 * 공통 buildComboOptions(bigFilterCombo.ts)는 마지막에 value(CODE) localeCompare 로 재정렬한다
 *   — bigFilterCombo 규칙 3 "OrderBy(CODE)"로, AS-IS Filter 콤보(DataService.GetDMInnerTable)
 *   재현이다. 그러나 이 화면의 Division/Team/EndCustomer/SalesSite/PlantSite 는 Filter 가 아니라
 *   재조회 SP(MyDivision=ORDER BY ATTRIBUTE1, TeambyDivision 등)라 서버가 이미 업무 순서로 내려준다.
 *   여기에 CODE 재정렬을 걸면 Division 이 81,82,81_UC,81_HM,81_ST,81_HD,81_HG(ATTRIBUTE1 업무순)
 *   대신 81,81_HD,81_HG,81_HM,81_ST,81_UC,82(코드 알파벳순)로 뒤바뀐다. AS-IS cs:200-206 의
 *   clsCtrl.setListBox 는 재정렬 없이 DataTable 행순(SP ORDER BY) 그대로 바인딩하므로, 그 동작을
 *   이 화면에서만 복원한다(공통 함수 변경·타 화면 영향 없음).
 *
 * dedup(같은 CODE 는 첫 행 우선)은 buildComboOptions 와 동일하고, 마지막 정렬만 생략한다. 이 화면
 *   콤보는 재조회 응답이라 축(narrow)을 걸지 않으므로(= 서버가 이미 좁힘) 축 필터는 불필요하다.
 */
const comboCell = (row: ComboResponse, column: string): string => {
  const raw = row[column] as string | number | null | undefined;
  return raw === null || raw === undefined ? '' : String(raw).trim();
};

export const buildOrderedComboOptions = (rows: ComboResponse[] | undefined): ComboOption[] => {
  const byCode = new Map<string, ComboOption>();
  for (const row of rows ?? []) {
    const code = comboCell(row, 'CODE');
    if (code === '' || byCode.has(code)) continue;
    byCode.set(code, { label: comboCell(row, 'NAME') || code, value: code });
  }
  return [...byCode.values()];
};

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
