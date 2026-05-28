export const MENU_ID = 'DMF0007' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  CUSTOMER_FCST = 'customerFcst',
  CUSTOMER_PSI = 'customerPSI',
  CUSTOMER_PSI_PIVOT = 'customerPsiPivot',
}

export enum SHEET_INDEX {
  CUSTOMER_FCST,
  CUSTOMER_PSI,
  CUSTOMER_PSI_PIVOT,
}

export enum RESPONSE_SET {
  CUSTOMER_FCST = 'o_rc1',
  CUSTOMER_PSI = 'o_rc1',
  CUSTOMER_PSI_PIVOT = 'o_rc1',
}
