export const MENU_ID = 'DMF0049' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS DMF0049_Sales_ETC_Reports.cs (Demand > Demand Plan > Etc Sales Reports — 신정본 Forms.UIL 1,727행.
//   Plan.UIL 변형 1,648행 대비 ExcelButton [E20240906]/YearSet SP화 [E20250121] 2건 신규):
//   - DMF0044(Sales Reports) 파생 형제 — United 버전 팝업·버전 SP 5종·Team 룩업 공유. 고유 = ETC SP 4종 라인.
//   - 메인 그리드 : 단일 시트 'MDF Reports'(SHEET_COLUMNS 42) + 동적 M_yyyymm 월축
//     (**1단 평면 헤더** — AS-IS `.cs:265` iColumnHeaderRowCount=1. 2026-08-11 전환).
//     division 별 Measure 세트행: 40=3(SalesAmt_LOC→SalesAmt_KRW→RTF_SYS_RP)/81계열=2/82=1.
//   - 3축 분기: MDF Type(REPORT_SP_W/BP_M) × Plan-Result(정적 콤보) × Division(40/81*/82 — 81=startsWith).
//   - 분석서(2026-07-20): Doc/화면분석서/DMF0049_EtcSalesReports_{제약매트릭스_상세,주요이벤트_상세분석}.md
export enum SHEETS {
  MAIN = 'MDF Reports', // SHEET_COLUMNS 42행 등록명 (룰 #91 — rename 금지. DMF0044와 동일명, PROGRAM_ID 구분)
  SPREAD_TITLE = 'spreadTitle', // 동적 월 헤더 (PKG_DMF0049.P_DMF0049_GET_SPREAD_TITLE — 커서 2)
  MEASURE = 'measure', // Measure 세트 정의 (PKG_DMF0049.P_DMF0049_GET_MEASURE)
  UNITED_VERSION = 'unitedVersion', // United 버전 팝업 (DMF0044 SP 공유 — API_ID 만 DMF0049_ 신규)
  TITLE_SET = 'titleSet', // Column/Measure Setting 영구 저장 (공유)
}

// Report Type (lookup MDF_TYPE — clbType)
export const REPORT_TYPE = {
  SP_W: 'REPORT_SP_W',
  BP_M: 'REPORT_BP_M',
} as const;
export type ReportType = (typeof REPORT_TYPE)[keyof typeof REPORT_TYPE];

// ⭐ Plan/Result (clbPlanResult — AS-IS 정적 콤보, 기본 Plan[SelectedIndex=0 L207]. CMBO 불요)
export const PLAN_RESULT = {
  PLAN: 'Plan',
  RESULT: 'Result',
} as const;
export type PlanResult = (typeof PLAN_RESULT)[keyof typeof PLAN_RESULT];

// ⭐ REPORT_BP_M 기준월 — 6자리 단일 상수 (EditButton L370/InsertRow L1050 정본.
//   AS-IS FindData L577 '20180101' 8자리는 결함② — 교정 채택 2026-07-22: 잠금·회색 모두 본 상수로 산출)
export const BP_BASE_YM = '201801' as const;

// Division 분기 — 40(소형·편집 완화)/81계열(startsWith '81')/82(ESS — DM Planner 편집 허용 유일)
export const DIVISION = {
  MOBILITY: '40',
  AUTOMOTIVE: '81',
  ESS: '82',
} as const;

// division 별 Measure 세트 크기 (AS-IS L934~939 — Insert/Delete/저장 수집 단위)
export const measureCntOf = (divisionId: string): number =>
  divisionId === '40' ? 3 : divisionId.startsWith('81') ? 2 : 1;

// ⭐ MSG 매핑 — 전부 사내 기등록 실측 재사용 (2026-07-22 — 신규 채번 0. hook #114 3분기)
export const MSG = {
  // 조회 전 버전 필수 (FindData L528 — AS-IS 00283 = 사내 기등록)
  REQUIRE_VERSION_FIND: 'MSG00283',
  // 저장 전 버전 (SaveData L633 — AS-IS 00281 → DMF0044 신설 MSG00688 재사용)
  REQUIRE_VERSION_ACTION: 'MSG00688',
  // 편집 권한 차단 — DM Planner && Div≠82 (EditButton L344 — 사내 기등록)
  NO_PERMISSION: 'MSG00096',
  // Department 필수 (SaveData L748 — AS-IS 00002 '{0} 필수' → 사내 MSG00429 재매핑 선례)
  REQUIRED_FIELD: 'MSG00429',
  // 저장 성공 (AS-IS 00004 '{N}건' → 사내 MSG00002 재매핑 선례)
  SAVED: 'MSG00002',
  // 변경 없음 (사내 MSG00004)
  NO_CHANGES: 'MSG00004',
  // 저장 대상 0건 / 실패 fallback (DMF0042 계열 재사용)
  NO_SAVE_TARGET: 'MSG00676',
  SAVE_ERROR: 'MSG00618',
  // United 팝업 — DMF0044 신설분 재사용
  COPY_PLAN_ONLY: 'MSG00682',
  DELETE_CONFIRM: 'MSG00683',
  CANCEL_CONFIRM: 'MSG00684',
  SEND_ONLY_N: 'MSG00685',
  CANCEL_ONLY_Y: 'MSG00686',
  DELETE_ONLY_NC: 'MSG00687',
} as const;

// United 팝업 버전 액션 코드 (DMF0044 공유)
export const VERSION_ACTION = {
  DELETE: 'D',
  COPY: 'CP',
  CREATE: 'CR',
  TRANSFER: 'T',
  CANCEL: 'C',
} as const;

// ⭐ sEditMeasure 원천 — 기등록 범용 CMBO 'DM_LOOKUP_DIV' (param1=division, param2=lookupType).
//   DM_SR_ETC_CURRENCY 실측: 82='SalesAmt_KRW' 1행뿐 / 40·81 빈값 (81=시점 창 내에도 전 Measure 잠금 파리티).
export const EDIT_MEASURE_LOOKUP = 'DM_SR_ETC_CURRENCY' as const;

// Grid 편집 전용 콤보 (SHEET_COLUMNS 메타 미지정 컬럼 — C2 cascade 대상. hook #59 §5-G)
export const GRID_EDIT_COMBO: Record<string, { comboId: string }> = {
  CUST_REPORT: { comboId: 'DMF0005_REPORT_GROUP2' },
  PRODUCT_GROUP: { comboId: 'ReportGroup3' },
};

// Insert 신규행 기본 필드
export const INSERT_ROW_DEFAULTS = {
  DEPARTMENT_ID: '',
  DEPT_ID: '',
  END_CUST_REPORT: '',
  CUST_REPORT: '',
  PRODUCT_GROUP: '',
  ITEM_ID: '',
  PROJECT_CODE: '',
  END_CUSTOMER: '',
  SCM_SITE_ID: '',
  CURRENCY: '',
  ETC_DESCR: '',
} as const;
