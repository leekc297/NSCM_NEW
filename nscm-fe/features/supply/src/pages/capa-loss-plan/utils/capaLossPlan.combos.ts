import {
  ALL_SENTINEL,
  DIVISION_EXCLUDE_ATTRIBUTE3,
  DIVISION_TYPE,
  DUMMY_CODE_PREFIX,
  EMPTY_CODE,
  FORMATION_OPERATION_ID,
  NONE_SENTINEL,
  OPERATION_WHITELIST_DEFAULT_CODE,
  PLAN_TYPE,
  PROGRESS_STATUS,
  SHEET_TYPE,
  SMALL_DIVISION_ID,
  type DivisionType,
  type SheetType,
} from '../capa-loss-plan.constants';
import type { ComboOption, ComboRow } from '../capa-loss-plan.types';

/**
 * SCP0106 조회조건 콤보의 **클라 후처리 필터 단일 출처**.
 *
 * 배경(convert-core §2.6 핵심 원칙): `SCM_ADM_CMBO_SQL_M` 은 AS-IS 서버 SP 를 그대로 옮긴 것이라,
 * AS-IS 가 C# 에서 SP 호출 **뒤에** 건 후처리 필터(`DBUtils.Filter`/`DataView.RowFilter`)는 이관본에
 * 들어 있지 않다. 그 필터를 FE 가 재현하지 않으면 콤보가 AS-IS 보다 넓게 떠서 조회 범위가 조용히
 * 달라진다. design 02 §2·§3.3 이 실측한 7그룹을 여기 모은다 — 화면 컴포넌트에 흩지 않는다.
 *
 *  (1) Division   `ATTRIBUTE3 <> 'EE'`                          (BLUtils.cs:107~116)
 *  (2) 마스터     `SHOP_GROUP_ID = 'A'|'P'|'E'`                 (ScpCapaBL.cs:35~42)
 *  (3) Status     **3중 필터 — SCP0105 와 다름**                (cs:1262~1298)
 *  (4) Operation  **Formation `AFFFF` 를 전역 제외하지 않는다** (cs:1158~1167, BL:327~368)
 *  (5) Operation  화이트리스트(CELL && 컷오프 && LINE)          (cs:1405~1450)
 *  (6) Line 재정렬 `_C`/`_A` 쌍 묶음                             (cs:1349~1402)
 *  (7) 더미 후치  `DMY_` 접두 항목을 목록 맨 뒤로                (ScpCapaBL.cs:81~136)
 *
 * **자매 SCP0105 의 같은 파일을 복사하면 (3)(4) 와 Line Type 원천이 틀린다**(02 §0 #2/#4/#6).
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
// (1) Division — ATTRIBUTE3 = 'EE'(전극 사업부) 제외
// ============================================================================
//   공유 SQL_ID(`Division_SCP`) 의 WHERE 를 고치지 않는다 — 타 화면 회귀(Hard Boundary §2.2, hook #117).
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

/** Version(cboVersionSeq) — Division + Plan Month 로 좁히고 값/표시 둘 다 `VER_SEQ`(02 §2.2). */
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
 * Status 콤보 후보를 좁히는 기준이자 Edit 게이트의 판정값이다(01 L-12~L-15).
 * 사용자가 고른 Status 콤보 값(`progressStatus`)과 혼동하면 편집 조건이 통째로 달라진다.
 */
export const deriveCurrProgressStatus = (
  rows: readonly ComboRow[] | undefined,
  divisionId: string,
  version: string,
  versionSeq: string
): string => toStr(findVersionRow(rows, divisionId, version, versionSeq)?.PROG_STAT);

// ============================================================================
// (3) Status — 3중 필터 (02 §2.3) — **SCP0105 규칙을 쓰면 실패**(02 §0 #2)
// ============================================================================
//   1) 항상        : `CODE <= curr`
//   2) curr != '-' : `CODE <> '-'`                 (Pre 제외)
//   3) curr in 1,2 : **`CODE = curr` 1건만**       (최종 상태만 남긴다)
//   SCP0105 는 2)·3) 자리에 "항상 `CODE<>'2'`" 와 "`CODE<>'0'`" 을 쓴다 — 결과 집합이 다르다.
//   ASCII 순서가 '-' < '0' < '1' < '2' 라 문자열 비교가 곧 진행 순서다. **숫자 캐스팅 금지**.
export const buildProgressStatusOptions = (
  rows: readonly ComboRow[] | undefined,
  currProgressStatus: string
): ComboOption[] =>
  (rows ?? [])
    .filter(row => {
      const code = toStr(row.CODE);
      if (!code) return false;
      if (currProgressStatus && code > currProgressStatus) return false;
      if (currProgressStatus !== PROGRESS_STATUS.PRE && code === PROGRESS_STATUS.PRE) return false;
      if (
        (currProgressStatus === PROGRESS_STATUS.FIRST_CUTOFF ||
          currProgressStatus === PROGRESS_STATUS.SECOND_CUTOFF) &&
        code !== currProgressStatus
      ) {
        return false;
      }
      return true;
    })
    .map(row => ({ label: toStr(row.NAME) || toStr(row.CODE), value: toStr(row.CODE) }));

// ============================================================================
// (7) 더미 후치 / (6) Line `_C`/`_A` 쌍 재정렬
// ============================================================================

/** `DMY_` 로 시작하는 항목을 목록 맨 뒤로 보낸다(상대 순서 유지). Site/Plant/Building/Line 4곳만. */
export const sortDummyLast = (options: ComboOption[]): ComboOption[] => {
  const normal = options.filter(option => !option.value.startsWith(DUMMY_CODE_PREFIX));
  const dummy = options.filter(option => option.value.startsWith(DUMMY_CODE_PREFIX));
  return [...normal, ...dummy];
};

/**
 * Line 목록 재정렬 — 단순 코드 정렬이 아니다(AS-IS RefreshLine cs:1349~1402).
 * CODE 끝 2글자가 `_C`/`_A` 로 **정확히 2행 쌍**을 이루면 같은 그룹으로 묶고 `_C` 를 앞에 둔다.
 * 쌍이 아니면(같은 접두 행이 1개거나 3개 이상) 그 행은 단독 그룹이다.
 * 미재현 시 Line 목록 순서가 AS-IS 와 달라진다(F-17).
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
// (2) 마스터 슬라이스 — Site / Plant / Building / Line / Operation / Line Type
// ============================================================================
//   AS-IS 는 콤보 6개가 아니라 **마스터 결과셋 1건의 클라 슬라이스**다(02 §2.5).
//   상위 축이 "전체"면 좁히지 않는다 — AS-IS 도 후보 전체를 IN 목록으로 펼쳐 넣어 결과가 같다.
//   **SCP0106 은 Line Type 도 이 마스터에서 나온다**(SCP0105 는 ELTR 만 별도 콤보 — 02 §0 #6).

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

const sliceDistinct = (
  rows: readonly ComboRow[],
  codeKey: string,
  nameKey: string,
  codeIsName: boolean
): ComboOption[] => {
  const seen = new Set<string>();
  const options: ComboOption[] = [];
  for (const row of rows) {
    const code = toStr(row[codeKey]);
    if (!code || seen.has(code)) continue;
    const name = toStr(row[nameKey]) || code;
    if (codeIsName ? !name.trim() : !hasDisplayName(code, name)) continue;
    seen.add(code);
    options.push({ label: name, value: code });
  }
  return options;
};

/** `CODE <> '-'` — Site/Plant/Building/Line 4단계만 적용한다. Operation 단계에는 **없다**(02 §3.3). */
const dropEmptyCode = (rows: readonly ComboRow[], codeKey: string): ComboRow[] =>
  rows.filter(row => toStr(row[codeKey]) !== EMPTY_CODE);

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
 * Site 는 AS-IS `GetFilterSite`(BL:144~166)가 `SHOP_GROUP_ID` 를 걸지 않는다 — Division 만 본다.
 * 다른 5축과 달리 shop group 을 넣으면 후보가 좁아져 AS-IS 와 달라진다.
 */
export const buildSiteOptions = (rows: readonly ComboRow[] | undefined, divisionId: string) =>
  sortDummyLast(
    sliceDistinct(
      dropEmptyCode(narrowMaster({ rows, divisionId, shopGroupId: '' }), 'SITE_ID'),
      'SITE_ID',
      'SITE_NAME',
      false
    )
  );

export const buildPlantOptions = (input: MasterSliceInput) =>
  sortDummyLast(
    sliceDistinct(dropEmptyCode(narrowMaster(input), 'PLANT_ID'), 'PLANT_ID', 'PLANT_NAME', false)
  );

export const buildBuildingOptions = (input: MasterSliceInput) =>
  sortDummyLast(
    sliceDistinct(
      dropEmptyCode(narrowMaster(input), 'FACTORY_ID'),
      'FACTORY_ID',
      'FACTORY_NAME',
      false
    )
  );

export const buildLineOptions = (input: MasterSliceInput) =>
  reorderLinePairs(
    sortDummyLast(
      sliceDistinct(dropEmptyCode(narrowMaster(input), 'LINE_ID'), 'LINE_ID', 'LINE_NAME', false)
    )
  );

// ============================================================================
// (5) Operation 화이트리스트 — CELL && 컷오프 && LINE 일 때만 (02 §2.6) — SCP0106 고유
// ============================================================================

/** 화이트리스트 lookup 을 조회해야 하는 상태인가. 이 조건이 거짓이면 lookup 호출 자체를 하지 않는다. */
export const needsOperationWhitelist = (
  divisionType: DivisionType,
  progressStatus: string,
  sheetType: SheetType
): boolean =>
  divisionType === DIVISION_TYPE.CELL &&
  (progressStatus === PROGRESS_STATUS.FIRST_CUTOFF ||
    progressStatus === PROGRESS_STATUS.SECOND_CUTOFF) &&
  sheetType === SHEET_TYPE.LINE;

/**
 * lookup `CPS_LOSS_CELL_LINE_OPERATION`(4행) -> 허용 OPERATION_ID 집합.
 * `_division === '40'`(소형)이면 `CODE='40'` 행들(`A3000`/`A8210`/`A9000`), 그 외는
 * `CODE='DEFAULT'` 행(`A9000`). 값은 lookup 의 **`NAME`(SEGMENT2)** 이다.
 * 미구현 시 1차 컷오프 후 Line별 비조업 조회에서 `A3000` 공정이 소실된다(F-15).
 */
export const buildOperationWhitelist = (
  rows: readonly ComboRow[] | undefined,
  divisionId: string
): Set<string> => {
  const wanted = divisionId === SMALL_DIVISION_ID ? SMALL_DIVISION_ID : OPERATION_WHITELIST_DEFAULT_CODE;
  const allowed = new Set<string>();
  for (const row of rows ?? []) {
    if (toStr(row.CODE) !== wanted) continue;
    const operationId = toStr(row.NAME);
    if (operationId) allowed.add(operationId);
  }
  return allowed;
};

interface OperationSliceInput extends MasterSliceInput {
  divisionType: DivisionType;
  /** `needsOperationWhitelist` 가 참일 때만 채워진 집합. 비었으면 화이트리스트 미적용. */
  whitelist?: Set<string>;
}

/**
 * (4) Operation — **Formation(`AFFFF`)을 전역 제외하지 않는다.**
 * ELTR 축에서만 `GetCodeFilterExceptFormation`(BL:138~141)이 제외하고, CELL/MODULE_PACK 에서는
 * 후보에 **남아야 한다**. 자매 SCP0105 는 `dtOperationAll` 생성 시 전역 제외라 정반대다(02 §0 #4) —
 * SCP0105 코드를 베끼면 Cell/Module-Pack 조회 후보가 조용히 좁아진다.
 *
 * 정렬은 `DISPLAY_SEQ` 이며 `DMY_` 후치는 적용하지 않는다(02 §3.3 — Operation/LineType 은 미적용).
 */
export const buildOperationOptions = ({
  divisionType,
  whitelist,
  ...master
}: OperationSliceInput): ComboOption[] => {
  const narrowed = narrowMaster(master)
    .filter(row =>
      divisionType === DIVISION_TYPE.ELTR
        ? toStr(row.OPERATION_ID) !== FORMATION_OPERATION_ID
        : true
    )
    .filter(row => !whitelist || whitelist.size === 0 || whitelist.has(toStr(row.OPERATION_ID)))
    .slice()
    .sort((a, b) => Number(a.DISPLAY_SEQ ?? 0) - Number(b.DISPLAY_SEQ ?? 0));
  return sliceDistinct(narrowed, 'OPERATION_ID', 'OPERATION_NAME', false);
};

/**
 * `GetElectrodeOperationFilter`(ScpCapaBL.cs:634~652) — Line Type 의 **Operation 무선택 시** 대체 필터.
 * MODULE_PACK `SUBSTRING(OPERATION_ID,1,1)='P'` / CELL `='A'` / ELTR `OPERATION_ID='E2000'`.
 * DataTable 식의 `SUBSTRING` 은 1-base 라 TS 로는 `slice(0,1)`.
 */
export const ELTR_DEFAULT_OPERATION_ID = 'E2000';

export const matchesElectrodeOperationPrefix = (
  operationId: string,
  divisionType: DivisionType
): boolean => {
  if (divisionType === DIVISION_TYPE.MODULE_PACK) return operationId.slice(0, 1) === 'P';
  if (divisionType === DIVISION_TYPE.CELL) return operationId.slice(0, 1) === 'A';
  return operationId === ELTR_DEFAULT_OPERATION_ID;
};

/**
 * Line Type — **전 축 마스터 슬라이스**다(02 §0 #6, §2.5). SCP0105 처럼 ELTR 에서 별도 콤보
 * (`OperationElectrodeType_SCP_ALL`)를 부르지 않는다. 부르면 후보 집합이 달라진다.
 *
 * 필터는 `DIVISION_ID + OPERATION_ID IN(...)` 이고, **Operation 이 무선택일 때만** 접두 필터로
 * 대체한다(BL:370~403). `DeleteEmptyName(isCodeIsName=true)` 라 CODE 접두 제거 없이 NAME 공백만 거른다.
 */
export const buildLineTypeOptions = ({
  divisionType,
  ...master
}: MasterSliceInput & { divisionType: DivisionType }): ComboOption[] => {
  const hasOperation = master.operationId !== undefined && !isAllSelected(master.operationId);
  const narrowed = narrowMaster(hasOperation ? master : { ...master, operationId: undefined })
    .filter(row =>
      hasOperation
        ? true
        : matchesElectrodeOperationPrefix(toStr(row.OPERATION_ID), divisionType)
    )
    .slice()
    .sort((a, b) => Number(a.DISPLAY_SEQ ?? 0) - Number(b.DISPLAY_SEQ ?? 0));
  return sliceDistinct(narrowed, 'ELTR_LN_TP_CD', 'ELTR_LN_TP_NM', true);
};

// ============================================================================
// 다중선택 payload 전개 (02 §3.4) — 서버 계약
// ============================================================================
/**
 * AS-IS `CString.GetCheckedListValueNone` 재현.
 *   후보 0건       -> `"NONE"`  (존재하지 않는 코드로 결과셋을 비운다)
 *   무선택/전체선택 -> 후보 전체 CODE 를 `,` 로 join  (서버에 `'ALL'` 문자열을 보내지 않는다)
 *   일부 선택      -> 그 CODE 들 `,` join
 *
 * 주의 1: 숨겨진 축도 값은 나간다 — ELTR 에서 Operation 필드는 숨지만 후보 전체가 실린다.
 *   빈값으로 바꾸면 조회 건수가 달라진다(F-23). "숨김 != 값 비움" 이 규약이다.
 * 주의 2: 후보 0건 -> `"NONE"` 은 **AS-IS 본문 미확인분**이다(02 §7 #7 — `…None` 변형이 이 저장소
 *   스냅샷에 없다). 자매 SCP0105 채택값을 승계했고 04 리포트에 "확인필요"로 올려 뒀다.
 * 주의 3: 무선택 전개는 후보 수만큼 길어져 **4000byte 초과 위험**이 있다(goal BLK-16, 미측정).
 */
export const expandMultiSelect = (selected: string, candidates: readonly ComboOption[]): string => {
  if (candidates.length === 0) return NONE_SENTINEL;
  if (isAllSelected(selected)) return candidates.map(option => option.value).join(',');
  return selected;
};
