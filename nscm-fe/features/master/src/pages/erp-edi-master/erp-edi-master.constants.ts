export const MENU_ID = 'DMF0008' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  SUMMARY = 'summary',
  REPAIR = 'repair',
  SITE = 'site',
  PROJECT = 'project',
}

export enum RESPONSE_SET {
  SUMMARY = 'o_rc1',
  REPAIR = 'o_rc1',
  SITE = 'O_RESULT_CURSOR',
  PROJECT = 'o_rc1',
}
