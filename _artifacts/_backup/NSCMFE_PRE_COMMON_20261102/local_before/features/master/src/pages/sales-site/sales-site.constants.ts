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

/**
 * Team / End Customer 조회조건이 살아 있는 division. AS-IS 원문 술어 그대로다
 * (`sDivision.Substring(0, 2) == "81" || sDivision == "82"`).
 *
 * 이 술어 하나가 두 가지를 동시에 정한다 - End Customer 칸의 활성 여부(lblEndCustomer.Enabled)와
 * Sales Site 콤보 원천 선택. AS-IS 가 같은 if 블록에서 둘 다 처리하므로 나누지 않는다.
 * 자세한 원천 규칙은 utils/sales-site.salesSiteCombo 참조.
 */
export const hasEndCustomer = (divisionId: string) =>
  divisionId.startsWith('81') || divisionId === '82';
