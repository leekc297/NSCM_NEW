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
 * ⭐ [E20260908-MEASUNIFY] `titleSetSheetNm` = 메저 개인화 저장 축(`SCM_MST_TITLESET_USER`,
 *   `USER_INQUIRY_COLUMN_TYPE_CODE='M'`). **컬럼 축과 동일하게 저장=조회 시트명을 통일**한다
 *   (사용자 지시 2026-09-08 "컬럼 가져오는거랑 동일하게"). measure 조회(`measureSheetNm`)와
 *   measure 개인화 저장(`titleSetSheetNm`)이 1바이트라도 다르면 저장은 되는데 재조회가 그 행을
 *   못 찾아 개인화가 사라지므로(titleSetApi.ts 주석), 세 축(`sheetNm`/`measureSheetNm`/
 *   `titleSetSheetNm`)을 gubun 별 한 시트명으로 맞춘다.
 *   전제: 메인 데이터 SP(`PKG_DMF0022`/`PKG_DMF0035`)의 'M' titleset 읽기 시트명(V_P_SHEET_NAME)도
 *   이 통일 시트명으로 재등록/정렬되어야 메인 그리드 measure 개인화가 회귀하지 않는다.
 *   ⚠ call-proc 배선 시트명(SHEETS enum, camel)은 여전히 별개 축 — BTN/API/PROC 배선이라 개명 금지.
 */
export const GUBUN_META: Record<
  Gubun,
  { programId: string; sheetNm: string; measureSheetNm: string; titleSetSheetNm: string }
> = {
  // mnuId 통일(사용자 지시 2026-09-08 "url에 mnuId도 맞춰주세요 / titleset 저장할때도 동일한 mnuId로"):
  //   admin 메타·titleset 경로 mnuId 를 gubun 무관하게 화면 자신 MENU_ID(DMF0035)로 고정한다.
  //   대상 URL: `/admin/menu/{mnuId}/column`·`/measure`·`/titleset`(fetch/save 'C'·'M') + ColumnLayoutModal.
  //   구 설계는 GUBUN 별 종속 PROGRAM_ID(DMF0035/DMF0022/DMF0051)를 실었으나, VERSION 따라 mnuId 가
  //   바뀌는 것이 이레귤러라는 지적에 따라 단일화. BE 가 path mnuId 를 P_PROGRAM_ID 로 넘기므로,
  //   전제: SALES/BIZ 의 SCM_MST_SHEET_COLUMNS/SHEET_MEASURE 메타 + titleset + 메인 SP 의 P_PROGRAM_ID
  //   해소가 DMF0035 로 등록/정렬되어 있어야 SALES/BIZ 컬럼·메저 조회가 0행이 되지 않는다(SYS0004 통합 전제).
  // 시트명 통일: gubun 별로 컬럼(sheetNm)·measure 조회(measureSheetNm)·measure 저장(titleSetSheetNm)을
  //   한 시트명으로 맞춘다(컬럼 fetch=저장 방식과 동일).
  [GUBUN.MKT_FCST]: {
    programId: MENU_ID,
    sheetNm: 'Mkt Fcst Waterfall',
    measureSheetNm: 'Mkt Fcst Waterfall',
    titleSetSheetNm: 'Mkt Fcst Waterfall',
  },
  [GUBUN.SALES_PLAN]: {
    programId: MENU_ID,
    sheetNm: 'Sales Plan Waterfall',
    measureSheetNm: 'Sales Plan Waterfall',
    titleSetSheetNm: 'Sales Plan Waterfall',
  },
  [GUBUN.BIZ_PLAN]: {
    programId: MENU_ID,
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

/**
 * MEASURE → 환산 나눗셈 배수 (AS-IS SetAmountCalculating 실측).
 *   MKT 는 measure 필터 없이 전 행에 QTY 배수를 적용한다(.cs:2246-2262).
 * ⚠ 값(itemsSource) 단계에서 나눈다 — footer 집계·Excel·필터가 모두 셀 값을 보므로
 *   formatItem 텍스트 치환으로는 셋 다 어긋난다.
 */
export const divisorFor = (
  gubun: Gubun,
  measure: string,
  d: { krw: number; usd: number; loc: number; qty: number }
): number => {
  if (gubun === GUBUN.MKT_FCST) return d.qty;
  if ((AMOUNT_MEASURES.KRW as readonly string[]).includes(measure)) return d.krw;
  if ((AMOUNT_MEASURES.USD as readonly string[]).includes(measure)) return d.usd;
  if ((AMOUNT_MEASURES.LOC as readonly string[]).includes(measure)) return d.loc;
  const qtyMeasures: readonly string[] =
    gubun === GUBUN.BIZ_PLAN ? QTY_MEASURES_BIZ : QTY_MEASURES_SALES;
  if (qtyMeasures.includes(measure)) return d.qty;
  return 1;
};

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

/**
 * 기간 컬럼 표시 rank (hook #103 §1-2) — 활성 버킷 kind = 표시 / 상위(rank 작음) = 합계(Sum 토글) /
 * 하위(rank 큼) = 기본 숨김(헤더 더블클릭 드릴로만 노출).
 *   MKT·SALES : M(월) > W(주) > D(일)      — AS-IS SetSpreadColumn .cs:1790-1820
 *   BIZ       : Y(연) > Q(분기) > M(월)     — AS-IS 0051 .cs:932-954 (M/Q/Y 3계층)
 */
export const DYN_RANK: Record<Gubun, Record<string, number>> = {
  [GUBUN.MKT_FCST]: { M: 0, W: 1, D: 2 },
  [GUBUN.SALES_PLAN]: { M: 0, W: 1, D: 2 },
  [GUBUN.BIZ_PLAN]: { Y: 0, Q: 1, M: 2 },
};

/** 헤더 강조색 (AS-IS .cs 실측) — 당기 버킷 Green Bold / 주말(토 파랑·일 빨강) */
export const HEADER_COLORS = {
  /** 당월 M_ · 당주 W_ 헤더 (AS-IS Color.Green + Bold) */
  CURRENT: '#008000',
  SATURDAY: '#1565c0',
  SUNDAY: '#d32f2f',
} as const;

/**
 * 셀 콤보 파라미터 quoting — BE `BaseService.makeComboQuery` 가 `@토큰` 을 **raw 치환**하므로
 * 따옴표 없이 넘기면 ORA-00904/01722 가 난다(정본 규약: forecast-price `q()` / SearchFields `q()`).
 * 값이 비면 관대형 SQL 의 전체 게이트인 'ALL' 로 보낸다.
 */
export const quoteComboParam = (value: string | undefined): string =>
  `'${(value && value.trim() !== '' ? value : 'ALL').replace(/'/g, '\'\'')}'`;
