export const MENU_ID = 'SSP0003' as const;
export type MENU_ID = typeof MENU_ID;

// UI 라벨 코드(SCM_ADM_MSG_M MSG_TP_CD='LBL' 역조회 — DB 확정). 값=LBL 코드, fallback 은 call site 에서 '_텍스트'.
//   정책: Division=LBL00001(_Div), Search=LBL00112(_Search) 고정.
export const LBL = {
  SEARCH: 'LBL00112', // Search(F5)
  DIVISION: 'LBL00001', // Div.
  FROM_SITE: 'LBL00022', // From Site
  STATUS: 'LBL00014', // Status
  CHANGE_TYPE: 'LBL01061', // Change Type
  // 기간(drpPeriod) 라벨 — AS-IS `layoutControlItem1.Text = "Request Date"`(Designer:690).
  //   공용 PeriodField 기본값은 LBL00505('Period')라 그대로 두면 AS-IS 와 문구가 다르다.
  //   LBL00677: SCM_ADM_MSG_M(EN/KO 'Request Date', USE_YN='Y') + public/locales 실측 — 등록 불요.
  REQUEST_DATE: 'LBL00677', // Request Date
  // 조회조건 Model 필드 라벨 = "Model/Nickname"(사용자 지시 2026-10-07. 자매 SSP0015 400ceb57 선례).
  //   LBL00618: SCM_ADM_MSG_M(KO/EN/CN 전건 'Model/Nickname', USE_YN='Y') + 번들 양쪽 실측 — 등록 불요.
  //   종전 LBL00669('Model')에서 교체. 라벨칸 폭 override 없음(검색영역은 라벨칸 140px 보장).
  MODEL_NICKNAME: 'LBL00618', // Model/Nickname
  // 디테일 섹션 헤더 — AS-IS `usrLabel2.Text = "Request Confirm Detail"`(Designer:993, Location 12,12).
  //   LBL01106: SCM_ADM_MSG_M(KO/EN/CN, USE_YN='Y') + 번들 실측 — 등록 불요.
  REQUEST_CONFIRM_DETAIL: 'LBL01106',
  REQUESTOR: 'LBL01108', // Requestor
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

// AS-IS GSCM.SSP.Plan.UIL SSP0003_ShipmentChangeRequestConfirm (출하 변경요청 승인):
//   설계 근거: .atlas/gscm-design/SSP0003/design/00_checklist.md ~ 03_grid-columns.md, 상세 매핑 __asis-mapping__.md
//   - 조회 전용 승인 화면: 마스터-디테일 2그리드 + 디테일 폼(8필드 읽기전용 + rejectReason 입력).
//   - 표준 툴바 Insert/Delete/Save = NO-OP(본문 공백/주석), Edit = "읽기전용"(MSG00109) 안내만. Find 만 실동작.
//   - 실제 액션은 커스텀 버튼 3종 Approval/Reject/SelfReject — 초기 숨김, 마스터 더블클릭 시 userId 비교로 토글.
//   - GET  SP : PKG_SSP0003.P_SSP0003_GET_CHG_REQ_CONFIRM(메인) / _GET_REQ_DRAFTING(디테일, o_rc1=그리드/o_rc2=폼) /
//               _GET_DELEGATEE_LOAD(위임자)
//   - SAVE SP : PKG_SSP0003.P_SSP0003_SAVE_REQ_CONFIRM / _SAVE_REQ_CONFIRM_40 (대상행 DIVISION_ID 앞2 '40' 런타임 분기, SP 내부)
//   - 자매 SSP0202 가 동일 화면성격의 청사진(read-only 승인, 2그리드, 액션 3종). 단 SSP0003 은 별개 화면:
//       Division = 권한범위 EE제외 다중(SSP0202 는 '40' 고정) · siSub 54컬럼(SSP0202 는 50) · PKG_SSP0003(별개).
//   - PKG_SSP0003 은 배포·VALID(convert-plan ② 실측) — 조회/저장 런타임 검증 가능(SP 미배포 아님).
export enum SHEETS {
  MAIN = 'main', // spdMain siMain "Shipment Change Request Confirm" (22컬럼, 조회전용)
  SUB = 'sub', // siSub "Shipment Change Request Confirm Detail" (54컬럼, 2단헤더, 조회전용)
  DELEGATE = 'delegate', // Delegate_Load(위임자) — 마스터 더블클릭 시 division+approval 로 조회
}

// NSCM 단일 cursor 표준 'o_rc1'. 디테일 GET SP 는 2 결과셋: o_rc1=디테일 그리드, o_rc2=디테일 폼(8필드, design 03 §4.3).
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  SUB_GRID: 'o_rc1',
  SUB_FORM: 'o_rc2',
  DELEGATE: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS SpdSheet 명 그대로 (design 03 §0).
//   실측(ora.py): PROGRAM_ID='SSP0003' -> "Shipment Change Request Confirm" 22행 /
//     "Shipment Change Request Confirm Detail" 54행 (총 76행 배포됨 — INPUT_TP_CD 전열 'S').
export const ADMIN_SHEET_NAME: Record<SHEETS.MAIN | SHEETS.SUB, string> = {
  [SHEETS.MAIN]: 'Shipment Change Request Confirm',
  [SHEETS.SUB]: 'Shipment Change Request Confirm Detail',
};

// ====================================================================================
// 조회조건 콤보/lookup ID (design 02 §2/§5 — TO-BE Oracle 실측, ora.py)
// ====================================================================================
//   - Division: MyDivisionInEE_SCP(CMBO_SQL, 등록·배포됨). 권한범위 EE 포함 반환 -> FE 에서 CODE!=='EE' 제거
//       (AS-IS: GetSSPInnerTable("MyDivision")=MyDivisionInEE + 클라 EE제거, design 02 §2.1 권장안).
//   - From Site: PlantSiteByDivision_SCP(CMBO_SQL, @divisionId). Division 변경 시 재조회 cascade(design 02 §2.2/§3).
//       EE 분기(ShipmentPlanPlantSite_SCP)는 clbDivision EE제거로 도달불가 -> 미이식(design 02 §2.2, __asis-mapping__).
//   - Status/Change Type: lookup(LOOKUP_TYPE), 콤보 아님.
//   - ERP 차단 게이트: SSPBlockCheckIF_SCP(CMBO_SQL, @segment1='SSP0003', 반환 BLOCK_YN/PERIOD).
export const COMBO = {
  DIVISION: 'MyDivisionInEE_SCP',
  FROM_SITE: 'PlantSiteByDivision_SCP',
} as const;

export const LOOKUP = {
  CHANGE_REQ_STATUS: 'CHANGE_REQ_STATUS', // Status: D/Q/A/P/R/S/O/E (+ALL 선두, 기본 D=Drafting, AS-IS 패리티)
  CHANGE_REQ_TYPE: 'CHANGE_REQ_TYPE', // Change Type: P/C/N/A (+ALL 선두, 기본 ALL). 'P'=컬럼분기 트리거
} as const;

// ERP 차단 판정 콤보(액션 가드 — 승인/반려/자기반려 클릭 시, design 02 §2.6 / 01 §2-F).
export const ERP_BLOCK_COMBO = 'SSPBlockCheckIF_SCP';

// AS-IS 가 클라이언트에서 제거하는 사업부(design 02 §2.1: dtMyDivision.Where(CODE!='EE')).
export const EXCLUDE_DIVISION = 'EE';

// 조회조건 sentinel/기본값 (design 02 §4)
export const ALL = 'ALL';
// AS-IS 기본값 = Drafting('D'). AS-IS 는 cboStatus.SelectedIndex=2 로 '위치' 기준 기본선택하는데(SSP0003.cs:326),
//   AS-IS 콤보 데이터 순서가 ALL 선두 + CODE 정렬이라 [ALL(0), A-Approved(1), D-Drafting(2), ...] 가 되어 index2=Drafting 이
//   된다(사용자 실행화면 확인 2026-10-01). TO-BE lookup(LookupCommon)은 DISPLAY_SEQ 정렬(D=1,Q=2,...)이고 값으로 선택하므로
//   AS-IS 와 동일 표시가 되려면 코드값 'D'(Drafting)를 기본으로 둔다(index 재현이 아니라 의미값 매핑).
export const DEFAULT_STATUS = 'D'; // AS-IS index2 = Drafting (코드값 'D')
export const DEFAULT_CHANGE_TYPE = ALL; // cboChangeType idx0 = ALL
export const PERIOD_OFFSET_DAY = 14; // Period 기본 D-14 (from=오늘-14, to=오늘. SCM0001_GET_SCP_DAY_PERIOD offset -14)

// ====================================================================================
// 그리드 동적 컬럼세트 분기 (design 03 §2 — _sChangeType 구동)
// ====================================================================================
export const CHANGE_TYPE_PLAN = 'P'; // 'P'(Plan) -> siSub ERP_SO_NO hide + 그룹라벨 "Plan"/"Confirm"
export const STATUS_REQUESTED = 'Q'; // 승인/반려/자기반려 버튼 가시성 판정 status

// siSub 동적 컬럼/그룹라벨 (design 03 §2)
export const SUB_PLAN_HIDE_COLUMN = 'ERP_SO_NO'; // _sChangeType='P' 시 숨김
// P 분기 그룹라벨은 메타에 없어 FE 오버라이드(비NEW군 / NEW군).
export const SUB_GROUP_LABEL = {
  PLAN: { confirmed: 'Plan', change: 'Confirm' }, // _sChangeType='P'
  DEFAULT: { confirmed: 'Confirmed', change: 'Change' }, // else (메타 SCLS 일치)
} as const;

// 마스터 hidden id 컬럼(버튼 Visibility 판정 원천 — design 03 §1.1 #20~22).
//   전부 마스터 GET(PKG_SSP0003.P_SSP0003_GET_CHG_REQ_CONFIRM, BODY:173-367) 커서 컬럼명이다.
export const MASTER_USER_COLUMNS = {
  REQUEST_USER: 'REQUEST_USER',
  APPROVAL_USER: 'APPROVAL_USER',
  // 주의: 이 둘은 마스터 GET 이 **서버에서 위임 테이블까지 해소해** 내려주는 값이다 —
  //   BODY:251-268 `COALESCE(A.DELEGATEE_*, CASE WHEN CHANGE_REQ_STATUS IN ('Q','D')
  //   THEN E.DELEGATEE_ID / F.DEPT_ID END)`. 즉 위임자 SP 를 따로 부르지 않아도 여기 이미 들어 있다.
  DELEGATEE_USER: 'DELEGATEE_USER',
  DELEGATEE_DEPT: 'DELEGATEE_DEPT',
  STATUS: 'SHIPMENT_STATUS',
  CHANGE_TYPE: 'CHANGE_TYPE',
  CHANGE_REQ_NO: 'CHANGE_REQ_NO',
  DIVISION_ID: 'DIVISION_ID',
} as const;

// 위임자 SP(PKG_SSP0003.P_SSP0003_GET_DELEGATEE_LOAD, BODY:640-692) o_rc1 커서 컬럼명.
//   필수: SP 는 `SELECT A.DELEGATEE_ID, B.DEPT_ID`(BODY:664-665)라 응답 키가
//   DELEGATEE_ID / DEPT_ID 다 — MASTER_USER_COLUMNS 의 DELEGATEE_USER / DELEGATEE_DEPT 와 다르다.
//   두 축을 섞어 읽으면 값이 조용히 undefined 가 된다(2026-09-30 실제 사고 — delegateeDept 가
//   항상 빈 값으로 SAVE payload 에 실렸다). memory proc-m-cursor-colnm-is-fe-response-key 계열.
export const DELEGATE_COLUMNS = {
  DELEGATEE_USER: 'DELEGATEE_ID',
  DELEGATEE_DEPT: 'DEPT_ID',
} as const;

// 액션 코드(SaveData confirm_yn — 승인 A / 반려 R / 자기반려 S).
export const ACTION = { APPROVAL: 'A', REJECT: 'R', SELF_REJECT: 'S' } as const;
export type ACTION = (typeof ACTION)[keyof typeof ACTION];

// SAVE change_status — 액션 3종 + 내부 D/O Reject('O')·부분승인('P')·ERP실패('E').
//   'O'/'P'/'E' 는 버튼이 아니라 저장 흐름에서 산출(AS-IS BtnApproval_Click L1945/1152/1987).
export const SAVE_STATUS = { APPROVED: 'A', REJECT: 'R', SELF_REJECT: 'S', DO_REJECT: 'O', PARTIAL: 'P', ERP_FAIL: 'E' } as const;
export type SAVE_STATUS = (typeof SAVE_STATUS)[keyof typeof SAVE_STATUS];

// ====================================================================================
// siSub CHK 상태머신 (design 03 §3.4 / AS-IS FindData_Sub L722-761) — 마스터 SHIPMENT_STATUS 별
//   초기 체크값·활성. status else(Q 등)일 때만 사용자 토글 가능, 그 외는 표시되나 잠금.
// ====================================================================================
export const CHK_LOCK_UNCHECK_STATUS = ['E', 'O', 'R', 'S'] as const; // 전행 해제 + 잠금(확정/반려 완료)
export const CHK_LOCK_CHECK_STATUS = ['D', 'A'] as const; // 전행 체크 + 잠금(초안/승인)
export const CHK_PARTIAL_STATUS = 'P'; // 행별 STATUS_DETAIL 판정 + 잠금(부분승인)
export const CHK_PARTIAL_UNCHECK_DETAIL = ['R', 'E', 'S'] as const; // P 분기: 이 STATUS_DETAIL 은 해제, else 체크

// siSub 저장 payload 원천 컬럼 (design 03 §1.2 — ora.py SCM_MST_SHEET_COLUMNS 실측 COLUMN_NAME).
//   hidden(VIS=N) NEW_* 계열이 SAVE SP CLOB 파라미터 원천(P_SSP0003_SAVE_REQ_CONFIRM 36파라미터, ALL_ARGUMENTS 실측).
export const SUB_COL = {
  CHK: 'CHK',
  CONFIRM_ID: 'CONFIRM_ID',
  DIVISION_ID: 'DIVISION_ID',
  ITEM_ID: 'ITEM_ID',
  FROM_SITE: 'FROM_SITE',
  NEW_BASE_CONFIRM_YN: 'NEW_BASE_CONFIRM_YN',
  NEW_YN: 'NEW_YN',
  STATUS_DETAIL: 'STATUS_DETAIL',
  NEW_ETD: 'NEW_ETD',
  NEW_ETA: 'NEW_ETA',
  NEW_SHIPMENT_CONFIRM_QTY: 'NEW_SHIPMENT_CONFIRM_QTY',
  NEW_SHIPMENT_DATE: 'NEW_SHIPMENT_DATE',
  NEW_BOD_ID: 'NEW_BOD_ID',
  NEW_ROUTE: 'NEW_ROUTE',
  NEW_INCOTERMS: 'NEW_INCOTERMS',
  NEW_D_COUNTRY: 'NEW_D_COUNTRY',
  NEW_D_PORT_CODE: 'NEW_D_PORT_CODE',
  NEW_A_COUNTRY: 'NEW_A_COUNTRY',
  NEW_A_PORT_CODE: 'NEW_A_PORT_CODE',
  NEW_TO_COUNTRY: 'NEW_TO_COUNTRY',
  NEW_TO_CITY: 'NEW_TO_CITY',
  NEW_LT_DAY: 'NEW_LT_DAY',
  NEW_TRANSPORT_MODE: 'NEW_TRANSPORT_MODE',
  REMARKS: 'REMARKS',
  REMARKS2: 'REMARKS2',
  REMARKS3: 'REMARKS3',
  ERP_ATTR1: 'ERP_ATTR1',
  ERP_ATTR2: 'ERP_ATTR2',
  ERP_ATTR3: 'ERP_ATTR3',
} as const;

// SAVE/CHECK 시트·버튼 코드 (05_register.sql SCM_ADM_MNU_BTN_MPG_M 등록분과 정합).
//   call-proc 경로: apiClient.post(`/${MENU_ID}/${sheet}/${btnCode}/call-proc`, payload).
export const SAVE_BTN = {
  SAVE: 'SAVE', // P_SSP0003_SAVE_REQ_CONFIRM
  SAVE_40: 'SAVE_40', // P_SSP0003_SAVE_REQ_CONFIRM_40 (division 앞2 '40')
  SAVE_DE: 'SAVE_DE', // P_SSP0003_SAVE_REQ_DE_CONFIRM (Drafting 승인상세)
  PLAN_CHECK: 'PLAN_CHECK', // P_SSP0003_GET_PLAN_PROC_CHECK (엔진 수행중 체크)
  SCS_CHECK: 'SCS_CHECK', // PKG_SSP0200.P_SSP0200_GET_SHIPMENT_STATUS (D/O 체크)
  // ERP 인터페이스 적재 — P_SSP0003_SAVE_REQ_IF_CHECK(순수 DB). 승인 시 XIF_ERP_SHIP_PLAN_CONFIRM_S 스테이징
  //   (change_status='A' -> PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH). AS-IS 가 컨펌 시 인터페이스 테이블까지
  //   쌓던 단계(사용자 확인 2026-10-01). A→E fallback(외부 ERP 웹서비스)은 BE/ERP 소관 미이식(design 04 SSP0003-16).
  IF_CHECK: 'IF_CHECK', // P_SSP0003_SAVE_REQ_IF_CHECK
} as const;

// ====================================================================================
// TO-BE MSG 코드 (SCM_ADM_MSG_M 문구 역조회 — Hook #114. AS-IS 번호 그대로 쓰지 않는다).
//   자매 SSP0202 가 동일 AS-IS 메시지를 ora.py 로 역조회해 확정한 TO-BE 코드를 승계(같은 화면군 동일 메시지).
//   AS-IS 원 번호는 주석 병기. SSP0003 고유(ChkDraftingData 계열 MSG00420/421/422, D/O MSG00413)는
//   등가 TO-BE 코드 미확정 -> 영문 defaultValue fallback 유지(Hook #114 규약: 등가 없으면 fallback).
// ====================================================================================
export const MSG = {
  READ_ONLY: 'MSG00109', // "Read-only mode." (AS-IS MSG00109) — EditButton NO-OP 안내
  APPROVE_CONFIRM: 'MSG01203', // "Are you sure you want to approve your request?" (AS-IS MSG00190)
  REJECT_CONFIRM: 'MSG01204', // "Are you sure you want to Reject?" (AS-IS MSG00191)
  SELF_REJECT_CONFIRM: 'MSG01205', // "Are you sure you want to your request Self Reject?" (AS-IS MSG00192)
  REJECT_REASON_REQUIRED: 'MSG00181', // "Please enter the reason for rejection." (AS-IS MSG00181)
  ERP_BLOCK: 'MSG01395', // "Due to ERP I/F, changes can be made after ..." (AS-IS MSG00267)
  ENGINE_PROCESSING: 'MSG01294', // "SSP Daily Plan Processing now. Please, Try again ..." (AS-IS MSG00291)
  SAVE_SUCCESS: 'MSG00002', // "Saved successfully."
  SAVE_FAIL: 'MSG00003', // "Failed to save." (AS-IS MSG00284 보안조치 실패 — 오매핑 회피)
  // 아래 4종은 TO-BE SCM_ADM_MSG_M 에 등가 코드 미존재(ora.py 실측: MSG00420/421/422/413 EN 0행) →
  //   Hook #114 규약대로 AS-IS 코드 키 + 영문 defaultValue fallback(등가 채번 시 교체). 오매핑 아님(코드 부재).
  APPROVE_TARGET_REQUIRED: 'MSG00420', // AS-IS: "승인 대상을 체크해주세요."
  REJECT_ALL_REQUIRED: 'MSG00421', // AS-IS: "전체 체크 후 Reject ... 부분 승인 필요 시 승인 대상 체크 후 Approval"
  SELF_REJECT_ALL_REQUIRED: 'MSG00422', // AS-IS: "전체 체크 후 Self Reject 버튼 눌러주세요."
  DO_BLOCK: 'MSG00413', // AS-IS: "ERP D/O(Delivery Order) 생성되어 SSP 계획 변경 불가"
  // ERP 인터페이스 적재 실패 경고 — 확정 자체는 저장됨. TO-BE 등가 코드 미채번 → 영문 fallback(Hook #114).
  ERP_IF_FAIL: '_ssp0003.erpIfFail',
} as const;
