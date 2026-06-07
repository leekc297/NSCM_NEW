export const MENU_ID = 'DMF0003' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS DMF0003_1_MktFcst.cs (7,056줄, GSCM.DM.Plan.UIL 메인 1순위) + .Designer.cs (2,750줄):
//   - 3 변형: _MktFcst (원본 deprecated) / _1_MktFcst (메인) / _T_MktFcst (성능 fork)
//   - 사용자 결정 옵션 B: 메인 `_1_` 만 신규 + `_T_` 성능 통합 + `_M_` deprecated
//   - 메인 GET SP : SCM_MGR.DMF0003_GET_MKT_FCST_DATA (standalone, 22 IN + 4 OUT cursor)
//                 archive line 1546~5745 (4,200 lines) - To-be_v2_converted 변환 완료
//   - 메인 SAVE SP: SCM_MGR.DMF0003_SAVE_MKT_FCST (standalone, archive line 8332~10549, 2,218 lines)
//   - 36 Event handler (+6 보조 핸들러) / 23 호출 SP / 154 Validation / 117 Expression / 16 Button
//   - 70 Grid 컬럼 (Main 43 fixed + 동적 PIVOT 50~100 + ESS 추가 13 + 수정불가 14)
//   - 9 호출 POPUP (공용 4: Column/Project/Item/Owner + 전용 5: MasterChg/PR/PRHistory/SspSync/SspSyncCompare)
//                + deprecated 1 (CustDemandAnalysis) + 공용 대용 1 (VersionCutOff)
//   - 분석서: Doc/_analysis/domain_DM/screens/DMF0003_1_MktFcst/ (8 MD 완비)
//   - 메타  : _artifacts/_deploy_packages/DMF0003/03_META/010_DMF0003_Registration*.sql (7-BLOCK)
//
// Phase 1 범위: 메인 grid 43 fixed cols 단순 조회 (PIVOT 컬럼 + Sub-Grid 는 Phase 2~7)
export enum SHEETS {
  MAIN = 'main',              // 메인 그리드 (43 fixed + 동적 PIVOT)
  PSI = 'psi',                // Phase 4 — spdSub1 PSI 분석 sub-grid (3 sheets: Mkt Fcst / PSI / Car Fcst)
  CAR_FCST = 'carFcst',       // Phase 4 — spdSub2 Car Forecast sub-grid
  SPREAD_TITLE = 'spreadTitle',         // Phase 3 — 동적 컬럼 메타 (Bucket D/W/M)
  SPREAD_TITLE_PSI = 'spreadTitlePsi',  // Phase 4
  SPREAD_TITLE_CAR = 'spreadTitleCar',  // Phase 4
  // Phase 5 — POPUP 5종 sheet
  MASTER_CHG = 'masterChg',
  PR_POPUP = 'prPopup',
  PR_HISTORY = 'prHistory',
  SSP_SYNC = 'sspSync',
  SSP_SYNC_COMPARE = 'sspSyncCompare',
}

export enum RESPONSE_SET {
  MAIN = 'o_rc1',                    // 메인 grid 데이터
  MAIN_8WEEK = 'o_rc2',              // 8주 이내 bucket 정보 (Div 40)
  MAIN_CURRENT_WEEK = 'o_rc3',       // 현재 주차 정보 (Div 40)
  PSI = 'o_rc1',
  CAR_FCST = 'o_rc1',
  SPREAD_TITLE = 'o_rc1',
  SPREAD_TITLE_PSI = 'o_rc1',
  SPREAD_TITLE_CAR = 'o_rc1',
  MASTER_CHG = 'o_rc1',
  PR_POPUP = 'o_rc1',
  PR_HISTORY = 'o_rc1',
  SSP_SYNC = 'o_rc1',
  SSP_SYNC_COMPARE = 'o_rc1',
}

// AS-IS Bucket Type (analysis MD §1.4 cboBucketType — DMF0003_GET_BUCKET_TYPE_CODE 동적 lookup):
//   D : Daily (일별)
//   W : Weekly (주별, Div 40 default)
//   M : Monthly (월별)
export enum BUCKET_TYPE {
  DAILY = 'D',
  WEEKLY = 'W',
  MONTHLY = 'M',
}

// AS-IS Division 3-way 분기 (validation.md 154건 중 사업부 분기 114건):
//   40 : Mobility & IT Battery — 8주 관리 + W_tag column editable + Customer40 / Site40 사용
//   81 : ESS Battery — PLANT_SITE_ID 필수 + NewFlag 컬럼 추가 (v2020.07) + VMI 관리
//   82 : Automotive Battery — JV Planner 권한 + INCOTERMS 권한 정리 (v2021-11)
export const DIVISION = {
  MOBILITY: '40',
  ESS: '81',
  AUTOMOTIVE: '82',
} as const;
export type DivisionCode = typeof DIVISION[keyof typeof DIVISION];

// Column 메타 (룰 12 §11.7 + hook grid-column-meta-mandatory):
//   _ctrlType    : FPText / FPModal / FPComboBox / FPCheckBox / FPDate / FPNumber
//   _inputEditType: S (read-only) / M (필수) / O (선택) / IM (신규 필수) / IO (신규 선택)
//   _modalKey    : popup cell modal 식별자 (dblClick switch key)
//   _comboKey    : lookup combo 식별자
export interface MainColumnMeta {
  key: string;
  header: string;
  width?: number;
  align?: 'L' | 'C' | 'R';
  format?: string;
  visible?: boolean;
  merge?: boolean;
  freeze?: boolean;
  _ctrlType?: 'FPText' | 'FPModal' | 'FPComboBox' | 'FPCheckBox' | 'FPDate' | 'FPNumber';
  _inputEditType?: 'S' | 'M' | 'O' | 'IM' | 'IO';
  _modalKey?: string;
  _comboKey?: string;
}

// AS-IS 화면 visible Column 13개 (사용자 명시 요구 2026-06-07):
//   Div / End Customer / Sales Site / Project Code / zproject / Project Owner / Model
//   Nick name / Incoterms / Fcst Type / Customs Handbook / Plant Site / Measure
//
// AS-IS DMF0003_1_MktFcst.cs L1847 InsertRow + L1880~1951 cellTypeImage / SetCellTypeCombo 분석:
//   - Project / Item : cellTypeImage (popup) → _ctrlType='FPModal' + _modalKey
//   - End Customer / Sales Site / DomExp / PlantSiteId / FcstType / Incoterms / Measure : SetCellTypeCombo → FPComboBox + _comboKey
//   - Project Code Name / Project Owner / Nick Name : popup 결과 자동 채움 (auto-derive)
//   - _inputEditType: 'IM' (신규 row 필수) / 'IO' (신규 row 선택) / 'S' (read-only)
export const MAIN_COLUMNS: MainColumnMeta[] = [
  { key: 'DIVISION_ID',       header: 'Div',              width:  70, align: 'C', freeze: true,  _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'END_CUSTOMER',      header: 'End Customer',     width: 110, align: 'L', _ctrlType: 'FPComboBox', _inputEditType: 'IM', _comboKey: 'EndCustomer' },
  { key: 'SCM_SITE_ID',       header: 'Sales Site',       width: 100, align: 'C', _ctrlType: 'FPComboBox', _inputEditType: 'IM', _comboKey: 'SiteByEndCustomer' },
  { key: 'PROJECT_CODE',      header: 'Project Code',     width: 110, align: 'L', _ctrlType: 'FPModal',    _inputEditType: 'IM', _modalKey: 'ProjectByDivision' },
  { key: 'PROJECT_CODE_NAME', header: 'zproject',         width: 140, align: 'L', _ctrlType: 'FPText',     _inputEditType: 'S' },
  { key: 'PROJECT_OWNER',     header: 'Project Owner',    width: 110, align: 'L', _ctrlType: 'FPText',     _inputEditType: 'S' },
  { key: 'ITEM_ID',           header: 'Model',            width: 140, align: 'L', _ctrlType: 'FPModal',    _inputEditType: 'IM', _modalKey: 'ItemByDivision' },
  { key: 'NICK_NAME',         header: 'Nick Name',        width: 120, align: 'L', _ctrlType: 'FPText',     _inputEditType: 'S' },
  { key: 'INCOTERMS',         header: 'Incoterms',        width:  90, align: 'C', _ctrlType: 'FPComboBox', _inputEditType: 'IM', _comboKey: 'Incoterms' },
  { key: 'FCST_TYPE',         header: 'Fcst Type',        width:  90, align: 'C', _ctrlType: 'FPComboBox', _inputEditType: 'IM', _comboKey: 'FcstType' },
  { key: 'DOM_EXP',           header: 'Customs Handbook', width: 130, align: 'C', _ctrlType: 'FPComboBox', _inputEditType: 'IO', _comboKey: 'CustomsHandbook' },
  { key: 'PLANT_SITE_ID',     header: 'Plant Site',       width: 100, align: 'C', _ctrlType: 'FPComboBox', _inputEditType: 'IO', _comboKey: 'PlantSite' },
  { key: 'MEASURE',           header: 'Measure',          width: 110, align: 'C', _ctrlType: 'FPComboBox', _inputEditType: 'IM', _comboKey: 'Measure' },
  // 비표시 (visible:false) — AS-IS 화면에서 안 보이는 columns
  { key: 'DEPT_ID',           header: 'Dept ID',          width:  80, align: 'C', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'DEPT_NAME_KO',      header: 'Dept Name',        width: 120, align: 'L', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'TEAM_ID',           header: 'Team ID',          width:  80, align: 'C', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'TEAM_NAME_KO',      header: 'Team Name',        width: 120, align: 'L', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'BIZ_TYPE',          header: 'Biz Type',         width:  90, align: 'C', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'PROJECT_NAME',      header: 'Project Name',     width: 140, align: 'L', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'ITEM_NAME',         header: 'Item Name',        width: 160, align: 'L', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'ITEM_TYPE',         header: 'Item Type',        width:  90, align: 'C', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'PROJECT_STATUS',    header: 'Project Status',   width: 110, align: 'C', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'OWNER',             header: 'Owner',            width: 110, align: 'L', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'SOLD_TO_CUSTOMER',  header: 'Sold-to',          width: 110, align: 'L', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'CELL_TYPE',         header: 'Cell Type',        width:  90, align: 'C', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'CITY',              header: 'City Code',        width:  90, align: 'C', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'CITY_NAME',         header: 'City Name',        width: 120, align: 'L', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'COUNTRY',           header: 'Country Code',     width:  90, align: 'C', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'COUNTRY_NAME',      header: 'Country Name',     width: 120, align: 'L', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'EDIT_FLAG',         header: 'Edit Flag',        width:  80, align: 'C', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'MEASURE_GROUP',     header: 'Measure Group',    width: 110, align: 'C', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'YYYYMMDD',          header: 'Date',             width:  90, align: 'C', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'QTY',               header: 'Qty',              width: 100, align: 'R', visible: false, _ctrlType: 'FPNumber', _inputEditType: 'O' },
  { key: 'VMI_YN',            header: 'VMI Y/N',          width:  80, align: 'C', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
];

// 좌측 Freeze count (5 fixed cols: Division/Dept/DeptName/Team/TeamName)
export const FROZEN_COL_COUNT = 5;

// AS-IS Validation MSG ID 카탈로그 (validation.md 154건 중 Top 20):
//   - 사업부 분기 114건 (Division 40/81/82 별 column visibility/lock)
//   - GMessageBox 20건 (필수값 / Period 검증 / 중복 / SAVE 확인)
//   - MessageBox.Show 12건 (셀 선택 / Model 중복)
//   - 사전검증 분기 10건 (early return)
//   - Date Range 4건 (기간 연속성)
//   - 중복 체크 3건 / 숫자 검증 1건
export const MSG = {
  REQUIRED_FIELD:       'MSG00002',  // {} 은 필수 입력사항입니다.
  CONFIRM_SAVE:         'MSG00004',  // 저장하시겠습니까?
  REQUIRE_DIVISION:     'MSG00097',  // Division 을 선택하세요.
  NO_DATA:              'MSG00108',  // 조회된 데이터가 없습니다. (Period 역전)
  SELECT_COPY_ROW:      'MSG00113',  // 복사할 데이터를 선택하세요.
  PERIOD_OVER_3YEARS:   'MSG00164',  // (Period 3년 초과)
  EDIT_AFTER_SEARCH:    'MSG00259',  // 조회 후 수정모드로 가능
  DUPLICATE_NEW:        'MSG00260',  // 신규 데이터 중 중복
  QTY_LESS_THAN_RP:     'MSG00225',  // 실적 이상의 수량 불가
  REQUIRED_QTY:         'MSG00034',  // 일자 입력 검증
  DUPLICATE_SAVE:       'MSG00043',  // 저장 시 중복 오류
  AS_FROM_SITE_ALL:     'MSG00366',  // (AS From Site 'ALL' 처리)
} as const;
