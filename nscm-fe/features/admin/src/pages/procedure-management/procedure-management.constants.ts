export const MENU_ID = 'SYS0005' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  PROCEDURE_LIST = 'procList',
  PROCEDURE_INFO = 'procInfo',
}

export enum SHEET_INDEX {
  PROCEDURE_LIST,
  PROCEDURE_INFO,
}
