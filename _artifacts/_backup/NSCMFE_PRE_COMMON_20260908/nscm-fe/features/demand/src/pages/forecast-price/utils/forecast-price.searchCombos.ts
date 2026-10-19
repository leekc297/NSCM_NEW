import type { ComboParam } from '@foundation/models';

/**
 * 조회조건 콤보 원천 (Doc/Combo/DMF0082_콤보구성.md §1).
 *
 * Division / Team / End Customer / Biz Type 은 필터다. 파라미터 없이 전량을 한 번 받고 좁히는
 * 일은 화면이 한다 - 규칙은 features/master/src/components/searchFields/bigFilterCombo 참조.
 *
 *   콤보                          방식     목록 구성 조건   AS-IS
 *   FilterMyDivision              필터     없음             InitControls :341
 *   FilterTeambyDivision          필터     Division         :348
 *   FilterEndCustomerByDivision   필터     Division + Team  :353 / :3053
 *   FilterBizType                 필터     Division         :357
 *   FilterPlantSiteByEndCustomer  필터     Division 만      (81 계열)
 *   SiteByEndCustomer_DM          재조회   Div + 고객       :3068  (AS-IS CODE=SiteByEndCustomer)
 *   SiteByEndCustomer40_DM        재조회   Team + 고객      :3072  (AS-IS CODE=SiteByEndCustomer40)
 *
 * Plant Site 는 이름과 달리 End Customer 를 걸지 않는다. AS-IS DMF0003 실측상 고객 값이 실리는
 * 경로가 없고(고객 변경 핸들러가 Plant Site 를 다시 만들지 않는다), #6 은 SITE_TYPE='PLANT'
 * 행이라 END_CUSTOMER 가 대부분 NULL 이라 엄격 매칭으로 걸면 목록이 통째로 빈다. DMF0003 과
 * 같은 결정이다 - MktFcstForm 의 plantSiteOptions 주석 참조.
 *
 * Bucket 과 Sender Code 만 그 밖의 재조회이며 현행 콤보 ID 를 그대로 쓴다.
 *
 * ====================================================================================
 * Sales Site 를 재조회로 통일한 이유 (2026-08-29 사용자 확정 - DMF0003 과 같은 결정)
 * ====================================================================================
 * AS-IS 는 조작 경로마다 원천이 셋으로 갈린다 - 진입은 축 없는 BIGFILTER_ScmSitebyEndCustomer40,
 * Team 변경은 BIGFILTER_SiteByEndCustomer 필터, 고객 변경만 재조회다.
 *
 * 그 필터 원천을 TO-BE 사내 데이터로는 쓸 수 없다. BIGFILTER_SiteByEndCustomer 의 40 분기는
 * DEPT_ID 를 LEFT JOIN 두 단계로 만들고(SITE -> SITE_ITEM -> OWNER->DEPT), 비40 분기는
 * DEPT_ID 가 아예 NULL 이다. 엄격 매칭이라 Team 을 고르는 순간 목록이 통째로 빈다.
 *
 * 재조회는 서버가 이미 좁혀 CODE / NAME 만 내려주므로 그 문제가 없다. 이 화면은 AS-IS 도
 * 고객 변경 경로가 이미 재조회였고, 나머지 둘을 거기 맞추면 한 칸이 한 규칙으로 동작한다 -
 * 경로마다 목록과 표시 문구가 달라지던 AS-IS 결함(문서 §4-2)도 없어진다.
 *
 * 잃는 것: 40 진입 목록의 표시 문구. BIGFILTER_ScmSitebyEndCustomer40 은 NAME 이
 * SITE_DESCRIPTION 인데 재조회는 사이트 코드를 쓴다. AS-IS 도 경로마다 달랐던 부분이다.
 *
 * 옮기지 않은 것: AS-IS 는 Division 목록을 받은 뒤 40 만 남긴다(:342). 이 화면 TO-BE 는
 * 81 전용 필드(Sender Code · Plant Site)를 갖춘 다중 사업부 화면이라 그 제한을 걸지 않는다.
 * 문서 §4-3 도 그 줄을 결함으로 지목한다 - CopyToDataTable 이 0건이면 예외라, 40 권한이 없는
 * 계정은 화면 자체가 열리지 않는다.
 */
export const SEARCH_COMBO = {
  division: 'FilterMyDivision',
  team: 'FilterTeambyDivision',
  endCustomer: 'FilterEndCustomerByDivision',
  bizType: 'FilterBizType',
  plantSite: 'FilterPlantSiteByEndCustomer',
  // Sales Site - 재조회 2종. 사업부로만 갈린다.
  //   40 갈래는 DMF0003 과 같은 등록 SQL 을 공유한다 (사용자 확정 2026-08-30).
  salesSite: 'SiteByEndCustomer_DM',
  salesSite40: 'SiteByEndCustomer40_DM',
} as const;

/** 81 계열·82 판정 - AS-IS :3065 Substring(0,2)=="81" || =="82" 와 같다. */
const is81or82 = (divisionId: string): boolean => {
  const d = (divisionId ?? '').trim();
  return d.startsWith('81') || d === '82';
};

/** 전체선택('ALL')과 전체해제는 조건 없음과 같다 - 둘 다 공란으로 접는다. */
const join = (values: readonly string[]): string =>
  values
    .map(value => String(value).trim())
    .filter(value => value !== '' && value.toUpperCase() !== 'ALL')
    .join(',');

export interface SalesSiteComboInput {
  divisionId: string;
  deptIds: readonly string[];
  endCustomers: readonly string[];
}

/**
 * Sales Site 콤보 파라미터. 사업부로 두 갈래다.
 *
 *   81 계열·82  SiteByEndCustomer_DM   Division + End Customer   AS-IS GetSalesSite   :3180
 *   40 등       SiteByEndCustomer40_DM Team + End Customer       AS-IS GetSalesSite40 :3202
 *
 * 목록 구성 조건이 전부 파라미터로 실리므로 그중 하나라도 바뀌면 react-query 키가 달라져
 * SQL 이 다시 나간다 (refetch 를 직접 부르지 않는다).
 *
 * 40 갈래에도 divisionId 를 싣는다 - AS-IS GetSalesSite40 은 PARAM1 이 팀이라 사업부를 안
 * 넘기지만, 등록 SQL 이 @divisionId 를 조건으로 써서 빠지면 BE makeComboQuery 가 공란으로
 * 치환해 목록이 조회조건과 무관하게 고정된다(2026-08-28 실측).
 */
export const buildSalesSiteComboParam = ({
  divisionId,
  deptIds,
  endCustomers,
}: SalesSiteComboInput): ComboParam => {
  const endCustomer = join(endCustomers);
  if (is81or82(divisionId)) {
    return { comboId: SEARCH_COMBO.salesSite, divisionId, endCustomer };
  }
  return {
    comboId: SEARCH_COMBO.salesSite40,
    divisionId,
    deptId: join(deptIds),
    endCustomer,
  };
};
