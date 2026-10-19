/**
 * 그리드 셀 콤보 요청 출처 표식.
 *
 * useTabComboQueries 의 src 로 넘기면 요청 URL 이 `admin/combo?src=grid` 가 되어 Network 탭에서
 * 검색조건 콤보와 바로 구분된다. 본문에는 안 실린다 - 본문 키는 BE makeComboQuery 가 등록 SQL 의
 * @키 로 치환하는 대상이라 진단용 값이 SQL 경로에 섞이면 안 된다.
 *
 * 쿼리 키에도 들어가므로 같은 콤보를 검색조건과 그리드가 함께 써도 요청이 하나로 접히지 않는다 -
 * 접히면 Network 탭에 한 건만 남아 출처를 가릴 수 없다.
 */
export const GRID_COMBO_SRC = 'grid';
