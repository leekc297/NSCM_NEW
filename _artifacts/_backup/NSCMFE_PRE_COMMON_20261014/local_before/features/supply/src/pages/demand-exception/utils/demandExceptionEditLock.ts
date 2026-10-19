// WijmoRowItem 은 configs/types/global.d.ts 전역 타입 (import 불필요 — 다른 화면 util 과 동일).

/**
 * 메인 그리드 편집잠금 — design/03_grid-columns.md §3 white-list(LockColumn#4/#5, LockRange#10/#11)
 * 재현.
 *
 * TO-BE 는 EditButton "편집모드" 토글을 이식하지 않는다(asis_to_tobe.md §11, 전 화면 공통 결정).
 * 따라서 AS-IS 의 SwitchLock/LockColumn(EditButton 클릭 시 해제, gridSignals#3~#5)이 실질적으로
 * 해제되는 시점이 TO-BE 에는 없다 — 조회 직후 read-only(gridSignals#7)가 기존행에는 상시 유지된다
 * (SCP0128 SafetyStock 선례와 동일 구조).
 *
 * 신규행(LockRange#10/#11)만 별도 규칙 — DIVISION_ID + 감사컬럼 4개를 제외한 나머지는 즉시 편집
 * 가능. PRE_KEY_VALUES 는 LockRange 신규행 범위(#11) 밖이나 #5 전체잠금 범위에는 포함돼 있어
 * 보수적으로 잠금 유지(design 03 §1 #16, §3 #4/#5 각주).
 */
const LOCKED_ALWAYS: ReadonlySet<string> = new Set([
  'DIVISION_ID',
  'CREATED_BY',
  'CREATION_DATE',
  'LAST_UPDATED_BY',
  'LAST_UPDATE_DATE',
  'PRE_KEY_VALUES',
]);

// ITEM_ID 는 텍스트 직접입력이 아니라 더블클릭 팝업으로만 채워진다(design 03 §3 #13,
//   02_search-combo.md §4.6) — 신규행이어도 셀 편집기는 열지 않는다(팝업 경로만 허용).
const POPUP_ONLY: ReadonlySet<string> = new Set(['ITEM_ID']);

const crudType = (row: WijmoRowItem | undefined): string => row?.CRUD_TYPE ?? '';

export const isMainCellEditable = (binding: string, row: WijmoRowItem | undefined): boolean => {
  if (crudType(row) !== 'I') return false; // 기존행 = 상시 read-only(Edit 미이식)
  return !LOCKED_ALWAYS.has(binding) && !POPUP_ONLY.has(binding);
};

// 신규행 기본값(design 01 §2 규칙#9/§5-2 확인 필요 — defaultData 원문 미확인, AS-IS 원본 소스
//   부재로 SCP0122/SCP0128 선례대로 조회조건 Division 만 상속하고 나머지는 빈 값으로 채운다.
//   __asis-mapping__.md 에 확인필요로 기록).
export const demandExceptionInsertDefaults = (divisionId: string): Record<string, string> => ({
  DIVISION_ID: divisionId,
  OPMZ_PLAN_GR_ID: '',
  SCM_SITE_ID: '',
  ITEM_ID: '',
  STAGE: '',
  MODEL_TYPE_CD: '',
  FROM_YYYYMMDD: '',
  TO_YYYYMMDD: '',
  STOCK_EXCEPTION: 'N',
  VALUE_DESCRIPTION: '',
  VALID_YN: 'Y',
});
