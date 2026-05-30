export const MENU_ID = 'DMF0007' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  CUSTOMER_FCST = 'customerFcst',
  CUSTOMER_PSI = 'customerPSI',
}

export enum SHEET_INDEX {
  CUSTOMER_FCST,
  CUSTOMER_PSI,
}

export enum RESPONSE_SET {
  CUSTOMER_FCST = 'o_rc1',
  CUSTOMER_PSI = 'o_rc1',
}
