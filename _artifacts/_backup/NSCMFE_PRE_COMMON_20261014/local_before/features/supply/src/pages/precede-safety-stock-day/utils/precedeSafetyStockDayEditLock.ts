// WijmoRowItem 은 configs/types/global.d.ts 전역 타입 (import 불필요 — 다른 화면 util 과 동일).

import { NEW_ROW_LOCKED_COLUMNS } from '../precede-safety-stock-day.constants';

// design/03_grid-columns.md §1 집계(편집가능 10칼럼) — 신규행/기존행 공통 white-list.
//   VALUE_TYPE/OPMZ_PLAN_GR_ID/SCM_SITE_ID/ITEM_ID/STAGE/FROM_YYYYMMDD/TO_YYYYMMDD/
//   TYPE_APPLY_DAY/VALUE_DESCRIPTION/VALID_YN.
const EDITABLE_COLUMNS: ReadonlySet<string> = new Set([
  'VALUE_TYPE',
  'OPMZ_PLAN_GR_ID',
  'SCM_SITE_ID',
  'ITEM_ID',
  'STAGE',
  'FROM_YYYYMMDD',
  'TO_YYYYMMDD',
  'TYPE_APPLY_DAY',
  'VALUE_DESCRIPTION',
  'VALID_YN',
]);

const NEW_ROW_LOCKED: ReadonlySet<string> = new Set(NEW_ROW_LOCKED_COLUMNS);

const crudType = (row: WijmoRowItem | undefined): string => row?.CRUD_TYPE ?? '';

/**
 * 셀 편집 가부 판정 — design/03_grid-columns.md §4.2·§4.3(G-01, iter-2 갱신).
 *
 * 조회 직후(신규행 아님)는 이중 잠금이다: (1) `isEditMode`(EditButton 토글이 아니라
 * `hasButton('EDIT')` 화면 Load 시점 편집권한 판정, memory ssp0025-no-edit-toggle-
 * always-editable)가 false 면 전 칼럼 read-only(gridSignals#7 LockColumn(0,Max,true) 상당).
 * (2) 권한 있어도 DIVISION_ID·감사4칼럼(CREATED_BY~LAST_UPDATE_DATE)은 항상 잠금(gridSignals#4·#5).
 *
 * 신규행(CRUD_TYPE='I')은 isEditMode 와 무관하게 편집가능 10칼럼이 즉시 열린다(gridSignals#10·
 * #11 LockRange — DIVISION_ID + 감사4칼럼만 잠금, §4.3).
 */
export const isMainCellEditable = (
  binding: string,
  row: WijmoRowItem | undefined,
  isEditMode: boolean
): boolean => {
  if (crudType(row) === 'I') {
    return !NEW_ROW_LOCKED.has(binding) && EDITABLE_COLUMNS.has(binding);
  }
  if (!isEditMode) return false;
  return EDITABLE_COLUMNS.has(binding);
};

/**
 * 신규행 기본값 — DIVISION_ID 는 조회조건 선택값을 승계(gridSignals#9 defaultData 상세 미확인,
 * 03_grid-columns.md §4.3 "가정 — SetValue defaultData 상세 미확인으로 확정 아님"). VALID_YN
 * 기본 'Y' 는 화면 업무 관례(그리드 신규행 공통 패턴, AS-IS 원문 미확인 — 확인 필요).
 */
export const precedeSafetyStockDayInsertDefaults = (divisionId: string): Record<string, string> => ({
  DIVISION_ID: divisionId,
  VALUE_TYPE: '',
  OPMZ_PLAN_GR_ID: '',
  OPMZ_PLAN_GR_NAME: '',
  SCM_SITE_ID: '',
  ITEM_ID: '',
  STAGE: '',
  FROM_YYYYMMDD: '',
  TO_YYYYMMDD: '',
  TYPE_APPLY_DAY: '',
  VALUE_DESCRIPTION: '',
  VALID_YN: 'Y',
});
