// SSP0024 편집잠금/셀 판정 (design 01_layout §2 R1/R2, 03_grid-columns §3.1 white-list — gridSignals lock 12건).
//   순수 함수 — 모드×행상태(CRUD_TYPE) 기준 동적 잠금. rowStatus 자체필드 신설 금지(convert-core §2.4).
//   조회직후 = 전체 lock(editMode=false) / Edit 모드 = 기존행 9칸 / 신규행('I') = 지정칸.

import {
  EDIT_EDITABLE_COLUMNS,
  INSERT_EDITABLE_COLUMNS,
  MATERIAL_POPUP_COLUMN,
} from '../shipment-master-electrode.constants';

const EDIT_SET = new Set<string>(EDIT_EDITABLE_COLUMNS);
const INSERT_SET = new Set<string>(INSERT_EDITABLE_COLUMNS);

// 신규행 판정 — 공통 CRUD_TYPE='I' 기준 (convert-core §2.4).
export const isInsertRow = (row: Record<string, unknown> | undefined): boolean =>
  !!row && row.CRUD_TYPE === 'I';

// MATERIAL_ID = 팝업 전용(키입력/인라인 편집 차단, design 03 §3.4 cs:650). 더블클릭 팝업으로만 값 입력.
export const isMaterialPopupColumn = (binding: string): boolean => binding === MATERIAL_POPUP_COLUMN;

// 인라인 편집 가능 셀 — 모드×행상태 판정 (design 03 §3.1).
//   MATERIAL_ID 는 편집가능 대상이라도 인라인 편집은 금지(팝업 전용) — 아래 isInlineEditable 에서 제외.
//   신규행도 Edit 모드에서만 편집 가능하다(gap-resolve iter-1 G4): AS-IS SwitchLock 은 편집모드를 끌 때
//   'I' 행의 전 셀을 다시 Locked=true 로 잠그고(SpreadInfo.cs:9686~9698), 시트 lock 초기값이 true 라
//   (SpreadInfo.cs:412) Edit 진입 전에는 신규행이 생기지도 편집되지도 않는다.
export const isCellEditable = (
  binding: string,
  row: Record<string, unknown> | undefined,
  isEditMode: boolean
): boolean => {
  if (!isEditMode) return false;
  if (isInsertRow(row)) return INSERT_SET.has(binding);
  return EDIT_SET.has(binding);
};

// 인라인 편집(더블클릭 팝업 제외) 허용 — MATERIAL_ID 는 팝업 전용이라 인라인 편집 취소(nscm-patterns §5-16).
export const isInlineEditable = (
  binding: string,
  row: Record<string, unknown> | undefined,
  isEditMode: boolean
): boolean => !isMaterialPopupColumn(binding) && isCellEditable(binding, row, isEditMode);
