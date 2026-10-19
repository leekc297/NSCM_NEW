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

/**
 * [E20260831-METASHEET] UI CATEGORY(SHEET_COLUMNS) 메타 조회 축 — **AS-IS SpreadInfo 시트명 그대로**
 * (사용자 지시 2026-08-31 "SHEET 명은 AS-IS 명칭 동일하게").
 * 실사고: FE 가 call-proc 배선 시트명(camel)으로 `/admin/menu/DMF0035/column` 을 호출해
 *   MKT('Mkt Fcst Waterfall' 48행)·BIZ('Biz Plan Waterfall' 38행) 가 0행 → Grid Layout Fields 에
 *   DEFAULT(Rows) 만 노출. SALES/BIZ 메타는 통합 원천 화면의 **종속 PROGRAM_ID**(DMF0022/DMF0051) 소속
 *   (hook #148 G2 — DMF0035=DMF0022+DMF0051 통합 계보)이라 프로그램 경로도 함께 스위칭해야 한다.
 * ⚠ call-proc 배선 시트명(SHEETS enum, camel)은 별개 축 — 개명 금지 (BTN/API/PROC 배선이 그 표기).
 *
 * ⭐ [E20260902-MEASTITLESET] `titleSetSheetNm` = 메저 개인화 저장 축(`SCM_MST_TITLESET_USER`,
 *   `USER_INQUIRY_COLUMN_TYPE_CODE='M'`). **메타 축(`measureSheetNm`)과 다른 세 번째 축**이며,
 *   메인 SP 가 읽는 값과 1바이트라도 다르면 저장은 되는데 조회에 반영되지 않는다.
 *   사내 PACKAGE BODY 실측(주석 제거 후 LIVE 코드 기준):
 *     MKT   `PKG_DMF0035` L112 `V_P_SHEET_NAME := 'mktFcstWaterfall'`   (메타 L113 = 'Mkt Fcst Waterfall')
 *     SALES `PKG_DMF0022` L628 `v_sheet_name   := 'salesPlanWaterfall'` (메타 L629 = 'Sales Plan Waterfall')
 *     BIZ   `PKG_DMF0051` L532 `v_sheet_name   := 'Biz Plan Waterfall'` (메타 동일값)
 *   ⚠ BIZ 는 SHEETS enum('bizPlanWaterfall')과 **다르다** — enum 으로 대체 ⛔.
 */
export const GUBUN_META: Record<
  Gubun,
  { programId: string; sheetNm: string; measureSheetNm: string; titleSetSheetNm: string }
> = {
  // ⚠ 축별 시트명이 다르다(사내 실측 2026-08-31): SALES 는 COLUMN 축='salesPlanWaterfall'(65행) /
  //   MEASURE 축='Sales Plan Waterfall'(31행). 실측 표기 그대로 — 개명 ⛔.
  [GUBUN.MKT_FCST]: {
    programId: 'DMF0035',
    sheetNm: 'Mkt Fcst Waterfall',
    measureSheetNm: 'Mkt Fcst Waterfall',
    titleSetSheetNm: 'mktFcstWaterfall',
  },
  [GUBUN.SALES_PLAN]: {
    programId: 'DMF0022',
    sheetNm: 'salesPlanWaterfall',
    measureSheetNm: 'Sales Plan Waterfall',
    titleSetSheetNm: 'salesPlanWaterfall',
  },
  [GUBUN.BIZ_PLAN]: {
    programId: 'DMF0051',
    sheetNm: 'Biz Plan Waterfall',
    measureSheetNm: 'Biz Plan Waterfall',
    titleSetSheetNm: 'Biz Plan Waterfall',
  },
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

/**
 * UM-08 — bucket 전환 시 AS-IS `InitSpread()`(타이틀 재조회 + 시트 재생성 = 그리드 비움) 경계.
 * DMF0035 cboBucketType_SelectedIndexChanged .cs:1594~1610: ①(구 WEEKLY|MONTHLY) → 신 DAILY
 * ②신·구 중 하나가 ONLY_WEEKLY. 그 외 = SetSpreadColumn() 가시성 토글뿐.
 * BIZ(M/Q/Y 3계층 — 0051 은 FE 컬럼 토글만) 은 경계 없음.
 */
export const isBucketResetBoundary = (gubun: Gubun, prev: string, next: string): boolean =>
  gubun !== GUBUN.BIZ_PLAN &&
  prev !== next &&
  (prev === BUCKET_TYPE.ONLY_WEEKLY ||
    next === BUCKET_TYPE.ONLY_WEEKLY ||
    ((prev === BUCKET_TYPE.WEEKLY || prev === BUCKET_TYPE.MONTHLY) && next === BUCKET_TYPE.DAILY));

/**
 * UM-04 — 기간 컬럼 소수 자릿수 (SP DATA_SCALE_NUMBER: MKT 타이틀 기간 컬럼은 NULL → AS-IS
 * SpreadInfo.cs L1433~1440 decimalPlaces=0). 행별 NOTATION 이 있으면 그것이 우선한다(formatByNotation).
 */
export const scaleOf = (raw: string | number | null | undefined, fallback = 0): number => {
  const s = String(raw ?? '').trim();
  if (!s) return fallback;
  const n = Number(s);
  return Number.isFinite(n) && n > 0 ? Math.trunc(n) : fallback;
};

/**
 * UM-04 — AS-IS DMF0035 [E20231106-000212] 행별 NOTATION 포맷 (.cs:1199~1273 SetRowFormat 1:1).
 *   INTEGER : 정수 표기 `###,###,###,##0` (0.000 도 0)
 *   POINT   : 정수면 정수 / 소수면 소수 3자리까지(꼬리 0 제거) `###,###,###,###.###` · 0.xxx 는 `0.###`
 *   POINT3  : 무조건 소수 3자리 `###,###,###,###.###` 로 채움(`.#00`/`.##0` = 0 패딩) · 0.000 은 0
 *   DEFAULT/'' : 컬럼 기본 포맷(호출측 fallback)
 * @returns 표시 문자열 (fallback = null 이면 호출측이 기본 포맷 유지)
 */
export const formatByNotation = (value: number, notation: string): string | null => {
  const n = String(notation ?? '')
    .trim()
    .toUpperCase();
  const int0 = (v: number): string => Math.round(v).toLocaleString('en-US');
  if (n === 'INTEGER') return int0(value);
  if (n === 'POINT') {
    if (Number.isInteger(value)) return int0(value);
    return value.toLocaleString('en-US', { minimumFractionDigits: 0, maximumFractionDigits: 3 });
  }
  if (n === 'POINT3') {
    if (Math.abs(value) < 0.0005) return '0';
    return value.toLocaleString('en-US', { minimumFractionDigits: 3, maximumFractionDigits: 3 });
  }
  return null;
};
