// WijmoRowItem 은 configs/types/global.d.ts 전역 타입 (import 불필요 — 다른 화면 util 과 동일).

/**
 * 메인 그리드 편집잠금 — design/03_grid-columns.md §3 white-list(LockColumn#4/#5, LockRange#10/#11)
 * 재현.
 *
 * TO-BE 는 EditButton "편집모드" 토글(잠금 토글 절차)만 이식하지 않으며(asis_to_tobe.md §11, 전 화면
 * 공통 결정), 편집가능 여부 자체는 신규/기존행 구분 없이 컬럼 white-list 로 판정한다 — 즉 조회 직후
 * 전체잠금(gridSignals#7)과 Edit 토글 해제(#3~#5)의 순효과 = "DIVISION_ID + 감사컬럼만 잠그고
 * 나머지는 편집 가능"을 기존행에도 그대로 적용한다(별도 Edit 버튼 없이 바로 수정 가능). 형제
 * SCP0128 safetyStockEditLock 과 동일 구조.
 *
 * 참고: 이 화면 SHEET_COLUMNS.INPUT_TP_CD 는 편집 컬럼이 M/O 로 적재돼 있어(DB 실측 2026-10-13,
 *   이전 "전건 S" 주석은 스테일) 공용 메타 판정(GridUtils.isEditableCell)도 기존행 M/O 셀을
 *   편집 허용한다. 이 white-list 는 그 위에 DIVISION_ID(메타 M 이나 AS-IS 상시 잠금)·감사컬럼·
 *   ITEM_ID(팝업 전용)만 추가로 잠그는 역할이다.
 *
 * LOCKED_ALWAYS = AS-IS LockColumn DIVISION_ID + CREATED_BY~PRE_KEY_VALUES. PRE_KEY_VALUES 는
 *   COLUMN_WIDTH=0 비노출이라 신규/기존행 공통 잠금셋으로 둔다.
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
//   02_search-combo.md §4.6) — 신규행·기존행 모두 셀 편집기는 열지 않는다(팝업 경로만 허용).
const POPUP_ONLY: ReadonlySet<string> = new Set(['ITEM_ID']);

export const isMainCellEditable = (binding: string, row: WijmoRowItem | undefined): boolean => {
  if (!row) return false;
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
