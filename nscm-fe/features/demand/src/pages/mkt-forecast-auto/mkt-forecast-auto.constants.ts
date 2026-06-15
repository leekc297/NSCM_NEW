export const MENU_ID = 'DMF0081' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS DMF0081_MktFcst_Auto.cs (6,386줄) — MKT FCST (AUTO)
//   - 6 PKG SP (메인 9IN+3OUT / PSI 5IN+2OUT / Detail Popup / Save Popup / Excel Upload / DDL Template)
//   - 3 Sheet (Mkt Fcst + PSI + Car Fcst — Multi-Sheet 변형)
//   - 30+ events / 50+ DefColumns / Validation 20+ / 측정 9 + 누적 18
//   - 1 신규 popup (CustDemandAnlDetail)
//   - 자매 reference: DMF0003_1_MktFcst (mkt_forecast 폴더)
//   - 분석서: Doc/_analysis/domain_DM/screens/DMF0081_MktFcst_Auto/ (8 MD, Phase A 작성)
export enum SHEETS {
  MAIN = 'main',                        // Mkt Fcst 메인
  PSI = 'psi',                          // PSI 서브시트
  CAR_FCST = 'carFcst',                 // Car Fcst — Excel Upload 시트
  DETAIL_POPUP = 'detailPopup',         // Cust Demand Anl Detail Popup
  DETAIL_POPUP_SAVE = 'detailPopupSave',
  CAR_FCST_EXCEL_UPLOAD = 'carFcstExcelUpload',
  CAR_FCST_DDL = 'carFcstDdl',          // DDL Template 다운로드
  SPREAD_TITLE = 'spreadTitle',
}

export enum RESPONSE_SET {
  MAIN = 'o_rc1',
}

export enum BUCKET_TYPE {
  DAILY = 'DAILY',
  WEEKLY = 'WEEKLY',
  MONTHLY = 'MONTHLY',
}

export const DIVISION = {
  MOBILITY: '40',
  ESS: '81',
  POWER: '82',
} as const;

export interface MainColumnMeta {
  key: string;
  header: string;
  width?: number;
  align?: 'L' | 'C' | 'R';
  format?: string;
  visible?: boolean;
  merge?: boolean;
  _ctrlType?: 'FPText' | 'FPNumber' | 'FPModal' | 'FPComboBox';
  _inputEditType?: 'S' | 'M' | 'O' | 'IM' | 'IO';
  _modalKey?: string;
}

// AS-IS DefColumns 50+ (Phase B-8 후속 정밀 추출 의무)
// 본 SKELETON 18 + 측정 9 핵심
export const MAIN_COLUMNS: MainColumnMeta[] = [
  // BASE 18
  { key: 'DIVISION_ID',    header: 'Div',           width: 60,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'DEPT_NAME_KO',   header: 'Department',    width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'TEAM_NAME_KO',   header: 'Team',          width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'END_CUSTOMER',   header: 'Customer',      width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'BIZ_TYPE',       header: 'Biz.Type',      width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'SCM_SITE_ID',    header: 'Sales Site',    width: 90,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'PLANT_SITE_ID',  header: 'Plant Site',    width: 90,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'PROJECT_CODE',   header: 'Project',       width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'PROJECT_NAME',   header: 'Project Name',  width: 150, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'ITEM_ID',        header: 'Model',         width: 120, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'NICK_NAME',      header: 'Nick',          width: 100, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'INCOTERMS',      header: 'Incoterms',     width: 80,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'FCST_TYPE',      header: 'Fcst Type',     width: 90,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'PLAN_YYYYMM',    header: 'Plan YYYYMM',   width: 90,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  // 측정 9 (M3/M2/M1 CUST_FCST + MKT_FCST)
  { key: 'M3_CUST_FCST_QTY', header: 'M-3 Cust', width: 80,  align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'M', format: 'n0' },
  { key: 'M3_MKT_FCST_QTY',  header: 'M-3 Mkt',  width: 80,  align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'M', format: 'n0' },
  { key: 'M2_CUST_FCST_QTY', header: 'M-2 Cust', width: 80,  align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'M', format: 'n0' },
  { key: 'M2_MKT_FCST_QTY',  header: 'M-2 Mkt',  width: 80,  align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'M', format: 'n0' },
  { key: 'M1_CUST_FCST_QTY', header: 'M-1 Cust', width: 80,  align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'M', format: 'n0' },
  { key: 'M1_MKT_FCST_QTY',  header: 'M-1 Mkt',  width: 80,  align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'M', format: 'n0' },
  // 누적 18 (SUM_03/06/12 + PRODUCT/SALE/INVENTORY/TIME_ADJUST/MODEL_MIX/SUPPLY_ISSUE) — Phase B-8 후속
  { key: 'POPUP_STATUS',   header: 'Status',        width: 80,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'EDIT_FLAG',      header: 'EDIT_FLAG',     width: 0,   align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', visible: false },
];

export const FROZEN_COL_COUNT = 14;

export const MSG = {
  REQUIRE_DIVISION:     'MSG00097',
  NO_DATA:              'MSG00108',
  REQUIRED_COLUMN:      'MSG00137',
  CONFIRM_SAVE:         'MSG00004',
} as const;
