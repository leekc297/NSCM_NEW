import type { ComboParam } from '@foundation/models';

/**
 * Team(DEPT_ID) 파생용 콤보 조회 파라미터.
 *
 * 드롭다운과는 무관하다. 셀 콤보의 후보·표시·행별 좁힘은 전부 컬럼 메타
 * (cellCboDataTp / PARAM2 / PARAM9 / PARAM10)가 단일 원천이고 공용 DataGrid 가 그 메타대로
 * 만든다. 화면이 col.dataMap 을 만들어 붙이면 그 설정이 통째로 무효가 된다.
 *
 * 여기가 남아 있는 이유는 하나뿐이다 — Team 은 전 division 입력 불가(insertStaticEditable)라
 * 스스로 값을 가질 수 없고, End Customer / Sales Site / Project / Model 을 고른 그 행이 함께
 * 내려주는 DEPT_ID 로만 채워진다. 공용 계층은 콤보 조회 결과를 화면에 돌려주지 않으므로 그
 * 원본 행을 얻는 경로가 이것뿐이다. 후보를 좁힐 필요가 없으므로 division 전량을 받는다.
 *
 * 필수: 콤보 파라미터는 bind 변수가 아니라 텍스트 치환이다 — LookupServiceImpl.retrieveCombo →
 * BaseService.makeComboQuery 가 등록 SQL(SCM_ADM_CMBO_SQL_M.SQL_DTL_CTN)의 @key 를 전달 문자열로
 * 그대로 갈아끼운다. 따옴표는 호출자가 붙여야 한다. 미인용 시 숫자 코드인 divisionId 만 우연히
 * 통과하고 'ALL' 같은 문자값은 식별자로 해석돼 오류 → 빈 콤보가 된다.
 */
const quote = (value: string): string => `'${value.trim() !== '' ? value : 'ALL'}'`;

export const buildSalesPlanTeamSourceFilter = (
  metadataComboId: string,
  divisionId: string
): ComboParam => ({ comboId: metadataComboId, divisionId: quote(divisionId) });
