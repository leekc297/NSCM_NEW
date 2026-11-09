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
//   2026-10-08 정정: AS-IS 번호 MSG00303/MSG00308 은 TO-BE DB(SCM_ADM_MSG_M)에 미등록이라 ID 가 그대로 노출되거나
//   fallback 만 보였다. 같은 문구가 등록된 TO-BE 코드로 바꾼다 (개발 DB 실측 2026-10-08, MSG-04 문구 대조).
//   저장 전 두 검증은 모두 화면(utils/validators.ts)에서 하며 저장 SP 는 이 검사를 하지 않는다.
export const VALIDATION_MSG = {
  RATIO_OUT_OF_RANGE: 'MSG01306', // "입력한 데이터가 100을 초과하거나 미만입니다." (ValidChk — 기간별 법인 합계 ≠ 100)
  REQUIRED_DIVISION: 'MSG01310', // "구분값을 입력해 주세요." (ValidChk2 — 기여율이 있는 기간의 구분(RBU_0999) 칸 공란)
  SAVE_CONFIRM: 'MSG00001', // 저장 전 확인
  VERSION_REQUIRED: 'MSG00283', // FindData — 버전 미선택
  NOT_LOCK: 'MSG00266', // chkYear — sheet 잠금 상태 확인
} as const;

// 구분(RBU_0999) 컬럼 입력 제한 안내 — AS-IS 코드에는 없던 TO-BE 전용 메시지.
//   숫자가 섞인 입력을 조용히 버리면 "데이터가 사라졌다" 로 보이므로 반드시 사유를 알린다.
export const DIVISION_TEXT_ONLY_MSG = {
  code: 'MSG_DIVISION_TEXT_ONLY',
  fallback: '구분 컬럼에는 숫자를 입력할 수 없습니다. 문자만 입력해 주세요.',
} as const;
