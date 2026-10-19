// SCP0132 편집잠금 white-list(design 03 §1/§3) + 신규행 기본값(§1 각주) + VAL_TP_CD A/B 파생(§3 #14~17).
//   순수 함수. AS-IS LockColumn/LockRange/SwitchLock(gridSignals 5건)를 화면 편집정책으로 이식 —
//   INPUT_TP_CD 전 컬럼 'S'(메타 미세팅)라 메타 파리티만으론 재현 불가, 코드가 아닌 정책 함수로 명시(hook #130).
//
// design 01 §2#4 는 (SCP0131 과 달리) EditButton 을 SwitchLock+LockColumn 2건 조합으로 "실동작
//   확정"했다 — 조회 직후 전체잠금 -> EditButton 클릭 시 편집 가능(단 ALWAYS_LOCKED_COLUMNS 는
//   토글 무관 항상 잠금 유지).

import { CRUD_TYPE } from '@foundation/constants';

import {
  ALWAYS_LOCKED_COLUMNS,
  EDITABLE_COLUMNS,
  NEW_ROW_LOCKED_COLUMNS,
} from '../constraint-of-shipment-qty.constants';

type Row = Record<string, unknown>;

export const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 신규행 판정 — GridAction.addRow 가 붙이는 CRUD_TYPE='I'.
export const isNewRow = (row: Row): boolean => s(row.CRUD_TYPE) === CRUD_TYPE.INSERT;

// 편집 가능 판정(design 01 §2#4,#6 / 03 §1,§3.2).
//   - 조회 직후(isEditMode=false): 신규행이 아니면 전체 잠금(gridSignal#7 LockColumn 0~Max).
//   - EditButton 클릭(isEditMode=true) 또는 신규행: ALWAYS_LOCKED_COLUMNS(신규행은
//     NEW_ROW_LOCKED_COLUMNS, PRE_KEY_VALUES 제외 — design 03 §1 #23 각주)만 항상 잠금, 나머지는
//     EDITABLE_COLUMNS 화이트리스트로 편집 허용. ITEM_ID 는 팝업 전용(더블클릭) — 인라인 편집 금지.
export const isCellEditable = (binding: string, row: Row, isEditMode: boolean): boolean => {
  if (!(EDITABLE_COLUMNS as readonly string[]).includes(binding)) return false;
  if (binding === 'ITEM_ID') return false;
  const newRow = isNewRow(row);
  if (!isEditMode && !newRow) return false;
  const lockedRange = newRow
    ? (NEW_ROW_LOCKED_COLUMNS as readonly string[])
    : (ALWAYS_LOCKED_COLUMNS as readonly string[]);
  return !lockedRange.includes(binding);
};

// ITEM_ID 팝업 오픈 대상 셀 — 신규행/편집모드 공통.
export const isItemPopupCell = (binding: string): boolean => binding === 'ITEM_ID';

// 신규행 기본값(design 01 §2#6 / 03 §1 #1각주,#3.2) — DIVISION_ID=확정 조회조건 division(항상잠금).
//   나머지 EDITABLE_COLUMNS 는 공란(사용자 입력), 감사4칸/PRE_KEY_VALUES 는 서버/시스템 처리 영역.
export const insertDefaults = (division: string): Row => ({
  DIVISION_ID: division,
  OPMZ_PLAN_GR_ID: '',
  MDL_GR_NM: '',
  ITEM_ID: '',
  STAGE: '',
  FROM_STE_ID: '',
  TO_STE_ID: '',
  FROM_YYYYMMDD: '',
  TO_YYYYMMDD: '',
  SIPM_MIN_QYT: '',
  SIPM_MAX_QTY: '',
  SAT_SIPM_MIN_QTY: '',
  SAT_SIPM_MAX_QTY: '',
  SUN_SIPM_MIN_QTY: '',
  SUN_SIPM_MAX_QTY: '',
  VALUE_DESCRIPTION: '',
  VALID_YN: '',
});

// 파생: ITEM 팝업 선택 -> ITEM_ID 동기(design 03 §3 #13 SetText).
export const applyItemSelect = (row: Row, itemId: string): void => {
  row.ITEM_ID = itemId;
};

// VAL_TP_CD "A"/"B" 자동 태깅(design 03 §3 #14~17) — 일반 Min/Max 쌍(SIPM_*) 편집 시 "A",
//   SAT/SUN 쌍(SAT_SIPM_*/SUN_SIPM_*) 편집 시 "B". AS-IS 원본 부재로 정확한 분기 조건은 확인
//   필요(design 03 §6#1) — 컬럼명 기준 최선 추정이며, EditChange/KeyDown 두 경로가 중복 구현된
//   것으로 보이는 로직을 이 단일 유틸로 통합한다(plan.md §4 통합 권고 반영).
const GENERAL_QTY_COLUMNS = ['SIPM_MIN_QYT', 'SIPM_MAX_QTY'] as const;
const SAT_SUN_QTY_COLUMNS = [
  'SAT_SIPM_MIN_QTY',
  'SAT_SIPM_MAX_QTY',
  'SUN_SIPM_MIN_QTY',
  'SUN_SIPM_MAX_QTY',
] as const;

export const deriveValTpCd = (binding: string): 'A' | 'B' | undefined => {
  if ((GENERAL_QTY_COLUMNS as readonly string[]).includes(binding)) return 'A';
  if ((SAT_SUN_QTY_COLUMNS as readonly string[]).includes(binding)) return 'B';
  return undefined;
};

export const applyValTpCdDerivation = (row: Row, binding: string): void => {
  const derived = deriveValTpCd(binding);
  if (derived) row.VAL_TP_CD = derived;
};
