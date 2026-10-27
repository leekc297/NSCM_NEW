// SSP0023 Excel Form (엑셀 양식 다운로드) — AS-IS btnExcelFormDownload_Click → FindData_Plan_Detail_DownLoad 파리티.
//   AS-IS 는 siSub(shtPlanDetail_Excel) 로 현재 조회조건을 SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL 로 조회해
//   데이터를 채운 뒤 내보낸다. TO-BE 도 동일하게 DETAIL_EXCEL SP(main/GET_SHIPMENT_PLAN_DETAIL_EXCEL)를 조회한 결과를 채워 내려보낸다
//   (빈 양식이 아니다 — 응답 o_rc1 행을 FORM_COLUMNS 로 매핑). 조회 로직은 ShipmentPlanElectrode.handleExcelFormDownload.
//
//   header 문자열은 BE FileServiceImpl.validateExcelHeader 가 SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT
//   토큰을 엑셀 1행 헤더에서 이름으로 찾는 매칭 키다. 따라서 DB 실측값 원형 그대로여야 한다
//   (별표 '*' 포함 · 1바이트라도 다르면 그 열 유실). DB 실측(ora.py 2026-10-14):
//     PROGRAM_ID='SSP0023', SHEET_NAME='Shipment Plan(Electrode)',
//     HEADER_CONTENT='Div*|Company*|FromSite*|Material*|YYYYMMDD*|Qty*' (6 토큰, VALID_YN='Y').
//   주의: 설계 03 §1.5 는 5번째 표시명을 'yyyyMMdd*' 로 적었으나 DB 등록값은 'YYYYMMDD*' 다
//     — 검증 매칭 키는 DB 가 정본이므로 'YYYYMMDD*' 를 쓴다.
//
//   key 는 데이터 행을 실을 때의 응답 필드명 = DETAIL_EXCEL SP 커서 컬럼명(DIVISION_ID/COMPANY_ID/FROM_SITE/
//   ITEM_ID/YYYYMMDD/QTY, EXCEL_REQUIRED_COLUMNS 와 1:1). flatExcelDownload 가 각 행에서 이 key 로 셀 값을 읽는다.

import type { EXCEL_REQUIRED_COLUMNS } from './shipment-plan-electrode.constants';

export interface FormColumn {
  // 엑셀 1행 헤더 = HEADER_CONTENT 토큰 (BE 이름 매핑 키, 원형 그대로)
  header: string;
  // 컬럼 ID = 응답 행 필드명 (EXCEL_REQUIRED_COLUMNS 와 1:1 — flatExcelDownload 가 이 key 로 셀 값을 읽음)
  key: (typeof EXCEL_REQUIRED_COLUMNS)[number];
  width?: number;
}

// Excel Form 다운로드 파일명 prefix — flatExcelDownload 가 prefix_yyyymmddHHMMSS.xlsx 로 저장한다.
export const TEMPLATE_EXCEL_PREFIX = 'SSP0023_Template';

// 양식 6컬럼 (HEADER_CONTENT 실측 토큰 순서 그대로).
export const FORM_COLUMNS: readonly FormColumn[] = [
  { header: 'Div*', key: 'DIVISION_ID', width: 90 },
  { header: 'Company*', key: 'COMPANY_ID', width: 110 },
  { header: 'FromSite*', key: 'FROM_SITE', width: 100 },
  { header: 'Material*', key: 'ITEM_ID', width: 140 },
  { header: 'YYYYMMDD*', key: 'YYYYMMDD', width: 100 },
  { header: 'Qty*', key: 'QTY', width: 90 },
];
