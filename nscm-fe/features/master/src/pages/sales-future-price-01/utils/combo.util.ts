// 콤보 원천 — 메인 조회조건(SEARCH_COMBO) · Price Batch Input 팝업 조회조건(PRICE_BATCH_COMBO).

// ===== 메인 조회조건 =====
/**
 * 조회조건 콤보 원천 (Doc/Combo/DMF0020_콤보구성.md §1).
 *
 * 전부 필터 방식이다. Filter 접두가 그 표시이며 파라미터 없이 전량을 한 번 받는다.
 * 쿼리 키가 고정이라 조회조건을 바꿔도 서버를 다시 치지 않는다 - AS-IS GetDMInnerTable 이
 * 세션 캐시 테이블을 LINQ 로 거르던 것과 같은 동작이다. 좁히는 일은 화면이 한다.
 *
 *   콤보                                목록 구성 조건            반환 컬럼
 *   FilterMyDivision          (#0)  없음                      CODE / NAME
 *   FilterTeambyDivision      (#1)  Division                  DIVISION_ID / CODE / NAME
 *   FilterEndCustomerByDivision(#2) Division + Team           DIVISION_ID / DEPT_ID / CODE / NAME
 *   FilterBizType             (#3)  Division                  DIVISION_ID / CODE / NAME
 *   FilterSiteByEndCustomer   (#4)  Division + End Customer   DIVISION_ID / DEPT_ID / END_CUSTOMER / CODE / NAME
 *   FilterPlantSiteByEndCustomer(#6) Division + End Customer  DIVISION_ID / END_CUSTOMER / CODE / NAME
 *
 * 컬럼 근거는 04.WSL/FoxQuery/DM/Common/BigFilter_list_line_dm_insert.sql 이다.
 *
 * 필수: Sales Site 는 DEPT_ID 로 좁히지 않는다. #4 의 40 외 분기가 DEPT_ID 를 NULL 로 채우므로
 * 팀을 걸면 그 분기가 통째로 사라진다. AS-IS 도 네 호출부 전부 팀 자리에 빈 값을 고정으로 넣는다.
 *
 * 주의: division 40 은 End Customer 자리에 Project Code 가 들어간다. #2 의 40 분기가
 * PROJECT_CODE 를 CODE 로 쓰고 #4 의 40 분기도 같은 값을 END_CUSTOMER 자리에 담아, 두 목록이
 * 같은 체계로 맞물린다. 화면 라벨만 "End Customer" 다.
 */
export const SEARCH_COMBO = {
  division: 'FilterMyDivision',
  team: 'FilterTeambyDivision',
  endCustomer: 'FilterEndCustomerByDivision',
  bizType: 'FilterBizType',
  salesSite: 'FilterSiteByEndCustomer',
  plantSite: 'FilterPlantSiteByEndCustomer',
} as const;

// 좁히는 규칙은 화면마다 같으므로 공용 모듈에 있다 - components/searchFields/bigFilterCombo.
export { buildComboOptions, toSelectedCodes } from '../../../components';

// ===== Price Batch Input 팝업 조회조건 =====
/**
 * Price Batch Input 팝업 조회조건 콤보 원천.
 *
 * 이 팝업 전용이다. 위 메인 화면 조회조건(SEARCH_COMBO)은
 * 전부 필터지만 이 팝업의 Sales Site 는 재조회다 - AS-IS 가 팝업 안에서 목록을 직접 다시 받는다.
 * BigFilter 를 타지 않는다.
 *
 *   콤보         방식     목록 구성 조건                          실제 호출
 *   Sales Site   재조회   Division + 본화면에서 받은 End Customer  SiteByEndCustomer
 *
 * 근거: DMF0020_SaveSalesFuturePrice_Popup.cs InitControls :318 · Division 변경 :2173 -
 *   Data.UserSiteByEndCustomer(NowGroupID, UserId, division, sEndCustomer)  [C20210127-000163]
 *
 * 금지: AS-IS 의 Data.UserXxx 이름을 콤보 ID 로 쓰지 말 것. 그건 C# 래퍼 이름이고 실제 등록명은
 * 안에서 부르는 문자열이다 - Data.UserSiteByEndCustomer -> CallBizCommonData("SiteByEndCustomer", ...).
 *
 * End Customer 는 팝업이 만들지 않는다. 팝업에 End Customer 칸 자체가 없고, 메인 화면이 팝업을
 * 열 때 넘긴 값을 팝업 수명 내내 그대로 쓴다 (메인 :2377 -> LoadData :212 sEndCustomer_).
 * Division 을 바꿔도 그 값은 그대로다(:2173 이 같은 필드를 다시 읽는다).
 *
 * 40 갈래를 따로 두지 않는다. AS-IS 가 사업부와 무관하게 이 원천 하나만 부르고, 등록 SQL 이
 * 40 분기를 자체적으로 갖는다 - NVL(@divisionId,'~')='40' 갈래는 @endCustomer 를 END_CUSTOMER 가
 * 아니라 PROJECT_CODE 와 대조한다(40 은 End Customer 자리에 Project Code 가 들어간다는 규약이
 * SQL 에도 그대로 있다). 이 SQL 은 DMF0042 business-plan 도 같은 ID 로 쓴다.
 *
 * 재조회라 목록 구성 조건이 전부 콤보 파라미터로 실린다 - 그중 하나라도 바뀌면 react-query 키가
 * 달라져 SQL 이 다시 나간다(refetch 를 직접 부르지 않는다).
 */
export const PRICE_BATCH_COMBO = {
  salesSite: 'SiteByEndCustomer',
} as const;

/**
 * Sales Site 에 실을 End Customer 파라미터.
 *
 * 미선택(전체선택 'ALL' 포함)은 'ALL' 센티널로 보낸다 - 등록 SQL 이 @endCustomer='ALL' 을 직접
 * 처리한다. AS-IS 는 이 자리에 CString.GetCheckedListValue 로 목록 전체를 펼쳐 넣지만 그 방식은
 * 쓸 수 없다: 값이 4000byte 를 넘겨 ORA-01704(string literal too long)로 실패한다(DMF0042 실측 -
 * demand/business-plan/utils/business-plan.searchCombos 주석).
 *
 * 스토어 조회조건 필드는 종전대로 'ALL' 을 담아야 드롭다운 전체 체크가 유지되므로, 이 규약은
 * 콤보 파라미터에 한한다.
 */
export const resolveBatchEndCustomer = (endCustomers?: readonly string[]): string => {
  const selected = (endCustomers ?? [])
    .map(value => String(value).trim())
    .filter(value => value !== '' && value.toUpperCase() !== 'ALL')
    .join(',');
  return selected === '' ? 'ALL' : selected;
};
