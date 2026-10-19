// SCP0033 편집잠금/셀 판정 (design 01_layout §2, 03_grid-columns §3.1 white-list — gridSignals lock 6건).
//   순수 함수 — 모드×행상태(CRUD_TYPE) 기준 동적 잠금. rowStatus 자체필드 신설 금지(convert-core §2.4).
//   조회직후 = 전체 lock(editMode=false) / Edit 모드 = 기존행 DEPARTURE_DAY/VALID_YN / 신규행('I') = 지정칸.
//   주의(hook #130): AS-IS LockRange/LockColumn 컬럼명 배열을 상수로 이식하되 모드×행상태 판정에만 쓴다 —
//     INPUT_TP_CD 전건 'S' 라 메타만으론 편집 불가(§6-A). 커스텀 editLock 이 beginningEdit 에서 최종 결정.

import {
  DIVISION_COLUMN,
  EDIT_EDITABLE_COLUMNS,
  INSERT_EDITABLE_COLUMNS,
  ITEM_POPUP_COLUMN,
} from '../shipment-semi-dept-day.constants';

const EDIT_SET = new Set<string>(EDIT_EDITABLE_COLUMNS);
const INSERT_SET = new Set<string>(INSERT_EDITABLE_COLUMNS);

// 신규행 판정 — 공통 CRUD_TYPE='I' 기준 (convert-core §2.4).
export const isInsertRow = (row: Record<string, unknown> | undefined): boolean =>
  !!row && row.CRUD_TYPE === 'I';

// ITEM_ID = 팝업 전용(키입력/인라인 편집 차단, design 03 §3.4 cs:440). 더블클릭/클릭 팝업으로만 값 입력.
export const isItemPopupColumn = (binding: string): boolean => binding === ITEM_POPUP_COLUMN;

// design 03 §3.4 cs:463 — 신규행 ITEM_ID 셀 클릭 시 DIVISION_ID 공백이면 MSG00093 후 팝업 미개방.
//   신규행('I') && DIVISION_ID 공백 && 대상열 == ITEM_ID -> 팝업/편집 차단 + Division 선택 안내.
export const isDivisionRequired = (
  binding: string,
  row: Record<string, unknown> | undefined
): boolean => isInsertRow(row) && !row?.[DIVISION_COLUMN] && isItemPopupColumn(binding);

// 셀 편집 가능(팝업 포함) — 모드×행상태 판정 (design 03 §3.1).
//   신규행 = INSERT_SET(DIVISION_ID/ITEM_ID/DEPARTURE_DAY/VALID_YN) / 기존행 = editMode && EDIT_SET(DEPARTURE_DAY/VALID_YN).
export const isCellEditable = (
  binding: string,
  row: Record<string, unknown> | undefined,
  isEditMode: boolean
): boolean => {
  if (isInsertRow(row)) return INSERT_SET.has(binding);
  return isEditMode && EDIT_SET.has(binding);
};

// 인라인 편집(콤보/텍스트) 허용 — ITEM_ID 는 팝업 전용이라 인라인 편집 취소(nscm-patterns §5-16).
export const isInlineEditable = (
  binding: string,
  row: Record<string, unknown> | undefined,
  isEditMode: boolean
): boolean => !isItemPopupColumn(binding) && isCellEditable(binding, row, isEditMode);
