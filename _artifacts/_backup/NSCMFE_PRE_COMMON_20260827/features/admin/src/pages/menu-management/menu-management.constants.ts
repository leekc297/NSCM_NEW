export const MENU_ID = 'SYS0003' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEET_INDEX {
  LEVEL_ONE_MENU,
  LEVEL_TWO_MENU,
  LEVEL_THREE_MENU,
}

export enum SHEETS {
  LEVEL_ONE_MENU = 'levelOneMenu',
  LEVEL_TWO_MENU = 'levelTwoMenu',
  LEVEL_THREE_MENU = 'levelThreeMenu',
}

export enum RESPONSE_SET {
  OUTPUT = 'o_rc',
}
