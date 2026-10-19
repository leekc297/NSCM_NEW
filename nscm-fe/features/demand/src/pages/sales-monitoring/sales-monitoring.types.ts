import type { BUCKET_TYPE } from './sales-monitoring.constants';

// AS-IS DMF0048 조회조건 (화면 설계 + .cs FindData L655~713):
//   Row1: Div* / Team / End Customer / Sales Site
//   Row2: Period* / Bucket* / 체크박스(Sum / Color / Include Internal Txn)
//   확장 : Item Type / Biz. Type / PJT🔍 / Model·Nickname🔍 / Plant Site / Owner🔍
//   (통화 콤보 cboKRW/USD/LOC 제외 — Designer.cs 미존재 + 핸들러 본문 주석 데드코드, 사용자 확정 2026-07-04)
export interface SearchCondition {
  divisionId: string; // 필수 — Div Dropdown (단일)
  deptIds: string[]; // Team (콤마 delim — PKG FN_SPLITSTRING(x, ','))
  endCustomers: string[]; // End Customer
  scmSiteIds: string[]; // Sales Site
  plantSiteIds: string[]; // Plant Site
  bizTypes: string[]; // Biz. Type
  itemTypes: string[]; // Item Type
  projectCodes: string[]; // PJT — Input + popup (빈값 = '' → SP NULL 통과)
  itemIds: string[]; // Model/Nickname — Input + popup
  owners: string[]; // Owner — Input + popup
  startYyyymmdd: string; // Period.start (필수)
  endYyyymmdd: string; // Period.end (필수)
  bucketType: BUCKET_TYPE; // Bucket (필수 — 'DAILY'/'WEEKLY'/'MONTHLY' full-word)
  sumYn: boolean; // Sum — 상위 합계(M_/W_) 컬럼 표시 토글 (AS-IS chkSum → SetSpreadColumn)
  colorYn: boolean; // Color — 과거(실적) 구간 회색 표시 토글 (AS-IS chkColor → setResultPeriod)
  internalYn: boolean; // Include Internal Txn (AS-IS InternalYN → p_internal_yn)
}

// 메인 그리드 행 (PIVOT wide format — 좌측 식별 + 동적 M_/W_/D_ 컬럼). read-only (CRUD 없음).
export type SalesMonitoringRow = Record<string, unknown> & {
  MEASURE?: string;
  EDIT_YN?: string; // SP 반환 행 편집 플래그 — read-only 화면이라 미사용 (기록: __asis-mapping__)
};

// 동적 컬럼 메타 (DMF0048_GET_SPREAD_TITLE O_RC1 — 2026-07-04 스모크 실측 22 cols)
export interface SpreadTitleRow {
  PROGRAM_ID?: string;
  SHEET_NAME?: string;
  COLUMN_NAME: string; // binding (M_yyyymm / W_yyyymm+ISO_WEEK / D_yyyymmdd / 정적 컬럼명)
  COLUMN_LABEL_NAME: string; // leaf header
  SMALL_CLASS_LABEL_NAME: string; // 2단 header (주차)
  LARGE_CLASS_LABEL_NAME: string; // 1단 header (대상년월)
  SORT_ORDER_NO: string | number;
  DAY_CODE?: string; // 요일 (D_ 전용)
  COLUMN_WIDTH?: string | number;
  CELL_CONTROL_OBJECT_TYPE_CODE?: string;
  HORIZONTAL_ALIGN_CODE?: string;
  VISIBLE_FLAG?: string;
  DIVISION_ID?: string;
}

// 메인 SP o_rc2 — 현재/전주 주차 정보 (스모크 실측: THIS_YYYYMM='M_202607', THIS_YYYYMMWW='W_20260727').
//   현재 월/주 헤더 초록 강조(chkColor=false 경로) + 과거 구간 회색(chkColor=true, setResultPeriod) 판정 입력.
export interface CurrentWeekInfo {
  THIS_YYYYMM?: string;
  THIS_YYYYMMWW?: string;
  BASIS_DATE?: string;
  PRE_YYYYMM?: string;
  PRE_YYYYMMWW?: string;
  BASIS_YYYYMM?: string;
  ISO_WEEK?: string;
}
