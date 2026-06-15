export const MENU_ID = 'DMF0021' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS DMF0021_SalesPlan.cs (5,599줄) + Designer (1,451줄):
//   - 메인 SP : PKG_DMF0021.P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX (2,122줄)
//   - SAVE SP : PKG_DMF0021.P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL (2,937줄)
//   - 27 Event / 7+ PKG SP + 콤보 7종 + 공통 4
//   - Validation 141 (사업부 73 + 필수 39 + 기타 29) / Expression 120 (조건부 잠금 112 + SUM 5 + 합계 3)
//   - 51 Grid cols (5 DefColumns 그룹 — 다단 헤더 ColumnHeaderSpan 11회)
//   - 9 Popup (DM 2 + 미지정 1 + 신규 6)
//   - 자매 reference: DMF0020 SalesFuturePrice (PIVOT) + DMF0048 SalesMonitoring (Plan 표준)
//   - 메뉴: Demand > Demand Plan > Sales Plan (UPPR_MNU_ID='Demand_Plan')
// 룰 25 §1.5.1 (Button 10대) — CRUD 활성:
//   F2 Edit / F5 Search / F7 Save / F8 Insert / F9 Delete / F12 Excel (CRUD 6 모두)
//   F3 Sort / F4 Filter / F6 Condition / F10 Reset (자동 활성)
export enum SHEETS {
  MAIN = 'main',                      // 메인 그리드 (wide format with dynamic time cols)
  SPREAD_TITLE = 'spreadTitle',       // 동적 헤더 메타
  SPREAD_TITLE2 = 'spreadTitle2',     // 추가 헤더 메타
  MEASURE_INFO = 'measureInfo',       // Measure 정보
  MEASURE_INFO2 = 'measureInfo2',     // Measure 정보 2
}

export enum RESPONSE_SET {
  MAIN = 'o_rc1',
  MAIN_META = 'o_rc2',
  SPREAD_TITLE = 'o_rc1',
  MEASURE_INFO = 'o_rc1',
}

export enum BUCKET_TYPE {
  DAILY = 'DAILY',
  WEEKLY = 'WEEKLY',
  MONTHLY = 'MONTHLY',
}

// Division 분기 (AS-IS validation.md 73 건 사업부 분기 — 40/81/82 중심)
export const DIVISION = {
  MOBILITY: '40',
  ESS: '81',
  POWER: '82',
} as const;

// Column 메타 (자매 DMF0020/DMF0048 패턴 — 51 cols, _inputEditType 'S' (read-only) / 'M' (필수) / 'O' (선택))
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
  _comboKey?: string;
}

// AS-IS DMF0021 DefColumns 51 cols (5 그룹):
//   Main (19) + [C20200513-000276] Sales Co/Plant +16 + UPPER_DEPT_ID (1) + [PJ20200138] +4 + 201806 소형 +11 = 51
//   DMF0048 와 거의 동일 (단, DMF0021 은 편집 가능 — _inputEditType 'M'/'O' 다수)
export const MAIN_COLUMNS: MainColumnMeta[] = [
  // === Main 19 cols (메타 정보 — 대부분 read-only, 좌측 freeze) ===
  { key: 'Column1',        header: '',              width: 30,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'Column2',        header: '',              width: 30,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'Column3',        header: '',              width: 30,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'DIVISION_ID',    header: 'Div',           width: 60,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'DEPT_ID',        header: 'Dept ID',       width: 80,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true, visible: false },
  { key: 'DEPT_NAME_KO',   header: 'Department',    width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'TEAM_ID',        header: 'Team ID',       width: 80,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true, visible: false },
  { key: 'TEAM_NAME_KO',   header: 'Team',          width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'END_CUSTOMER',   header: 'Customer',      width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'BIZ_TYPE',       header: 'Biz.Type Code', width: 80,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true, visible: false },
  { key: 'BIZ_TYPE_NAME',  header: 'Biz.Type',      width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'SCM_SITE_ID',    header: 'Sales Site',    width: 90,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'PLANT_SITE_ID',  header: 'Plant Site',    width: 90,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'PLANT_SITE_ID2', header: 'Plant Site 2',  width: 90,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true, visible: false },
  { key: 'PROJECT_CODE',   header: 'Project',       width: 100, align: 'C', _ctrlType: 'FPModal', _inputEditType: 'S', merge: true, _modalKey: 'PROJECT' },
  { key: 'PROJECT_NAME',   header: 'Project Name',  width: 150, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'ITEM_ID',        header: 'Model',         width: 120, align: 'C', _ctrlType: 'FPModal', _inputEditType: 'S', merge: true, _modalKey: 'ITEM' },
  { key: 'ITEM_CLASS_NAME',header: 'Item Class',    width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'ITEM_NAME',      header: 'Item Name',     width: 150, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },

  // === [C20200513-000276] Sales Co / Plant +16 cols ===
  { key: 'SALES_COMPANY',     header: 'Sales Company',   width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'SALES_PLANT',       header: 'Sales Plant',     width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'NICK_NAME',         header: 'Nick Name',       width: 100, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'INCOTERMS',         header: 'Incoterms',       width: 80,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'ITEM_TYPE',         header: 'Item Type',       width: 90,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'FCST_TYPE',         header: 'Fcst Type',       width: 90,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'DOM_EXP',           header: 'DOM/EXP',         width: 80,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'PROJECT_STATUS',    header: 'Project Status',  width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'PROJECT_OWNER',     header: 'Project Owner',   width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'MEASURE_GROUP',     header: 'Measure Group',   width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'MEASURE',           header: 'Measure',         width: 100, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'YYYYMMDD',          header: 'YYYYMMDD',        width: 80,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', visible: false },
  { key: 'QTY',               header: 'Qty',             width: 80,  align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'M', format: 'n0' },
  { key: 'CURRENCY',          header: 'Currency',        width: 70,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'SALES_PLAN_ADJUST_YN', header: 'Adjust YN',    width: 70,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'O' },
  { key: 'TEAM_INCHARGE',     header: 'Team Incharge',   width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },

  // === UPPER_DEPT_ID (1) ===
  { key: 'UPPER_DEPT_ID',     header: 'Upper Dept',      width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true, visible: false },

  // === [PJ20200138] (3 cols — ProjectName 중복 제외) ===
  { key: 'DISTRIBUTION_CHANNEL', header: 'Distribution', width: 120, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'CELL_NAME',         header: 'Cell Name',       width: 100, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'SHIPMENT_SITE',     header: 'Shipment Site',   width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },

  // === 201806 소형 (11 cols) ===
  { key: 'END_CUSTOMER40',    header: 'End Customer 40', width: 120, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'OWNER',             header: 'Owner',           width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'COUNTRY_NAME',      header: 'Country',         width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'CITY_NAME',         header: 'City',            width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'FORECAST_INFO_PRODUCT_GROUP', header: 'Product Group', width: 120, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'VMI_YN',            header: 'VMI YN',          width: 70,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'COLUMN_NAME',       header: 'Col Name',        width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', visible: false },
  { key: 'COLUMN_LABEL_NAME', header: 'Col Label',       width: 100, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S', visible: false },
  { key: 'SMALL_CLASS_LABEL_NAME', header: 'Small Class', width: 100, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S', visible: false },
  { key: 'LARGE_CLASS_LABEL_NAME', header: 'Large Class', width: 100, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S', visible: false },
  { key: 'DAY_CODE',          header: 'Day Code',        width: 70,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', visible: false },

  // === EditFlag (CRUD 추적) ===
  { key: 'EDIT_FLAG',         header: 'EDIT_FLAG',       width: 0,   align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', visible: false },
];

export const FROZEN_COL_COUNT = 4;       // BASE 좌측 고정

// MSG ID (validation.md 141건 핵심)
export const MSG = {
  REQUIRE_DIVISION:     'MSG00097',
  NO_DATA:              'MSG00108',
  REQUIRED_COLUMN:      'MSG00137',
  PERIOD_OVER_3YEARS:   'MSG00164',
  INSERT_ONLY_BUCKET:   'MSG00227',
  CONFIRM_SAVE:         'MSG00004',
  DUPLICATE:            'MSG00043',
  REQUIRED_FIELD:       'MSG00002',
  EDIT_LOCK_REQUIRED:   'MSG00135',
} as const;
