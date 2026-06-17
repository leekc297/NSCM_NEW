// AS-IS .cs L107~111 SpdSheet — 4 sheet 매핑

// [1단] SUMMARY — DMF0008_GET_EDI_MST_SUMMARY
export interface SummaryRow {
  DIVISION_ID?: string;
  EDI_SENDER_NAME?: string;
  ERP_MASTER_DATA?: string;
  GSCM_MASTER_DATA?: string;
  ERP_SOLDTO?: string;
  ERP_SHIPTO?: string;
  ERP_ITEM_ID?: string;
  GSCM_SALES_SITE_ID?: string;
  [k: string]: string | number | undefined;
}

// [2단] REPAIR — DMF0008_GET_EDI_MST_REPAIR
// AS-IS .cs L861: TotalCount = ds.Tables[0].Compute("SUM(CNT)", "")
export interface RepairRow {
  DIVISION_ID?: string;
  EDI_SENDER_NAME?: string;
  CNT?: number;
  // AS-IS .cs L876 의 verification columns
  GSCM_SALES_SITE?: string;
  ACTIVE_SS?: string;
  GSCM_SSPM?: string;
  GSCM_SSPM_INCOTERMS?: string;
  ACTIVE_SSPM?: string;
  GSCM_PROJECT?: string;
  GSCM_PLANT?: string;
  [k: string]: string | number | undefined;
}

// [3단 TAB1] SALES_SITE — DMF0008_GET_SALES_SITE
export interface SalesSiteRow {
  DIVISION_ID?: string;
  SCM_SITE_ID?: string;
  SSCM_SITE_ID?: string;
  REP_SOLDTO_CODE?: string;
  REP_SHIPTO_CODE?: string;
  SITE_VALID_YN?: string;
  CUSTOMER_VALID_YN?: string;
  SOLDTO_CUSTOMER?: string;
  END_CUSTOMER?: string;
  [k: string]: string | number | undefined;
}

// [3단 TAB2] SSPM — DMF0008_GET_SALES_SITE_PROJECT_MODEL
export interface SspmRow {
  DIVISION_ID?: string;
  SCM_SITE_ID?: string;
  ITEM_ID?: string;
  ITEM_NAME?: string;
  VALID_YN?: string;
  EDIT_FLAG?: string;
  [k: string]: string | number | undefined;
}

// AS-IS Designer.cs L57/L58 + .cs L729~745
export interface SearchCondition {
  fromYyyymmdd: string;
  toYyyymmdd: string;
  divisionId: string;
  senderName: string;     // REPAIR 사용
  flag: string;           // REPAIR 사용
  // SSPM 호출용 (메인 row 선택 시 설정)
  selectedItemId: string;
  selectedScmSiteId: string;
  // SALES_SITE 호출용 (메인 row 선택 시 설정)
  selectedSoldTo: string;
  selectedShipTo: string;
}
