export const MENU_ID = 'SSP0019' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SSP.Plan.UIL SSP0019_ShipmentChangeHistory (단일 그리드 spdMain "Shipment Change History"):
//   설계 근거: .atlas/gscm-design/SSP0019/design/00_checklist.md ~ 03_grid-columns.md + convert-flow goal/plan.
//   출하 변경 이력(Shipment Change History) 조회 화면. 도메인 SSP(features/shipping, 00 §0 트리 실측 판정).
//   화면 성격: 읽기전용 조회(inquiry) — 그리드 전열 LockColumn, 편집 4버튼(Insert/Delete/Edit/Save) AS-IS NO-OP.
//   - GET   SP : PKG_SSP0019.P_SSP0019_GET_SHIPMENT_CHANGE_HISTORY (Table[0] 그리드 47열, 파라미터 12개)
//   - POPUP    : SCM0002_ItembyDivisionPopup(Model 조회조건 팝업) / SCM0002_ShipmentPlanRequestPopup(REQUEST_NO 드릴다운)
//   - SP 미배포(goal.md ②): PKG_SSP0019 all_objects 0건 -> 조회 런타임 미완(convert-sp 후속). FE 는 47컬럼 계약으로 구현.
export enum SHEETS {
  MAIN = 'main', // spdMain 단일 시트 (47컬럼, 표시 46 + LAST_SEQ 숨김)
  POPUP = 'popup', // SCM0002 Item by Division (Model 조회조건 팝업)
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  POPUP: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS SpdSheet 그대로 (design 03 §0).
//   실측: SCM_MST_SHEET_COLUMNS PROGRAM_ID='SSP0019' SHEET_NAME='Shipment Change History' 47행(배포됨, design 03 §0).
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'Shipment Change History',
};

// 조회조건 콤보 SQL_ID (design 02 §2.1 — TO-BE Oracle SCM_ADM_CMBO_SQL_M 실측 USE_YN='Y').
//   Division = MyDivisionInEE_SCP(EE 미제외) + FE 필터 code!=='EE'(EE 1개만 제외, EE_HD~EE_UC 유지).
//     MyDivision/FilterMyDivision 재사용 금지(EE cascade 붕괴, convert-core §2.6).
//   From/To Site = EE 조건분기 동적 comboId(전극선택 ShipmentPlan* / else *ByDivision*).
export const COMBO = {
  DIVISION: 'MyDivisionInEE_SCP',
  FROM_SITE_NON_EE: 'PlantSiteByDivision_SCP',
  TO_SITE_NON_EE: 'SSPToSiteByDivision_SCP',
  FROM_SITE_EE: 'ShipmentPlanPlantSite_SCP',
  TO_SITE_EE: 'ShipmentPlanToSite_SCP',
  INCOTERMS: 'ssp0019_Incoterms_SCP',
  TRANS_MODE: 'ssp0019_TransportMode_SCP',
  // 그리드 셀 콤보 DIVISION_ID 표시용(CODE=NAME, lookupType 불요 — design 03 §1 셀콤보표).
  CELL_DIVISION: 'Division',
} as const;

// 그리드 셀 콤보 lookupType 직접 fetch(useTabLookupQueries) — comboParams 단일값으로 못 푸는 2종(design 03 §6-1).
//   FCST_TYPE = SALES_TYPE_CODE(14행, CODE=SEGMENT1/NAME=SEGMENT2), CHANGE_REASON_CODE = CHANGE_REASON_CODE(7행,
//   CODE=SEGMENT1/표시 'CODE : 명', KO=SEGMENT2·EN=SEGMENT3 — CHANGE_REASON_CODE_ALL 콤보 SQL 실측 재현).
export const LOOKUP_TYPE = {
  FCST_TYPE: 'SALES_TYPE_CODE',
  CHANGE_REASON: 'CHANGE_REASON_CODE',
} as const;

// lookupType 직접 dataMap 주입 대상 셀 컬럼(공용 DataGrid comboParams 로 못 푸는 2종). buildColumns 가 auto-wire 를 벗겨
//   plain 컬럼으로 만들고, Grid 가 fetch 한 lookup 으로 col.dataMap 을 직접 주입(자동 콤보 apply 이펙트 클로버 방지).
export const FCST_TYPE_COLUMN = 'FCST_TYPE';
export const CHANGE_REASON_COLUMN = 'CHANGE_REASON_CODE';

// DIVISION_ID 셀 콤보(CODE=NAME, lookupType 불요) — admin 메타 auto-wire 유지(comboParams @mnuId).
export const CELL_DIVISION_COLUMN = 'DIVISION_ID';

// REQUEST_NO 이미지셀 드릴다운(design 03 §3-4 / 00 §4d 가드 2건) — 값 존재 시 클릭하면 SCM0002 요청 상세 팝업.
export const REQUEST_NO_COLUMN = 'REQUEST_NO';

// chkCurrent(현재값만 보기) 행 판정 키(hidden) + 현재값 코드(design 03 §1 #47 / §3 SetCheckRow).
export const LAST_SEQ_COLUMN = 'LAST_SEQ';
export const LAST_SEQ_CURRENT = 'C';

// chkCurrent 강조색 — AS-IS SetBGColor(LightSkyBlue alpha80, design 03 §3 #6/#10).
export const CURRENT_ROW_BG = 'rgba(135, 206, 250, 0.8)';

// Freeze 경계 컬럼 수(design 03 §3-1, AS-IS Freeze(0, CONFIRM_ID+1) = DIVISION_ID~CONFIRM_ID 7열).
//   실제 고정은 SCM_MST_SHEET_COLUMNS.FIXED_FLAG='Y'(SORT_ORDER_NO 1~7) 메타로 구동(CLAUDE §2 체크4 — FE 리터럴
//   fixed:true 덮어쓰기 금지, AS-IS 코드 Freeze 를 메타로 정비, 05_register.sql). DataGrid frozenColumns=findLastIndex(_fixed)+1.
export const FREEZE_COLUMN_COUNT = 7;

// Division 전극(EE) 판정 — code==='EE' 만 제외(design 02 §2.2, EE_HD~EE_UC 는 유지). cascade EE 분기는 prefix 'EE'.
export const ELECTRODE_DIVISION_EXACT = 'EE';
export const ELECTRODE_DIVISION_PREFIX = 'EE';

// TO-BE MSG 코드 (SCM_ADM_MSG_M 문구 역조회 확정 — Hook #114, ora.py 실측 2026-09-24):
//   NO_DIVISION_AUTH = MSG00667("No authority assigned.") — 권한 division 0건 게이트(design 01 §2#1). AS-IS
//     SetDivisionAuthCheck 는 MSG00097 을 쓰나 TO-BE MSG00097 문구는 "Please select Division." 라 의도가 다르다
//     -> 자매 shipment-semi-dept-day 확정대로 MSG00667 로 매핑(번호가 아니라 문구, 메모리 hook#114 선례).
//   INVALID_PERIOD = MSG00219("Invalid period (start > end).") — 기간 역전(Check_PeriodDate 등가, design 02 §4).
//     기간 공백은 CRUD_MSG.REQUIRED_FIELD('{0} value is required.')로 안내(MSG00134 는 TO-BE 미등록).
export const MSG = {
  NO_DIVISION_AUTH: 'MSG00667', // "No authority assigned." (권한 division 0건)
  INVALID_PERIOD: 'MSG00219', // "Invalid period (start > end)." (기간 역전)
} as const;

// LBL 코드 (design 02 §4.5 — 전건 기존 등록, 신규 0). 조회조건 라벨.
export const LBL = {
  DIVISION: 'LBL00641',
  FROM_SITE: 'LBL00022',
  TO_SITE: 'LBL00023',
  INCOTERMS: 'LBL00024',
  TRANS_MODE: 'LBL00025',
  SHIPMENT_DATE: 'LBL01115',
  MODEL: 'LBL00669',
  SO_NO: 'LBL01111',
  CONFIRM_ID: 'LBL01063',
  CURRENT: 'LBL01065',
  SEARCH: 'LBL00664',
} as const;

// 컬럼 메타 fallback (design 03 §1 — DB SCM_MST_SHEET_COLUMNS 47행 실측, SORT_ORDER_NO 순).
//   admin 등록본이 있으면 authoritative(실측 47행 배포됨, design 03 §0). 미등록/실패 시 이 fallback.
//   전열 읽기전용(INPUT_TP_CD 전건 'S', LockColumn). 셀유형/정렬/폭은 design 03 §1 사양표 그대로.
export interface ColumnMeta {
  key: string;
  header: string;
  width: number;
  align: 'L' | 'C' | 'R';
  visible?: boolean;
  cell?: 'combo' | 'date' | 'datetime' | 'number';
}

export const MAIN_COLUMNS: ColumnMeta[] = [
  { key: 'DIVISION_ID', header: 'Div', width: 30, align: 'C', cell: 'combo' },
  { key: 'FROM_SITE', header: 'From Site', width: 80, align: 'L' },
  { key: 'ITEM_ID', header: 'Model', width: 100, align: 'L' },
  { key: 'NICK_NAME', header: 'Nick Name', width: 70, align: 'L' },
  { key: 'TO_SITE', header: 'To Site', width: 130, align: 'L' },
  { key: 'END_CUSTOMER', header: 'End Customer', width: 80, align: 'L' },
  { key: 'CONFIRM_ID', header: 'Confirm ID', width: 120, align: 'C' },
  { key: 'SEQ', header: 'Seq', width: 60, align: 'C', cell: 'number' },
  { key: 'SHIPMENT_DATE', header: 'Shipment Date', width: 80, align: 'C', cell: 'date' },
  { key: 'QTY', header: 'Qty', width: 75, align: 'R', cell: 'number' },
  { key: 'TRANSPORT_MODE', header: 'Trans Mode', width: 60, align: 'C' },
  { key: 'INCOTERMS', header: 'Incoterms', width: 65, align: 'C' },
  { key: 'BEFORE_SHIPMENT_DATE', header: 'Before Shipment Date', width: 80, align: 'C', cell: 'date' },
  { key: 'BEFORE_QTY', header: 'Before QTY', width: 60, align: 'R', cell: 'number' },
  { key: 'BEFORE_TRANSPORT_MODE', header: 'Before Trans Mode', width: 60, align: 'C' },
  { key: 'BEFORE_INCOTERMS', header: 'Before Incoterms', width: 65, align: 'C' },
  { key: 'CUSTOMER_LT', header: 'L/T(Day)', width: 80, align: 'R' },
  { key: 'ERP_SO_NO', header: 'SO No', width: 100, align: 'C' },
  { key: 'TYPE', header: 'Type', width: 80, align: 'C' },
  { key: 'CHANGE_TYPE', header: 'Change Type', width: 100, align: 'C' },
  { key: 'CHANGE_REASON_CODE', header: 'Change Reason', width: 150, align: 'L', cell: 'combo' },
  { key: 'CHANGE_REASON_DETAIL', header: 'Change Reason Detail', width: 150, align: 'L' },
  { key: 'REQUESTOR', header: 'Requestor', width: 100, align: 'L' },
  { key: 'REQUESTOR_DEPT_NAME', header: 'Requestor Dept Name', width: 150, align: 'L' },
  { key: 'REQUEST_DATE', header: 'Request Date', width: 80, align: 'L', cell: 'datetime' },
  { key: 'APPROVAL', header: 'Approval', width: 100, align: 'L' },
  { key: 'APPROVAL_DEPT_NAME', header: 'Approval Dept Name', width: 150, align: 'L' },
  { key: 'APPROVAL_DATE', header: 'Approval Date', width: 80, align: 'L', cell: 'datetime' },
  { key: 'REQUEST_NO', header: 'Request No', width: 120, align: 'C' },
  { key: 'BUILDING', header: 'Building', width: 80, align: 'L' },
  { key: 'REMARKS', header: 'Remarks', width: 120, align: 'L' },
  { key: 'SHIPMENT_REQUESTOR', header: 'Shipment Requestor', width: 100, align: 'L' },
  { key: 'CUSTOMER_REQUIRMENT', header: 'Customer Requirement', width: 150, align: 'L' },
  { key: 'SOLD_TO_PARTY', header: 'Sold To Party', width: 130, align: 'L' },
  { key: 'SHIP_TO_PARTY', header: 'Ship To Party', width: 130, align: 'L' },
  { key: 'MODEL_PIC', header: 'Model PIC', width: 150, align: 'L' },
  { key: 'PROJECT_NAME', header: 'Project Name', width: 100, align: 'L' },
  { key: 'FCST_TYPE', header: 'FCST Type', width: 100, align: 'L', cell: 'combo' },
  { key: 'MTK_OWNER', header: 'MKT Owner', width: 80, align: 'L' },
  { key: 'LAST_UPDATE_DATE', header: 'Last Update Date', width: 80, align: 'L', cell: 'datetime' },
  { key: 'SHIPMENT_DATE_CHANGE', header: 'Shipment Date Change', width: 60, align: 'C' },
  { key: 'VARIABLE_DATE', header: 'Variable Date', width: 80, align: 'R', cell: 'number' },
  { key: 'QTY_CHANGE', header: 'Qty Change', width: 60, align: 'C' },
  { key: 'VARIABLE_QTY', header: 'Variable Qty', width: 60, align: 'R', cell: 'number' },
  { key: 'TRANS_MODE_CHANGE', header: 'Trans Mode Change', width: 60, align: 'C' },
  { key: 'REMARKS_CHANGE', header: 'Remarks Change', width: 60, align: 'C' },
  { key: 'LAST_SEQ', header: 'Last Seq', width: 60, align: 'C', visible: false },
];
