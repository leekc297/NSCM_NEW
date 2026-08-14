export const MENU_ID = 'DMF0021' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS DMF0021_SalesPlan.cs (Demand > Demand Plan > Sales Plan / 판매계획 — GSCM.DM.Forms.UIL 5,599줄 정본):
//   - 메인 그리드 : PIVOT wide format (정적 66컬럼 admin 메타 + 기간 동적 M_/W_/D_ 3단 헤더)
//   - 분석서      : Doc/_analysis/domain_DM/screens/DMF0021_SalesPlan/ (validation 141 / expressions 120)
//               + Doc/화면설계서/DMF0021_SalesPlan_UI분석서_v1.0.xlsx (11시트) + 상세동작_개발용.md
//   - Division 3종(40 소형 / 81* 자동차 / 82 ESS) 단일 화면 — 81 계열 판정 = startsWith('81') 의무.
export enum SHEETS {
  MAIN = 'Sales Plan', // 메인 그리드 — 공백 포함 quoted key (룰 #91 sheet-name-asis-preserve, DMF0003 'Mkt Fcst' 선례)
  SPREAD_TITLE = 'spreadTitle', // 동적 3단 헤더 메타 (P_DMF0021_GET_SPREAD_TITLE)
  MEASURE_INFO = 'measureInfo', // Insert 행 Measure 콤보 (P_DMF0021_GET_SALES_PLAN_MEASUREINFO)
  DAY_RANGE = 'dayRange', // 기본 조회구간 — PR_GET_DAY_RANGE 공유 (AS-IS GetDayRange p_month=6, o_rc2)
  TITLE_SET = 'titleSet', // Column/Measure Setting 영구 저장 (SCM0002_SET_TITLESET_POPUP 공유)
}

// Bucket Type — AS-IS cboBucketType (DMF0003_GET_BUCKET_TYPE_CODE). 기본값 = Monthly (DefineProperty L543).
export enum BUCKET_TYPE {
  DAILY = 'D',
  WEEKLY = 'W',
  MONTHLY = 'M',
}

// SP 전송용 full-word 변환 (P_BUCKET — AS-IS cboBucketType.ControlValues 1:1, DMF0014 P_BUCKET_TYPE 동일)
export const BUCKET_WORD: Record<BUCKET_TYPE, string> = {
  [BUCKET_TYPE.DAILY]: 'DAILY',
  [BUCKET_TYPE.WEEKLY]: 'WEEKLY',
  [BUCKET_TYPE.MONTHLY]: 'MONTHLY',
};

// Division 분기 (UI분석서 v1.0 시트 9 실측): 40=Mobility / 81 계열(81/81_UC/81_HM/81_ST/81_HD/81_HG)=Automotive / 82=ESS.
//   ⚠ 81 계열 판정은 divisionKindOf(sales-plan.division.ts) 의 startsWith('81') — '===' 비교 금지.
export const DIVISION = {
  MOBILITY: '40',
  AUTOMOTIVE: '81',
  ESS: '82',
} as const;

// 편집 가능 Measure 3종 (AS-IS EditButton L952~1094 — 행 SALES_PLAN_ADJUST_YN='N_Y' + 아래 measure 만 Unlock)
//   SalesAmt_LOC = EDIT_AUTH_SALESAMT_LOC 권한 / RTF_SYS_RP = EDIT_AUTH_RTF_SYS_RP 권한(+당월 잠금) /
//   Catch_Up = 40 전용·M+3 이후 (권한 무관).
export const EDIT_MEASURE = {
  SALES_AMT_LOC: 'SalesAmt_LOC',
  CATCH_UP: 'Catch_Up',
  RTF_SYS_RP: 'RTF_SYS_RP',
} as const;

// 신규 행 기본값 (AS-IS InsertRow L2925~2945 — Measure=SalesAmt_LOC + FcstType=ETC 고정)
export const INSERT_DEFAULT_MEASURE = EDIT_MEASURE.SALES_AMT_LOC;
export const INSERT_DEFAULT_FCST_TYPE = 'ETC' as const;

// 신규 행 초기 필드 (AS-IS InsertRow — DIVISION_ID 는 조회조건으로 세팅, 나머지 공란 + 기본값 2종)
export const INSERT_ROW_DEFAULTS = {
  DEPT_ID: '',
  END_CUSTOMER: '',
  END_CUSTOMER40: '',
  SCM_SITE_ID: '',
  PROJECT_CODE: '',
  ITEM_ID: '',
  TEXT: '',
  TEXT4082: '',
  NICK_NAME: '',
  INCOTERMS: '',
  FCST_TYPE: INSERT_DEFAULT_FCST_TYPE,
  DOM_EXP: '',
  CELL_PROD_SITE_ID: '',
  FROM_SITE_ID: '',
  CURRENCY: '',
  PLANT_SITE_ID: '',
  MEASURE: INSERT_DEFAULT_MEASURE,
} as const;

// ⭐ AS-IS Validation MSG ID 매핑 — 사내 SCM_ADM_MSG_M 실측 대사 완료 (2026-07-14, 계약 확정 — 이 용법 그대로).
//   룰: MSG ID 는 실문구 대사 후 지정(fallback 신뢰 금지). 각 항목에 사내 KO 실측 문구 주석.
export const MSG = {
  // 재진입 가드 — "이전 작업이 아직 실행 중입니다." (AS-IS blnWork L1460/1933)
  WORK_IN_PROGRESS: 'MSG00137',
  // Division 미선택 — "Division 을 선택하세요." (FindData L1513)
  REQUIRE_DIVISION: 'MSG00097',
  // 기간 역전 — "조회 기간이 잘못되었습니다 (시작일 > 종료일)." (FindData L1474)
  PERIOD_INVERTED: 'MSG00108',
  // 기간 3년 초과 — "조회 기간은 3년 이내로 입력해주세요." (FindData L1481 — Value2 자동 보정 후 차단)
  PERIOD_MAX_3YEAR: 'MSG00164',
  // 필수값 — "{0} 값은 필수 입력 항목입니다." (AS-IS MSG00002 용법 → 사내 MSG00429 재매핑. SaveData L2239 필수 13종)
  REQUIRED_FIELD: 'MSG00429',
  // 필수 컬럼 — "필수 입력 컬럼이 없습니다." (EditButton L726/730 · SaveData L2024)
  REQUIRED_COLUMN: 'MSG00113',
  // Bucket 변경 차단 — "Insert 된 행이 있어 Bucket 을 변경할 수 없습니다." (cboBucketType_Click L5475)
  BUCKET_CHANGE_BLOCK: 'MSG00227',
  // Catch_Up 음수 — "{0} 이상의 값만 입력 가능합니다." (SaveData L2587 — 40+Catch_Up+음수, {0}=0)
  CATCHUP_MIN_ZERO: 'MSG00085',
  // 라인 변경 없음 — "라인 [{0}] 에 변경된 값이 없습니다." (SaveData L2666 — iDateCount==0)
  LINE_NO_CHANGE: 'MSG00146',
  // Daily 편집 불가 — (EditButton L1103. Weekly/Monthly 만 편집 — MSG_M 본문 등록 대상)
  DAILY_EDIT_BLOCK: 'MSG00361',
  // 저장 성공 — "성공적으로 저장되었습니다." (AS-IS MSG00004 {0}건 저장 용법 → 사내 MSG00002 재매핑)
  SAVED: 'MSG00002',
  // 변경 0건 — "수정한 내용이 없습니다." (저장 대상 없음)
  NO_CHANGES: 'MSG00004',
  // 저장 오류 공통 fallback — "저장 중 오류가 발생했습니다." (SP 원문 메시지 부재 시)
  SAVE_ERROR: 'MSG00618',
} as const;

// ============================================================================
// ⭐ Grid 내 cascade filter (hook #59 §5-G — DMF0020/DMF0003 표준 이식)
//   콤보 편집 진입 시 같은 행의 상위 셀 값으로 콤보 후보를 클라 필터(dataMap 스왑, cellEditEnded 원복).
//   관대 통과(행 값·콤보 키 공란/'ALL' = 통과)라 키 미보유 콤보는 자동 전체 통과 — 값 유실 없음.
//   AS-IS spdMain_ComboSelChange 행 내 cascade 6키 (L4500~5082) 대응.
// ============================================================================
export const GRID_CASCADE_FILTERS: Record<string, { rowKey: string; comboKey: string }[]> = {
  DEPT_ID: [{ rowKey: 'DIVISION_ID', comboKey: 'DIVISION_ID' }],
  END_CUSTOMER: [
    { rowKey: 'DIVISION_ID', comboKey: 'DIVISION_ID' },
    { rowKey: 'DEPT_ID', comboKey: 'DEPT_ID' },
  ],
  END_CUSTOMER40: [{ rowKey: 'DIVISION_ID', comboKey: 'DIVISION_ID' }],
  SCM_SITE_ID: [
    { rowKey: 'DIVISION_ID', comboKey: 'DIVISION_ID' },
    { rowKey: 'END_CUSTOMER', comboKey: 'END_CUSTOMER' },
  ],
  // CELL_PROD_SITE_ID — ITEM_ID 종속 재바인딩 (AS-IS L4769 Data.Common(CELL_PROD_SITE_ID, division, itemId)).
  //   CMBO 'CELL_PROD_SITE_ID'(P3 등록) 반환열에 ITEM_ID 미포함 시 관대 통과.
  CELL_PROD_SITE_ID: [
    { rowKey: 'DIVISION_ID', comboKey: 'DIVISION_ID' },
    { rowKey: 'ITEM_ID', comboKey: 'ITEM_ID' },
  ],
};

// 상위 콤보 값 변경 시 하위 셀 clear 체인 (AS-IS ComboSelChange 하위 키 셀 clear 1:1 —
//   END_CUSTOMER L4646 / END_CUSTOMER40 L4682 / SCM_SITE_ID L4710. DEPT_ID 분기는 전량 주석 = no-op).
export const GRID_CASCADE_CLEAR: Record<string, readonly string[]> = {
  END_CUSTOMER: ['SCM_SITE_ID', 'ITEM_ID', 'TEXT', 'TEXT4082', 'ITEM_CLASS_NAME'],
  END_CUSTOMER40: ['SCM_SITE_ID', 'ITEM_ID', 'TEXT', 'TEXT4082', 'ITEM_CLASS_NAME'],
  SCM_SITE_ID: ['PROJECT_CODE', 'PROJECT_NAME', 'ITEM_ID', 'TEXT', 'TEXT4082', 'ITEM_CLASS_NAME'],
};

// ============================================================================
// ⭐ Grid 편집 전용 콤보 (조회 표시 dataMap 과 별개 — 편집 진입 시 스왑, cellEditEnded 원복. hook #59 §5-G)
//   - MEASURE : Insert 행 40 전용 — GET_SALES_PLAN_MEASUREINFO(dataMap 은 SP 응답에서 부모가 주입).
//   - CURRENCY: CMBO 'CurrencyList' (AS-IS dtCurrencyList=Data.Common CURRENCY_LIST 1:1 — DMF0020 선례 등록명).
//   - FCST_TYPE(Catch_Up): 전체 'FcstType' 콤보에서 ETC 제외 클라 필터 (AS-IS FCST_TYPE(ETC 제외) L4903).
// ============================================================================
export const GRID_EDIT_COMBO: Record<string, { comboId: string }> = {
  CURRENCY: { comboId: 'CurrencyList' },
};

// Catch_Up 전환 시 콤보 개방 3종 (AS-IS spdMain_ComboSelChange Measure 분기 L4865~4877 —
//   DomExp/Incoterms/FcstType 개방. SalesAmt_LOC 복귀 시 FCST_TYPE='ETC' 고정 + 3종 잠금).
export const CATCH_UP_OPEN_COLS = ['DOM_EXP', 'INCOTERMS', 'FCST_TYPE'] as const;
