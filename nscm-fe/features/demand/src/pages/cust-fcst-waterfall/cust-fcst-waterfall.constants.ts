export const MENU_ID = 'DMF0053' as const;
export type MENU_ID = typeof MENU_ID;

/**
 * DMF0053 Customer FCST Waterfall — 읽기 전용 Waterfall 조회 리포트 (신규 생성 2026-08-27).
 * 정본 분석: Doc/화면분석서/DMF0053_CustFcstWaterfall_{주요이벤트_상세분석,제약매트릭스_상세,Cascade_Filter_전수}.md
 * AS-IS: GSCM.DM.Forms.UIL\Plan\DMF0053_CustFcstWaterfall.cs 1,822행 (Insert/Delete/Save 주석·EditButton=MSG00109).
 * Version(Date*) 조회조건은 AS-IS btnVersion 숨김 + Figma·#112 카탈로그 부재로 미구현 — versionNo='' 고정.
 */
export enum SHEETS {
  // 메인 조회 — PKG_DMF0053.P_DMF0053_GET_CUST_FCST_WATERFALL (21 IN + O_RC1~3)
  MAIN = 'custFcstWaterfall',
  // 동적 시간축 — PKG_DMF0053.P_DMF0053_GET_SPREAD_TITLE (7 IN)
  SPREAD_TITLE = 'spreadTitle',
}

/** Bucket (AS-IS DMF0003_GET_REPORT_BUCKET_TYPE_CODE — 콤보 'ReportBucketType' 재사용) */
export const BUCKET_TYPE = {
  DAILY: 'DAILY',
  WEEKLY: 'WEEKLY',
  MONTHLY: 'MONTHLY',
  ONLY_WEEKLY: 'ONLY_WEEKLY',
} as const;

/** 기간 상한(년) — AS-IS FindData L692·L709 `AddYears(3)` (MSG00164 문구 '3년' 과 정합 — DMF0040 의 2년 특례와 다름) */
export const PERIOD_LIMIT_YEARS = 3;

/** QTY 표시 스케일 (AS-IS SetAmountCalculating L1755~1772 — SelectedIndex 0~3) */
export const QTY_DIVISOR_OPTIONS = [
  { value: '1', label: '1' },
  { value: '1000', label: '1,000' },
  { value: '1000000', label: '1,000,000' },
  { value: '100000000', label: '100,000,000' },
];

/**
 * AS-IS MSG 매핑 — 사내 SCM_ADM_MSG_M + locales 실측 대사 완료 (2026-08-27, 전부 기등재 재사용·신규 채번 0).
 */
export const MSG = {
  DIVISION_REQUIRED: 'MSG00097', // Division 을 선택하세요. (A-01)
  PERIOD_INVALID: 'MSG00108', // 조회 기간이 잘못되었습니다 (시작일 > 종료일). (A-02/A-04)
  PERIOD_LIMIT: 'MSG00164', // 조회 기간은 3년 이내로 입력해주세요. — 종료일 자동 보정 (A-03/A-05)
} as const;

/** 동적 컬럼 종류 판정 — D_yyyymmdd / W_yyyymmWW / M_yyyymm */
export const kindOf = (binding: string): 'M' | 'W' | 'D' | null =>
  /^M_\d{6}$/.test(binding)
    ? 'M'
    : /^W_\d{8}$/.test(binding)
      ? 'W'
      : /^D_\d{8}$/.test(binding)
        ? 'D'
        : null;

/** bucket 활성 랭크 — 상위(요약)=Sum 토글 / 하위(상세)=드릴다운 (DMF0040 DYN_RANK 계보) */
export const DYN_RANK = { M: 0, W: 1, D: 2 } as const;

/**
 * UM-04 — 기간 컬럼 소수 자릿수 fallback. P_DMF0053_GET_SPREAD_TITLE 은 기간 컬럼에 `3 AS DATA_SCALE_NUMBER`
 * (BODY L91) → AS-IS SpreadInfo.cs L1433~1440 decimalPlaces=3·구분자 on. (DMF0040 은 '' → 0 — 화면별 상이)
 */
export const DEFAULT_DYN_SCALE = 3;

/** SP DATA_SCALE_NUMBER → 자릿수 (''/NULL/음수/NaN = fallback). AS-IS: `int > 0` 일 때만 채택 */
export const scaleOf = (
  raw: string | number | null | undefined,
  fallback: number = DEFAULT_DYN_SCALE
): number => {
  const s = String(raw ?? '').trim();
  if (!s) return fallback;
  const n = Number(s);
  return Number.isFinite(n) && n > 0 ? Math.trunc(n) : fallback;
};

/** SP COLUMN_WIDTH → px (''/NULL/0 = fallback 90) */
export const widthOf = (raw: string | number | null | undefined, fallback: number = 90): number => {
  const n = Number(String(raw ?? '').trim());
  return Number.isFinite(n) && n > 0 ? n : fallback;
};

/** AS-IS footer 집계 서식 `{0:#,##0.###}` (InitSpreadFooterSum L425) — 3자리 */
export const FOOTER_FORMAT = 'n3';

/**
 * UM-08 — bucket 전환 시 AS-IS `InitSpread()`(타이틀 재조회 + 시트 재생성 = 그리드 비움) 경계.
 * DMF0053 cboBucketType_SelectedIndexChanged L1123~1146: ①신·구 중 하나가 ONLY_WEEKLY
 * ②(구 WEEKLY|MONTHLY) → 신 DAILY (L1129~1132). 그 외 = SetSpreadColumn() 가시성 토글뿐.
 */
export const isBucketResetBoundary = (prev: string, next: string): boolean =>
  prev !== next &&
  (prev === BUCKET_TYPE.ONLY_WEEKLY ||
    next === BUCKET_TYPE.ONLY_WEEKLY ||
    ((prev === BUCKET_TYPE.WEEKLY || prev === BUCKET_TYPE.MONTHLY) && next === BUCKET_TYPE.DAILY));
