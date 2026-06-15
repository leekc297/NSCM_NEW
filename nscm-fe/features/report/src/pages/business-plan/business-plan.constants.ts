export const MENU_ID = 'DMF0042' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS DMF0042_BizPlan.cs (3,564줄, Forms.UIL/Plan) — BUSINESS PLAN 메인
//   - 9 SP / Validation 97 (필수 43 + 사업부 34) / Expression 62 (행잠금 57 + SUM 5 → PIVOT 강력 시사)
//   - 68 Grid cols (PIVOT 또는 다단 헤더)
//   - 4 신규 Popup (ExchangeRate / Textbox / Version / UnitedVersion)
//   - 진화 lineage: DMF0042 메인 / DMF0042_1 / DMF0042_2 / DMF0042_3 (4 variants 모두 별도 화면)
//   - _bulk_fix_v2 SP audit 이력 (2026-06-01) 적용 완료
//
// 메뉴: Report > Business Plan > BUSINESS PLAN (UPPR_MNU_ID='Report' or 'BusinessPlan')
// 자매 reference: DMF0020 (PIVOT 행잠금) + DMF0021 (Plan 다단 헤더)
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

// AS-IS DMF0042 DefColumns 68 cols (Phase B-4 후속 진입 시 정밀 추출 의무)
// 본 SKELETON 에서는 핵심 28 cols 만 - 나머지 40 cols 후속 보강
export const MAIN_COLUMNS: MainColumnMeta[] = [
  { key: 'DIVISION_ID',    header: 'Div',           width: 60,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'DEPT_NAME_KO',   header: 'Department',    width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'TEAM_NAME_KO',   header: 'Team',          width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'END_CUSTOMER',   header: 'Customer',      width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'BIZ_TYPE_NAME',  header: 'Biz.Type',      width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'SCM_SITE_ID',    header: 'Sales Site',    width: 90,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'PLANT_SITE_ID',  header: 'Plant Site',    width: 90,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'PROJECT_CODE',   header: 'Project',       width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'ITEM_ID',        header: 'Model',         width: 120, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'INCOTERMS',      header: 'Incoterms',     width: 80,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'FCST_TYPE',      header: 'Fcst Type',     width: 90,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'CURRENCY',       header: 'Currency',      width: 70,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'MEASURE',        header: 'Measure',       width: 100, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'QTY',            header: 'Qty',           width: 80,  align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'M', format: 'n0' },
  // ... 나머지 54 cols Phase B-4 후속 추가
  { key: 'EDIT_FLAG',      header: 'EDIT_FLAG',     width: 0,   align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', visible: false },
];

export const FROZEN_COL_COUNT = 9;       // BASE dimension 좌측 고정 (PIVOT frozenColumns)

export const MSG = {
  REQUIRE_DIVISION:     'MSG00097',
  NO_DATA:              'MSG00108',
  REQUIRED_COLUMN:      'MSG00137',
  CONFIRM_SAVE:         'MSG00004',
  DUPLICATE:            'MSG00043',
  REQUIRE_VERSION:      'MSG00283',
  EDIT_LOCK_REQUIRED:   'MSG00135',
} as const;
