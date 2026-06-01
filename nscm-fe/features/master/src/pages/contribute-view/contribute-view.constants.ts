export const MENU_ID = 'DMF0043_01' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  MAIN = 'main',
  MAIN_TITLE = 'mainTitle',
  VERSION = 'version',
  RATE_POPUP = 'ratePopup',
  VERSION_POPUP = 'versionPopup',
}

export enum RESPONSE_SET {
  MAIN = 'p_cursor_main',
  MAIN_TITLE = 'o_rc1',
  VERSION = 'o_rc1',
  RATE_POPUP = 'o_rc1',
  VERSION_POPUP = 'o_rc1',
}
