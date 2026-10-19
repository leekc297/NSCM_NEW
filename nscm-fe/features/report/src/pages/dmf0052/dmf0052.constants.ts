// DMF0052 EDISummary — TobeGen 생성 골격 (As-is DMF0052_EDISummary, Fact Pack Doc/asisfacts/screens/DMF0052)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
export const MENU_ID = 'DMF0052' as const;
export type MENU_ID = typeof MENU_ID;

// 시트명은 배포 DB SCM_MST_SHEET_COLUMNS.SHEET_NAME 케이싱 그대로 (BE 시트 검증은 대소문자 구분)
export enum SHEETS {
  SUMMARY = 'SUMMARY', // META+코드연결
  ERP_DATA = 'ERP Data', // META+코드연결
  GSCM_DATA = 'GSCM Data', // META+코드연결
  SUMMARY_PJT = 'Summary Pjt', // META+코드연결
  SUMMARY_STATUS = 'Summary Status', // META+코드연결
  EDI_SUMMARY_GSCM_DATA_POPUP = 'EDI Summary GSCM DATA Popup', // 코드 하드코딩 전용(메타 없음) (팝업)
  SITE_POPUP = 'Site Popup', // 메타 정의만, 코드 미참조(미사용 가능) (팝업)
  SPREAD_TITLE = 'spreadTitle', // 동적 헤더 메타 (As-is *_GET_SPREAD_TITLE)
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
