export const MENU_ID = 'DMF0043_01' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  MAIN = 'main',
  MAIN_TITLE = 'mainTitle',
  VERSION = 'version',
  RATE_POPUP = 'ratePopup',
  VERSION_POPUP = 'versionPopup',
  TITLE_SET = 'titleSet',           // AS-IS DM0002_TitleSetForm_Popup — DMF0002_GET_TITLESET_POPUP
}

// const object — enum 대체 (NSCM 단일 cursor 표준 'o_rc1' 다수 중복 허용)
export const RESPONSE_SET = {
  MAIN: 'p_cursor_main',
  MAIN_TITLE: 'o_rc1',
  VERSION: 'o_rc1',
  RATE_POPUP: 'o_rc1',
  VERSION_POPUP: 'o_rc1',
  TITLE_SET: 'o_cursor',           // P_DMF0002_GET_TITLESET_POPUP 의 OUT cursor
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// AS-IS DMF0043_Contribute_View.cs 의 Validation MSG codes (.cs L287, L335)
export const VALIDATION_MSG = {
  VERSION_REQUIRED: 'MSG00283',   // FindData — Version 미선택 (.cs L287)
  NO_RESULT: 'MSG00307',          // FindData — 조회 결과 없음 (.cs L335)
} as const;

// AS-IS .cs L234: siMain.Freeze(0, siMain.GetColumnIndex(DefColumns.EDIT_FLAG))
// 좌측 고정 컬럼 갯수 (룰 12 §11.5 — frozenColumns=BASE_COLUMN_COUNT)
// 사용자 요구 (2026-06-01): 년월(YYYYMM)부터 Biz(DM_BIZ_TYPE)까지 고정 = 9 컬럼
// SP DMF0043_GET_SALES_LIST_SPREAD_TITLE 결과의 첫 9개 (SHEET_COLUMNS DEFAULT_FLAG='Y' DISTINCT 9개)
export const BASE_COLUMN_COUNT = 9;
