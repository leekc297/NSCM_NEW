export const MENU_ID = 'DMF0042' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS DMF0042_1_BizPlan.cs (Demand > Demand Plan > Business Plan / 사업계획 — 3,477줄 정본 채택,
//   5벌 병존 중 _1 = CELL_PER_CAR/MODULE_PER_CAR/UNIT_ENERGY 최신 + ExchangeRatePopup 배선):
//   - 메인 그리드 : PIVOT wide format (정적 63컬럼 admin 메타 + 기간 동적 Y_/Q_/M_ 3단 헤더 — 분기 축 TO-BE 최초)
//   - 분석서      : Doc/_analysis/domain_DM/screens/DMF0042_1_BizPlan/ (validation 99 / expressions 103)
//               + Doc/화면설계서/DMF0042_BizPlan_UI분석서_v1.0.xlsx + 상세동작_개발용.md (이벤트 28 전수)
//   - Division 3종(40 소형 / 81* 자동차 / 82 ESS) 단일 화면 — 81 계열 판정 = startsWith('81') 의무.
//   - 편집제어    : GADM 아님 — 조회 SP 가 세팅한 행 EDIT_FLAG=='Y' × Measure∈{Business_Plan, LOC}.
export enum SHEETS {
  MAIN = 'Biz Plan', // 메인 그리드 — SHEET_COLUMNS 63행 등록명 (룰 #91 sheet-name-asis-preserve. TITLESET 'bizPlan' 은 P3 rename)
  SPREAD_TITLE = 'spreadTitle', // 동적 3단 헤더 메타 (DMF0042_GET_SPREAD_TITLE — Y_yyyy / Q_yyyy_q / M_yyyymm)
  DAY_RANGE = 'dayRange', // 기본 조회구간 — PR_GET_DAY_RANGE 공유 (AS-IS GetDayRange p_month=7, o_rc2)
  TITLE_SET = 'titleSet', // Column/Measure Setting 영구 저장 (SCM0002_SET_TITLESET_POPUP 공유)
  EXCHANGE_RATE = 'exchangeRate', // 환율 모달 조회/저장 (DMF0042_GET_EXCHANGE_PRICE / SAVE_DM_BP_EXCHANGE_RATE)
  FUTURE_PRICE = 'futurePrice', // 환율정보 (DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP — P_CATE='BP')
  FUTURE_PRICE_DATA = 'futurePriceData', // 환율 모달 grid (DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA)
  CUTOFF_VERSION = 'cutoffVersion', // Ver. Cutoff 버전 목록 (DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION)
  MDF_VERSION = 'mdfVersion', // Replace 대상 버전 목록 (DMF0042_GET_DM_MDF_VERSION)
}

// ⭐ 컬럼 개인화(SCM_MST_TITLESET_USER) 구분값 — USER_INQUIRY_COLUMN_TYPE_CODE.
//   ⚠️ 팝업 조회(ColumnLayoutModal) · 저장(saveTitleSet) · 진입 복원(fetchUserColumnLayout) 이
//     **셋 다 같은 값**을 써야 한다. 하나라도 다르면 저장은 성공하는데 재진입 조회가 그 행을 못 찾아
//     개인화가 사라진다.
//   2026-07-29: 팝업이 SHEETS.MAIN('Biz Plan')으로 조회하고 저장은 'C' 로 하던 불일치를 교정
//     (실측 값 = 'C'(컬럼)/'M'(measure). forecast-price 2026-07-27 / sales-monitoring 2026-07-04 동일 사고).
export const TITLESET_COLUMN_TYPE = 'C';
export const TITLESET_MEASURE_TYPE = 'M';

// Bucket Type — AS-IS cboBucketType (BUCKET2_TYPE_CODE — Monthly/Quarterly/Yearly). 기본 Monthly.
//   ⚠ DMF0082(D/W/M)·DMF0021(D/W/M) 과 버킷 축이 다름 — 분기(Q)/연(Y) 축은 TO-BE 최초 (상세동작 md 헤더).
export enum BUCKET_TYPE {
  MONTHLY = 'M',
  QUARTERLY = 'Q',
  YEARLY = 'Y',
}

// SP 전송용 full-word 변환 (AS-IS cboBucketType.ControlValues 1:1 — BUCKET2_TYPE_CODE lookup CODE)
export const BUCKET_WORD: Record<BUCKET_TYPE, string> = {
  [BUCKET_TYPE.MONTHLY]: 'MONTHLY',
  [BUCKET_TYPE.QUARTERLY]: 'QUARTERLY',
  [BUCKET_TYPE.YEARLY]: 'YEARLY',
};

// Division 분기 (UI분석서 실측): 40=소형(IT) / 81 계열(81/81_UC/81_HM/81_ST/81_HD/81_HG)=자동차 / 82=ESS.
//   ⚠ 81 계열 판정은 divisionKindOf(business-plan.division.ts) 의 startsWith('81') — '===' 비교 금지.
export const DIVISION = {
  MOBILITY: '40',
  AUTOMOTIVE: '81',
  ESS: '82',
} as const;

// 편집(입력) 가능 Measure 2종 (AS-IS EditButton L646 — EDIT_FLAG=='Y' 행 × 아래 measure 만 수량영역 unlock.
//   KRW/USD/SalesAmt_*/CAR_QTY/MKT_FCST 는 SP 파생 산출 — FE 입력 금지, 상세동작 [14]·[24] ⚠).
export const EDIT_MEASURE = {
  BUSINESS_PLAN: 'Business_Plan',
  LOC: 'LOC',
} as const;

// Insert 행 Measure 블록 — AS-IS InsertRow L1159 `Insert(dtMeasure.Rows.Count)` : 한 키셋에
//   division별 measure 전 행 삽입 (CMBO 'DMF0042_BP_Measure' 원천 — 콤보 미적재 시 삽입 차단 MSG00113).
export const INSERT_MEASURE_COMBO_ID = 'DMF0042_BP_Measure' as const;

// 신규 행 초기 필드 (AS-IS InsertRow — DIVISION_ID 는 조회조건으로 세팅, 나머지 공란)
export const INSERT_ROW_DEFAULTS = {
  DEPT_ID: '',
  DEPT_ID40: '',
  END_CUSTOMER: '',
  END_CUSTOMER40: '',
  SCM_SITE_ID40: '',
  SCM_SITE_ID81: '',
  SCM_SITE_ID82: '',
  PROJECT_CODE: '',
  PROJECT_CODE82: '',
  PROJECT_NAME: '',
  ITEM_ID: '',
  ITEM_ID40: '',
  ITEM_CLASS_NAME: '',
  NICK_NAME: '',
  INCOTERMS: '',
  INCOTERMS82: '',
  FCST_TYPE: '',
  CELL_PROD_SITE: '',
  CURRENCY: '',
  PLANT_SITE_ID: '',
  ITEM_USE: '',
  UNIT_ENERGY: '',
} as const;

// ⭐ AS-IS Validation MSG ID 매핑 — 사내 SCM_ADM_MSG_M 실측 대사 (2026-07-15 확정 — P1 신규 채번 MSG00675~680 포함).
//   룰: MSG ID 는 실문구 대사 후 지정(fallback 신뢰 금지). 각 항목에 AS-IS 용법 주석.
export const MSG = {
  // Division 미선택 — "Division 을 선택하세요." (FindData L697)
  REQUIRE_DIVISION: 'MSG00097',
  // 기간 역전 — 시작일 > 종료일 (FindData L705)
  PERIOD_INVERTED: 'MSG00108',
  // 기간 6년 초과 — "조회 기간은 6년 이상 설정 할 수 없습니다." (FindData L711 AS-IS 00276 → P1 신설 677.
  //   종료일 = 시작일+6년 보정 후 차단)
  PERIOD_MAX_6YEAR: 'MSG00677',
  // 필수값 — "{0} 값은 필수 입력 항목입니다." (SaveData L912/943/967 AS-IS 00310 용법 → 사내 MSG00429 재매핑)
  REQUIRED_FIELD: 'MSG00429',
  // 필수 컬럼 부재 — (EditButton L548 · SaveData L810 MinColumnChk. Insert measure 콤보 0건 차단 겸용)
  REQUIRED_COLUMN: 'MSG00113',
  // Bucket 변경 차단 — "Insert 된 행이 있어 Bucket 을 변경할 수 없습니다." (cboBucketType_Click L2969)
  BUCKET_CHANGE_BLOCK: 'MSG00227',
  // 저장 중복 — "저장시 중복 오류가 발생하였습니다.{0}" (fnValidation L1093)
  DUPLICATE_KEY: 'MSG00043',
  // 저장 성공 — "성공적으로 저장되었습니다." (AS-IS MSG00004 {0}건 저장 용법 → 사내 MSG00002 재매핑)
  SAVED: 'MSG00002',
  // 변경 0건 — "수정한 내용이 없습니다."
  NO_CHANGES: 'MSG00004',
  // 저장 대상 0건 — "저장할 대상 데이터가 없습니다." (SaveData L1087 AS-IS 00275 → P1 신설 676)
  NO_SAVE_TARGET: 'MSG00676',
  // Business_Plan 정수 입력 — "Business Plan 데이터는 정수로 입력해 주세요." (spdMain_Changed L1853
  //   AS-IS 00289 → P1 신설 679. 소수부 절삭 후 안내)
  BP_INTEGER_ONLY: 'MSG00679',
  // Set Price 확인 — "변경된 환율을 적용하시겠습니까?" (btnSetPrice L3117 AS-IS 00282 → P1 신설 678)
  SET_PRICE_CONFIRM: 'MSG00678',
  // 실행 확인 공통 — "실행하시겠습니까?" (Ver. Cutoff 실행 전 confirm. 2026-08-08 사내 등록)
  EXECUTE_CONFIRM: 'MSG00033',
  // Ver. Cutoff 완료 — "Manual Cutoff가 완료되었습니다.[Division ID : {0}] {1}" (AS-IS 00151 → P1 신설 675)
  CUTOFF_DONE: 'MSG00675',
  // 변경 중 수행 불가 — (btnExchangeRate L2989 MSG00142 / btnCutOff·btnReplace 인라인 "Edit Mode is not
  //   allowed." → TO-BE 상시편집 = pending 변경 존재 시 차단. P1 신설 680)
  PENDING_BLOCK: 'MSG00680',
  // 저장 오류 공통 fallback — "저장 중 오류가 발생했습니다." (SP 원문 메시지 부재 시)
  SAVE_ERROR: 'MSG00618',
} as const;

// ============================================================================
// ⭐ Grid 내 cascade filter (hook #59 §5-G — AS-IS spdMain_ComboSelChange L1565~1596 40 전용 2키 대응).
//   콤보 편집 진입 시 같은 행의 상위 셀 값으로 콤보 후보를 클라 필터(dataMap 스왑, cellEditEnded 원복).
//   관대 통과(행 값·콤보 키 공란/'ALL' = 통과)라 키 미보유 콤보는 자동 전체 통과 — 값 유실 없음.
// ============================================================================
export const GRID_CASCADE_FILTERS: Record<string, { rowKey: string; comboKey: string }[]> = {
  DEPT_ID: [{ rowKey: 'DIVISION_ID', comboKey: 'DIVISION_ID' }],
  DEPT_ID40: [{ rowKey: 'DIVISION_ID', comboKey: 'DIVISION_ID' }],
  END_CUSTOMER: [
    { rowKey: 'DIVISION_ID', comboKey: 'DIVISION_ID' },
    { rowKey: 'DEPT_ID', comboKey: 'DEPT_ID' },
  ],
  // AS-IS L1577~1595 — DEPT_ID40 변경 시 END_CUSTOMER40 재설정 (EndCustomerByDivision40 원천)
  END_CUSTOMER40: [{ rowKey: 'DIVISION_ID', comboKey: 'DIVISION_ID' }],
  // AS-IS L1568~1576 — END_CUSTOMER40 변경 시 SCM_SITE_ID40(SiteByEndCustomer) 재조회
  SCM_SITE_ID40: [
    { rowKey: 'DIVISION_ID', comboKey: 'DIVISION_ID' },
    { rowKey: 'END_CUSTOMER40', comboKey: 'END_CUSTOMER' },
  ],
  PLANT_SITE_ID: [{ rowKey: 'DIVISION_ID', comboKey: 'DIVISION_ID' }],
};

// 상위 콤보 값 변경 시 하위 셀 clear 체인 — AS-IS ComboSelChange 는 콤보 재바인딩만 수행(값 clear 없음)
//   → 재바인딩은 cascade dataMap 스왑이 대체하므로 clear 대상 없음 (빈 정의 유지 = 메커니즘 보존).
export const GRID_CASCADE_CLEAR: Record<string, readonly string[]> = {};

// ============================================================================
// ⭐ Grid 편집 전용 콤보 (조회 표시 dataMap 과 별개 — 편집 진입 시 스왑, cellEditEnded 원복. hook #59 §5-G)
//   CURRENCY = 'CurrencyList' (AS-IS InsertRow CURRENCY_LIST L1184 — SHEET_COLUMNS 메타 콤보 미지정 컬럼)
// ============================================================================
export const GRID_EDIT_COMBO: Record<string, { comboId: string }> = {
  CURRENCY: { comboId: 'CurrencyList' },
  // ⭐ 2026-07-21 G9 — 40 신규행 CELL_PROD_SITE 편집 = 유효건(VALID_YN='Y')만 콤보
  //   (신정본 InsertRow L1274~1278 GetCellProdSite(...,"Y") [C20220513-000327]).
  //   조회 표시(코드→한글)는 SHEET_COLUMNS 메타 FPComboBox='DMF0042CellProdSite'(ALL) 가 담당
  //   ([E20240731-000845] InitSpread L392~397) — P7 SQL 와 반드시 세트 적용(원복 로직이 표시 dataMap 전제).
  CELL_PROD_SITE: { comboId: 'CellProdSiteValid' },
};

// Ver. Cutoff / Replace 버전 타입 고정값 (AS-IS LoadDataDiv "BP_M" — [27]/[28])
export const CUTOFF_VER_TYPE = 'BP_M' as const;

// Exchange Rate 모달 조회 카테고리 (AS-IS LoadData(..., "BP", division) — [26] P_CATE)
export const EXCHANGE_CATE = 'BP' as const;
