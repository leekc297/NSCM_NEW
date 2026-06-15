export const MENU_ID = 'DMF0048' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS DMF0048_SalesMonitoring.cs (2,181줄, Forms.UIL/Plan 정본) + .Designer.cs:
//   - 메인 그리드 SP : PKG_DMF0048.P_DMF0048_GET_DM_PLN_SALES_MONITORING (22 IN + 3 OUT cursor — O_RC1/O_RC2/O_RESULT_CURSOR)
//   - 컬럼 헤더 SP  : PKG_DMF0048.P_DMF0048_GET_SPREAD_TITLE         (5 IN — 동적 W_/M_/D_ 컬럼)
//   - 21 Event / 2 PKG SP + 콤보 7종 + 공통 4 / Validation 23 / Expression 7 (SUM 헤더 5 + 합계 변수 2)
//   - Sheet 1 (단일 — shtMain 'Sales Monitoring')
//   - 분석서: Doc/_analysis/domain_DM/screens/DMF0048_SalesMonitoring/ (8 MD)
//   - 자매 reference: DMF0020 SalesFuturePrice (동적 헤더 + PIVOT 패턴)
//   - 메뉴: Demand > Demand Plan > Sales Monitoring (UPPR_MNU_ID='Demand_Plan')
//
// 조회 전용 (read-only) — F-key:
//   F5 Search / F12 Excel  (CRUD 의 F7/F8/F9 X)
//   F3 Sort (자동) / F4 Filter (자동) / F6 Condition (false — 패널 없음) / F10 Reset (false)
export enum SHEETS {
  MAIN = 'main',                         // 메인 그리드 — wide format (동적 W_/M_/D_ 컬럼)
  SPREAD_TITLE = 'spreadTitle',          // P_DMF0048_GET_SPREAD_TITLE 동적 컬럼 메타
}

export enum RESPONSE_SET {
  MAIN = 'o_rc1',           // 메인 데이터 (PIVOT 결과)
  MAIN_META = 'o_rc2',      // ISO_WEEK / BASIS_DATE / BASIS_YYYYMM / THIS_YYYYMMWW / PRE_YYYYMMWW (색상 표시용)
  SPREAD_TITLE = 'o_rc1',
}

// Bucket Type — AS-IS .cs cboBucketType (Daily / Weekly / Monthly)
export enum BUCKET_TYPE {
  DAILY = 'DAILY',
  WEEKLY = 'WEEKLY',
  MONTHLY = 'MONTHLY',
}

// Division 분기 (AS-IS .cs L338 / L1855 — sDivision=='40' 별도 처리):
//   40 : Mobility & IT Battery — Project / PlantSite 비활성
//   81 : ESS Battery — PlantSite 추가 콤보
//   기타: 통상 처리
export const DIVISION = {
  MOBILITY: '40',
  ESS: '81',
  POWER: '82',
} as const;

// Column 메타 (룰 12 §11.7 — 조회 전용은 모두 'S' read-only):
export interface MainColumnMeta {
  key: string;
  header: string;
  width?: number;
  align?: 'L' | 'C' | 'R';
  format?: string;
  visible?: boolean;
  merge?: boolean;          // SmartColMerge — AS-IS .cs L739
  freeze?: boolean;
  _ctrlType?: 'FPText' | 'FPNumber' | 'FPModal';
  _inputEditType?: 'S';     // 조회 전용 — 모두 read-only
  _modalKey?: string;        // PROJECT/ITEM popup (조회 후 더블클릭 트리거)
}

// AS-IS DefColumns (Main 19 + 추가 32 = 51 cols) 정확 매핑.
// 조회 전용 — 모두 read-only (_inputEditType: 'S').
// PROJECT_CODE / ITEM_ID 는 cellTypeImage popup 이지만 조회 후 더블클릭으로 상세보기만.
export const MAIN_COLUMNS: MainColumnMeta[] = [
  // === Main 19 cols (AS-IS DefColumns) ===
  { key: 'Column1',        header: '',                 width: 30,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'Column2',        header: '',                 width: 30,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'Column3',        header: '',                 width: 30,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'DIVISION_ID',    header: 'Div',              width: 60,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'DEPT_ID',        header: 'Dept ID',          width: 80,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true, visible: false },
  { key: 'DEPT_NAME_KO',   header: 'Department',       width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'TEAM_ID',        header: 'Team ID',          width: 80,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true, visible: false },
  { key: 'TEAM_NAME_KO',   header: 'Team',             width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'END_CUSTOMER',   header: 'Customer',         width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'BIZ_TYPE',       header: 'Biz.Type Code',    width: 80,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true, visible: false },
  { key: 'BIZ_TYPE_NAME',  header: 'Biz.Type',         width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'SCM_SITE_ID',    header: 'Sales Site',       width: 90,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'PLANT_SITE_ID',  header: 'Plant Site',       width: 90,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'PLANT_SITE_ID2', header: 'Plant Site 2',     width: 90,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true, visible: false },
  { key: 'PROJECT_CODE',   header: 'Project',          width: 100, align: 'C', _ctrlType: 'FPModal', _inputEditType: 'S', merge: true, _modalKey: 'PROJECT' },
  { key: 'PROJECT_NAME',   header: 'Project Name',     width: 150, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'ITEM_ID',        header: 'Model',            width: 120, align: 'C', _ctrlType: 'FPModal', _inputEditType: 'S', merge: true, _modalKey: 'ITEM' },
  { key: 'ITEM_CLASS_NAME',header: 'Item Class',       width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },
  { key: 'ITEM_NAME',      header: 'Item Name',        width: 150, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },

  // === [C20200513-000276] Sales Company, Sales Plant 추가 (16 cols) ===
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
  { key: 'QTY',               header: 'Qty',             width: 80,  align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'S', format: 'n0', visible: false },
  { key: 'CURRENCY',          header: 'Currency',        width: 70,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'SALES_PLAN_ADJUST_YN', header: 'Adjust YN',    width: 70,  align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'TEAM_INCHARGE',     header: 'Team Incharge',   width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true },

  // === UPPER_DEPT_ID (1 col) ===
  { key: 'UPPER_DEPT_ID',     header: 'Upper Dept',      width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S', merge: true, visible: false },

  // === [PJ20200138] (4 cols) Project Name / Distribution / Cell Name / Shipment Site ===
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
];

// Frozen 컬럼 — DIVISION_ID 까지 (좌측 메타 영역 고정 — 룰 12 §11.5 PIVOT frozenColumns)
export const FROZEN_COL_COUNT = 4;

// AS-IS Validation MSG ID 매핑 (validation.md 23건):
//   - MSG00097 Division 을 선택하세요.
//   - MSG00108 조회된 데이터가 없습니다 (기간 역전 시).
//   - MSG00137 필수 컬럼을 입력하세요. (또는 동시 작업 잠금)
//   - MSG00164 (미등록) — 기간 3년 초과 시
//   - MSG00227 (미등록) — Insert flag 'I' 행 BucketType 변경 차단
export const MSG = {
  REQUIRE_DIVISION:     'MSG00097',
  NO_DATA:              'MSG00108',
  REQUIRED_COLUMN:      'MSG00137',
  PERIOD_OVER_3YEARS:   'MSG00164',
  INSERT_ONLY_BUCKET:   'MSG00227',
} as const;
