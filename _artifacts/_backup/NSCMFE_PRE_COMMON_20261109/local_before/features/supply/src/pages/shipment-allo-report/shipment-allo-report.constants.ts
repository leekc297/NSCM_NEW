export const MENU_ID = 'SCP0055' as const;
export type MENU_ID = typeof MENU_ID;

// Main/Gap 탭이 동일 sheetNm 을 공유(design 03 §0 — sheetNm 1종). SHEETS 유니온은 convert-core §2.4 규약.
export const enum SHEETS {
  MAIN = 'main',
  NOTE = 'note',
}

export const enum TAB {
  MAIN = 'MAIN',
  GAP = 'GAP',
}

// OnShown 강제 고정값 4종(design 01 §2 #1-4) — 사용자가 바꿀 수 없음(disabled).
export const FIXED_SEARCH = {
  DIVISION_ID: '40',
  OPERATION_GROUP: 'A', // Cell
  BUCKET_TYPE: 'MONTHLY',
  CELL_TYPE_GR: 'C', // Cyl
} as const;

export const COMBO = {
  DIVISION: 'MyDivisionInEE_SCP',
  CELL_TYPE_GR: 'CellTypeGr_SCP',
  OPERATION_GROUP_LOOKUP: 'LookupCommon',
  FROM_SITE: 'AllPlantSiteDescription_SCP',
  OPERATION_GROUP: 'OperationGroup_SCP',
  OPERATION_GROUP_EE: 'OperationGroupEE_SCP',
  DATE_WEEKLY: 'DATE_WEEKLY',
  // cboBucketType — AS-IS `DM.DM0003_GET_BUCKET_TYPE_CODE`(파라미터 없음) 대응. TO-BE 기존 등록 SQL_ID
  // `BucketType`(LOOKUP_TYPE='BUCKET_TYPE_CODE', CODE/NAME 3건 DAILY/WEEKLY/MONTHLY)을 재사용 —
  // FIXED_SEARCH.BUCKET_TYPE='MONTHLY' 코드값이 그대로 존재함을 ora.py 실측으로 확인(신규 등록 불필요).
  BUCKET_TYPE: 'BucketType',
} as const;

export const LABEL = {
  DIVISION: 'LBL00001',
  OPERATION_GROUP: 'LBL00027',
  MODEL: 'LBL00669',
  NICK_NAME: 'LBL00767',
  TEAM: 'LBL00044',
  FROM_SITE: 'LBL00022',
  CELL_TYPE_GR: 'LBL00042',
  FCST_PEGGING: 'LBL01078',
  BUCKET: 'LBL00710',
  PLAN_DATE: 'LBL00039',
  GAP_DATE: 'LBL00065',
  PERIOD: 'LBL00013',
} as const;

export const MSG = {
  PERIOD_RANGE: 'MSG00344', // Period From > To
  PLAN_GAP_ORDER: 'MSG00345', // PlanDate < GapDate
  PLAN_GAP_EQUAL: 'MSG00348', // PlanDate = GapDate
  SAVE_COUNT: 'MSG00004', // 저장건수 안내
  EXCEL_CONFIRM: 'MSG00100', // Yes/No/Cancel 확인창
} as const;

// SUBTOTAL/GAP/비고 — admin 메타(SCM_MST_SHEET_COLUMNS) 밖 코드리터럴 칼럼(design 03 §1.2).
export const DERIVED_COLUMN = {
  SUBTOTAL: 'SUBTOTAL',
  GAP: 'GAP',
  NOTE: 'NOTE',
} as const;
