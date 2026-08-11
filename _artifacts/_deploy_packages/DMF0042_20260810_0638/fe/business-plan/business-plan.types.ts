import type { BUCKET_TYPE, MENU_ID, SHEETS } from './business-plan.constants';

// AS-IS DMF0042 조회조건 14 + Sum 체크박스 (상세동작 md §3 컨트롤 15 전수 — dead/숨김 제외):
//   Row1: Division*(단일) / Team / End Customer / Sales Site
//   Row2: Plant Site(40 비활성) / Biz Type / Period* / Bucket*(기본 Monthly — M/Q/Y)
//   Row3: Project🔍(40 비활성) / Model🔍 / Owner🔍 / Item Type
//   체크박스: Sum(즉시 토글 — Y_/Q_ SUM 표시) / cboQty(Qty≥0)=Visible=false dead — 'N' 고정 배선만 /
//   cboClosed=Enabled=false dead 제외.
export interface SearchCondition {
  divisionId: string; // 필수 — Division 단일 콤보 (MSG00097)
  deptIds: string[]; // Team
  endCustomers: string[]; // End Customer (40 = EndCustomerByDivision40 원천)
  scmSiteIds: string[]; // Sales Site
  plantSiteIds: string[]; // Plant Site (40 비활성 — AS-IS InitControls L259~261)
  bizTypes: string[]; // Biz Type (40 = DM_BIZ_TYPE / 81·82 = GetBizTypebyDivision)
  itemTypes: string[]; // Item Type
  projectCodes: string[]; // Project — Input + popup (40 비활성 — AS-IS btnProject 81/82 전용)
  itemIds: string[]; // Model/Nickname — Input + popup
  owners: string[]; // Owner — Input + popup (DM0020 모달 — CMBO 불필요 판정)
  startYyyymmdd: string; // Period.start (필수 — PR_GET_DAY_RANGE p_month=7 당월 1일)
  endYyyymmdd: string; // Period.end (필수 — +7개월 말일)
  bucketType: BUCKET_TYPE; // Bucket (필수 — 기본 Monthly. M/Q/Y — BUCKET2_TYPE_CODE)
  sumYn: boolean; // Sum — 상위 버킷 SUM 컬럼(Y_/Q_) 표시 토글 (FE 전용, AS-IS chkSum L2832)
}

// 메인 그리드 행 (PIVOT wide format — 정적 63 admin 메타 + 동적 Y_/Q_/M_ 컬럼)
//   CRUD_TYPE: 'I'(신규) / 'M'(수정 — EditTracker 자동 마킹).
//   INSERT_GROUP_ID: Insert Measure 블록 식별자 (블록 삭제/셀 팝업 반영 대상 추적).
//   EDIT_FLAG: 조회 SP 세팅 행 편집권 ('Y' 만 편집 — GADM 아님, 상세동작 md 헤더 ⚠).
export type BusinessPlanRow = Record<string, unknown> & {
  CRUD_TYPE?: 'I' | 'M' | 'D';
  INSERT_GROUP_ID?: string;
  MEASURE?: string;
  EDIT_FLAG?: string;
};

// 동적 컬럼 메타 (DMF0042_GET_SPREAD_TITLE data 커서 — COLUMN_NAME = Y_yyyy / Q_yyyy_q / M_yyyymm / B_* / 정적).
export type SpreadTitleRow = ResponseData<MENU_ID, SHEETS.SPREAD_TITLE, 'data'>;

// 커서 2 — 40 편집 유효구간 메타 (1행. AS-IS Tables[1] — 81/82 는 lookup DM_LONG_PLAN 미등재 = NULL 반환
//   → FE NULL 방어 승계(AS-IS 파리티, 플랜 §D). alias 실측: SP L1084~1091)
export type CutoffWindow = ResponseData<MENU_ID, SHEETS.MAIN, 'calendar'>;

// Ver. Cutoff / Replace 버전 목록 행
export type CutoffVersionRow = ResponseData<MENU_ID, SHEETS.CUTOFF_VERSION, 'data'>;
export type MdfVersionRow = ResponseData<MENU_ID, SHEETS.MDF_VERSION, 'data'>;

// Exchange Rate 모달 grid 행 (futurePriceData — long format)
export type FuturePriceRow = ResponseData<MENU_ID, SHEETS.FUTURE_PRICE_DATA, 'data'>;

// Validation 결과
export interface ValidationResult {
  ok: boolean;
  msgId?: string;
  detail?: string;
  rowIdx?: number;
  // MSG00677 — 6년 초과 시 AS-IS 는 종료일을 시작일+6년으로 보정 후 차단 (호출측이 반영)
  adjustedEnd?: string;
}
