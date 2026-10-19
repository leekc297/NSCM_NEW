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
  PROGRESS_STATUS,
  type DivisionType,
} from '../capa-speed-plan.constants';
import type { ComboOption, ComboRow } from '../capa-speed-plan.types';

/**
 * SCP0105 조회조건 콤보의 **클라 후처리 필터 단일 출처**.
 *
 * 배경(convert-core §2.6 핵심 원칙): `SCM_ADM_CMBO_SQL_M` 은 AS-IS 서버 SP 를 그대로 옮긴 것이라,
 * AS-IS 가 C# 에서 SP 호출 **뒤에** 건 후처리 필터(`DBUtils.Filter`/`DataView.RowFilter`)는 이관본에
 * 들어 있지 않다. 그 필터를 FE 가 재현하지 않으면 콤보가 AS-IS 보다 넓게 떠서 조회 범위가 조용히
 * 달라진다. design 02 §2·§3.3 이 실측한 7종을 여기 모은다 — 화면 컴포넌트에 흩지 않는다.
 *
 *  ① Division   `ATTRIBUTE3 <> 'EE'`                       (BLUtils.cs:107~116)
 *  ② 마스터     `SHOP_GROUP_ID = 'A'|'P'` (ASSEMBLY 축)     (ScpCapaBL.cs:35~42)
 *  ③ Operation  Formation 더미 `AFFFF` 제외                 (cs:949~962)
 *  ④ Line Type  `OPERATION_ID` 접두 `A`/`P` 또는 `='E2000'` (ScpCapaBL.cs:634~652)
 *  ⑤ Status     3중 필터                                    (cs:1071~1088)
 *  ⑥ 더미 후치  `DMY_` 접두 항목을 목록 맨 뒤로              (ScpCapaBL.cs:81~136)
 *  ⑦ Line 재정렬 `_C`/`_A` 쌍 묶음                          (cs:1147~1198)
 */

export const toStr = (value: unknown): string =>
  typeof value === 'string' ? value : typeof value === 'number' ? String(value) : '';

/** 선택값이 "전체"(무선택 포함) 인가 — 공용 CustomDropdown 의 `ALL` sentinel 과 빈 문자열 둘 다. */
export const isAllSelected = (value: string): boolean => value === '' || value === ALL_SENTINEL;

/** 콤마 결합 선택값을 집합으로. 전체 선택이면 null(= 좁히지 않음). */
const selectedSet = (value: string): Set<string> | null => {
  if (isAllSelected(value)) return null;
  const codes = value
    .split(',')
    .map(code => code.trim())
    .filter(Boolean);
  return codes.length > 0 ? new Set(codes) : null;
};

// ============================================================================
// ① Division — ATTRIBUTE3 = 'EE'(전극 사업부) 제외
// ============================================================================
//   공유 SQL_ID(`Division_SCP`) 의 WHERE 를 고치지 않는다 — 타 화면 회귀(Hard Boundary §2.2).
//   표시값은 `NAME`(= '{DIVISION_ID} {DIVISION_NAME}') 이다. 코드만 뜨면 F-03 실패.
export const buildDivisionOptions = (rows: readonly ComboRow[] | undefined): ComboOption[] =>
  (rows ?? [])
    .filter(row => toStr(row.ATTRIBUTE3) !== DIVISION_EXCLUDE_ATTRIBUTE3)
    .map(row => ({ label: toStr(row.NAME) || toStr(row.CODE), value: toStr(row.CODE) }));

// ============================================================================
// Version 계열 — `CapaVersion_SCP_ALL` 결과셋 1건에서 4파생 (02 §2.2)
// ============================================================================
//   서버 정렬(`VER_ID DESC, VER_SEQ DESC`)을 그대로 쓴다. FE 재정렬 금지 — 기본선택이 "최신" 이어야 한다.

/** Plan Month(cboVersion) — 선택 Division 의 `VER_ID` DISTINCT. */
export const buildVersionOptions = (
  rows: readonly ComboRow[] | undefined,
  divisionId: string
): ComboOption[] => {
  const seen = new Set<string>();
  const options: ComboOption[] = [];
  for (const row of rows ?? []) {
    if (divisionId && toStr(row.DIVISION_ID) !== divisionId) continue;
    const code = toStr(row.CODE);
    if (!code || seen.has(code)) continue;
    seen.add(code);
    options.push({ label: toStr(row.NAME) || code, value: code });
  }
  return options;
};

/** Version(cboVersionSeq) — Division + Plan Month 로 좁히고 값/표시 둘 다 `VER_SEQ`. */
export const buildVersionSeqOptions = (
  rows: readonly ComboRow[] | undefined,
  divisionId: string,
  version: string
): ComboOption[] => {
  const seen = new Set<string>();
  const options: ComboOption[] = [];
  for (const row of rows ?? []) {
    if (divisionId && toStr(row.DIVISION_ID) !== divisionId) continue;
    if (version && toStr(row.CODE) !== version) continue;
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
  version: string,
  versionSeq: string
): ComboRow | undefined =>
  (rows ?? []).find(
    row =>
      (!divisionId || toStr(row.DIVISION_ID) === divisionId) &&
      (!version || toStr(row.CODE) === version) &&
      (!versionSeq || toStr(row.VER_SEQ) === versionSeq)
  );

/** Plan Type(txtPlanType) — 읽기전용 파생 표시. 매칭 없으면 `RP`(AS-IS ScpCapaBL:656). */
export const derivePlanType = (
  rows: readonly ComboRow[] | undefined,
  divisionId: string,
  version: string,
  versionSeq: string
): string => {
  const row = findVersionRow(rows, divisionId, version, versionSeq);
  return toStr(row?.BIZ_PLAN_USE_YN) === 'Y' ? PLAN_TYPE.BIZ : PLAN_TYPE.ROLLING;
};

/**
 * `_currVersionProgressStatus` — 그 버전의 **현재 진행상태**(`PROG_STAT`).
 * Status 콤보 후보를 좁히는 기준이자 Edit 차단 게이트의 판정값이다(01 L-11).
 * 선택한 Status 콤보 값(`progressStatus`)과 혼동하면 편집 가능 조건이 통째로 달라진다.
 *
 * 버전 행을 못 찾으면 **`'0'`(Current)** 이다 — AS-IS `GetCurrVersionProgessStatus`(cs:1049~1069)가
 * `string res = "0";` 로 시작해 `Rows.Count == 0` 이면 그 초기값을 그대로 돌려준다. 빈 문자열을
 * 돌려주면 Status 후보 필터(`CODE <= curr`)가 무력화돼 `-`/`1` 까지 노출된다(AS-IS 는 `'0'` 하나).
 */
export const deriveCurrProgressStatus = (
  rows: readonly ComboRow[] | undefined,
  divisionId: string,
  version: string,
  versionSeq: string
): string =>
  toStr(findVersionRow(rows, divisionId, version, versionSeq)?.PROG_STAT) ||
  PROGRESS_STATUS.CURRENT;

// ============================================================================
// ⑤ Status — 3중 필터 (02 §2.3)
// ============================================================================
//   1) 항상        : `CODE <= curr` 그리고 `CODE <> '2'`  (2차 컷오프는 Speed Plan 대상 아님)
//   2) curr != '-' : `CODE <> '-'`                        (Pre 제외)
//   3) curr in 1,2 : `CODE <> '0'`                        (1차 컷오프 이후 Current 조회 불가)
//   ASCII 순서가 '-' < '0' < '1' < '2' 라 문자열 비교가 곧 진행 순서다. 숫자 캐스팅 금지.
export const buildProgressStatusOptions = (
  rows: readonly ComboRow[] | undefined,
  currProgressStatus: string
): ComboOption[] =>
  (rows ?? [])
    .filter(row => {
      const code = toStr(row.CODE);
      if (!code) return false;
      // 기준값은 항상 채워져 있다 — `deriveCurrProgressStatus` 가 AS-IS `GetCurrVersionProgessStatus`
      //   (cs:1049~1069)의 `res = "0"` 초기값까지 이식해 버전 행을 못 찾아도 `'0'` 을 돌려준다.
      //   AS-IS 는 `string.Format("CODE <= '{0}'...", curr)`(cs:1073)로 조건을 **무조건** 조립하므로
      //   여기서도 건너뛰지 않는다.
      if (code > currProgressStatus) return false;
      if (code === PROGRESS_STATUS.SECOND_CUTOFF) return false;
      if (currProgressStatus !== PROGRESS_STATUS.PRE && code === PROGRESS_STATUS.PRE) return false;
      if (
        (currProgressStatus === PROGRESS_STATUS.FIRST_CUTOFF ||
          currProgressStatus === PROGRESS_STATUS.SECOND_CUTOFF) &&
        code === PROGRESS_STATUS.CURRENT
      ) {
        return false;
      }
      return true;
    })
    .map(row => ({ label: toStr(row.NAME) || toStr(row.CODE), value: toStr(row.CODE) }));

// ============================================================================
// ⑥ 더미 후치 / ⑦ Line `_C`/`_A` 쌍 재정렬
// ============================================================================

/** `DMY_` 로 시작하는 항목을 목록 맨 뒤로 보낸다(상대 순서 유지). Site/Plant/Building/Line 4곳. */
export const sortDummyLast = (options: ComboOption[]): ComboOption[] => {
  const normal = options.filter(option => !option.value.startsWith(DUMMY_CODE_PREFIX));
  const dummy = options.filter(option => option.value.startsWith(DUMMY_CODE_PREFIX));
  return [...normal, ...dummy];
};

/**
 * Line 목록 재정렬 — 단순 코드 정렬이 아니다(AS-IS RefreshLine cs:1147~1198).
 * CODE 끝 2글자가 `_C`/`_A` 로 **정확히 2행 쌍**을 이루면 같은 그룹으로 묶고 `_C` 를 앞에 둔다.
 * 쌍이 아니면(같은 접두 행이 1개거나 3개 이상) 그 행은 단독 그룹이다.
 * 미재현 시 Line 목록 순서가 AS-IS 와 달라진다(F-13).
 */
export const reorderLinePairs = (options: ComboOption[]): ComboOption[] => {
  const prefixCount = new Map<string, number>();
  for (const option of options) {
    const suffix = option.value.slice(-2);
    if (suffix !== '_C' && suffix !== '_A') continue;
    const prefix = option.value.slice(0, -2);
    prefixCount.set(prefix, (prefixCount.get(prefix) ?? 0) + 1);
  }

  const sorted = [...options].sort((a, b) => a.value.localeCompare(b.value));
  const groups: { key: string; items: ComboOption[] }[] = [];
  const groupIndex = new Map<string, number>();

  for (const option of sorted) {
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
    // 쌍 그룹 안에서만 `_C` -> `_A` 순으로 고정한다.
    [...group.items].sort((a, b) => (a.value.endsWith('_C') ? -1 : b.value.endsWith('_C') ? 1 : 0))
  );
};

// ============================================================================
// ② 마스터 슬라이스 — Site / Plant / Building / Line / Operation / Line Type
// ============================================================================
//   AS-IS 는 콤보 6개가 아니라 **마스터 결과셋 1건의 클라 슬라이스**다(02 §2.4).
//   상위 축이 "전체"면 좁히지 않는다 — AS-IS 도 후보 전체를 IN 목록으로 펼쳐 넣어 결과가 같다.

interface MasterSliceInput {
  rows: readonly ComboRow[] | undefined;
  divisionId: string;
  shopGroupId: string;
  siteId?: string;
  plantId?: string;
  factoryId?: string;
  lineId?: string;
  operationId?: string;
}

/**
 * `DeleteEmptyName(isCodeIsName=false)` 재현(DBUtils.cs:572~633).
 * NAME 이 "CODE NAME" 형태이면 CODE 접두를 떼고, 남는 명칭이 공백이면 그 행을 버린다.
 */
const hasDisplayName = (code: string, name: string): boolean => {
  const trimmed = name.trim();
  if (!trimmed) return false;
  const stripped = trimmed.startsWith(code) ? trimmed.slice(code.length).trim() : trimmed;
  return stripped.length > 0;
};

/**
 * `excludeDashCode` — AS-IS 는 `CODE <> '-'` 를 **일부 축에만** 건다(ScpCapaBL.cs 원문 실측):
 *   `GetFilterSite`(:154) · `GetFilterCompany`(:178) · `GetFilterPlant`(:202) ·
 *   `GetFilterFactory`(:251) · `GetFilterLine`(:300) 5축에만 `res += " AND CODE <> '-'"` 가 있고,
 *   **`GetFilterOperation`(:327~) 과 `GetFilterElectrodeType`(:370~) 에는 없다.**
 * 이 구분을 놓치고 전 축에 걸면 Module/Pack 에서 Line Type 후보가 0건이 되고(실측: SHOP_GROUP `P`
 * 의 `ELTR_LN_TP_CD` 는 `'-'` 122행뿐), `expandMultiSelect` 가 `NONE` 을 보내 **조회가 통째로
 * 0건**이 된다. Cell 도 `'-'` 707행이 후보에서 빠져 조회 범위가 좁아진다.
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
    // ASSEMBLY 의 Line Type 만 isCodeIsName=true — NAME 자체가 공백일 때만 제외한다.
    if (codeIsName ? !name.trim() : !hasDisplayName(code, name)) continue;
    seen.add(code);
    options.push({ label: name, value: code });
  }
  return options;
};

/** 상위 축 조건을 AND 로 건 마스터 행 부분집합. `shopGroupId` 는 DivisionType 파생이라 항상 걸린다. */
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
  const sites = siteId === undefined ? null : selectedSet(siteId);
  const plants = plantId === undefined ? null : selectedSet(plantId);
  const factories = factoryId === undefined ? null : selectedSet(factoryId);
  const lines = lineId === undefined ? null : selectedSet(lineId);
  const operations = operationId === undefined ? null : selectedSet(operationId);

  return (rows ?? []).filter(row => {
    if (divisionId && toStr(row.DIVISION_ID) !== divisionId) return false;
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
 * Site — `GetFilterSite`(ScpCapaBL.cs:144~166) 자체는 `SHOP_GROUP_ID` 를 걸지 않지만, 그 필터가
 * 적용되는 **마스터 결과셋이 이미 shop group 으로 좁혀져 있다**:
 *   `GetCapaLineMasterAll(CELL|MODULE_PACK)`(:65~76) -> `GetFilteredPackCell(temp, divisionType)`
 *   (:35~42) = `DBUtils.Filter(tbl, "SHOP_GROUP_ID = 'A'|'P'")`.
 * 따라서 `RefreshSiteAll`(cs:905~914)이 잘라내는 `dtSiteAll` 도 shop group 스코프다 — 여기서
 * shop group 을 비우면 Cell 과 Module/Pack 의 Site 목록이 같아지고, 그것이 설계 F-10 의 실패 조건이다
 * (실측: 마스터 distinct (DIVISION_ID, SITE_ID) = shop group `A` 15건 / `P` 5건).
 * ELTR 은 원천이 `CapaLineMasterEE_SCP_ALL` 이고 `GetFilteredPackCell` 을 거치지 않지만, 그 결과셋의
 * shop group 이 `E` 단일이라 걸어도 결과가 같다.
 */
export const buildSiteOptions = (input: MasterSliceInput) =>
  sortDummyLast(sliceDistinct(narrowMaster(input), 'SITE_ID', 'SITE_NAME', false));

export const buildPlantOptions = (input: MasterSliceInput) =>
  sortDummyLast(sliceDistinct(narrowMaster(input), 'PLANT_ID', 'PLANT_NAME', false));

export const buildBuildingOptions = (input: MasterSliceInput) =>
  sortDummyLast(sliceDistinct(narrowMaster(input), 'FACTORY_ID', 'FACTORY_NAME', false));

export const buildLineOptions = (input: MasterSliceInput) =>
  reorderLinePairs(
    sortDummyLast(sliceDistinct(narrowMaster(input), 'LINE_ID', 'LINE_NAME', false))
  );

/**
 * ③ Operation — Formation 더미(`AFFFF`)를 제외하고 `DISPLAY_SEQ` 순으로 정렬한다.
 * `DMY_` 후치는 적용하지 않는다(AS-IS 도 DISPLAY_SEQ 정렬이라 미적용, 02 §3.3).
 */
export const buildOperationOptions = (input: MasterSliceInput): ComboOption[] => {
  const narrowed = narrowMaster(input)
    .filter(row => toStr(row.OPERATION_ID) !== FORMATION_OPERATION_ID)
    .slice()
    .sort((a, b) => Number(a.DISPLAY_SEQ ?? 0) - Number(b.DISPLAY_SEQ ?? 0));
  // `CODE <> '-'` 미적용 — AS-IS `GetFilterOperation` 에 그 조건이 없다(sliceDistinct 주석).
  return sliceDistinct(narrowed, 'OPERATION_ID', 'OPERATION_NAME', false, false);
};

/**
 * Line Type(ASSEMBLY 축) — 마스터 슬라이스. `DeleteEmptyName(isCodeIsName=true)` 라
 * "CODE 접두 제거" 를 하지 않고 NAME 공백만 거른다(02 §2.4 표 주석).
 */
export const buildAssemblyLineTypeOptions = (input: MasterSliceInput): ComboOption[] => {
  const narrowed = narrowMaster(input)
    .slice()
    .sort((a, b) => Number(a.DISPLAY_SEQ ?? 0) - Number(b.DISPLAY_SEQ ?? 0));
  // `CODE <> '-'` 미적용 — AS-IS `GetFilterElectrodeType` 에 그 조건이 없다. Module/Pack 은 이 축의
  //   후보가 `'-'` 하나뿐이라(실측 122행) 제외하면 조회가 0건이 된다(sliceDistinct 주석).
  return sliceDistinct(narrowed, 'ELTR_LN_TP_CD', 'ELTR_LN_TP_NM', true, false);
};

/**
 * ④ Line Type(ELTR 축) — 원천이 마스터가 아니라 `OperationElectrodeType_SCP_ALL`(125행) 이고,
 * AS-IS 는 `SHOP_GROUP_ID` 가 아니라 **`OPERATION_ID` 접두**로 거른다(ScpCapaBL.cs:634~652).
 * 이 필터는 이관 CMBO SQL 에 없다 — 빠지면 ELTR 에서 125건 전체가 노출된다(F-12).
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

export const buildEltrLineTypeOptions = (
  rows: readonly ComboRow[] | undefined,
  divisionId: string,
  divisionType: DivisionType
): ComboOption[] => {
  const narrowed = (rows ?? [])
    .filter(row => !divisionId || toStr(row.DIVISION_ID) === divisionId)
    .filter(row => matchesElectrodeOperationPrefix(toStr(row.OPERATION_ID), divisionType))
    .slice()
    .sort((a, b) => Number(a.DISPLAY_SEQ ?? 0) - Number(b.DISPLAY_SEQ ?? 0));
  // 같은 이유로 `CODE <> '-'` 미적용(ELTR 축 실측 후보는 `S`/`W` 2종이라 현 데이터에선 무영향).
  return sliceDistinct(narrowed, 'CODE', 'NAME', true, false);
};

// ============================================================================
// 다중선택 payload 전개 (02 §3.4) — 서버 계약
// ============================================================================
/**
 * AS-IS `CString.GetCheckedListValueNone`(CString.cs:554~581) 재현.
 *   후보 0건       -> `"NONE"`  (존재하지 않는 코드로 결과셋을 비운다)
 *   무선택/전체선택 -> 후보 전체 CODE 를 `,` 로 join  (서버에 `'ALL'` 문자열을 보내지 않는다)
 *   일부 선택      -> 그 CODE 들 `,` join
 *
 * 주의: 숨겨진 축도 값은 나간다 — ELTR 에서 Operation 필드는 숨지만 후보 전체가 실린다.
 * 빈값으로 바꾸면 조회 건수가 달라진다(F-18).
 */
export const expandMultiSelect = (selected: string, candidates: readonly ComboOption[]): string => {
  if (candidates.length === 0) return NONE_SENTINEL;
  if (isAllSelected(selected)) return candidates.map(option => option.value).join(',');
  return selected;
};
