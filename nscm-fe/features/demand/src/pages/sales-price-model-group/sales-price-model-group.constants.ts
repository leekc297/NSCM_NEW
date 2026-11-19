// DMF0083 Sales Price Model Group — 82(ESS) 사업부 Model Group 단위 판가 (신규 화면, AS-IS 없음)
//   설계서: 화면설계서_DMF0083_SalesPriceModelGroup_v8.xlsx
//   원천 화면: DMF0020 Sales Price (features/master/src/pages/sales-future-price) — 칸 · 저장 · 일괄입력 동작 참고
//   패키지: PKG_DMF0083 (SCM_ADM_PROC_M · API_M · MNU_BTN_MPG_M 등록 2026-11-05)
export const MENU_ID = 'DMF0083' as const;
export type MENU_ID = typeof MENU_ID;

// 라우팅 시트 = SCM_ADM_MNU_BTN_MPG_M.SHT_NM. 컬럼 메타 SHEET_NAME 과 개인화(SHEET_PRSL_YN) 시트명도 같은 값이다.
export enum SHEETS {
  MAIN = 'main',
  PRICE_BATCH = 'priceBatch',
  TITLE_SET = 'titleSet',
}

export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  PRICE_BATCH: 'o_rc1',
  TITLE_SET: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// SEARCH · SAVE 외에 main / priceBatch 시트에 등록된 버튼 코드 (SCM_ADM_MNU_BTN_MPG_M).
export const PROC_ACTION = {
  SPREAD_TITLE_DATE: 'SPREAD_TITLE_DATE',
  EXCHANGE_RATE: 'EXCHANGE_RATE',
} as const;

// 이 화면이 다루는 사업부. 설계서 [개요] B10 "82 고정"과 PKG_DMF0083 C_DIVISION_82 가 같은 값이다.
//   조회조건 Div 는 권한 사업부 중 이 값만 보여 주고, 없으면 빈 값으로 둔다(설계서 O10).
export const SCREEN_DIVISION = '82';

export enum BUCKET_TYPE {
  WEEKLY = 'W',
  MONTHLY = 'M',
}

// Measure 코드 — 화면 · 저장 규칙의 기준이 되는 값([Measure 규칙] 시트: LOC 입력 가능, KRW · USD 조회 전용).
//   행 목록은 Measure 메타(SCM_MST_SHEET_MEASURE DMF0083/main)에서 받고, 여기서는 규칙 판정에만 쓴다.
export const MEASURE_CODE = {
  LOC: 'LOC',
  KRW: 'KRW',
  USD: 'USD',
} as const;

// Price Master Representative 값 (콤보 YesOrNo).
export const PRC_RPSN = {
  YES: 'Y',
  NO: 'N',
} as const;

// Model Group = 모델 코드 앞 12자리 (설계서 [개요] C6 · table MDL_GR 주석).
//   공용 ITEM 팝업(COM0008)은 MDL_GR 을 돌려주지 않아 고른 Model 에서 잘라 쓴다.
//   개발 DB 실측(2026-11-06): SCM_MST_SITE_ITEM 82 사업부 49,268행 전부 MDL_GR = SUBSTR(ITEM_ID, 1, 12).
//   저장 시 PKG_DMF0083 2-11 검증이 Project · Sales Site 에 실제 있는 Model Group 인지 다시 본다.
export const MDL_GR_LENGTH = 12;

// 묶음 키 — PKG_DMF0083 저장 · 조회의 GROUP BY 7칸 (End Customer 는 참조 정보라 제외, 설계서 [개요] C78).
export const BUNDLE_KEY_COLS = [
  'DIVISION_ID',
  'PROJECT_CODE',
  'SCM_SITE_ID',
  'MDL_GR',
  'INCOTERMS',
  'FCST_TYPE',
  'CURRENCY',
] as const;

// 신규 행에서 사용자가 직접 입력할 수 없는 자동 입력 칸 (설계서 [개요] R45 · R46).
//   메타 입력 구분은 IO 지만 Team 은 Model Group 팝업, End Customer 는 Sales Site 에서 채운다.
export const AUTO_MAPPED_COLUMNS = ['DEPT_ID', 'END_CUSTOMER'] as const;

// 셀 팝업 키 = 컬럼 메타 ATTRIBUTE1 (PROJECT_CODE='PROJECT', MDL_GR='ITEM').
export const MODAL_KEY = {
  PROJECT: 'PROJECT',
  ITEM: 'ITEM',
} as const;

// 상위 칸 값이 바뀌면 같은 신규 묶음에서 함께 비울 칸 (설계서 [개요] R47 · R48).
//   Sales Site 변경 = End Customer 재파생 + Project · Model Group · Team 무효.
//   Project 변경 = Model Group · Team 무효 (Project 팝업 콜백에서 처리).
export const GRID_CASCADE_CLEAR: Record<string, readonly string[]> = {
  SCM_SITE_ID: ['END_CUSTOMER', 'PROJECT_CODE', 'PROJECT_NAME', 'MDL_GR', 'DEPT_ID'],
  PROJECT_CODE: ['MDL_GR', 'DEPT_ID'],
};

// Sales Site → End Customer 자동 입력 원천 (DMF0020 신규 행과 같은 콤보).
export const SITE_EC_COMBO_ID = 'SiteEndCustomerMapDMF0082';

// 조회조건 콤보 — 전부 필터 방식(파라미터 없이 전량, 화면이 buildComboOptions 로 좁힘). 원천 DMF0020 과 같다.
export const SEARCH_COMBO = {
  division: 'FilterMyDivision',
  team: 'FilterTeambyDivision',
  endCustomer: 'FilterEndCustomerByDivision',
  salesSite: 'FilterSiteByEndCustomer',
} as const;

// Price Batch Input 팝업 Sales Site — 원천 DMF0020 팝업과 같은 재조회 콤보(설계서 popup-1 H25).
export const PRICE_BATCH_SITE_COMBO = 'SiteByEndCustomer';

// Price Batch Input 조회 · 저장 최대 구간 (설계서 popup-1 N28).
export const PRICE_BATCH_MAX_WEEKS = 52;

// Price Batch Input 팝업의 조회 쿼리 키(tabId) — 서버로 가지 않는 클라이언트 식별자, 다른 모달과 겹치지 않는 값(POP-03).
export const MODAL_PRICE_BATCH = 'DMF0083_PRICE_BATCH' as const;
export type MODAL_PRICE_BATCH = typeof MODAL_PRICE_BATCH;

// Exchange Rate 팝업의 조회 쿼리 키(tabId) — 메인 환율 조회(tabId = 탭)와 캐시를 나눈다(POP-03).
export const MODAL_EXCHANGE_RATE = 'DMF0083_EXCHANGE_RATE' as const;
export type MODAL_EXCHANGE_RATE = typeof MODAL_EXCHANGE_RATE;

// Exchange Rate 팝업 고정 칸 — 원천 DMF0020 팝업과 같은 칸 · 폭(Div 120 · Currency 70 · Unit 50).
//   컬럼 메타에 등록된 시트가 아니라(조회 전용 피벗 그리드) 화면 상수로 둔다. labelCode 가 없는 칸은 header 를 그대로 쓴다.
export const EXCHANGE_RATE_COLUMNS: ReadonlyArray<{
  key: string;
  header: string;
  labelCode?: string;
  width: number;
}> = [
  { key: 'DIVISION_ID', header: 'Div', labelCode: 'LBL00001', width: 120 },
  { key: 'CURRENCY', header: 'Currency', width: 70 },
  { key: 'UNIT_CURRENCY', header: 'Unit', labelCode: 'LBL00045', width: 50 },
];

// 컬럼 개인화(SCM_MST_TITLESET_USER) 조회 · 저장 키 — 조회 · 저장 · 진입 복원이 모두 같은 값을 써야 한다.
export const TITLESET_COLUMN_TYPE = 'C';

// 메시지 코드 — 원천 DMF0020 이 쓰는 기존 코드만 쓴다(신규 채번 없음, 사용자 결정 2026-11-06).
//   문구는 개발 DB SCM_ADM_MSG_M 에서 확인했다(2026-11-06).
//   예외: PRICE_EMPTY(MSG00328)는 DMF0020 코드가 아니다 — 판가대표 Y 인데 가격이 없을 때 MSG00013 으로는
//   원인을 알 수 없어 기존 메시지 중 3개 언어가 갖춰진 것을 골랐다(사용자 결정 2026-11-06).
export const MSG = {
  CONFIRM_SAVE: 'MSG00001', // 저장 하시겠습니까?
  NO_CHANGES: 'MSG00004', // 수정한 내용이 없습니다.
  REQUIRED_INPUT: 'MSG00013', // 필수 입력란을 입력해 주세요.
  REQUIRE_DIVISION: 'MSG00097', // Division 을 선택하세요.
  PERIOD_INVERTED: 'MSG00108', // 조회 기간이 잘못되었습니다 (시작일 > 종료일).
  BUSY: 'MSG00137', // 이전 작업이 아직 실행 중입니다. 잠시 후 다시 시도해주세요.
  MAX_PERIOD: 'MSG00172', // 최대 조회일은 From Date + {0} 입니다.
  INSERT_ONLY_BUCKET: 'MSG00227', // Insert 된 행이 있어 Bucket 을 변경할 수 없습니다.
  PRICE_EMPTY: 'MSG00328', // 판가 미입력 상태입니다. 판가 입력 후 진행해 주세요.
  MONDAY_ONLY: 'MSG00330', // 기간을 다시 선택하여 주십시오.(월요일)
  PAST_PERIOD: 'MSG00409', // 과거 구간은 일괄입력이 불가합니다. 현재/미래 구간으로 기간 설정해주세요.
  DUPLICATE_NEW: 'MSG00428', // 신규 입력 데이터 중 중복된 데이터가 있습니다.
  CURRENCY_EMPTY: 'MSG00447', // Currency를 입력하세요.
  // 기존 묶음 Currency 변경 범위 안내 — DMF0020 과 같은 문구(2026-11-12 프로시저가 "조회 기간 안만 변경"으로 바뀌어 LHS 지정).
  //   처음 인계 때의 MSG01499("이번 주 이후 전체 기간")는 쓰지 않는다.
  CURRENCY_CHANGE_SCOPE: 'MSG01429', // 화면에 조회된 기간의 데이터만 Currency가 변경됩니다. 기간을 확인하시고 …
  ONLY_NEW_DELETE: 'MSG00608', // 신규 입력 (Insert) 한 행만 삭제할 수 있습니다.
  SAVED: 'MSG00606', // 저장되었습니다.
  SAVE_FAIL: 'MSG00618', // 저장 중 오류가 발생했습니다.
  NO_DATA: 'MSG00719', // 조회된 데이터가 없습니다.
} as const;
