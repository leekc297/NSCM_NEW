import {
  ALL,
  COLUMN,
  ORG_DIVISION_FALLBACK_DIVISION,
  OSP_EXCLUDE_DIVISION,
  OSP_EXCLUDE_SHEETS,
  PLANT_SEQ_NORMAL,
  type GridSheet,
} from '../opt-capa.constants';
import type { ComboOption, LineRow, LineTypeRow, OperationRow, PlantRow } from '../opt-capa.types';

/**
 * 조회조건/셀 콤보 후보 산출 — AS-IS 클라 후처리 필터의 순수함수 이식(design 02 §2.4 F-01~F-12).
 *
 * 이 필터들은 **이관된 SP/CMBO SQL 안에 없다**(convert-core §2.6 "핵심 원칙") — AS-IS 가 SP 호출
 * 뒤 `DBUtils.Filter` 로 건 것이라 FE 가 재현하지 않으면 후보 집합이 조용히 넓어진다.
 *
 * 전 단계가 **필터형**이고 재조회형이 0건이다 — `init` SEARCH 1회로 받은 마스터를 클라에서만
 * 좁힌다(design 02 §3.2). 단계마다 파라미터 실은 콤보를 새로 등록하면 AS-IS 와 호출 횟수·후보
 * 범위가 둘 다 달라진다.
 */

export const str = (value: unknown): string =>
  typeof value === 'string' ? value : typeof value === 'number' ? String(value) : '';

/** 다중선택 값이 ALL 인가 — sentinel 또는 미선택(빈 배열)은 AS-IS `UsrCheckedList2` 의 ALL 이다. */
export const isAllSelected = (values: readonly string[]): boolean =>
  values.length === 0 || values.includes(ALL);

/**
 * `82` × 활성시트 ∈ {Daily Capa, No Work} 일 때만 OSP(`SEQ=2`)를 제외한다.
 * AS-IS cs:369-376 / 416-423 / 526-533 — 2025-09-03 PJ20257329.
 */
export const needsSeqNormalOnly = (divisionId: string, activeSheet: GridSheet): boolean =>
  divisionId === OSP_EXCLUDE_DIVISION && OSP_EXCLUDE_SHEETS.includes(activeSheet);

const seqOf = (row: PlantRow): string => str(row.SEQ);

const applySeqFilter = <T extends PlantRow>(
  rows: readonly T[],
  divisionId: string,
  activeSheet: GridSheet
): T[] =>
  needsSeqNormalOnly(divisionId, activeSheet)
    ? rows.filter(row => seqOf(row) === PLANT_SEQ_NORMAL)
    : [...rows];

/**
 * `EE_UC` 대표행의 `ORG_DIVISION_ID` — 없으면 `undefined`(= 축 전환 불가 → DIVISION_ID 유지).
 * AS-IS 는 `dtTemp.Rows.Count > 0` 일 때만 필터를 갈아끼운다(cs:362-366 · 448-453).
 */
const orgDivisionOf = (rows: readonly PlantRow[], divisionId: string): string | undefined => {
  if (divisionId !== ORG_DIVISION_FALLBACK_DIVISION) return undefined;
  const representative = rows.find(row => str(row.DIVISION_ID) === divisionId);
  const org = str(representative?.ORG_DIVISION_ID);
  return org || undefined;
};

/**
 * Division 축 필터 — `EE_UC` 만 `ORG_DIVISION_ID` 로 **완전 대체**한다(`DIVISION_ID` 조건을 남기지
 * 않는다 — AS-IS 가 `strFilter` 를 덮어쓰기 때문, cs:364 · 452). 그래서 `81_UC` 마스터가 함께 들어온다.
 */
const filterByDivisionAxis = <T extends PlantRow>(rows: readonly T[], divisionId: string): T[] => {
  const org = orgDivisionOf(rows, divisionId);
  return org
    ? rows.filter(row => str(row.ORG_DIVISION_ID) === org)
    : rows.filter(row => str(row.DIVISION_ID) === divisionId);
};

/**
 * `DBUtils.GetDistinctTable(dt, ...keys)` 이식 — 지정 키 조합 기준 최초 1건만 남긴다.
 * 키 목록이 결과 건수를 바꾸므로 AS-IS 호출마다 키를 그대로 옮긴다(조회조건은 3키, 셀콤보는 2키).
 */
const distinctBy = <T>(rows: readonly T[], keyOf: (row: T) => string): T[] => {
  const seen = new Set<string>();
  const out: T[] = [];
  for (const row of rows) {
    const key = keyOf(row);
    if (seen.has(key)) continue;
    seen.add(key);
    out.push(row);
  }
  return out;
};

/**
 * 조회조건 Plant 후보 — AS-IS `RefreshPlantIdByDivision`(cs:350-391).
 *
 * distinct 키가 `CODE`·`NAME`·`DIVISION_ID` **3개**라 `EE_UC` 에서 같은 Plant 가 division 별로
 * 2번 표시된다(실측 4행 = GM00/GM01 × EE_UC/81_UC). AS-IS 실동작이므로 CODE 기준 dedupe 로
 * "정리" 하지 않는다(design 02 §9.3 U-1 — 임의 (b) 적용 금지).
 * 정렬은 SP 가 `SEQ, DIVISION_ID, CODE` 로 이미 해줬으므로 FE 재정렬 금지(§7.3).
 */
export const buildPlantOptions = (
  plantAll: readonly PlantRow[],
  divisionId: string,
  activeSheet: GridSheet
): ComboOption[] => {
  if (!divisionId) return [];
  const scoped = applySeqFilter(filterByDivisionAxis(plantAll, divisionId), divisionId, activeSheet);
  // 조회조건은 `NAME`(= `PLANT_ID + ' ' + PLANT_NAME`)을 표시한다 — 셀 콤보의 `NAME:=CODE`
  //   덮어쓰기 규약을 여기 적용하면 코드만 보인다(design 02 §2.4-3).
  return distinctBy(
    scoped,
    row => `${str(row.CODE)}|${str(row.NAME)}|${str(row.DIVISION_ID)}`
  ).map(row => ({ value: str(row.CODE), label: str(row.NAME) || str(row.CODE) }));
};

/**
 * 선택된 Plant CODE 집합 — `ALL` 이면 현재 후보 전체를 펼친다.
 * AS-IS `CString.GetCheckedListValue`(CString.cs:526-547)가 `"ALL"` 만 전개하고 그 외는 입력을
 * 그대로 반환한다. 콤보 후처리 경로(cs:396·437)는 이 전개값을 `PLANT_ID IN (...)` 에 쓴다.
 */
export const resolvePlantCodes = (
  selected: readonly string[],
  plantOptions: readonly ComboOption[]
): string[] => {
  if (!isAllSelected(selected)) return [...new Set(selected)];
  // `EE_UC` 의 중복 표시(U-1) 때문에 후보에 같은 CODE 가 2번 있다 — 전개 시에는 중복을 제거한다
  //   (`GM00,GM00` 을 SP `IN` 목록에 싣지 않기 위함. 표시 축은 건드리지 않는다).
  return [...new Set(plantOptions.map(option => option.value).filter(Boolean))];
};

/**
 * **조회 payload** 용 Plant/Line CODE 집합 — `ALL` 이면 **빈 배열**이다(= SP 필터 끄기).
 *
 * {@link resolvePlantCodes} 와 용도가 정반대라 함수를 따로 둔다(iter-3 감사 G3-2):
 *   · AS-IS `FindData_Main` cs:1159-1160 —
 *     `clbPlant.ControlValues.Equals("ALL") ? string.Empty : GetCheckedListValue(...)` →
 *     **ALL 이면 명시적으로 `string.Empty`** 다. Line 도 동문(cs:1160).
 *   · `GetCheckedListValue` 의 "후보 전 CODE 전개" 는 **콤보 후처리 경로**(cs:396·437)에만 쓰인다.
 *
 * 전개값을 payload 에 실으면 GET SP 의
 * `AND (P_PLANT_ID IS NULL OR A.PLANT_ID IN (... STRING_SPLIT(P_PLANT_ID,',')))`(8 GET SP 동형)이
 * **현재 콤보 후보로 행 집합을 제한**해 버린다 — 후보에서 빠진 plant(예 division `82` × Daily Capa
 * 의 OSP `SEQ=2`)의 데이터 행까지 사라진다. AS-IS 는 후보에서만 빼고 데이터는 보여준다.
 * Oracle 은 `'' = NULL` 이라 빈 문자열이 곧 무필터다.
 */
export const resolveFilterCodes = (selected: readonly string[]): string[] =>
  isAllSelected(selected) ? [] : [...new Set(selected)];

/**
 * 조회조건 Line 후보 — AS-IS `RefreshLine`(cs:434-471).
 * `DIVISION_ID`(또는 EE_UC 면 `ORG_DIVISION_ID`) **AND** `PLANT_ID IN (선택 Plant)`.
 * 주의: Plant 후보가 0건이면 AS-IS 는 `PLANT_ID IN ('')` 가 되어 Line 도 0건이다(cs:440).
 */
export const buildLineOptions = (
  lineAll: readonly LineRow[],
  divisionId: string,
  plantCodes: readonly string[]
): ComboOption[] => {
  if (!divisionId) return [];
  const allowed = new Set(plantCodes.length > 0 ? plantCodes : ['']);
  return filterByDivisionAxis(lineAll, divisionId)
    .filter(row => allowed.has(str(row.PLANT_ID)))
    .map(row => ({ value: str(row.CODE), label: str(row.NAME) || str(row.CODE) }));
};

/**
 * `PLANT_ID` 셀 콤보 후보 — AS-IS `RefreshPlantIdByCombo`(cs:393-432).
 *
 * 조회조건 Plant 후보와 **다르다**: ① `CODE IN (조회조건 선택 Plant)` 2차 제한이 추가되고
 * ② distinct 키가 `CODE`·`NAME` 2개이며 ③ `NAME:=CODE` 로 덮어써 **코드만** 표시한다(R-19).
 * 누락하면 셀 콤보 후보가 AS-IS 보다 넓어진다.
 */
export const buildPlantCellCandidates = (
  plantAll: readonly PlantRow[],
  divisionId: string,
  selectedPlantCodes: readonly string[],
  activeSheet: GridSheet
): string[] => {
  if (!divisionId) return [];
  const allowed = new Set(selectedPlantCodes.length > 0 ? selectedPlantCodes : ['']);
  const scoped = applySeqFilter(
    filterByDivisionAxis(plantAll, divisionId).filter(row => allowed.has(str(row.CODE))),
    divisionId,
    activeSheet
  );
  return distinctBy(scoped, row => `${str(row.CODE)}|${str(row.NAME)}`)
    .map(row => str(row.CODE))
    .filter(Boolean);
};

/**
 * `LINE_ID` 셀 콤보 후보 — AS-IS `RefreshLineByCombo(행 PLANT_ID)`(cs:473-505).
 * 조회조건 Plant 선택이 아니라 **그 행의 `PLANT_ID`** 로 좁힌다(R-20).
 */
export const buildLineCellCandidates = (
  lineAll: readonly LineRow[],
  divisionId: string,
  rowPlantId: string
): string[] => {
  if (!divisionId) return [];
  return filterByDivisionAxis(lineAll, divisionId)
    .filter(row => str(row.PLANT_ID) === rowPlantId)
    .map(row => str(row.CODE))
    .filter(Boolean);
};

/**
 * `OPERATION_ID` 셀 콤보 후보 — AS-IS `RefreshOperationByDivision`(cs:507-543).
 * `EE_UC` ORG 축 전환이 **없다**(Plant/Line 과 다른 점) — division 완전일치 + 82×시트 SEQ 제한만.
 */
export const buildOperationCellCandidates = (
  operationAll: readonly OperationRow[],
  divisionId: string,
  activeSheet: GridSheet
): string[] => {
  if (!divisionId) return [];
  const scoped = applySeqFilter(
    operationAll.filter(row => str(row.DIVISION_ID) === divisionId),
    divisionId,
    activeSheet
  );
  return scoped.map(row => str(row.CODE)).filter(Boolean);
};

/**
 * `LINE_TYPE` 셀 콤보 후보 — AS-IS `RefreshLineTypeByCombo(행 OPERATION_ID)`(cs:546-550).
 * 실측 3행: `E2000`→`-` / `A5000`→`Anode`,`Cathode` / 그 외 → **0건이 정답**이다.
 * 주입 자체가 `EE_UC` 한정이라는 가드는 호출부(`beginningEdit`)가 건다(R-07).
 */
export const buildLineTypeCellCandidates = (
  lineTypeAll: readonly LineTypeRow[],
  rowOperationId: string
): string[] =>
  lineTypeAll
    .filter(row => str(row.OPERATION_ID) === rowOperationId)
    .map(row => str(row.CODE))
    .filter(Boolean);

/**
 * `LINE_ID` → `LINE_NAME` 파생(R-08, cs:3569-3573 / 붙여넣기 cs:3650-3655).
 * 원천은 **필터 전 전체 마스터**(`dtLineAll`)다 — AS-IS 가 `dtLineAll.Select("CODE=…")` 를 쓴다.
 * 못 찾으면 AS-IS 는 예외가 나지만(`[0]` 접근) TO-BE 는 값을 바꾸지 않는다(파괴적 동작 금지).
 */
export const deriveLineName = (
  lineAll: readonly LineRow[],
  lineId: string
): string | undefined => {
  if (!lineId) return undefined;
  const found = lineAll.find(row => str(row.CODE) === lineId);
  return found ? str(found.LINE_NAME) : undefined;
};

/**
 * `LINE_ID` → `OPERATION_ID` 파생(R-09) — AS-IS `GetOperationByLine`(cs:3594-3616) 2단 조회.
 *
 * ① 조회조건 Plant 후보(`dtPlantId`)에서 `DIVISION_ID` + `CODE=plantId` 확인
 * ② 조회조건 Line 후보(`dtLine`)에서 `DIVISION_ID` + `PLANT_ID` + `CODE=lineId` 의 `OPERATION_ID`
 * **못 찾으면 빈 문자열이 정답**이다 — 기본값 임의 주입 금지.
 */
export const deriveOperationByLine = (
  plantCandidates: readonly PlantRow[],
  lineCandidates: readonly LineRow[],
  rowDivisionId: string,
  rowPlantId: string,
  lineId: string
): string => {
  const plant = plantCandidates.find(
    row => str(row.DIVISION_ID) === rowDivisionId && str(row.CODE) === rowPlantId
  );
  if (!plant) return '';
  const line = lineCandidates.find(
    row =>
      str(row.DIVISION_ID) === rowDivisionId &&
      str(row.PLANT_ID) === str(plant.CODE) &&
      str(row.CODE) === lineId
  );
  return line ? str(line.OPERATION_ID) : '';
};

/**
 * `PLANT_ID` 변경 시 `LINE_ID` 유지/클리어 판정(R-10, cs:3546-3567).
 *
 * 후보 재산출은 `DIVISION_ID = 조회조건 division AND PLANT_ID = 행의 새 Plant` 다 —
 * `EE_UC` ORG 축 전환을 **쓰지 않는다**(`RefreshLineByCombo` 와 다른 지점, cs:3553).
 * 새 후보에 현재 `LINE_ID` 가 **포함되면 유지**한다. 무조건 클리어 금지.
 */
export const shouldClearLineOnPlantChange = (
  lineAll: readonly LineRow[],
  divisionId: string,
  nextPlantId: string,
  currentLineId: string
): boolean => {
  if (!currentLineId) return false;
  return !lineAll.some(
    row =>
      str(row.DIVISION_ID) === divisionId &&
      str(row.PLANT_ID) === nextPlantId &&
      str(row.CODE) === currentLineId
  );
};

/** `COLUMN.PLANT_ID` 를 값으로 쓰는 헬퍼 — 호출부가 컬럼명 리터럴을 반복하지 않게 한다. */
export const rowPlantIdOf = (row: Record<string, unknown> | undefined): string =>
  str(row?.[COLUMN.PLANT_ID]);
