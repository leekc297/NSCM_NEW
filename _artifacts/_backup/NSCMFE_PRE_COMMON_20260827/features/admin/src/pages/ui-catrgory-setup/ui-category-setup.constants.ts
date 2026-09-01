export const MENU_ID = 'SYS0004' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  COLUMN = 'column',
  MEASURE = 'measure',
}

export enum SHEET_INDEX {
  COLUMN,
  MEASURE,
}

export enum RESPONSE_SET {
  COLUMN = 'column',
  MEASURE = 'measure',
}
