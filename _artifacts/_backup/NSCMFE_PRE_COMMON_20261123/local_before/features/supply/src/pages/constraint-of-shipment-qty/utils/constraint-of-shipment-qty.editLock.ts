// SCP0132 편집잠금 white-list(design 03 §1/§3) + 신규행 기본값(§1 각주) + VAL_TP_CD A/B 파생(§3 #14~17).
//   순수 함수. AS-IS LockColumn/LockRange(gridSignals)를 화면 편집정책으로 이식 —
//   INPUT_TP_CD 전 컬럼 'S'(메타 미세팅)라 메타 파리티만으론 재현 불가, 코드가 아닌 정책 함수로 명시(hook #130).
//
// TO-BE 공통 결정으로 AS-IS Edit 잠금 토글(SwitchLock)은 이식하지 않는다(convert-core §2.4) —
//   편집 가능 여부는 canEdit = hasButton('EDIT') 권한으로만 갈리며, 아래 isCellEditable 의
//   canEdit 인자로 흘러든다. ALWAYS_LOCKED_COLUMNS 는 권한 무관 항상 잠금 유지.

import { CRUD_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import type { EditTracker } from '@foundation/utils';

import {
  ALWAYS_LOCKED_COLUMNS,
  EDITABLE_COLUMNS,
  NEW_ROW_LOCKED_COLUMNS,
} from '../constraint-of-shipment-qty.constants';

type Row = Record<string, unknown>;

export const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 저장/비교용 — FPDate 셀값(Date·'YYYY-MM-DD'·'YYYYMMDD'·시각포함)을 DB 저장형태인 'YYYYMMDD' 8자리로
//   되돌린다. 조회 GET SP 는 FROM/TO_YYYYMMDD 를 TO_CHAR(..., 'YYYY-MM-DD') 로 반환하고(.body:164/167)
//   FPDate 편집은 Date 객체를 쓸 수 있으나, SAVE SP 는 받은 문자열을 변환 없이 컬럼에 넣으므로(.body:337
//   SCM_ARR_SPL_VAL → INSERT/UPDATE) 반드시 8자리로 접어야 한다 — 하이픈째 보내면 DB 오염 + pre-image
//   WHERE(원본 8자리와 불일치)로 UPDATE/DELETE 가 0건이 된다. 자매 SCP0127 toYmd8 과 동일 로직.
export const toYmd8 = (v: unknown): string => {
  if (v instanceof Date) return dayjs(v).format('YYYYMMDD');
  return s(v).replace(/\D/g, '').slice(0, 8);
};

// 신규행 판정 — GridAction.addRow 가 붙이는 CRUD_TYPE='I'.
export const isNewRow = (row: Row): boolean => s(row.CRUD_TYPE) === CRUD_TYPE.INSERT;

// 편집 가능 판정(design 01 §2#6 / 03 §1,§3.2). isEditMode 인자는 화면의 canEdit(=hasButton('EDIT'))
//   권한을 받는다 — Edit 모드 토글이 아니라 mount 1회 권한이다(convert-core §2.4).
//   - 권한 없음(isEditMode=false): 신규행이 아니면 전체 잠금(gridSignal#7 LockColumn 0~Max).
//   - 권한 있음(isEditMode=true) 또는 신규행: ALWAYS_LOCKED_COLUMNS(신규행은
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

// 신규행 기본값(AS-IS Insert_Row .cs:566~568 SetValue defaultData) — DIVISION_ID=확정 조회조건 division(항상잠금),
//   VALID_YN="Y"·VAL_TP_CD="A" 자동 세팅. VAL_TP_CD 는 신규행 잠금 컬럼(NEW_ROW_LOCKED_COLUMNS)이라
//   자동세팅 전용(사용자 변경 불가) — 이후 수량 셀 편집 시 applyValTpCdDerivation 이 일반쌍="A"/주말쌍="B"로 덮는다.
//   나머지 EDITABLE_COLUMNS 는 공란(사용자 입력), 감사4칸/PRE_KEY_VALUES 는 서버/시스템 처리 영역.
export const insertDefaults = (division: string): Row => ({
  DIVISION_ID: division,
  OPMZ_PLAN_GR_ID: '',
  MDL_GR_NM: '',
  ITEM_ID: '',
  STAGE: '',
  FROM_STE_ID: '',
  TO_STE_ID: '',
  // 날짜 칸은 null — '' 면 날짜 편집기가 값을 받지 못해(Date expected) 첫 F2 입력이 오늘 날짜가 된다.
  FROM_YYYYMMDD: null,
  TO_YYYYMMDD: null,
  SIPM_MIN_QYT: '',
  SIPM_MAX_QTY: '',
  SAT_SIPM_MIN_QTY: '',
  SAT_SIPM_MAX_QTY: '',
  SUN_SIPM_MIN_QTY: '',
  SUN_SIPM_MAX_QTY: '',
  VALUE_DESCRIPTION: '',
  VALID_YN: 'Y',
  VAL_TP_CD: 'A',
});

// 파생: ITEM 팝업 선택 -> ITEM_ID 동기(design 03 §3 #13 SetText). 그리드 칸 편집을 거치지 않으므로
//   변경 추적에 직접 알린다 — 빠뜨리면 기존 행에 변경 표시가 없어 저장 요청이 만들어지지 않는다(갭분석 F-01).
export const applyItemSelect = (
  row: Row,
  itemId: string,
  tracker: EditTracker | undefined
): void => {
  tracker?.storeChange(row as WijmoRowItem, 'ITEM_ID', row.ITEM_ID as WijmoPrimitive, itemId);
  row.ITEM_ID = itemId;
};

// VAL_TP_CD "A"/"B" 자동 태깅 — AS-IS SpdMain_EditChange·SpdMain_KeyDown(.cs:1052~1098): SAT/SUN 네 칸을
//   고칠 때 네 칸이 모두 비면 "A", 하나라도 값이 있으면 "B". 평일 Min/Max 를 고쳐도 바꾸지 않는다(갭분석 G-19).
const SAT_SUN_QTY_COLUMNS = [
  'SAT_SIPM_MIN_QTY',
  'SAT_SIPM_MAX_QTY',
  'SUN_SIPM_MIN_QTY',
  'SUN_SIPM_MAX_QTY',
] as const;

export const applyValTpCdDerivation = (row: Row, binding: string): void => {
  if (!(SAT_SUN_QTY_COLUMNS as readonly string[]).includes(binding)) return;
  const empty = SAT_SUN_QTY_COLUMNS.every(key => s(row[key]).trim() === '');
  row.VAL_TP_CD = empty ? 'A' : 'B';
};
