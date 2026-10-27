// SSP0015 ShipmentPSI — TobeGen 생성 골격 (As-is SSP0015_ShipmentPSI, Fact Pack Doc/asisfacts/screens/SSP0015)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
export const MENU_ID = 'SSP0015' as const;
export type MENU_ID = typeof MENU_ID;

// 시트명은 배포 DB SCM_MST_SHEET_COLUMNS.SHEET_NAME 케이싱 그대로 (BE 시트 검증은 대소문자 구분)
export enum SHEETS {
  HOLD_STOCK = 'Hold stock', // META+코드연결
  HOLD_STOCK_DETAIL = 'Hold stock Detail', // META+코드연결
  MES_STOCK_DETAIL = 'MES Stock Detail', // 메타 정의만, 코드 미참조(미사용 가능)
  SCS_STOCK_DETAIL = 'SCS Stock Detail', // META+코드연결
  SHIPMENT_CONFIRM_DETAIL = 'Shipment Confirm Detail', // META+코드연결
  SHIPMENT_PSI_IT_MOBILE = 'Shipment PSI(IT & Mobile)', // 메타 정의만, 코드 미참조(미사용 가능)
  SHIPMENT_PSI_MOBILITY_IT = 'Shipment PSI(Mobility & IT)', // META+코드연결
  SHIPMENT_PSI_PACKER = 'Shipment PSI(Packer)', // META+코드연결
  SHIPMENT_REQUEST_DETAIL = 'Shipment Request Detail', // META+코드연결
  SHIPMENT_RESULT = 'Shipment Result', // META+코드연결
  STOCK_DETAIL = 'Stock Detail', // META+코드연결
  STOCK_LOCATION_DETAIL = 'Stock Location Detail', // META+코드연결
  W_H_STOCK = 'W/H stock', // META+코드연결
  W_H_STOCK_DETAIL = 'W/H stock Detail', // META+코드연결
  WH_IN_PLAN_DETAIL = 'WH In Plan Detail', // META+코드연결
  CALENDAR = 'calendar', // 동적 헤더(기간 컬럼) 원천 — As-is GetSpdTitle → SCP0009_GET_SHEET_CALENDAR_3SPAN · 사내 배선 PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN. TODO(이식): useTabProcQuery 로 조회해 o_rc1 행으로 헤더 생성
}

export enum RESPONSE_SET {
  MAIN = 'o_rc',
}

// As-is grid_effective division 축: 40, 81, 82, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC — division 분기는 통합하지 말고 switch 유지
export const DIVISION = {
  D40: '40',
  D81: '81',
  D82: '82',
  DEE: 'EE',
} as const;
