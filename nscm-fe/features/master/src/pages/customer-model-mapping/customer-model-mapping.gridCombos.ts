import { DataMap } from '@mescius/wijmo.grid';

import type { ComboResponse } from '@foundation/models';
import { filterComboRowsByRowItem } from '@foundation/utils';

/**
 * DMF0006 Team(DEPT_ID) 셀 콤보 — 표시와 신규행 후보의 원천을 나눈다.
 *
 * 표시는 컬럼 메타(CELL_COMBO_DATA_TYPE = 'DeptId')가 담당한다. 조회 결과에는 지금 division 밖·
 * 권한 밖 팀도 섞여 오므로 코드를 이름으로 바꾸려면 넓은 목록이 필요하다. 반대로 신규 입력 후보는
 * 그 division 의 팀으로 좁혀야 해서 아래 콤보를 쓴다. DMF0003(mkt-fcst) TEAM_ID 와 같은 구성이다.
 *
 * 메타에는 콤보를 하나만 등록할 수 있어 후보 콤보 id 만 화면 상수로 든다 — 표시 콤보 id 는
 * 하드코딩하지 않는다(메타가 유일한 출처).
 */

/**
 * 신규행 Team 드롭다운 후보 콤보.
 *
 * 파라미터는 그리드가 이미 싣는 @divisionId 하나다. 등록 SQL 에 그 토큰이 없으면 BE(makeComboQuery)
 * 가 치환 대상을 못 찾고 넘어가므로 전달 자체는 무해하다.
 *
 * 필수: 콤보 SQL 은 CODE/NAME 별칭이어야 한다. 공용 매핑(columnMapping.getDataMap)도 아래
 * buildTeamDataMap 도 new DataMap(rows, 'CODE', 'NAME') 고정이라, 별칭이 다르면 행이 와도 매핑이
 * 0건이 되어 후보가 비고 셀에는 코드가 그대로 남는다.
 *
 * 필수: 이름은 등록값(SCM_ADM_CMBO_SQL_M.SQL_ID)과 대소문자까지 정확히 같아야 한다. BE 는
 * `SQL_ID = #{comboId}` 정확 일치로 찾고, 못 찾으면 500 을 내는데 그 500 은 응답 인터셉터가
 * 정상 응답으로 되돌려 result=null 이 되므로 화면에는 오류 없이 빈 목록으로만 나타난다.
 * 팀 콤보 등록명은 'TeambyDivision'(by 가 소문자)다 — 'TeamByDivision' 은 등록돼 있지 않다.
 */
export const TEAM_INSERT_COMBO_ID = 'TeambyDivision';

/** 콤보 응답 1행이 쓸 수 있는가 — CODE 별칭이 있고 값이 비어 있지 않은가. */
export const hasCode = (row: ComboResponse): boolean => String(row?.CODE ?? '').trim() !== '';

/**
 * Team 컬럼 DataMap — superset 하나만 만들고 후보 목록만 행 컨텍스트로 좁힌다.
 *
 * 금지: beginningEdit 에서 column.dataMap 을 후보 콤보로 갈아끼우지 말 것. dataMap 은 셀이 아니라
 * 컬럼 속성이라 한 셀이 편집에 들어가는 순간 그 컬럼 전 행이 좁혀진 맵을 타고, 맵에 없는 코드는
 * DataMap.getDisplayValue 가 원값(코드)을 그대로 돌려준다 — "Team 셀에 포커스만 가면 이름이
 * 코드로 바뀌었다 돌아온다"(2026-08-21 DMF0049 실사고). 대안이 이 getDisplayValues 처방이고,
 * 정본은 etc-sales-reports.gridCombos.ts buildDeptIdDataMap 이다.
 *
 * superset 이어야 하는 이유는 표시만이 아니다. 사용자가 드롭다운에서 고른 이름을 코드로 되돌리는
 * DataMap.getKeyValue 도 같은 컬렉션에서 찾는다 — 후보 콤보 행이 컬렉션에 없으면 신규행에서 고른
 * 팀이 빈 값으로 커밋된다.
 *
 * 순서: 표시 콤보를 앞에 둔다. 같은 CODE 가 양쪽에 있으면 DataMap 내부 색인은 첫 항목만 담으므로
 * 표시명이 메타 콤보 기준으로 고정되고, 후보 라벨도 같은 맵을 거쳐 만들어 드롭다운과 셀이 같은
 * 이름 체계를 쓴다.
 *
 * @param display 메타 콤보 응답 (표시 원천)
 * @param insert  TEAM_INSERT_COMBO_ID 응답 (신규행 후보)
 * @param cascade 컬럼 메타 ATTRIBUTE2 — 조회행 후보를 행 값으로 좁히는 기존 규약을 그대로 유지한다
 */
export const buildTeamDataMap = (
  displayRows: ComboResponse[],
  insertRows: ComboResponse[],
  cascade?: string
): DataMap | null => {
  // CODE 가 없는 행은 버린다. 콤보 SQL 별칭이 다르면(DEPT_ID/DEPT_NAME 등) 행은 오는데 CODE 가
  //   undefined 라, 그대로 두면 DataMap 이 키 없는 항목을 만들어 드롭다운에 빈 줄만 늘어선다
  //   (실측: new DataMap(별칭불일치행,'CODE','NAME').getDisplayValues() === [null, null]).
  //   여기서 걸러 0건으로 만들면 아래 폴백이 동작해 최소한 고를 수 있는 목록이 남는다.
  const display = displayRows.filter(row => hasCode(row));
  const insert = insertRows.filter(row => hasCode(row));
  if (display.length === 0 && insert.length === 0) return null;

  const dataMap = new DataMap([...display, ...insert], 'CODE', 'NAME');
  const labels = (rows: ComboResponse[]): string[] =>
    rows.map(row => String(dataMap.getDisplayValue(row.CODE)));

  dataMap.getDisplayValues = (rowItem?: unknown): string[] => {
    const row = (rowItem ?? {}) as WijmoRowItem;
    // 신규행(GridAction.addRow 가 심는 CRUD_TYPE='I')만 후보 콤보를 쓴다.
    //   후보가 0건이면(미등록 콤보/파라미터 불일치) 표시 콤보를 그대로 준다 — 드롭다운이 비어
    //   아무 팀도 못 고르는 상태로 굳는 것보다 낫다.
    if (row.CRUD_TYPE === 'I' && insert.length > 0) return labels(insert);
    // 조회행은 종전대로 메타 cascade(ATTRIBUTE2) 규약을 따른다 — 공용 getDataMap 과 같은 함수라
    //   "드롭다운에 뜨는 값 = 셀에 남을 수 있는 값" 불변식이 갈리지 않는다.
    return labels(filterComboRowsByRowItem(display, cascade, row));
  };

  return dataMap;
};
