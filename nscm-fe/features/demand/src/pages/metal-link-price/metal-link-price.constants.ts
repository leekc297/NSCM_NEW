export const MENU_ID = 'DMF0074' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS DMF0074_MetalLinkPrice.cs (760줄) — METAL LINK PRICE
//   - PKG_DMF0074: 3 SP (GET PIVOT + GET TEMPLATE + EXCEL UPLOAD)
//   - 11 events / 5 popup (3 공용 + 2 신규)
//   - Validation 6 / Expression 0 (PIVOT only)
//   - 40 사업부 별도 ID 처리 (DMF0074_40 — Excel Upload formId 분기)
//   - 분석서: Doc/_analysis/domain_DM/screens/DMF0074_MetalLinkPrice/ (8 MD, Phase A 작성)
//   - 메뉴: Demand > Demand Plan > METAL LINK PRICE
// 자매 reference: DMF0020 SalesFuturePrice (PIVOT 표준)
export enum SHEETS {
  MAIN = 'main',
  SPREAD_TITLE = 'spreadTitle',
  TEMPLATE_POPUP = 'templatePopup',
  EXCEL_UPLOAD_POPUP = 'excelUploadPopup',
}

export enum RESPONSE_SET {
  MAIN = 'o_rc1',
}

export const DIVISION = {
  MOBILITY: '40',
  ESS: '81',
  POWER: '82',
} as const;

// AS-IS DMF0074_40 별도 ID 처리 (Excel Upload 시만 사용)
export const DMF0074_40 = 'DMF0074_40';

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

// AS-IS DMF0074 BASE 14 cols + 동적 월별 PIVOT
export const MAIN_COLUMNS: MainColumnMeta[] = [
  { key: 'DIVISION_ID',          header: 'Div',              width: 60,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'DEPT_ID',              header: 'Team',             width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'FCST_TYPE',            header: 'Fcst Type',        width: 90,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'SCM_SITE_ID',          header: 'Sales Site',       width: 90,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'END_CUSTOMER',         header: 'End Customer',     width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'PROJECT_CODE',         header: 'Project',          width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'PROJECT_NAME',         header: 'Project Name',     width: 150, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'PLANT_SITE_ID',        header: 'Plant Site',       width: 90,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'ITEM_ID',              header: 'Model',            width: 120, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'METAL_KIND_CODE',      header: 'Metal Kind',       width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'CURRENCY',             header: 'Currency',         width: 70,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'METAL_EXCEPTION_YN',   header: 'Exception',        width: 80,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'METAL_LINK_YN',        header: 'Link YN',          width: 70,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'APPLY_PRICE_TYPE_CODE',header: 'Apply Type',       width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  // 동적 월별 컬럼 (CONTRACT_UNIT_PRICE / METAL_APPLY_UNIT_PRICE / METAL_REQR_QTY / ENERGY)
];

export const FROZEN_COL_COUNT = 14;          // BASE 좌측 고정 (PIVOT frozenColumns)

export const MSG = {
  REQUIRE_DIVISION:     'MSG00097',
  NO_DATA:              'MSG00108',
  REQUIRED_COLUMN:      'MSG00137',
  REQUIRE_VERSION:      'MSG00283',
  REQUIRED_PERIOD:      'MSG00002',
  INVALID_DATE:         'MSG00049',
} as const;
