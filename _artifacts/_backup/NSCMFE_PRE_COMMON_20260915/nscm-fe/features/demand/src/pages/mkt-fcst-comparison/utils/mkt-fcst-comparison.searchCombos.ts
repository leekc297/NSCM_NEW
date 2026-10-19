/**
 * 조회조건 콤보 원천 (사용자 지정 2026-09-01 — DMF0048 Sales Monitoring 과 같은 구성).
 *
 * 여섯 칸이 전부 필터다 - 파라미터 없이 전량을 한 번 받고 좁히는 일은 화면이 한다.
 * 규칙은 features/master/src/components/searchFields/bigFilterCombo 참조.
 * Bucket / QTY / Item Type 만 재조회로 남으며 현행 콤보 ID 를 그대로 쓴다.
 *
 *   Filter 콤보                     목록 구성 조건
 *   FilterMyDivision                없음 (단순 호출)
 *   FilterTeambyDivision            Division
 *   FilterEndCustomerByDivision     Division + Team
 *   FilterBizType                   Division
 *   FilterSiteByEndCustomer         Division + End Customer (40 은 Team 까지)
 *   FilterFromSiteByDivision        Division
 *
 * 원천별 반환 컬럼은 GSCm/04.WSL/FoxQuery/DM/Common/BigFilter_list_line_dm.md 참조.
 */
export const SEARCH_COMBO = {
  division: 'FilterMyDivision',
  team: 'FilterTeambyDivision',
  endCustomer: 'FilterEndCustomerByDivision',
  bizType: 'FilterBizType',
  salesSite: 'FilterSiteByEndCustomer',
  plantSite: 'FilterFromSiteByDivision',
} as const;

/** AS-IS D-04 (cboDivision L968): 40 = Project · Plant Site 비활성 (81 계열 · 82 = 활성). */
export const isDiv40 = (divisionId?: string): boolean => (divisionId ?? '').trim() === '40';

/**
 * Sales Site 에 걸 DEPT_ID - 40 사업부에서만 걸린다.
 *
 * FilterSiteByEndCustomer(#4)는 두 갈래 UNION 인데 40 외 분기가 DEPT_ID 를 빈 문자열로 고정해
 * 내려준다(BigFilter_list_line_dm.md #4 구성①). 81 계열·82 에 팀 축을 걸면 어떤 팀 코드와도
 * 맞지 않아 목록이 통째로 빈다 - AS-IS 프레임워크가 DIVISION_ID != '40' 이면 팀 조건을 강제로
 * 지우는 것과 같은 이유다(DataService.cs:3891~3894). 임의 규칙이 아니라 데이터 구조다.
 */
export const resolveSalesSiteDeptIds = (
  divisionId: string,
  deptIds: readonly string[]
): readonly string[] => (isDiv40(divisionId) ? deptIds : []);

/**
 * Sales Site 에 걸 END_CUSTOMER 코드 — Team 이 Sales Site 까지 전달되는 경로다.
 *
 * AS-IS 는 Sales Site 콤보에 팀 자리를 비워 넘기고(`SetChangeControl("UserSiteByEndCustomer",
 * sDivision, string.Empty, sEndCustomer)`), 그 sEndCustomer 를
 * `CString.GetCheckedListValue(dtCustomer, clbCustomer.ControlValues)` 로 만든다. 이 함수가
 * 'ALL'(미선택)을 그 시점 dtCustomer 전체 CODE 로 **펼친다.** dtCustomer 는 이미
 * Division + Team 으로 좁혀져 있으므로, 펼치기가 곧 팀을 Sales Site 에 반영하는 길이다.
 * (자매 화면 DMF0053 .cs:324 · :928 · :955 에 같은 형태가 남아 있다)
 *
 * 필수: 미선택을 "축 미적용"으로 떨어뜨리지 말 것. 그러면 Team 을 골라도 Sales Site 가 그대로라
 * 목록 구성 조건 "Division + Team + End Customer" 가 깨진다. 같은 규칙이 DMF0048
 * Sales Monitoring · SalesSiteProjectModel 에도 있다.
 *
 * 목록이 비면 빈 배열 = 그 축 미적용이다 - AS-IS 도 펼친 결과가 공란이면 Count == 0 분기로
 * 떨어져 전량이 흐른다.
 */
export const resolveSalesSiteEndCustomers = (
  selectedEndCustomers: readonly string[],
  endCustomerOptions: readonly { value: string }[]
): readonly string[] =>
  selectedEndCustomers.length > 0
    ? selectedEndCustomers
    : endCustomerOptions.map(option => option.value);
