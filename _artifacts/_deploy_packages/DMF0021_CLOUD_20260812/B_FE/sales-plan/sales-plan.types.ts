import type { BUCKET_TYPE, MENU_ID, SHEETS } from './sales-plan.constants';

// AS-IS DMF0021 조회조건 12 + Sum 체크박스 (UI분석서 v1.0 시트 3 전수):
//   Row1: Division*(단일) / Team / End Customer(40=ByDivision40 스왑) / Sales Site
//   Row2: Plant Site(40 비활성) / Biz Type(40=DmBizType 스왑) / Period* / Bucket*(기본 Monthly)
//   Row3: Project🔍(40 비활성) / Model🔍 / Owner🔍 / Item Type
//   체크박스: Sum / Color / Include Internal Txn /
//   Cell Qty dead 제외.
export interface SearchCondition {
  divisionId: string; // 필수 — Division 단일 콤보 (MSG00097)
  deptIds: string[]; // Team
  endCustomers: string[]; // End Customer (40 = EndCustomerByDivision40 원천)
  scmSiteIds: string[]; // Sales Site
  plantSiteIds: string[]; // Plant Site (40 비활성 — AS-IS InitControls L455)
  bizTypes: string[]; // Biz Type (40 = DmBizType 원천)
  itemTypes: string[]; // Item Type
  projectCodes: string[]; // Project — Input + popup (40 비활성 — AS-IS btnProject L3491)
  itemIds: string[]; // Model/Nickname — Input + popup
  owners: string[]; // Owner — Input + popup
  startYyyymmdd: string; // Period.start (필수 — PR_GET_DAY_RANGE 당월 1일)
  endYyyymmdd: string; // Period.end (필수 — +6개월 말일)
  bucketType: BUCKET_TYPE; // Bucket (필수 — 기본 Monthly, AS-IS DefineProperty L543)
  colorYn: boolean;
  sumYn: boolean; // Sum — 상위 버킷 합계 컬럼(M_/W_) 표시 토글 (FE 전용, AS-IS chkSum L4419)
  internalYn: boolean; // Include Internal Txn — 내부거래 포함 조회조건
}

// 메인 그리드 행 (PIVOT wide format — 정적 66 admin 메타 + 동적 M_/W_/D_ 컬럼)
//   CRUD_TYPE: 'I'(신규) / 'M'(수정 — EditTracker 자동 마킹). 저장행 삭제는 셀 0 저장(SP 'D' 전환) 경로만.
//   INSERT_GROUP_ID: Insert 행 식별자 (셀 팝업 반영 대상 추적).
export type SalesPlanRow = Record<string, unknown> & {
  CRUD_TYPE?: 'I' | 'M' | 'D';
  INSERT_GROUP_ID?: string;
  MEASURE?: string;
};

// 동적 컬럼 메타 (P_DMF0021_GET_SPREAD_TITLE data 커서 — SHEET_COLUMNS 동형 22컬럼).
//   COLUMN_NAME: M_yyyymm(월) / W_yyyymm+ISO_WEEK(주) / D_yyyymmdd(일) / B_*(항상 숨김) / 정적 컬럼명.
export type SpreadTitleRow = ResponseData<MENU_ID, SHEETS.SPREAD_TITLE, 'data'>;

// 커서 2 — 기준일/주차 정보 (1행. 편집 cutoff 산출의 단일 기준 — 클라 시계 금지)
export type CalendarInfo = ResponseData<MENU_ID, SHEETS.MAIN, 'calendar'>;

// 커서 3 — measure 편집권한 (1행 'Y'/'N'. AS-IS bEDIT_AUTH_SalesAmt_LOC / bEDIT_AUTH_RTF_SYS_RP)
export type EditAuthInfo = ResponseData<MENU_ID, SHEETS.MAIN, 'editAuth'>;

// Insert 행 Measure 콤보 행 (P_DMF0021_GET_SALES_PLAN_MEASUREINFO)
export type MeasureInfoRow = ResponseData<MENU_ID, SHEETS.MEASURE_INFO, 'data'>;

// Validation 결과
export interface ValidationResult {
  ok: boolean;
  msgId?: string;
  detail?: string;
  rowIdx?: number;
  // MSG00164 — 3년 초과 시 AS-IS 는 종료일을 시작일+3년으로 보정 후 차단 (호출측이 반영)
  adjustedEnd?: string;
}
