// admin DB SCM_ADM_MNU_M 에 별도 popup MENU_ID 등재 없음 — DMF0043 의 sheet 재사용.
// AS-IS 의 RATE_POPUP SP (DMF0043_GET_CONTRIBUTE_RATE_POPUP(yyyy)) 가 실제로
// VERSION 데이터 (VER_SEQ/YYYY/VERSION_NM/VALID_YN/DESCRIPTION) 를 반환 — AS-IS 명칭 confusion.
// 그래서 data fetch sheet = 'ratePopup' (실제 데이터 source).
// column meta fetch sheet = 'versionPopup' (admin 메타의 VER_SEQ/.. 5 컬럼).
export const MODAL_VERSION = 'DMF0043' as const;
export type MODAL_VERSION = typeof MODAL_VERSION;

// data fetch sheet (BE PROC_M 매핑 — DMF0043_GET_CONTRIBUTE_RATE_POPUP(yyyy))
export const MODAL_SHEET_DATA = 'ratePopup' as const;
export type MODAL_SHEET_DATA = typeof MODAL_SHEET_DATA;

// column meta fetch sheet (admin SCM_MST_SHEET_COLUMNS 에 VER_SEQ/YYYY/... 5 컬럼 등재)
export const MODAL_SHEET_COLUMN_META = 'versionPopup' as const;
export type MODAL_SHEET_COLUMN_META = typeof MODAL_SHEET_COLUMN_META;

export const MODAL_SHEET_YEAR = 'yearPopup' as const;
export type MODAL_SHEET_YEAR = typeof MODAL_SHEET_YEAR;

export const MODAL_NAME = 'versionPopup';
