// SCM0005 Dynamic Query — 신규 SYS0013 (Admin_Menu 부모)

export const MENU_ID = 'SYS0013' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  MAIN = 'main',
  RESULT = 'result',
  COLUMNS = 'columns',
  PARAMETERS = 'parameters',
  HISTORY = 'history',
}

export enum RESPONSE_SET {
  OUTPUT = 'o_rc1',
}
