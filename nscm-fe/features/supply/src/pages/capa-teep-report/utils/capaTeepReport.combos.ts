import {
  ALL_SENTINEL,
  DIVISION_EXCLUDE_ATTRIBUTE3,
  DIVISION_TYPE,
  DUMMY_CODE_PREFIX,
  ELTR_DEFAULT_OPERATION_ID,
  EMPTY_CODE,
  FORMATION_OPERATION_ID,
  NONE_SENTINEL,
  PLAN_TYPE,
  REQUIRED_PROG_STAT,
  SHOP_GROUP_ID,
  type DivisionType,
} from '../capa-teep-report.constants';
import type { ComboOption, ComboRow } from '../capa-teep-report.types';

/**
 * SCP0107 조회조건 콤보의 **클라 후처리 단일 출처** (design 02 §2 / §2.6 / §2.7).
 *
 * 배경(convert-core §2.6 핵심 원칙): `SCM_ADM_CMBO_SQL_M` 은 AS-IS 서버 SP 를 그대로 옮긴 것이라,
 * AS-IS 가 C# 에서 SP 호출 **뒤에** 건 후처리(`DBUtils.Filter`/`GetDistinctTable`/`DeleteEmptyName`/
 * `GetSortedCode`/`ScpCapaBL.GetFilterXxx`)는 이관본에 없다. 재현하지 않으면 콤보가 AS-IS 보다 넓게
 * 떠서 조회 범위가 조용히 달라진다(silent drift).
 *
 * 이관 안 된 화면 전용 필터 4종(02 §2.7 "화면 전용 클라 필터" 열 = goal S-7):
 *  (1) Division  `ATTRIBUTE3 <> 'EE'`                                   (blu:107~116)
 *  (2) 마스터    `SHOP_GROUP_ID = 'A'|'P'` — **ASSEMBLY 경로 전량 선필터** (BL:35~42)
 *  (3) Operation `CODE <> 'AFFFF'` — **ELTR + CELL 두 경로**              (BL:327~368 · cs:1083~1093)
 *  (4) Line Type `OPERATION_ID = 'E2000'` — ELTR 경로의 lookup 콤보        (BL:634~652)
 *
 * 자매 화면과 다른 4가지(복사 금지 — 02 §0 / goal ④-2):
 *  - Division 이 **다중선택**이고 ALL 이면 `''`(빈 문자열)로 나간다. Site 이하는 후보 전건 CSV 다.
 *  - Operation 의 Formation 제외가 **ELTR + CELL** 이다(SCP0106/0108 은 ELTR 만).
 *  - Line Type 원천이 **2개**다(ASSEMBLY = 마스터 distinct / ELTR = `OperationElectrodeType_SCP_ALL`).
 *  - `CapaProgressStatus_SCP_ALL` 을 호출하지 않는다 — 이 화면에 Status 콤보가 없다(02 §2.5 D3).
 */

export const toStr = (value: unknown): string =>
  typeof value === 'string' ? value : typeof value === 'number' ? String(value) : '';

/** 선택값이 "전체"(무선택 포함) 인가 — `ALL` sentinel 과 빈 문자열 둘 다. */
export const isAllSelected = (value: string): boolean => value === '' || value === ALL_SENTINEL;

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
// (1) Division — ATTRIBUTE3 = 'EE'(전극 사업부) 제외 (02 §2.1)
// ============================================================================
//   공유 SQL_ID(`Division_SCP`)의 WHERE 를 고치지 않는다 — 타 화면 회귀(Hard Boundary §2.2 / hook #117 §3).
//   표시값은 `NAME`(= '{DIVISION_ID} {DIVISION_NAME}') 이다. 코드만 뜨면 공통 QA "CODE 아닌 NAME 표시" 실패.
//   정렬은 CMBO SQL 의 `ORDER BY ATTRIBUTE1` 을 그대로 신뢰한다(FE 재정렬 금지 — AS-IS 도 동일).
export const buildDivisionOptions = (rows: readonly ComboRow[] | undefined): ComboOption[] =>
  (rows ?? [])
    .filter(row => toStr(row.ATTRIBUTE3) !== DIVISION_EXCLUDE_ATTRIBUTE3)
    .map(row => ({ label: toStr(row.NAME) || toStr(row.CODE), value: toStr(row.CODE) }));

// ============================================================================
// Version 계열 — `CapaVersion_SCP_ALL` 결과셋 1건에서 4파생 (02 §2.2)
// ============================================================================
//   서버 정렬(`VER_ID DESC, VER_SEQ DESC`)을 그대로 쓴다. FE 재정렬 금지 — 기본선택이 "최신 / 최대 Seq"
//   여야 한다(02 §4.2). 필터는 `CODE`(=VER_ID) 기준이다(`VER_ID` 컬럼이 아니다 — cs:945 주석).

/**
 * Plan Month(`cboVersion`) — 선택 Division 들의 `VER_ID` distinct.
 * **`PROG_STAT = '2'`(2차 컷오프) 한정이 이 화면의 조회 전제**다(cs:941 주석 "2nd Cutoff 인 버전목록만
 * 조회"). 이 필터를 빼면 1차 컷오프/CURRENT 버전이 섞여 조회 게이트에서 전건 차단된다.
 * Division 이 ALL 이면 `GetAndFilterString` 이 그 절을 만들지 않아 **전 사업부 버전**이 후보다(02 §3.4-1).
 */
export const buildVersionOptions = (
  rows: readonly ComboRow[] | undefined,
  divisionId: string
): ComboOption[] => {
  const divisions = selectedSet(divisionId);
  const seen = new Set<string>();
  const options: ComboOption[] = [];
  for (const row of rows ?? []) {
    if (toStr(row.PROG_STAT) !== REQUIRED_PROG_STAT) continue;
    if (divisions && !divisions.has(toStr(row.DIVISION_ID))) continue;
    const code = toStr(row.CODE);
    if (!code || seen.has(code)) continue;
    seen.add(code);
    options.push({ label: toStr(row.NAME) || code, value: code });
  }
  return options;
};

/**
 * Version(`cboVersionSeq`) — Division + Plan Month 로 좁히고 **값/표시 둘 다 `VER_SEQ`** 다
 * (02 §2.2 — CODE/NAME 규약 예외). 주석 "Division 멀티 선택으로 변경되어 중복 제거 필요"(cs:952)대로
 * 중복을 제거한다. **`PROG_STAT` 필터는 여기 없다**(AS-IS 필터식 그대로).
 */
export const buildVersionSeqOptions = (
  rows: readonly ComboRow[] | undefined,
  divisionId: string,
  verId: string
): ComboOption[] => {
  const divisions = selectedSet(divisionId);
  const seen = new Set<string>();
  const options: ComboOption[] = [];
  for (const row of rows ?? []) {
    if (divisions && !divisions.has(toStr(row.DIVISION_ID))) continue;
    if (verId && toStr(row.CODE) !== verId) continue;
    const seq = toStr(row.VER_SEQ);
    if (!seq || seen.has(seq)) continue;
    seen.add(seq);
    options.push({ label: seq, value: seq });
  }
  return options;
};

/** Division + Plan Month + Version 으로 확정되는 버전 1행(02 §2.2 PlanType/게이트 필터식). */
const findVersionRow = (
  rows: readonly ComboRow[] | undefined,
  divisionId: string,
  verId: string,
  verSeq: string
): ComboRow | undefined => {
  const divisions = selectedSet(divisionId);
  return (rows ?? []).find(
    row =>
      (!divisions || divisions.has(toStr(row.DIVISION_ID))) &&
      (!verId || toStr(row.CODE) === verId) &&
      (!verSeq || toStr(row.VER_SEQ) === verSeq)
  );
};

/** Plan Type(`txtPlanType`) — 읽기전용 파생 표시. 매칭 없으면 `RP`(AS-IS ScpCapaBL:656 기본값). */
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
 * Search 차단 게이트(02 §4.4 / cs:1340~1345)의 판정값이다. 버전 행을 못 찾으면 **`'0'`(CURRENT)** 다
 * (AS-IS `GetCurrVersionProgessStatus` 가 `res="0"` 으로 시작해 0행이면 그 초기값을 돌려준다, cs:967~987).
 */
export const deriveCurrProgressStatus = (
  rows: readonly ComboRow[] | undefined,
  divisionId: string,
  verId: string,
  verSeq: string
): string =>
  toStr(findVersionRow(rows, divisionId, verId, verSeq)?.PROG_STAT) || '0';

// ============================================================================
// (2) 마스터 원천 선필터 — ASSEMBLY 경로만 `SHOP_GROUP_ID = 'A'|'P'` (02 §2.3 BL:35~42)
// ============================================================================
/**
 * `GetCapaLineMasterAll(divisionType)` 의 클라 후처리를 재현한다.
 *   CELL / MODULE_PACK -> `CapaLineMaster_SCP_ALL` + `DBUtils.Filter("SHOP_GROUP_ID='A'|'P'")`
 *   ELTR               -> `CapaLineMasterEE_SCP_ALL` (**후처리 필터 없음**)
 * 이 선필터는 Division 선택과 무관하게 **항상** 걸린다 — 축별 `GetFilterXxx` 의 shop group 절은
 * Division 이 비면 생성되지 않지만(02 §4.3-1) 이 단계는 그 이전이다. 두 단계를 혼동해 여기서 빼면
 * Cell/Module·Pack 에서 전극 라인이 후보에 섞인다.
 */
export const filterMasterByShopGroup = (
  rows: readonly ComboRow[] | undefined,
  divisionType: DivisionType
): ComboRow[] => {
  const source = [...(rows ?? [])];
  if (divisionType === DIVISION_TYPE.ELTR) return source;
  const shopGroupId = SHOP_GROUP_ID[divisionType];
  return source.filter(row => toStr(row.SHOP_GROUP_ID) === shopGroupId);
};

// ============================================================================
// 더미 후치 — `GetSortedCode`(BL:81~136), Site/Plant/Building/Line 4축만 (02 §2.6 유틸 표)
// ============================================================================
/**
 * `CODE ASC` 정렬 후 `DMY_` 로 시작하는 항목을 목록 맨 뒤로 보낸다.
 * 빠뜨리면 Site/Plant/Building/Line 목록에 더미 라인이 알파벳 순서대로 섞여 나온다.
 * Operation·Line Type 에는 적용하지 않는다(그쪽은 `DISPLAY_SEQ` 정렬이다).
 */
export const sortDummyLast = (options: ComboOption[]): ComboOption[] => {
  const byCode = [...options].sort((a, b) => a.value.localeCompare(b.value));
  const normal = byCode.filter(option => !option.value.startsWith(DUMMY_CODE_PREFIX));
  const dummy = byCode.filter(option => option.value.startsWith(DUMMY_CODE_PREFIX));
  return [...normal, ...dummy];
};

/**
 * Line 목록 화면 고유 재정렬 — 단순 코드 정렬이 아니다(AS-IS `RefreshLine` cs:1027~1078).
 * CODE 끝 2글자가 `_C`/`_A` 로 **정확히 2행 쌍**을 이루면 같은 그룹으로 묶고 `_C` 를 앞에 둔다
 * (`SEQ1`=그룹 순서 / `SEQ2`=`_C`:1,`_A`:2). 쌍이 아니면 단독 그룹이다.
 * 미재현 시 Line 목록 순서가 AS-IS 와 달라진다(02 §2.6 "Line 축 화면 고유 재정렬").
 *
 * AS-IS 는 `CopyToDataTable()` 에 0행 방어가 없어 후보 0건이면 `InvalidOperationException` 이 난다
 * (02 §7 A-5 = goal S-17 FAIL). TO-BE 는 **빈 배열을 그대로 돌려** 예외만 제거한다 — 기능 축소가 아니다.
 */
export const reorderLinePairs = (options: ComboOption[]): ComboOption[] => {
  if (options.length === 0) return [];

  const prefixCount = new Map<string, number>();
  for (const option of options) {
    const suffix = option.value.slice(-2);
    if (suffix !== '_C' && suffix !== '_A') continue;
    const prefix = option.value.slice(0, -2);
    prefixCount.set(prefix, (prefixCount.get(prefix) ?? 0) + 1);
  }

  const groups: { key: string; items: ComboOption[] }[] = [];
  const groupIndex = new Map<string, number>();
  for (const option of options) {
    const suffix = option.value.slice(-2);
    const prefix = option.value.slice(0, -2);
    const isPair = (suffix === '_C' || suffix === '_A') && prefixCount.get(prefix) === 2;
    const key = isPair ? prefix : `@${option.value}`;
    const found = groupIndex.get(key);
    if (found === undefined) {
      groupIndex.set(key, groups.length);
      groups.push({ key, items: [option] });
    } else {
      groups[found].items.push(option);
    }
  }

  return groups.flatMap(group =>
    // 쌍 그룹 안에서만 `_C` -> `_A` 순으로 고정한다(SEQ2).
    [...group.items].sort((a, b) => (a.value.endsWith('_C') ? -1 : b.value.endsWith('_C') ? 1 : 0))
  );
};

// ============================================================================
// 마스터 슬라이스 — Site / Plant / Building / Line / Operation / Line Type (02 §2.3 / §2.6)
// ============================================================================
//   AS-IS 는 콤보 6개가 아니라 **마스터 결과셋 1건의 축별 distinct** 다.
//   축마다 걸리는 조건이 다르다 — 통일하면 후보 집합이 달라진다(02 §2.6 표):
//     Site      : DIVISION                      + CODE<>'-'
//     Plant     : DIVISION + SITE + SHOP_GROUP   + CODE<>'-'
//     Building  : DIVISION + SHOP_GROUP + PLANT  + CODE<>'-'   (**SITE 축 없음**)
//     Line      : DIVISION + SHOP_GROUP + PLANT + FACTORY + CODE<>'-'
//     Operation : DIVISION + SHOP_GROUP + PLANT + FACTORY + LINE (**CODE<>'-' 없음**)
//     Line Type : DIVISION + OPERATION                          (**shop group·CODE<>'-' 없음**)

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
 * `DeleteEmptyName(ref tbl, "CODE", "NAME", isCodeIsName)`(dbu:572) 재현.
 * `isCodeIsName=false`: NAME 이 `"CODE NAME"` 형태이면 CODE 접두를 떼고, 남는 명칭이 공백이면 행을 버린다.
 * `isCodeIsName=true`(Line Type 만): 접두 제거 없이 `Trim()` 결과가 공백일 때만 버린다(02 §2.3 주의).
 */
const hasDisplayName = (code: string, name: string): boolean => {
  const trimmed = name.trim();
  if (!trimmed) return false;
  const stripped = trimmed.startsWith(code) ? trimmed.slice(code.length).trim() : trimmed;
  return stripped.length > 0;
};

const sliceDistinct = (
  rows: readonly ComboRow[],
  codeKey: string,
  nameKey: string,
  codeIsName: boolean,
  excludeDashCode: boolean
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
 *
 * `divisionId` 가 ALL/빈 값이면 **필터를 통째로 걸지 않는다** — AS-IS 6개 `GetFilterXxx` 전부
 * `if (string.IsNullOrEmpty(division)) return "";` 이라 무필터(전건)가 되고, 그때는
 * `SHOP_GROUP_ID IN (...)` 절조차 생성되지 않는다(02 §3.4-1 / §4.3-1). 이 가드를 빼면 미선택 상태의
 * 후보가 AS-IS 보다 좁아진다.
 *
 * 상위 축이 ALL 이면 좁히지 않는다 — AS-IS 는 `GetCheckedListValueNone` 이 후보 전건 CSV 로 펼쳐
 * `IN (...)` 에 넣으므로 결과가 등가다(02 §2.6 유틸 표 `GetAndFilterString`).
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
  const divisions = selectedSet(divisionId);
  if (!divisions) return [...(rows ?? [])];

  const sites = selectedSet(siteId);
  const plants = selectedSet(plantId);
  const factories = selectedSet(factoryId);
  const lines = selectedSet(lineId);
  const operations = selectedSet(operationId);

  return (rows ?? []).filter(row => {
    if (!divisions.has(toStr(row.DIVISION_ID))) return false;
    if (shopGroupId && toStr(row.SHOP_GROUP_ID) !== shopGroupId) return false;
    // `selectedSet(undefined)` 가 null 이라 "축을 걸지 않음" 과 "전체 선택" 이 같은 분기로 흡수된다.
    if (sites && !sites.has(toStr(row.SITE_ID))) return false;
    if (plants && !plants.has(toStr(row.PLANT_ID))) return false;
    if (factories && !factories.has(toStr(row.FACTORY_ID))) return false;
    if (lines && !lines.has(toStr(row.LINE_ID))) return false;
    if (operations && !operations.has(toStr(row.OPERATION_ID))) return false;
    return true;
  });
};

/** Site — `GetFilterSite`(BL:144~166) = `DIVISION_ID IN (…) AND CODE <> '-'`. **shop group 축 없음.** */
export const buildSiteOptions = (input: MasterSliceInput): ComboOption[] =>
  sortDummyLast(
    sliceDistinct(narrowMaster({ ...input, shopGroupId: '' }), 'SITE_ID', 'SITE_NAME', false, true)
  );

/** Plant — `GetFilterPlant`(BL:192~239) = `DIVISION + SITE + SHOP_GROUP + CODE<>'-'`. */
export const buildPlantOptions = (input: MasterSliceInput): ComboOption[] =>
  sortDummyLast(sliceDistinct(narrowMaster(input), 'PLANT_ID', 'PLANT_NAME', false, true));

/**
 * Building(=Factory) — `GetFilterFactory`(BL:241~288) = `DIVISION + SHOP_GROUP + PLANT + CODE<>'-'`.
 * **`SITE_ID` 절이 없다**(AS-IS 그대로 — 넣으면 후보가 줄어 불일치, 02 §6.2 체크). 호출부가 `siteId` 를
 * 넘기지 않는 것으로 재현한다.
 */
export const buildBuildingOptions = (input: MasterSliceInput): ComboOption[] =>
  sortDummyLast(sliceDistinct(narrowMaster(input), 'FACTORY_ID', 'FACTORY_NAME', false, true));

/**
 * Line — `GetFilterLine`(BL:290~325) = `DIVISION + SHOP_GROUP + PLANT + FACTORY + CODE<>'-'`
 * + 화면 고유 `_C`/`_A` 쌍 재정렬(`reorderLinePairs`).
 */
export const buildLineOptions = (input: MasterSliceInput): ComboOption[] =>
  reorderLinePairs(
    sortDummyLast(sliceDistinct(narrowMaster(input), 'LINE_ID', 'LINE_NAME', false, true))
  );

/**
 * Operation — `GetFilterOperation`(BL:327~368) = `DIVISION + SHOP_GROUP + PLANT + FACTORY + LINE`,
 * **`CODE <> '-'` 없음**, `DISPLAY_SEQ` 오름차순(cs:874), distinct 조합에 **`SITE_ID` 가 없다**(02 §2.3).
 *
 * Formation(`AFFFF`) 제외는 **ELTR + CELL 두 경로**다 — ELTR 은 `GetFilterOperation` 안에서,
 * CELL 은 화면이 `AND CODE <> 'AFFFF'` 를 덧붙인다(cs:1083~1093). 결과적으로 **Module/Pack 만 포함**이다.
 * 자매 SCP0106/SCP0108(ELTR 만 제외)을 복사하면 Cell 후보가 AS-IS 보다 넓어진다(02 §6.1 체크).
 */
export const buildOperationOptions = (
  input: MasterSliceInput,
  divisionType: DivisionType
): ComboOption[] => {
  const excludeFormation =
    divisionType === DIVISION_TYPE.ELTR || divisionType === DIVISION_TYPE.CELL;
  const narrowed = narrowMaster(input)
    .filter(row => !excludeFormation || toStr(row.OPERATION_ID) !== FORMATION_OPERATION_ID)
    .sort((a, b) => Number(a.DISPLAY_SEQ ?? 0) - Number(b.DISPLAY_SEQ ?? 0));
  return sliceDistinct(narrowed, 'OPERATION_ID', 'OPERATION_NAME', false, false);
};

/**
 * `GetElectrodeOperationFilter`(BL:634~652) — ELTR 경로 lookup 콤보의 후처리 필터.
 * MODULE_PACK -> `SUBSTRING(OPERATION_ID,1,1)='P'` / CELL -> `='A'` / **ELTR -> `OPERATION_ID='E2000'`**.
 * 실행 경로상 이 함수는 ELTR 계열에서만 도달하므로 실효 조건은 `E2000` 이다(02 §2.4, 체크리스트 §4c #1).
 * DataTable 식 `SUBSTRING(col,1,1)` 은 1-base 라 TS 로는 `slice(0,1)` 이다(SQL 로 옮길 때만 `SUBSTR`).
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
 * Line Type(=ElectrodeType) — **원천이 DivisionType 별로 2개**다(02 §2.4 / goal S-8 축별 컬럼명).
 *   ASSEMBLY 경로(CELL·MODULE_PACK): 마스터 distinct `ELTR_LN_TP_CD`/`ELTR_LN_TP_NM`
 *   ELTR 경로:                       `OperationElectrodeType_SCP_ALL` + `OPERATION_ID='E2000'`
 *                                    (반환 컬럼이 이미 `CODE`/`NAME` 이다 — SEGMENT3 alias)
 * 한쪽만 구현하면 한 Operation group 에서 목록이 통째로 빈다(02 §6.1 체크).
 *
 * 축 필터는 `DIVISION_ID IN (…) AND OPERATION_ID IN (…)` 뿐이다 — **shop group 절과 `CODE<>'-'` 가
 * 없다**(02 §2.6). `DeleteEmptyName(isCodeIsName=true)` 라 CODE 접두 제거 없이 NAME 공백만 거른다.
 */
export const buildLineTypeOptions = (
  input: MasterSliceInput,
  divisionType: DivisionType,
  electrodeLookupRows: readonly ComboRow[] | undefined
): ComboOption[] => {
  if (divisionType === DIVISION_TYPE.ELTR) {
    const filtered = (electrodeLookupRows ?? []).filter(row =>
      matchesElectrodeOperationPrefix(toStr(row.OPERATION_ID), divisionType)
    );
    const narrowed = narrowMaster({ ...input, rows: filtered, shopGroupId: '' }).sort(
      (a, b) => Number(a.DISPLAY_SEQ ?? 0) - Number(b.DISPLAY_SEQ ?? 0)
    );
    return sliceDistinct(narrowed, 'CODE', 'NAME', true, false);
  }

  const narrowed = narrowMaster({ ...input, shopGroupId: '' }).sort(
    (a, b) => Number(a.DISPLAY_SEQ ?? 0) - Number(b.DISPLAY_SEQ ?? 0)
  );
  return sliceDistinct(narrowed, 'ELTR_LN_TP_CD', 'ELTR_LN_TP_NM', true, false);
};

// ============================================================================
// 다중선택 직렬화 (02 §3.4 / goal S-6) — **축마다 함수가 다르다**
// ============================================================================
/**
 * Division 축 — `CString.GetCheckedListValue(dtDivision, cv, true)`(cstr:550).
 * ALL/무선택 -> **`''`(빈 문자열)**. SP 가 빈 값을 "전체" 로 해석한다(AS-IS 사양).
 * 주의: Oracle 은 `''` = NULL 이라 TO-BE SP 변환 시 "빈값 = 무조건" 분기를 명시 이식해야 한다
 * (02 §5.5 / §7 A-6 — `convert-sp` 인계). FE 계약은 AS-IS 와 동일하게 빈 문자열이다.
 */
export const toDivisionParam = (selected: string): string =>
  isAllSelected(selected) ? '' : selected;

/**
 * Site~Line Type 축 — `CString.GetCheckedListValueNone(dt, cv)`.
 *   후보 0건        -> **`"NONE"`**(실재하지 않는 코드로 결과셋을 강제로 비운다)
 *   ALL/무선택      -> **후보 전건 CODE 를 `,` join**(빈 값이 아니다)
 *   일부 선택        -> 그 CODE 들 `,` join
 *
 * 주의 1: **`"NONE"` sentinel 을 빼먹으면 그 축이 무필터가 되어 조건 없이 전건을 조회한다**(goal S-6).
 * 주의 2: 숨겨진 축도 값은 나간다 — Electrode 에서 Operation/Line Type 필드는 숨지만 후보 전건이
 *   실린다(01 L-01/L-02 · V-05 · goal D-6 기본안 "값 유지"). 빈값으로 바꾸면 조회 건수가 달라진다.
 * 주의 3: 무선택 전개는 후보 수만큼 길어져 4000byte 초과 위험이 있다(공통 QA 콤보 항목 — 미측정).
 */
export const expandMultiSelect = (
  selected: string,
  candidates: readonly ComboOption[]
): string => {
  if (candidates.length === 0) return NONE_SENTINEL;
  if (isAllSelected(selected)) return candidates.map(option => option.value).join(',');
  return selected;
};
