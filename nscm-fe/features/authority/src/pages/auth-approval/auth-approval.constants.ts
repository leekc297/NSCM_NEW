// SYS0012 Auth Approval — 표준 constants
// 위치: features/authority/src/pages/auth-approval/ (auth-request 자매 화면)

export const MENU_ID = 'SYS0012' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  MAIN = 'main',
}

export enum RESPONSE_SET {
  OUTPUT = 'o_rc',
}

export enum APPROVAL_STATUS {
  ALL = 'ALL',
  REQUEST = 'REQUEST',
  APPROVED = 'APPROVED',
  REJECTED = 'REJECTED',
}
