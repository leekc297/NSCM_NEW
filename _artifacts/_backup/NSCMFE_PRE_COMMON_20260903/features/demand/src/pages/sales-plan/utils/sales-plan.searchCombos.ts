import { isDiv40 } from './sales-plan.division';

/**
 * 조회조건 콤보 원천 (Doc/Combo/DMF0021_콤보구성.md §1).
 *
 * 이 화면은 조회조건 6종이 전부 필터다 - 파라미터 없이 전량을 한 번 받고 좁히는 일은 화면이
 * 한다. 규칙은 features/master/src/components/searchFields/bigFilterCombo 참조.
 * Item Type 과 Bucket 만 재조회이며 현행 콤보 ID 를 그대로 쓴다.
 *
 *   Filter 콤보                     목록 구성 조건            AS-IS 근거
 *   FilterMyDivision                없음                      InitControls :430
 *   FilterTeambyDivision            Division                  :5154
 *   FilterEndCustomerByDivision     Division + Team           :5173·:5195 / :5353·:5380
 *   FilterBizType                   Division                  :5166·:5188
 *   FilterSiteByEndCustomer         Division + End Customer   :503 / :5219 / :5129 / :5375·:5384
 *   FilterPlantSiteByEndCustomer    Division + End Customer   :510   (진입)
 *   FilterFromSiteByDivision        Division                  :5226  (Division 변경)
 */
export const SEARCH_COMBO = {
  division: 'FilterMyDivision',
  team: 'FilterTeambyDivision',
  endCustomer: 'FilterEndCustomerByDivision',
  bizType: 'FilterBizType',
  salesSite: 'FilterSiteByEndCustomer',
  plantSiteByEndCustomer: 'FilterPlantSiteByEndCustomer',
  plantSiteByDivision: 'FilterFromSiteByDivision',
} as const;

/** Sales Site 목록을 다시 만든 계기. 무엇을 바꿨느냐로 팀 반영 여부가 갈린다. */
export type SearchComboTrigger = 'entry' | 'division' | 'team' | 'endCustomer';

/** Plant Site 목록의 원천. 진입과 Division 변경이 서로 다른 SQL 을 쓴다. */
export type PlantSiteSource = 'entry' | 'division';

/** 전체선택('ALL')과 전체해제는 필터상 같다 - 둘 다 빈 목록 = 그 축 미적용이다. */
const toCodes = (values: readonly string[]): string[] =>
  values
    .map(value => String(value).trim())
    .filter(value => value !== '' && value.toUpperCase() !== 'ALL');

/**
 * Sales Site 에 걸 DEPT_ID - AS-IS 는 다섯 호출부 중 한 곳에서만 팀을 넘긴다.
 *
 *   진입           :503   (sDivision, string.Empty, sEndCustomer)
 *   Division 변경  :5219  (sDivision, string.Empty, sEndCustomer)
 *   End Customer   :5129  (ControlValues, string.Empty, ControlValues)
 *   Team 변경 81·82 :5375 (sDivision, string.Empty, sEndCustomer)
 *   Team 변경 그 외 :5384 (sDivision, clbTeam.ControlValues, ...)   <- 여기만 팀이 걸린다
 *
 * 같은 콤보가 무엇을 바꿨느냐에 따라 다르게 동작한다. AS-IS 결함으로 보이지만 화면에 보이는
 * 목록이 실제로 달라지므로 그대로 옮긴다(DMF0014·DMF0048 에도 같은 형태가 있다).
 */
export const resolveSalesSiteDeptIds = (
  trigger: SearchComboTrigger,
  divisionId: string,
  deptIds: readonly string[]
): string[] => (trigger === 'team' && isDiv40(divisionId) ? toCodes(deptIds) : []);

/**
 * Sales Site · Plant Site 에 걸 END_CUSTOMER - 고른 값만 쓰고 펼치지 않는다.
 *
 * AS-IS 는 네 호출부 모두 CString.GetCheckedListValue(dtCustomer, ...) 또는 ControlValues 를
 * 그대로 넘기는데, dtCustomer 는 :78 에서 null 로 선언된 뒤 대입이 전부 주석 처리되어 있다
 * (:5171 · :5193 · :5352 등). 테이블이 null 이면 받은 값이 그대로 돌아오므로(CString.cs :531)
 * 이 화면에는 펼치기 경로가 아예 없다 - 문서 §4-3 이 지적한 결함이다.
 *
 * 그래서 전체선택은 축을 끄고, END_CUSTOMER 가 비어 있는 사이트 행도 살아남는다.
 * options 는 받지 않고 무시한다 - 펼치는 화면과 호출 모양을 맞춰 두려는 것뿐이다.
 */
export const resolveEndCustomerCodes = (
  selected: readonly string[],
  _options: readonly { value: string }[]
): string[] => toCodes(selected);

/** Plant Site 원천 선택 - 두 결과셋은 원본 SQL 이 달라 목록이 서로 다르다. */
export const resolvePlantSiteComboId = (source: PlantSiteSource): string =>
  source === 'division' ? SEARCH_COMBO.plantSiteByDivision : SEARCH_COMBO.plantSiteByEndCustomer;
