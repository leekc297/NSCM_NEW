export const MENU_ID = 'SSP0202' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SSP.Plan.UIL SSP0202_ShipmentChangeRequestConfirm (출하요청 변경 승인):
//   설계 근거: .atlas/gscm-design/SSP0202/design/00_checklist.md ~ 03_grid-columns.md, 상세 매핑 __asis-mapping__.md
//   - 조회 전용 승인 화면: 마스터-디테일 2그리드 + 디테일 폼(8필드 읽기전용 + rejectReason 입력).
//   - 표준 툴바 Insert/Delete/Save = NO-OP(본문 공백), Edit = "읽기전용"(MSG00109) 안내만. Find 만 실동작.
//   - 실제 액션은 커스텀 버튼 3종 Approval/Reject/SelfReject — 초기 숨김, 마스터 더블클릭 시 userId 비교로 토글.
//   - GET  SP : PKG_SSP0202.P_SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM(메인) / _GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING(디테일, Tables[0]=그리드/Tables[1]=폼)
//   - SAVE SP : _SAVE_SHIPMENT_REQUEST_CONFIRM_40 / _SAVE_SHIPMENT_REQUEST_CONFIRM (division 앞2 '40' 런타임 분기)
//   - PKG_SSP0202 배포 상태(2026-10-07 ora.py 실측): PACKAGE/PACKAGE BODY 모두 VALID. 종전 "미배포" 주석은 stale.
//       배포된 SP 8종 = _GET_SHIPMENT_CHANGE_REQUEST_CONFIRM / _GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING /
//       _GET_DELEGATEE_LOAD / _GET_SCS_CONFIRM_ID_CHECK / _GET_SSP_PLAN_PROCESSING_CHECK /
//       _SAVE_SHIPMENT_REQUEST_CONFIRM / _SAVE_SHIPMENT_REQUEST_CONFIRM_40 / _SAVE_..._CONFIRM_IF_CHECK.
//       버튼메타(SCM_ADM_MNU_BTN_MPG_M)도 SEARCH/SAVE/SAVE_40/IF_CHECK/PLAN_CHECK/SCS_CHECK + delegate SEARCH 등록완료.
//   - 미배선(FE): IF_CHECK(승인 후 ERP 적재) · PLAN_CHECK(EngProcessingChk MSG01294) · SCS_CHECK(chkSaveYN MSG01356) ·
//       SAVE_40 분기. AS-IS cs:1379/1387/1411 에서 전부 호출된다(실측) — SP·메타가 준비됐으므로 다음 회차 배선 대상.
export enum SHEETS {
  MAIN = 'main', // spdMain siMain "Shipment Change Request Confirm" (22컬럼, 조회전용)
  SUB = 'sub', // siSub "Shipment Change Request Confirm Detail" (50컬럼, 2단헤더, 조회전용)
  DELEGATE = 'delegate', // Delegate_Load(위임자) — 마스터 더블클릭 시 division+approval 로 조회
}

// NSCM 단일 cursor 표준 'o_rc1'. 디테일 GET SP 는 2 결과셋: o_rc1=디테일 그리드, o_rc2=디테일 폼(8필드).
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  SUB_GRID: 'o_rc1',
  SUB_FORM: 'o_rc2',
  DELEGATE: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS SpdSheet 명 그대로 (design 03 §0).
//   실측: PROGRAM_ID='SSP0202' -> "Shipment Change Request Confirm" 22행 / "Shipment Change Request Confirm Detail" 50행 (총 72행 배포됨).
export const ADMIN_SHEET_NAME: Record<SHEETS.MAIN | SHEETS.SUB, string> = {
  [SHEETS.MAIN]: 'Shipment Change Request Confirm',
  [SHEETS.SUB]: 'Shipment Change Request Confirm Detail',
};

// ====================================================================================
// 조회조건 콤보/lookup ID (design 02 §2/§5 — TO-BE Oracle 실측, ora.py)
// ====================================================================================
//   - From Site: FromSiteByDivisionOspPack(CMBO_SQL, 등록·배포됨). 반환 CODE=SCM_SITE_ID.
//       PLANT+OSP+OPERATION_GROUP='P' + division auth + SSP_UI_EXCEPT_COMPANY 제외 — AS-IS 후보범위 등가(재사용 확정).
//   - Status/Change Type: lookup(LOOKUP_TYPE), 콤보 아님.
//   - ERP 차단 게이트: SSPBlockCheckIF_SCP(CMBO_SQL, @segment1='SSP0202', 반환 BLOCK_YN/PERIOD).
export const COMBO = {
  FROM_SITE: 'FromSiteByDivisionOspPack',
} as const;

export const LOOKUP = {
  CHANGE_REQ_STATUS: 'CHANGE_REQ_STATUS', // Status: D/Q/A/P/R/S/O/E (+ALL 선두, 기본 Q)
  CHANGE_REQ_TYPE: 'CHANGE_REQ_TYPE', // Change Type: P/C/N/A (+ALL 선두, 기본 ALL). 'P'=컬럼분기 트리거
} as const;

// ERP 차단 판정 콤보(액션 가드 — 승인/반려/자기반려 클릭 시, design 02 §2.6).
export const ERP_BLOCK_COMBO = 'SSPBlockCheckIF_SCP';

// 조회조건 sentinel/기본값 (design 02 §4)
export const ALL = 'ALL';
export const FIXED_DIVISION = '40'; // C1: Division "40" 고정 + disabled(단일 상수)
export const DEFAULT_STATUS = 'Q'; // cboStatus.SelectedIndex=2 = Requested(Q)
export const DEFAULT_CHANGE_TYPE = ALL; // cboChangeType idx0 = ALL
export const PERIOD_OFFSET_DAY = 14; // Period 기본 D-14 (from=오늘-14, to=오늘. SCM0001_GET_SCP_DAY_PERIOD offset -14)

// ====================================================================================
// 그리드 동적 컬럼세트 분기 (design 03 §2 — _sChangeType 구동)
// ====================================================================================
export const CHANGE_TYPE_PLAN = 'P'; // 'P'(Plan) -> siSub ERP_SO_NO hide + 그룹라벨 "Plan"/"Confirm"
export const STATUS_REQUESTED = 'Q'; // 승인/반려/자기반려 버튼 가시성 판정 status

// siSub 동적 컬럼/그룹라벨 (design 03 §2 R2~R5)
export const SUB_PLAN_HIDE_COLUMN = 'ERP_SO_NO'; // _sChangeType='P' 시 숨김
// P 분기 그룹라벨은 메타에 없어 FE 오버라이드(비NEW군 / NEW군).
export const SUB_GROUP_LABEL = {
  PLAN: { confirmed: 'Plan', change: 'Confirm' }, // _sChangeType='P'
  DEFAULT: { confirmed: 'Confirmed', change: 'Change' }, // else (메타 SCLS 일치)
} as const;
// else/P 분기에서 그룹헤더가 갈리는 앵커 컬럼(비NEW군 선두 / NEW군 선두).
export const SUB_GROUP_ANCHOR = { confirmed: 'LT_DAY', change: 'NEW_LT_DAY' } as const;

// 마스터 hidden id 컬럼(버튼 Visibility 판정 원천 — design 03 §1.1 SN20~22, cs:1193).
export const MASTER_USER_COLUMNS = {
  REQUEST_USER: 'REQUEST_USER',
  APPROVAL_USER: 'APPROVAL_USER',
  DELEGATEE_USER: 'DELEGATEE_USER',
  STATUS: 'SHIPMENT_STATUS',
  CHANGE_TYPE: 'CHANGE_TYPE',
  CHANGE_REQ_NO: 'CHANGE_REQ_NO',
} as const;

// 액션 코드(SaveData confirm_yn — 승인 A / 반려 R / 자기반려 S).
export const ACTION = { APPROVAL: 'A', REJECT: 'R', SELF_REJECT: 'S' } as const;
export type ACTION = (typeof ACTION)[keyof typeof ACTION];

// ====================================================================================
// UI 라벨 코드 (SCM_ADM_MSG_M MSG_TP_CD='LBL' 실측 — Hook #114. t(LBL.KEY, '_Fallback') 경유).
// ====================================================================================
export const LBL = {
  DIVISION: 'LBL00001', // Div
  SEARCH: 'LBL00112', // Search
  FROM_SITE: 'LBL00022', // From Site
  STATUS: 'LBL00014', // Status
  CHANGE_TYPE: 'LBL01061', // Change Type
  // 기간(drpPeriod) 라벨 — AS-IS `layoutControlItem1.Text = "Request Date"`(Designer:688).
  //   공용 PeriodField 기본값은 LBL00505('Period')라 그대로 두면 AS-IS 와 문구가 다르다.
  //   LBL00677: SCM_ADM_MSG_M(EN/KO 'Request Date', USE_YN='Y') + public/locales 실측 — 등록 불요.
  REQUEST_DATE: 'LBL00677', // Request Date
  // 디테일 섹션 헤더 — AS-IS `usrLabel2.Text = "Request Confirm Detail"`(Designer:991, Location 12,12).
  //   LBL01106: DB·번들 실측 등록분 — 자매 SSP0003 과 동일 코드.
  REQUEST_CONFIRM_DETAIL: 'LBL01106',
  REQUESTOR: 'LBL01108', // Requestor
  // 조회조건 Model 필드 라벨 = "Model/Nickname"(사용자 지시 2026-10-07. 4자매 화면 동일 적용).
  //   종전엔 LBL01142('Item')로 **자매 SSP0003 과 라벨 문구가 달랐다**(그쪽은 'Model') — 같은 필드
  //   (MaterialByDivisionModal 로 Model 을 고르는 조회조건)이므로 상수명도 MODEL_NICKNAME 으로 통일한다.
  //   LBL00618: SCM_ADM_MSG_M(KO/EN/CN 전건 'Model/Nickname', USE_YN='Y') + 번들 양쪽 실측 — 등록 불요.
  MODEL_NICKNAME: 'LBL00618', // Model/Nickname
  REQUEST_NO: 'LBL00744', // Request No
  TITLE: 'LBL01125', // Title
  DEPT_NAME: 'LBL01071', // Dept Name
  APPROVAL: 'LBL01052', // Approval
  CHANGE_REASON: 'LBL01060', // Change Reason
  REASON_DETAIL: 'LBL01104', // Reason Detail
  REJECT_REASON: 'LBL00628', // Reject Reason
  REJECT: 'LBL00624', // Reject
  SELF_REJECT: 'LBL01113', // Self Reject
} as const;

// ====================================================================================
// TO-BE MSG 코드 (SCM_ADM_MSG_M 문구 역조회 — Hook #114. AS-IS 번호 그대로 쓰지 않는다).
//   ora.py 실측 역조회 완료: AS-IS 번호 -> 문구 일치하는 TO-BE 코드. AS-IS 원 번호는 주석 병기.
// ====================================================================================
export const MSG = {
  READ_ONLY: 'MSG00109', // "Read-only mode." (AS-IS MSG00109, EN 실측 일치) — EditButton NO-OP 안내
  APPROVE_CONFIRM: 'MSG01203', // "Are you sure you want to approve your request?" (AS-IS MSG00190)
  REJECT_CONFIRM: 'MSG01204', // "Are you sure you want to Reject?" (AS-IS MSG00191)
  SELF_REJECT_CONFIRM: 'MSG01205', // "Are you sure you want to your request Self Reject?" (AS-IS MSG00192)
  REJECT_REASON_REQUIRED: 'MSG00181', // "Please enter the reason for rejection." (AS-IS MSG00181, EN 실측 일치)
  ERP_BLOCK: 'MSG01395', // "Due to ERP I/F, changes can be made after 2 minutes..." (AS-IS MSG00267)
  ENGINE_PROCESSING: 'MSG01294', // "SSP Daily Plan Processing now. Please, Try again after {0} minutes." (AS-IS MSG00291)
  CONFIRM_ID_EXISTS: 'MSG01356', // "The Shipment performance based on the Confirm ID occurred in SCS..." (AS-IS MSG00362)
  SAVE_SUCCESS: 'MSG00002', // "Saved successfully."
  SAVE_FAIL: 'MSG00003', // "Failed to save." (AS-IS MSG00284 보안조치 실패 — TO-BE MSG00284='grid not ready' 오매핑 회피)
  SYSTEM_ERROR: 'MSG01215', // "system error... Request No : {0}" (AS-IS MSG00204)
} as const;
