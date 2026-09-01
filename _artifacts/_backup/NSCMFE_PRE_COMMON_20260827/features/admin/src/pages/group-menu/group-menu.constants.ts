export const MENU_ID = 'SYS0008' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEET_INDEX {
  GROUP,
  MENU,
  BUTTON,
}

export enum SHEETS {
  GROUP = 'group',
  MENU = 'menu',
  BUTTON = 'button',
}

export enum RESPONSE_SET {
  OUTPUT = 'o_rc',
}
