export const MENU_ID = 'SYS0014' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  MAIN = 'main',
  USER_INFO = 'userInfo',
  DIVISION = 'division',
  PLANT = 'plant',
  CUSTOMER = 'customer',
}

export enum RESPONSE_SET {
  OUTPUT = 'o_rc1',
}

export enum UNIT_TP_CD {
  DIVISION = 'D',
  PLANT = 'P',
  CUSTOMER = 'C',
}
