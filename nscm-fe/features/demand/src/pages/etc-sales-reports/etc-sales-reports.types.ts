import type { MENU_ID, PlanResult, ReportType, SHEETS } from './etc-sales-reports.constants';

// AS-IS DMF0049 조회조건 (주요이벤트 L17 전수 — Company 캐시만):
//   Division*(MyDivision)/MDF Type*(MDF_TYPE)/Plan-Result*(정적, 기본 Plan)/Year*(CALENDAR_YYYY)/
//   Version(United 팝업 주입 — 조회 MSG00283/저장 MSG00688)/btnMeasure.
export interface SearchCondition {
  divisionId: string;
  mdfType: ReportType;
  planResult: PlanResult; // ⭐ DMF0044 dataType 대신 — Plan/Result 정적 콤보
  yyyy: string;
  versionNo: string;
  versionLabel: string;
}

// 메인 그리드 행 — 정적 42 admin 메타 + 동적 M_yyyymm. division 별 Measure 세트행(40=3/81=2/82=1).
//   ⚠ EDIT_FLAG 는 동적 셀 편집 판정에 미사용 (DMF0049 매트릭스 — editLock 헤더 참조).
export type EtcSalesReportRow = Record<string, unknown> & {
  CRUD_TYPE?: 'I' | 'M' | 'D';
  INSERT_GROUP_ID?: string;
  MEASURE?: string;
  EDIT_FLAG?: string;
  DATA_SEQ?: string | number;
};

export type SpreadTitleRow = ResponseData<MENU_ID, SHEETS.SPREAD_TITLE, 'data'>;
export type MeasureRow = ResponseData<MENU_ID, SHEETS.MEASURE, 'data'>;
export type UnitedVersionRow = ResponseData<MENU_ID, SHEETS.UNITED_VERSION, 'data'>;

export interface ValidationResult {
  ok: boolean;
  msgId?: string;
  detail?: string;
  rowIdx?: number;
}
