export const MENU_ID = 'SCP0005' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Master.UIL SCP0005_DistributionRoute (단일 그리드 spdMain):
//   설계 근거: .atlas/gscm-design/SCP0005/design/00_checklist.md ~ 03_grid-columns.md.
//   - GET SP : SCP.SCP0005_GET_DISTRIBUTION_ROUTE (TO-BE PKG_SCP0005.P_SCP0005_GET_DISTRIBUTION_ROUTE)
//   - SAVE SP: SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE (TO-BE PKG_SCP0005.P_SCP0005_SAVE_ROUTE) — 36 파라미터 I/U/D
//   - 조회조건: TransMode(단일) / Valid + From/To Country·City(텍스트+도시팝업). cascade 없음(design 02 §3).
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
export const ADMIN_SHEET_NAME: Record<SHEETS, string> = {
  [SHEETS.ROUTE]: 'Distribution Route',
};

// ====================================================================================
// 조회조건 콤보 (design 02 §2·§5)
// ====================================================================================
export const COMBO = {
  // clbTransMode = 공통 LookupCommon(@lookupType='TRANSPORT_MODE_CODE') — 후보 5값 AIR/FRY/TRK/SEA/RAI.
  //   주의(combo-semantic-parity, convert-core §2.6): 콤보 SQL 'TransMode'(BOD 뷰)는 다른 콤보 — 사용 금지.
  TRANS_MODE: 'LookupCommon',
} as const;
// TransMode lookupType 파라미터 (design 02 §2.1 — @lookupType)
export const TRANS_MODE_LOOKUP_TYPE = 'TRANSPORT_MODE_CODE';

// Valid = 정적 Y/N (design 02 §2.2 — DB 콤보 불필요, 상수 옵션). 'ALL' sentinel = 빈값 전달.
export const VALID_OPTIONS: { label: string; value: string }[] = [
  { label: 'ALL', value: 'ALL' },
  { label: 'Y', value: 'Y' },
  { label: 'N', value: 'N' },
];

// ====================================================================================
// 메시지 (design 03 §4.3 / 00 §7 validations 12). 전건 SCM_ADM_MSG_M 실측 확정(2026-09-21 ora.py).
//   Hook #114: AS-IS MSG 번호를 그대로 쓰지 않고 TO-BE SCM_ADM_MSG_M 등재 ID 로 매핑.
//   AS-IS MSG00209(Total L/T 상한)는 TO-BE 미등재 → 등가 MSG01036 으로 대체.
// ====================================================================================
export const MSG = {
  REQUIRED_FIELD: 'MSG00429', // {0} value is required. (실측)
  SAVE_SUCCESS: 'MSG00002', // Saved successfully. (실측)
  NO_CHANGE: 'MSG00004', // No changes to save. (실측)
  SAVE_DUP: 'MSG00043', // Duplicate error on save. {0} (실측 — AS-IS 99010/99020 대응)
  PRIORITY_MIN: 'MSG01134', // Priority is a positive integer. (MSG00107 은 SCM_ADM_MSG_M 미등재 → TO-BE 등재 MSG01134 로 교체)
  LT_SUM_MAX: 'MSG01036', // Only values less than or equal to {0} are allowed. (AS-IS MSG00209 미등재→등가)
  INSERT_GUIDE: 'MSG00662', // Edit mode is available after search. (실측)
  CONFIRM_RESEARCH: 'MSG00265', // Excel upload completed. Reloading data. (AS-IS MSG00265 — 실측 등재 확인)
} as const;

// 검증 경계값 (design 03 §5)
export const PRIORITY_MIN = 1;
export const LT_SUM_MAX = 999;

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

// ROUTE_ID 링크셀 — 더블클릭 시 Route 이력 상세팝업 (design 03 R8 / §1b).
//   주의: 상세팝업(SCP0005_DistributionRoutePopup)은 별도 화면 activity 위임(design 03 §6 #3).
export const ROUTE_ID_BINDING = 'ROUTE_ID';

// ====================================================================================
// 컬럼 메타 (design 03 §1 — 39 칼럼). admin(SCM_MST_SHEET_COLUMNS) 등록본이 있으면 그걸
//   authoritative 로 쓰고(buildColumns), 없으면 이 fallback 을 쓴다. 콤보 lookupType(@lookupType)
//   파라미터는 admin ATTRIBUTE1(LT_TYPE/TRANSPORT_MODE_CODE)에서 공급된다(fallback 은 후보 없음).
// ====================================================================================
export interface RouteColumnMeta {
  key: string;
  header: string;
  width?: number;
  align?: 'L' | 'C' | 'R';
  _ctrlType?: 'FPText' | 'FPComboBox' | 'FPNumber' | 'FPNumberText' | 'FPDateTime';
  _inputEditType?: 'S' | 'O'; // S=항상 잠금(키/파생명/합계/감사) / O=편집후보(editLock 세부판정)
  _comboKey?: string;
}

export const ROUTE_COLUMNS: RouteColumnMeta[] = [
  { key: 'ROUTE_ID', header: 'Route Id', width: 110, align: 'R', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'LT_TYPE', header: 'L/T Type', width: 90, align: 'C', _ctrlType: 'FPComboBox', _inputEditType: 'O', _comboKey: 'LookupCommon' },
  { key: 'FROM_CITY_NAME', header: 'City Name', width: 120, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'FROM_COUNTRY', header: 'Country', width: 80, align: 'C', _ctrlType: 'FPText', _inputEditType: 'O' },
  { key: 'FROM_CITY', header: 'City', width: 80, align: 'C', _ctrlType: 'FPText', _inputEditType: 'O' },
  { key: 'TRANSPORT_MODE', header: 'Trans Mode', width: 100, align: 'C', _ctrlType: 'FPComboBox', _inputEditType: 'O', _comboKey: 'LookupCommon' },
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
  { key: 'TO_COUNTRY', header: 'Country', width: 80, align: 'C', _ctrlType: 'FPText', _inputEditType: 'O' },
  { key: 'TO_CITY', header: 'City', width: 80, align: 'C', _ctrlType: 'FPText', _inputEditType: 'O' },
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
