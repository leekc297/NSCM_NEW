import {
  CASCADE_CLEAR_COLUMNS,
  COLUMN,
  DUMMY_CODE_PREFIX,
  EMPTY_CODE,
  ID_NAME_PAIRS,
} from '../capa-line-assign.constants';
import type { ComboRow, GridRow } from '../capa-line-assign.types';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

/**
 * 콤보 NAME 에서 `코드 + " "` 접두를 제거해 순수 명칭만 남긴다
 * (AS-IS `SetSpreadNameToCode`, cs:1764 / cs:1797-1800 — "Code + ' ' Name 형태에서 Name 으로 변경").
 *
 * 콤보 SP 는 NAME 을 `"A3000 Assembly"`(코드+공백+명칭)로 실어 온다. AS-IS 는 그리드 셀 명칭에
 * 넣기 전에 이 접두를 떼어 셀에는 명칭("Assembly")만 보인다. 조회조건 콤보(`clbSite`/`clbOperation`)는
 * 반대로 `dtSiteAll`/`dtOperationAll`(`ChangeColumnNameToCodeName` → NAME="코드 명칭")를 그대로 쓰므로
 * 거기서는 떼지 않는다 — strip 은 그리드 셀 경로(값·명칭후보)에만 적용한다.
 */
const stripCodePrefix = (code: string, name: string): string =>
  code && name.startsWith(`${code} `) ? name.slice(code.length + 1) : name;

/**
 * 그리드 셀 콤보 — 단일 출처 (design 03 §0.4·§3.2·§5.6 B-2~B-6).
 *
 * AS-IS 는 셀 콤보를 메타가 아니라 C# `SheetUtils.SetComboDataRow` 60+ 호출로 런타임 주입한다(X-F).
 * 그래서 TO-BE 컬럼 메타에는 `YesOrNo` 6행(VALID_YN/DUMMY_YN)뿐이고, SITE/COMPANY/PLANT/FACTORY/
 * LINE/OPERATION 의 **ID·NAME 양쪽** + `ELTR_LN_TP_CD` + `NICK_NAME`/`ITEM_ID` 는 미이관이다.
 * 그 미이관분을 화면이 복원한다 — 후보 원천은 조회조건과 **같은 마스터 콤보**다(AS-IS `dt*SpreadAll`
 * 도 동일 마스터 파생이라 후보 집합이 어긋나지 않는다).
 *
 * 후보는 "그 행의 현재 상위 값"으로 매번 다시 계산한다(§3.2.2 cascade 5단).
 */

/** 그 행의 상위 코드와 일치하는 마스터 행만 남긴다. 빈 상위 값은 필터를 걸지 않는다(전 후보). */
const matches = (row: ComboRow, context: Record<string, string>): boolean => {
  for (const [key, value] of Object.entries(context)) {
    if (!value) continue;
    if (str(row[key]) !== value) return false;
  }
  return true;
};

/** AS-IS `GetDummyCheckedCode`(cs:1745-1748) — Dummy(`DMY_`) 부모 코드는 하위 필터 기준에서 뺀다(빈값=무필터). */
const dummyUnchecked = (code: string): string => (code.startsWith(DUMMY_CODE_PREFIX) ? '' : code);

/**
 * 셀 콤보 코드 정렬 — AS-IS `GetSortedCode`(ScpCapaBL.cs:81-136): CODE 오름차순, 단 `DMY_` 접두
 * Dummy 는 **맨 뒤**(제외가 아니다). `'-'`(센티널)도 맨 뒤로 둔다 — Line Type `keepEmpty` 축에만
 * 존재하며 AS-IS 자연순서상 높은 DISPLAY_SEQ 로 하단에 온다.
 */
const compareCellCode = (a: string, b: string): number => {
  const aDummy = a.startsWith(DUMMY_CODE_PREFIX);
  const bDummy = b.startsWith(DUMMY_CODE_PREFIX);
  if (aDummy !== bDummy) return aDummy ? 1 : -1;
  const aDash = a === EMPTY_CODE;
  const bDash = b === EMPTY_CODE;
  if (aDash !== bDash) return aDash ? 1 : -1;
  return a.localeCompare(b);
};

/**
 * 코드 후보 — `'-'`(센티널)만 제외하고, `DMY_` 접두 Dummy 는 **제외하지 않고 맨 뒤로** 둔다.
 *
 * AS-IS 의 어느 `GetFilterDummy*`(Site/Company/Plant/Factory/Line)도 DMY_ 를 걸러내지 않는다 —
 * `CODE <> '-'` 만 있고(ScpCapaBL.cs:414·430·446·487·527), `GetSortedCode` 가 DMY_ 를 맨 뒤로
 * 정렬할 뿐이다. 사내 마스터에 선존재하는 DMY_ 라인(실측 43건)을 셀 콤보에서 고를 수 있어야 한다.
 * (K-11 "Dummy 는 하위 필터에서 제외"는 Dummy 가 **부모로 선택됐을 때 자식 필터 기준에서 뺀다**는
 *  뜻이다 — {@link dummyUnchecked} — 후보 목록에서 지우라는 뜻이 아니다. 조회조건 쪽 `sortMasterCodes`
 *  /`distinctByCode` 도 DMY_ 를 끝에 포함한다.)
 *
 * `keepEmpty=true` 면 `'-'` 도 남긴다 — Line Type(ELTR_LN_TP_CD) 전용이다. AS-IS
 * `GetFilterElectrodeType`(ScpCapaBL.cs:370-403)는 location 축의 `GetFilterDummySite`(cs:414
 * `CODE <> '-'`)와 달리 `'-'` 를 거르지 않는다. `'-'` 는 유효 Line Type 이라, 빼면 Operation
 * A9000/AFFFF/P5500/P9500 행의 셀 후보가 0건이 돼 입력 제한(검증)이 풀린다(2026-11-18 DB 실측).
 */
const codesOf = (rows: ComboRow[], key: string, keepEmpty = false): string[] => {
  const seen = new Set<string>();
  for (const row of rows) {
    const code = str(row[key]);
    if (!code) continue;
    if (!keepEmpty && code === EMPTY_CODE) continue;
    seen.add(code);
  }
  return [...seen].sort(compareCellCode);
};

/**
 * 명칭 후보 — 코드 축(`codesOf`)과 같은 멤버십·순서를 쓰되 표시값(`*_NAME`)을 돌려준다.
 * AS-IS `dtOperationSpreadName`/`dt*SpreadName`(cs:1800)처럼 `코드 + " "` 접두를 뗀 순수 명칭이다.
 *
 * 정렬은 **코드 순서**다 — 명칭 가나다순이 아니다. AS-IS `SetSpreadNameToCode`(cs:1775-1807)가
 * `GetSortedCode`(CODE 오름차순, DMY_ 맨 뒤)로 정렬된 테이블을 그대로 복사해 명칭만 치환하므로,
 * 명칭 콤보도 코드 콤보와 같은 순서(DMY_ 포함, 맨 뒤)로 선다. 명칭 기준으로 정렬하면 같은 필드의
 * ID 콤보와 NAME 콤보 후보 순서가 어긋난다(예: Site Name A001 LGES Korea→A002 LGES China 뒤집힘).
 */
const namesOf = (rows: ComboRow[], idKey: string, nameKey: string): string[] => {
  const seen = new Map<string, string>();
  for (const row of rows) {
    const code = str(row[idKey]);
    const name = str(row[nameKey]);
    // `codesOf` 와 동일 멤버십: '-'(EMPTY_CODE)·빈 명칭만 제외(DMY_ 는 포함해 맨 뒤로 정렬).
    if (!code || code === EMPTY_CODE || !name) continue;
    if (!seen.has(code)) seen.set(code, stripCodePrefix(code, name));
  }
  return [...seen.entries()].sort(([a], [b]) => compareCellCode(a, b)).map(([, name]) => name);
};

export interface CellComboSources {
  masterRows: ComboRow[];
  operationRows: ComboRow[];
  electrodeRows: ComboRow[];
  /** `CapaNickname_SCP_ALL` — `CODE`/`NAME` 별칭이 없어 `NICK_NAME`/`ITEM_ID` 를 직접 읽는다(§6-2). */
  nicknameRows: ComboRow[];
}

/**
 * 현재 행 기준 셀 콤보 후보 (design 03 §3.2.2 실측 매트릭스 그대로).
 *   DIVISION → Site/Company/Plant/Factory/Line/Nickname · SITE → Company/Plant/Factory/Line
 *   PLANT → Factory/Line · FACTORY → Line · OPERATION → ElectrodeType
 * 주의(§3.3 함정1): Operation 은 Line 에 종속되지 않는다 — 여기에 LINE_ID 를 더하면 결함이다.
 */
export const buildCellComboCandidates = (
  binding: string,
  row: GridRow,
  sources: CellComboSources,
  isEltr: boolean
): string[] | null => {
  const division = str(row[COLUMN.DIVISION_ID]);
  const site = str(row[COLUMN.SITE_ID]);
  const company = str(row[COLUMN.COMPANY_ID]);
  const plant = str(row[COLUMN.PLANT_ID]);
  const factory = str(row[COLUMN.FACTORY_ID]);
  const master = sources.masterRows;

  switch (binding) {
    case COLUMN.SITE_ID:
      return codesOf(master.filter(r => matches(r, { DIVISION_ID: division })), 'SITE_ID');
    case COLUMN.SITE_NAME:
      return namesOf(
        master.filter(r => matches(r, { DIVISION_ID: division })),
        'SITE_ID',
        'SITE_NAME'
      );
    case COLUMN.COMPANY_ID:
      return codesOf(
        master.filter(r => matches(r, { DIVISION_ID: division, SITE_ID: site })),
        'COMPANY_ID'
      );
    case COLUMN.COMPANY_NAME:
      return namesOf(
        master.filter(r => matches(r, { DIVISION_ID: division, SITE_ID: site })),
        'COMPANY_ID',
        'COMPANY_NAME'
      );
    case COLUMN.PLANT_ID:
      return codesOf(
        master.filter(r => matches(r, { DIVISION_ID: division, SITE_ID: site, COMPANY_ID: company })),
        'PLANT_ID'
      );
    case COLUMN.PLANT_NAME:
      return namesOf(
        master.filter(r => matches(r, { DIVISION_ID: division, SITE_ID: site, COMPANY_ID: company })),
        'PLANT_ID',
        'PLANT_NAME'
      );
    // Building(Factory)은 Division·Plant 뿐 아니라 **Company 로도 좁힌다** — AS-IS
    //   `GetFilterDummyFactory`(ScpCapaBL.cs:480-499)가 `COMPANY_ID = company` 를 AND 로 더한다.
    //   Company 를 빼면 Plant 가 빈 행에서 다른 Company 의 Building 까지 후보에 뜬다(cs:1844 `_curr_assign_company`).
    case COLUMN.FACTORY_ID:
      return codesOf(
        master.filter(r =>
          matches(r, { DIVISION_ID: division, COMPANY_ID: company, PLANT_ID: dummyUnchecked(plant) })
        ),
        'FACTORY_ID'
      );
    case COLUMN.FACTORY_NAME:
      return namesOf(
        master.filter(r =>
          matches(r, { DIVISION_ID: division, COMPANY_ID: company, PLANT_ID: dummyUnchecked(plant) })
        ),
        'FACTORY_ID',
        'FACTORY_NAME'
      );
    // Line 은 Division·Factory 뿐 아니라 **Plant 로도 좁힌다** — AS-IS `GetFilterDummyLine`
    //   (ScpCapaBL.cs:520-527)은 `DIVISION_ID·SHOP_GROUP_ID·PLANT_ID·FACTORY_ID` + `CODE<>'-'` 다
    //   (shop_group 은 masterRows 선필터로 반영). Plant/Factory 가 Dummy 면 `dummyUnchecked` 로
    //   필터에서 빼 AS-IS `GetDummyCheckedCode(_plant)·(_factory)`(cs:1854)와 같게 한다.
    case COLUMN.LINE_ID:
      return codesOf(
        master.filter(r =>
          matches(r, {
            DIVISION_ID: division,
            PLANT_ID: dummyUnchecked(plant),
            FACTORY_ID: dummyUnchecked(factory),
          })
        ),
        'LINE_ID'
      );
    case COLUMN.LINE_NAME:
      return namesOf(
        master.filter(r =>
          matches(r, {
            DIVISION_ID: division,
            PLANT_ID: dummyUnchecked(plant),
            FACTORY_ID: dummyUnchecked(factory),
          })
        ),
        'LINE_ID',
        'LINE_NAME'
      );
    case COLUMN.OPERATION_ID:
      return codesOf(
        sources.operationRows.filter(r => matches(r, { DIVISION_ID: division })),
        'CODE'
      );
    case COLUMN.OPERATION_NAME:
      return namesOf(
        sources.operationRows.filter(r => matches(r, { DIVISION_ID: division })),
        'CODE',
        'NAME'
      );
    case COLUMN.ELTR_LN_TP_CD:
      return codesOf(
        sources.electrodeRows.filter(r =>
          matches(r, { DIVISION_ID: division, OPERATION_ID: str(row[COLUMN.OPERATION_ID]) })
        ),
        'CODE',
        true // Line Type 은 `'-'` 를 유효 후보로 남긴다(AS-IS `GetFilterElectrodeType` 에 `CODE<>'-'` 없음)
      );
    // F07 — 현재 행 Division 기준. CELL/MODULE_PACK 은 NICK_NAME, ELTR 은 ITEM_ID 축이다.
    case COLUMN.NICK_NAME:
      if (isEltr) return null; // ELTR 의 NICK_NAME 은 잠금 컬럼이라 후보가 없다(G43)
      return codesOf(
        sources.nicknameRows.filter(r => matches(r, { DIVISION_ID: division })),
        'NICK_NAME'
      );
    case COLUMN.ITEM_ID:
      if (!isEltr) return null; // ASSEMBLY 의 ITEM_ID 는 저장 시 '-' 고정이라 편집 대상이 아니다
      return codesOf(
        sources.nicknameRows.filter(r => matches(r, { DIVISION_ID: division })),
        'ITEM_ID'
      );
    default:
      return null;
  }
};

/**
 * 코드↔명칭 양방향 동기 (design 03 §3.2 G06·G08~G13·G16).
 *   · `*_ID` 입력 → 대응 `*_NAME` 을 마스터에서 찾아 세팅
 *   · `*_NAME` 입력 → `*_ID` 역세팅
 *   · `*_ID` 공백 → `*_NAME` 클리어(`ClearRowName`, cs:3814-3819)
 * 변경된 컬럼 목록을 돌려준다(호출부가 그리드 무효화 범위를 정한다).
 */
export const syncCodeAndName = (
  binding: string,
  row: GridRow,
  sources: CellComboSources
): string[] => {
  const pair = ID_NAME_PAIRS.find(entry => entry.id === binding || entry.name === binding);
  if (!pair) return [];
  // OPERATION 은 `operationRows`(CODE/NAME), 나머지는 location `masterRows` 에서 찾는다(AS-IS cs:2803-2820).
  const source = pair.source === 'operation' ? sources.operationRows : sources.masterRows;
  const division = str(row[COLUMN.DIVISION_ID]);
  const scoped = source.filter(r => matches(r, { DIVISION_ID: division }));

  if (binding === pair.id) {
    const id = str(row[pair.id]);
    if (!id) {
      row[pair.name] = '';
      return [pair.name];
    }
    const hit = scoped.find(r => str(r[pair.masterId]) === id);
    if (!hit) return [];
    // AS-IS `SetSpreadNameToCode`(cs:2815) — 셀 명칭은 `코드 + " "` 접두를 뗀 순수 명칭이다.
    row[pair.name] = stripCodePrefix(str(hit[pair.masterId]), str(hit[pair.masterName]));
    return [pair.name];
  }

  const name = str(row[pair.name]);
  if (!name) return [];
  // 셀 명칭 후보가 strip 된 값이므로(namesOf) 역세팅 비교도 strip 된 명칭 기준이다.
  const hit = scoped.find(
    r => stripCodePrefix(str(r[pair.masterId]), str(r[pair.masterName])) === name
  );
  if (!hit) return [];
  row[pair.id] = str(hit[pair.masterId]);
  return [pair.id];
};

/**
 * 하위 코드 cascade 클리어 (design 03 §3.2.1 `ClearCurrRowSubCodes`, cs:3702-3820).
 * 말미의 `ClearRowName` 6회(= `*_ID` 공백이면 `*_NAME` 도 비움)까지 함께 수행한다.
 */
export const clearSubCodes = (binding: string, row: GridRow): string[] => {
  const pair = ID_NAME_PAIRS.find(entry => entry.id === binding || entry.name === binding);
  // 매트릭스 키는 `*_ID` 기준이며 `*_NAME` 변경도 같은 하위 집합을 지운다(§3.2.1 표 1열).
  const key = pair ? pair.id : binding;
  const targets = CASCADE_CLEAR_COLUMNS[key];
  const cleared: string[] = [];
  if (targets) {
    for (const column of targets) {
      if (row[column] === '' || row[column] === undefined) continue;
      row[column] = '';
      cleared.push(column);
    }
  }
  for (const entry of ID_NAME_PAIRS) {
    if (!str(row[entry.id]) && str(row[entry.name])) {
      row[entry.name] = '';
      cleared.push(entry.name);
    }
  }
  return cleared;
};

/**
 * Dummy 자동 마킹 (design 03 §3.2 G07 / F14).
 * SITE/COMPANY/PLANT/FACTORY/LINE 의 코드가 Dummy 목록에 있으면 `DUMMY_YN='Y'`, 아니면 `'N'`.
 * **OPERATION 은 Dummy 를 검사하지 않는다**(cs:3653 주석).
 */
const DUMMY_CHECK_COLUMNS: readonly string[] = [
  COLUMN.SITE_ID,
  COLUMN.COMPANY_ID,
  COLUMN.PLANT_ID,
  COLUMN.FACTORY_ID,
  COLUMN.LINE_ID,
];

export const markDummyYn = (row: GridRow, dummyCodes: Set<string>): boolean => {
  const isDummy = DUMMY_CHECK_COLUMNS.some(column => {
    const code = str(row[column]);
    return !!code && (dummyCodes.has(code) || code.startsWith(DUMMY_CODE_PREFIX));
  });
  const next = isDummy ? 'Y' : 'N';
  if (str(row[COLUMN.DUMMY_YN]) === next) return false;
  row[COLUMN.DUMMY_YN] = next;
  return true;
};
