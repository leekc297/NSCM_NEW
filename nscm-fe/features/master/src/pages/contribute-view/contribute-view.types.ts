/**
 * DMF0043_01 Contribute_View — 타입 정의
 */

/** 메인 그리드 행 — AS-IS spdMain ContributeSalesList sheet */
export interface ContributeViewRow {
  YYYY?: string;
  VERSION_ID?: string;
  CUSTOMER_GROUP?: string;
  PRODUCT_TYPE?: string;
  BIZ_TYPE?: string;
  LARGE_LABEL?: string;
  SMALL_LABEL?: string;
  SUM_VALUE?: number;
  [key: string]: unknown;
}

/** 조회조건 — AS-IS 9 controls (usrYear/txtVersion/usrCust/usrType/usrBiz/chkM/usrChk/btnSPVer/btnColumn) */
export interface ContributeViewSearchParams {
  yearId: string;
  versionId: string;
  customerIds: string[];
  productType: string;
  bizType: string;
  isCheckM: boolean;
  isUsrCheck: boolean;
}

/** Version popup 행 (DMF0043_VersionPopup) */
export interface ContributeVersionRow {
  VER_SEQ?: string;
  YYYY?: string;
  VERSION_NM?: string;
  VALID_YN?: 'Y' | 'N';
  DESCRIPTION?: string;
}
