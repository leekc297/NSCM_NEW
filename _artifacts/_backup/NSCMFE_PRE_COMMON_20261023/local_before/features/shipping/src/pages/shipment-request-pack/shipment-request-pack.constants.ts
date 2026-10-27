export const MENU_ID = 'SSP0026' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SSP.Forms.UIL.Plan.SSP0026_ShipmentRequestPack(정본, controls 76) — pivot 메인그리드
//   (Pack Biz/Cell Biz 2탭) + 상세(Request Detail 편집/Result Detail 읽기전용 2탭) + 엑셀전용 1시트.
//   설계 근거: .atlas/gscm-design/SSP0026/design/00_checklist.md ~ 03_grid-columns.md(v4),
//   convert-flow/goal.md·plan.md(v2, 정본 백본 재정정).
//   - GET  SP(6, 배포됨): P_SSP0026_GET_REQUEST_DETAIL_PACK / _GET_RESULT_DETAIL /
//     _GET_REQUEST_DETAIL_PACK_EXCEL_DOWN / _GET_SPREAD_TITLE / _GET_BOD_ITEM / _GET_ITEM_BY_DIVISION_POPUP
//   - GET  SP(2, 미배포): P_SSP0026_GET_SHIPMENT_REQUEST_PACK / _CELL(메인 그리드 조회, 핵심 경로)
//   - SAVE SP(4, 미배포): P_SSP0026_SAVE_SHIP_REQ_PACK / _CELL / _DETAIL_PACK / _DETAIL_CELL
//   - SP 미배포(goal.md ②, 2026-09-26 ora.py 실측): 메인 그리드 조회·저장 핵심 플로우 런타임 미완
//     (convert-sp 후속). Request/Result Detail 조회·엑셀다운로드·BOD자동세팅·pivot헤더는 배포돼 실행 가능.
export enum SHEETS {
  PACK = 'pack', // spdMain 시트0 "Pack Biz" — 19컬럼 + 동적 pivot(D_/W_/M_)
  CELL = 'cell', // spdMain 시트1 "Cell Biz" — 17컬럼 + 동적 pivot, dtPgmAuthId 권한자만 노출
  REQUEST_DETAIL = 'requestDetail', // spdDetail 시트0 "Shipment Request Detail" — 편집 대상
  RESULT_DETAIL = 'resultDetail', // spdDetail 시트1 "Shipment Result Detail" — 읽기전용
  REQUEST_DETAIL_EXCEL = 'requestDetailExcel', // spdSub — 엑셀 폼다운로드 전용
  SPREAD_TITLE = 'spreadTitle', // P_SSP0026_GET_SPREAD_TITLE — 동적 pivot 헤더
  BOD_ITEM = 'bodItem', // P_SSP0026_GET_BOD_ITEM — Incoterms/TrMode 변경 시 BOD_ID 백그라운드 재조회
  ITEM_BY_DIVISION_POPUP = 'itemByDivisionPopup', // Model/Model2 팝업(SSP0026_ItembyDivisionPopup) 내부 조회
}

export const RESPONSE_SET = {
  PACK: 'o_rc1',
  CELL: 'o_rc1',
  REQUEST_DETAIL: 'o_rc1',
  RESULT_DETAIL: 'o_rc1',
  REQUEST_DETAIL_EXCEL: 'o_rc1',
  SPREAD_TITLE: 'o_rc1',
  BOD_ITEM: 'o_rc1',
  ITEM_BY_DIVISION_POPUP: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS SpdSheet 원본명 그대로(design 03 §0.2).
//   실측(ora.py, 2026-09-26): 5개 SHEET_NAME 전건 배포 확인(Pack Biz 19 / Cell Biz 17 /
//   Shipment Request Detail 37 / Shipment Result Detail 13 / Shipment Request Detail Excel 10).
export const ADMIN_SHEET_NAME: Record<SHEETS.PACK | SHEETS.CELL | SHEETS.REQUEST_DETAIL | SHEETS.RESULT_DETAIL | SHEETS.REQUEST_DETAIL_EXCEL, string> = {
  [SHEETS.PACK]: 'Pack Biz',
  [SHEETS.CELL]: 'Cell Biz',
  [SHEETS.REQUEST_DETAIL]: 'Shipment Request Detail',
  [SHEETS.RESULT_DETAIL]: 'Shipment Result Detail',
  [SHEETS.REQUEST_DETAIL_EXCEL]: 'Shipment Request Detail Excel',
};

// Measure 정의(SCM_MST_SHEET_MEASURE, PROGRAM_ID=SSP0026) — design 03 §0.3 실측.
//   Pack Biz 8종 / Cell Biz 10종(CUST_MOVE 는 VALID_YN=N 비활성 제외) — 화면은 admin fetch 로 받되,
//   색상 규칙(01_layout.md R18)이 참조하는 리터럴 목록을 문서화 목적으로 함께 남긴다.
export const MEASURE = {
  SCP_SHIP_PLAN: 'SCP_SHIP_PLAN',
  SHIP_REQ: 'SHIP_REQ',
  SHIP_PLAN: 'SHIP_PLAN',
  PACK_FP: 'PACK_FP',
  POSTP_PLAN: 'POSTP_PLAN',
  SITE_MOVE: 'SITE_MOVE',
  WH_IN: 'WH_IN',
  TOTAL_PLAN: 'TOTAL_PLAN',
  TOTAL_REQ: 'TOTAL_REQ',
  WH_BOH_PLAN: 'WH_BOH_PLAN',
  WH_BOH_REQ: 'WH_BOH_REQ',
} as const;

// Measure 배경색 4계열(01_layout.md R18, cs:718-743/4225-4271 — 엑셀 export 동일 규칙 공유).
export const MEASURE_COLOR = {
  BLUE: [
    MEASURE.PACK_FP,
    MEASURE.POSTP_PLAN,
    MEASURE.SITE_MOVE,
    MEASURE.WH_IN,
    MEASURE.TOTAL_PLAN,
    MEASURE.TOTAL_REQ,
    MEASURE.WH_BOH_PLAN,
    MEASURE.WH_BOH_REQ,
  ],
  ORANGE: [MEASURE.SCP_SHIP_PLAN],
  GREEN: [MEASURE.SHIP_REQ],
} as const;

// 조회조건 콤보 SQL_ID — 02_search-combo.md §7 "DB 재실측 필요" 후보(소스 추적 기반, ora.py 접속 재확인 전까지
//   확실성 미확정으로 취급). Division→Team→Customer→SalesSite 4단 + Division→PlantSite 독립 2단, 전부 재조회형
//   (서버 SQL 파라미터 변경 시 useTabComboQueries 쿼리키가 바뀌어 자동 재조회 — 클라 필터 없음).
export const COMBO = {
  DIVISION: 'MyDivision', // 확인 필요(§7-1) — 표시만, 값 자체는 "40" 고정
  TEAM: 'TeambyDivision', // param: divisionId
  END_CUSTOMER: 'SoldToCustomerByDivisionDept', // param: divisionId, teamId(형식상 deptId)
  SALES_SITE: 'SiteByEndCustomer', // param: divisionId, endCustomerId
  PLANT_SITE: 'FromSiteByDivisionOspPack', // param: divisionId (Team/Customer/SalesSite 무관 독립 체인)
  BUCKET_TYPE: 'BucketType', // 실측 확정(ora.py, SCM_ADM_CMBO_SQL_M, USE_YN='Y') — LOOKUP_TYPE='BUCKET_TYPE_CODE' 조회
  PLAN_PERIOD: 'Plan_InforPacker_SCP', // 초기 Period From/To 단발성 조회(콤보 아님)
} as const;

export const BUCKET_TYPE = {
  DAILY: 'Daily',
  WEEKLY: 'Weekly',
  MONTHLY: 'Monthly',
} as const;

// 팝업 트리거 버튼 → 대상 텍스트 필드(02_search-combo.md §4.6). Model/Model2 는 동일 팝업 클래스를
//   인스턴스만 다르게 열되, 팝업 내부(그리드/조회조건) 구현은 이번 회차 미완 — 04_react-gap.md 참조.
export const SEARCH_POPUP = {
  PROJECT: 'PROJECT', // btnProject → SCM0002_ProjectbyDivisionPopupEx(공용, 재사용 후보)
  MODEL: 'MODEL', // btnItemId → SSP0026_ItembyDivisionPopup(신규, param: division+plantSite)
  MODEL_2: 'MODEL_2', // btnItemID2 → 동일 팝업, param: division+salesSite
  REQUESTOR: 'REQUESTOR', // btnRequestor → UserInfoPopup(공용)
} as const;

// EditFlag 기준 Request Detail 편집가능 컬럼(01_layout.md R8) — 화이트리스트, 나머지는 항상 잠금.
export const REQUEST_DETAIL_EDIT_COLUMNS: readonly string[] = ['QTY', 'REMARK'];

// Insert 직후 편집가능(unlock) 컬럼 화이트리스트(01_layout.md R9/R10).
export const INSERT_EDITABLE_COLUMNS_MAIN: readonly string[] = [
  'MODEL_ID',
  'FROM_SITE',
  'TO_SITE',
  'FCST_TYPE',
  'TR_MODE',
  'INCOTERMS',
];

// 그리드 셀 콤보 5종(03_grid-columns.md §0.4) — TransportMode/Incoterms/FCST_TYPE/Measure 는 admin
//   SCM_ADM_CMBO_SQL_M 정적 배선, FromSite/ToSite 는 이벤트 기반 코드 재바인딩(admin PARAM 아님).
export const CELL_COMBO = {
  TRANSPORT_MODE: 'TransportMode',
  INCOTERMS: 'Incoterms',
  FCST_TYPE: 'FCST_TYPE',
  MEASURE: 'Measure',
  PLANT_SITE_BY_DIVISION_OSP: 'PlantSiteByDivisionOSP', // FROM_SITE(Shipment Request Detail) 바인딩
} as const;

// 동적 pivot 컬럼 태그 패턴 — D_/W_/M_ × yyyyMMdd(03_grid-columns.md §2, GET_SPREAD_TITLE 응답 기준
//   매 조회마다 재생성. 정적 나열 금지).
export const DYNAMIC_COLUMN_TAG_PATTERN = /^([DWM])_(\d{8})$/;

// 화면 라벨 코드(SCM_ADM_MSG_M, MSG_TP_CD='LBL') — DB 실측 매핑.
//   SEARCH_MAIN: 상단 SearchArea 조회 버튼 = LBL00112. SEARCH_GRID: 상세 그리드 보조 조회 버튼 = LBL00664.
export const LBL = {
  DIVISION: 'LBL00001',
  BUCKET: 'LBL00710',
  PERIOD: 'LBL00013',
  TEAM: 'LBL00044',
  END_CUSTOMER: 'LBL00080',
  SALES_SITE: 'LBL00011',
  PLANT_SITE: 'LBL00005',
  PROJECT: 'LBL00617',
  MODEL: 'LBL00669',
  SHIPMENT_DATE: 'LBL01115',
  LOT_ID: 'LBL01090',
  NICK_NAME: 'LBL00767',
  REQUESTOR: 'LBL01108',
  SEARCH_MAIN: 'LBL00112',
  SEARCH_GRID: 'LBL00664',
} as const;
