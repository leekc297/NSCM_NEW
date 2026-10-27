export const MENU_ID = 'SCM0019' as const;
export type MENU_ID = typeof MENU_ID;

// 단일 시트 "Main" (design 03 §1 — SCM_MST_SHEET_COLUMNS PROGRAM_ID='SCM0019' 5컬럼, sheetNm='Main').
export enum SHEETS {
  MAIN = 'main',
}

// GET 단일 커서 (design goal §1 RESPONSE_SET={MAIN:'o_rc1'}).
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin SCM_MST_SHEET_COLUMNS SHEET_NAME — 컬럼 메타 조회 스코프 키 (DB 실측 'Main').
export const ADMIN_SHEET_NAME: Record<SHEETS, string> = {
  [SHEETS.MAIN]: 'Main',
};

// 조회조건 Division 콤보 (design 02 §2.1 — TO-BE Oracle 실측 SQL_ID, 권한필터·@mnuId, EE 포함).
//   공통 MyDivision(EE 제외) 과 달리 EE(전극) division 을 포함한다(InEE) — 클라 EE 제외 필터 없음.
//   이름 유사 콤보(MyDivision/MyDivisionInEE/_FP/Out40_SCP) 재사용 금지(convert-core §2.6).
// Period 기본값 프리셋 — 이번 ISO 주 시작 ~ 약 4주 후(design 02 §2.2, @TimeZone BE 세션 주입).
export const COMBO = {
  DIVISION: 'MyDivisionInEE_SCP',
  PERIOD_DEFAULT: 'PERIOD_DEFAULT',
} as const;

// 라벨 — SCM_ADM_MSG_M 실측(design 02 §4.5, 신규 등록 불요).
export const LBL = {
  DIVISION: 'LBL00001', // Div
  PERIOD: 'LBL00013', // Period
  SEARCH: 'LBL00112', // Search(F5)
} as const;

// 메시지 — TO-BE 문구 역조회로 확정(Hook #114, design 01 §5 / 03 §5). AS-IS 번호 직사용 금지.
//   MSG00672 "{0} data saved."(저장 성공 건수) — AS-IS MSG00004 는 TO-BE 에서 "No changes to save" 라 미사용.
//   MSG00006 "Failed to save."(TO-BE 의미 일치) / MSG00097 "Please select Division."(R1 무권한) /
//   MSG00013 "Please enter the required fields."(Period 필수 R6).
export const MSG = {
  SAVE_SUCCESS: 'MSG00672',
  SAVE_FAIL: 'MSG00006',
  REQUIRE_DIVISION: 'MSG00097',
  REQUIRE_FIELD: 'MSG00013',
} as const;

// 버튼 코드 — 05_register.sql 의 SCM_ADM_MNU_BTN_MPG_M 과 1:1. Insert/Delete 는 AS-IS NO-OP
//   (버튼 노출·무동작) 이지만 공용 SubTitle 기본 addRow/removeRow 차단 위해 메타 등록(자매 SCP0121 미러).
//   EDIT 는 권한축(canEdit=hasButton('EDIT')) — AS-IS 모드토글 미이식(convert-core §2.4), API 없음.
export const BTN = {
  SEARCH: 'SEARCH',
  SAVE: 'SAVE',
  INSERT: 'INSERT',
  DELETE: 'DELETE',
  EDIT: 'EDIT',
} as const;
