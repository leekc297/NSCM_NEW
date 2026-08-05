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
  DAY_RANGE = 'dayRange',
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

// Division 분기 (UI분석서 v1.7 §9 실측):
//   40 : Mobility & IT Battery (기본) / 81 : Automotive Battery (81_UC/HM/ST/HD/HG 계열)
//   82 : ESS (Energy Storage) — ⭐ 편집 가능 유일 division (DM_UI_EDITABLE_DIVISION EDIT_YN='Y').
//   ⚠️ 값('40'/'81'/'82')은 divisionKindOf(division.ts) 가 substring 으로 판정하므로 key 는 라벨일 뿐.
export const DIVISION = {
  MOBILITY: '40',
  AUTOMOTIVE: '81',
  ESS: '82',
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
    key: 'PROJECT_CODE',
    header: 'Project',
    width: 110,
    align: 'C',
    _ctrlType: 'FPModal',
    _inputEditType: 'IM',
    _modalKey: 'PROJECT',
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

// ⭐ AS-IS Validation MSG ID 매핑 — 사내 SCM_ADM_MSG_M 실측 재정합 (2026-07-11).
//   ⚠️ 직전(2026-06-28) "신규 MSG00631~646 채번"은 오류였다. 근거: (1) 그 채번의 전제였던
//      "MAX(MSG)=MSG00630" 이 stale — 실제 사내 MAX=MSG00659. (2) MSG00631 은 이미 타 화면 선점
//      ("해외법인 기여도 미 맵핑된 마스터가 존재합니다."). (3) 정작 필요한 문구 다수가 원 AS-IS ID 로
//      사내에 실재(MSG00097/108/164/227/260/043/152/113/429/225 등) — 신규 채번이 불필요했다.
//   따라서: 사내 실재분은 원 ID 로 EXACT 재사용(문구 대사 완료), 사내 부재분만 신규 채번(MSG00660+).
//   본문(KO/EN/CN) = public/locales/*.json + 사내 handoff `_artifacts/_apply_corporate/DMF0003_msg_register.sql`.
//   룰: MSG ID 는 실문구 대사 후 지정(fallback 신뢰 금지). 각 항목에 사내 KO 실측 문구 주석.
export const MSG = {
  // 필수값 — 사내 MSG00429 "{0} 값은 필수 입력 항목입니다." EXACT 재사용.
  REQUIRED_FIELD: 'MSG00429',
  // 필수 컬럼 — 사내 MSG00113 "필수 입력 컬럼이 없습니다." EXACT.
  REQUIRED_COLUMN: 'MSG00113',
  // 저장 확인 — 사내 MSG00617 "{0} 행을 저장하시겠습니까?" (MSG00004="수정한 내용이 없습니다" 오매핑 교정).
  CONFIRM_SAVE: 'MSG00001',
  // 중복 — 사내 MSG00043 "저장시 중복 오류가 발생하였습니다. {0}" EXACT.
  DUPLICATE: 'MSG00043',
  // 신규 행간 중복 입력 — 사내 MSG00260 "중복된 조합이 존재합니다 (Division/Project/Item/일자/Measure)." EXACT.
  DUPLICATE_INPUT: 'MSG00260',
  // Division 필수 — 사내 MSG00097 "Division 을 선택하세요." EXACT.
  REQUIRE_DIVISION: 'MSG00097',
  // 기간 역전 — 사내 MSG00108 "조회 기간이 잘못되었습니다 (시작일 > 종료일)." EXACT.
  PERIOD_INVERTED: 'MSG00108',
  // 기간 3년 초과 — 사내 MSG00164 "조회 기간은 3년 이내로 입력해주세요." EXACT.
  PERIOD_MAX_3YEAR: 'MSG00164',
  // Bucket 변경 가드 — 사내 MSG00227 "Insert 된 행이 있어 Bucket 을 변경할 수 없습니다." EXACT.
  INSERT_ONLY_BUCKET: 'MSG00227',
  // 저장 대상 없음 — 사내 MSG00152 "저장할 데이터가 없습니다." EXACT.
  NO_SAVE_DATA: 'MSG00152',
  // 편집 게이트 — 사내 MSG00448 "현재 버전이 아닙니다." (DM_UI_EDITABLE_DIVISION EDIT_YN='N' 시). EXACT.
  EDIT_GATE_NOT_EDITABLE: 'MSG00448',
  // ── 사내 부재 → 신규 채번 (MSG00660+, 사내 MAX=659 실측 기준. handoff SQL 로 등록) ──
  // 수량 미입력 — "MKT FCST 수량이 입력된 일자가 없습니다." (.cs L1499/1660).
  NO_QTY_INPUT: 'MSG00660',
  // 복사대상 미선택 — "복사할 데이터를 선택하세요." (.cs L802/814/826). MSG00113 과 텍스트 상이 → 별도.
  SELECT_COPY_ROW: 'MSG00661',
  // 모드 — "조회 후 수정모드로 가능합니다." (.cs L847, 구 MSG00259 사내 부재).
  EDIT_AFTER_SEARCH: 'MSG00662',
  // AS+ALL 가드 — "AS From-Site 를 ALL 로 저장할 수 없습니다." (.cs L1569, 구 MSG00366 사내 부재).
  AS_SITE_ALL: 'MSG00663',
  // FcstType 코드 — "FcstType 코드가 유효하지 않습니다." (.cs L3388, 구 MSG00472 사내 부재).
  FCST_TYPE_INVALID: 'MSG00664',
  // Period 누락 — "조회 기간을 입력하세요." (AS-IS 별도 ID 없음, 필수값과 분리).
  REQUIRED_PERIOD: 'MSG00665',
  // 실적 미만 — "실적 수량보다 작은 숫자를 넣을 수 없습니다." (.cs L3844). MSG00225("0 이상")와 의미 상이 → 별도.
  BELOW_ACTUAL: 'MSG00666',
  // ── AS-IS 최신 반영분 (E20260402-001736 / E20260604-000994, 2026-07-20) ──
  // 권한 없음 — 사내 실재 공통 MSG00096 "사용 권한이 없습니다." (SCP Planner 편집/Insert 차단, .cs L828/L2531).
  NO_AUTH: 'MSG00096',
  // AS FROM SITE 필수 — MSG00476 (저장 시 W/S+고객향 사이트+FcstType AS·WS+빈값, .cs L2300~2329).
  AS_FROM_SITE_REQUIRED: 'MSG00476',
  // SCP Planner 시간창 — MSG00477 (Dmf0003ScpPlannerEditFlag 0행=차단, .cs L848~860. lookup 운영값 협의 대기).
  SCP_TIME_WINDOW: 'MSG00477',
  // DM Planner류 시간창 — MSG00478 5파라미터 {0}~{4}=LIMIT_AUTH/EDIT_DAYS/FROM_TIME/TO_TIME/AUTH (.cs L862~874).
  DM_TIME_WINDOW: 'MSG00478',
} as const;

// ⭐ AS-IS 권한 그룹명 원문 (UserInfoContext["NowGroupID"] 비교 문자열 — .cs 정확 일치, 공백·괄호 포함).
//   TO-BE 는 세션 그룹 부재 → CMBO 'MktFcstUserGroups'(USER_GR_MPG_M @sesUserId) membership 으로 판정.
export const GROUP = {
  WS_PLANNER: 'DM Planner (W/S)',
  DM_PLANNER: 'DM Planner',
  DM_ADMIN: 'DM ADMIN',
  SCP_PLANNER: 'SCP Planner',
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
  // ⭐ 2026-08-04 AS-IS 정합 — TEAM_ID 셀 division cascade (.cs L3304 UserTeamByDivisionAuth(division)).
  TEAM_ID: [{ rowKey: 'DIVISION_ID', comboKey: 'DIVISION_ID' }],
  // ⭐ 2026-08-04 — TEAM_ID→DEPT_ID cascade 추가 (.cs L3313/L3325 team 파라미터 1:1).
  //   콤보가 DEPT_ID 미반환이면 관대 통과(현행 무영향) — Auth판 CMBO(P8) 적용 시 활성.
  END_CUSTOMER: [
    { rowKey: 'DIVISION_ID', comboKey: 'DIVISION_ID' },
    { rowKey: 'TEAM_ID', comboKey: 'DEPT_ID' },
  ],
  SCM_SITE_ID: [
    { rowKey: 'DIVISION_ID', comboKey: 'DIVISION_ID' },
    { rowKey: 'END_CUSTOMER', comboKey: 'END_CUSTOMER' },
  ],
  // Div40 변형 — END_CUSTOMER40(값=PROJECT_CODE) / SCM_SITE_ID40. 콤보에 키 없으면 관대 통과.
  END_CUSTOMER40: [
    { rowKey: 'DIVISION_ID', comboKey: 'DIVISION_ID' },
    { rowKey: 'TEAM_ID', comboKey: 'DEPT_ID' },
  ],
  SCM_SITE_ID40: [
    { rowKey: 'DIVISION_ID', comboKey: 'DIVISION_ID' },
    { rowKey: 'END_CUSTOMER40', comboKey: 'END_CUSTOMER' },
  ],
};

// 상위 콤보 값 변경 시 하위 셀 clear 체인 (같은 INSERT_GROUP 형제 행 포함 — DMF0020 동일).
//   ⭐ 2026-08-04 AS-IS 정합 — SCM_SITE_ID(81/82) 변경 시 Project 계열+BizType clear (.cs L3422~3431).
//   40(SCM_SITE_ID40)은 AS-IS 에 clear 없음(.cs L3518~3528 — Measure 콤보 재구성만) → 체인 미등록.
export const GRID_CASCADE_CLEAR: Record<string, readonly string[]> = {
  END_CUSTOMER: ['SCM_SITE_ID'],
  END_CUSTOMER40: ['SCM_SITE_ID40'],
  SCM_SITE_ID: ['PROJECT_CODE', 'PROJECT_NAME', 'PROJECT_STATUS', 'BIZ_TYPE'],
};

// ============================================================================
// ⭐ Grid 편집 전용 콤보 (조회 표시 dataMap 과 별개 — 편집 진입 시 스왑, cellEditEnded 원복).
//   AS-IS DMF0003_MktFcst.cs: 편집 시 유효분만 후보(조회 표시는 전체 매핑).
//   - MEASURE   : MktFcstEditMeasure (MKT_FCST_MEASURE lookup, @divisionId, VALID+TMM제외 — 82 편집 7종).
//                 조회 표시 dataMap = 'Measure' CMBO(전체 measure 명칭). VMI(site) 세부는 후속.
//   - INCOTERMS : IncotermsEdit (INCOTERMS lookup, VALID_YN='Y'+ATTRIBUTE2='Y' 유효분). 조회 = 'Incoterms'(전체).
//   divisionParam=true → useTabComboQueries 에 divisionId(FE quoting '값') 전달 (BE raw 치환 대응).
// ============================================================================
export const GRID_EDIT_COMBO: Record<
  string,
  { comboId: string; divisionParam?: boolean; wsOnly?: boolean }
> = {
  MEASURE: { comboId: 'MktFcstEditMeasure', divisionParam: true },
  INCOTERMS: { comboId: 'IncotermsEdit' },
  // ⭐ [E20260402-001736] FCST_TYPE 편집 콤보 권한 분기 (.cs L2587~2605): W/S Planner 만
  //   EDIT_MODE 6종(WS·WSF·AS·ASF+Recall·RMA = SALES_TYPE_CODE2 ∪ _ADD) 스왑. 그 외 그룹은
  //   기존 'FcstType'(일반 12종) 조회 dataMap 그대로 (wsOnly=true → 비W/S 스왑 생략).
  FCST_TYPE: { comboId: 'FcstTypeEditMode', wsOnly: true },
};

// ⭐ Measure 변경 시 Model 초기화 (AS-IS spdMain_ComboSelChange L3340~3363, 20231213).
//   신규행('I')에서 MEASURE 가 아래 예외(AS_In_Req/BNPIn)가 아니면 Model 계열 셀 clear
//   (MDM ACTIVE_FLAG 기반 DP 입력 차단 목적 — 잘못된 measure×model 조합 저장 방지).
export const MEASURE_MODEL_KEEP: readonly string[] = ['AS_In_Req', 'BNPIn'];
export const MEASURE_MODEL_CLEAR_COLS: readonly string[] = [
  'ITEM_ID',
  'ITEM_ID40',
  'ITEM_NAME',
  'ITEM_TYPE',
  'NICK_NAME',
];
