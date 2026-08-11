// admin DB SCM_ADM_MNU_M 에 별도 popup MENU_ID 등재 없음 — DMF0043 의 sheet 'ratePopup' 재사용.
// (regionModal/customerModal 등은 별도 COMxxxx MENU_ID 보유 — 표준이나 본 화면 메타 작업 미발생 시 본 형태 적용)
export const MODAL_RATE = 'DMF0043' as const;
export type MODAL_RATE = typeof MODAL_RATE;

export const MODAL_SHEET_RATE = 'ratePopup' as const;
export type MODAL_SHEET_RATE = typeof MODAL_SHEET_RATE;

export const MODAL_NAME = 'ratePopup';
