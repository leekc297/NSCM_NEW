export const MENU_ID = 'DMF0049' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS DMF0049_Sales_ETC_Reports.cs — ETC SALES REPORTS
//   - 4 SP (SAVE 36 param!) / 42 cols (T_DEPARTMENT_ID / T_DEPT_ID / ETC_DESCR / Cell_Name 특수)
//   - 0 신규 popup (DMF0044 공유)
//   - 메뉴: Report > Sales > ETC SALES REPORTS (UPPR_MNU_ID='Report')
// 자매 reference: DMF0044 (Sales Reports 직접 형제)
export enum SHEETS {
  MAIN = 'main',
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

// AS-IS DMF0049 DefColumns 42 cols (T_prefix ETC 특수)
// Phase B-6 후속 정밀 추출 — 본 SKELETON 핵심 14
export const MAIN_COLUMNS: MainColumnMeta[] = [
  { key: 'DIVISION_ID',    header: 'Div',           width: 60,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'T_DEPARTMENT_ID',header: 'T_Department',  width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'T_DEPT_ID',      header: 'T_Dept',        width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'END_CUSTOMER',   header: 'Customer',      width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'BIZ_TYPE_NAME',  header: 'Biz.Type',      width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'PROJECT_CODE',   header: 'Project',       width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'PROJECT_NAME',   header: 'Project Name',  width: 150, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'ITEM_ID',        header: 'Model',         width: 120, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'CELL_NAME',      header: 'Cell Name',     width: 100, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'ETC_DESCR',      header: 'ETC Descr',     width: 200, align: 'L', _ctrlType: 'FPText', _inputEditType: 'O' },
  { key: 'CURRENCY',       header: 'Currency',      width: 70,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'MEASURE',        header: 'Measure',       width: 100, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'QTY',            header: 'Qty',           width: 80,  align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'M', format: 'n0' },
  // ... 나머지 29 cols Phase B-6 후속
  { key: 'EDIT_FLAG',      header: 'EDIT_FLAG',     width: 0,   align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', visible: false },
];

export const FROZEN_COL_COUNT = 6;

export const MSG = {
  REQUIRE_DIVISION:     'MSG00097',
  NO_DATA:              'MSG00108',
  REQUIRED_COLUMN:      'MSG00137',
  CONFIRM_SAVE:         'MSG00004',
} as const;
