export const MENU_ID = 'DMF0035' as const;
export type MENU_ID = typeof MENU_ID;

/**
 * DMF0035 Demand Plan Waterfall — AS-IS 3 UI(DMF0035/DMF0022/DMF0051) 통합 (2026-08-06).
 * GUBUN(초기값 MKT_FCST) 전환 = PROC_M 시트 3계열 스위칭.
 * 정본 분석: Doc/화면분석서/DMF0035_DemandPlanWaterfall_ASIS_통합분석_v1.0.md
 */
export enum SHEETS {
  MKT_FCST = 'mktFcstWaterfall',
  SALES_PLAN = 'salesPlanWaterfall',
  BIZ_PLAN = 'bizPlanWaterfall',
  MKT_FCST_TITLE = 'mktFcstSpreadTitle',
  SALES_PLAN_TITLE = 'salesPlanSpreadTitle',
  BIZ_PLAN_TITLE = 'bizPlanSpreadTitle',
  // Version 선택 모달 (SALES) — DMF0073_GET_VERSION_SALESPRICE 공유 계약 (SP_ 축 전용)
  VERSION = 'version',
  // Version 선택 모달 (MKT/BIZ) — PKG_SCM0002.P_SCM0002_GET_VERSIONBYWATERFALLPOPUP
  //   (AS-IS 정본 팝업 SP — 'MF_SF_*'/'BP_*' 축 문자열을 SP 가 내부 분기·확장. 2026-08-06 배선)
  VERSION_WF = 'versionWf',
}

export const GUBUN = {
  MKT_FCST: 'MKT_FCST',
  SALES_PLAN: 'SALES_PLAN',
  BIZ_PLAN: 'BIZ_PLAN',
} as const;
export type Gubun = (typeof GUBUN)[keyof typeof GUBUN];

/** GUBUN → 메인/타이틀 시트 매핑 */
export const GUBUN_SHEET: Record<Gubun, { main: SHEETS; title: SHEETS }> = {
  [GUBUN.MKT_FCST]: { main: SHEETS.MKT_FCST, title: SHEETS.MKT_FCST_TITLE },
  [GUBUN.SALES_PLAN]: { main: SHEETS.SALES_PLAN, title: SHEETS.SALES_PLAN_TITLE },
  [GUBUN.BIZ_PLAN]: { main: SHEETS.BIZ_PLAN, title: SHEETS.BIZ_PLAN_TITLE },
};

/** MKT/SALES 버킷 (AS-IS DMF0003_GET_REPORT_BUCKET_TYPE_CODE) */
export const BUCKET_TYPE = {
  DAILY: 'DAILY',
  WEEKLY: 'WEEKLY',
  MONTHLY: 'MONTHLY',
  ONLY_WEEKLY: 'ONLY_WEEKLY',
} as const;

/** BIZ 버킷 (AS-IS LOOKUP 'BUCKET2_TYPE_CODE' — 0051 은 M/Q/Y 3계층, 서버 미반영·FE 컬럼 토글만) */
export const BUCKET2_TYPE = {
  MONTHLY: 'MONTHLY',
  QUARTERLY: 'QUARTERLY',
  YEARLY: 'YEARLY',
} as const;

/**
 * Version 모달 축 문자열 (GUBUN × Day/Week/Manual 체크):
 * - SALES → DMF0073 공유 SP(정확 토큰 IN): 'SP_D,SP_W,SP_M' 조합
 * - MKT   → SCM0002 SP(축 내부 확장): 'MF_SF_D,MF_SF_W,MF_SF_M' 조합 — SP 가 MF_x,SF_x 로 확장.
 *           ME_S 는 SP 의 MF_SF 분기가 V_VERSION_TYPE 만 사용해 버려지므로 미부가(DMF0082 선례 동일)
 * - BIZ   → SCM0002 SP: 'BP_D,BP_W,BP_M' 조합 — BP 분기는 토큰 그대로 IN 매칭
 */
export const VERSION_AXIS: Record<Gubun, string> = {
  [GUBUN.MKT_FCST]: 'MF_SF',
  [GUBUN.SALES_PLAN]: 'SP',
  [GUBUN.BIZ_PLAN]: 'BP',
};

/** 기간 상한(년) — MKT/SALES=3년(MSG00164) / BIZ=10년 (AS-IS 0051 cs:532-540 실측) */
export const PERIOD_LIMIT_YEARS: Record<Gubun, number> = {
  [GUBUN.MKT_FCST]: 3,
  [GUBUN.SALES_PLAN]: 3,
  [GUBUN.BIZ_PLAN]: 10,
};

/**
 * 클라이언트 표시 환산 대상 MEASURE (AS-IS SetAmountCalculating 실측 — 추측 금지 원칙):
 * - SALES(0022 .cs:2467-2571): 금액 3계(×_40 포함) + 수량 8종
 * - BIZ  (0051 cs:1587-1690) : 동일 + 수량에 Business_Plan 추가
 * - MKT  (0035 .cs:2246-2262): QTY 콤보가 **전 행** 기간값에 무조건 적용 (measure 필터 없음)
 */
export const AMOUNT_MEASURES = {
  KRW: ['SalesAmt_KRW', 'SalesAmt_KRW_40'],
  USD: ['SalesAmt_USD', 'SalesAmt_USD_40'],
  LOC: ['SalesAmt_LOC', 'SalesAmt_LOC_40'],
} as const;

export const QTY_MEASURES_SALES = [
  'CUST_FCST',
  'MKT_FCST',
  'MKT_FCST_RP',
  'MKT_FCST_RP_CAR',
  'MKT_FCST_RP_CELL',
  'RTF',
  'RTF_RP_CAR',
  'RTF_RP_CELL',
] as const;

export const QTY_MEASURES_BIZ = [...QTY_MEASURES_SALES, 'Business_Plan'] as const;

/** 기간(버킷) 컬럼 판정 — D_yyyymmdd / W_yyyymmWW / M_yyyymm / Q_yyyy_q / Y_yyyy */
export const PERIOD_COLUMN_REGEX = /^(D_|W_|M_|Q_|Y_)\d/;
