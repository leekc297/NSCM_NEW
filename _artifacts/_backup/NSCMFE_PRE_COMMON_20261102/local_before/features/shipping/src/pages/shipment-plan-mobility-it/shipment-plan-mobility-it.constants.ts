export const MENU_ID = 'SSP0015' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SSP.Plan.UIL SSP0015_ShipmentPSI (Shipment Plan(Mobility & IT), 9,856줄 정본 — 00_checklist §0):
//   설계 근거: .atlas/gscm-design/SSP0015/design/00_checklist.md ~ 03_grid-columns.md, 매핑 __asis-mapping__.md.
//   - master PSI pivot(2 시트: 일반 Mobility&IT / Packer) = 측정치×기간(D_/W_/M_/B_ 서버 wide) + detail 다중 sheet.
//   - Division 은 '40' 고정(disabled) — 검색 SP p_division_id 항상 '40'(design 02 §2.1).
//   - Plant Site 는 master 활성시트별 comboId 스왑(Main=ShipmentRequestPlantSite_SCP / Packer=FromSiteByDivisionOspPack).
//   - 편집 화이트리스트(design 03 §3) — DB INPUT_TP_CD 336건 전건 'S' 갭(#A)이라 코드 화이트리스트로 재현.
//   - 툴바 5버튼(Find/Insert/Delete/Save/Edit) 전부 실동작(NO-OP 없음, 00 §4d) — EditButton 모드토글은 미이식(편집 기본 ON).
export enum SHEETS {
  MAIN = 'main', // spdMain 일반 "Shipment PSI(Mobility & IT)" (PSI pivot) — P_SSP0015_GET_SHIPMENT_PSI
  MAIN_PACKER = 'mainPacker', // spdMain Packer "Shipment PSI(Packer)" — P_SSP0015_GET_SHIPMENT_PSI_PACKER
  CALENDAR = 'calendar', // PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN (3단 헤더 메타)
  CONFIRM_DETAIL = 'confirmDetail', // shtDetail "Shipment Confirm Detail" (72열, 편집) — GET/SAVE_SHIPMENT_REQUEST_CONFIRM_40
  HOLD_STOCK = 'holdStock', // "Hold stock" (12열, 편집 insert) — GET_BLOCK_STOCK o_rc1 / SAVE_BLOCK_STOCK_DATA
  MES_STOCK = 'mesStock', // AS-IS shtMesStock "Stock Detail" (편집) — GET_MES_STOCK / SAVE_MES_STOCK
  WH_STOCK = 'whStock', // "W/H stock" (19열, 읽기전용) — GET_WH_STOCK o_rc1
  SCS_STOCK = 'scsStock', // "SCS Stock Detail" (9열, 읽기전용) — GET_SCS_STOCK
  STOCK_LOCATION_DETAIL = 'stockLocationDetail', // "Stock Location Detail" (20열, 읽기전용) — GET_STOCK_LOCATION_DETAIL
  SHIPMENT_RESULT = 'shipmentResult', // "Shipment Result" (19열, 읽기전용) — GET_SHIPMENT_RESULT
  // drill/서브 detail — 부모 SP 2번째 커서(O_RC2)/드릴다운으로 채움(전용 GET SP 없음, AS-IS도 동일).
  WH_STOCK_DETAIL = 'whStockDetail', // "W/H stock Detail" (25열, 읽기전용) — GET_WH_STOCK o_rc2 (.cs L3820)
  HOLD_STOCK_DETAIL = 'holdStockDetail', // "Hold stock Detail" (12열, 읽기전용) — GET_BLOCK_STOCK o_rc2
  WH_IN_PLAN_DETAIL = 'whInPlanDetail', // "WH In Plan Detail" (13열, 읽기전용) — WH_IN measure 드릴다운
}

// NSCM cursor 표준 — main 은 3-cursor(o_rc1 PSI). 나머지는 o_rc1.
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  CALENDAR: 'o_rc1',
  DETAIL: 'o_rc1',
} as const;

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — DB 실측 그대로 (design 03 §1, ora.py 2026-09-27).
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'Shipment PSI(Mobility & IT)',
  [SHEETS.MAIN_PACKER]: 'Shipment PSI(Packer)',
  [SHEETS.CONFIRM_DETAIL]: 'Shipment Confirm Detail',
  [SHEETS.HOLD_STOCK]: 'Hold stock',
  [SHEETS.MES_STOCK]: 'Stock Detail', // AS-IS shtMesStock 표시명(GET_MES_STOCK) — 이전 'MES Stock Detail' 정정
  [SHEETS.WH_STOCK]: 'W/H stock',
  [SHEETS.SCS_STOCK]: 'SCS Stock Detail',
  [SHEETS.STOCK_LOCATION_DETAIL]: 'Stock Location Detail',
  [SHEETS.SHIPMENT_RESULT]: 'Shipment Result',
  [SHEETS.WH_STOCK_DETAIL]: 'W/H stock Detail',
  [SHEETS.HOLD_STOCK_DETAIL]: 'Hold stock Detail',
  [SHEETS.WH_IN_PLAN_DETAIL]: 'WH In Plan Detail',
};

// 하단 SUM footer 숫자 서식 — AS-IS "{0:#,##0.###}"(SetAggregationFormat L1066) 1:1. 천단위 + 소수는
//   있을 때만 최대 3자리(뒷자리 0 숨김). 종전 'n3' 는 소수 3자리를 '항상' 찍어 정수 합계에 ".000" 이
//   붙어 상단 정수 표기와 어긋났다(사용자 신고 2026-10-02). '#,##0.###' 는 정수면 소수 미표시 → 상단과 일치.
export const FOOTER_FORMAT = '#,##0.###';

// 컬럼/Measure 개인화 저장 구분값 (SCM_MST_TITLESET_USER)
export const TITLESET_COLUMN_TYPE = 'C';
export const TITLESET_MEASURE_TYPE = 'M';

// Division 고정값 (design 02 §2.1 — clbDivision.ControlValues='40' + Enabled=false)
export const FIXED_DIVISION = '40';

// ====================================================================================
// 조회조건 콤보/lookup (design 02 §2·§5 — SCM_ADM_CMBO_SQL_M 실측, ora.py 2026-09-27)
//   cascade 전량 재조회(Filter 없음, 02 §3) — 트리거는 master 활성시트(searchParams 바깥).
// ====================================================================================
export const COMBO = {
  // Division — 사용자 권한 Division 목록(@sesUserId BE주입 @mnuId). 옵션만 콤보로, 값은 FIXED_DIVISION 고정.
  DIVISION: 'MyDivisionInEE',
  // Plant Site — master 활성시트별 스왑 (design 02 §2.2). 이름유사 재사용 금지(convert-core §2.6).
  PLANT_SITE_MAIN: 'ShipmentRequestPlantSite_SCP', // @divisionId @operationGroup='P' @param3='E' (Pack·전극 제외)
  PLANT_SITE_PACKER: 'FromSiteByDivisionOspPack', // @divisionId @__GROUP__ @sesUserId(BE주입) (OSP Pack)
  BUCKET: 'BucketType', // lookup BUCKET_TYPE_CODE — AS-IS 완전 일치(DM0003_GET_BUCKET_TYPE_CODE)
  // Plan Date — AS-IS PlanDateShip 등가(SSP_MST_SHIP_REQ, CUTOFF_FLAG='Y'). 'PlanDateShip' 콤보 신규 등록 대상.
  //   기존 'PlanDate'(SCP_PLAN_VERSION_V 공급계획 버전)는 원천이 달라 교체. @divisionId.
  PLAN_DATE: 'PlanDateShip', // @divisionId
  // Period 조회구간 — @fromDate(Plan Date) @offsetDay(31) @timeZone. 결과 1행 CODE="YYYYMMDD:YYYYMMDD".
  //   SCM_ADM_CMBO_SQL_M 실존(콤보). AS-IS GetDayRange 등가(design 02 §2.5 / I08).
  DAY_PERIOD: 'SCM0001_GET_SCP_DAY_PERIOD',
} as const;

export const LOOKUP = {
  // Mobility&IT clbResultType — 유효행 [P=Plan, O=Result(LSP WM. oWMS), E=Result(ERP), R=Return] 중 Main 은 R 제외 → [P,O,E].
  SHIPMENT_RESULT_TYPE: 'SSP_SHIPMENT_RESULT_TYPE',
  // Packer 전용 lookup — [P=Plan, S=Result(PSCM)] 2행(DB 실측 SCM_ADM_LOOKUP_MASTER_DETAIL). Packer 는
  //   base lookup 클라 필터가 아니라 이 전용 lookup 을 쓴다(사용자 확정 2026-10-01 — 운영 파리티).
  SHIPMENT_RESULT_TYPE_PACKER: 'SSP_SHIPMENT_RESULT_TYPE_PACKER',
  // My Model 기본체크 whitelist — 유효행 CODE(=회사ID) 가 로그인 사용자 회사와 일치하면 로드 시 chkMyModel 자동 ON.
  //   AS-IS Form_Load: LookupCommon "MY_MODEL_DEFAULT_CHECK" + SSP0015 프로그램권한 → chkMyModel.Checked=true.
  MY_MODEL_DEFAULT_CHECK: 'MY_MODEL_DEFAULT_CHECK',
  // 출하일 입력 가능 기간 — 1D+ = 오늘+N일(상한), 2D- = 오늘-N일(하한). AS-IS dateMax/MinShipDate
  SHIPMENT_PERIOD_DAY: 'SHIPMENT_PERIOD_DAY',
  // 출하일 범위 메시지 인자 dDay(-56). AS-IS dtBaseDay
  CHANGE_REQ_DAY: 'CHANGE_REQ_DAY',
} as const;

// Bucket Type — 기본 Daily. 값은 BucketType 콤보 CODE 와 동일해야 선택 매칭됨(콤보 실측 DAILY/WEEKLY/MONTHLY).
//   FE 전용(검색 SP 미전달, isDynVisible 그리드 표시 토글에만 사용).
export enum BUCKET_TYPE {
  DAILY = 'DAILY',
  WEEKLY = 'WEEKLY',
  MONTHLY = 'MONTHLY',
}

// Result Type 시트별 코드셋(기본체크·payload용) — Main 은 base lookup 에서 클라 R제외 [P,O,E],
//   Packer 는 전용 lookup SSP_SHIPMENT_RESULT_TYPE_PACKER 그대로 [P=Plan, S=Result(PSCM)].
export const RESULT_TYPE_BY_SHEET = {
  MAIN: ['P', 'O', 'E'],
  PACKER: ['P', 'S'],
} as const;

export const ALL = 'ALL';
export const PROGRAM_ID = MENU_ID;

// drpPeriod/2 초기범위 offset (design 02 §2.5 — SCM0001_GET_SCP_DAY_PERIOD offset 31, Packer -1일)
export const PERIOD_OFFSET_DAY = 31;
// drpPeriod3(ShipmentResult 전용) 기본 = 오늘-9 ~ 오늘-1 (AS-IS ShipmentResult_GetDayRange)
export const PERIOD3_FROM_OFFSET = -9;
export const PERIOD3_TO_OFFSET = -1;

// 기간 최대범위 메시지 문구 인자({0}) — AS-IS MSG00172 "From Date + 371". 실제 경계는 고정 371 이
//   아니라 From Date + 1년 + 7일(윤년 2/29 포함 구간이면 372~373일) — 아래 handleSearch 계산 참조.
export const MAX_PERIOD_LABEL_DAYS = 371;

// ====================================================================================
// 편집 화이트리스트 (design 03 §3 — DB INPUT_TP_CD 전건 'S' 갭#A라 코드 상수로 재현.
//   admin 메타(INPUT_TP_CD) 정비 시 이 상수를 제거하고 메타 기준으로 전환)
// ====================================================================================
// Shipment Confirm Detail(shtDetail) — SHIPMENT_STATUS=='C' && ERP_STATUS!='C' 행만 unlock (03 §3.A/B).
//   AS-IS LockColumn(SSP0015.cs L1856-1866): 중간블록(FCST_TYPE+1 ~ INCOTERMS-1)은 양 탭 편집 —
//   Qty/Date/Trans Mode + REMARKS2(Building)/REMARKS(Remarks)/CHANGE_REASON_CODE/DETAIL/REMARKS3(Customer Requirement).
export const CONFIRM_DETAIL_EDITABLE_COLUMNS = [
  'SHIPMENT_CONFIRM_QTY',
  'SHIPMENT_DATE',
  'TRANSPORT_MODE',
  'REMARKS2',
  'REMARKS',
  'CHANGE_REASON_CODE',
  'CHANGE_REASON_DETAIL',
  'REMARKS3', // Customer Requirement — 양 탭 편집(이전 누락, 사용자 지적 2026-10-01)
] as const;

// Packer 탭 전용 추가 편집 컬럼 — Ship to(TO_SITE_SHIPTO_CODE). AS-IS L1864: Packer 만 INCOTERMS~SHIPTO-1
//   을 잠그고 SHIPTO 는 unlock(Mobility&IT 은 INCOTERMS~끝 잠금이라 SHIPTO 편집불가).
export const CONFIRM_DETAIL_PACKER_EXTRA_EDITABLE = ['TO_SITE_SHIPTO_CODE'] as const;

// SO그룹 전파 대상 (03 §3.B — ERP_SO_NO 동일 행 전파). AS-IS 변경감지/전파(L6262~6267)는 Qty/Date/Trans/
//   Build(REMARKS2)/Remark(REMARKS)/Reason/Ship to — REMARKS3(Customer Requirement)는 전파 대상 아님(편집셋과 분리).
export const SO_GROUP_PROPAGATE_COLUMNS = [
  'SHIPMENT_CONFIRM_QTY',
  'SHIPMENT_DATE',
  'TRANSPORT_MODE',
  'REMARKS2',
  'REMARKS',
  'CHANGE_REASON_CODE',
  'CHANGE_REASON_DETAIL',
  'TO_SITE_SHIPTO_CODE',
] as const;

// Hold stock — Edit 모드 전행 unlock 3컬럼 (design 03 §1.E)
export const HOLD_STOCK_EDITABLE_COLUMNS = ['RELEASE_YYYYMMDD', 'HOLD_QTY', 'REMARKS'] as const;

// MES Stock Detail — 편집 컬럼(design 03 §1.E — USER_MOD_RELEASE_DATE·REMARKS)
export const MES_STOCK_EDITABLE_COLUMNS = ['USER_MOD_RELEASE_DATE', 'REMARKS'] as const;

// master 편집 대상 측정치 (design 03 §1.A/§3.A) — MEASURE=='WH_IN' 행의 D_ 기간셀만 편집
export const MAIN_EDITABLE_MEASURE = 'WH_IN';

// master 에서 왼쪽 컬럼과 무관하게 세로 병합하는 컬럼 (design 03 §3.D — AS-IS MergePolicy.Always)
export const MAIN_ALWAYS_MERGE_COLUMNS = ['TYPE', 'PSI_NAME'];

// master 에서 같은 Model 그룹 안이면 값이 같은(빈 값 포함) 행끼리 세로 병합하는 컬럼 (Aging L/T, Yield, TYPE)
export const MAIN_GROUP_MERGE_COLUMNS = ['LT_DAY', 'YEILD', 'TYPE'];
export const MAIN_GROUP_MERGE_KEYS = ['DIVISION_ID', 'FROM_SITE', 'ITEM_ID'];

// master 헤더에서 "BOH" 한 칸으로 합치는 컬럼 (AS-IS HeaderSpan, SSP0015.cs L761)
export const MAIN_BOH_HEADER_COLUMNS = ['TYPE', 'FIGURE'];

// ====================================================================================
// MSG — SCM_ADM_MSG_M 문구 역조회 실측 대상(Hook #114). 미역조회분은 AS-IS 번호 보존 + defaultValue fallback.
//   주의: SSP0060 이 역조회한 코드 다수는 재사용 가능하나, 이 화면 전용 재조회는 04_react-gap.md 확인필요로 남긴다.
// ====================================================================================
export const MSG = {
  // (MSG00007) Measure 활성 그리드 없음
  GRID_NOT_READY: 'MSG00284',
  // (MSG00084) Main 일자수량 음수
  NEGATIVE_QTY: 'MSG00225',
  // (MSG00133) 변경 없음 — (AS-IS MSG00133 는 TO-BE 미등록 → 같은 문구 MSG00004, KO/EN/CN)
  NO_MODIFICATION: 'MSG00004',
  // 저장 변경 없음 표준 코드(MSG00133 은 TO-BE 미등록)
  NO_CHANGES: 'MSG00004',
  // 미저장 변경 상태 조회 확인(공용 조회 가드와 같은 문구)
  UNSAVED_SEARCH: 'MSG00704',
  // (MSG00098) 팝업 오픈 전 필수값
  REQUIRED_FIELDS: 'MSG00013',
  // (MSG00278) 운송수단 필수
  REQUIRED_VALUE: 'MSG00429',
  // (MSG00287) 변경사유코드 미선택
  REASON_CODE_FIRST: 'MSG01291',
  // (MSG00286) 행별 변경사유 필수
  ROW_REASON_REQUIRED: 'MSG01289',
  // SSP Planner 권한 없는 사용자(Edit 가드 R7a, I06). AS-IS MSG00251 "SSP Planner 권한이 없는 사용자 입니다. User ID:{0}"
  //   → TO-BE 문구 역조회 MSG01261(012xx 신규계열, 동일 문구). 종전 MSG00667("Division 권한 없음")은 오매핑 — I19 수정.
  NO_AUTHORITY: 'MSG01261',
  // (MSG00170) 최신 아닌 Plan 편집 차단(Edit 가드 R7b)
  OLD_PLAN_EDIT_BLOCK: 'MSG01185',
  // 기간 검증 — AS-IS DateUtil.Check_PeriodDate(drpPeriod) (SSP0015.cs L2188/2307/2426).
  //   (MSG00049) 기간 미입력 / (from>to) 역순 / (MSG00172) 최대범위 초과(From Date+1년+7일, 문구 {0}=371)
  PERIOD_EMPTY: 'MSG00665',
  PERIOD_ORDER: 'MSG00108',
  PERIOD_MAX: 'MSG01187',
  // 읽기전용 셀 편집 거부 (AS-IS MSG00109 "읽기전용 상태입니다" → TO-BE 문구 역조회 MSG00109 동일, SCM_ADM_MSG_M 실측).
  //   주의: 종전 MSG00284 는 "Grid 가 준비되지 않았습니다"(GRID_NOT_READY)라 오매핑이었음 — I19 수정(2026-10-07).
  READONLY_SHEET: 'MSG00109',
  // 저장 성공/실패 — 공용 훅 표준값
  SAVED: 'MSG00002',
  SAVE_FAILED: 'MSG00003',
  // Confirm 변경 2분 이내 재변경 LOCK (AS-IS MSG00404 → TO-BE MSG01395). SCM_SSP_CHECK_CONFIRM_CHANGETIME='X'.
  CONFIRM_CHANGETIME_LOCK: 'MSG01395',
  // ERP SO No 동일 건수 불일치 (AS-IS MSG00247 → TO-BE MSG00247, 문구 역조회 동일). 같은 SO 는 전건이 한 화면에.
  SO_NO_COUNT_MISMATCH: 'MSG00247',
  // Shipment Date 날짜 형식 오류 (AS-IS MSG00049 "유효한 날짜 형식..." → TO-BE 문구 역조회 MSG01081).
  INVALID_DATE_FORMAT: 'MSG01081',
  // 출하일 입력 가능 기간 밖 (AS-IS MSG00194 "변경요청은 현재일 기준 D+{0} 출하일부터..." → TO-BE MSG01206)
  SHIP_DATE_OUT_OF_RANGE: 'MSG01206',
  // GetShipmentStatusChk 저장 게이트 3커서 (AS-IS SSP0015.cs GetShipmentStatusChk, 002xx → TO-BE 012xx 역매핑).
  //   o_rc1: 다른 사용자가 변경요청한 CONFIRM_ID 존재 (AS-IS MSG00248 → MSG01258, SCM_ADM_MSG_M 실측 일치).
  STATUS_OTHER_USER_REQUEST: 'MSG01258',
  //   o_rc2: 확정계획이 삭제됨(Qty:0)인 CONFIRM_ID (AS-IS MSG00249 → MSG01259).
  STATUS_DELETED_QTY0: 'MSG01259',
  //   o_rc3: ERP 에 DO 생성됨(ERP_STATUS='C') → 변경 불가 (AS-IS MSG00189 → MSG01202).
  STATUS_ERP_DO_CREATED: 'MSG01202',
} as const;

// ====================================================================================
// LBL — SCM_ADM_MSG_M 실측(design 02 §4.5 — 전 라벨 매칭 존재, 신규 등록 0건).
// ====================================================================================
export const LBL = {
  DIVISION: 'LBL00001',
  FROM_SITE: 'LBL00022',
  BUCKET: 'LBL00710',
  SUM: 'LBL00687',
  PLAN_DATE: 'LBL00039',
  PERIOD: 'LBL00013',
  ITEM: 'LBL01142',
  MODEL: 'LBL00669',
  MODEL_NICKNAME: 'LBL00618', // 하단(detail) Model 필드 — "Model/Nickname"(사용자 지시 2026-10-07)
  LOT_ID: 'LBL01090',
  REQUESTOR: 'LBL01108',
  MY_MODEL: 'LBL01093',
  PART_LEADER: 'LBL01101',
  TEAM_LEADER: 'LBL01124',
  DELEGATEE: 'LBL01070',
  RESULT_TYPE: 'LBL01109',
  SHIPMENT_DATE: 'LBL01115',
  MEASURE: 'LBL00310',
  SEARCH: 'LBL00112', // 상단 SearchArea 검색(F5)
  SEARCH_GRID: 'LBL00664', // 하위 detail bar 검색(그리드 부착)
  EDIT: 'LBL00783',
  MEMO: 'LBL_MEMO', // Memo(우클릭 코멘트) — DB 미등록 키 → defaultValue 'Memo' 표시(LBL00669=Model 재사용 금지)
} as const;

// Memo(Comments) — WH_IN 셀 우클릭 메모(엑셀 메모형). GET/SAVE 버튼코드(SCM_ADM_MNU_BTN_MPG_M, SHT_NM='main').
//   엔드포인트 /{MENU_ID}/main/{code}/call-proc 로 proc 해석(PR_GET_PROC_INFO_LIST).
export const COMMENTS_BTN = {
  GET: 'GET_SHIPMENT_PSI_COMMENTS',
  SAVE: 'SAVE_SHIPMENT_PSI_COMMENTS',
} as const;

// ERP_SO_NO 더블클릭 → OrderDetail(SSP0300) 팝업 조회 버튼코드 (AS-IS SSP0300_GET_ORDER_DETAIL).
//   주의: PKG_SSP0300 / ORDER_DETAIL proc 은 TO-BE 미배포(DB 실측 2026-10-01 0건) — 배선 완비, 런타임
//   데이터는 convert-sp 배포 후 완성(SCM0002 팝업 선례와 동일). 배포 시 mnuId/btnCd 매핑 등록 필요.
export const ORDER_DETAIL_BTN = 'GET_ORDER_DETAIL';

// CHANGE_REQ_NO 셀 클릭 → 변경요청 상세(Drafting) 팝업 조회 버튼코드 (I13, AS-IS SCM0002_ShipmentPlanRequestPopup).
//   AS-IS SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING → TO-BE PKG_SSP0003.P_SSP0003_GET_REQ_DRAFTING
//   (o_rc1=Confirmed/Change 비교 그리드). API_M(P_SSP0003_GET_DRAFTING)·PROC_M 는 SSP0003 등록분 재사용,
//   SSP0015/main 버튼+권한만 신규 등록(output/ssp0015_change_req_drafting_register.sql). 엔드포인트 /SSP0015/main/{code}/call-proc.
export const REQ_DRAFTING_BTN = 'GET_REQ_DRAFTING';

// R7a 편집 진입 가드(I06) — SSP 등록 사용자 체크. AS-IS GetSSPUserCheck(cs L9895) = SSP0002_GET_USER_INFO_LIST.
//   TO-BE: /SSP0015/main/USER_CHECK/call-proc {userId, language, ssoUserYn:'N'} → o_rc1 0행 or 403 이면 비SSP.
//   API_M(P_SSP0200_USER_CHECK → PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST)·PROC_M 재사용, 버튼+권한만 등록
//   (output/ssp0015_user_check_register.sql, 권한 ADMIN·SSP Planner).
export const USER_CHECK_BTN = 'USER_CHECK';

// ====================================================================================
// ERP I/F (SAP PI) 실시간 송신 — AS-IS GetErpIFCheckNew(cs:7262) 의 TO-BE 등가
// ====================================================================================
// AS-IS `CallClient.FN_ERP_UIWebService(RequestNo, "C", "")` 자리. TO-BE 는 BE 공통 창구
//   (framework/webservice/WebServiceCommonController `POST /common/web-service/{serviceKey}/call`)를 거치고,
//   BE 가 serviceKey=erpIf 를 nscm-if `POST /api/if/send/NSD0100` 으로 라우팅한다(config.nscm-if.routes).
//   응답은 AS-IS 와 같은 `{ E_TYPE, E_MESSAGE }` — E_TYPE = AS-IS RtFlag,
//   E_MESSAGE = AS-IS ReErrorMsg('^' 구분 `confirmId:msg`). 자매 SSP0200 과 같은 축이다.
//   배선 점검용 mock 은 BE 에 `/common/web-service/erpIf/call-test` 로 남아 있다.
export const ERP_IF_PATH = '/common/web-service/erpIf/call';
export const ERP_IF_CHANGE_TYPE = 'C'; // AS-IS 2번째 인자 "C"(변경요청)
export const ERP_IF_SUCCESS = 'S'; // E_TYPE 정상 — AS-IS else 분기
export const ERP_IF_ERROR = 'E'; // AS-IS RtFlag 'E' — ERP 전건 거절
export const ERP_IF_PARTIAL_ERROR = 'S_E'; // AS-IS RtFlag 'S_E' — 일부 거절
export const ERP_IF_NO_DATA = 'F'; // AS-IS RtFlag 'F' — 데이터 없음·서버오류(cs:7243)
export const ERP_IF_PI_FAIL = 'C_E'; // AS-IS RtFlag 'C_E' — SAP PI 호출 실패(CallClient catch)

// 수정행 저장 1단계 — 변경요청 초안(CHG_REQ·CHG_REQ_DE INSERT + XIF 'C' 적재 + 요청번호 채번).
//   AS-IS cs:7011/7015. 메타 등록 실측(SCM_ADM_MNU_BTN_MPG_M, USE_YN='Y').
export const BTN_SAVE_DRAFTING = 'SAVE_SHIPMENT_REQUEST_DRAFTING';
export const BTN_SAVE_DRAFTING_PACKER = 'SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER';

// ERP 거절 보상 — AS-IS cs:7298(초안 되돌림)·오류 적재. 둘 다 메타 등록 완료(USE_YN='Y'):
//   DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM → P_SSP0015_SCM_SSP_DEL_DRAFTING_BY_CONFIRM
//   ERP_ERROR_CONFIRM                           → P_SSP0015_SCM_SSP_ERP_ERROR_CONFIRM
export const BTN_DELETE_DRAFTING_BY_CONFIRM = 'DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM';
export const BTN_ERP_ERROR_CONFIRM = 'ERP_ERROR_CONFIRM';
export const ERP_DELETE_FLAG = 'D'; // AS-IS p_del_flag(cs:7302)
export const ERP_IF_SEND_ON = 'Y'; // AS-IS p_if_send_flag(cs:7305)
export const ERP_ERROR_E_TYPE = 'E'; // AS-IS p_e_type 고정값

// 2차 적재 — AS-IS CHG_BATCH('B', REQ_NO)(cs:7317~7334) 의 TO-BE 등가.
//   전용 SP 를 만들지 않고 PKG_SSP0003.P_SSP0003_SAVE_REQ_IF_CHECK 를 빌려 쓴다. 그 SP 는
//   changeStatus='A' + changeType='C' 에서 V_STATUS='B' 로 CHG_BATCH 만 하고 COMMIT 한다
//   (BODY 1850/1852/1858/1882 실측).
//   선례: SSP0015 의 GET_REQ_DRAFTING 이 P_SSP0003_GET_DRAFTING 을 빌려 쓴다(SSP0012·0021 도 동일).
//   필요 메타 1행 — MNU_ID='SSP0015', SHT_NM='main', MNU_BTN_CD='IF_CHECK',
//                   API_ID='P_SSP0003_GET_IF_CHECK'  ← SSP0003 등록값과 같아야 한다
//   (주의: API_ID 는 `P_SSP0003_IF_CHECK` 가 아니다. 실제 등록값은 GET 접두가 붙어 있다.)
export const BTN_IF_CHECK = 'IF_CHECK';
export const IF_CHECK_STATUS_APPLY = 'A'; // 이 값에서만 CHG_BATCH 가 돈다(BODY 1850)
export const IF_CHECK_PARTIAL_OFF = 'F'; // IFSEQ merge 안 함(AS-IS GetErpIFCheck 는 'F' 고정)

// ERP 송신 결과 메시지 — AS-IS GetErpIFCheck/New 의 RtFlag 분기(cs:7230~7259)를 그대로 옮긴다.
//   TO-BE 코드는 SCM_ADM_MSG_M 실측(2026-10-25, KO/EN USE_YN='Y', AS-IS 문구와 동일).
//   종전에는 세 분기를 MSG.SAVE_FAILED 하나로 뭉쳤는데, AS-IS 는 원인별로 다른 안내를 준다.
export const MSG_ERP = {
  ISSUE: 'MSG01208', // AS-IS MSG00197 — RtFlag 'E'/'S_E', {0}=ReErrorMsg
  SYSTEM_ERROR: 'MSG01215', // AS-IS MSG00204 — RtFlag 'F', {0}=Request No
  PI_FAIL: 'MSG01309', // AS-IS MSG00306 — RtFlag 'C_E'
} as const;
