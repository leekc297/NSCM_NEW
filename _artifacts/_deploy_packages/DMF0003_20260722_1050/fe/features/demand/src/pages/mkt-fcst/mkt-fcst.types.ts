import type { BUCKET_TYPE } from './mkt-fcst.constants';

// AS-IS DMF0003 조회조건 13 + 체크박스 4 (DMF0003_MktFcst_LAYOUT.md §2):
//   Row1: Div* / Team / End Customer / Sales Site(+AS 체크)
//   Row2: Biz Type* / Sender Code / Period* / Bucket*
//   Row3: Project🔍 / Model🔍 / Plant Site / Item Type
//   Row4: Owner🔍 / 체크박스(Sum / Color / Qty≥0 / Cell Qty)
export interface SearchCondition {
  divisionId: string; // 필수 — Div Dropdown
  deptIds: string[]; // Team (^ delim)
  endCustomers: string[]; // End Customer (^ delim)
  scmSiteIds: string[]; // Sales Site (^ delim)
  bizTypes: string[]; // Biz Type (필수, ^ delim)
  senderCodes: string[]; // Sender Code (^ delim)
  startYyyymmdd: string; // Period.start (필수)
  endYyyymmdd: string; // Period.end (필수)
  bucketType: BUCKET_TYPE; // Bucket (필수)
  projectCodes: string[]; // Project — Input + popup (^ delim)
  itemIds: string[]; // Model/Nickname — Input + popup (^ delim)
  nickName: string; // Model/Nickname 보조
  plantSiteIds: string[]; // Plant Site (^ delim)
  itemTypes: string[]; // Item Type (^ delim)
  owners: string[]; // Owner — Input + popup (^ delim)
  // 체크박스 4 + AS (Color 제거 — 2026-07-03, AS-IS 실행 UI 미표시 / Invalid 신설 — AS-IS checkInvalidExec 1:1)
  sumYn: boolean; // Sum
  qtyOverZero: boolean; // Qty ≥ 0
  cellQtyYn: boolean; // Cell Qty (Div40 전용)
  invalidYn: boolean; // MKT FCST 미등록 제외 (Div82 전용 — AS-IS checkInvalidExec, 82 진입 시 기본 checked)
  asYn: boolean; // Sales Site 옆 AS 체크
}

// 메인 그리드 행 (PIVOT wide format — 좌측 고정 + 동적 M_/W_/D_ 컬럼)
//   CRUD_TYPE: 'I' (신규) / 'M' (수정) / 'D' (삭제)
//   INSERT_GROUP_ID: Insert 시 같은 grouping (measure 묶음) 식별자
export type MktFcstRow = Record<string, unknown> & {
  CRUD_TYPE?: 'I' | 'M' | 'D';
  INSERT_GROUP_ID?: string;
  MEASURE?: string;
};

// 동적 컬럼 메타 (DMF0003_GET_SPREAD_TITLE O_RC1 결과 기반 — ora.py SP body 실측).
//   COLUMN_NAME: D_yyyymmdd(일) / W_yyyymm+ISO_WEEK(주) / M_yyyymm(월) / 정적 컬럼명.
//   라벨 3단: LARGE(월=MONTH_NAME) > SMALL(주=WEEK_NAME) > COLUMN_LABEL(일=CALENDAR_DAY).
export interface SpreadTitleRow {
  PROGRAM_ID?: string;
  SHEET_NAME?: string;
  COLUMN_NAME: string; // binding
  COLUMN_LABEL_NAME: string; // leaf header (일자/정적 라벨)
  SMALL_CLASS_LABEL_NAME: string; // 2단 header (주차)
  LARGE_CLASS_LABEL_NAME: string; // 1단 header (대상년월)
  SORT_ORDER_NO: string;
  DAY_CODE?: string; // 요일
  COLUMN_WIDTH?: string | number;
  CELL_CONTROL_OBJECT_TYPE_CODE?: string; // 'FPNumber' 등
  HORIZONTAL_ALIGN_CODE?: string; // 'R' (기간 컬럼)
  VISIBLE_FLAG?: string;
  DIVISION_ID?: string;
}

// Validation 결과
export interface ValidationResult {
  ok: boolean;
  msgId?: string;
  detail?: string;
  rowIdx?: number;
}
