export const MENU_ID = 'DMF0004' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  SITE = 'site',
  CUSTOMER = 'customer',
  LOCATION = 'location',
  BUCKET = 'bucket',
}

export enum RESPONSE_SET {
  SITE = 'salesSite',
  CUSTOMER = 'salesCustomer',
  LOCATION = 'salesLocation',
  BUCKET = 'salesBucket',
}

export enum SHEET_INDEX {
  SITE,
  CUSTOMER,
  LOCATION,
  BUCKET,
}
