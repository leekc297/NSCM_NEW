export const MENU_ID = 'DMF0020' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS DMF0020_SalesFuturePrice.cs (3,969줄, Forms.UIL/Master 정본) + .Designer.cs (1,599줄):
//   - 메인 그리드 SP : PKG_DMF0020.P_DMF0020_GET_FUTUREPRICE_INFO (4 IN + 2 OUT, 메타 등록)
//   - 환율 저장 SP   : PKG_DMF0020.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA (8 IN + 1 OUT, 메타 등록)
//   - 24 Event / 18 PKG SP / 71 메인 Validation + 12 POPUP / 9 Expression / 7 POPUP
//   - 분석서: Doc/_analysis/domain_DM/screens/DMF0020_SalesFuturePrice/ + 5 POPUP_*
export enum SHEETS {
  MAIN = 'main',           // 메인 그리드 — wide format (동적 W_/M_ 컬럼)
  PIVOT = 'pivot',         // Tab2 — Wijmo PivotEngine 클라이언트 측 long format
  EXCHANGE = 'exchange',   // ExchangeRate POPUP
  PRICE_BATCH = 'priceBatch', // Price 일괄입력 POPUP
  VERSION = 'version',     // Version 선택 POPUP
  TITLE_SET = 'titleSet',  // Grid Column Setting POPUP
  OWNER = 'owner',         // Owner POPUP
  SPREAD_TITLE = 'spreadTitle',     // 동적 컬럼 메타 (W_/M_)
  SPREAD_TITLE_DATE = 'spreadTitleDate', // 동적 컬럼 + 3단 헤더
  MEASURE_COUNT = 'measureCount',   // Item 별 Measure 개수 (RowSpan)
}

export enum RESPONSE_SET {
  MAIN = 'o_rc1',
  PIVOT = 'o_rc1',
  EXCHANGE = 'o_rc1',
  PRICE_BATCH = 'o_rc1',
  VERSION = 'o_rc1',
  TITLE_SET = 'o_rc1',
  OWNER = 'o_rc1',
  SPREAD_TITLE = 'o_rc1',
  SPREAD_TITLE_DATE = 'o_rc1',
  MEASURE_COUNT = 'o_rc1',
}

// Bucket Type — AS-IS .cs L3823 cboBucketType_Click + Designer cboBucketType (Weekly / Monthly)
export enum BUCKET_TYPE {
  WEEKLY = 'W',
  MONTHLY = 'M',
}

// Division 분기 (AS-IS validation.md 38건 사업부분기, .cs L203/320/881/892/911/...):
//   40 : Mobility & IT Battery — END_CUSTOMER40 컬럼 사용 / btnTemplate 비표시
//   81 : ESS Battery — PLANT_SITE_ID 컬럼 사용 / NewFlag 컬럼 추가 (C20200612-000174)
//   82 : Power Tool — INCOTERMS/FCST_TYPE/DOM_EXP/CURRENCY 컬럼 lock 별도 동작
export const DIVISION = {
  MOBILITY: '40',
  ESS: '81',
  POWER: '82',
} as const;

// Column 메타 (룰 12 §11.7 + hook grid-column-meta-mandatory.md):
//   _ctrlType    : FPText/FPModal/FPComboBox/FPCheckBox/FPDate/FPDateTime/FPNumber
//   _inputEditType: S (read-only) / M (필수) / O (선택) / IM (신규 필수) / IO (신규 선택)
//   _modalKey    : popup cell modal 식별자 (dblClick switch key)
//   _comboKey    : lookup combo 식별자 (Owner 등)
export interface MainColumnMeta {
  key: string;
  header: string;
  width?: number;
  align?: 'L' | 'C' | 'R';
  format?: string;
  visible?: boolean;
  merge?: boolean;
  freeze?: boolean;
  _ctrlType?: 'FPText' | 'FPModal' | 'FPComboBox' | 'FPCheckBox' | 'FPDate' | 'FPDateTime' | 'FPNumber';
  _inputEditType?: 'S' | 'M' | 'O' | 'IM' | 'IO';
  _modalKey?: string;
  _comboKey?: string;
}

// AS-IS .cs DefColumns + .Designer.cs SetSpreadColumn (analysis.md §4.5 v3 Grid 컬럼) — 32 cols + dynamic W_/M_
// AS-IS L645/673 SetSpreadHeaderSpan (SUM headers) + L3771 btnOwner_Click + L3792 btnColumn_Click
export const MAIN_COLUMNS: MainColumnMeta[] = [
  // ----- 좌측 Freeze 영역 (RowSpan + 그룹 동시 선택용, Sort 키 = group key) -----
  { key: 'DIVISION_ID',    header: 'Div.',          width: 70,  align: 'C', freeze: true, merge: true,  _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'DEPT_ID',        header: 'Dept Id',       width: 0,   visible: false,           _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'TEAM_INCHARGE',  header: 'Team',          width: 90,  align: 'C', freeze: true, merge: true,  _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'UPPER_DEPT_ID',  header: 'Upper Dept',    width: 0,   visible: false,           _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'DEPT_NAME',      header: 'Dept',          width: 110, align: 'L', freeze: true, merge: true,  _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'END_CUSTOMER',   header: 'End Customer',  width: 120, align: 'L', freeze: true, merge: true,  _ctrlType: 'FPComboBox', _inputEditType: 'IM', _comboKey: 'endCustomer' },
  { key: 'END_CUSTOMER40', header: 'End Cust 40',   width: 0,   visible: false,           _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'SCM_SITE_ID',    header: 'Sales Site',    width: 100, align: 'C', freeze: true, merge: true,  _ctrlType: 'FPComboBox', _inputEditType: 'IM', _comboKey: 'scmSite' },
  { key: 'PLANT_SITE_ID',  header: 'Plant Site',    width: 100, align: 'C', freeze: true, merge: true,  _ctrlType: 'FPText',     _inputEditType: 'IM' }, // div=81 전용
  { key: 'PROJECT_CODE',   header: 'Project',       width: 110, align: 'L', freeze: true, merge: true,  _ctrlType: 'FPModal',    _inputEditType: 'IM', _modalKey: 'projectByDivisionModal' },
  { key: 'PROJECT_NAME',   header: 'Project Name',  width: 130, align: 'L', freeze: true,               _ctrlType: 'FPText',     _inputEditType: 'S' },
  { key: 'ITEM_ID',        header: 'Model',         width: 130, align: 'L', freeze: true, merge: true,  _ctrlType: 'FPModal',    _inputEditType: 'IM', _modalKey: 'itemByDivisionModal' },
  { key: 'ITEM_NAME',      header: 'Item Name',     width: 130, align: 'L', freeze: true,               _ctrlType: 'FPText',     _inputEditType: 'S' },
  { key: 'ITEM_CLASS_NAME',header: 'Item Class',    width: 100, align: 'L', freeze: true,               _ctrlType: 'FPText',     _inputEditType: 'S' },
  { key: 'NICK_NAME',      header: 'Nick Name',     width: 100, align: 'L', freeze: true,               _ctrlType: 'FPText',     _inputEditType: 'S' },
  { key: 'INCOTERMS',      header: 'Incoterms',     width: 80,  align: 'C', freeze: true,               _ctrlType: 'FPComboBox', _inputEditType: 'IM', _comboKey: 'incoterms' },
  { key: 'FCST_TYPE',      header: 'FCST Type',     width: 80,  align: 'C', freeze: true,               _ctrlType: 'FPComboBox', _inputEditType: 'IM', _comboKey: 'fcstType' },
  { key: 'DOM_EXP',        header: 'Customs HBK',   width: 90,  align: 'C', freeze: true,               _ctrlType: 'FPComboBox', _inputEditType: 'IM', _comboKey: 'domExp' },
  { key: 'CURRENCY',       header: 'Currency',      width: 70,  align: 'C', freeze: true,               _ctrlType: 'FPComboBox', _inputEditType: 'IM', _comboKey: 'currency' },
  { key: 'MEASURE',        header: 'Measure',       width: 80,  align: 'C', freeze: true,               _ctrlType: 'FPComboBox', _inputEditType: 'IM', _comboKey: 'measure' },
  // ----- 상태 컬럼 (Freeze 분기점, 우측은 동적 시간축) -----
  { key: 'PROJECT_STATUS', header: 'PJT Status',    width: 0,   visible: false,           _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'BIZ_TYPE',       header: 'Biz Type',      width: 0,   visible: false,           _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'BIZ_TYPE_NAME',  header: 'Biz Type Name', width: 100, align: 'L',               _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'AUTHORITY_YN',   header: 'Auth',          width: 0,   visible: false,           _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'NEW_FLAG',       header: 'New',           width: 50,  align: 'C',               _ctrlType: 'FPText', _inputEditType: 'S' }, // ESS only
  { key: 'PRICE_EXIST',    header: 'Px Exist',      width: 0,   visible: false,           _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'EDIT_YN',        header: 'Editable',      width: 0,   visible: false,           _ctrlType: 'FPText', _inputEditType: 'S' },
];

// ExchangeRate POPUP — AS-IS DMF0020_SalesFuturePricePopUp.cs (586줄)
//   메타 SQL BLOCK 3 의 7 columns (현 SCM_MST_SHEET_COLUMNS 등록 상태)
export const EXCHANGE_RATE_COLUMNS: MainColumnMeta[] = [
  { key: 'DIVISION_ID',     header: 'Div',           width: 80,  align: 'C', freeze: true, _ctrlType: 'FPText',   _inputEditType: 'S' },
  { key: 'CURRENCY',        header: 'Currency',      width: 90,  align: 'C', freeze: true, _ctrlType: 'FPText',   _inputEditType: 'S' },
  { key: 'UNIT_CURRENCY',   header: 'Unit Currency', width: 110, align: 'C', freeze: true, _ctrlType: 'FPText',   _inputEditType: 'S' },
  { key: 'EXCHANGE_PRICE',  header: 'Exchange',      width: 140, align: 'R', format: 'n4', _ctrlType: 'FPNumber', _inputEditType: 'M' },
];

// 좌측 Freeze 분기점 (Wijmo frozenColumns = visible freeze column count)
export const FROZEN_COL_COUNT = 18;

// 그룹 동시 선택 — Measure 제외 11개 키 (As-Is .cs RowSpan + 사용자 캡쳐)
export const GROUP_COLS = [
  'DIVISION_ID', 'TEAM_INCHARGE', 'END_CUSTOMER', 'SCM_SITE_ID',
  'ITEM_ID', 'INCOTERMS', 'FCST_TYPE', 'DOM_EXP', 'CURRENCY',
] as const;

// AS-IS Validation MSG ID 매핑 (validation.md 71건):
//   - MSG00002 [{}] 은 필수 입력사항입니다.
//   - MSG00004 저장하시겠습니까?
//   - MSG00043 저장시 중복 오류가 발생하였습니다.{0}
//   - MSG00097 Division 을 선택하세요.
//   - MSG00108 조회된 데이터가 없습니다 (기간 역전 시).
//   - MSG00113 복사할 데이터를 선택하세요.
//   - MSG00135/00408 수정모드에서는 입력할 수 없습니다.
//   - MSG00137 필수 컬럼을 입력하세요.
//   - MSG00142 (편집 잠금 해제 필요)
//   - MSG00227/00255/00265/00283/00412/00414/00447/00448 기타 미등록 메시지
export const MSG = {
  REQUIRED_FIELD:       'MSG00002',
  CONFIRM_SAVE:         'MSG00004',
  DUPLICATE:            'MSG00043',
  REQUIRE_DIVISION:     'MSG00097',
  NO_DATA:              'MSG00108',
  SELECT_COPY_ROW:      'MSG00113',
  EDIT_LOCK_REQUIRED:   'MSG00135',
  REQUIRED_COLUMN:      'MSG00137',
  EXCHANGE_LOCK:        'MSG00142',
  BATCH_RESULT:         'MSG00143',
  MULTI_VERSION:        'MSG00255',
  EXCEL_UPLOAD_RESULT:  'MSG00265',
  REQUIRE_VERSION:      'MSG00283',
  EDIT_MODE_LOCK:       'MSG00408',
  PRICE_EXIST_MISSING:  'MSG00412',
  SAVE_DIVISION_40:     'MSG00414',
  CURRENCY_EMPTY:       'MSG00447',
  EDIT_NOT_CURRENT_VER: 'MSG00448',
  INSERT_ONLY_BUCKET:   'MSG00227',
} as const;
