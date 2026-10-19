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
