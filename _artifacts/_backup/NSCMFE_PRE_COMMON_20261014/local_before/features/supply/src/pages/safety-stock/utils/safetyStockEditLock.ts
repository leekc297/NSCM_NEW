// WijmoRowItem 은 configs/types/global.d.ts 전역 타입 (import 불필요 — 다른 화면 util 과 동일).

/**
 * 메인 그리드 편집잠금 — design/03_grid-columns.md §3.1 gridSignals white-list
 * (LockColumn #3/#4 · LockRange #9/#10) 재현.
 *
 * TO-BE 는 EditButton "편집모드" 토글을 이식하지 않는다(asis_to_tobe.md §11, design/01_layout.md
 * §11 전 화면 공통 결정 — SCP0127 과 달리 이 화면은 "확인 필요" 가 아니라 명시적 미이식 확정).
 * 따라서 AS-IS 의 LockColumn(#3/#4, EditButton 클릭 시 해제)이 실질적으로 해제되는 시점이
 * TO-BE 에는 없다 — 조회 직후 read-only(#6) 가 기존행에는 상시 유지된다.
 *
 * 신규행(LockRange #9/#10)만 별도 규칙 — DIVISION_ID + 4개 감사컬럼을 제외한 나머지는
 * isEditMode 와 무관하게 즉시 편집 가능(design 03 §3.1 #9/#10, §1 확인 필요 각주 반영).
 * PRE_KEY_VALUES 는 LockRange 범위 밖이나(#10) #4 전체잠금 범위에 포함돼 있어 보수적으로 잠금
 * 유지(design 03 §3.1 #10 확인 필요 각주).
 */
const LOCKED_ALWAYS: ReadonlySet<string> = new Set([
  'DIVISION_ID',
  'CREATED_BY',
  'CREATION_DATE',
  'LAST_UPDATED_BY',
  'LAST_UPDATE_DATE',
  'PRE_KEY_VALUES',
]);

// ITEM_ID 는 텍스트 직접입력이 아니라 더블클릭 팝업으로만 채워진다(design 01 §2 L9, 02 §4.6) —
//   신규행이어도 셀 편집기는 열지 않는다(팝업 경로만 허용).
const POPUP_ONLY: ReadonlySet<string> = new Set(['ITEM_ID']);

const crudType = (row: WijmoRowItem | undefined): string => row?.CRUD_TYPE ?? '';

export const isMainCellEditable = (binding: string, row: WijmoRowItem | undefined): boolean => {
  if (crudType(row) !== 'I') return false; // 기존행 = 상시 read-only(Edit 미이식)
  return !LOCKED_ALWAYS.has(binding) && !POPUP_ONLY.has(binding);
};

// 신규행 기본값 — GAP-06 해소(본 회차 AS-IS 원문 `.cs:507-515` 직접 대조 완료). defaultData.Add
//   호출은 DIVISION_ID(상속)·VALID_YN='Y' 2건뿐, 그 외 컬럼 기본값 없음(빈 문자열) — 아래 구현과
//   1:1 일치 확인, 코드 변경 불요.
export const safetyStockInsertDefaults = (divisionId: string): Record<string, string> => ({
  DIVISION_ID: divisionId,
  VALUE_TYPE: '',
  OPMZ_PLAN_GR_ID: '',
  SCM_SITE_ID: '',
  ITEM_ID: '',
  STAGE: '',
  FROM_YYYYMMDD: '',
  TO_YYYYMMDD: '',
  APL_QTY: '',
  VALUE_DESCRIPTION: '',
  VALID_YN: 'Y',
});
