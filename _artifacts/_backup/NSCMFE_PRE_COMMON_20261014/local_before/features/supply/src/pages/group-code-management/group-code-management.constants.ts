export const MENU_ID = 'SCP0080' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM SCP0080_GroupCodeManagement (Model Code Master, Forms.UIL/Supply 정본):
//   - 조회 SP : PKG_SCP0080.P_SCP0080_GET_GROUP_CODE_MANAGEMENT (10 IN + O_RC1 + 2 OUT, VALID)
//   - 저장 SP : PKG_SCP0080.P_SCP0080_SAVE_GROUP_CODE_MANAGEMENT (39 IN CLOB + 3 OUT, VALID)
//   - PIC 검증 SP : PKG_SCP0050.P_SCP0050_GET_CAPA_PIC_USERINFO_POPUP (2 IN + 3 OUT)
//   - 단일 그리드 + division→sheetNm 동적 컬럼셋 (pivot 아님, SHEET_MEASURE=0)
//   - 설계 근거: .atlas/gscm-design/SCP0080/design/01_layout.md / 02_search-combo.md / 03_grid-columns.md
export enum SHEETS {
  // 단일 메인 그리드. division→sheetNm 은 아래 resolveSheetNm() 가 정한다.
  //   라우팅/버튼권한(SHT_NM)용 값이며, admin 컬럼 메타 조회는 GRID_SHEET_NAME 기반 동적 sheetNm 사용.
  MAIN = 'main',
}

// 단일 커서 표준 응답셋 (NSCM 'o_rc1').
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin SCM_MST_SHEET_COLUMNS.SHEET_NAME 기준명 — AS-IS SHEET_NAME 원본 그대로 (SHEET_NAME 불변 규약).
//   division 별 sheetNm 은 이 기준명 + division 접미어로 만든다 (03_grid-columns.md §1 V_SHEET_NAME 규칙).
export const GRID_SHEET_NAME = 'Group Code Management' as const;

/**
 * division → admin 컬럼 메타 sheetNm 매핑 (AS-IS GET SP V_SHEET_NAME 산식 1:1).
 *
 * AS-IS: base 'Group Code Management'
 *   + CASE WHEN P_DIVISION_ID IN ('81','82','40') OR SUBSTR(P_DIVISION_ID,1,2)='81'
 *          THEN ' - ' || P_DIVISION_ID ELSE '' END
 *
 * 81 계열(81/81_HD/81_HG/81_HM/81_ST/81_UC)은 접미어에 원 division 값이 그대로 붙는다
 *   (byte-identical 44/35 레이아웃이나 sheetNm 은 division 별로 다르다).
 * base(그 외) / -40 / -81계열 / -82 네 종류 레이아웃이 있으나 sheetNm 은 division 단위로 갈린다.
 */
export const resolveSheetNm = (divisionId: string): string => {
  const isSuffixed =
    divisionId === '81' ||
    divisionId === '82' ||
    divisionId === '40' ||
    divisionId.startsWith('81');
  return isSuffixed ? `${GRID_SHEET_NAME} - ${divisionId}` : GRID_SHEET_NAME;
};

// 조회조건 콤보 ID (SCM_ADM_CMBO_SQL_M) — 02_search-combo.md §2 정본.
//   Division : 권한 auth + ATTRIBUTE3<>'EE' WHERE 내장 (CODE=DIVISION_ID, NAME=DIVISION_ID||' '||DIVISION_NAME).
//     주의: Division_SCP(EE 포함) / MyDivision(DM 도메인) 사용 금지.
//   Operation: DIVISION_ID 반환 다중선택. 파라미터 없이 1회 전체 로드 후 client 필터 (재조회 아님).
//     주의: OperationForPlanDivisionId_SCP(DIVISION_ID 미반환) 사용 금지.
export const SEARCH_COMBO = {
  division: 'Division_SCP_NoEE',
  operation: 'OperationForPlanDivisionId1_SCP_ALL',
} as const;

// GROUP_CODE5(82 사업부) 셀팝업 데이터 원천 콤보 (SCM_ADM_CMBO_SQL_M, DB 실측 존재 — 03_grid-columns.md §3-3).
//   AS-IS CommonDataSCPPopup(DataType=RTFGubun) 의 CommonDataList_SCP 비즈서비스 등가. DIVISION_ID/CODE/NAME 반환,
//   @divisionId 파라미터로 사업부 필터(INSTR 다중매칭). 화면 로컬 GroupCodeRtfGubunModal 이 소비한다.
export const RTF_GUBUN_COMBO_ID = 'RTFGubun_SCP' as const;

// 화면 UI 라벨 코드 (SCM_ADM_MSG_M MSG_TP_CD='LBL' 실측). 값 = LBL 코드.
//   NickName 은 확인필요 #1 미해소 — LBL 미정의(임시 하드코딩 금지). 해소 시 이 상수에 추가한다.
//   그 전까지 NickName FormItem 은 defaultValue 만으로 렌더.
export const LBL = {
  SEARCH: 'LBL00112',
  DIVISION: 'LBL00001',
  OPERATION: 'LBL00009',
  MODEL: 'LBL00669',
  FCST: 'LBL01077',
  PRODUCTION: 'LBL01102',
  ACTIVE: 'LBL00007',
  BOM: 'LBL01055',
  NO: 'LBL00674',
  OK: 'LBL00716',
  CLOSE: 'LBL00627',
} as const;

// 편집 잠금 대상 division. 81 계열은 원 division 값이 81 로 시작한다 (03_grid-columns.md §3-2).
export const isEssDivision = (divisionId: string): boolean => divisionId.startsWith('81');

// AlarmByStatusMass 경고색 대상 컬럼 (STATUS_MASS='Y' + 해당 셀 공백 → 노랑 배경, 03_grid-columns.md §3-4).
//   81 계열 = GROUP_CODE1 / 82 = GROUP_CODE8.
export const ALARM_MASS_COLUMN = {
  ess: 'GROUP_CODE1',
  power: 'GROUP_CODE8',
} as const;

// 화면 고유 저장검증 MSG (03_grid-columns.md §3-4 R-SAVE-RESULT / §6).
export const MSG = {
  DATE_ORDER: 'MSG00048', // 81* SALES_FROM/TO 일자 순서 (V-DATE-ORDER)
  SAVE_SUCCESS: 'MSG00004', // 저장 성공(result_cnt) — R-SAVE-RESULT
  SAVE_RESULT: 'MSG00284', // 저장 예외/실패 — R-SAVE-RESULT
  PIC_CHECK: 'MSG00251', // PIC 미등록 (R-PIC-CHECK)
  NO_CHANGE: 'MSG00133', // 변경 없음 (V-NOCHANGE)
} as const;

// BASIC_END_CUSTOMER(81*) 최대 길이 검증 (V-ENDCUST-LEN).
export const BASIC_END_CUSTOMER_MAX_LEN = 50;

// PIC 검증 API MNU_BTN_CD (SCM_ADM_API_M) — SCP0050 검증 SP 를 SCP0080 화면에서 호출하기 위한 배선명.
//   05_register.sql 로 SCM_ADM_API_M/SCM_ADM_PROC_M 에 등록(PKG_SCP0050.P_SCP0050_GET_CAPA_PIC_USERINFO_POPUP).
//   호출 경로: POST /{MENU_ID}/{SHEETS.MAIN}/{PIC_CHECK_BTN}/call-proc (공용 call-proc 규약).
export const PIC_CHECK_BTN = 'PIC_CHECK' as const;
