import type { DistributionRouteRow } from './distribution-route.types';

// SCP0005 Excel Form (업로드 양식 다운로드) — hook #135 excel-form-upload-standard.
//   업로드 시 BE FileServiceImpl.validateExcelHeader 가 SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT 토큰을
//   엑셀 1행 헤더에서 이름으로 조회한다. 따라서 양식은 다음을 지킨다:
//   - 1줄 평면 헤더 (grid 내보내기의 2줄 병합헤더는 이름 매칭이 불가 — group_sub 결합명이 되어 전량 탈락).
//   - header 문자열은 HEADER_CONTENT 실측값 원형 그대로 (별표 '*' 포함 — 1바이트라도 다르면 그 열 유실).
//   DB 실측 2026-09-28 (ora.py): PROGRAM_ID=SCP0005, SHEET_NAME='Distribution Route', 토큰 35.
//   토큰 ↔ 응답키(o_rc1)는 이름으로 1:1 매핑한다. 파일 컬럼 순서는 업로드에 무관하나(HEADER_CONTENT
//   순서가 ATTRIBUTE 위치를 정함) 가독성을 위해 HEADER_CONTENT 순서 그대로 둔다.
//   값은 콤보 변환 없이 그리드 원값(코드/원문) 그대로 싣는다 (#135 §3.3) — GridAction.flatExcelDownload 가
//   전 셀을 '@'(텍스트) 포맷으로 기록해 숫자 셀이 '40.0' 으로 변환돼 검증에서 탈락하는 사고를 막는다.

export interface FormColumn {
  // 엑셀 1행 헤더 = HEADER_CONTENT 토큰 (BE 이름 매핑 키, 원형 그대로)
  header: string;
  // o_rc1 응답 필드명
  key: string;
  width?: number;
}

export const FORM_COLUMNS: readonly FormColumn[] = [
  { header: 'L/T Type*', key: 'LT_TYPE', width: 90 },
  { header: 'Route Id', key: 'ROUTE_ID', width: 110 },
  { header: 'From City Name', key: 'FROM_CITY_NAME', width: 120 },
  { header: 'From Country*', key: 'FROM_COUNTRY', width: 80 },
  { header: 'From City*', key: 'FROM_CITY', width: 80 },
  { header: 'Trans Mode*', key: 'TRANSPORT_MODE', width: 100 },
  { header: 'Priority*', key: 'PRIORITY', width: 70 },
  { header: 'Mon', key: 'DAYS_MON', width: 55 },
  { header: 'Tue', key: 'DAYS_TUE', width: 55 },
  { header: 'Wed', key: 'DAYS_WED', width: 55 },
  { header: 'Thu', key: 'DAYS_THU', width: 55 },
  { header: 'Fri', key: 'DAYS_FRI', width: 55 },
  { header: 'Sat', key: 'DAYS_SAT', width: 55 },
  { header: 'Sun', key: 'DAYS_SUN', width: 55 },
  { header: 'Departure Port*', key: 'D_PORT_NAME', width: 120 },
  { header: 'Departure Country*', key: 'D_COUNTRY', width: 80 },
  { header: 'Departure Port Code*', key: 'D_PORT_CODE', width: 90 },
  { header: 'Arrival Port*', key: 'A_PORT_NAME', width: 120 },
  { header: 'Arrival Country*', key: 'A_COUNTRY', width: 80 },
  { header: 'Arrival Port Code*', key: 'A_PORT_CODE', width: 90 },
  { header: 'Forwarder*', key: 'SHIPPING_COMPANY', width: 110 },
  { header: 'To City Name', key: 'TO_CITY_NAME', width: 120 },
  { header: 'To Country*', key: 'TO_COUNTRY', width: 80 },
  { header: 'To City*', key: 'TO_CITY', width: 80 },
  { header: 'Shipping Document Preparation Date', key: 'SHIP_DOC_PREPARATION_DATE', width: 150 },
  { header: 'Departure Inland', key: 'LT_DEPARTURE_INLAND', width: 110 },
  { header: 'Waiting For Shipping', key: 'LT_WAIT_SHIPPING', width: 120 },
  { header: 'Voyage', key: 'LT_VOYAGE', width: 90 },
  { header: 'Lay Off/Customs Clearance', key: 'LT_LAY_OFF_CLEARANCE', width: 130 },
  { header: 'Arrival Inland', key: 'LT_ARRIVAL_INLAND', width: 110 },
  { header: 'Total L/T', key: 'LT_SUM', width: 90 },
  { header: 'Pick Up Cost', key: 'One_SEGMENT_COST', width: 100 },
  { header: 'Freight Cost', key: 'Two_SEGMENT_COST', width: 100 },
  { header: 'Delivery Cost', key: 'Three_SEGMENT_COST', width: 100 },
  { header: 'Valid*', key: 'VALID_YN', width: 60 },
];

// 그리드 행 → 양식 행. 콤보 변환 없이 원값을 문자열로 싣는다(빈값은 '').
export const buildFormRows = (rows: readonly DistributionRouteRow[]): Record<string, string>[] =>
  rows.map(row => {
    const out: Record<string, string> = {};
    FORM_COLUMNS.forEach(col => {
      const v = (row as Record<string, string | number>)[col.key];
      out[col.key] = v == null ? '' : String(v);
    });
    return out;
  });
