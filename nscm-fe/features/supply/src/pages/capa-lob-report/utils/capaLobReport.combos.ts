import {
  ALL_SENTINEL,
  DIVISION_EXCLUDE_ATTRIBUTE3,
  DIVISION_TYPE,
  DUMMY_CODE_PREFIX,
  ELTR_DEFAULT_OPERATION_ID,
  EMPTY_CODE,
  FORMATION_OPERATION_ID,
  PLAN_TYPE,
  PROGRESS_STATUS,
  type DivisionType,
} from '../capa-lob-report.constants';
import type { ComboOption, ComboRow } from '../capa-lob-report.types';

/**
 * SCP0108 조회조건 콤보의 **클라 후처리 단일 출처** (design 02 §2.5 / §2.9 / §3.3 — 38 연산).
 *
 * 배경(convert-core §2.6): `SCM_ADM_CMBO_SQL_M` 은 AS-IS 서버 SP 만 옮긴 것이라, AS-IS 가 C# 에서
 * SP 호출 **뒤에** 건 후처리(`DBUtils.Filter`/`GetDistinctTable`/`DeleteEmptyName`/`GetSortedCode`/
 * `ScpCapaBL.GetFilterXxx`)는 이관본에 없다. 재현하지 않으면 콤보가 AS-IS 보다 넓거나 좁게 떠서
 * 조회 범위가 조용히 달라진다.
 *
 * 자매 SCP0105 와 다른 4가지(02 §0 — 복사 금지):
 *  - 마스터가 1개다(`CapaLineMaster_SCP_ALL` 고정). `CapaLineMasterEE` 를 호출하지 않는다.
 *  - shop group 을 마스터 단계에서 선필터하지 않고 **매 슬라이스마다** 건다.
 *  - Status 3번째 필터가 `curr ∈ {0,1,2}` 전부 `CODE = curr` -> **목록이 항상 1건**.
 *  - Formation(`AFFFF`) 제외는 **ELTR 축에서만**(SCP0105 전역 제외와 정반대).
 */

export const toStr = (value: unknown): string =>
  typeof value === 'string' ? value : typeof value === 'number' ? String(value) : '';

/** 선택값이 "전체"(무선택 포함) 인가 — `ALL` sentinel 과 빈 문자열 둘 다. */
export const isAllSelected = (value: string): boolean => value === '' || value === ALL_SENTINEL;

/**
 * 다중선택 -> SP 파라미터. AS-IS `CString.GetCheckedListValueNone(dt, "ALL")` 가 `""` 를 돌려주고
 * SP 가 빈값을 무필터로 처리한다(02 §1.1 "무선택=ALL->''" / §3.4).
 * 주의: 자매 SCP0105 는 후보 전체 CODE 를 전개해 보내지만 **SCP0108 은 빈 문자열**이다 — 전개하면
 * 4000byte 초과 위험(마스터 1,900+행)이 생기고 AS-IS 와도 다르다.
 */
export const toFilterValue = (selected: string): string =>
  isAllSelected(selected) ? '' : selected;

/** 콤마 결합 선택값을 집합으로. 전체 선택이면 null(= 좁히지 않음). */
const selectedSet = (value: string | undefined): Set<string> | null => {
  if (value === undefined || isAllSelected(value)) return null;
  const codes = value
    .split(',')
    .map(code => code.trim())
    .filter(Boolean);
  return codes.length > 0 ? new Set(codes) : null;
};

// ============================================================================
// Division — ATTRIBUTE3 = 'EE'(전극 사업부) 제외 (02 §2.1)
// ============================================================================
//   공유 SQL_ID(`Division_SCP`) 의 WHERE 를 고치지 않는다 — 소비자 10곳 실측(hook #117 §3).
//   표시값은 `NAME`(= '{DIVISION_ID} {DIVISION_NAME}') 이다.
export const buildDivisionOptions = (rows: readonly ComboRow[] | undefined): ComboOption[] =>
  (rows ?? [])
    .filter(row => toStr(row.ATTRIBUTE3) !== DIVISION_EXCLUDE_ATTRIBUTE3)
    .map(row => ({ label: toStr(row.NAME) || toStr(row.CODE), value: toStr(row.CODE) }));

// ============================================================================
// Version 계열 — `CapaVersion_SCP_ALL` 결과셋 1건에서 4파생 (02 §2.2)
// ============================================================================
//   서버 정렬(`VER_ID DESC, VER_SEQ DESC`)을 그대로 쓴다. FE 재정렬 금지 — 기본선택이 "최신" 이어야 한다.

/**
 * Plan Month(`cboVersion`) — 선택 Division 의 `VER_ID` distinct.
 * AS-IS 는 `GetAndFilterString(["DIVISION_ID"],[div])` **+ `" AND PROG_STAT <> '-'"`** 를 건다
 * (cs:989~1000) — Pre 뿐인 버전은 Plan Month 목록에서 빠진다.
 */
export const buildVersionOptions = (
  rows: readonly ComboRow[] | undefined,
  divisionId: string
): ComboOption[] => {
  const seen = new Set<string>();
  const options: ComboOption[] = [];
  for (const row of rows ?? []) {
    if (divisionId && toStr(row.DIVISION_ID) !== divisionId) continue;
    if (toStr(row.PROG_STAT) === PROGRESS_STATUS.PRE) continue;
    const code = toStr(row.CODE);
    if (!code || seen.has(code)) continue;
    seen.add(code);
    options.push({ label: toStr(row.NAME) || code, value: code });
  }
  return options;
};

/**
 * Version(`cboVersionSeq`) — Division + Plan Month 로 좁히고 **값/표시 둘 다 `VER_SEQ`** 다
 * (cs:1002~1011, CODE/NAME 규약 예외). distinct 가 아니라 `DBUtils.Filter` 라 중복 행이 나올 수
 * 있어 여기서 코드 기준 dedupe 한다(공용 CustomDropdown 도 표시 직전에 같은 일을 한다).
 */
export const buildVersionSeqOptions = (
  rows: readonly ComboRow[] | undefined,
  divisionId: string,
  verId: string
): ComboOption[] => {
  const seen = new Set<string>();
  const options: ComboOption[] = [];
  for (const row of rows ?? []) {
    if (divisionId && toStr(row.DIVISION_ID) !== divisionId) continue;
    if (verId && toStr(row.CODE) !== verId) continue;
    const seq = toStr(row.VER_SEQ);
    if (!seq || seen.has(seq)) continue;
    seen.add(seq);
    options.push({ label: seq, value: seq });
  }
  return options;
};

/** Division + Plan Month + Version 으로 확정되는 버전 1행. */
const findVersionRow = (
  rows: readonly ComboRow[] | undefined,
  divisionId: string,
  verId: string,
  verSeq: string
): ComboRow | undefined =>
  (rows ?? []).find(
    row =>
      (!divisionId || toStr(row.DIVISION_ID) === divisionId) &&
      (!verId || toStr(row.CODE) === verId) &&
      (!verSeq || toStr(row.VER_SEQ) === verSeq)
  );

/** Plan Type(`txtPlanType`) — 읽기전용 파생 표시. 매칭 없으면 `RP`(AS-IS ScpCapaBL:656). */
export const derivePlanType = (
  rows: readonly ComboRow[] | undefined,
  divisionId: string,
  verId: string,
  verSeq: string
): string =>
  toStr(findVersionRow(rows, divisionId, verId, verSeq)?.BIZ_PLAN_USE_YN) === 'Y'
    ? PLAN_TYPE.BIZ
    : PLAN_TYPE.ROLLING;

/**
 * `_currVersionProgressStatus` — 그 버전의 **현재 진행상태**(`PROG_STAT`).
 * Status 콤보 후보를 좁히는 기준이자 Search 차단 게이트(01 L-22)의 판정값이다.
 * 버전 행을 못 찾으면 **`'0'`(Current)** 이다 — AS-IS `GetCurrVersionProgessStatus`(cs:136~156)가
 * `res = "0"` 으로 시작해 예외/0행이면 그 초기값을 그대로 돌려준다.
 */
export const deriveCurrProgressStatus = (
  rows: readonly ComboRow[] | undefined,
  divisionId: string,
  verId: string,
  verSeq: string
): string =>
  toStr(findVersionRow(rows, divisionId, verId, verSeq)?.PROG_STAT) || PROGRESS_STATUS.CURRENT;

// ============================================================================
// Status — 3중 필터 (02 §2.3) -> 결과는 **항상 1건**
// ============================================================================
//   1) 항상        : `CODE <= curr`
//   2) curr != '-' : `CODE <> '-'`            (Pre 제외)
//   3) curr ∈ {0,1,2} : `CODE = curr`         (⚠ SCP0106 은 {1,2} — 복사 금지, 02 §0 #3)
//   ASCII 순서가 '-' < '0' < '1' < '2' 라 문자열 비교가 곧 진행 순서다. 숫자 캐스팅 금지.
const CODE_EQ_CURR_STATUSES: readonly string[] = [
  PROGRESS_STATUS.CURRENT,
  PROGRESS_STATUS.FIRST_CUTOFF,
  PROGRESS_STATUS.SECOND_CUTOFF,
];

export const buildProgressStatusOptions = (
  rows: readonly ComboRow[] | undefined,
  currProgressStatus: string
): ComboOption[] =>
  (rows ?? [])
    .filter(row => {
      const code = toStr(row.CODE);
      if (!code) return false;
      if (code > currProgressStatus) return false;
      if (currProgressStatus !== PROGRESS_STATUS.PRE && code === PROGRESS_STATUS.PRE) return false;
      if (CODE_EQ_CURR_STATUSES.includes(currProgressStatus) && code !== currProgressStatus) {
        return false;
      }
      return true;
    })
    .map(row => ({ label: toStr(row.NAME) || toStr(row.CODE), value: toStr(row.CODE) }));

// ============================================================================
// Bottleneck — `YesOrNo` CMBO 에 'ALL' 행이 없어 FE 가 선두에 붙인다 (02 §2.6)
// ============================================================================
export const buildBottleneckOptions = (
  rows: readonly ComboRow[] | undefined,
  allLabel: string
): ComboOption[] => [
  { label: allLabel, value: ALL_SENTINEL },
  ...(rows ?? []).map(row => ({
    label: toStr(row.NAME) || toStr(row.CODE),
    value: toStr(row.CODE),
  })),
];

// ============================================================================
// 더미 후치 — `GetSortedCode`(BL:81~136) 4곳 (02 §2.9 #25/27/29/31)
// ============================================================================
/**
 * `DMY_` 로 시작하는 항목을 목록 맨 뒤로 보낸다. 그 앞 구간은 **CODE ASC** 다.
 * 빠뜨리면 Site/Plant/Building/Line 목록에 더미 라인이 알파벳 순서대로 섞여 나온다(02 §2.9 주의).
 */
export const sortDummyLast = (options: ComboOption[]): ComboOption[] => {
  const byCode = [...options].sort((a, b) => a.value.localeCompare(b.value));
  const normal = byCode.filter(option => !option.value.startsWith(DUMMY_CODE_PREFIX));
  const dummy = byCode.filter(option => option.value.startsWith(DUMMY_CODE_PREFIX));
  return [...normal, ...dummy];
};

// ============================================================================
// 마스터 슬라이스 — Site / Plant / Building / Line / Operation / Line Type (02 §2.5 / §3.3)
// ============================================================================

export interface MasterSliceInput {
  rows: readonly ComboRow[] | undefined;
  divisionId: string;
  shopGroupId: string;
  /** 축을 걸지 않을 때는 `undefined` 를 넘긴다(AS-IS 필터식에 그 축이 없다는 뜻). */
  siteId?: string;
  plantId?: string;
  factoryId?: string;
  lineId?: string;
  operationId?: string;
}

/**
 * `DeleteEmptyName(isCodeIsName=false)` 재현.
 * NAME 이 `"CODE NAME"` 형태이면 CODE 접두를 떼고, 남는 명칭이 공백이면 그 행을 버린다.
 * 주의: 3번째 인자가 `true` 인 곳은 Line Type 뿐이며(cs:960) 본문이 이 스냅샷에 없다(02 §9 확인필요-4)
 * — 인자 차이가 존재한다는 사실만 확정됐다. `true` 축은 "NAME 자체가 공백일 때만 제외" 로 구현하고
 * 그 판단을 04 리포트 확인필요로 남긴다(임의 단정 금지).
 */
const hasDisplayName = (code: string, name: string): boolean => {
  const trimmed = name.trim();
  if (!trimmed) return false;
  const stripped = trimmed.startsWith(code) ? trimmed.slice(code.length).trim() : trimmed;
  return stripped.length > 0;
};

/**
 * `excludeDashCode` — AS-IS 는 `CODE <> '-'` 를 **Site/Plant/Building/Line 4축에만** 건다
 * (`GetFilterSite` BL:154 · `GetFilterPlant` BL:202 · `GetFilterFactory` BL:251 · `GetFilterLine` BL:300).
 * `GetFilterOperation`(BL:327~)·`GetFilterElectrodeType`(BL:370~)에는 **없다**(02 §3.3).
 * 이 구분을 놓치고 전 축에 걸면 Line Type 후보가 0건이 되고 조회가 통째로 비어 버린다.
 */
const sliceDistinct = (
  rows: readonly ComboRow[],
  codeKey: string,
  nameKey: string,
  codeIsName: boolean,
  excludeDashCode = true
): ComboOption[] => {
  const seen = new Set<string>();
  const options: ComboOption[] = [];
  for (const row of rows) {
    const code = toStr(row[codeKey]);
    if (!code || seen.has(code)) continue;
    if (excludeDashCode && code === EMPTY_CODE) continue;
    const name = toStr(row[nameKey]) || code;
    if (codeIsName ? !name.trim() : !hasDisplayName(code, name)) continue;
    seen.add(code);
    options.push({ label: name, value: code });
  }
  return options;
};

/**
 * 상위 축 조건을 AND 로 건 마스터 부분집합.
 * `divisionId` 가 비면 **필터를 통째로 걸지 않는다** — AS-IS 6개 `GetFilterXxx` 전부
 * `if (string.IsNullOrEmpty(division)) return "";` 이라 전건이 나온다(02 §3.3 공통 가드 / §4.4).
 * 빈 목록으로 만들면 AS-IS 위반이다.
 */
const narrowMaster = ({
  rows,
  divisionId,
  shopGroupId,
  siteId,
  plantId,
  factoryId,
  lineId,
  operationId,
}: MasterSliceInput): ComboRow[] => {
  if (!divisionId) return [...(rows ?? [])];

  const sites = selectedSet(siteId);
  const plants = selectedSet(plantId);
  const factories = selectedSet(factoryId);
  const lines = selectedSet(lineId);
  const operations = selectedSet(operationId);

  return (rows ?? []).filter(row => {
    if (toStr(row.DIVISION_ID) !== divisionId) return false;
    if (shopGroupId && toStr(row.SHOP_GROUP_ID) !== shopGroupId) return false;
    if (sites && !sites.has(toStr(row.SITE_ID))) return false;
    if (plants && !plants.has(toStr(row.PLANT_ID))) return false;
    if (factories && !factories.has(toStr(row.FACTORY_ID))) return false;
    if (lines && !lines.has(toStr(row.LINE_ID))) return false;
    if (operations && !operations.has(toStr(row.OPERATION_ID))) return false;
    return true;
  });
};

/**
 * Site — `GetFilterSite(_division)`(BL:144~166)는 `DIVISION_ID IN(..) AND CODE <> '-'` 뿐이고
 * **shop group 축이 없다**(SCP0105 와 다르다 — 그쪽은 마스터가 이미 shop group 으로 좁혀져 있다).
 * 그래서 SCP0108 에서는 **DivisionType 을 바꿔도 Site 목록이 변하지 않는다**(02 §3.3 특이사항).
 */
export const buildSiteOptions = (input: MasterSliceInput): ComboOption[] =>
  sortDummyLast(
    sliceDistinct(
      narrowMaster({ ...input, shopGroupId: '' }),
      'SITE_ID',
      'SITE_NAME',
      false
    )
  );

/** Plant — `DIVISION_ID + SITE_ID + SHOP_GROUP_ID` + `CODE <> '-'` (BL:192~239). */
export const buildPlantOptions = (input: MasterSliceInput): ComboOption[] =>
  sortDummyLast(sliceDistinct(narrowMaster(input), 'PLANT_ID', 'PLANT_NAME', false));

/**
 * Building(=Factory) — `DIVISION_ID + SHOP_GROUP_ID + PLANT_ID` + `CODE <> '-'` (BL:241~288).
 * ⚠ **SITE 축이 빠져 있다**(Plant 를 거친 전제). 호출부가 `siteId` 를 넘기지 않는다.
 */
export const buildBuildingOptions = (input: MasterSliceInput): ComboOption[] =>
  sortDummyLast(sliceDistinct(narrowMaster(input), 'FACTORY_ID', 'FACTORY_NAME', false));

/** Line — `DIVISION_ID + SHOP_GROUP_ID + PLANT_ID + FACTORY_ID` + `CODE <> '-'` (BL:290~325). */
export const buildLineOptions = (input: MasterSliceInput): ComboOption[] =>
  sortDummyLast(sliceDistinct(narrowMaster(input), 'LINE_ID', 'LINE_NAME', false));

/**
 * Operation — `DIVISION_ID + SHOP_GROUP_ID + PLANT_ID + FACTORY_ID + LINE_ID`,
 * **`CODE <> '-'` 없음**, `DISPLAY_SEQ` 오름차순(cs:1100), 그리고
 * **Formation(`AFFFF`) 제외는 `_division_type == ELTR` 일 때만**(BL:355~361 / 02 §0 #4 / V-19).
 * 자매 SCP0105 의 전역 제외를 복사하면 Cell/Module·Pack 후보가 AS-IS 보다 좁아진다.
 */
export const buildOperationOptions = (
  input: MasterSliceInput,
  divisionType: DivisionType
): ComboOption[] => {
  const narrowed = narrowMaster(input)
    .filter(
      row =>
        divisionType !== DIVISION_TYPE.ELTR ||
        toStr(row.OPERATION_ID) !== FORMATION_OPERATION_ID
    )
    .slice()
    .sort((a, b) => Number(a.DISPLAY_SEQ ?? 0) - Number(b.DISPLAY_SEQ ?? 0));
  return sliceDistinct(narrowed, 'OPERATION_ID', 'OPERATION_NAME', false, false);
};

/**
 * `GetElectrodeOperationFilter`(BL:634~652) — Operation 무선택일 때 Line Type 후보를 좁히는 대체 필터.
 * MODULE_PACK -> `SUBSTRING(OPERATION_ID,1,1)='P'` / CELL -> `='A'` / ELTR -> `OPERATION_ID='E2000'`.
 * DataTable 식 `SUBSTRING(col,1,1)` 은 1-base 라 TS 로는 `slice(0,1)`.
 */
export const matchesElectrodeOperationPrefix = (
  operationId: string,
  divisionType: DivisionType
): boolean => {
  if (divisionType === DIVISION_TYPE.MODULE_PACK) return operationId.slice(0, 1) === 'P';
  if (divisionType === DIVISION_TYPE.CELL) return operationId.slice(0, 1) === 'A';
  return operationId === ELTR_DEFAULT_OPERATION_ID;
};

/**
 * Line Type(=ElectrodeType) — SCP0108 은 **전 축 마스터 슬라이스 1개**다(02 §0 #6 — 별도 콤보 0건).
 * `GetFilterElectrodeType(_division_type, _division, _operation)`(BL:370~403):
 *   `DIVISION_ID IN(..) AND OPERATION_ID IN(..)`, Operation 무선택이면 위 대체 필터.
 * shop group 축이 없고 `CODE <> '-'` 도 없다. 표시값은 `ELTR_LN_TP_NM`(= 코드와 동일 값, 02 §2.5).
 */
export const buildLineTypeOptions = (
  input: MasterSliceInput,
  divisionType: DivisionType
): ComboOption[] => {
  const hasOperation = !isAllSelected(input.operationId ?? '');
  const narrowed = narrowMaster({ ...input, shopGroupId: '' })
    .filter(
      row =>
        hasOperation ||
        matchesElectrodeOperationPrefix(toStr(row.OPERATION_ID), divisionType)
    )
    .slice()
    .sort((a, b) => Number(a.DISPLAY_SEQ ?? 0) - Number(b.DISPLAY_SEQ ?? 0));
  // `DeleteEmptyName(..., true)` 축 — CODE 접두 제거 없이 NAME 공백만 거른다(cs:960, 확인필요-4).
  return sliceDistinct(narrowed, 'ELTR_LN_TP_CD', 'ELTR_LN_TP_NM', true, false);
};
