import type { BUCKET_TYPE } from './customer-fcst-upload.constant';

// 조회조건 — 기존 디자인(Form 레이아웃) 유지. 멀티 콤보 값은 CustomDropdown 콤마 문자열.
//   period(단일 문자열) → startYyyymmdd/endYyyymmdd 분리 (PR_GET_DAY_RANGE 기본값 + DatePicker 바인딩).
export interface SearchParamProps {
  divisionId: string;
  team: string;
  endCustomer: string;
  salesSite: string;
  plantSite: string;
  project: string;
  modelNickname: string;
  customsHandbook: string;
  startYyyymmdd: string;
  endYyyymmdd: string;
  bucket: BUCKET_TYPE;
}

// GET o_rc1 — 식별 13 + EDIT_FLAG/EDIT_YN + 동적 D_ 기간 컬럼 (스모크 실측 2026-07-04)
export interface CustomerFcstUploadRow {
  DIVISION_ID: string;
  SCM_SITE_ID: string;
  PLANT_SITE_ID: string;
  CUSTOMER_PROJECT_CODE: string;
  CUSTOMER_MODEL: string;
  INCOTERMS: string;
  FCST_TYPE: string;
  DOM_EXP: string;
  MEASURE_GROUP: string;
  MEASURE: string;
  UPLOAD_UOM: string;
  PROJECT_CODE: string;
  ITEM_ID: string;
  // 'Y' = 편집 가능 행 (AS-IS EditButton — 'Y' 행만 기간 셀 편집, 그 외 전행 잠금)
  EDIT_FLAG: string;
  EDIT_YN: string;
  [key: string]: string | number;
}

// SPREAD_TITLE o_rc1 — 전 버킷 D_ 접두 (WEEKLY=주 시작일 / MONTHLY=월 시작일). 스모크 실측:
//   COLUMN_NAME='D_20260701', COLUMN_LABEL='20260701', SMALL_LABEL_NAME='W27'|'SAT' 등, EDIT_YN='Y'
export interface SpreadTitleRow {
  COLUMN_NAME: string;
  COLUMN_LABEL: string;
  SMALL_LABEL_NAME: string;
  EDIT_YN: string;
  [key: string]: string | number;
}

// SetSaveData 1:1 — 변경 D_ 셀 1건 = 1 save entry (dedup 키 = 식별 10 + yyyymmdd)
export interface SaveEntry {
  divisionId: string;
  scmSiteId: string;
  customerProjectCode: string;
  customerModel: string;
  incoterms: string;
  fcstType: string;
  domExp: string;
  measureGroup: string;
  measure: string;
  plantSiteId: string;
  uploadUom: string;
  projectCode: string;
  itemId: string;
  yyyymmdd: string;
  qty: string;
}
