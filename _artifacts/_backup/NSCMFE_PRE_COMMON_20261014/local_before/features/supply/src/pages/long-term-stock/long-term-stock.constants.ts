// AS-IS: GSCM/06.UIL/GSCM.SCP.Forms.UIL/Report/SCP0084_LongTermStock/SCP0084_LongTermStock.cs
//   화면 성격: 조회 리포트 + MEMO 단일 컬럼 Edit-토글 편집 + 저장(MEMO) + 엑셀.
//   설계 근거: .atlas/gscm-design/SCP0084/design/00_checklist.md ~ 03_grid-columns.md
export const MENU_ID = 'SCP0084' as const;
export type MENU_ID = typeof MENU_ID;

// 단일 그리드 리포트(master-detail 아님, PIVOT 아님). 조회/저장 SP 라우팅 키 = main 단일.
//   조회 SCP0084_GET_LONG_TERM_STOCK / 저장 SCP0084_SAVE_LONG_TERM_STOCK_MEMO_ROW_DATASET.
//   PKG_SCP0084 미배포(convert-sp 후속) — 컬럼셋은 SCM_MST_SHEET_COLUMNS 59행 메타 구동.
export enum SHEETS {
  MAIN = 'main',
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = { MAIN: 'o_rc1' } as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// UI Category Setup(admin) SHEET_NAME — AS-IS 원본명 그대로. 컬럼 메타(SCM_MST_SHEET_COLUMNS)
//   fetch 는 이 값으로 조회한다(DB 실측 59행). SHEETS value 와 분리(design 03 §1).
export const ADMIN_SHEET_NAME: Record<SHEETS, string> = {
  [SHEETS.MAIN]: 'Long Term Stock',
};

// 조회조건 콤보 ID (SCM_ADM_CMBO_SQL_M 실측 PASS — design 02 §2). 이름 유사 재사용 아님:
//   Division 은 Division_SCP(권한필터 SQL, EE 미제외 → FE 클라필터 필요), Plant 는
//   PlantByGroup1_SCP_ALL(권한무시 전체, 파라미터 없음 → FE 클라 cascade 필터). MyDivision/
//   PlantByGroup_SCP 재사용 금지(SCP0006 선례, convert-core §2.6).
export const COMBO = {
  DIVISION: 'Division_SCP',
  PLANT: 'PlantByGroup1_SCP_ALL',
} as const;

// Division 콤보 결과에서 전극(EE) 사업부 제외 — AS-IS BLUtils.GetDivisionWithoutEE(cs:40) 의
//   클라 후처리 필터 `ATTRIBUTE3 <> 'EE'`. Division_SCP CMBO SQL 엔 이 필터가 없어(권한/VALID_YN
//   뿐) FE 에서 재현해야 후보 범위가 AS-IS 와 같다(design 02 §2-1, convert-core §2.6).
export const DIVISION_EXCLUDE_ATTRIBUTE3 = 'EE';

// Long Term Type — AS-IS 하드코딩 3옵션(cs:97~106/151~167, SQL/lookup 아님). CODE→SP 전달값,
//   NAME=표시명([E20250310-000014] 용어변경 "부실"→"장기" 반영). i18n LBL 신규등록은 사용자
//   결정(goal.md 확인필요 #4) — AS-IS 는 한글 하드코딩이라 현행 그대로 재현(추측 번역 금지).
export const LONG_TERM_TYPE_OPTIONS: readonly { code: string; name: string }[] = [
  { code: 'CODE_2', name: '비대상' },
  { code: 'CODE_5', name: '장기 징후' },
  { code: 'CODE_6', name: '장기' },
];

// monthPicker 범위 하한 — AS-IS 는 SCP0084_GET_MONTH_RANGE(MIN/MAX_YYYYMM)로 min/max/기본(최신월)
//   을 세팅하나(cs:361~368) PKG_SCP0084 미배포(goal.md ②) → convert-sp 배포 전까지 현재월을
//   기본/상한, 2021 을 하한으로 폴백한다(ending-inventory 선례). 런타임 범위는 SP 배포 후 재판정.
export const MONTH_MIN_YEAR = 2021;

// i18n LABEL (DB 실측 PASS — design 02 §4.5, 전건 존재·신규 0). AS-IS 번호 임의 재사용 금지(#114).
export const LBL = {
  MONTH: 'LBL00066',
  DIVISION: 'LBL00001',
  PLANT: 'LBL00030',
  LONG_TERM_TYPE: 'LBL00067',
  SEARCH: 'LBL00112',
  EDIT: 'LBL00414', // Edit 버튼 라벨 — DB 실측(SCM_ADM_MSG_M LBL/EN='Edit'). LBL00108 은 'Delete' 라 오사용 금지.
} as const;

// i18n MSG (Hook #114 — AS-IS MSG_ID 그대로 쓰지 않고 문구로 TO-BE 코드 역조회).
//   REQUIRE_DIVISION: TO-BE 등록됨(MSG00097 = 'Please select Division.') — SetDivisionAuthCheck(R8).
//   EXCEL_NO_DATA   : 조회 0건 엑셀 안내. AS-IS MSG00100(SCP0084 는 "저장않고 열기" 확인)은 web
//                     다운로드 모델에 부적합 → TO-BE 등가 문구 MSG00719('No data have been
//                     retrieved.') 재사용(ending-inventory 선례).
export const MSG = {
  REQUIRE_DIVISION: 'MSG00097',
  EXCEL_NO_DATA: 'MSG00719',
} as const;

// 컬럼명 상수 — 편집토글/셀색/저장키에서 참조하는 binding(design 03 §1/§4.3).
export const COL = {
  MEMO: 'MEMO', // AS-IS 유일 편집 컬럼(EditButton 토글 후, cs:249)
  YYYYMM: 'YYYYMM',
  DIVISION_ID: 'DIVISION_ID',
  PLANT_DESCRIPTION: 'PLANT_DESCRIPTION',
  PLANT_ID: 'PLANT_ID',
  ITEM_UOM: 'ITEM_UOM', // FIXED_FLAG=Y 틀고정(메타 구동)
} as const;

// 저장 매칭키 6종 — AS-IS SaveData_Memo TVP WHERE 키(cs:411~420, design 03 §4.3).
//   MEMO 만 UPDATE, 이 6키로 행 매칭. 저장 payload 는 CRUD_TYPE I/M/D 행만 전송.
export const SAVE_KEY_COLUMNS: readonly string[] = [
  'YYYYMM_VAL',
  'PLANT_ID',
  'DIVISION_ID',
  'ITEM_ID',
  'CHARG',
  'DEVALUATION_AGE',
];

// 선두 그룹 컬럼 세로 병합(SmartColMerge, design 03 §3 W2/W5, cs:206·207·329). AS-IS SmartColMerge
//   는 인자 없이 호출되고 per-column 병합 정책은 FarPoint 스프레드 템플릿에 있어 .cs/designer/메타
//   에서 추출 불가(SCM_MST_SHEET_COLUMNS 에 merge 플래그 없음 — FIXED_FLAG 만) → 자매 화면
//   (ending-inventory)이 검증한 선두 식별 컬럼 집합을 그대로 적용한다(best-effort, grid-behavior-
//   parity §1.3 누적키 방식은 선두 연속 컬럼에만 유효). 한계는 __asis-mapping__.md 에 기록.
export const MERGE_COLUMNS: ReadonlySet<string> = new Set([
  COL.YYYYMM,
  COL.DIVISION_ID,
  COL.PLANT_DESCRIPTION,
  COL.PLANT_ID,
]);

// 엑셀 고정밀 치환쌍(화면 컬럼 → *_XLS 컬럼, design 03 §3.1 W9). 화면=저정밀 표시(VIS=Y) /
//   엑셀=고정밀(VIS=N). NSCM 공용 excelDownload 는 per-export 정밀도 스왑 훅이 없어 이번 회차엔
//   미구현(04 확인필요 — SP 미배포로 런타임 검증 불가). 상수는 후속 배선 시 참조용으로 남긴다.
export const EXCEL_XLS_PAIRS: readonly { screen: string; xls: string }[] = [
  { screen: 'LONG_TERM_STOCK_QTY', xls: 'LONG_TERM_STOCK_QTY_XLS' },
  { screen: 'LONG_TERM_STOCK_AMOUNT', xls: 'LONG_TERM_STOCK_AMOUNT_XLS' },
  { screen: 'UNIT_PRICE', xls: 'UNIT_PRICE_XLS' },
  { screen: 'AMOUNT', xls: 'AMOUNT_XLS' },
  { screen: 'UNIT_PRICE_KRW', xls: 'UNIT_PRICE_KRW_XLS' },
];

// 편집가능(MEMO) 셀 배경색 — hook #95 grid-cell-backcolor-standard(편집가능 Yellow).
export const MEMO_EDITABLE_BG = '#ffff00';
