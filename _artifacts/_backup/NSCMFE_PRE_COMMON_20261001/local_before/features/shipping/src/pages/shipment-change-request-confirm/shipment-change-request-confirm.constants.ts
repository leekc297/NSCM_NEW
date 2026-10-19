export const MENU_ID = 'SSP0202' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SSP.Plan.UIL SSP0202_ShipmentChangeRequestConfirm (출하요청 변경 승인):
//   설계 근거: .atlas/gscm-design/SSP0202/design/00_checklist.md ~ 03_grid-columns.md, 상세 매핑 __asis-mapping__.md
//   - 조회 전용 승인 화면: 마스터-디테일 2그리드 + 디테일 폼(8필드 읽기전용 + rejectReason 입력).
//   - 표준 툴바 Insert/Delete/Save = NO-OP(본문 공백), Edit = "읽기전용"(MSG00109) 안내만. Find 만 실동작.
//   - 실제 액션은 커스텀 버튼 3종 Approval/Reject/SelfReject — 초기 숨김, 마스터 더블클릭 시 userId 비교로 토글.
//   - GET  SP : PKG_SSP0202.P_SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM(메인) / _GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING(디테일, Tables[0]=그리드/Tables[1]=폼)
//   - SAVE SP : _SAVE_SHIPMENT_REQUEST_CONFIRM_40 / _SAVE_SHIPMENT_REQUEST_CONFIRM (division 앞2 '40' 런타임 분기)
//   - 주의: PKG_SSP0202 미배포(convert-sp 후속) — 실 조회/저장/서버체크 런타임 검증은 SP 배포 후.
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
