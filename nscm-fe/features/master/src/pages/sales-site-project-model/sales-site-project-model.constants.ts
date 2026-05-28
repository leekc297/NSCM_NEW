export const MENU_ID = 'DMF0005' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  PRODUCTION = 'production',
  PURCHASE = 'purchase',
}

export enum RESPONSE_SET {
  PRODUCTION = 'production',
  PURCHASE = 'purchase',
}

export enum SHEET_INDEX {
  PRODUCTION,
  PURCHASE,
}
