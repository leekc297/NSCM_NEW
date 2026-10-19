import type { ComboParam } from '@foundation/models';

import { isDiv40 } from './business-plan.division';

/**
 * 조회조건 콤보 원천 (Doc/Combo/DMF0042_콤보구성.md §1).
 *
 * 이 화면은 BigFilter 미적용이다(§0) - SetChangeControl / GetDMInnerTable 이 한 줄도 없고
 * End Customer / Sales Site / Plant Site 가 전부 재조회다. 조회조건을 파라미터로 실으므로
 * 그중 하나라도 바뀌면 react-query 키가 달라져 SQL 이 다시 나간다.
 *
 * Division 과 Team 만 전 화면 공통 규칙에 따라 필터(Filter 접두)를 쓴다 - 화면 컴포넌트 참조.
 *
 *   콤보                        방식     목록 구성 조건                  AS-IS
 *   EndCustomerByDivision40     재조회   Division + Team          (40)   :271 · :1505 · :1588
 *   EndCustomerByDivisionDept   재조회   Division + Team        (그 외)  :283 · :1517 · :1581
 *   SiteByEndCustomer           재조회   Division + End Customer         :312 · :1545 · :1584 · :1603
 *   SiteByEndCustomer40         재조회   Division + Team + End Customer  :1591 · :1607
 *   FromSiteByDivision          재조회   Division                        :316 · :1548
 */
export const SEARCH_COMBO = {
  endCustomer40: 'EndCustomerByDivision40',
  endCustomerByDept: 'EndCustomerByDivisionDept',
  salesSite: 'SiteByEndCustomer',
  salesSite40: 'SiteByEndCustomer40',
  plantSite: 'FromSiteByDivision',
} as const;

/**
 * 마지막으로 바뀐 조회조건. Sales Site 원천이 경로에 따라 갈리기 때문에 필요하다.
 * 초기값은 진입 경로와 같은 'division'.
 */
export type SearchComboTrigger = 'division' | 'team' | 'endCustomer';

interface SearchComboSource {
  divisionId: string;
  deptIds: string[];
  endCustomers: string[];
}

/**
 * 미선택은 공란으로 넘긴다. 값이 비면 SQL 이 그 단계를 건너뛴다. 공란 규약은 콤보 파라미터에
 * 한한다 - 스토어 조회조건은 종전대로 'ALL' 을 담아야 드롭다운 전체 체크가 유지된다.
 */
const joinSelected = (values: readonly string[]) =>
  values
    .map(v => String(v).trim())
    .filter(v => v !== '' && v.toUpperCase() !== 'ALL')
    .join(',');

/** End Customer - 원천만 40 여부로 갈리고 목록 구성 조건은 같다. */
export const buildEndCustomerComboParam = ({
  divisionId,
  deptIds,
}: Pick<SearchComboSource, 'divisionId' | 'deptIds'>): ComboParam => ({
  comboId: isDiv40(divisionId) ? SEARCH_COMBO.endCustomer40 : SEARCH_COMBO.endCustomerByDept,
  divisionId,
  deptId: joinSelected(deptIds),
});

/**
 * Sales Site 에 넘길 End Customer 코드 집합. AS-IS CString.GetCheckedListValue 재현이다.
 *
 * 미선택은 그 시점 End Customer 목록의 전체 CODE 로 펼쳐진다. Team 을 바꾸면 End Customer 가
 * 팀으로 좁혀지고(clbTeam_SelectedIndexChanged :1581) 그 좁혀진 집합이 Sales Site 파라미터로
 * 들어가므로, 이 펼치기가 곧 Team 을 Sales Site 에 반영하는 경로다. Sales Site 콤보에 팀을
 * 직접 넘기지는 않는다(40 분기 제외).
 *
 * 필수: 미선택을 공란으로 떨어뜨리면 안 된다. 그러면 Team 을 골라도 Sales Site 가 좁혀지지
 * 않고 오히려 넓어진다. 목록이 비었을 때만 빈 배열이 되며, AS-IS 도 빈 테이블에서 공란을 준다.
 */
export const resolveEndCustomerCodes = (
  selected: readonly string[],
  options: readonly { value: string }[]
): string[] => {
  const codes = selected
    .map(v => String(v).trim())
    .filter(v => v !== '' && v.toUpperCase() !== 'ALL');
  return codes.length > 0 ? codes : options.map(option => option.value);
};

/**
 * Sales Site - 경로와 40 여부가 함께 원천을 정한다.
 *
 * 진입과 Division 변경은 40 이어도 SiteByEndCustomer 를 쓴다(:312 · :1545). Team 이나
 * End Customer 를 바꿨을 때만 40 이 SiteByEndCustomer40 으로 갈아끼며 팀이 함께 실린다
 * (:1591 · :1607).
 *
 * 주의: 그래서 40 사업부는 진입 직후와 조건 변경 후의 목록이 다르다. SiteByEndCustomer 가 40 을
 * 제외하는 쿼리라 진입 시 목록이 비어 나올 수 있다 - 문서 §1 이 지적한 AS-IS 결함이다.
 */
export const buildSalesSiteComboParam = (
  trigger: SearchComboTrigger,
  { divisionId, deptIds, endCustomers }: SearchComboSource
): ComboParam => {
  const endCustomer = joinSelected(endCustomers);
  if (trigger === 'division' || !isDiv40(divisionId)) {
    return { comboId: SEARCH_COMBO.salesSite, divisionId, endCustomer };
  }
  return {
    comboId: SEARCH_COMBO.salesSite40,
    divisionId,
    deptId: joinSelected(deptIds),
    endCustomer,
  };
};

/**
 * Plant Site - 원천이 하나뿐이다. AS-IS 는 UserPlantSiteByEndCustomer 호출이 주석 처리돼 있고
 * UserPlantSiteByDivision 만 산다(:315-316 · :1548). 그래서 End Customer 는 걸지 않는다.
 */
export const buildPlantSiteComboParam = ({
  divisionId,
}: Pick<SearchComboSource, 'divisionId'>): ComboParam => ({
  comboId: SEARCH_COMBO.plantSite,
  divisionId,
});
