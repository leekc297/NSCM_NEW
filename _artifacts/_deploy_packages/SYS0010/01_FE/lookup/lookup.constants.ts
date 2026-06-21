export const MENU_ID = 'SYS0010' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  LOOKUP_MASTER = 'lookupMaster',
  LOOKUP_DETAIL = 'lookupDetail',
}

export enum RESPONSE_SET {
  SAVE = 'o_rc',
}

export type ActiveGrid = 'main' | 'sub';
