// SCP0111 그리드 편집잠금 + 컬럼 가시성 순수함수 (design 03 §3-Lock L1~L23 / §3-Other O1~O4).
//   AS-IS 는 조회직후 시트 전체 잠금(L19) 후 EditButton(SwitchLock) 편집모드 진입 시 권한(USER_ID)·
//   Division(81/82/40/기타)·measure/seqFlag 조합으로 pivot 기간셀·BOH·정보열을 선택 해제/재잠금한다.
//   TO-BE 는 별도 편집모드(EditButton)를 두지 않는다 — 권한으로 셀 입력 여부를 바로 결정한다.
//   따라서 AS-IS 의 편집모드 게이트(L1 전건 잠금)는 제거하고, measure/seqFlag/division/권한 규칙만
//   baseline 으로 남겨 beginningEdit 에서 셀 단위로 재현한다.
//   주의: 상수(권한명/컬럼명) 이식 금지 — 규칙표(design 03 §3)를 그대로 함수로 옮긴다.

import {
  DIVISION_ESS,
  DIVISION_SMALL,
  MEASURE,
} from '../integration-psi.constants';

type Row = Record<string, unknown>;

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// AS-IS NowGroupID 3권한(ADMIN / SCM PI Admin / SCP Planner)을 TO-BE 는 USER_ID 기준 권한으로 판정
//   (hook#128 auth-by-userid-not-groupid). 화면은 이 3속성만 소비한다 — 권한 원천은 상위(page)가 주입.
export interface AuthContext {
  isAdmin: boolean; // AS-IS NowGroupID==ADMIN — ADMIN 저장(SAVE_PSI_ADMIN) + DIVISION_ID/PLANT_ID/TO_SITE 편집
  isPiAdmin: boolean; // SCM PI Admin — BOH_QTY 편집 허용(cs:564-570)
  isPlanner: boolean; // SCP Planner — BOH_QTY 편집 허용(cs:564-570)
}

// isEdit = ADMIN | SCM PI Admin | SCP Planner → BOH_QTY 편집 허용 (design 03 §3-Lock cs:564-570).
//   TO-BE 는 편집모드 게이트 없이 권한만으로 판정한다.
export const isBohEditableAuth = (auth: AuthContext): boolean =>
  auth.isAdmin || auth.isPiAdmin || auth.isPlanner;

// 편집 권한 보유 여부 — 편집모드 전용 컬럼(SEQ_FLAG/MEASURE/PLANT_ID/TO_SITE) 가시성 기준.
//   AS-IS 는 IsEditMode 로 노출했으나 TO-BE 는 편집모드가 없으므로 편집 권한 보유 시 노출한다.
export const hasEditAuth = (auth: AuthContext): boolean =>
  auth.isAdmin || auth.isPiAdmin || auth.isPlanner;

// seqFlag 코드 파싱 (design 03 §3-Lock cs:608,676). packFlag=seqFlag[0], measureFlag=seqFlag[1].
//   packFlag: 1 팩/모듈제품, 2 팩/모듈반제품, 3 셀제품, 4 셀반제품, 5 전극, 6 셀후공정제품, 7 셀후공정반제품.
//   measureFlag: 2 Ship Plan Semi, 5 전극, 6 BOH(INV) 등 measure 구분자.
export const packFlag = (row: Row): string => s(row.SEQ_FLAG).charAt(0);
export const measureFlag = (row: Row): string => s(row.SEQ_FLAG).charAt(1);

// pivot 기간칼럼 판정 — 고정 base 20열 이후는 전부 6자리 YYYYMM pivot 컬럼 (design 03 §2-C line 125).
//   AS-IS D_/W_/M_ 접두는 FpSpread 로컬 pivot 이고, TO-BE GET SP 는 raw YYYYMM 을 emit 한다.
export const isPivotColumn = (binding: string, fixedBindings: ReadonlySet<string>): boolean =>
  !fixedBindings.has(binding) && /^\d{6}$/.test(binding);

// ===== pivot 기간셀 편집 판정 (design 03 §3-Lock L2~L23 전건) =====
//   조회직후 전건 잠금(L19) 이 baseline. 아래 규칙에서 "잠금 아님"이 하나도 안 걸리면 편집 가능.
//   AS-IS 는 LockRange 로 명시적으로 "잠근다" — TO-BE 는 반대로 "잠기는 조건"을 모아 하나라도 참이면 잠금.
export interface EditLockContext {
  division: string;
  auth: AuthContext;
  // MULTI_CHILD_ITEM lookup NAME 목록 (design 03 §1-L / L7). 모듈 반제품 편집 예외 판정.
  multiChildItems: ReadonlySet<string>;
}

// pivot 기간셀 잠금 판정 — measure/seqFlag/division 규칙으로 편집 여부를 가린다.
//   TO-BE 는 편집모드(L1 SwitchLock) 게이트가 없다 — 아래 규칙에서 "잠기는 조건"이 하나라도 참이면 잠금.
export const isPivotCellLocked = (
  row: Row,
  ctx: EditLockContext
): boolean => {
  const measure = s(row.MEASURE);
  const div = ctx.division;
  const pf = packFlag(row);
  const mf = measureFlag(row);
  const itemId = s(row.ITEM_ID);
  const valueType = s(row.VALUE_TYPE);

  // 공통: 편집 가능 measure 후보는 Ship Plan Semi/전극(measureFlag∈{2,5})·PROD_PLAN·IN_HOUSE_MOVING 계열.
  //   그 외 measure 는 division 규칙에서 대부분 잠긴다.

  if (div === DIVISION_ESS) {
    // L14 — ESS: measure ∉ {SHIP_PLAN_SEMI, PROD_PLAN, IN_HOUSE_MOVING} 면 기간 전체 잠금.
    if (
      measure !== MEASURE.SHIP_PLAN_SEMI &&
      measure !== MEASURE.PROD_PLAN &&
      measure !== MEASURE.IN_HOUSE_MOVING
    ) {
      return true;
    }
    // L15 — ESS IN_HOUSE_MOVING & seqFlag[0]≠3(Cell 외) 잠금.
    if (measure === MEASURE.IN_HOUSE_MOVING && pf !== '3') return true;
    // L16 — ESS IN_HOUSE_MOVING & seqFlag[0]=3 & valueType='-' 잠금.
    if (measure === MEASURE.IN_HOUSE_MOVING && pf === '3' && valueType === '-') return true;
    return false;
  }

  if (div === DIVISION_SMALL) {
    // L10 — 소형(40): measureFlag ∉ {2,5} 잠금.
    if (mf !== '2' && mf !== '5') return true;
    // L11 — 소형: measureFlag=5 & packFlag ∈ {3,6,7}(셀제품/후공정 제외) 잠금.
    if (mf === '5' && (pf === '3' || pf === '6' || pf === '7')) return true;
    return false;
  }

  // 기타 division (비ESS·비소형):
  // L6 — measureFlag ∉ {2,5} 잠금.
  if (mf !== '2' && mf !== '5') return true;
  // L7 — measureFlag=5 & packFlag=2(모듈 반제품) & MULTI_CHILD_ITEM 미포함 잠금.
  if (mf === '5' && pf === '2' && !ctx.multiChildItems.has(itemId)) return true;
  return false;
};

// ===== 신규행(Insert) 셀 잠금 — AS-IS InsertRow 직후 LockRange (cs:976 / 1054 / 1057) =====
//   AS-IS 는 행을 삽입한 **그 행에** 곧바로 잠금을 건다. 일반 유저(비ADMIN)는 두 범위다:
//     cs:1054  LockRange(insCell, PLAN_TYPE .. VALUE_TYPE, true)
//     cs:1057  LockRange(insCell, TO_SITE_DESCRIPTION .. GetMaxColumnIndex(), true)
//   마지막 컬럼은 SetCalendar(cs:354 AddNumColumn)가 뒤에 붙인 **YYYYMM 월 컬럼**이라, 두 번째 범위가
//   수량 입력칸을 전부 삼킨다(BOH_QTY·UOM·SEQ_FLAG·MEASURE·PLANT_ID·TO_SITE 포함).
//   메타 SORT_ORDER(SCM_MST_SHEET_COLUMNS 실측)로 보면 PLAN_TYPE 10 … VALUE_TYPE 120 /
//   LINE_ID 130 / TO_SITE_DESCRIPTION 140 … 이므로 **두 범위 사이에 남는 칸은 LINE_ID 하나뿐**이다.
//   → 신규행에서 사용자가 하는 일은 "Line 고르기" 뿐이고, 수량은 저장 후 재조회해서 입력한다
//     (사용자 확인 2026-10-13: "Insert 할 때는 Prod plan 수량 입력이 안 된다").
//   ADMIN(cs:976)은 DIVISION_ID 만 잠근다 — "Admin 권한의 경우 전체 컬럼 edit"(2024-07-31) 주석 그대로.
export const INSERT_ROW_ONLY_EDITABLE = 'LINE_ID';
export const isInsertRowCellEditable = (binding: string, auth: AuthContext): boolean =>
  auth.isAdmin ? binding !== 'DIVISION_ID' : binding === INSERT_ROW_ONLY_EDITABLE;

// BOH_QTY 셀 편집 판정 (design 03 §3-Lock L8/L12/L17 — measure=INV & seqFlag[1]=6 & isEdit 권한).
export const isBohCellEditable = (row: Row, ctx: EditLockContext): boolean => {
  if (s(row.MEASURE) !== MEASURE.INV) return false;
  if (measureFlag(row) !== '6') return false;
  return isBohEditableAuth(ctx.auth);
};

// ===== 고정 컬럼 가시성 (design 03 §1 VISIBLE=N / §3-Other O4 SetVisibleSheetColumns) =====
//   VISIBLE=N 2건(MEASURE_COLOR/MEASURE_ORDER_NO)은 상시 숨김. AS-IS 는 아래 4건(SEQ_FLAG/MEASURE/
//   PLANT_ID/TO_SITE)을 IsEditMode 일 때만 노출했으나(cs:1064-1087), TO-BE 는 편집모드가 없으므로
//   편집 권한 보유 시 노출한다(hasEditAuth).
export const HIDDEN_COLUMNS: readonly string[] = ['MEASURE_COLOR', 'MEASURE_ORDER_NO'];
export const EDIT_AUTH_ONLY_COLUMNS: readonly string[] = [
  'SEQ_FLAG',
  'MEASURE',
  'PLANT_ID',
  'TO_SITE',
];

export const isFixedColumnVisible = (
  colName: string,
  baseVisible: boolean,
  canEdit: boolean
): boolean => {
  if (HIDDEN_COLUMNS.includes(colName)) return false; // VISIBLE=N 상시 숨김
  if (EDIT_AUTH_ONLY_COLUMNS.includes(colName)) return canEdit; // 편집 권한 보유 시 노출
  return baseVisible;
};

// ===== 조건부 배경색 C1/C2 (design 03 §3-Color) — ESS 편집가능 셀 연두 배경 =====
//   C1: ESS PROD_PLAN & seqFlag[0]=2(Pack). C2: ESS IN_HOUSE_MOVING & seqFlag[0]=3 & TO_PRODUCT 유효.
//   편집가능=연두(140,240,60) / 잠금=흰(252,252,252). hook#95 표준(편집=Yellow/잠금=Gray)로 매핑.
export const isEssEditableColorCell = (row: Row, division: string): boolean => {
  if (division !== DIVISION_ESS) return false;
  const measure = s(row.MEASURE);
  const pf = packFlag(row);
  if (measure === MEASURE.PROD_PLAN && pf === '2') return true; // C1
  if (measure === MEASURE.IN_HOUSE_MOVING && pf === '3' && s(row.TO_PRODUCT).trim() !== '') {
    return true; // C2
  }
  return false;
};
