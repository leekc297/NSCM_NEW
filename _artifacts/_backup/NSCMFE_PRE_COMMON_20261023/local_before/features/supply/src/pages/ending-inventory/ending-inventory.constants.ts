// AS-IS: GSCM/06.UIL/GSCM.SCP.Forms.UIL/Report/SCP0085_EndingInventory/SCP0085_EndingInventory.cs
//   화면 성격: 조회 전용 Report — Find + Excel 실동작 / Edit·Save NO-OP / 전 컬럼 Lock.
//   설계 근거: .atlas/gscm-design/SCP0085/design/00_checklist.md ~ 03_grid-columns.md
export const MENU_ID = 'SCP0085' as const;
export type MENU_ID = typeof MENU_ID;

// 조회 SP 이중화(design 02 §2.2 / 03 §4-2): 월별·일별로 GET SP 가 다르다. 컬럼 메타는 단일
//   'Ending Inventory Main' 을 공유하나(ADMIN_SHEET_NAME), SP 라우팅은 시트로 갈라야 하므로
//   procedures.d.ts SHEETS 는 main(월)·daily(일) 두 개를 둔다.
export enum SHEETS {
  MAIN = 'main', // 월별 — SCP0085_GET_ENDING_INVENTORY (p_yyyymm)
  DAILY = 'daily', // 일별 — SCP0085_GET_ENDING_INVENTORY_DAILY (p_yyyymmdd)
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = { MAIN: 'o_rc1', DAILY: 'o_rc1' } as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// UI Category Setup(admin) SHEET_NAME — AS-IS 원본명 그대로. 컬럼 메타(SCM_MST_SHEET_COLUMNS)
//   fetch 는 이 값으로 조회한다(월·일 모드 공통 단일 컬럼셋, DB 실측 99행). SHEETS value 와 분리.
export const ADMIN_SHEET_NAME: Record<SHEETS, string> = {
  [SHEETS.MAIN]: 'Ending Inventory Main',
  [SHEETS.DAILY]: 'Ending Inventory Main',
};

// 조회모드 — AS-IS RdoMonth(기본)/RdoDate 라디오(designer:341 Checked=true). 좌측 세로 라디오 그룹으로 재현한다.
export const SEARCH_MODE = {
  MONTH: 'MONTH',
  DAILY: 'DAILY',
} as const;
export type SearchMode = (typeof SEARCH_MODE)[keyof typeof SEARCH_MODE];

// 조회조건 콤보 ID (SCM_ADM_CMBO_SQL_M 실측 PASS — design 02 §2.1). 이름 유사 재사용 아님,
//   의미 5층(CODE+권한필터+EE제외/@divisionId cascade+반환 CODE/NAME) 일치 확인됨(goal.md ④).
export const COMBO = {
  DIVISION: 'MyDivision', // 다중선택, EE 제외 + user-group unit-auth 권한필터 SQL 내장. 값 전체=ALL
  PLANT: 'PlantByGroup_SCP', // 다중선택, @divisionId(콤마 다중 INSTR) 재조회형 cascade
  ITEM_TYPE: 'ItemType', // 다중선택, 전체=ALL (demand 화면 공용 콤보 ID)
} as const;

// monthPicker 범위 하한 — AS-IS `monthPicker.MonthMin = "2021-12"`(cs:404). 상한/기본값은 AS-IS 가
//   SCP0084_GET_MONTH_RANGE.MAX_YYYYMM 를 쓰나(cs:399~405) PKG_SCP0084 미배포(goal.md ② C1) →
//   convert-sp 배포 전까지 현재월을 상한/기본으로 폴백한다(런타임 조회는 SP 배포 후 재판정).
export const MONTH_MIN_YEAR = 2021;

// i18n (Hook #114 — AS-IS MSG_ID 그대로 쓰지 않고 문구로 TO-BE 코드 역조회).
//   REQUIRE_DIVISION: TO-BE 등록됨(MSG00097 = 'Please select Division.').
//   EXCEL_NO_DATA   : AS-IS MSG00100(Excel 조회없음) → TO-BE 등가 문구 MSG00719('No data have been
//                     retrieved.') 재사용. AS-IS 번호(MSG00100)는 TO-BE 미등록이라 재사용 금지.
//   DAILY_ERP_NOTICE: AS-IS MSG00378(일별 ERP 07:30 안내) → TO-BE 미등록. SCM_ADM_MSG_M 쓰기는
//                     convert-react DB 쓰기 범위 밖(db-access.md) + CN 임의번역 금지(convert-core §2.3)
//                     → fallback defaultValue 로만 노출, 정식 등록은 사용자/admin 결정(04 확인필요).
export const MSG = {
  REQUIRE_DIVISION: 'MSG00097',
  EXCEL_NO_DATA: 'MSG00719',
  DAILY_ERP_NOTICE: 'MSG00378',
} as const;

// UI 라벨 코드 — SCM_ADM_MSG_M(MSG_TP_CD='LBL') 문구 역조회(#114). AS-IS 번호 그대로 쓰지 않는다.
export const LBL = {
  SEARCH: 'LBL00112', // Search(F5)
  MONTHLY: 'LBL00684', // Monthly (조회모드 라벨/옵션)
  DAILY: 'LBL00682', // Daily (조회모드 옵션)
  DATE: 'LBL00069', // Date (DAILY 모드 기간 라벨)
  MONTH: 'LBL00066', // Month (MONTH 모드 기간 라벨)
  DIVISION: 'LBL00001', // Division (표준 LBL00001)
  PLANT: 'LBL00030', // Plant
  MATERIAL: 'LBL00021', // Material (Item ID 라벨)
  ITEM_TYPE: 'LBL00068', // Item Type
} as const;

// AS-IS 일별 안내문(cs:544 주석) — TO-BE MSG 미등록 fallback 문안.
export const DAILY_ERP_NOTICE_FALLBACK =
  'Daily-based data reflects ERP (ZMMB0180) inventory as of 07:30 AM KST each day.';

// Devaluation Age 라벨은 TO-BE LBL 코드 미확인 — 코드 확정 전까지 문구를 직접 쓴다(확인 필요).
export const DEVALUATION_AGE_LABEL = 'Devaluation Age';

// 컬럼명 상수 — 동적 가시성/병합/셀색 판정에서 참조하는 binding (design 03 §1/§3).
export const COL = {
  YYYYMM: 'YYYYMM',
  YYYYMMDD: 'YYYYMMDD',
  DIVISION_ID: 'DIVISION_ID',
  PLANT_NAME: 'PLANT_NAME',
  PLANT_ID: 'PLANT_ID',
  QUANTITY: 'QUANTITY', // 상세토글 트리거 헤더(더블클릭)
  UNRESTRICTED_QTY: 'UNRESTRICTED_QTY',
  BLOCKED_STOCK: 'BLOCKED_STOCK',
  IN_TRANSIT: 'IN_TRANSIT',
  CELL_TYPE_GR: 'CELL_TYPE_GR',
  USE_CELL_CF_BOM: 'USE_CELL_CF_BOM',
  CELL_CONVER_FACTOR: 'CELL_CONVER_FACTOR',
  CELL_CONVER_QUANTITY: 'CELL_CONVER_QUANTITY',
} as const;

// 상세 3컬럼 — QUANTITY 헤더 더블클릭 토글(design 03 §3 #9~14, cs:476~497). 초기 숨김.
export const DETAIL_COLUMNS: readonly string[] = [
  COL.UNRESTRICTED_QTY,
  COL.BLOCKED_STOCK,
  COL.IN_TRANSIT,
];

// 재고월령 39컬럼(M1~M13 × QUANTITY/AMOUNT/AMOUNT_KRW) — Devaluation Age 체크 시만 표시한다.
//   주의: 메타 M*_QUANTITY 13컬럼은 VISIBLE_FLAG=Y 이나 초기 숨김이 기본이라 코드로 hide 한다.
const AGING_SUFFIXES = ['QUANTITY', 'AMOUNT', 'AMOUNT_KRW'] as const;
export const AGING_COLUMNS: readonly string[] = Array.from({ length: 13 }, (_, i) => i + 1).flatMap(
  n => AGING_SUFFIXES.map(sfx => `M${n}_${sfx}`)
);

// 선두 그룹 컬럼 세로 병합(SmartColMerge, design 03 §3 #8 / cs:362). AS-IS SmartColMerge 는 인자 없이
//   호출되고 per-column 병합 정책은 FarPoint 스프레드 템플릿에 있어 .cs/designer/메타에서 추출 불가
//   (SCM_MST_SHEET_COLUMNS 에도 merge 플래그 없음 — FIXED_FLAG 만 존재) → 설계가 명시한 선두 그룹
//   (DIVISION_ID/PLANT_NAME/PLANT_ID …)에 선두 기간 컬럼(YYYYMM/YYYYMMDD)을 더해 적용한다.
//   공용 CustomMergeManager 는 좌측 누적 키 방식이라 선두 연속 컬럼에만 유효(grid-behavior-parity §1.3).
export const MERGE_COLUMNS: ReadonlySet<string> = new Set([
  COL.YYYYMM,
  COL.YYYYMMDD,
  COL.DIVISION_ID,
  COL.PLANT_NAME,
  COL.PLANT_ID,
]);

// 조건부 셀 배경색(Yellow) 대상 — USE_CELL_CF_BOM='Y' 행의 두 컬럼(design 03 §3 #4/5, cs:256/257).
export const CELL_CF_YELLOW_COLUMNS: readonly string[] = [
  COL.CELL_CONVER_FACTOR,
  COL.CELL_CONVER_QUANTITY,
];
export const CELL_CF_YELLOW = '#ffff00';
