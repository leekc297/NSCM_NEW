import type { ComboParam } from '@foundation/models';

/**
 * 조회조건 콤보 원천 (Doc/Combo/DMF0072_콤보구성.md §1).
 *
 * 이 화면은 필터와 재조회가 섞여 있다. 속도개선 과제([E20241112-000596])가 핸들러별로만
 * 적용돼 Division 변경 경로에는 옛 재조회 코드가 그대로 남았기 때문이다(:1096-1120).
 *
 *   경로                    Team    End Customer    Sales Site
 *   진입      :157~186      필터    필터            필터
 *   Division  :1088~1120    필터    재조회          재조회
 *   Team      :1421~1427    -       필터            필터
 *   EndCust   :1406         -       -               필터
 *
 * 그래서 "방금 무엇을 바꿨는가"를 트리거로 들고 원천을 고른다 - DMF0004 SalesSiteTrigger 와
 * 같은 장치다. 같은 콤보인데 경로에 따라 목록이 달라지는 것이 AS-IS 동작이다.
 *
 * 재조회 경로는 파라미터를 싣고, 그 값이 바뀌면 SQL 이 다시 나간다. 필터 경로는 파라미터 없이
 * 전량을 받고 화면이 좁힌다 - 좁히는 규칙은 components/searchFields/bigFilterCombo 참조.
 */
export const SEARCH_COMBO = {
  /** 필터. 파라미터 없음. */
  division: 'FilterMyDivision',
  team: 'FilterTeambyDivision',
  /** 필터. 진입 / Team 변경 / End Customer 변경 경로. */
  endCustomer: 'FilterEndCustomerByDivision',
  salesSite: 'FilterSiteByEndCustomer',
  /** 재조회. Division 변경 경로 전용. */
  endCustomer40Requery: 'EndCustomerByDivision40',
  endCustomerRequery: 'EndCustomerByDivisionDept',
  salesSite40Requery: 'ScmSitebyEndCustomer40',
  salesSiteRequery: 'SiteByEndCustomer',
} as const;

/** 마지막으로 바뀐 조회조건. 초기값은 진입 경로와 같은 'team'(= 필터). */
export type SearchComboTrigger = 'division' | 'team' | 'endCustomer';

/** 재조회 경로인가. Division 변경 경로만 옛 코드가 남아 재조회다. */
export const isRequeryTrigger = (trigger: SearchComboTrigger) => trigger === 'division';

/** Project / End Customer 개념이 다른 Division (Mobility). AS-IS 원문 술어 그대로. */
export const DIVISION_NO_PROJECT = '40';

/** 40 전용 원천을 쓰는 Division. */
export const isDivision40 = (divisionId?: string) => divisionId === DIVISION_NO_PROJECT;

interface SearchComboSource {
  divisionId: string;
  deptId: string;
  endCustomer: string;
}

/**
 * 미선택은 공란으로 넘긴다. AS-IS GetDMInnerTable 진입부가 'ALL' 을 '' 로 바꾸고, 값이 비면
 * 그 단계를 아예 건너뛴다. 공란 규약은 콤보 파라미터에 한한다 - 스토어 조회조건 필드는
 * 종전대로 'ALL' 을 담아야 드롭다운 전체 체크가 유지되고 proc 요청 규약도 맞는다.
 */
const blank = (value?: string) => (!value || value === 'ALL' ? '' : value);

/**
 * End Customer 콤보 1건.
 *
 *   Division 변경 + 40   Data.Common(EndCustomerByDivision40, ...)                  :1100
 *   Division 변경 + 그 외 Data.UserEndCustomerByDivisionDept(...)                    :1113
 *   그 외 경로            SetChangeControl("EndCustomerByDivision", ...)  :168·:175·:1421
 */
export const buildEndCustomerComboParam = (
  trigger: SearchComboTrigger,
  { divisionId, deptId }: Pick<SearchComboSource, 'divisionId' | 'deptId'>
): ComboParam => {
  if (!isRequeryTrigger(trigger)) return { comboId: SEARCH_COMBO.endCustomer };
  return {
    comboId: isDivision40(divisionId)
      ? SEARCH_COMBO.endCustomer40Requery
      : SEARCH_COMBO.endCustomerRequery,
    divisionId,
    deptId: blank(deptId),
  };
};

/**
 * Sales Site 콤보 1건.
 *
 *   Division 변경 + 40   Data.ScmSitebyEndCustomer40(group, user, sDivision, "")   :1107
 *                        네 번째 인자가 Project 자리다 - 항상 빈 값이라 End Customer 를
 *                        골라도 채우지 않는다. 40 은 그 자리 값 체계가 다르다.
 *   Division 변경 + 그 외 Data.UserSiteByEndCustomer(group, user, sDivision, sEndCustomer) :1118
 *   그 외 경로            SetChangeControl("UserSiteByEndCustomer", div, string.Empty, ...)
 *                        :186 · :1406 · :1427 - 팀 자리는 항상 빈 값이다.
 */
export const buildSalesSiteComboParam = (
  trigger: SearchComboTrigger,
  { divisionId, endCustomer }: Pick<SearchComboSource, 'divisionId' | 'endCustomer'>
): ComboParam => {
  if (!isRequeryTrigger(trigger)) return { comboId: SEARCH_COMBO.salesSite };
  return isDivision40(divisionId)
    ? { comboId: SEARCH_COMBO.salesSite40Requery, divisionId, endCustomer: '' }
    : { comboId: SEARCH_COMBO.salesSiteRequery, divisionId, endCustomer: blank(endCustomer) };
};
