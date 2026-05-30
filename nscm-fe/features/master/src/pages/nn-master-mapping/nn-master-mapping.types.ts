/**
 * DMF0072 NNMasterMapping — 타입 정의 (22 cols)
 */
import type { DataTypeCode } from './nn-master-mapping.constants';

/** AS-IS DefColumns 22 컬럼 (hidden 1 포함) */
export interface NNMasterMappingRow {
  EDIT_FLAG?: string;
  DATA_TYPE_CODE?: DataTypeCode;
  DIVISION_ID?: string;
  COMPANY_ID?: string;
  SOLDTO_CODE?: string;
  SHIPTO_CODE?: string;
  UNLOADING_POINT?: string; // ≤35
  CUSTOMER_PLANT?: string;  // ≤10
  CUSTOMER_ITEM_ID?: string; // ≤50
  END_CUSTOMER?: string;
  SCM_SITE_ID?: string;
  PROJECT_CODE?: string;
  FCST_TYPE?: string;
  INCOTERMS?: string;
  DOM_EXP?: string;
  ITEM_ID?: string;
  MAPPING_ITEM_ID?: string;
  MAPPING_ITEM_ID_ORIGINAL?: string;  // hidden UPDATE 키
  VALID_START_DATE?: string;          // yyyymmdd
  VALID_END_DATE?: string;            // yyyymmdd
  ACTIVE_YN?: 'Y' | 'N';
  LAST_UPDATED_BY?: string;
  LAST_UPDATE_DATE?: string;
  CRUD_TYPE?: 'C' | 'U' | 'D';
  [key: string]: unknown;
}

export interface NNMasterMappingSearchParams {
  divisionId: string;            // 필수 MSG00097
  teamIds: string[];
  endCustomers: string[];
  salesSiteIds: string[];
  projectCode: string;
  modelType: string;
  dataTypeCode: DataTypeCode;
}
