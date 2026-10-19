import type { BOH_RADIO, BUCKET_TYPE, MENU_ID, SHEETS } from './shipment-plan-electrode.constants';

// 시트별 행 타입 — 전역 ambient ResponseData<MENU_ID, SHEET, cursor> 로 유도(단일 cursor 'o_rc1').
//   미배포 MENU_ID 는 Base index-signature fallback 로 type-check 통과([[procedures-dts-base-index-fallback]]).
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN, 'o_rc1'>;
export type CalendarRow = ResponseData<MENU_ID, SHEETS.CALENDAR, 'o_rc1'>;
export type PlanDetailRow = ResponseData<MENU_ID, SHEETS.PLAN_DETAIL, 'o_rc1'>;
export type StockDetailRow = ResponseData<MENU_ID, SHEETS.STOCK_DETAIL, 'o_rc1'>;
export type ShipmentResultRow = ResponseData<MENU_ID, SHEETS.SHIPMENT_RESULT, 'o_rc1'>;
export type ExcelRow = ResponseData<MENU_ID, SHEETS.EXCEL, 'o_rc1'>;

// 하단 detail 3-sheet 전환 대상 (siSub 엑셀 양식은 업로드 전용이라 전환 목록 제외).
export type DetailSheet = SHEETS.PLAN_DETAIL | SHEETS.STOCK_DETAIL | SHEETS.SHIPMENT_RESULT;

// 활성 그리드 — Measure 설정/저장 라우팅 판정 (main pivot vs 하단 detail).
export type ActiveGrid = 'main' | 'detail';

// GET_SHEET_CALENDAR_3SPAN 이 공급하는 동적 기간칼럼 메타 (03 §2.2) — Wijmo 컬럼 재생성 입력.
export interface CalendarColumn {
  columnName: string; // [X_|Y_|Z_][D_|W_|M_]yyyyMMdd
  columnLabelName: string; // 일/주/월 leaf 라벨
  smallClassLabelName: string; // WEEK_NAME (중분류 머지헤더)
  largeClassLabelName: string; // MONTH_NAME (대분류 머지헤더)
  dayCode: string; // 요일코드(주말색 판정: 토=7 Blue / 일=1 Red 등)
  sortOrderNo: number; // ORDER BY 정렬키
}

// 조회조건 상태 (02 §3 cascade 원천값).
export interface SearchCondition {
  divisionId: string;
  companyId: string;
  fromSite: string;
  planDateYyyymmdd: string; // 선택 Plan Date (yyyymmdd)
  isLatest: boolean; // 선택 Plan Date 가 최신(index0)인가 → realFlag/edit 가드
  bucketType: BUCKET_TYPE; // drpPeriod
  bohRadio: BOH_RADIO; // BOH 3-radio (span prefix 동시 선택)
  resultType: string; // shtShipmentResult 조회 Result Type
  chkSum: boolean; // SUM 칼럼 표시
  chkPastPeriod: boolean; // 과거기간(tag-date<planDate) 숨김
  periodFrom: string; // drpPeriod 시작(yyyymmdd)
  periodTo: string; // drpPeriod 종료(yyyymmdd)
}

// detail bar 필드 표시 세트 (하단 시트별 조회조건 노출 제어, 03 §0).
export interface DetailFieldSet {
  resultType: boolean; // shtShipmentResult 만
  shipmentDate: boolean; // shtPlanDetail 기간 필터
  newButton: boolean; // shtPlanDetail 만 Insert
}
