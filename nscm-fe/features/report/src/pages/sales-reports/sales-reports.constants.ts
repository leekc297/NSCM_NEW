export const MENU_ID = 'DMF0044' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS DMF0044_Sales_Reports.cs (~2,000줄) — SALES REPORTS
//   - 18 SP (실호출 6) / SAVE_C_CF 2,896줄
//   - 35 Grid cols / Popup 4 신규 (SalesReportExchange / SalesReport_Textbox / Sales_Version / United_Version)
//   - Figma ✅ (Doc/_figma/screens/DMF0044.md + DMF0044.svg + DMF0044_Table.svg)
//   - 메뉴: Report > Sales > SALES REPORTS (UPPR_MNU_ID='Report')
// 자매 reference: DMF0020 (Report 표준) + DMF0042 (Report 형제)
export enum SHEETS {
  MAIN = 'main',
  SPREAD_TITLE = 'spreadTitle',
  EXCHANGE_POPUP = 'exchangePopup',
  TEXTBOX_POPUP = 'textboxPopup',
  VERSION_POPUP = 'versionPopup',
  UNITED_VERSION_POPUP = 'unitedVersionPopup',
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
  freeze?: boolean;
  _ctrlType?: 'FPText' | 'FPNumber' | 'FPModal' | 'FPComboBox';
  _inputEditType?: 'S' | 'M' | 'O' | 'IM' | 'IO';
  _modalKey?: string;
}

// AS-IS DMF0044 DefColumns 35 cols (Phase B-5 후속 진입 시 정밀 추출 의무)
// 본 SKELETON 핵심 15 cols
export const MAIN_COLUMNS: MainColumnMeta[] = [
  { key: 'DIVISION_ID',    header: 'Div',           width: 60,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'DEPT_NAME_KO',   header: 'Department',    width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'TEAM_NAME_KO',   header: 'Team',          width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'END_CUSTOMER',   header: 'Customer',      width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'BIZ_TYPE_NAME',  header: 'Biz.Type',      width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'PROJECT_CODE',   header: 'Project',       width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'PROJECT_NAME',   header: 'Project Name',  width: 150, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'ITEM_ID',        header: 'Model',         width: 120, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'INCOTERMS',      header: 'Incoterms',     width: 80,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'CURRENCY',       header: 'Currency',      width: 70,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'MEASURE',        header: 'Measure',       width: 100, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'QTY',            header: 'Qty',           width: 80,  align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'M', format: 'n0' },
  // ... 나머지 23 cols Phase B-5 후속
  { key: 'EDIT_FLAG',      header: 'EDIT_FLAG',     width: 0,   align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', visible: false },
];

export const FROZEN_COL_COUNT = 7;

export const MSG = {
  REQUIRE_DIVISION:     'MSG00097',
  NO_DATA:              'MSG00108',
  REQUIRED_COLUMN:      'MSG00137',
  CONFIRM_SAVE:         'MSG00004',
} as const;
