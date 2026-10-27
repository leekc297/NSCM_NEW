export const MENU_ID = 'SSP0012' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SSP.Plan.UIL SSP0012_ShipmentPlanConfirmDetail (출하계획 확정 상세, 파라미터명 Shipment Plan Detail):
//   설계 근거: .atlas/gscm-design/SSP0012/design/00_checklist.md ~ 03_grid-columns.md, 매핑 __asis-mapping__.md
//   - 화면 성격: 읽기전용 조회(Inquiry) + 고정 47컬럼 상세 그리드. 편집/저장 없음, 동적 PIVOT 없음(03 §2 반증).
//   - 그리드 1개: "Shipment Plan Confirm Detail"(47컬럼 = 표시 43 + hidden 4, 전량 읽기전용 cs:439).
//   - GET  SP : PKG_SSP0012.P_SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL(IN 9종). 미배포(convert-sp 후속).
//   - 툴바: Find(SEARCH)=실동작 / Insert/Delete/Save=NO-OP(cs:303/308/345).
//     AS-IS Edit(읽기전용 가드 MSG00109 cs:314)는 미이식 — TO-BE 표준은 편집모드 토글 버튼을 두지 않는다(convert-core §2.4).
//   - 주의: PKG_SSP0012 미배포 — 실 조회/Period 기본값(SCM0001_GET_SCP_DAY_PERIOD) 런타임은 SP 배포 후.
export enum SHEETS {
  MAIN = 'main', // spdMain "Shipment Plan Confirm Detail" (47컬럼, 읽기전용)
}

// NSCM 단일 cursor 표준 'o_rc1'.
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS SpdSheet 명 그대로 (design 03 §0).
//   실측(ora.py): PROGRAM_ID='SSP0012' SHEET_NAME='Shipment Plan Confirm Detail' 47행 배포됨.
export const ADMIN_SHEET_NAME: Record<SHEETS, string> = {
  [SHEETS.MAIN]: 'Shipment Plan Confirm Detail',
};

// ====================================================================================
// 조회조건 콤보 ID (design 02 §2/§5 — TO-BE Oracle 실측, ora.py 2026-09-24)
// ====================================================================================
//   - Division: MyDivisionInEE_SCP(권한필터 내장, EE 미제외) + FE 클라 필터 CODE!=='EE'(AS-IS cs:237).
//   - From Site: EE/비-EE 분기 재조회 — 선택 division 에 'EE' 부분문자열 포함 시 EE 콤보.
//       (실측: SCM_MST_DIVISION 에 EE_HD/EE_HG/EE_HM/EE_ST/EE_UC 존재 → EE 분기 실질 도달, goal §⑦-4 해소.)
export const COMBO = {
  DIVISION: 'MyDivisionInEE_SCP', // 권한필터 내장, EE 미제외(클라 필터로 EE 제외)
  FROM_SITE_NON_EE: 'PlantSiteByDivision_SCP', // 비-EE 분기(권한필터 + '-' 더미행)
  FROM_SITE_EE: 'ShipmentPlanPlantSite_SCP', // EE 분기(EE_SHIPMENT_PLAN lookup 합집합, 권한필터 없음)
  // Period 기본구간 — AS-IS GetDayRange(cs:588-608) 서버 산출. @fromDate(오늘) @offsetDay('55') @timeZone.
  //   결과 1행 CODE="YYYYMMDD:YYYYMMDD". 콤보 USE_YN='Y' 실배포(ora.py 2026-10-13). 자매 shipment-plan-mobility-it
  //   (ShipmentPsiForm) 동일 패턴. 서버 영업일/휴일/타임존 반영 — dayjs 주말근사 divergence 해소.
  DAY_PERIOD: 'SCM0001_GET_SCP_DAY_PERIOD',
} as const;

// 그리드 FCST_TYPE 셀 표시매핑 lookup(SALES_TYPE_CODE 15코드) — admin 메타 FPComboBox 로 자동 배선.
export const LOOKUP = {
  SALES_TYPE_CODE: 'SALES_TYPE_CODE',
} as const;

// 컬럼 개인화(ColumnLayoutModal) titleSet columnType — 조회·저장·복원 동일 값('C'=컬럼).
//   세 경로(모달 조회 / saveTitleSet / fetchUserColumnLayout)가 반드시 같은 값을 써야 저장·복원 키가 일치한다.
export const TITLESET_COLUMN_TYPE = 'C';

// 조회조건 sentinel/기본값 (design 02 §4)
export const ALL = 'ALL';
export const EE_DIVISION = 'EE'; // Division 클라 제외 대상(정확히 'EE' — 부분문자열 EE_* 는 유지)
export const PERIOD_BUSINESS_DAYS = 55; // Period 기본 = 오늘 ~ +55영업일(design 02 §2, SCM0001_GET_SCP_DAY_PERIOD)

// ====================================================================================
// 그리드 드릴다운(셀 클릭) 대상 컬럼 (design 03 W8/W9/W10, hook #18)
// ====================================================================================
export const DRILLDOWN = {
  INCOTERMS: 'INCOTERMS', // 셀 클릭 → BOD 상세(DIVISION_ID[EE면 ORIGIN_FROM_DIVISION_ID] + BOD_ID)
  CHANGE_REQ_NO: 'CHANGE_REQ_NO', // 셀 클릭 → 변경요청 상세(CHANGE_REQ_NO, 공백 아닐 때만 G3)
} as const;
// 드릴다운 파라미터 원천 컬럼(hidden backing, design 03 §1.3).
export const BOD_ID_COLUMN = 'BOD_ID';
export const DIVISION_ID_COLUMN = 'DIVISION_ID';
export const ORIGIN_FROM_DIVISION_ID_COLUMN = 'ORIGIN_FROM_DIVISION_ID';

// CHANGE_REQ_NO 드릴다운(W10) 변경요청 상세 팝업 — call-proc 버튼 코드.
//   proc PKG_SSP0003.P_SSP0003_GET_REQ_DRAFTING(= AS-IS SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING) 재사용.
//   API_M(P_SSP0003_GET_DRAFTING)·PROC_M 는 SSP0003 등록분 재사용, SSP0012/main 버튼+권한만 등록
//   (design/06_register_change_req_drafting_btn_auth.sql). 호출: /SSP0012/main/GET_REQ_DRAFTING/call-proc.
export const REQ_DRAFTING_BTN = 'GET_REQ_DRAFTING';

// INCOTERMS 드릴다운(W9) BOD 상세 팝업 — call-proc 버튼 코드.
//   proc PKG_SCM0002.P_SCM0002_SHIPMENT_PLAN_CONFIRM_BOD_POPUP (DB 실측 2026-10-15, GET 없음).
//   API_M=P_SSP0012_BOD_POPUP_GET, PROC_M IN 키 = divisionId / bod (bodId 아님 — 실측).
//   divisionId 는 EE면 ORIGIN_FROM_DIVISION_ID. 공유 팝업(AS-IS SSP0001+SSP0012), 현재 소비자 SSP0012
//   하나라 화면 로컬 구현(배치 A). 호출: /SSP0012/main/GET_BOD_DETAIL/call-proc. 버튼/권한만 등록 필요
//   (API_M/PROC_M 는 이관 때 선등록됨) — design/07_register_bod_popup_btn_auth.sql.
export const BOD_DETAIL_BTN = 'GET_BOD_DETAIL';

// ====================================================================================
// i18n LBL 코드 (SCM_ADM_MSG_M MSG_TP_CD='LBL' — 문구 역조회로 확정, value = LBL 코드)
//   Division=LBL00001 / Search=LBL00112 표준 고정. 라벨 텍스트가 아니라 코드를 t() 1인자로 전달.
// ====================================================================================
export const LBL = {
  DIV: 'LBL00001', // Div. — 프로젝트 표준(조회조건 Division 라벨 72개 화면 LBL00001). 설계 02 §4.5는 LBL00641('Division') 지정이나 소수(2화면) outlier라 표준 우선.
  FROM_SITE: 'LBL00022', // From Site
  PERIOD: 'LBL00013', // Period
  MODEL: 'LBL00618', // Model/Nickname
  SOLD_TO_PARTY: 'LBL01122', // Sold To Party
  SHIP_TO_PARTY: 'LBL01114', // Ship To Party
  SEARCH: 'LBL00112', // Search(F5)
  COLUMN_SETTING: 'LBL00605', // Column Setting
} as const;

// ====================================================================================
// TO-BE MSG 코드 (SCM_ADM_MSG_M 문구 역조회 — Hook #114. AS-IS 번호 답습 금지, TO-BE 문구 기준 코드 사용).
//   주의: AS-IS 화면은 MSG00097 로 "No authority assigned." 를 띄웠으나, TO-BE SCM_ADM_MSG_M 에서
//   MSG00097 문구는 "Please select Division." 다(ora.py 실측 2026-09-24). 따라서 AS-IS 번호를 그대로 쓰면
//   오문구가 노출된다 — TO-BE 에서 "No authority assigned." 를 담은 코드는 MSG00667 하나뿐이라 그것을 쓴다.
//   MSG00013="Please enter the required fields." 는 TO-BE 문구도 의도와 일치.
// ====================================================================================
export const MSG = {
  NO_AUTHORITY: 'MSG00667', // L1 권한 Division 0건 — 조회영역 잠금 안내(TO-BE "No authority assigned." 실측 코드)
  REQUIRED_PERIOD: 'MSG00013', // Period 필수(조회 가드 cs:390/394) — "Please enter the required fields."
} as const;
