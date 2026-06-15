// DMF0082 FCST&PRICE MGMT — DMF0081 (FCST) + DMF0020 (PRICE) 결합
// AS-IS DMF0082_FcstNPrice_Mgmt.cs (9,418줄 — 12 화면 중 가장 큼)
//   - 5 PKG SP + 1 신규 SAVE (16 IN + 1 OUT 예상)
//   - 메인 SP: 6 ResultSet (O_RC1~5 + O_RESULT_CURSOR)
//   - 권한 4 분기 (bEDIT_AUTH_SCM_FCST/MKT_FCST/LOC/VMI_IN_REQ)
//   - 월간→일별 배분 + Clipboard Paste 최적화 + Mon-Sun 권한 분기
//   - 3 신규 popup (FuturePriceInfo + MeasureCountInfo + WeekData)
//   - Figma ✅ (DMF0082.svg + DMF0082_Table_v2.svg)
//   - 분석서: Doc/_analysis/domain_DM/screens/DMF0082_FcstNPrice_Mgmt/ (8 MD)
// ⚠️ DMF0082 의 기존 'forecast-price' 폴더 (ROUTE_PATHS.DMF0082='forecast-price') 와 다른 신규 폴더
//   본 폴더 (fcst-price-mgmt) 는 정식 DMF0082 화면. 'forecast-price' 는 deprecated 검토.
export const MENU_ID = 'DMF0082' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  MAIN = 'main',                                  // 메인 6 ResultSet
  FUTURE_PRICE_POPUP = 'futurePricePopup',         // 환율 popup
  MEASURE_COUNT_POPUP = 'measureCountPopup',
  MEASURE_COUNT_SAVE_POPUP = 'measureCountSavePopup',
  WEEK_DATA_POPUP = 'weekDataPopup',
}

export enum RESPONSE_SET {
  MAIN_FCST = 'o_rc1',         // FCST 데이터
  MAIN_PRICE = 'o_rc2',        // PRICE 데이터
  MAIN_MEASURE = 'o_rc3',      // MEASURE 정보
  MAIN_CALENDAR = 'o_rc4',     // CALENDAR 정보
  MAIN_WEEK = 'o_rc5',         // WEEK 정보
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

// 권한 4 분기 (행별 cell 색상 + 편집 가능/불가)
export enum EDIT_AUTH {
  SCM_FCST = 'SCM_FCST',
  MKT_FCST = 'MKT_FCST',
  LOC = 'LOC',
  VMI_IN_REQ = 'VMI_IN_REQ',
}

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
  _editAuth?: EDIT_AUTH;        // DMF0082 특수 — 권한 4 분기
}

// AS-IS DMF0082 DefColumns (Phase B-9 후속 정밀 추출)
// 본 SKELETON 핵심 14
export const MAIN_COLUMNS: MainColumnMeta[] = [
  { key: 'DIVISION_ID',    header: 'Div',           width: 60,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'DEPT_NAME_KO',   header: 'Department',    width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'TEAM_NAME_KO',   header: 'Team',          width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'END_CUSTOMER',   header: 'Customer',      width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'BIZ_TYPE_NAME',  header: 'Biz.Type',      width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'SCM_SITE_ID',    header: 'Sales Site',    width: 90,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'PROJECT_CODE',   header: 'Project',       width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'ITEM_ID',        header: 'Model',         width: 120, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'INCOTERMS',      header: 'Incoterms',     width: 80,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'FCST_TYPE',      header: 'Fcst Type',     width: 90,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'CURRENCY',       header: 'Currency',      width: 70,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'MEASURE',        header: 'Measure',       width: 100, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'QTY',            header: 'Qty',           width: 80,  align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'M', format: 'n0', _editAuth: EDIT_AUTH.SCM_FCST },
  // 동적 시간축 (Daily/Weekly/Monthly Bucket 별) — Phase B-9 후속
  { key: 'EDIT_FLAG',      header: 'EDIT_FLAG',     width: 0,   align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', visible: false },
];

export const FROZEN_COL_COUNT = 7;

export const MSG = {
  REQUIRE_DIVISION:     'MSG00097',
  NO_DATA:              'MSG00108',
  REQUIRED_COLUMN:      'MSG00137',
  CONFIRM_SAVE:         'MSG00004',
  REQUIRE_VERSION:      'MSG00283',
} as const;
