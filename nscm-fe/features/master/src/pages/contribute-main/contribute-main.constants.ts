export const MENU_ID = 'DMF0043' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  MAIN = 'main',
  MAIN_TITLE = 'mainTitle',
  VERSION = 'version',
  YEAR_POPUP = 'yearPopup',
  RATE_POPUP = 'ratePopup',
  VERSION_POPUP = 'versionPopup',
  SALES_LIST = 'salesList',
  SALES_LIST_TITLE = 'salesListTitle',
}

// const object — enum 대체 (NSCM 단일 cursor 표준 'o_rc1' 다수 중복 허용)
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  MAIN_TITLE: 'o_rc1',
  VERSION: 'o_rc1',
  YEAR_POPUP: 'o_rc1',
  RATE_POPUP: 'o_rc1',
  VERSION_POPUP: 'o_rc1',
  SALES_LIST: 'p_cursor_main',
  SALES_LIST_TITLE: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// ⭐ 2026-06-17 — DMF0004 reference 패턴 (SHEET_COLUMNS 메타 sheet name):
//   SCM_MST_SHEET_COLUMNS.SHEET_NAME 의 실제 PascalCase 값 (SP body 가 hardcode 참조).
//   SHEETS (= MNU_BTN_MPG_M.SHT_NM + callProc 용 camelCase) 와 표기 다름.
//   fetchStaticColumns 가 META_SHEETS 사용 → SP body 변경 회피 + admin SYS0004 메타 동기화 호환.
//   사용자 진단 SQL (2026-06-17) 으로 확인: ContributeMain (8) / ContributeRate (5) / ContributeSalesList (10).
export const META_SHEETS = {
  MAIN: 'ContributeMain',
  RATE_POPUP: 'ContributeRate',
  SALES_LIST: 'ContributeSalesList',
} as const;

// AS-IS .cs 의 5 Validation MSG codes
export const VALIDATION_MSG = {
  RATIO_OUT_OF_RANGE: 'MSG00303',   // 입력 데이터 100% 초과/미만 차단 (ValidChk)
  REQUIRED_DIVISION: 'MSG00308',    // 필수값 — 구분값 입력 (ValidChk2)
  SAVE_CONFIRM: 'MSG00004',         // 저장 전 확인
  VERSION_REQUIRED: 'MSG00283',     // FindData — 버전 미선택
  NOT_LOCK: 'MSG00266',             // chkYear — sheet 잠금 상태 확인
} as const;
