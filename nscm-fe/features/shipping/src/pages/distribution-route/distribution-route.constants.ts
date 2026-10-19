export const MENU_ID = 'SCP0005' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Forms.UIL SCP0005_DistributionRoute (단일 그리드 spdMain):
//   domain = SSP(Shipping) — 메뉴코드 접두어(SCP)와 트리 도메인(SSP)이 어긋나는 SCM0008 유형.
//   FE 배치 features/shipping/src/pages/distribution-route, ROUTE_PATH shipping/shipping-master/distribution-route.
//   설계 근거: .atlas/gscm-design/SCP0005/design/00_checklist.md ~ 03_grid-columns.md.
//   - GET SP : SCP.SCP0005_GET_DISTRIBUTION_ROUTE (TO-BE PKG_SCP0005.P_SCP0005_GET_DISTRIBUTION_ROUTE)
//   - SAVE SP: SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE (TO-BE PKG_SCP0005.P_SCP0005_SAVE_ROUTE) — 36 파라미터 I/U/D
//   - 조회조건: TransMode(다중 체크, 콤마 조인) / Valid + From/To Country·City(텍스트+도시팝업). cascade 없음(design 02 §3).
//   - 그리드: 39 칼럼, 셀콤보(LT_TYPE/TRANSPORT_MODE/DAYS/VALID_YN), 편집잠금 계층, 파생(LT_SUM/TRK·AIR).
//   주의: sheetNm 매핑 불일치(design 03 §0/§6 #1) — API 매핑 SHT_NM='route' vs 컬럼메타 SHEET_NAME='Distribution Route'.
//     라우팅/조회는 'route'(API), 컬럼메타 fetch 키는 ADMIN_SHEET_NAME(='Distribution Route')로 분리 배선.
export enum SHEETS {
  ROUTE = 'route', // spdMain (API 매핑 SHT_NM='route')
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = { ROUTE: 'o_rc1' } as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS 컬럼메타 등록명 그대로 (design 03 §0).
//   API 매핑 SHT_NM('route')과 표기가 달라 컬럼메타 fetch 는 이 이름으로 조회한다(불일치 방치 시 0건).
//   DB 실측(2026-09-25 ora.py): PROGRAM_ID=SCP0005, SHEET_NAME='Distribution Route' 39행(31 'O' + 8 'S').
export const ADMIN_SHEET_NAME: Record<SHEETS, string> = {
  [SHEETS.ROUTE]: 'Distribution Route',
};

// Excel Form(업로드 양식) 다운로드 파일명 prefix — GridAction.flatExcelDownload 가
//   '{prefix}_YYYYMMDD_hhmmss.xlsx' 로 완성한다. MetalLinkPrice 'DMF0074_Template' 와 동일 규약.
export const TEMPLATE_EXCEL_PREFIX = 'SCP0005_Template';

// 엑셀 업로드 결과(오류) 그리드의 데이터 컬럼 라벨 — 업로드 SP 결과 O_CUR_LIST 의 ATTRIBUTE1..n 과
//   위치가 1:1 대응한다(ATTRIBUTE1 = 배열[0]). SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT(PROGRAM_ID='SCP0005',
//   SHEET_NAME='Distribution Route') 를 그대로 옮긴 것으로 필수표시 '*' 는 제거했다(DB 실측 2026-09-30).
//   admin 이 HEADER_CONTENT 를 바꾸면 이 배열도 맞춰야 한다.
export const EXCEL_UPLOAD_HEADER_LABELS = [
  'L/T Type',
  'Route Id',
  'From City Name',
  'From Country',
  'From City',
  'Trans Mode',
  'Priority',
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
  'Departure Port',
  'Departure Country',
  'Departure Port Code',
  'Arrival Port',
  'Arrival Country',
  'Arrival Port Code',
  'Forwarder',
  'To City Name',
  'To Country',
  'To City',
  'Shipping Document Preparation Date',
  'Departure Inland',
  'Waiting For Shipping',
  'Voyage',
  'Lay Off/Customs Clearance',
  'Arrival Inland',
  'Total L/T',
  'Pick Up Cost',
  'Freight Cost',
  'Delivery Cost',
  'Valid',
] as const;

// i18n 라벨 코드 — SCM_ADM_MSG_M 실측(문구 역조회 TO-BE 코드, #114). AS-IS 번호 그대로 쓰지 말 것.
export const LBL = {
  SEARCH: 'LBL00112', // Search(F5) — 메인 SearchArea 조회 버튼
  FROM_COUNTRY: 'LBL00074',
  FROM_CITY: 'LBL00070',
  TO_COUNTRY: 'LBL00075',
  TO_CITY: 'LBL00071',
  TRANS_MODE: 'LBL00025',
  VALID: 'LBL00639',
  EXCEL_FORM: 'LBL00762',
  EXCEL_UPLOAD: 'LBL00346',
  EXCEL_FILE: 'LBL00759',
  UPLOAD_RESULT: 'LBL00754',
  SUCCESS: 'LBL00755',
  ERROR: 'LBL00756',
  TOTAL: 'LBL00757',
  OK: 'LBL00716',
  CANCEL: 'LBL00107',
} as const;

// ====================================================================================
// 조회조건 콤보 (design 02 §2·§5)
// ====================================================================================
export const COMBO = {
  // clbTransMode = 전용 콤보 'TransportModeCode'(무파라미터, LOOKUP_TYPE='TRANSPORT_MODE_CODE' 하드코딩).
  //   design 02 §2.1 채택(1순위) — 후보 5값 AIR/FRY/TRK/SEA/RAI, 표시=SEGMENT2(NAME). 셀 콤보와 동일 SQL_ID.
  //   주의(combo-semantic-parity, convert-core §2.6): 이름이 비슷한 'TransportMode'(NAME=코드)·'TransModeCode'
  //   (VALID 필터 누락)·'TransMode'/'SSP16LocTransMode_SCP'(BOD 뷰)은 다른 콤보 — 재사용 금지.
  TRANS_MODE: 'TransportModeCode',
} as const;

// Valid = Y/N 정적 옵션 + ALL(전체). DB 콤보 불필요(상수 옵션), ALL 은 CustomDropdown allOption 이 공급.
//   AS-IS 실측 재정정(2026-09-28): 데이터소스(dtValidYN=Data.Common(YesOrNo,false)) 와 Designer
//   IsAllFlag=false 만 보면 Y/N 2개로 보이나, 실제 바인딩은 setListBox(dtValidYN, cboValidYN, true, ...)
//   의 blnAllFlag=true(CControl.cs:338) 가 ALL 행을 index 0 에 삽입하고 DataSource SelectedIndex=0 →
//   로드 시 ALL 로 표시된다. DMF0004 cboActive(setListBox(dtYesOrNo, cboActive, true)) 와 동일 패턴.
//   조회 시 ALL → p_valid_yn=''(무필터), Y/N 지정 시 해당 필터. (design 02 §2.2/§4 v5 정정.)
export const VALID_OPTIONS: { label: string; value: string }[] = [
  { label: 'Y', value: 'Y' },
  { label: 'N', value: 'N' },
];

// ====================================================================================
// 메시지 (design 03 §4.3 / 00 §7 validations 12). 전건 SCM_ADM_MSG_M 실측 확정(2026-09-21 ora.py).
//   Hook #114: AS-IS MSG 번호를 그대로 쓰지 않고 TO-BE SCM_ADM_MSG_M 등재 ID 로 매핑.
//   AS-IS MSG00209(Total L/T 상한)는 TO-BE 미등재 → 등가 MSG01220({0}은 {1} 이하 입니다.)로 대체.
// ====================================================================================
export const MSG = {
  REQUIRED_FIELD: 'MSG00429', // {0} value is required. (실측)
  SAVE_SUCCESS: 'MSG00002', // Saved successfully. (실측)
  NO_CHANGE: 'MSG00004', // No changes to save. (실측)
  SAVE_DUP: 'MSG00043', // Duplicate error on save. {0} (실측 — AS-IS 99010/99020 대응)
  PRIORITY_MIN: 'MSG01134', // Priority is a positive integer. (AS-IS 원번호 MSG00107 과 문구 동일한 TO-BE 등재 코드 MSG01134 사용 — 05_runtime-parity §4.4 / 04_impl-gap-audit §6.5 ora.py 실측: MSG00107 도 동일 문구로 등재됨)
  LT_SUM_MAX: 'MSG01220', // {0}은 {1} 이하 입니다. — 초과 컬럼명(Total L/T)과 상한을 함께 노출(AS-IS MSG00209 미등재→등가)
  // 주의: AS-IS M5(조회 후 편집 안내 MSG00662)는 NSCM 상시편집 구조대체로 불요 → 상수 미보유(참조처 0, dead 제거).
  CONFIRM_RESEARCH: 'MSG00265', // Excel upload completed. Reloading data. (AS-IS MSG00265 — 실측 등재 확인)
} as const;

// 검증 경계값 (design 03 §5)
export const PRIORITY_MIN = 1;
export const LT_SUM_MAX = 999;

// 숫자 셀 입력범위 (design 03 R1 SetReNumerCellType — 정수, 초과 차단).
//   PRIORITY 0~99, LT 5종·SHIP_DOC_PREPARATION_DATE 0~999. DB DATA_MAX_LENGTH 가 공란이라 컬럼메타로는
//   범위가 안 실려(gap G7) cellEditEnded 에서 클램프한다(admin fetch/ fallback 무관하게 동일 강제).
export const PRIORITY_MAX = 99;
export const NUM_CELL_MAX = 999;
// 0~999 정수 범위 대상(SHIP_DOC + LT 5종). PRIORITY 는 0~99 로 별도.
export const NUM_999_COLUMNS = [
  'SHIP_DOC_PREPARATION_DATE',
  'LT_DEPARTURE_INLAND',
  'LT_WAIT_SHIPPING',
  'LT_VOYAGE',
  'LT_LAY_OFF_CLEARANCE',
  'LT_ARRIVAL_INLAND',
] as const;

// L/T 합계 대상 5 컬럼 (design 03 R13 — LT_SUM 파생 원천)
export const LT_SEGMENT_COLUMNS = [
  'LT_DEPARTURE_INLAND',
  'LT_WAIT_SHIPPING',
  'LT_VOYAGE',
  'LT_LAY_OFF_CLEARANCE',
  'LT_ARRIVAL_INLAND',
] as const;

// 요일 7 컬럼 (design 03 R9 / G4)
export const DAYS_COLUMNS = [
  'DAYS_MON',
  'DAYS_TUE',
  'DAYS_WED',
  'DAYS_THU',
  'DAYS_FRI',
  'DAYS_SAT',
  'DAYS_SUN',
] as const;

// TRANSPORT_MODE='TRK' 시 '-' 로 파생되는 港/Forwarder 7 컬럼 (design 03 R10)
export const TRK_DASH_COLUMNS = [
  'A_COUNTRY',
  'A_PORT_CODE',
  'A_PORT_NAME',
  'D_COUNTRY',
  'D_PORT_CODE',
  'D_PORT_NAME',
  'SHIPPING_COMPANY',
] as const;

// TRANSPORT_MODE 변경 시 DAYS 자동 'Y' 트리거 코드 (design 03 R9)
export const DAYS_AUTO_MODES = ['TRK', 'AIR'] as const;

// FROM/TO 도시팝업 대상 셀 (design 03 R11/R12 — 더블클릭 → SCM0002 도시팝업)
export const FROM_CELL_BINDINGS = ['FROM_COUNTRY', 'FROM_CITY', 'FROM_CITY_NAME'] as const;
export const TO_CELL_BINDINGS = ['TO_COUNTRY', 'TO_CITY', 'TO_CITY_NAME'] as const;

// 저장응답 중복오류 색칠 대상 컬럼 (design 03 R14/R15 — SAVE body 99010/99020, cs:858~863 구간).
//   SAVE 응답 O_RESULT_CURSOR 의 ERR_CODE 로 분기해 위반행 해당 구간을 invalid 색칠(gap G2).
//   R14(99010 DUP DATA): LT_TYPE~TRANSPORT_MODE + D_PORT_NAME~TO_CITY (SO 2~6, 15~24).
export const R14_DUP_DATA_COLUMNS = [
  'LT_TYPE',
  'FROM_CITY_NAME',
  'FROM_COUNTRY',
  'FROM_CITY',
  'TRANSPORT_MODE',
  'D_PORT_NAME',
  'D_COUNTRY',
  'D_PORT_CODE',
  'A_PORT_NAME',
  'A_COUNTRY',
  'A_PORT_CODE',
  'SHIPPING_COMPANY',
  'TO_CITY_NAME',
  'TO_COUNTRY',
  'TO_CITY',
] as const;
// R15(99020 DUP PRIORITY): FROM_CITY_NAME~FROM_CITY + PRIORITY + TO_CITY_NAME~TO_CITY (SO 3~5, 7, 22~24).
export const R15_DUP_PRIORITY_COLUMNS = [
  'FROM_CITY_NAME',
  'FROM_COUNTRY',
  'FROM_CITY',
  'PRIORITY',
  'TO_CITY_NAME',
  'TO_COUNTRY',
  'TO_CITY',
] as const;

// SAVE 응답 O_RESULT_CURSOR ERR_CODE (design 03 §4.3 / SP body L1322·L1346).
export const SAVE_ERR = { DUP_DATA: '99010', DUP_PRIORITY: '99020' } as const;

// ====================================================================================
// 컬럼 메타 (design 03 §1 — 39 칼럼). admin(SCM_MST_SHEET_COLUMNS) 등록본이 있으면 그걸
//   authoritative 로 쓰고(buildColumns), 없으면 이 fallback 을 쓴다. DB 실측(2026-09-25):
//   SHEET_NAME='Distribution Route' 39행(31 'O' 편집 + 8 'S' 표시/감사), 셀 콤보 CELL_COMBO_DATA_TYPE
//   = LT_TYPE→LtType / TRANSPORT_MODE→TransportModeCode / DAYS·VALID_YN→YesOrNo (fallback 콤보키 동일).
// ====================================================================================
export interface RouteColumnMeta {
  key: string;
  header: string;
  width?: number;
  align?: 'L' | 'C' | 'R';
  _ctrlType?: 'FPText' | 'FPTextModal' | 'FPComboBox' | 'FPNumber' | 'FPNumberText' | 'FPDateTime';
  _inputEditType?: 'S' | 'O'; // S=항상 잠금(키/파생명/합계/감사) / O=편집후보(editLock 세부판정)
  _comboKey?: string;
}

export const ROUTE_COLUMNS: RouteColumnMeta[] = [
  { key: 'ROUTE_ID', header: 'Route Id', width: 110, align: 'R', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'LT_TYPE', header: 'L/T Type', width: 90, align: 'C', _ctrlType: 'FPComboBox', _inputEditType: 'O', _comboKey: 'LtType' },
  { key: 'FROM_CITY_NAME', header: 'City Name', width: 120, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'FROM_COUNTRY', header: 'Country', width: 80, align: 'C', _ctrlType: 'FPTextModal', _inputEditType: 'O' },
  { key: 'FROM_CITY', header: 'City', width: 80, align: 'C', _ctrlType: 'FPTextModal', _inputEditType: 'O' },
  { key: 'TRANSPORT_MODE', header: 'Trans Mode', width: 100, align: 'C', _ctrlType: 'FPComboBox', _inputEditType: 'O', _comboKey: 'TransportModeCode' },
  { key: 'PRIORITY', header: 'Priority', width: 70, align: 'R', _ctrlType: 'FPNumberText', _inputEditType: 'O' },
  { key: 'DAYS_MON', header: 'Mon', width: 55, align: 'C', _ctrlType: 'FPComboBox', _inputEditType: 'O', _comboKey: 'YesOrNo' },
  { key: 'DAYS_TUE', header: 'Tue', width: 55, align: 'C', _ctrlType: 'FPComboBox', _inputEditType: 'O', _comboKey: 'YesOrNo' },
  { key: 'DAYS_WED', header: 'Wed', width: 55, align: 'C', _ctrlType: 'FPComboBox', _inputEditType: 'O', _comboKey: 'YesOrNo' },
  { key: 'DAYS_THU', header: 'Thu', width: 55, align: 'C', _ctrlType: 'FPComboBox', _inputEditType: 'O', _comboKey: 'YesOrNo' },
  { key: 'DAYS_FRI', header: 'Fri', width: 55, align: 'C', _ctrlType: 'FPComboBox', _inputEditType: 'O', _comboKey: 'YesOrNo' },
  { key: 'DAYS_SAT', header: 'Sat', width: 55, align: 'C', _ctrlType: 'FPComboBox', _inputEditType: 'O', _comboKey: 'YesOrNo' },
  { key: 'DAYS_SUN', header: 'Sun', width: 55, align: 'C', _ctrlType: 'FPComboBox', _inputEditType: 'O', _comboKey: 'YesOrNo' },
  { key: 'D_PORT_NAME', header: 'Port', width: 120, align: 'L', _ctrlType: 'FPText', _inputEditType: 'O' },
  { key: 'D_COUNTRY', header: 'Country', width: 80, align: 'C', _ctrlType: 'FPText', _inputEditType: 'O' },
  { key: 'D_PORT_CODE', header: 'Port Code', width: 90, align: 'C', _ctrlType: 'FPText', _inputEditType: 'O' },
  { key: 'A_PORT_NAME', header: 'Port', width: 120, align: 'L', _ctrlType: 'FPText', _inputEditType: 'O' },
  { key: 'A_COUNTRY', header: 'Country', width: 80, align: 'C', _ctrlType: 'FPText', _inputEditType: 'O' },
  { key: 'A_PORT_CODE', header: 'Port Code', width: 90, align: 'C', _ctrlType: 'FPText', _inputEditType: 'O' },
  { key: 'SHIPPING_COMPANY', header: 'Forwarder', width: 110, align: 'C', _ctrlType: 'FPText', _inputEditType: 'O' },
  { key: 'TO_CITY_NAME', header: 'City Name', width: 120, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'TO_COUNTRY', header: 'Country', width: 80, align: 'C', _ctrlType: 'FPTextModal', _inputEditType: 'O' },
  { key: 'TO_CITY', header: 'City', width: 80, align: 'C', _ctrlType: 'FPTextModal', _inputEditType: 'O' },
  { key: 'SHIP_DOC_PREPARATION_DATE', header: 'Shipping Document Preparation Date', width: 150, align: 'R', _ctrlType: 'FPNumberText', _inputEditType: 'O' },
  { key: 'LT_DEPARTURE_INLAND', header: 'Departure Inland', width: 110, align: 'R', _ctrlType: 'FPNumberText', _inputEditType: 'O' },
  { key: 'LT_WAIT_SHIPPING', header: 'Waiting For Shipping', width: 120, align: 'R', _ctrlType: 'FPNumberText', _inputEditType: 'O' },
  { key: 'LT_VOYAGE', header: 'Voyage', width: 90, align: 'R', _ctrlType: 'FPNumberText', _inputEditType: 'O' },
  { key: 'LT_LAY_OFF_CLEARANCE', header: 'Lay Off/Customs Clearance', width: 130, align: 'R', _ctrlType: 'FPNumberText', _inputEditType: 'O' },
  { key: 'LT_ARRIVAL_INLAND', header: 'Arrival Inland', width: 110, align: 'R', _ctrlType: 'FPNumberText', _inputEditType: 'O' },
  { key: 'LT_SUM', header: 'Total L/T', width: 90, align: 'R', _ctrlType: 'FPNumberText', _inputEditType: 'S' },
  { key: 'One_SEGMENT_COST', header: 'Pick Up Cost', width: 100, align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'O' },
  { key: 'Two_SEGMENT_COST', header: 'Freight Cost', width: 100, align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'O' },
  { key: 'Three_SEGMENT_COST', header: 'Delivery Cost', width: 100, align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'O' },
  { key: 'VALID_YN', header: 'Valid', width: 60, align: 'C', _ctrlType: 'FPComboBox', _inputEditType: 'O', _comboKey: 'YesOrNo' },
  { key: 'CREATED_BY', header: 'Created By', width: 90, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'CREATION_DATE', header: 'Creation Date', width: 130, align: 'C', _ctrlType: 'FPDateTime', _inputEditType: 'S' },
  { key: 'LAST_UPDATED_BY', header: 'Last Updated By', width: 90, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'LAST_UPDATE_DATE', header: 'Last Update Date', width: 130, align: 'C', _ctrlType: 'FPDateTime', _inputEditType: 'S' },
];
