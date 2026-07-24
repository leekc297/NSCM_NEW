import type { DataType, MENU_ID, ReportType, SHEETS } from './sales-reports.constants';

// AS-IS DMF0044 조회조건 8 컨트롤 (상세동작 §2.2 L233~242 전수 — Company 는 캐시만·바인딩 없음):
//   Division*(MyDivision 단일) / Report Type*(MDF_TYPE) / Year*(CALENDAR_YYYY, 기본 당해년) /
//   Data Type*(MDF_TYPE2 — ALL/1/2) / Version(United 팝업 주입 — readonly text + '...' 버튼) /
//   버튼: Measure Show / Exchange Rate / Text 입력(82 전용)
export interface SearchCondition {
  divisionId: string; // 필수 — MyDivision 단일 콤보
  mdfType: ReportType; // Report Type (REPORT_SP_W 기본 — lookup MDF_TYPE)
  yyyy: string; // Year (기본 당해년)
  dataType: DataType; // Data Type (ALL/1=Cutoff/2=ETC)
  versionNo: string; // ⭐ United 팝업 주입 — 조회·저장 필수키 (미선택 조회 MSG00283)
  versionLabel: string; // txtSPVersion 표시문 (VERSION_NO + DESCRIPTION)
}

// 메인 그리드 행 (PIVOT wide — 정적 46 admin 메타 + 동적 M_yyyymm 12컬럼. 2행 Measure 블록)
//   CRUD_TYPE: 'I'(신규) / 'M'(수정 — EditTracker 마킹). INSERT_GROUP_ID: 2행 세트 식별자.
//   EDIT_FLAG: 조회 SP 세팅 행 편집권 (4변수 매트릭스 입력 1 — 제약매트릭스 §3).
export type SalesReportRow = Record<string, unknown> & {
  CRUD_TYPE?: 'I' | 'M' | 'D';
  INSERT_GROUP_ID?: string;
  MEASURE?: string;
  EDIT_FLAG?: string;
};

// 동적 컬럼 메타 (DMF0044_GET_SPREAD_TITLE data 커서 — COLUMN_NAME = M_yyyymm / B_* / 정적)
export type SpreadTitleRow = ResponseData<MENU_ID, SHEETS.SPREAD_TITLE, 'data'>;

// Measure 2행 블록 정의 (PKG.P_DMF0044_GET_MEASURE — Insert 강제 세팅 원천)
export type MeasureRow = ResponseData<MENU_ID, SHEETS.MEASURE, 'data'>;

// United 버전 팝업 행 (SEND_YN = Transfer/Cancel/Delete 게이트)
export type UnitedVersionRow = ResponseData<MENU_ID, SHEETS.UNITED_VERSION, 'data'>;

// Exchange Rate 팝업 행 (통화쌍 × 월 피벗)
export type ExchangeRateRow = ResponseData<MENU_ID, SHEETS.EXCHANGE_RATE, 'data'>;

// Textbox 행 (13개월 코멘트 — rc2 MONDAY 기준월)
export type TextboxRow = ResponseData<MENU_ID, SHEETS.TEXTBOX, 'data'>;

// Validation 결과
export interface ValidationResult {
  ok: boolean;
  msgId?: string;
  detail?: string;
  rowIdx?: number;
}
