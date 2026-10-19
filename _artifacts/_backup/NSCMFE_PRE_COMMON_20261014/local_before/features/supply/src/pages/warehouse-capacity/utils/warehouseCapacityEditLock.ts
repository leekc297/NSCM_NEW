// design 01 §2(#2,#6) + design 03 §1.1/§3(gridSignals#7~18) 편집잠금 재현.
//   AS-IS 규칙: DIVISION_ID·감사4컬럼(CREATED_BY/CREATION_DATE/LAST_UPDATED_BY/LAST_UPDATE_DATE)
//   + PRE_KEY_VALUES 는 신규행 포함 항상 잠금(LockColumn/LockRange). AS-IS EditButton(SwitchLock)
//   의 "수정 모드" 토글 어포던스 자체는 TO-BE 미이식 결정(전 화면 공통, `.atlas/memory/
//   editbutton-toggle-not-ported.md`, `Doc/rules/mapping/asis_to_tobe.md §11`) — 아래는 그 토글과
//   무관하게 항상 잠겨야 하는 컬럼 화이트리스트(AS-IS LockColumn 하드코딩 컬럼)만 판정한다.

// AS-IS gridSignals#8/#9/#13/#14 LockColumn/LockRange 대상(신규행 포함 항상 잠금).
export const ALWAYS_LOCKED_COLUMNS = [
  'DIVISION_ID',
  'CREATED_BY',
  'CREATION_DATE',
  'LAST_UPDATED_BY',
  'LAST_UPDATE_DATE',
  'PRE_KEY_VALUES',
] as const;

// ITEM_ID(Warehouse Item Mapping 시트) — 팝업 선택 전용, 직접 타이핑 편집 아님(design 03 §1.2,
//   gridSignals#19 SetText). beginningEdit 에서 취소하고 dblClick 이 팝업을 연다.
export const POPUP_ONLY_COLUMNS = ['ITEM_ID'] as const;

/**
 * 셀 편집 가능 여부. ALWAYS_LOCKED_COLUMNS/POPUP_ONLY_COLUMNS 만 예외 없이 잠금, 그 외 컬럼은
 * 조회 직후에도 바로 편집 가능(EditButton 토글 어포던스 미이식).
 */
export const isCellEditable = (binding: string): boolean => {
  if ((ALWAYS_LOCKED_COLUMNS as readonly string[]).includes(binding)) return false;
  if ((POPUP_ONLY_COLUMNS as readonly string[]).includes(binding)) return false;
  return true;
};

// MAX_CAPA/STOR_PER 음수 클램프 0(design 03 §3 #27, MSG00193/MSG00085). 정수 여부는 admin
//   DATA_SCALE_NUMBER 가 두 컬럼 모두 NULL(design 03 §6-11 확인 필요)이라 이 화면은 부호만 강제한다.
export const clampNonNegative = (raw: unknown): { value: number; coerced: boolean } => {
  const num = Number(raw);
  if (Number.isNaN(num) || num < 0) return { value: 0, coerced: true };
  return { value: num, coerced: false };
};

// Warehouse Item Mapping 시트 전용(design 03 §1.2 #7~9, AS-IS SCP0133_WarehouseCapacity.cs:512-532).
//   STOR_LOC_NAME 컬럼은 division 에 '81_UC' 가 포함될 때만 표시(그 외 division 은 숨김) —
//   admin 메타 속성 리터럴 덮어쓰기가 아니라, 표시할 컬럼 목록 자체에서 제외하는 방식(project-route
//   ProjectRouteMainGrid.tsx R-DYN 선례와 동일 패턴).
export const STOR_LOC_NAME_DIVISION_KEYWORD = '81_UC';
export const isStorLocNameVisible = (divisionId: string): boolean =>
  divisionId.includes(STOR_LOC_NAME_DIVISION_KEYWORD);

// STOR_LOC_NAME(East/West 직접입력) → STOR_LOC 코드 파생(AS-IS .cs:1317-1336 ClipboardPasted,
//   1388-1406 ComboSelChange — 붙여넣기·셀 변경 두 경로 모두 동일 매핑). 그 외 값은 빈 코드.
export const deriveStorLocCode = (storLocName: unknown): string => {
  const name = typeof storLocName === 'string' ? storLocName : '';
  if (name === 'East') return '@E';
  if (name === 'West') return '@W';
  return '';
};
