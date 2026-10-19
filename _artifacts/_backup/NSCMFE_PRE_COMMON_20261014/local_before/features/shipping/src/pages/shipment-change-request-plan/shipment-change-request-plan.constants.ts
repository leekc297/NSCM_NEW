import { CRUD_TYPE } from '@foundation/constants';

export const MENU_ID = 'SSP0200' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SSP.Forms.UIL/Plan/SSP0200_ShipmentChangeRequest.cs (6,906행) + Designer(1,780행).
//   설계 정본: .atlas/gscm-design/SSP0200/design/00_checklist.md ~ 03_grid-columns.md (v3 재작성본).
//   주의: design/_superseded-planuil-copy/** 와 roslyn/*PlanUIL* 은 틀린 사본 — 입력 금지.
//   자매 SSP0201(features/shipping/src/pages/shipment-change-request)은 Packer 판으로 별개 화면이다.
//     컬럼셋 상이(68/56 vs 65/58) · hotkeyConfig 상이(DELETE NO-OP) · MENU_ID 상이 → 복사 금지.
//   그리드 2개: spdMain "Shipment Change Request"(68컬럼) / spdSub "Change Request"(56컬럼, 2단 헤더)
//   GET  SP : PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST(IN 12 -> o_rc1 69열)
//             PKG_SSP0200.P_SSP0200_GET_SHIPMENT_REQUEST_DRAFTING(IN 19 -> o_rc1 50열 + o_rc2 요청자 6열)
//   SAVE SP : _SAVE_SHIPMENT_CONFIRM_NEW(31) / _SAVE_SHIPMENT_REQUEST_DRAFTING(39) /
//             _SAVE_SHIPMENT_REQUEST_COMPLETE(45)
//   편집모드 모드토글(EditButton/SwitchLock)은 미이식 — 편집 기본 ON(convert-core §2.4).
//     컬럼 단위 잠금은 SCM_MST_SHEET_COLUMNS.INPUT_TP_CD 가 원천(hook #130, FE 컬럼명 배열 금지).
export enum SHEETS {
  MAIN = 'main', // spdMain — SCM_ADM_MNU_BTN_MPG_M.SHT_NM 과 일치(05_register.sql)
  SUB = 'sub', // spdSub
}

// NSCM 단일 cursor 표준. detail 은 o_rc2(요청자 6열)를 추가로 소비한다(design 03 §4.3).
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  SUB: 'o_rc1',
  SUB_REQUESTOR: 'o_rc2',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// 컬럼메타 축 sheetName = SCM_MST_SHEET_COLUMNS.SHEET_NAME (AS-IS 표시명).
//   호출 축(SHEETS/SHT_NM, camelCase)과 다른 축이다 — 섞으면 컬럼 0건/조회 0건.
//   실측(ora.py 2026-09-27): PROGRAM_ID='SSP0200' -> 68행 / 56행.
export const ADMIN_SHEET_NAME: Record<SHEETS, string> = {
  [SHEETS.MAIN]: 'Shipment Change Request',
  [SHEETS.SUB]: 'Change Request',
};

// ====================================================================================
// 조회조건 콤보 / lookup (design 02 §5.3 — ora.py 실측 전건 USE_YN='Y')
// ====================================================================================
export const COMBO = {
  // Div — 정본은 미이관 SP(SSP0200_GET_SHIPMENT_DIVISION). 잠정 대체 + 화면 EE 필터(C2/C3).
  //   주의: DM 도메인 'MyDivision' 은 ATTRIBUTE3<>'EE' 라 EE_* 5건까지 제외 — 사용 금지.
  DIVISION: 'MyDivisionInEE_SCP',
  // From Site — 정본은 미이관 SP. 잠정 대체(VP ATTRIBUTE9 UNION 없음 — 04 확인필요).
  FROM_SITE: 'ShipmentPlanPlantSite_SCP',
  TO_SITE: 'ShipmentPlanToSite_SCP',
  // 요청정보 Change Reason + 그리드 셀 콤보 공용(CMBO_SQL, '-' 더미 선두행 포함).
  CHANGE_REASON: 'CHANGE_REASON_CODE_ALL',
  // 그리드 셀 콤보 — 조회조건 clbToSite(ShipmentPlanToSite_SCP)와 다른 SQL_ID 다(design 03 §1.3 #8).
  CELL_TO_SITE: 'ToSiteByDivisionEEForSSP_SCP',
  // 행 파라미터 셀 콤보 2종 — 컬럼 단위 dataMap 으로는 후보를 좁힐 수 없어 행 값으로 그때그때 조회한다.
  //   AS-IS 도 SetCellTypeCombo(행, 컬럼, dt) 로 행마다 갈아끼운다(cs:5468 TransMode / cs:6658 EndCustomer).
  //   TransMode      @divisionId/@fromSite/@toSite/@incoterms  (SCP_MST_BOD_V)
  //   EndCustomer    @divisionId/@scmSiteId/@itemId/@param5     (SCM_MST_SITE_ITEM)
  CELL_TRANS_MODE: 'TransMode',
  CELL_END_CUSTOMER: 'EndCustomerByItemForSSP_SCP',
  // 저장 전 ERP 중단기간 게이트. 파라미터로 화면코드를 넘긴다(L-079).
  ERP_BLOCK: 'SSPBlockCheckIF_SCP',
  // 요청부서(세션 축) — AS-IS `UserInfoContext.Current["Dept_ID"]`(cs:523) 등가.
  //   TO-BE UserSession 에 부서 필드가 없어(실측) 로그인 사용자 부서를 주는 기등록 콤보를 재사용한다.
  //   `SalesPlanUserDept` = SELECT DEPT_ID CODE, DEPT_ID NAME FROM SCM_ADM_USER_M WHERE USER_ID=@sesUserId
  //   (ora.py 본문 실측). @sesUserId 는 BE 가 주입하므로 화면은 파라미터를 싣지 않는다.
  //   주의: detail 조회 o_rc2 는 **모델 담당자(승인자 후보)** 라 요청부서 원천이 아니다(2026-09-28 교정).
  REQUESTOR_DEPT: 'SalesPlanUserDept',
  // 부서ID -> 부서명. 본문 WHERE 가 LIKE '%값%' OR 체인이라 과다 매칭될 수 있어 호출부가 CODE 완전일치로 좁힌다.
  DEPT_NAME: 'Dept',
} as const;

export const LOOKUP = {
  SHIPMENT_STATUS: 'SHIPMENT_STATUS', // 4코드 P/C/D/R — 조회조건은 P 제외 + ALL 선두
  CHANGE_REQ_TYPE: 'CHANGE_REQ_TYPE', // 4코드 P/C/N/A — ALL 없음, 기본 'C'
  SALES_TYPE_CODE: 'SALES_TYPE_CODE', // 그리드 FCST_TYPE 셀 콤보(14코드)
  // CHANGE_REASON_CODE_ALL(CMBO_SQL) 의 @lookupType 인자값. 미전달 시 BE 가 '' 로 치환해
  //   WHERE A.LOOKUP_TYPE='' 가 되어 후보가 더미 '-' 1행뿐이 된다(실측 8행 -> 1행).
  CHANGE_REASON_CODE: 'CHANGE_REASON_CODE',
  // 출하일 상·하한 기준일수. MASTER 헤더가 SEGMENT1='CODE'/SEGMENT2='NAME' 라 응답 키는 CODE/NAME 이고
  //   AS-IS `dtBaseDay.Rows[0][1]`(= NAME) 이 기준일수다(실측 CODE='D' / NAME='-56', cs:506).
  CHANGE_REQ_DAY: 'CHANGE_REQ_DAY',
} as const;

// ====================================================================================
// 조회조건 sentinel / 기본값 (design 02 §4.2)
// ====================================================================================
export const ALL = 'ALL';
export const CHANGE_TYPE_CONFIRM = 'C'; // ChangeType.ChangeType_C
export const DEFAULT_CHANGE_TYPE = CHANGE_TYPE_CONFIRM; // cboChangeType SelectedIndex=1 = C(Confirm)
export const CHANGE_TYPE_PLAN = 'P'; // AS-IS 도달 불가(Δ2) — 분기는 남기되 기본값 아님
export const CHANGE_TYPE_NEW = 'N'; // 신규 출하 요청 — newYn 강제 'Y' + 취소 시 ERP I/F 송신(cs:3452)
export const DEFAULT_STATUS = ALL;
export const EXCLUDED_DIVISION = 'EE'; // C2/C3 — CODE 완전일치 1건만 제외(EE_* 5건은 남긴다)
export const EXCLUDED_STATUS = 'P'; // C1 — Status 콤보에서 Plan 제거
export const PERIOD_OFFSET_DAY = '30'; // SCM0001_SCP_DAY_PERIOD_GET p_offset_day
export const PLAN_FROM_OFFSET_DAY = 9; // ChangeType='P' -> fromDate = 오늘+9D (cs:3096)
// Period 기본값 SP — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD. dayjs 근사 금지(design 02 §5.4).
//   call-proc 라우트는 SCM_ADM_MNU_BTN_MPG_M(MNU_ID,SHT_NM,MNU_BTN_CD)->API_ID 로 해석되므로
//   이 화면에 기능 버튼코드를 등록해 경유한다(05_register.sql). SP명 기반 버튼코드는 DB 기등록 관례
//   (예 SSP0019 GET_SHIPMENT_PLAN_DETAIL / SAVE_SHIPMENT_REQUEST_DRAFTING) 미러다.
export const BTN_DAY_PERIOD = 'GET_SCP_DAY_PERIOD';
export const BTN_SAVE_COMPLETE = 'SAVE_SHIPMENT_REQUEST_COMPLETE';
export const BTN_SAVE_DRAFTING = 'SAVE_SHIPMENT_REQUEST_DRAFTING';
export const BTN_DELETE_DRAFTING = 'DELETE_SHIPMENT_REQUEST_DRAFTING';
// SaveButton 사전검증 3종. 주의: AS-IS 는 이 3건을 **SaveButton(cs:845~930)** 에서 부른다 —
//   요청확정(BtnChangeRe_Click cs:3213)이 아니다. 채번 cs:864 / GetShipmentStatusChk cs:4090 /
//   GetErpSoNoCnt cs:4155. call-proc 라우팅용 버튼코드는 05_register_prechecks.sql 로 등록했다.
export const BTN_GET_CHANGE_REQ_NO = 'GET_CHANGE_REQ_NO';
export const BTN_GET_SHIPMENT_STATUS = 'GET_SHIPMENT_STATUS';
export const BTN_GET_ERP_SO_NO_CNT = 'GET_ERP_SO_NO_CNT';

// 요청확정/취소 실행체인 상태값 (AS-IS Change_Req_Status / Shipment_Status enum).
export const CHANGE_STATUS_REQUESTED = 'Q'; // cs:3316 sChangeStatus
export const SHIP_STATUS_REQUEST_DONE = 'R'; // cs:3317 sShipStatus — 이 값일 때만 완료 안내를 띄운다
export const SHIP_STATUS_CANCELED = 'C'; // cs:3446 ChangeType C/N 취소
export const SHIP_STATUS_PLAN_CANCELED = 'P'; // cs:3448 그 외 취소
export const DELETE_FLAG = 'D'; // cs:2632 — p_del_flag 는 호출 플래그와 무관하게 'D' 고정
export const IF_SEND_ON = 'Y';
export const IF_SEND_OFF = 'N';
export const NEW_YN_ON = 'Y';
// SP 반환 1열 판정값 — 'S' 성공 / 'X' 부분성공(재조회만) / 그 외 실패.
export const RESULT_SUCCESS = 'S';
export const RESULT_PARTIAL = 'X';

// ====================================================================================
// 그리드 셀 콤보 (design 03 §1.3)
// ====================================================================================
// A. 메타 구동으로 그대로 두는 것 — Incoterms 만 PASS(SQL 이 LOOKUP_TYPE 하드코딩, 파라미터 불요).
export const META_DRIVEN_COMBO_COLUMNS = ['INCOTERMS'] as const;

// B. 화면 주입 dataMap 대상 — 메타 콤보로는 파라미터(@lookupType/@sesUserId)를 공급할 수 없다(D-1/D-2).
//    주입 시 cellCboDataTp 를 반드시 비운다(자동 콤보가 덮어쓰면 빈 목록/다른 후보가 된다).
export const INJECTED_COMBO = {
  SHIPMENT_STATUS: 'SHIPMENT_STATUS',
  FCST_TYPE: 'FCST_TYPE',
  CHANGE_REASON_CODE: 'CHANGE_REASON_CODE',
  DIVISION_ID: 'DIVISION_ID',
  TO_SITE_DESCRIPTION: 'TO_SITE_DESCRIPTION',
  // 행 파라미터형 2종 — 후보가 행 값에 종속이라 컬럼 단위 조회로는 만들 수 없다.
  //   선택된 행 기준으로 그때그때 조회해 같은 dataMap 자리에 갈아끼운다(AS-IS SetCellTypeCombo 등가).
  TRANSPORT_MODE: 'TRANSPORT_MODE',
  END_CUSTOMER: 'END_CUSTOMER',
} as const;

// C. 미배선 — AS-IS 도 콤보를 붙이지 않았다. 콤보 신설 금지(design 03 §6 #8).
export const FREE_TEXT_COLUMN = 'NEW_TRANSPORT_MODE';
// EndCustomer 후보가 0행일 때 AS-IS 가 합성하는 단일 행(cs:6665~6675).
export const END_CUSTOMER_EMPTY_CODE = '-';

// ====================================================================================
// 컬럼 상수 (display='N' 컬럼은 그리드가 아니라 row 객체로만 읽는다 — CP-17)
// ====================================================================================
export const COLUMN = {
  DIVISION_ID: 'DIVISION_ID',
  ERP_SO_NO: 'ERP_SO_NO',
  SHIPMENT_STATUS: 'SHIPMENT_STATUS',
  CONFIRM_ID: 'CONFIRM_ID',
  ITEM_ID: 'ITEM_ID',
  NICK_NAME: 'NICK_NAME',
  PROJECT_CODE: 'PROJECT_CODE',
  PROJECT_NAME: 'PROJECT_NAME',
  END_CUSTOMER: 'END_CUSTOMER',
  FCST_TYPE: 'FCST_TYPE',
  FROM_SITE: 'FROM_SITE',
  FROM_SITE_DESCRIPTION: 'FROM_SITE_DESCRIPTION',
  TO_SITE: 'TO_SITE',
  TO_SITE_DESCRIPTION: 'TO_SITE_DESCRIPTION',
  INCOTERMS: 'INCOTERMS',
  SHIPMENT_CONFIRM_QTY: 'SHIPMENT_CONFIRM_QTY',
  SHIPMENT_DATE: 'SHIPMENT_DATE',
  TRANSPORT_MODE: 'TRANSPORT_MODE',
  CHANGE_REASON_CODE: 'CHANGE_REASON_CODE',
  CHANGE_REASON_DETAIL: 'CHANGE_REASON_DETAIL',
  REMARKS: 'REMARKS',
  REMARKS2: 'REMARKS2',
  REMARKS3: 'REMARKS3',
  ERP_ATTR1: 'ERP_ATTR1',
  ERP_ATTR2: 'ERP_ATTR2',
  ERP_ATTR3: 'ERP_ATTR3',
  CHANGE_REQ_NO: 'CHANGE_REQ_NO',
  // display='N' — row 객체 전용
  ERP_STATUS: 'ERP_STATUS',
  BOD_ID: 'BOD_ID',
  EDIT_MAIN: 'EDIT_MAIN',
  NEW_ETD: 'NEW_ETD',
  NEW_ETA: 'NEW_ETA',
  NEW_LT_DAY: 'NEW_LT_DAY',
  NEW_SHIPMENT_DATE: 'NEW_SHIPMENT_DATE',
  ELECTRODE_YN: 'ELECTRODE_YN',
  ELECTRODE_TYPE: 'ELECTRODE_TYPE',
  ORIGIN_FROM_DIVISION_ID: 'ORIGIN_FROM_DIVISION_ID',
  ORIGIN_TO_DIVISION_ID: 'ORIGIN_TO_DIVISION_ID',
  // display='N' — SAVE payload 원천(AS-IS cs:1015~1027 이 siMain 에서 그대로 읽는다).
  //   shtMain 메타 실측(ora.py)으로 15개 NEW_* 열이 존재함을 확인했다.
  NEW_CUSTOMER_LT: 'NEW_CUSTOMER_LT',
  NEW_ROUTE_ID: 'NEW_ROUTE_ID',
  NEW_BOD_ID: 'NEW_BOD_ID',
  NEW_D_COUNTRY: 'NEW_D_COUNTRY',
  NEW_D_PORT_CODE: 'NEW_D_PORT_CODE',
  NEW_A_COUNTRY: 'NEW_A_COUNTRY',
  NEW_A_PORT_CODE: 'NEW_A_PORT_CODE',
  NEW_TO_COUNTRY: 'NEW_TO_COUNTRY',
  NEW_TO_CITY: 'NEW_TO_CITY',
  NEW_TRANSPORT_MODE: 'NEW_TRANSPORT_MODE',
  // SP 반환 전용(메타 없음) — 수량 소수자리 판정 원천(design 03 §4.2)
  OPERATION_GROUP: 'OPERATION_GROUP',
  // shtSub
  PLAN_CONFIRM_ID: 'PLAN_CONFIRM_ID',
  NEW_YN: 'NEW_YN',
  NEW_SHIPMENT_CONFIRM_QTY: 'NEW_SHIPMENT_CONFIRM_QTY',
  CHK: 'CHK',
} as const;

// 팝업(이미지셀) 컬럼 — 더블클릭 팝업 전용. 인라인 편집은 취소한다(nscm-patterns §5-16).
export const ITEM_POPUP_COLUMN = COLUMN.ITEM_ID; // SCM0002_ItembyDivisionPopup
export const PROJECT_POPUP_COLUMN = COLUMN.PROJECT_CODE; // SCM0002_ProjectbyDivisionPopup
// 단일 클릭 드릴다운(조회 전용) — 값이 있을 때만 연다.
export const CHANGE_REQ_NO_POPUP_COLUMN = COLUMN.CHANGE_REQ_NO; // SCM0002_ShipmentPlanRequestPopup
export const SO_NO_POPUP_COLUMN = COLUMN.ERP_SO_NO; // SSP0300_OrderDetailPopup

// SO 그룹 전파 키 — chkSingleProcess 해제 시 동일 ERP_SO_NO 전 행에 전파(CP-11).
export const SO_GROUP_KEY = COLUMN.ERP_SO_NO;

// 동일 SO 전파 트리거 — design 03 §3.2 R-20/R-21/R-22/R-24 경로만이다.
//   전 편집컬럼을 전파하면 AS-IS 가 건드리지 않는 행까지 CRUD_TYPE='U' 로 저장 대상에 들어간다.
//   값까지 전파: TRANSPORT_MODE(R-20) / SHIPMENT_DATE(R-22, 파생 포함) /
//              CHANGE_REASON_CODE(R-24, Detail 동반) / CHANGE_REASON_DETAIL(cs:6590~6609 직접 입력 경로)
export const SO_PROPAGATE_VALUE_COLUMNS = [
  COLUMN.TRANSPORT_MODE,
  COLUMN.SHIPMENT_DATE,
  COLUMN.CHANGE_REASON_CODE,
  COLUMN.CHANGE_REASON_DETAIL,
] as const;
//   행상태만 'M'(= CRUD_TYPE 'U') 로 전파: REMARKS/REMARKS2/SHIPMENT_CONFIRM_QTY(R-21)
export const SO_PROPAGATE_STATUS_COLUMNS = [
  COLUMN.REMARKS,
  COLUMN.REMARKS2,
  COLUMN.SHIPMENT_CONFIRM_QTY,
] as const;
//   위 7열 외(INCOTERMS·REMARKS3·ERP_ATTR1~3)는 자기 행만 마킹한다.
// chkSingleProcess 를 보지 않는 전파 경로 — AS-IS 실측(2026-09-28 정본 cs grep `chkSingleProcess` 7 hit).
//   체크박스를 보는 자리는 cs:6336/6386/6447/6476/6517/6595 전부 `shtMain_Change`/`SpdMain_EditChange` 다.
//   콤보 선택으로 값이 바뀌는 두 열은 `SpdMain_ComboSelChange` 가 유일한 live 전파 경로이고
//   그 블록에는 체크박스 조건이 없다 — 따라서 체크 여부와 무관하게 동일 SO 전 행에 전파된다.
//   - TRANSPORT_MODE: cs:5817~5858 (`shtMain_Change` 의 TRANSPORT_MODE 분기 cs:6429~6437 은 전건 주석)
//   - CHANGE_REASON_CODE: cs:5862~5908 — `if (sSoNo == sChkSoNo)` 루프가 CODE·DETAIL·EDIT_MAIN 을
//     함께 쓰며 `chkSingleProcess` 참조가 0건이다. 체크박스를 보는 `shtMain_Change` 쪽 분기(cs:6595)와
//     상반되지만 콤보 경로가 먼저 전파를 끝내므로 실동작은 '체크 무관 전파'다(설계 R-24).
//   CHANGE_REASON_DETAIL 은 직접 입력 경로(cs:6590~6609)만 live 라 체크박스를 존중한다 — 여기 넣지 않는다.
export const SO_PROPAGATE_IGNORE_SINGLE_COLUMNS = [
  COLUMN.TRANSPORT_MODE,
  COLUMN.CHANGE_REASON_CODE,
] as const;

// shtSub 행/모드 조건 편집 게이트 — design 03 §3.5 R-31⑤.
//   열 축(StringAction~NEW_ETA 전열 잠금)은 INPUT_TP_CD 메타가 원천이다(hook #130).
//   여기 상수는 **모드 분기**(sShipStatus / SearchType)에만 쓴다 — 컬럼 잠금 화이트리스트가 아니다.
export const SUB_MODE_EDITABLE_COLUMNS = [
  COLUMN.NEW_SHIPMENT_CONFIRM_QTY,
  COLUMN.NEW_TRANSPORT_MODE,
  COLUMN.REMARKS2,
  COLUMN.REMARKS3,
  COLUMN.CHK,
] as const;
// SearchType='E' 경로에서만 해제되는 컬럼. TO-BE 는 SearchType 원천(전극 조회 SP)이 미이관이라
//   ≠'E' 분기 고정이다 — 잠금 유지가 현 시점 패리티다(04 확인필요로 보고).
export const SUB_SEARCH_TYPE_ONLY_COLUMNS = [COLUMN.NEW_SHIPMENT_DATE] as const;
// sShipStatus='R'(요청완료 후 재구성) 분기에서 추가 잠금되는 컬럼.
export const SUB_REQUESTED_LOCKED_COLUMNS = [
  COLUMN.NEW_SHIPMENT_DATE,
  COLUMN.NEW_SHIPMENT_CONFIRM_QTY,
] as const;

// div 40/EE 분기 — END_CUSTOMER ↔ PROJECT_CODE/PROJECT_NAME 상호배타 + ERP_ATTR1~3(hook #113).
//   SCM_MST_SHEET_COLUMNS.DIVISION_ID 가 124행 전건 NULL 이라 메타로 구동되지 않는다(실측).
export const END_CUSTOMER_DIVISIONS = ['40', 'EE'] as const;
export const DIVISION_TOGGLE = {
  END_CUSTOMER_ONLY: [COLUMN.END_CUSTOMER, COLUMN.ERP_ATTR1, COLUMN.ERP_ATTR2, COLUMN.ERP_ATTR3],
  PROJECT_ONLY: [COLUMN.PROJECT_CODE, COLUMN.PROJECT_NAME],
} as const;

// ChangeType='P' 시 폭 0(§2.1 P1·P2). AS-IS 도달 불가(Δ2)지만 분기는 보존한다.
export const PLAN_HIDDEN_COLUMNS = [COLUMN.ERP_SO_NO, COLUMN.CONFIRM_ID] as const;

// 폭 0 + display='Y' 보정 — AS-IS FarPoint 는 사용자 조작으로 폭이 살아났으나 Wijmo 는 보이지 않는다.
//   메타 정비(COLUMN_WIDTH)는 사용자 결정 사항이라 FE 최소폭 보정으로 기능 상실만 막는다(design 03 §6 #7).
export const MIN_WIDTH_OVERRIDE: Record<string, number> = {
  [COLUMN.CHANGE_REASON_CODE]: 110,
  [COLUMN.CHANGE_REASON_DETAIL]: 150,
};

// 수량 소수자리 — 행 OPERATION_GROUP='E'(전극) 3자리 / 그 외 0자리(design 03 §2.3 S1).
export const ELECTRODE_OPERATION_GROUP = 'E';
export const ELECTRODE_SCALE = 3;
export const NON_ELECTRODE_SCALE = 0;
// shtSub 수량 2열은 무조건 3자리(S6·S7).
export const SUB_QTY_SCALE = 3;

// 행 상태 판정값
export const SHIPMENT_STATUS_CONFIRM = 'C';
export const SHIPMENT_STATUS_REQUESTED = 'R';
export const ERP_STATUS_CONFIRM = 'C';
export const CHANGE_REASON_NONE = '-';
// `'T07'` 의 진짜 자리는 신규행이 아니라 **저장 직전 검증**이다 —
//   `SSP_Main_Validation`(cs:3639~3643)이 Qty/Date/Mode/Incoterms 가 바뀐 **수정행**의 사유가
//   `'-'`/공백일 때 자동 세팅한다. 그 검증(5축)은 아직 미구현이라 이 상수도 아직 소비처가 없다.
//   `btnNew`(cs:3375~3435)에는 `CHANGE_REASON_CODE` 대입이 0건이므로 신규행 기본값으로 쓰지 마라.
export const CHANGE_REASON_AUTO_ON_CHANGE = 'T07';
// 신규행 div 분기 기준 — AS-IS 는 `clbDivision_ID.ControlValues == "40"` **단일 비교**다
//   (복사 경로 cs:2696·2740 / btnNew 경로 cs:3400). 컬럼 표시 축의 `END_CUSTOMER_DIVISIONS`
//   (`['40','EE']`)와 **다른 집합**이니 서로 재사용하지 마라.
export const NEW_ROW_END_CUSTOMER_DIVISION = '40';
// 공용 CRUD_TYPE 어휘를 그대로 쓴다(EditTracker 가 수정행에 넣는 값과 같아야 한다).
//   AS-IS StringAction 도 신규 'I' / 수정 'M' 이라 의미가 일치한다(design 03 R-21).
export const CRUD_INSERT = CRUD_TYPE.INSERT;
export const CRUD_UPDATE = CRUD_TYPE.MODIFY;
export const EDIT_MAIN_ON = 'Y';
export const EDIT_MAIN_OFF = 'N';

// ====================================================================================
// TO-BE i18n 코드 (hook #114 — AS-IS 번호를 그대로 쓰지 않는다).
//   AS-IS 번호는 주석 병기. TO-BE 미등록분은 영문 defaultValue fallback 으로 둔다(등록은 별도 요청).
//   금지: AS-IS 충돌 3종(저장성공/탭상한/그리드미준비 문구로 선점된 번호)은 코드에 쓰지 않는다.
//         충돌 번호와 등가 매핑 근거는 __asis-mapping__.md 표에 남긴다(Δ8).
// ====================================================================================
export const MSG = {
  NO_AUTH_DIVISION: 'MSG00667', // AS-IS MSG00097. TO-BE MSG00097 은 'Please select Division.' 로 다름
  NO_CHANGES: 'MSG00133', // 동일 — 'No modifications have been made.'
  SAVE_CONFIRM: 'MSG00001', // AS-IS 저장확인 번호의 등가(충돌 번호 재사용 금지)
  REQUIRED_VALUE: 'MSG00614', // 필수값 안내 등가 — '{0} value is required.'
  REQUIRED_COMBO: 'MSG00429', // Change Reason 미선택(design 02 §4.7)
  ERP_BLOCK_PERIOD: 'MSG00267', // 미등록 — 영문 fallback + {0}=PERIOD
  ALREADY_REQUESTED: 'MSG01189', // AS-IS MSG00174 -> 등가
  // AS-IS MSG00195('취소하시겠습니까?') -> 등가 2후보(MSG00684 / MSG01459, EN 문구 동일).
  //   먼저 등록된 MSG00684 를 쓴다(LBL 동일문구 2코드 선례와 같은 관례).
  CANCEL_CONFIRM: 'MSG00684',
  // L-096 완료 안내. AS-IS MSG00173 -> TO-BE MSG01188
  //   ('Your confirmed shipment plan change request has been completed.' EN 완전일치 실측).
  REQUEST_COMPLETED: 'MSG01188',
  OTHER_USER_REQUEST: 'MSG01258', // AS-IS MSG00248 -> 등가
  // AS-IS MSG00249 -> TO-BE MSG01259 'Confirm ID has been deleted (Qty: 0)...' (EN 완전일치 실측)
  DELETED_CONFIRM_PLAN: 'MSG01259',
  ERP_DO_CREATED: 'MSG01202', // AS-IS MSG00189 -> 등가 'In ERP, DO is created...'
  // TO-BE MSG01296 EN 실측 = 'BOD (Trans mode, Incoterms) information corresponding to Div,
  //   From Site, To Site is invalid.' = AS-IS **MSG00324**(저장결과 'X' 자리, cs:1175) 완전일치다.
  //   AS-IS MSG00293(Trans mode 후보 없음)에도 이 코드를 쓰고 있어 두 자리가 같은 문구를 받는다 —
  //   MSG00293 전용 등가는 TO-BE 미등록(역조회 0건)이라 근사 유지, 04 확인필요로 보고.
  BOD_INVALID: 'MSG01296',
  PREREQUISITE_REQUIRED: 'MSG00098', // 선행값 필수(Div/From/To/Item) — 미등록, 영문 fallback
  // AS-IS MSG00194 -> TO-BE MSG01206 'Change requests are possible from the current D + {0} ship date.'
  //   셀 입력 시 하한 위반(cs:6318) + 요청확정 상한 위반(cs:3286) 두 자리에서 같은 코드를 쓴다.
  SHIPMENT_DATE_UNDER_BASE: 'MSG01206',
  // AS-IS MSG00201 -> TO-BE MSG01212 'Current D + {0} days can not be requested. Please delete and request again.'
  SHIPMENT_DATE_BEFORE_BASE: 'MSG01212',
  QTY_ZERO: 'MSG01213', // AS-IS MSG00202 -> 등가 'Enter a number greater than 0.'
  REASON_CODE_REQUIRED: 'MSG00287', // Reason Detail 선행으로 Reason Code 필수 — 미등록, 영문 fallback
  SO_PARTIAL_SELECT: 'MSG00247', // 동일 SO 부분선택 금지 — 미등록, 영문 fallback
  // 저장 결과 **'F' 한 자리 전용**이다(AS-IS cs:1125~1128 / 설계 L-092). TO-BE 등록 문구가
  //   'The sales price has not been entered...' 라, 통신오류·사전검증 실패·요청확정/취소 실패까지
  //   이 코드로 묶으면 전부 '판가를 입력하세요' 가 뜬다(L-094/L-100/L-101 번호 재사용 금지).
  //   그 외 실패는 SCREEN_TEXT.SAVE_FAILED(미등록 전용 키)로 분리한다.
  SALES_PRICE_MISSING: 'MSG00328',
  MODEL_NOT_SELECTED: 'MSG00261', // 저장 결과 'N'(AS-IS cs:1123) — 미등록, 영문 fallback
  // 요청확정 실패 분기 — AS-IS cs:2559~2578 의 3종. 전건 TO-BE 등가 실측(EN 완전일치).
  UNAUTHORIZED_APPROVER: 'MSG01317', // AS-IS MSG00316 'Unauthorized'
  DIFFERENT_MODEL_PIC: 'MSG01350', // AS-IS MSG00353 'UnModelPic'
  DIFFERENT_MODEL: 'MSG01347', // AS-IS MSG00353 'UnModelItem'
  INVALID_DATE_FORMAT: 'MSG01081', // AS-IS MSG00049 -> 등가 'This is not a valid date format. {0}'
  FIRST_ITEM_NOT_DELETABLE: 'MSG01209', // AS-IS MSG00198 -> 등가(체크 삭제 경로 전용)
} as const;

// 라벨 — design 02 §4.5 / 03 §2.2 실측(SCM_ADM_MSG_M + public/locales 번들 존재 확인).
export const LBL = {
  DIV: 'LBL00001',
  FROM_SITE: 'LBL00022',
  TO_SITE: 'LBL00023',
  STATUS: 'LBL00014',
  SHIPMENT_DATE: 'LBL01115',
  MODEL: 'LBL00669',
  SO_NO: 'LBL01111',
  CONFIRM_ID: 'LBL01063',
  CHANGE_TYPE: 'LBL01061',
  SEARCH: 'LBL00112',
  ALL: 'LBL00632',
  REQUESTOR: 'LBL01108',
  DEPT_NAME: 'LBL01071',
  APPROVAL: 'LBL01052',
  TITLE: 'LBL01125',
  CHANGE_REASON: 'LBL01060',
  REASON_DETAIL: 'LBL01104',
  REQUEST_COMPLETE: 'LBL01105',
  CANCEL: 'LBL00107',
  NEW: 'LBL01028',
  // shtSub 2단 헤더 — ChangeType='P' 분기(도달 불가). 메타 기본값 'Confirmed'/'Change' 는 그대로 쓴다.
  PLAN: 'LBL00358', // 'Plan' — 번들 실측 등록
  // 'Confirm' 은 LBL00359/LBL01034 두 코드가 동일 문구로 등록돼 있다(§6 #12 확인필요).
  //   AS-IS 도달 불가 분기라 실효 영향은 없고, 먼저 등록된 LBL00359 를 쓴다.
  CONFIRM: 'LBL00359',
} as const;

// 화면 전용 문구 키 — SCM_ADM_MSG_M/번들에 등가 코드가 없는 안내다.
//   MSG 코드를 빌려 쓰면(특히 완료 계열) 그 코드가 등록되는 순간 false success 문구가 된다.
export const SCREEN_TEXT = {
  INSERT_MULTIPLE: '_ssp0200.insertMultiple',
  // Insert Multiple 팝업의 건수 입력 라벨. 문구 키의 원천을 이 상수 하나로 둔다
  //   (컴포넌트가 `t('_ssp0200.insertCount')` 를 리터럴로 쓰면 같은 키에 원천이 둘 생긴다).
  INSERT_COUNT: '_ssp0200.insertCount',
  SINGLE_PROCESS: '_ssp0200.singleProcess',
  // ERP 중단기간 게이트가 판정 불가('unknown')일 때의 고지. AS-IS 에 대응 문구가 없다 —
  //   MSG 코드를 빌리면 그 코드가 등록되는 순간 엉뚱한 문구가 뜬다(hook #114).
  ERP_BLOCK_UNKNOWN: '_ssp0200.erpBlockUnknown',
  // 일반 저장 실패(통신오류 / 사전검증 호출 실패 / 요청확정·취소 실패 / 분기 미해당).
  //   AS-IS 는 이 자리에 MSG00284 를 썼지만 TO-BE MSG00284 는 'The grid is not ready.' 로 뜻이 다르고
  //   (메모리 ssp-asis-msg-ids-renumbered-into-msg011xx-block), MSG00328 은 'F' 전용이다 —
  //   등가 코드가 없어 화면 전용 키로 둔다.
  SAVE_FAILED: '_ssp0200.saveFailed',
  // 저장결과 'X' 상세(AS-IS cs:1140~1164 `string.Format("No soldto code from {0} - {1}", …)`).
  //   {0} = 'reason from division - site' 결합 문자열. 상세가 없으면 MSG.BOD_INVALID 로 떨어진다.
  SAVE_REASON_DETAIL: '_ssp0200.saveReasonDetail',
} as const;
