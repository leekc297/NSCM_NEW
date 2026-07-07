export const MENU_ID = 'SYS0014' as const;
export type MENU_ID = typeof MENU_ID;

// ⭐ SHEET_NAME = AS-IS GroupUserInfo.cs SpdSheet 원본 그대로 (sheet-name-asis-preserve-mandatory)
//   AS-IS: GroupInfo / UserInfo / Division (Plant/Customer 는 AS-IS 에서 //주석 비활성)
export enum SHEETS {
  MAIN = 'GroupInfo',
  USER_INFO = 'UserInfo',
  DIVISION = 'Division',
}

export enum RESPONSE_SET {
  OUTPUT = 'o_rc1',
}

export enum UNIT_TP_CD {
  DIVISION = 'D',
}
