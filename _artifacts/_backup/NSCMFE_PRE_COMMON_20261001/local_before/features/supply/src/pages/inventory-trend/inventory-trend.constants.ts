// AS-IS: GSCM/06.UIL/GSCM.SCP.Forms.UIL/Report/SCP0101_InventoryTrend/SCP0101_InventoryTrend.cs
//   화면 성격: 조회 전용 Report — Find + Excel 실동작 / Save NO-OP / 전 컬럼 Lock(리포트).
//   설계 근거: .atlas/gscm-design/SCP0101/design/00_checklist.md ~ 03_grid-columns.md
export const MENU_ID = 'SCP0101' as const;
export type MENU_ID = typeof MENU_ID;

// 단일 시트 — 메인 조회 SP(SCP0101_GET_INVENTORY_TREND). NSCM 단일 sheet 표준 'main'.
//   PKG_SCP0101 미배포(convert-sp 후속) — 컬럼셋은 SCM_MST_SHEET_COLUMNS 47행 메타 구동(index signature).
export enum SHEETS {
  MAIN = 'main',
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = { MAIN: 'o_rc1' } as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// UI Category Setup(admin) SHEET_NAME — AS-IS 원본명 그대로(SpdSheet.shtMain="Inventory Trend", cs:65).
//   컬럼 메타(SCM_MST_SHEET_COLUMNS) fetch 는 이 값으로 조회한다(DB 실측 SHEET_NAME DISTINCT = 'Inventory Trend').
export const ADMIN_SHEET_NAME: Record<SHEETS, string> = {
  [SHEETS.MAIN]: 'Inventory Trend',
};

// 조회조건 콤보 ID (SCM_ADM_CMBO_SQL_M 실측 USE_YN='Y' — design 02 §2.1/2.2).
//   주의: Division 은 MyDivision 이 아니라 Division_SCP 다(SCP0006 silent drift 함정, convert-core §2.6).
//   AS-IS GetDivisionWithoutEE→Data_SCP.Common(Type.Division) 의 정본 SQL_ID = Division_SCP.
//   EE(ATTRIBUTE3='EE') 제외는 Division_SCP WHERE 에 없어 FE 클라 필터로 재현(아래 EE_ATTRIBUTE).
export const COMBO = {
  DIVISION: 'Division_SCP', // 다중선택, 권한필터 SQL 내장. EE 제외는 FE 클라 필터로 재현
  PLANT: 'PlantByGroup_SCP', // 다중선택, @divisionId(콤마 다중 INSTR) 재조회형 cascade
} as const;

// EE(전극) 사업부 제외 클라 필터 — AS-IS BLUtils.GetDivisionWithoutEE 의 "ATTRIBUTE3 <> 'EE'"
//   (design 02 §2-1). Division_SCP 는 ATTRIBUTE3 컬럼을 반환하므로 row.ATTRIBUTE3 로 걸러 등가 재현.
export const EE_ATTRIBUTE = 'EE';

// i18n (Hook #114 — AS-IS MSG_ID 그대로 쓰지 않고 문구로 TO-BE 코드 역조회).
//   REQUIRE_DIVISION: AS-IS MSG00097 의도 = 'No authority assigned.'(권한 Division 없음, asis.py 실측).
//                     TO-BE MSG00097 은 'Please select Division.'(다른 문구)라 AS-IS 번호 재사용 금지 —
//                     의도 문구가 1:1 일치하는 TO-BE 코드 MSG00667(EN 'No authority assigned.' /
//                     KO '권한이 있는 Division이 없습니다.', ora.py 실측)를 쓴다. iter-1 gap-audit 교정.
//   EXCEL_NO_DATA   : AS-IS MSG00100(Excel 조회없음) → TO-BE 등가 문구 MSG00719('No data have been
//                     retrieved.', 실측 존재) 재사용. AS-IS 번호는 TO-BE 미등록이라 재사용 금지.
export const MSG = {
  REQUIRE_DIVISION: 'MSG00667',
  EXCEL_NO_DATA: 'MSG00719',
} as const;

// 컬럼명 상수 — 동적 헤더/조건포맷/행배경/병합 판정에서 참조하는 binding (design 03 §1~§3).
export const COL = {
  YYYYMM: 'YYYYMM',
  DIVISION_ID: 'DIVISION_ID',
  PLANT_DESCRIPTION: 'PLANT_DESCRIPTION',
  PLANT_ID: 'PLANT_ID',
  ITEM_ID: 'ITEM_ID',
  REPORT_TYPE: 'REPORT_TYPE', // 행 배경 트리거(≠'Ending'→LongTerm 음영, R1)
  CHK_QTY: 'CHK_QTY', // hidden 판정컬럼(0/10/20/30/40) — INV_STATUS 조건포맷(R2)
  QTY_MONTH1: 'QTY_MONTH1',
  QTY_MONTH2: 'QTY_MONTH2',
  QTY_MONTH3: 'QTY_MONTH3',
  QTY_MONTH4: 'QTY_MONTH4',
  QTY_MONTH5: 'QTY_MONTH5',
  QTY_MONTH_FOCUS: 'QTY_MONTH_FOCUS',
  LONG_TERM_STOCK_AMOUNT: 'LONG_TERM_STOCK_AMOUNT',
  INV_STATUS_AVAILABLE: 'INV_STATUS_AVAILABLE',
  INV_STATUS_HOLDING: 'INV_STATUS_HOLDING',
  INV_STATUS_QT: 'INV_STATUS_QT',
  INV_STATUS_BLOCKED: 'INV_STATUS_BLOCKED',
} as const;

// REPORT_TYPE 값(2 UNION 형상) — Ending(월말재고) / 그 외=LongTerm(장기재고). design 03 §4.
export const REPORT_TYPE_ENDING = 'Ending';

// 동적 6개월 롤링 헤더 대상 — 선택월 기준 relabel(컬럼 add/remove 없음, design 03 §2).
//   QTY_MONTH1..5 = focus 월 기준 -5..-1개월 yy.MM / QTY_MONTH_FOCUS = focus 월(+Red/Bold).
//   offset = GetYYMM(today, n) 의 n(AS-IS cs:347~398 SetSpreadHeader).
export const MONTH_HEADER_OFFSET: ReadonlyArray<{ binding: string; offset: number }> = [
  { binding: COL.QTY_MONTH1, offset: -5 },
  { binding: COL.QTY_MONTH2, offset: -4 },
  { binding: COL.QTY_MONTH3, offset: -3 },
  { binding: COL.QTY_MONTH4, offset: -2 },
  { binding: COL.QTY_MONTH5, offset: -1 },
  { binding: COL.QTY_MONTH_FOCUS, offset: 0 },
];

// LONG_TERM_STOCK_AMOUNT 헤더(row1=leaf)도 focus 월로 relabel(그룹 row0="Amount(KRW)" 유지, cs:384~388).
export const AMOUNT_FOCUS_MONTH_COLUMN = COL.LONG_TERM_STOCK_AMOUNT;

// INV_STATUS 그룹헤더(row0) — 선택월 기준 "{yy.MM} Inventory Status" relabel(cs:834~843 SetSpreadHeader).
//   메타 SMALL_CLASS_LABEL_NAME = 'Inventory Status' 를 focus 월 접두로 덮어쓴다.
export const INV_STATUS_COLUMNS: readonly string[] = [
  COL.INV_STATUS_AVAILABLE,
  COL.INV_STATUS_HOLDING,
  COL.INV_STATUS_QT,
  COL.INV_STATUS_BLOCKED,
];
export const INV_STATUS_GROUP_SUFFIX = ' Inventory Status';

// 선두 그룹 컬럼 세로 병합(SmartColMerge, design 03 §3 R4 / cs:325). AS-IS SmartColMerge 는 인자 없이
//   호출되고 per-column 병합 정책은 FarPoint 스프레드 템플릿에 있어 .cs/designer/메타에서 추출 불가
//   (SCM_MST_SHEET_COLUMNS 에도 merge 플래그 없음 — FIXED_FLAG 만 존재) → 설계가 명시한 선두 식별 그룹
//   (기간/사업부/Plant/Item)에 적용한다. 공용 CustomMergeManager 는 좌측 누적 키라 선두 연속 컬럼에만
//   유효(grid-behavior-parity §1.3) — ITEM_ID 이후는 REPORT_TYPE/INVENTORY_TYPE 이 달라 자연 종료.
export const MERGE_COLUMNS: ReadonlySet<string> = new Set([
  COL.YYYYMM,
  COL.DIVISION_ID,
  COL.PLANT_DESCRIPTION,
  COL.PLANT_ID,
  COL.ITEM_ID,
]);

// 조건부 셀 포맷 R2 — hidden CHK_QTY 값(40/30/20/10)에 따라 INV_STATUS 4컬럼 배경/글자색(cs:498~546).
//   40 → 4셀 배경 LightGreen + 글자 Red / 30 → AVAILABLE·HOLDING·QT 글자 Red /
//   20 → AVAILABLE·HOLDING·BLOCKED 글자 Red / 10 → AVAILABLE 글자 Red.
//   AS-IS Color.Red = #ff0000 / Color.LightGreen = #90ee90(ControlColor 표준 매핑).
export const CHK_QTY_RED = '#ff0000';
export const CHK_QTY_LIGHT_GREEN = '#90ee90';
export const CHK_QTY_RED_TEXT_BY_VALUE: Readonly<Record<string, readonly string[]>> = {
  '40': INV_STATUS_COLUMNS, // 4셀 전부(+배경)
  '30': [COL.INV_STATUS_AVAILABLE, COL.INV_STATUS_HOLDING, COL.INV_STATUS_QT],
  '20': [COL.INV_STATUS_AVAILABLE, COL.INV_STATUS_HOLDING, COL.INV_STATUS_BLOCKED],
  '10': [COL.INV_STATUS_AVAILABLE],
};

// 행 배경 R1 — LongTerm 행(REPORT_TYPE≠'Ending') 음영(cs:454~482). AS-IS SetBackColor 오버로드 버그로
//   실픽셀은 폼기본색(의도 Silver 미적용, design 03 §6-4). TO-BE 는 의도(LongTerm 행 음영) 재현 —
//   가독성 위해 연한 회색 사용, 정확 색상은 사용자 확인 축(04_react-gap.md 확인필요).
export const LONG_TERM_ROW_BG = '#f2f2f2';

// focus 월 헤더 강조(R3, cs:381~382 ForeColor Red + Bold).
export const FOCUS_HEADER_COLOR = '#ff0000';
