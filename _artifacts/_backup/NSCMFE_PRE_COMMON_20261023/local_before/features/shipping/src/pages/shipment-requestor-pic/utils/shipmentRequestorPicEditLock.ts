// SSP0025 편집잠금/셀 판정 (design 01_layout §2 R1/R3/R4, 03_grid-columns §3 white-list — gridSignals lock 13건).
//   순수 함수 — 모드×행상태(CRUD_TYPE) 기준 동적 잠금. rowStatus 자체필드 신설 금지(convert-core §2.4).
//   조회직후 기존행 = EDIT_SET(User/Part/Team/Valid) / 신규행('I') = INSERT_SET(콤보·팝업·User..).
//   isEditMode 는 화면 Load 시점에 판정한 **편집권한**(hasButton('EDIT'))이 들어온다 — 사용자 결정(2026-09-23):
//   Edit 버튼 없이 진입 즉시 편집, 단 권한 없으면 읽기전용(상세는 ShipmentRequestorPic.tsx editMode 주석).

import {
  DIVISION_COLUMN,
  EDIT_EDITABLE_COLUMNS,
  INSERT_EDITABLE_COLUMNS,
  ITEM_POPUP_COLUMN,
  USER_POPUP_COLUMNS,
} from '../shipment-requestor-pic.constants';

const EDIT_SET = new Set<string>(EDIT_EDITABLE_COLUMNS);
const INSERT_SET = new Set<string>(INSERT_EDITABLE_COLUMNS);
const USER_SET = new Set<string>(USER_POPUP_COLUMNS);

// 신규행 판정 — 공통 CRUD_TYPE='I' 기준 (convert-core §2.4).
export const isInsertRow = (row: Record<string, unknown> | undefined): boolean =>
  !!row && row.CRUD_TYPE === 'I';

// ITEM_ID = 팝업 전용(키입력/인라인 편집 차단, design 03 §3 R12). 더블클릭 팝업으로만 값 입력.
export const isItemPopupColumn = (binding: string): boolean => binding === ITEM_POPUP_COLUMN;

// User/Part/Team = 더블클릭 UserInfoPopup 전용 이미지셀 (design 03 §3 R16~R18). 인라인 편집 취소.
export const isUserPopupColumn = (binding: string): boolean => USER_SET.has(binding);

// 팝업 전용 셀(인라인 편집 금지 — 더블클릭으로만 값 입력).
export const isPopupColumn = (binding: string): boolean =>
  isItemPopupColumn(binding) || isUserPopupColumn(binding);

// R10 (design 03 §3 R10, cs:628~633) — 신규행 Division 미선택 상태에서 종속 셀 편집/팝업 차단 판정.
//   신규행('I') && DIVISION_ID 공백 && 대상열 != DIVISION_ID -> 편집 전 Division 선택 안내(MSG00097).
//   신규행 DIVISION_ID 는 handleInsert 에서 조회 division 으로 시드되어 실무상 도달 드묾 — AS-IS 완전 파리티용 가드.
export const isDivisionRequired = (
  binding: string,
  row: Record<string, unknown> | undefined
): boolean => isInsertRow(row) && !row?.[DIVISION_COLUMN] && binding !== DIVISION_COLUMN;

// 셀 편집 가능(팝업 포함) — 모드×행상태 판정 (design 03 §3 R3/R4).
export const isCellEditable = (
  binding: string,
  row: Record<string, unknown> | undefined,
  isEditMode: boolean
): boolean => {
  // isEditMode = 화면 Load 시점 편집권한(hasButton('EDIT')). 권한이 없으면 신규행 포함 전 셀 잠금 —
  //   AS-IS 도 셀 상호작용 전건을 `IsLock(SheetName)==false` 로 가둔다(cs:540·622·677).
  if (!isEditMode) return false;
  if (isInsertRow(row)) return INSERT_SET.has(binding);
  return EDIT_SET.has(binding);
};

// 인라인 편집(콤보/텍스트) 허용 — 팝업 셀(ITEM_ID/User..)은 인라인 편집 취소(팝업 전용, nscm-patterns §5-16).
export const isInlineEditable = (
  binding: string,
  row: Record<string, unknown> | undefined,
  isEditMode: boolean
): boolean => !isPopupColumn(binding) && isCellEditable(binding, row, isEditMode);
