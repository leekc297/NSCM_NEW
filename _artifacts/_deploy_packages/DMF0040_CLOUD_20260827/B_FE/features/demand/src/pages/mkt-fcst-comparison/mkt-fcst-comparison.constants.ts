export const MENU_ID = 'DMF0040' as const;
export type MENU_ID = typeof MENU_ID;

/**
 * DMF0040 MKT FCST Comparison — 읽기 전용 버전(최대 2) 비교 Waterfall 리포트 (신규 생성 2026-08-26).
 * 정본 분석: Doc/화면분석서/DMF0040_MktFcstComparison_{주요이벤트_상세분석,제약매트릭스_상세,Cascade_Filter_전수}.md
 * AS-IS: GSCM.DM.Forms.UIL\Plan\DMF0040_MktFcst_Comparison.cs 1,875행 (Insert/Delete/Save 빈 구현·EditButton=MSG00109).
 */
export enum SHEETS {
  // 메인 조회 — PKG_DMF0040.P_DMF0040_GET_MKT_FCST_COMPARISON (18 IN)
  MAIN = 'mktFcstComparison',
  // 동적 시간축 — DMF0040_GET_SPREAD_TITLE (5 IN)
  SPREAD_TITLE = 'spreadTitle',
  // Version 선택 모달 — PKG_SCM0002.P_SCM0002_GET_VERSIONBYWATERFALLPOPUP (DMF0035 versionWf 동계약)
  VERSION = 'version',
}

/** Bucket (AS-IS DMF0003_GET_REPORT_BUCKET_TYPE_CODE — 콤보 'ReportBucketType' 재사용) */
export const BUCKET_TYPE = {
  DAILY: 'DAILY',
  WEEKLY: 'WEEKLY',
  MONTHLY: 'MONTHLY',
  ONLY_WEEKLY: 'ONLY_WEEKLY',
} as const;

/** Version 모달 축 — AS-IS 부모가 code='MF' 고정 전달 (.cs L1646 Form_Load(true, "MF", ...)) */
export const VERSION_AXIS = 'MF' as const;

/** 버전 선택 상한 — 초과 시 MSG00255 (AS-IS btnVersion_Click L1657 + 팝업 SetItem 이중) */
export const VERSION_MAX_SELECT = 2;

/** 기간 상한(년) — AS-IS FindData L688 `AddYears(2)` (⚠ MSG00164 문구는 '3년' — 로직 파리티 우선, 제약 A-03) */
export const PERIOD_LIMIT_YEARS = 2;

/**
 * QTY 표시 스케일 (AS-IS SetAmountCalculating L1756~1830 — SelectedIndex 0~3).
 * 콤보 'QtyType' 실값이 있으면 그것을 쓰고, 없으면 이 fallback (DMF0035 DIVISOR_OPTIONS 선례).
 */
export const QTY_DIVISOR_OPTIONS = [
  { value: '1', label: '1' },
  { value: '1000', label: '1,000' },
  { value: '1000000', label: '1,000,000' },
  { value: '100000000', label: '100,000,000' },
];

/**
 * AS-IS MSG 매핑 — 사내 SCM_ADM_MSG_M + locales 실측 대사 완료 (2026-08-26, 전부 기등재 재사용).
 */
export const MSG = {
  DIVISION_REQUIRED: 'MSG00097', // Division 을 선택하세요. (A-01)
  PERIOD_INVALID: 'MSG00108', // 조회 기간이 잘못되었습니다 (시작일 > 종료일). (A-02)
  PERIOD_LIMIT: 'MSG00164', // 기간 상한 초과 — 종료일 자동 보정 (A-03)
  VERSION_MAX: 'MSG00255', // 버전은 최대 2개까지 선택할 수 있습니다. (P-02/P-03)
} as const;

/** 기간(동적) 컬럼 판정 — D_yyyymmdd / W_yyyymmWW / M_yyyymm */
export const PERIOD_COLUMN_REGEX = /^(D_|W_|M_)\d/;

/** 동적 컬럼 종류 판정 */
export const kindOf = (binding: string): 'M' | 'W' | 'D' | null =>
  /^M_\d{6}$/.test(binding)
    ? 'M'
    : /^W_\d{8}$/.test(binding)
      ? 'W'
      : /^D_\d{8}$/.test(binding)
        ? 'D'
        : null;

/** bucket 활성 랭크 — 상위(요약)=Sum 토글 / 하위(상세)=드릴다운 (forecast-price DYN_RANK 선례) */
export const DYN_RANK = { M: 0, W: 1, D: 2 } as const;
