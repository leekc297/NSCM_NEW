// WijmoRowItem 은 configs/types/global.d.ts 전역 타입 (import 불필요 — 다른 화면 util 과 동일).

/**
 * 메인 그리드 편집잠금 — design/03_grid-columns.md §3.1 gridSignals white-list
 * (LockColumn #3/#4 · #6 · LockRange #9/#10) 재현.
 *
 * TO-BE 는 EditButton "편집모드" 토글을 이식하지 않는다(asis_to_tobe.md §11, design/01_layout.md
 * §11 전 화면 공통 결정). 다만 이는 "Edit 버튼(잠금 토글 절차)"만 제거한다는 뜻이고, 편집가능
 * 여부 자체는 신규/기존행 구분 없이 컬럼 메타(=AS-IS LockColumn white-list)로 판정한다
 * (design 01 §2 L108 "별도 모드 진입 없이 조건 맞는 셀 즉시 편집", L75·L113 "기존행은 column
 * meta 판정으로 분기"). 즉 조회 직후 전체잠금(#6)과 Edit 토글 해제(#3/#4)의 순효과 =
 * "DIVISION_ID + 감사컬럼만 잠그고 나머지는 편집 가능" 을 기존행에도 그대로 적용한다.
 *
 * 주의: 이 화면 SHEET_COLUMNS.INPUT_TP_CD 는 16행 전건 'S'(read-only)로 적재돼 공용 메타 판정
 *   (GridUtils.isEditableCell)만으로는 전 컬럼 잠금으로 해석된다(design 03 §3.1 L46 확인 필요).
 *   그래서 편집가능 컬럼을 메타가 아니라 이 white-list 로 직접 재현한다.
 *
 * LOCKED_ALWAYS = AS-IS LockColumn #3(DIVISION_ID) + #4(CREATED_BY~PRE_KEY_VALUES 5컬럼).
 *   신규행 LockRange(#10)는 PRE_KEY_VALUES 를 범위 밖에 두나, PRE_KEY_VALUES 는 COLUMN_WIDTH=0
 *   화면 비노출이라 실질 차이가 없어 신규/기존행 공통 잠금셋으로 둔다.
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
//   신규행·기존행 모두 셀 편집기는 열지 않는다(팝업 경로만 허용).
const POPUP_ONLY: ReadonlySet<string> = new Set(['ITEM_ID']);

export const isMainCellEditable = (binding: string, row: WijmoRowItem | undefined): boolean => {
  if (!row) return false;
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
