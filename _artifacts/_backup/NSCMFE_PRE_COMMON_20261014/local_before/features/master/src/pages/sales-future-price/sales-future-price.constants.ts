export const MENU_ID = 'DMF0020' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS DMF0020_SalesFuturePrice.cs (3,969줄, Forms.UIL/Master 정본) + .Designer.cs (1,599줄):
//   - 메인 그리드 SP : PKG_DMF0020.P_DMF0020_GET_FUTUREPRICE_INFO (4 IN + 2 OUT, 메타 등록)
//   - 환율 저장 SP   : PKG_DMF0020.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA (8 IN + 1 OUT, 메타 등록)
//   - 24 Event / 18 PKG SP / 71 메인 Validation + 12 POPUP / 9 Expression / 7 POPUP
//   - 분석서: Doc/_analysis/domain_DM/screens/DMF0020_SalesFuturePrice/ + 5 POPUP_*
export enum SHEETS {
  MAIN = 'main', // 메인 그리드 — wide format (동적 W_/M_ 컬럼)
  PIVOT = 'pivot', // Tab2 — Wijmo PivotEngine 클라이언트 측 long format
  EXCHANGE = 'exchange', // ExchangeRate POPUP — 클라우드 procedures.d.ts 유니온 정렬 (2026-06-12)
  PRICE_BATCH = 'priceBatch', // Price 일괄입력 POPUP — 클라우드 procedures.d.ts 유니온 정렬 (2026-06-12)
  VERSION = 'version', // Version 선택 POPUP
  TITLE_SET = 'titleSet', // Grid Column Setting POPUP
  OWNER = 'owner', // Owner POPUP
  SPREAD_TITLE = 'spreadTitle', // 동적 컬럼 메타 (W_/M_)
  SPREAD_TITLE_DATE = 'spreadTitleDate', // 동적 컬럼 + 3단 헤더
  MEASURE_COUNT = 'measureCount', // Item 별 Measure 개수 (RowSpan)
}

// const object — enum 대체 (NSCM 단일 cursor 표준 'o_rc1' 다수 중복 허용)
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  PIVOT: 'o_rc1',
  EXCHANGE: 'o_rc1',
  PRICE_BATCH: 'o_rc1',
  VERSION: 'o_rc1',
  TITLE_SET: 'o_rc1',
  OWNER: 'o_rc1',
  SPREAD_TITLE: 'o_rc1',
  SPREAD_TITLE_DATE: 'o_rc1',
  MEASURE_COUNT: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// ⭐ UI Category Setup(admin) SHEET_NAME — AS-IS 원본명 그대로 (사용자 명시 2026-06-26: SHEET_NAME 불변).
//   라우팅용 SHEETS value('main' 등, BTN_BTN_MPG.SHT_NM)와 분리 — column/measure 메타 fetch 는 이 AS-IS명 사용.
//   admin SCM_MST_SHEET_COLUMNS/SHEET_MEASURE.SHEET_NAME = 'Sales Price' → FE fetchStaticColumns/Measures 가 이 값으로 조회.
//   미정의 sheet 는 SHEETS value 그대로 fallback. (#91 sheet-name-asis-preserve / #65 동적 메타)
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'Sales Price',
  // ⭐ Price Batch Input 팝업 전용 시트 (AS-IS DMF0020_SaveSalesFuturePrice_Popup.cs L99
  //   `shtMain = "Sales Price Save All"`). 메인('Sales Price')과 별개 컬럼셋. divisionId 로 SP 서버측 DIVISION_ID 필터.
  [SHEETS.PRICE_BATCH]: 'Sales Price Save All',
};

// ⭐ 컬럼 개인화(SCM_MST_TITLESET_USER) 조회/저장 키.
//   ⚠️ 팝업 조회(ColumnLayoutModal) · 저장(saveTitleSet) · 진입 복원(fetchUserColumnLayout) 이
//     **셋 다 같은 값**을 써야 한다. 하나라도 다르면 저장은 성공하는데 재진입 조회가 그 행을 못 찾아
//     개인화가 사라진다 (forecast-price 2026-07-27 / sales-monitoring 2026-07-04 동일 사고).
export const TITLESET_SHEET = ADMIN_SHEET_NAME[SHEETS.MAIN] ?? SHEETS.MAIN; // 'Sales Price'
export const TITLESET_COLUMN_TYPE = 'C';

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
  _ctrlType?:
    | 'FPText'
    | 'FPModal'
    | 'FPComboBox'
    | 'FPCheckBox'
    | 'FPDate'
    | 'FPDateTime'
    | 'FPNumber';
  _inputEditType?: 'S' | 'M' | 'O' | 'IM' | 'IO';
  _modalKey?: string;
  _comboKey?: string;
}

// AS-IS DefColumns + SP P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M 결과 컬럼명 정확 매핑 (2026-06-03 v3):
//   _ctrlType = 'FPModal'  : Insert 시 popup (AS-IS cellTypeImage — PROJECT_CODE / ITEM_ID)
//   _ctrlType = 'FPComboBox': Insert 시 combo dropdown (AS-IS SetCellTypeCombo)
//   _inputEditType = 'IM'  : 신규 입력 시 필수 / 'S' : read-only
// AS-IS .cs L2040/2044/2059/2088: PROJECT_CODE + ITEM_ID = cellTypeImage (popup)
// AS-IS .cs L2034/2036/2038/2055/2067: DEPT_ID + SCM_SITE_ID + END_CUSTOMER + INCOTERMS + DOM_EXP = combo
// AS-IS DMF0020_SalesFuturePrice.cs L1990~2200 InsertRow() 정밀 매핑 (anti-simplification):
//   FPComboBox + _comboKey  : Insert 시 dropdown (조회조건 form 의 dropdown 동등)
//   FPModal + _modalKey     : Insert 시 popup 🔍 (cell 우측 돋보기 아이콘 + dblClick popup)
//   FPText IM/IO            : 직접 입력
//   FPText S                : read-only (자동 채움 또는 고정)
export const MAIN_COLUMNS: MainColumnMeta[] = [
  // AS-IS L2051+2052: 자동 sc.divisionId 채움 + Lock — 사용자 명시 dropdown 가능
  {
    key: 'DIVISION_ID',
    header: 'Div',
    width: 70,
    align: 'C',
    _ctrlType: 'FPComboBox',
    _inputEditType: 'IM',
    _comboKey: 'MyDivision',
  },
  // AS-IS L2034/L2067 SetCellTypeCombo(dtTeamAuth) — AS-IS 원천(BigFilter 'TeambyDivision')은
  //   DIVISION_ID 매핑 포함. cascade(#59) 위해 DIVISION_ID 반환 + 사용자 권한 필터가 있는 기존 등록
  //   'TeambyDivision' 사용 (TeambyDivision2 는 division 키 미반환 — 2026-07-03 cascade 작업).
  {
    key: 'DEPT_ID',
    header: 'Team',
    width: 70,
    align: 'C',
    _ctrlType: 'FPComboBox',
    _inputEditType: 'IM',
    _comboKey: 'TeambyDivision', // UI Category CELL_COMBO_DATA_TYPE 정합 (fallback)
  },
  // AS-IS L2038/L2086 SetCellTypeCombo(dtEndCustomerAuth)
  {
    key: 'END_CUSTOMER',
    header: 'End Customer',
    width: 100,
    align: 'C',
    _ctrlType: 'FPComboBox',
    _inputEditType: 'IM',
    _comboKey: 'EndCustomerByDivisionDept',
  },
  // AS-IS L2036/L2072 SetCellTypeCombo(dtSalesSiteAuth)
  {
    key: 'SCM_SITE_ID',
    header: 'Sales Site',
    width: 90,
    align: 'C',
    _ctrlType: 'FPComboBox',
    _inputEditType: 'IM',
    _comboKey: 'SiteByEndCustomer',
  },
  // AS-IS L2040/L2088 cellTypeImage (popup)
  {
    key: 'PROJECT_CODE',
    header: 'Project Code',
    width: 120,
    align: 'C',
    _ctrlType: 'FPModal',
    _inputEditType: 'IM',
    _modalKey: 'PROJECT',
  },
  // AS-IS L2092 LockRange2(true) — Project popup 시 자동 채움 + 직접 입력 허용 (사용자 명시)
  {
    key: 'PROJECT_STATUS',
    header: 'Project Status',
    width: 100,
    align: 'C',
    _ctrlType: 'FPText',
    _inputEditType: 'IO',
  },
  // AS-IS L2094 LockRange2(true) — Project popup 시 자동 채움
  //   사용자 요구 2026-06-03 v4: Insert 시 BizType combo dropdown 도 가능 (CMBO_SQL_M 'BizType' 등록)
  {
    key: 'BIZ_TYPE_NAME',
    header: 'Biz.Type',
    width: 100,
    align: 'C',
    _ctrlType: 'FPComboBox',
    _inputEditType: 'IO',
    _comboKey: 'BizTypeByDivision', // UI Category CELL_COMBO_DATA_TYPE 정합 (fallback)
  },
  // AS-IS L2044/L2059 cellTypeImage (popup)
  {
    key: 'ITEM_ID',
    header: 'Model',
    width: 110,
    align: 'C',
    _ctrlType: 'FPModal',
    _inputEditType: 'IM',
    _modalKey: 'ITEM',
  },
  // AS-IS L2029/L2055 SetCellTypeCombo(dtincotermsEditType)
  {
    key: 'INCOTERMS',
    header: 'Incoterms',
    width: 70,
    align: 'C',
    _ctrlType: 'FPComboBox',
    _inputEditType: 'IM',
    _comboKey: 'Incoterms',
  },
  // AS-IS BP_FCST_TYPE — UI Category CELL_COMBO_DATA_TYPE = 'FCST_TYPE_NOT_FREE' (AS-IS UP_FX_GetCommonDataList)
  {
    key: 'FCST_TYPE',
    header: 'FCST Type',
    width: 80,
    align: 'C',
    _ctrlType: 'FPComboBox',
    _inputEditType: 'IM',
    _comboKey: 'FCST_TYPE_NOT_FREE', // UI Category CELL_COMBO_DATA_TYPE 정합 (fallback)
  },
  // AS-IS DOM/EXP — UI Category CELL_COMBO_DATA_TYPE = 'DOM_EXP' (AS-IS UP_FX_GetCommonDataList LOOKUP_TYPE='DOM/EXP')
  {
    key: 'DOM_EXP',
    header: 'DOM/EXP',
    width: 110,
    align: 'C',
    _ctrlType: 'FPComboBox',
    _inputEditType: 'IM',
    _comboKey: 'DOM_EXP', // UI Category CELL_COMBO_DATA_TYPE 정합 (fallback)
  },
  // AS-IS 미등록 — text 입력
  {
    key: 'PLANT_SITE_ID',
    header: 'Plant Site',
    width: 90,
    align: 'C',
    _ctrlType: 'FPText',
    _inputEditType: 'IM',
  },
  // AS-IS L2047주석 (Currency Combo 비활성) — CMBO_SQL_M 'CurrencyList' 등록되어 있어 dropdown 활용
  {
    key: 'CURRENCY',
    header: 'Currency',
    width: 80,
    align: 'C',
    _ctrlType: 'FPComboBox',
    _inputEditType: 'IM',
    _comboKey: 'CurrencyList',
  },
  // AS-IS 미등록 — 'Y'/'N' 옵션
  {
    key: 'PRICE_EXIST',
    header: 'Price Exist',
    width: 90,
    align: 'C',
    _ctrlType: 'FPText',
    _inputEditType: 'IO',
  },
  // AS-IS L2074 SetText(RTF/KRW/USD/LOC) + L2104 LockRange2(true)
  {
    key: 'MEASURE',
    header: 'Measure',
    width: 90,
    align: 'C',
    _ctrlType: 'FPText',
    _inputEditType: 'S',
  },
];

// AS-IS Measure 4종 (DMF0020 Sales Price SHEET_MEASURE 등록값)
// 순서: RTF, KRW, USD, LOC (사용자 명시 2026-06-03)
// LOC row 만 dynamic cell editable (AS-IS .cs L2108)
export const MEASURE_4 = ['RTF', 'KRW', 'USD', 'LOC'] as const;
export type Measure4 = (typeof MEASURE_4)[number];

// ============================================================================
// Grid cascade (AS-IS spdMain_ComboSelChange L2612~2757 1:1, 2026-07-03)
// ============================================================================

// 셀 콤보 후보 좁히기는 화면 코드가 아니라 관리자 컬럼 메타가 전담한다 (2026-09-01 사용자 확정).
//   PARAM10='D'  : 그 행의 값을 콤보 SQL 파라미터로 실어 조합마다 재조회 (PARAM2 오른쪽 = 바인드명).
//   PARAM10 미지정: 콤보 전량을 받아 행 값으로 필터 (PARAM2 오른쪽 = 콤보 결과 컬럼명).
//   양쪽 다 공용 DataGrid(useRowParamCombos + foundation columnMapping)가 처리하므로 여기에
//   화면 전용 cascade 표를 두지 않는다. 구 GRID_CASCADE_FILTERS (DEPT_ID / END_CUSTOMER /
//   SCM_SITE_ID 3건) 는 그 메타로 대체돼 제거됨 — 되살리지 말 것. 좁힘 조건이 틀리면 admin
//   컬럼 메타의 PARAM2/PARAM10 을 고친다.

// ============================================================================
// Team / End Customer 자동 매핑 (2026-09-08 — 사용자 요구: 직접 입력 불가 + 기준정보 파생)
// ============================================================================
//   기준 = Business Plan(DMF0042) 의 "입력 불가 컬럼 + 파생 채움" 패턴 재사용:
//     · business-plan.editLock.ts insertStaticEditable → DEPT_ID40/END_CUSTOMER40 = false 반환
//     · BusinessPlanModals ITEM 콜백이 SCM_MST_SITE_ITEM.DEPT_ID 를 그룹에 채움
//     · business-plan.constants.ts GRID_CASCADE_CLEAR.SCM_SITE_ID40 이 파생 필드 동반 clear
//   Sales Price 매핑 기준 (Business Plan 과 방향이 다름 — 사용자 확정):
//     · End Customer : Sales Site           → SCM_MST_SITE.END_CUSTOMER
//                      (기존 콤보 'SiteEndCustomerMapDMF0082' 재사용 — division→SCM_SITE_ID:END_CUSTOMER,
//                       (DIV,SITE) 1:1 실측 0중복. Sales Site 콤보 변경 즉시 파생)
//     · Team        : Sales Site + Project + Item(Model) → SCM_MST_SITE_ITEM.DEPT_ID
//                      (Model 팝업 COM0008(ItemByDivisionModal) 반환 DEPT_ID 재사용 — 팝업이
//                       클릭 행의 Sales Site + Project 로 이미 필터되어 있어 (Site+Project+Item) 기준 팀)
//   신규 API/SP/SQL 없음. FE 전용.
export const SITE_EC_COMBO_ID = 'SiteEndCustomerMapDMF0082' as const;

// 사용자가 직접 입력할 수 없는 자동 매핑 컬럼 — Grid beginningEdit/pastingCell 차단 + formatItem 노랑 제외.
export const AUTO_MAPPED_COLUMNS = ['DEPT_ID', 'END_CUSTOMER'] as const;

// 상위 값 변경 시 하위 셀 계단식 clear.
//   2026-09-08 cascade 방향 반전: Team/End Customer 가 사용자 입력 콤보였으나 자동 파생 leaf 로 전환.
//   입력 체인 = Division → Sales Site → Project → Model. End Customer 는 Sales Site 에서,
//   Team 은 (Sales Site + Project + Model) 에서 파생되므로 상위가 흔들리면 함께 비운다.
//   (구 AS-IS spdMain_ComboSelChange 체인은 Team→EndCustomer→Site 순서였다 — 반전 전 이력.)
const CLEAR_ITEM = ['ITEM_ID', 'ITEM_NAME', 'ITEM_CLASS_NAME', 'NICK_NAME'] as const;
const CLEAR_PROJECT_ITEM = [
  'PROJECT_CODE',
  'PROJECT_NAME',
  'PROJECT_STATUS',
  'BIZ_TYPE_NAME',
  ...CLEAR_ITEM,
] as const;
export const GRID_CASCADE_CLEAR: Record<string, readonly string[]> = {
  // Division 변경은 부모(SalesFuturePrice.tsx)가 신규행 전체 제거로 처리 — 방어적으로 유지.
  DIVISION_ID: ['SCM_SITE_ID', 'END_CUSTOMER', ...CLEAR_PROJECT_ITEM, 'DEPT_ID'],
  // Sales Site 변경 → End Customer 재파생(Grid cellEditEnded 핸들러) + Project/Model/Team 무효화.
  SCM_SITE_ID: ['END_CUSTOMER', ...CLEAR_PROJECT_ITEM, 'DEPT_ID'],
  // Project 변경 → Model·Team 무효화 (Project 팝업 콜백도 동일 처리 — 팝업은 cellEditEnded 미경유).
  PROJECT_CODE: [...CLEAR_ITEM, 'DEPT_ID'],
  // Model 변경 → Team 무효화 (Model 팝업이 반환 DEPT_ID 로 즉시 재매핑).
  ITEM_ID: ['DEPT_ID'],
};

// ExchangeRate POPUP — AS-IS DMF0020_SalesFuturePricePopUp.cs L141~194 InitSpread() 정밀 매핑
//   AS-IS L146/147/148: AddComboColumn(Division=120/Currency=70/Unit=50) Freeze through UNIT_CURRENCY
//   사용자 명시 (2026-06-03 v3) — 캡쳐 Doc/ui_cap/DMF0020_Exchang_rate.png 1:1 재현
export const EXCHANGE_RATE_COLUMNS: MainColumnMeta[] = [
  {
    key: 'DIVISION_ID',
    header: 'Div',
    width: 120,
    align: 'C',
    _ctrlType: 'FPText',
    _inputEditType: 'S',
  },
  {
    key: 'CURRENCY',
    header: 'Currency',
    width: 70,
    align: 'C',
    _ctrlType: 'FPText',
    _inputEditType: 'S',
  },
  {
    key: 'UNIT_CURRENCY',
    header: 'Unit',
    width: 50,
    align: 'C',
    _ctrlType: 'FPText',
    _inputEditType: 'S',
  },
];

// 좌측 Freeze 해제 (사용자 요구 2026-06-03)
export const FROZEN_COL_COUNT = 0;

// 그룹 동시 선택 — Measure 제외 11개 키 (As-Is .cs RowSpan + 사용자 캡쳐)
export const GROUP_COLS = [
  'DIVISION_ID',
  'TEAM_INCHARGE',
  'END_CUSTOMER',
  'SCM_SITE_ID',
  'ITEM_ID',
  'INCOTERMS',
  'FCST_TYPE',
  'DOM_EXP',
  'CURRENCY',
] as const;

// AS-IS Validation MSG ID 매핑 (validation.md 71건):
//   - MSG00002 [{}] 은 필수 입력사항입니다.
//   - MSG00001 저장하시겠습니까? (2026-07-02 MSG_M 명칭 재지정 — 구 MSG00004 는 "수정한 내용이 없습니다."로 용도 변경)
//   - MSG00043 저장시 중복 오류가 발생하였습니다.{0}
//   - MSG00097 Division 을 선택하세요.
//   - MSG00108 조회된 데이터가 없습니다 (기간 역전 시).
//   - MSG00113 복사할 데이터를 선택하세요.
//   - MSG00135/00408 수정모드에서는 입력할 수 없습니다.
//   - MSG00137 필수 컬럼을 입력하세요.
//   - MSG00142 (편집 잠금 해제 필요)
//   - MSG00227/00255/00265/00283/00412/00414/00447/00448 기타 미등록 메시지
export const MSG = {
  REQUIRED_FIELD: 'MSG00002',
  CONFIRM_SAVE: 'MSG00001',
  DUPLICATE: 'MSG00043',
  REQUIRE_DIVISION: 'MSG00097',
  NO_DATA: 'MSG00108',
  SELECT_COPY_ROW: 'MSG00113',
  EDIT_LOCK_REQUIRED: 'MSG00135',
  REQUIRED_COLUMN: 'MSG00137',
  EXCHANGE_LOCK: 'MSG00142',
  BATCH_RESULT: 'MSG00143',
  MULTI_VERSION: 'MSG00255',
  EXCEL_UPLOAD_RESULT: 'MSG00265',
  REQUIRE_VERSION: 'MSG00283',
  EDIT_MODE_LOCK: 'MSG00408',
  PRICE_EXIST_MISSING: 'MSG00412',
  SAVE_DIVISION_40: 'MSG00414',
  CURRENCY_EMPTY: 'MSG00447',
  EDIT_NOT_CURRENT_VER: 'MSG00448',
  INSERT_ONLY_BUCKET: 'MSG00227',
  NO_CHANGES: 'MSG00004',
} as const;

// ====================================================================================
// 조회조건 cascade 콤보 ID (SCM_ADM_CMBO_SQL_M)
// ====================================================================================
// 단계마다 콤보를 따로 조회하고 클라이언트에서 서로 필터링하던 카탈로그 방식(SearchFields)을
// 접고, 상위부터 하위까지 한 행에 다 들어간 조인 콤보 1건만 조회한다. 한 SQL 결과라 모든 행에
// 모든 단계 컬럼이 차 있어 strict / 관대 판단 자체가 없어진다. 값은 MktFcst(DMF0003)와 같은
// 등록 ID 이며 컬럼 규약도 같다 - 자세한 내용은 CascadeFields.tsx 헤더 참조.

// Div - Team - End Customer - Sales Site.
export const SEARCH_CASCADE_COMBO_ID = 'SalesSite';

// Div - Team - End Customer - Plant Site. Plant Site 는 Sales Site 의 하위가 아니라
// End Customer 에서 나란히 갈라지는 별개 가지라 콤보도 따로 등록돼 있다.
export const PLANT_SITE_CASCADE_COMBO_ID = 'PlantSite';

// Div - Biz Type 2단. 종전 이 화면의 BizTypeField 는 전역 lookup('BizType')을 Division 구분
// 없이 그대로 보여줬다 - 이 콤보로 바꾸면 Division 에 해당하는 Biz Type 만 나온다.
export const BIZ_TYPE_CASCADE_COMBO_ID = 'DivBizType';
