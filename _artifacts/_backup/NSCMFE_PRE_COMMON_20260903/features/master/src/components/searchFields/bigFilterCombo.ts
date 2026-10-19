import type { ComboResponse } from '@foundation/models';

/**
 * Filter 콤보 옵션 만들기 — AS-IS DataService.GetDMInnerTable 재현.
 *
 * 그 함수는 세션당 한 번 받아 둔 데이터셋(list_line_dm)을 메모리에서 거른다. TO-BE 는 등록
 * SQL(Filter*)이 같은 결과셋을 내려주고, 거르는 일을 화면이 대신한다. 규칙은 세 가지이며
 * 콤보 종류와 무관하게 동일하다.
 *
 *   1) 축별 필터
 *        (Codes.Contains(row[column]) || Codes.Count == 0)
 *      필터 목록이 비면 그 축은 미적용이고, 값이 있으면 행의 셀이 그 안에 있어야 통과한다.
 *      행의 셀이 비었다고 통과시키지 않는다(엄격). division 을 지정하면 DIVISION_ID 가 NULL 인
 *      행이 잘리고, End Customer 를 고르면 그 컬럼이 NULL 인 행이 잘린다.
 *
 *   2) GroupBy(CODE)
 *      중복 제거 키는 CODE 하나뿐이다. division 을 키에 섞으면 안 된다 - 같은 코드가 사업부
 *      수만큼 중복으로 뜬다. 같은 CODE 가 여럿이면 첫 행의 NAME 을 쓴다.
 *
 *   3) OrderBy(CODE)
 *      표시명이 아니라 코드 순이다. 화면이 CustomDropdown 의 sortBy 를 켜면 그것이 이긴다.
 *
 * 미선택 규약: 진입부가 DIVISION_ID / DEPT_ID / END_CUSTOMER 의 'ALL' 을 공란으로 바꾼 뒤
 * CommaToList 를 태우므로, 'ALL' 은 결국 빈 목록 = 그 축 미적용이 된다.
 *
 * ====================================================================================
 * 필터인가 재조회인가 - 콤보구성 문서의 "방식" 열이 가른다
 * ====================================================================================
 * 필터   comboId 에 Filter 접두를 붙이고 파라미터를 싣지 않는다. 전량을 한 번 받아 이 함수로
 *        좁힌다. 쿼리 키가 고정이라 조회조건을 바꿔도 서버를 다시 치지 않는다.
 *
 * 재조회 "목록 구성 조건"에 적힌 값을 전부 콤보 파라미터로 싣는다. 그중 하나라도 바뀌면 SQL 을
 *        다시 호출한다 - 파라미터가 react-query 키에 들어가므로 자동으로 재조회된다(refetch 를
 *        직접 부르지 않는다). comboId 는 접두 없이 그대로 쓴다.
 *
 *        필수: 재조회 응답에는 이 함수의 축을 하나도 걸지 말 것. 서버가 이미 좁혀서 CODE / NAME
 *        만 내려주므로 DIVISION_ID 조차 없다. 축을 걸면 엄격 매칭에서 전 행이 잘려 "값은
 *        내려오는데 옵션이 0건"이 된다. 축 없이 buildComboOptions(rows) 로만 부른다.
 */

export interface ComboOption {
  label: string;
  value: string;
}

const cell = (row: ComboResponse, column: string) => {
  const raw = row[column] as string | number | null | undefined;
  return raw === null || raw === undefined ? '' : String(raw).trim();
};

/**
 * 실제로 고른 코드만 남긴다. 전체선택('ALL')과 전체해제는 필터상 같다 - 둘 다 빈 배열이 되어
 * 그 축이 미적용된다 (GetDMInnerTable 진입부의 'ALL' -> '' 치환과 같은 결과).
 */
export const toSelectedCodes = (values?: readonly string[]) =>
  (values ?? []).map(v => String(v).trim()).filter(v => v !== '' && v.toUpperCase() !== 'ALL');

/** 좁힐 축 하나. column 은 콤보가 내려주는 컬럼명, codes 는 화면의 선택값. */
export interface ComboAxis {
  column: string;
  codes: readonly string[];
}

/**
 * 콤보 행을 좁혀 드롭다운 옵션으로. 규칙은 이 파일 헤더 참조.
 *
 * division 은 축 이름이 고정이라 편의로 따로 받는다. 아예 안 넘기면 그 축이 없는 것으로 본다 -
 * DIVISION_ID 컬럼을 내려주지 않는 FilterMyDivision 이 그 경우다.
 *
 * narrow 는 축 하나 또는 여럿이다. AS-IS 도 콤보에 따라 축이 여럿이다 - 예컨대
 * UserSiteByEndCustomer 는 DIVISION_ID · DEPT_ID · END_CUSTOMER 세 축을 함께 건다.
 * 코드가 빈 축은 자동으로 미적용이라, 걸지 않을 축은 빈 배열로 넘기면 된다.
 */
export const buildComboOptions = (
  rows: ComboResponse[] | undefined,
  filters?: { division?: string; narrow?: ComboAxis | ComboAxis[] }
): ComboOption[] => {
  const narrowAxes = filters?.narrow
    ? Array.isArray(filters.narrow)
      ? filters.narrow
      : [filters.narrow]
    : [];
  const axes: ComboAxis[] = [
    { column: 'DIVISION_ID', codes: filters?.division ? [filters.division] : [] },
    ...narrowAxes,
  ]
    .map(axis => ({ column: axis.column, codes: toSelectedCodes(axis.codes) }))
    .filter(axis => axis.codes.length > 0);

  // 같은 CODE 가 여럿이면 첫 행이 이긴다 - AS-IS GroupBy(...).First() 와 같다.
  //   Map 생성자는 나중 값이 이기므로 직접 넣으면서 이미 있는 키는 건너뛴다.
  const byCode = new Map<string, ComboOption>();
  for (const row of rows ?? []) {
    if (!axes.every(axis => axis.codes.includes(cell(row, axis.column)))) continue;
    const code = cell(row, 'CODE');
    if (code === '' || byCode.has(code)) continue;
    byCode.set(code, { label: cell(row, 'NAME') || code, value: code });
  }
  return [...byCode.values()].sort((a, b) => a.value.localeCompare(b.value));
};
