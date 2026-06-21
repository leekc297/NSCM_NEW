export const MENU_ID = 'SYS0011' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  AUTHORITY = 'authority',
  DIVISION = 'division',
  MY_AUTHORITY_LIST = 'myAuthorityList',
  USER_INFO = 'userInfo',
}

export enum SHEET_INDEX {
  AUTHORITY,
  DIVISION,
  MY_AUTHORITY_LIST,
  USER_INFO,
}

export enum RESPONSE_SET {
  OUTPUT = 'o_rc',
}

export enum ACTIVE_FLAG {
  ADD = 'I',
  REQUEST = 'M',
  DELETE = 'D',
}

export enum APPROVAL_RESULT {
  REQUESTING = 'REQUESTING',
  REJECT = 'REJECT',
}
