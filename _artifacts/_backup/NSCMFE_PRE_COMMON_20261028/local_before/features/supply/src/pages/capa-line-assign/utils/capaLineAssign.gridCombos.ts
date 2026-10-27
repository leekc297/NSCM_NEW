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

/** 코드 후보 — `'-'` 와 `DMY_` 접두 Dummy 는 하위 필터 대상에서 제외한다(K-11). */
const codesOf = (rows: ComboRow[], key: string): string[] => {
  const seen = new Set<string>();
  for (const row of rows) {
    const code = str(row[key]);
    if (!code || code === EMPTY_CODE || code.startsWith(DUMMY_CODE_PREFIX)) continue;
    seen.add(code);
  }
  return [...seen].sort((a, b) => a.localeCompare(b));
};

/** 명칭 후보 — 코드 축과 같은 필터를 쓰되 표시값(`*_NAME`)을 돌려준다. */
const namesOf = (rows: ComboRow[], idKey: string, nameKey: string): string[] => {
  const seen = new Set<string>();
  for (const row of rows) {
    const code = str(row[idKey]);
    const name = str(row[nameKey]);
    if (!code || code === EMPTY_CODE || !name) continue;
    seen.add(name);
  }
  return [...seen].sort((a, b) => a.localeCompare(b));
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
    case COLUMN.FACTORY_ID:
      return codesOf(
        master.filter(r => matches(r, { DIVISION_ID: division, PLANT_ID: plant })),
        'FACTORY_ID'
      );
    case COLUMN.FACTORY_NAME:
      return namesOf(
        master.filter(r => matches(r, { DIVISION_ID: division, PLANT_ID: plant })),
        'FACTORY_ID',
        'FACTORY_NAME'
      );
    case COLUMN.LINE_ID:
      return codesOf(
        master.filter(r => matches(r, { DIVISION_ID: division, FACTORY_ID: factory })),
        'LINE_ID'
      );
    case COLUMN.LINE_NAME:
      return namesOf(
        master.filter(r => matches(r, { DIVISION_ID: division, FACTORY_ID: factory })),
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
        'CODE'
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
  masterRows: ComboRow[]
): string[] => {
  const pair = ID_NAME_PAIRS.find(entry => entry.id === binding || entry.name === binding);
  if (!pair) return [];
  const division = str(row[COLUMN.DIVISION_ID]);
  const scoped = masterRows.filter(r => matches(r, { DIVISION_ID: division }));

  if (binding === pair.id) {
    const id = str(row[pair.id]);
    if (!id) {
      row[pair.name] = '';
      return [pair.name];
    }
    const hit = scoped.find(r => str(r[pair.masterId]) === id);
    if (!hit) return [];
    row[pair.name] = str(hit[pair.masterName]);
    return [pair.name];
  }

  const name = str(row[pair.name]);
  if (!name) return [];
  const hit = scoped.find(r => str(r[pair.masterName]) === name);
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
