export const MENU_ID = 'DMF0003' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS DMF0003_MktFcst.cs (Demand > Demand Plan > MKT FCST / 시장예측):
//   - 메인 그리드 : PIVOT wide format (좌측 고정 10 + 기간 동적 PIVOT 2단 헤더)
//   - 분석서      : Doc/_analysis/domain_DM/screens/DMF0003_MktFcst/ (validation 152 / expressions 130)
//   - 디자인      : Doc/_figma/screens/DMF0003_MktFcst_LAYOUT.md
//   ⚠️ Phase 2 미검증 — SP 실제 응답 shape/메타는 BE 적재 후 확정 (DMF0020 구조 가정).
export enum SHEETS {
  MAIN = 'Mkt Fcst', // 메인 그리드 — wide format (동적 M_/W_/D_ 컬럼). 등록명 그대로(룰 #91 sheet-name-asis-preserve). corp handoff 42~45 가 BTN_MPG SHT_NM / SHEET_COLUMNS / SHEET_MEASURE / SP 를 'Mkt Fcst' 로 마이그레이션.
  SPREAD_TITLE = 'spreadTitle', // 동적 컬럼 메타 (기간 PIVOT 헤더)
  MEASURE_COUNT = 'measureCount', // Item 별 Measure 개수 (Insert RowSpan)
  // ⭐ Phase 2e POPUP sheet (DMF0003 내부 sheet 확장 — corp BTN_MPG handoff 37_*.sql).
  SSP_COMPARE = 'sspCompare', // SSP↔MKT 비교 (DMF0003_GET_MKT_FCST_COMPARE_POPUP)
  PR_POPUP = 'prPopup', // PR 발행/조회 (GET/SAVE_PRPOPUP)
  PR_HISTORY = 'prHistory', // PR 이력 (DMF0003_GET_PR_HISTORY_POPUP)
  // (PSI/Car/CustDemand sheet 9종 제거 — 2026-07-03 사용자 결정: 평문 AS-IS 에 상단 분석영역 없음.
  //  구현·DB 등록분은 _deploy_packages/DMF0003_PSI_20260703/ 보존, DB 메타는 무해 존치.)
}

// ⭐ contextMenu PR 트리거 measure (AS-IS .cs L5564/L5703 — BNP In measure 행 한정).
export const PR_MEASURE = 'BNPIn' as const;

// ⭐ 우클릭 PR 메뉴 4항목 — 표시명 i18n (격차④, LBL00740~743. AS-IS contextMenuStrip Text 1:1).
//   ⚠ 채번은 사내 SCM_ADM_MSG_M MAX(LBL) 실측 기준 (LBL00728~739 는 타 화면 선점 — 2026-07-03 충돌 회피).
export const PR_MENU_LABELS = [
  { name: 'Request_PR', lblKey: 'LBL00740', fallback: 'Request PR' },
  { name: 'View_PR', lblKey: 'LBL00741', fallback: 'View PR' },
  { name: 'Add_History', lblKey: 'LBL00742', fallback: 'Add History' },
  { name: 'View_History', lblKey: 'LBL00743', fallback: 'View History' },
] as const;
// ⭐ SSP 동기화 비교 popup 트리거 measure (AS-IS .cs L2628 — Div40 MKT_FCST_RP 동기화색 셀).
export const SSP_SYNC_MEASURE = 'MKT_FCST_RP' as const;

// const object — NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  SPREAD_TITLE: 'o_rc1',
  MEASURE_COUNT: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// ⭐ UI Category Setup(admin) SHEET_NAME = SHEETS.MAIN value('Mkt Fcst') 등록명 그대로.
//   사내 corp handoff 42~45 가 SHEET_COLUMNS / SHEET_MEASURE / BTN_MPG SHT_NM / GET·SAVE SP 의
//   SHEET_NAME 을 'Mkt Fcst' 로 일괄 마이그레이션(룰 #91 sheet-name-asis-preserve). 따라서 store 의
//   fetchStaticColumns/fetchStaticMeasures 는 sheetNm(=SHEETS.MAIN value) 을 직접 사용한다(별도 매핑 제거).
//   ⚠️ corp handoff 42~45 적용 전엔 화면이 'Mkt Fcst' 로 호출하나 BTN_MPG/메타가 아직 'main'이면
//      0행 — coordinated migration 의 의도된 과도기.

// Bucket Type — DMF0003_GET_BUCKET_TYPE_CODE (Daily / Weekly / Monthly)
export enum BUCKET_TYPE {
  DAILY = 'D',
  WEEKLY = 'W',
  MONTHLY = 'M',
}

// Division 분기 (AS-IS validation):
//   40 : Mobility & IT Battery (기본) / 81 : ESS Battery / 82 : Power Tool
export const DIVISION = {
  MOBILITY: '40',
  ESS: '81',
  POWER: '82',
} as const;

// Column 메타 (룰 12 §11.7 + grid-column-meta hook):
//   _ctrlType    : FPText/FPModal/FPComboBox/FPCheckBox/FPDate/FPDateTime/FPNumber
//   _inputEditType: S (read-only) / M (필수) / O (선택) / IM (신규 필수) / IO (신규 선택)
//   _modalKey    : popup cell modal 식별자 / _comboKey : lookup combo 식별자
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

// 좌측 고정 컬럼 (11) — DMF0003_MktFcst_LAYOUT.md §4.1 (+ITEM_NAME 2026-07-02 B5)
//   ⚠️ Phase 2 fallback 전용 — 정본은 admin SCM_MST_SHEET_COLUMNS 동적 fetch (fetchStaticColumns).
//   admin 메타 미등록 시 화면 작동 보장용 hardcode fallback.
export const MAIN_COLUMNS: MainColumnMeta[] = [
  {
    key: 'DIVISION_ID',
    header: 'Div',
    width: 70,
    align: 'C',
    _ctrlType: 'FPComboBox',
    _inputEditType: 'IM',
    _comboKey: 'MyDivision',
  },
  {
    key: 'END_CUSTOMER',
    header: 'End Customer',
    width: 110,
    align: 'C',
    merge: true,
    _ctrlType: 'FPComboBox',
    _inputEditType: 'IM',
    _comboKey: 'EndCustomer',
  },
  {
    key: 'SCM_SITE_ID',
    header: 'Sales Site',
    width: 100,
    align: 'C',
    merge: true,
    _ctrlType: 'FPComboBox',
    _inputEditType: 'IM',
    _comboKey: 'ScmSitebyEndCustomer40',
  },
  {
    key: 'ITEM_ID',
    header: 'Model',
    width: 110,
    align: 'C',
    _ctrlType: 'FPModal',
    _inputEditType: 'IM',
    _modalKey: 'ITEM',
  },
  {
    // ⭐ B5 (2026-07-02) — Model Name. 사내 SHEET_COLUMNS 실측(SORT 150, VISIBLE_FLAG='Y', IM) 정합.
    //   데이터는 SP V_COLUMN(사용자 TITLESET_USER 'C' 기반)에 ITEM_NAME 포함 시 채워짐 — titleset
    //   미등록 사용자는 Part C 51_ titleset SQL 적용 필요 (누락 원인 진단 2026-07-02).
    key: 'ITEM_NAME',
    header: 'Model Name',
    width: 120,
    align: 'C',
    _ctrlType: 'FPText',
    _inputEditType: 'S',
  },
  {
    key: 'NICK_NAME',
    header: 'Nickname',
    width: 100,
    align: 'C',
    _ctrlType: 'FPText',
    _inputEditType: 'S',
  },
  {
    key: 'INCOTERMS',
    header: 'Incoterms',
    width: 80,
    align: 'C',
    _ctrlType: 'FPComboBox',
    _inputEditType: 'IM',
    _comboKey: 'Incoterms',
  },
  {
    key: 'FCST_TYPE',
    header: 'FCST Type',
    width: 90,
    align: 'C',
    _ctrlType: 'FPComboBox',
    _inputEditType: 'IM',
    _comboKey: 'FcstType',
  },
  {
    key: 'DOM_EXP',
    header: 'Customs Handbook',
    width: 120,
    align: 'C',
    _ctrlType: 'FPComboBox',
    _inputEditType: 'IM',
    _comboKey: 'CustomsHandbook',
  },
  {
    key: 'ITEM_TYPE',
    header: 'Item Type',
    width: 90,
    align: 'C',
    _ctrlType: 'FPText',
    _inputEditType: 'S',
  },
  {
    key: 'MEASURE',
    header: 'Measure',
    width: 110,
    align: 'C',
    _ctrlType: 'FPText',
    _inputEditType: 'S',
  },
];

// AS-IS Measure 종 — 출처: 사내 SCM_MST_SHEET_MEASURE WHERE SHEET_NAME='Mkt Fcst' AND VALID_YN='Y' 실측 23 (SORT 순).
//   admin SCM_MST_SHEET_MEASURE(SHEET_NAME='Mkt Fcst', VALID_YN='Y') 동적 fetch 우선, 0개 시 본 fallback (COLUMN_NAME 코드).
export const MEASURE_FALLBACK = [
  'TMM_FCST',
  'CUST_FCST',
  'MKT_FCST',
  'MKT_FCST_RP',
  'MKT_FCST_RP_CAR',
  'MKT_FCST_RP_CELL',
  'MKT_FCST_ENERGY',
  'RTF_SCP',
  'RTF_SYS_RP',
  'RTF_SYS_RP_CAR',
  'RTF_SYS_RP_CELL',
  'RTF_ENERGY',
  'RMA',
  'IN_TRANSIT',
  'BALANCE',
  'VMI_In_Plan',
  'VMI_In_Req',
  'VMI_Inv',
  'VMI_DIO',
  'BNPIn',
  'AS_In_Req',
  'AS_In_Plan',
  'AS_Inv',
] as const;
export type MeasureFallback = (typeof MEASURE_FALLBACK)[number];

// 신규 행 Insert 시 Measure 기본값 (AS-IS InsertRow L2509 siMain.SetValue(Measure, "MKT_FCST_RP")).
export const INSERT_DEFAULT_MEASURE = 'MKT_FCST_RP' as const;

// 좌측 Freeze — 정적(좌측 고정) 컬럼 전체를 frozen block 으로 처리.
//   실제 frozenColumns 는 공용 DataGrid wrapper 가 staticColumns 의 fixed(=true) findLastIndex+1 로 계산.
//   따라서 MktFcstGrid 는 mainStaticColumns 에 fixed:true 를 주입 (PIVOT 동적 컬럼은 우측 비고정).

// 그룹 동시 선택 / 세로 머지 후보 키 (Measure 제외)
export const GROUP_COLS = [
  'DIVISION_ID',
  'END_CUSTOMER',
  'SCM_SITE_ID',
  'ITEM_ID',
  'INCOTERMS',
  'FCST_TYPE',
  'DOM_EXP',
] as const;

// ⭐ AS-IS Validation MSG ID 매핑 — 사내 SCM_MST_MSG_M(SCM_ADM_MSG_M) 정합 (2026-06-28 실측 재채번).
//   ⚠️ GSCM-era MSG ID(MSG00002/00004/00034 …)는 NSCM 사내 메시지 마스터와 의미가 일치하지 않는다.
//      사내 실측: MSG00002='성공적으로 저장되었습니다.'(≠필수값), MSG00004='저장하시겠습니까?'(유일 재사용),
//      그 외 GSCM MSG ID 는 사내 미존재 → AS-IS 한글 원문을 사내 텍스트 매칭(READ) 후 신규 정식 채번.
//   사내 채번 기준: MAX(MSG)=MSG00630(MSG99999 sentinel 제외) → 신규 MSG00631+. 재사용은 정확 텍스트 일치만.
//   본문(KO/EN/CN) = public/locales/*.json + 사내 등록 handoff `_artifacts/_apply_corporate/40_dmf0003_i18n_register.py`.
//   매핑 근거 = __asis-mapping__.md §Validation + 사내 실측 결정표.
export const MSG = {
  // 필수값 — "[{0}] 은 필수 입력사항입니다." (.cs L4335 GMessageBox MSG00002).
  //   ⚠️ 사내 MSG00002='성공적으로 저장되었습니다.' 오매핑 → 신규 MSG00631 정합.
  REQUIRED_FIELD: 'MSG00631',
  // 확인 — "저장하시겠습니까?" (.cs L1621/1636). 사내 MSG00004 정확 일치 → 재사용.
  CONFIRM_SAVE: 'MSG00004',
  // 수량 미입력 — "MKT FCST 수량이 입력된 일자가 없습니다." (.cs L1499/1660 MSG00034, 사내 미존재) → 신규.
  NO_QTY_INPUT: 'MSG00632',
  // 중복 — "저장시 중복 오류가 발생하였습니다.{0}" (.cs L1493 MSG00043, 사내 미존재) → 신규.
  DUPLICATE: 'MSG00633',
  // 숫자값 — "0 보다 큰 수를 입력하세요." (.cs 숫자값검증 MSG00084, 사내 미존재) → 신규.
  POSITIVE_QTY: 'MSG00634',
  // Division 필수 — "Division 을 선택하세요." (.cs L1213 MSG00097, 사내 미존재) → 신규.
  REQUIRE_DIVISION: 'MSG00635',
  // 기간 역전 — "조회 기간이 잘못되었습니다 (시작일 > 종료일)." (.cs L1224 MSG00108, 사내 미존재) → 신규.
  PERIOD_INVERTED: 'MSG00636',
  // 복사대상 미선택 — "복사할 데이터를 선택하세요." (.cs L802/814/826 MSG00113, 사내 미존재) → 신규.
  SELECT_COPY_ROW: 'MSG00637',
  // 기간 3년 초과 — "조회 기간은 3년 이내로 입력해주세요." (.cs L1230 MSG00164, 사내 미존재) → 신규.
  PERIOD_MAX_3YEAR: 'MSG00638',
  // 실적 미만 — "실적 수량보다 작은 숫자를 넣을 수 없습니다." (.cs L3844 MSG00225, 사내 미존재) → 신규.
  BELOW_ACTUAL: 'MSG00639',
  // Bucket 변경 가드 — "Insert 된 행이 있어 Bucket 을 변경할 수 없습니다." (.cs L5401 MSG00227, 사내 미존재) → 신규.
  INSERT_ONLY_BUCKET: 'MSG00640',
  // 모드 — "조회 후 수정모드로 가능합니다." (.cs L847 MSG00259, 사내 미존재) → 신규.
  EDIT_AFTER_SEARCH: 'MSG00641',
  // 중복 입력 — "신규 입력 데이터 중 중복된 데이터가 있습니다." (.cs L3253 MSG00260, 사내 미존재) → 신규.
  DUPLICATE_INPUT: 'MSG00642',
  // AS+ALL 가드 — "AS From-Site 를 ALL 로 저장할 수 없습니다." (.cs L1569 MSG00366, 사내 미존재) → 신규.
  AS_SITE_ALL: 'MSG00643',
  // FcstType 코드 — "FcstType 코드가 유효하지 않습니다." (.cs L3388 영역 MSG00472, 사내 미존재) → 신규.
  FCST_TYPE_INVALID: 'MSG00644',
  // Period 누락 — "조회 기간을 입력하세요." (AS-IS 별도 ID 없음) → 신규(필수값과 분리).
  REQUIRED_PERIOD: 'MSG00645',
  // 저장 대상 없음 — "저장할 데이터가 없습니다." (AS-IS dtSaveFinal 0건) → 신규.
  NO_SAVE_DATA: 'MSG00646',
  // 필수 컬럼(범용) — REQUIRED_FIELD 와 동일 메시지 재사용 (별도 ID 불필요).
  REQUIRED_COLUMN: 'MSG00631',
} as const;

// (PSI 고객수요분석 상수 블록 제거 — 2026-07-03 사용자 결정. DMF0003_PSI_20260703 패키지 보존.)

// ============================================================================
// ⭐ Grid 내 cascade filter (hook #59 §5-G — DMF0020 표준 이식, 사용자 요구 2026-07-03)
//   콤보 편집 진입 시 같은 행의 상위 셀 값으로 콤보 후보를 클라 필터(dataMap 스왑).
//   filter 키 = 콤보 SQL 반환 컬럼 실측: EndCustomerByDivisionDept(DIVISION_ID/DEPT_ID/CODE/NAME),
//   SiteByEndCustomer(DIVISION_ID/END_CUSTOMER/CODE/NAME). 관대 통과(rv/cv 공란·'ALL' = 통과)라
//   키 미보유 콤보(Div40 변형 등)는 자동 전체 통과 — 값 유실 없음.
// ============================================================================
export const GRID_CASCADE_FILTERS: Record<string, { rowKey: string; comboKey: string }[]> = {
  END_CUSTOMER: [{ rowKey: 'DIVISION_ID', comboKey: 'DIVISION_ID' }],
  SCM_SITE_ID: [
    { rowKey: 'DIVISION_ID', comboKey: 'DIVISION_ID' },
    { rowKey: 'END_CUSTOMER', comboKey: 'END_CUSTOMER' },
  ],
  // Div40 변형 — END_CUSTOMER40(값=PROJECT_CODE) / SCM_SITE_ID40. 콤보에 키 없으면 관대 통과.
  END_CUSTOMER40: [{ rowKey: 'DIVISION_ID', comboKey: 'DIVISION_ID' }],
  SCM_SITE_ID40: [
    { rowKey: 'DIVISION_ID', comboKey: 'DIVISION_ID' },
    { rowKey: 'END_CUSTOMER40', comboKey: 'END_CUSTOMER' },
  ],
};

// 상위 콤보 값 변경 시 하위 셀 clear 체인 (같은 INSERT_GROUP 형제 행 포함 — DMF0020 동일).
export const GRID_CASCADE_CLEAR: Record<string, readonly string[]> = {
  END_CUSTOMER: ['SCM_SITE_ID'],
  END_CUSTOMER40: ['SCM_SITE_ID40'],
};
