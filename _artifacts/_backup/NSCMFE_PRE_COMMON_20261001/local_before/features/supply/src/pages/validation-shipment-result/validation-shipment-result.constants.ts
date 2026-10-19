// AS-IS: GSCM/06.UIL/GSCM.SCM.Validation.UIL/SCM0014_ValidationShipmentResult.cs
//   화면 성격: 읽기전용 조회(Intransit Inventory). Find(Search) + Excel 실동작 / Edit=읽기전용 안내(미노출).
//   저장/삽입/삭제 없음, 전 컬럼 Lock, PIVOT/셀콤보/병합 없음.
//   설계 근거: .atlas/gscm-design/SCM0014/design/00_checklist.md ~ 03_grid-columns.md
export const MENU_ID = 'SCM0014' as const;
export type MENU_ID = typeof MENU_ID;

// 단일 그리드 — 시트 1개(main). GET SP 라우팅 키(BTN_MPG.SHT_NM) = 'main'.
export enum SHEETS {
  MAIN = 'main', // 조회 — SCM0014_GET_VALIDATION_SHIPMENT_RESULT (8-IN)
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = { MAIN: 'o_rc1' } as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// UI Category Setup(admin) SHEET_NAME — AS-IS 원본명 그대로(DB 실측: 오타 'Rsult' 보존).
//   컬럼 메타(SCM_MST_SHEET_COLUMNS) fetch 는 이 값으로 조회한다(VALID_YN='Y' 23행). SHEETS value 와 분리.
export const ADMIN_SHEET_NAME: Record<SHEETS, string> = {
  [SHEETS.MAIN]: 'Validation Shipment Rsult',
};

// 조회조건 콤보 ID (SCM_ADM_CMBO_SQL_M 실측 PASS — design 02 §2). 이름 유사 재사용 아님,
//   의미 5층(CODE+권한필터+EE제외 / lookupType 반환 CODE/NAME) 일치 확인됨(design 02 §2, goal.md ④).
export const COMBO = {
  // 단일선택. EE(전극) 제외 + user-group unit-auth 권한필터 SQL 내장(@sesUserId/@mnuId 세션 자동).
  //   이름만 비슷한 Division/Division_SCP 재사용 금지(후보 범위 다름 — design 02 §2 콤보1).
  DIVISION: 'MyDivision',
  // 범용 lookup 디스패처 — @lookupType='SHIPMENT_RESULT_TYPE'. 후보 I/C/B(VALID_YN='Y' 3건, ALL 없음).
  RESULT_TYPE: 'LookupCommon',
} as const;

// Result Type lookup 타입 — SCM_ADM_LOOKUP_MASTER_DETAIL(SHIPMENT_RESULT_TYPE). VALID='Y' I/C/B.
export const RESULT_TYPE_LOOKUP_TYPE = 'SHIPMENT_RESULT_TYPE';

// i18n (Hook #114 — AS-IS MSG_ID 그대로 쓰지 않고 문구로 TO-BE 코드 역조회).
//   REQUIRE_DIVISION: TO-BE 등록됨(MSG00097 = 'Please select Division.') — R1 무권한 게이트.
//   EXCEL_NO_DATA   : TO-BE 등가 문구 MSG00719('No data have been retrieved.') 재사용(자매 SCP0085 동일).
export const MSG = {
  REQUIRE_DIVISION: 'MSG00097',
  EXCEL_NO_DATA: 'MSG00719',
} as const;

// 조회조건 라벨(SCM_ADM_MSG_M 실측 — design 02 §4.5). 존재 6 / Result Date 는 결합 LBL 미존재로 영문 fallback.
export const LBL = {
  DIVISION: 'LBL00641', // Division
  PLANT_SITE: 'LBL00005', // Plant Site
  SALES_SITE: 'LBL00011', // Sales Site
  PROJECT: 'LBL00617', // Project
  MODEL: 'LBL00669', // Model
  RESULT_TYPE: 'LBL01109', // Result Type
  SEARCH: 'LBL00112', // Search
  // Result Date: 결합 LBL 미존재(부분 LBL00645 Result / LBL00069 Date 만 존재) → 신규 채번 대기.
  //   등록 전까지 영문 defaultValue fallback(design 02 §4.5 확인필요 #4). 임의 채번 금지(설계 activity 범위 밖).
} as const;
export const RESULT_DATE_FALLBACK = 'Result Date';
