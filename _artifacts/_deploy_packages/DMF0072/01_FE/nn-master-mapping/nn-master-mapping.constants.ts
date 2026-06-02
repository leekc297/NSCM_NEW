export const MENU_ID = 'DMF0072' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS DMF0072_NNMasterMapping.cs / .Designer.cs:
//   - Main(L477):  DMF0072_GET_NNMASTER_MAPPING (7 IN + cursor)
//   - DataType(L200): GetLookupValues("DM_EDI_DATA_TYPE_CODE")
//   - Division(L154): Data.Common(Data.Type.MyDivision) — DMF0008_GET_MY_DIVISION_LIST 재사용
//   - Team(L159):     SetChangeControl("UserTeamByDivision", sDivision)
//   - EndCustomer(L165~178): div=40 → EndCustomerByDivision40 / 그 외 → EndCustomerByDivision
//   - SalesSite(L186): SetChangeControl("UserSiteByEndCustomer", divisions, endCustomer)
export enum SHEETS {
  MAIN = 'main',
  DATA_TYPE = 'dataType',
  DIVISION = 'division',
  TEAM = 'team',
  END_CUSTOMER = 'endCustomer',
  SALES_SITE = 'salesSite',
}

export enum RESPONSE_SET {
  MAIN = 'o_rc1',
  DATA_TYPE = 'o_rc1',
  DIVISION = 'o_rc1',
  TEAM = 'o_rc1',
  END_CUSTOMER = 'o_rc1',
  SALES_SITE = 'o_rc1',
}

// AS-IS .cs 의 main grid column 정의 (23 컬럼)
// merge=true: 사용자 요구 2026-06-02 — Data Type ~ MDM Code (ITEM_ID) 15개 컬럼 세로 머지 (As-Is .cs L515 `siMain.SmartColMerge()` 대응)
// As-Is DefColumnsLabel.ITEM_ID = "MDM_CODE" — Item ID 컬럼이 MDM Code 라벨로 표시되는 컬럼
export const MAIN_COLUMNS: ReadonlyArray<{ key: string; header: string; width?: number; merge?: boolean }> = [
  { key: 'DATA_TYPE_CODE', header: 'Data Type', width: 100, merge: true },
  { key: 'DIVISION_ID', header: 'Division', width: 80, merge: true },
  { key: 'COMPANY_ID', header: 'Company', width: 90, merge: true },
  { key: 'END_CUSTOMER', header: 'End Customer', width: 130, merge: true },
  { key: 'UNLOADING_POINT', header: 'Unloading Point', width: 130, merge: true },
  { key: 'CUSTOMER_PLANT', header: 'Customer Plant', width: 130, merge: true },
  { key: 'SOLDTO_CODE', header: 'SoldTo', width: 110, merge: true },
  { key: 'SHIPTO_CODE', header: 'ShipTo', width: 110, merge: true },
  { key: 'SCM_SITE_ID', header: 'SCM Site', width: 160, merge: true },
  { key: 'PROJECT_CODE', header: 'Project', width: 110, merge: true },
  { key: 'FCST_TYPE', header: 'FCST Type', width: 90, merge: true },
  { key: 'INCOTERMS', header: 'Incoterms', width: 90, merge: true },
  { key: 'DOM_EXP', header: 'Dom/Exp', width: 80, merge: true },
  { key: 'CUSTOMER_ITEM_ID', header: 'Customer Item', width: 140, merge: true },
  { key: 'ITEM_ID', header: 'MDM Code', width: 140, merge: true },
  { key: 'MAPPING_ITEM_ID', header: 'Mapping Item', width: 140 },
  { key: 'MAPPING_ITEM_ID_ORIGINAL', header: 'Mapping Item (Org)', width: 160 },
  { key: 'VALID_START_DATE', header: 'Valid Start', width: 110 },
  { key: 'VALID_END_DATE', header: 'Valid End', width: 110 },
  { key: 'ACTIVE_YN', header: 'Active', width: 70 },
  { key: 'LAST_UPDATE_DATE', header: 'Last Update', width: 140 },
  { key: 'LAST_UPDATED_BY', header: 'Updated By', width: 110 },
  { key: 'DC_LEVEL', header: 'DC Level', width: 90 },
];

// 빈 SP 결과 대응 fallback (lookup SP 호출 실패 시)
export const FALLBACK_ALL: ReadonlyArray<{ value: string; label: string }> = [
  { value: 'ALL', label: 'ALL' },
];
