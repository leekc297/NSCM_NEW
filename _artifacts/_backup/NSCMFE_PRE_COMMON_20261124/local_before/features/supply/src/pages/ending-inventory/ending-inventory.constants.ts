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
  // Item Type 은 콤보(ITEM_MASTER_ITEM_TYPE)가 아니라 DB LOOKUP 'ITEM_TYPE'에서 옵션을 가져온다(아래 LOOKUP).
  //   사유: 품목데이터 DISTINCT 는 실재 코드만이라 '기타'·'저장품' 등 미사용 코드가 빠짐(사용자 결정 2026-10-21).
  // Profit Center — AS-IS SCP0085_GET_SEARCH_INFO SELECT 를 CMBO_SQL 로 이관한 콤보(공통 function 미생성
  //   규약 — 콤보 관련 SP 는 SCM_ADM_CMBO_SQL_M 로 이관). @yyyymmdd 기간 스코프(월 _R / 일 _R_D).
  //   CODE=ATTRIBUTE3, NAME=ATTRIBUTE3+' '+ATTRIBUTE4. p_profit_center 로 전송.
  PROFIT_CENTER: 'SCP0085_GET_SEARCH_INFO',
  // Month 범위·기본값 — AS-IS SCP0085 가 SCP0084_GET_MONTH_RANGE(SetMonthRange cs:494~513)를 재사용한다.
  //   단일 행 MIN_YYYYMM/MAX_YYYYMM(= SELECT MIN/MAX(YYYYMM) FROM SCP_ANL_LONG_TERM_STOCK)를 반환.
  //   기본값=MAX_YYYYMM, 월 피커 상한=MAX_YYYYMM(하한은 AS-IS 하드코딩 '2021-12'). CMBO_SQL_M 이관완료
  //   (SCP0084 와 공용 — 동일 SP). 형제 long-term-stock(SCP0084) 선례 패턴.
  MONTH_RANGE: 'SCP0084_GET_MONTH_RANGE',
} as const;

// 조회조건 LOOKUP ID (SCM_ADM_LOOKUP_MASTER_DETAIL) — Item Type 콤보의 옵션 출처.
//   LOOKUP 'ITEM_TYPE': CODE(SEGMENT1 코드 E/H/P/Q/A/R/-) / NAME(SEGMENT2 한글: 기타/반제품/상품/
//   원부자재/저장품/제품/(Blanks)). 옵션집합·표시명 모두 이 LOOKUP 에서 가져온다(전송값은 CODE).
export const LOOKUP = {
  ITEM_TYPE: 'ITEM_TYPE',
} as const;

// monthPicker 범위 하한 — AS-IS `monthPicker.MonthMin = "2021-12"`(cs:510). 상한/기본값은
//   COMBO.MONTH_RANGE(SCP0084_GET_MONTH_RANGE, PKG_SCP0084 배포완료·CMBO_SQL_M 이관)의 MAX_YYYYMM 로
//   런타임 적용한다(Form 월범위 effect). 범위 미도착/조회실패 시에만 아래 하한연도로 폴백.
export const MONTH_MIN_YEAR = 2021;
// 월 하한(클램프) — AS-IS MonthMin "2021-12" = YYYYMM '202112'. onChange 클램프 하한에 사용.
export const MONTH_MIN = '202112';

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
  // 조회 필수값(AS-IS checkRequiredOfSearch, cs:405) — 활성 모드 기간 피커 미입력 차단.
  //   MSG00429 KO "{0} 값은 필수 입력 항목입니다." / EN "{0} value is required."({0}=기간 라벨 치환)
  REQUIRED_FIELD: 'MSG00429',
  // ERP 집계 안내문(SCM_ADM_MSG_M 실측 — 조회조건 아래 한 줄). 모드별로 문구가 다르다.
  //   월마감: MSG01371 '월마감 기준 데이터는 매월 본사 4 영업일에 집계하며, ERP(ZMMCMR6014) 전월말 재고를 가져옵니다.'
  //   일별  : MSG01370 '일별 기준 데이터는 매일 각 법인별 시업시간 기준 ERP(ZMMCMR6014) 재고를 가져옵니다.'
  //   (구 MSG00378 은 미등록 오코드였음 — 실측으로 교정)
  MONTH_ERP_NOTICE: 'MSG01371',
  DAILY_ERP_NOTICE: 'MSG01370',
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
  MATERIAL: 'LBL00021', // Material (Item ID 라벨 — AS-IS 실화면 라벨 "Material")
  ITEM_TYPE: 'LBL00068', // Item Type
  PROFIT_CENTER: 'LBL01103', // Profit Center
  MONTHLY_BASIS: 'LBL01137', // 월마감 기준 (조회모드 라디오)
  DAILY_BASIS: 'LBL01138', // 일별 기준 (조회모드 라디오)
} as const;

// Devaluation Age 라벨은 TO-BE LBL 코드 미확인 — 코드 확정 전까지 문구를 직접 쓴다(확인 필요).
export const DEVALUATION_AGE_LABEL = 'Devaluation Age';

// 컬럼명 상수 — 동적 가시성/병합/셀색 판정에서 참조하는 binding (design 03 §1/§3).
export const COL = {
  YYYYMM: 'YYYYMM',
  YYYYMMDD: 'YYYYMMDD',
  VALUATION_TYPE: 'VALUATION_TYPE', // Valuation Type — MONTH 모드만 표시(일별 숨김)
  DIVISION_ID: 'DIVISION_ID', // Div
  PLANT_NAME: 'PLANT_NAME', // Plant Site
  PLANT_ID: 'PLANT_ID', // Plant
  ITEM_ID: 'ITEM_ID', // Material
  ITEM_DESCRIPTION: 'ITEM_DESCRIPTION', // Description
  ITEM_UOM: 'ITEM_UOM', // Unit
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

// 세로 병합(SmartColMerge) — AS-IS 관측(사용자 2026-10-21): 월마감=YY.MM(YYYYMM)만 /
//   일별=YY.MM·YY.MM.DD·DIV·Plant Site·Plant·Material·Description·Unit 까지
//        (YYYYMM/YYYYMMDD/DIVISION_ID/PLANT_NAME/PLANT_ID/ITEM_ID/ITEM_DESCRIPTION/ITEM_UOM).
//   병합 세트는 그리드(EndingInventoryGrid)에 둔다. 빈 셀은 미병합(데이터 없으면 병합안함, CustomMergeManager 기본).

// 조건부 셀 배경색(Yellow) 대상 — USE_CELL_CF_BOM='Y' 행의 두 컬럼(design 03 §3 #4/5, cs:256/257).
export const CELL_CF_YELLOW_COLUMNS: readonly string[] = [
  COL.CELL_CONVER_FACTOR,
  COL.CELL_CONVER_QUANTITY,
];
export const CELL_CF_YELLOW = '#ffff00';
