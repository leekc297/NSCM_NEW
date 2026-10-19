// SCP0114 편집잠금 / 신규행 판정 (design 03_grid-columns §3.2·§3.3 white-list — gridSignals lock 54건).
//   순수 함수 — 레벨 × 행상태(CRUD_TYPE) × DUMMY_YN × 편집모드 기준 동적 잠금.
//   rowStatus/isNew 류 자체 행상태 필드 신설 금지 — 공통 CRUD_TYPE 만 본다(convert-core §2.4).
//
// hook #130(LockRange 상수 이식 금지): AS-IS `siLevelN.LockRange(row, colIdx, row, colIdx, bool)` 의
//   "컬럼 인덱스 배열"을 그대로 옮기지 않는다. AS-IS 가 그 인덱스로 표현하던 의미(자기 ID / 자기 NAME /
//   항상잠금 3컬럼)를 컬럼명 축으로 재현하고, 실제 게이트는 beginningEdit 에서 이 함수가 판정한다.
//
// AS-IS 근거 (SCP0114_CAPA_LineMaster.cs):
//   - 조회 직후 전열 읽기전용        : cs:748 `LockColumn(0, GetMaxColumnIndex(), true)`
//   - DUMMY_YN='N' 행 전열 잠금      : cs:520~525 / 551~554 / 580~583 / 609~612 / 640~643
//   - DUMMY_YN='Y' + 편집모드 on     : 자기 NAME 만 해제(cs:531/560/589/618/649), L5 는 VALID_YN 도 해제(cs:652)
//   - 자기 ID 는 기존행에서 항상 잠금: cs:530/559/588/617/648 -> 신규행('I')에서만 편집(cs:1265~1290)
//   - DIVISION_ID/DUMMY_YN/SHOP_GROUP_ID 항상 잠금: cs:519/524/532/650~651

import {
  ALWAYS_LOCKED_COLUMNS,
  DUMMY_EDITABLE_FLAG,
  DUMMY_YN_COLUMN,
  INSERT_DEFAULT_DUMMY_YN,
  INSERT_DEFAULT_VALID_YN,
  LEVEL_ID_COLUMN,
  LEVEL_NAME_COLUMN,
  LEVEL_PARENT_KEYS,
  SORT_ORDER_COLUMN,
  VALID_YN_COLUMN,
  type LevelNo,
} from '../capa-line-master.constants';
import type { DrillContext } from '../capa-line-master.types';

const ALWAYS_LOCKED = new Set<string>(ALWAYS_LOCKED_COLUMNS);

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 신규행 판정 — 공통 CRUD_TYPE='I' 기준 (convert-core §2.4).
export const isInsertRow = (row: Record<string, unknown> | undefined): boolean =>
  !!row && row.CRUD_TYPE === 'I';

// dummy 행(수기 등록) 판정 — 'N' = FP 인터페이스 유입 데이터라 Code/Name 모두 변경 불가(업무규칙 4).
export const isDummyRow = (row: Record<string, unknown> | undefined): boolean =>
  str(row?.[DUMMY_YN_COLUMN]) === DUMMY_EDITABLE_FLAG;

/**
 * 셀 편집 가능 판정 — 이 화면의 편집 게이트 단일 원천.
 * beginningEdit(e.cancel) 과 formatItem(배경색)이 같은 함수를 써야 "노란칸인데 못 고치는" 상태가 안 생긴다.
 *
 * @param editingLevel 현재 편집모드인 레벨(없으면 null). 5그리드 중 동시 1개만(cs:490~502).
 */
export const isCellEditable = (
  level: LevelNo,
  binding: string,
  row: Record<string, unknown> | undefined,
  editingLevel: LevelNo | null
): boolean => {
  if (!row || !binding) return false;
  // (e) DIVISION_ID / DUMMY_YN / SHOP_GROUP_ID / SORT_ORDER 는 어떤 상태에서도 잠금.
  if (ALWAYS_LOCKED.has(binding)) return false;

  const idColumn = LEVEL_ID_COLUMN[level];
  const nameColumn = LEVEL_NAME_COLUMN[level];
  const isValidYnOfLevel5 = level === 5 && binding === VALID_YN_COLUMN;

  // (d) 신규행: 자기 ID + 자기 NAME (+L5 VALID_YN) 만 편집. 부모키는 상속값이라 잠금(cs:1265~1290).
  if (isInsertRow(row)) return binding === idColumn || binding === nameColumn || isValidYnOfLevel5;

  // (a) 조회 직후(편집모드 아님) 또는 다른 레벨 편집중이면 전열 읽기전용.
  if (editingLevel !== level) return false;
  // (b) DUMMY_YN='N' 행은 편집모드여도 전열 잠금.
  if (!isDummyRow(row)) return false;
  // (c) 자기 NAME (+L5 VALID_YN) 만 해제.
  return binding === nameColumn || isValidYnOfLevel5;
};

/**
 * 드릴다운 가능 판정 (design 01 §2 L6, 00 §4d #8~#12).
 * - L5 는 최하위라 재조회 없음(cs:1816~1833 은 ID 캐시만 하고 FindData 미호출).
 * - 해당 시트 `Rows.Count <= 0` 이면 무동작(cs:1745/1764/1781/1799).
 * - Action 컬럼 visible(=편집모드) 이면 억제(cs:1748/1767/1784/1802) -> TO-BE 는 editingLevel 로 판정.
 */
export const canDrillDown = (
  level: LevelNo,
  rowCount: number,
  editingLevel: LevelNo | null
): boolean => level < 5 && rowCount > 0 && editingLevel !== level;

// 기존 행들의 SORT_ORDER 최대값 + 1 (AS-IS cs:1206~1212 — ds 없으면 1).
export const nextSortOrder = (rows: readonly Record<string, unknown>[]): number => {
  let max = 0;
  for (const row of rows) {
    const parsed = Number(row[SORT_ORDER_COLUMN]);
    if (Number.isFinite(parsed) && parsed > max) max = parsed;
  }
  return max + 1;
};

/**
 * 신규행 기본값 — 레벨별 부모키 상속 + 공통 기본값 (design 03 §3.3 R11~R17, cs:1215~1262).
 *
 * 필수: 부모키는 "드릴다운으로 확정된 상위 컨텍스트"에서만 온다. 빈 값 폴백으로 행을 만들면
 *   미조회 상태 삽입 = 데이터 결함이다(convert-core §2.4). 호출 전에 hasParentContext 로 막는다.
 */
export const buildInsertRow = (
  level: LevelNo,
  divisionId: string,
  shopGroupId: string,
  drill: DrillContext,
  rows: readonly Record<string, unknown>[]
): Record<string, unknown> => {
  const next: Record<string, unknown> = {
    CRUD_TYPE: 'I',
    DIVISION_ID: divisionId,
    [SORT_ORDER_COLUMN]: nextSortOrder(rows),
    [VALID_YN_COLUMN]: INSERT_DEFAULT_VALID_YN,
    [DUMMY_YN_COLUMN]: INSERT_DEFAULT_DUMMY_YN,
    [LEVEL_ID_COLUMN[level]]: '',
    [LEVEL_NAME_COLUMN[level]]: '',
  };
  for (const key of LEVEL_PARENT_KEYS[level]) {
    next[key] = str(drill[key as keyof DrillContext]);
  }
  // L5 만 SHOP_GROUP_ID 를 조회조건 Product Group 에서 상속(cs:1256).
  if (level === 5) next.SHOP_GROUP_ID = shopGroupId;
  return next;
};

// 신규행 삽입 사전조건 — 레벨별 부모 컨텍스트가 전부 확정돼 있는가(미조회 삽입 차단).
export const hasParentContext = (level: LevelNo, drill: DrillContext): boolean =>
  LEVEL_PARENT_KEYS[level].every(key => !!str(drill[key as keyof DrillContext]));
