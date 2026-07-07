export const MENU_ID = 'DMF0043' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  MAIN = 'ContributeMain',
  MAIN_TITLE = 'mainTitle',
  VERSION = 'version',
  YEAR_POPUP = 'yearPopup',
  RATE_POPUP = 'ratePopup',
  VERSION_POPUP = 'versionPopup',
  SALES_LIST = 'salesList',
  SALES_LIST_TITLE = 'salesListTitle',
}

export enum SHEET_INDEX {
  MAIN,
  MAIN_TITLE,
  VERSION,
  YEAR_POPUP,
  RATE_POPUP,
  VERSION_POPUP,
  SALES_LIST,
  SALES_LIST_TITLE,
}

// const object — enum 대체 (NSCM 단일 cursor 표준 'o_rc1' 다수 중복 허용)
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  MAIN_TITLE: 'o_rc1',
  VERSION: 'o_rc1',
  YEAR_POPUP: 'o_rc1',
  RATE_POPUP: 'o_rc1',
  VERSION_POPUP: 'o_rc1',
  SALES_LIST: 'o_rc1',
  SALES_LIST_TITLE: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// AS-IS .cs 의 5 Validation MSG codes
export const VALIDATION_MSG = {
  RATIO_OUT_OF_RANGE: 'MSG00303', // 입력 데이터 100% 초과/미만 차단 (ValidChk)
  REQUIRED_DIVISION: 'MSG00308', // 필수값 — 구분값 입력 (ValidChk2)
  SAVE_CONFIRM: 'MSG00001', // 저장 전 확인
  VERSION_REQUIRED: 'MSG00283', // FindData — 버전 미선택
  NOT_LOCK: 'MSG00266', // chkYear — sheet 잠금 상태 확인
} as const;
