export const MENU_ID = 'SSP0201' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SSP.Plan.UIL SSP0201_ShipmentChangeRequest (출하 변경 요청, 5838라인):
//   설계 근거: .atlas/gscm-design/SSP0201/design/00_checklist.md ~ 03_grid-columns.md, 상세 매핑 __asis-mapping__.md
//   - 그리드 2개: spdMain "Shipment Change Request"(65컬럼, 편집) / spdSub "Change Request"(58컬럼, 전량 읽기전용)
//   - GET  SP : PKG_SSP0201.P_SSP0201_GET_SHIPMENT_CHANGE_REQUEST(메인) / _GET_SHIPMENT_REQUEST_DRAFTING(서브)
//   - SAVE SP : _SAVE_SHIPMENT_REQUEST_DRAFTING(NewNonSoNo/NonSoNo/SoNo 3분기) / _SAVE_SHIPMENT_REQUEST_COMPLETE
//   - 편집모드 모드토글 미이식: AS-IS 는 EditButton/SwitchLock 상태기계(조회=전열 lock -> Edit 으로 해제,
//       cs:693~762, 진입가드 siSub.RowCount==0)지만 **편집 기본 ON** 으로 간다 — convert-core §2.4 +
//       사용자 지시(2026-09-25/2026-10-07). 자매 SSP0200 과 동일하다. 종전 TO-BE 의 Edit 버튼은 가드
//       `subRows.length > 0` 에 걸리면 알림도 없이 무동작이라 서브에 행이 있는 순간 편집이 도달불가였다.
//       컬럼 단위 잠금은 모드가 아니라 행 상태/컬럼 속성(editLock)이 담당한다.
//   - Division "40" 고정 + disabled(R3). Insert=실동작 / Delete=저장 전 신규행 전용(아래) / dead UI 5버튼 미노출(R4)
//   - Delete: AS-IS `DeleteButton()`(본문 공백 NO-OP)이나, 넣은 신규행을 되돌릴 수단이 없어 자매 SSP0200 과
//       동일하게 **저장 전 신규행(CRUD_TYPE='I')만 제거**로 실동작을 부여했다(사용자 지시 2026-10-07).
//   - PKG_SSP0201 배포 상태(2026-10-07 ora.py 실측): PACKAGE/PACKAGE BODY 모두 VALID. 종전 "미배포" 주석은 stale.
//       배포된 SP 10종 = _GET_SHIPMENT_CHANGE_REQUEST / _GET_SHIPMENT_CHANGE_REQUEST_N(신규조회 라우팅) /
//       _GET_SHIPMENT_REQUEST_DRAFTING / _GET_CHANGE_REQ_NO / _GET_ERP_SO_NO_CNT / _GET_SHIPMENT_STATUS /
//       _SAVE_SHIPMENT_CONFIRM_NEW / _SAVE_SHIPMENT_REQUEST_DRAFTING / _SAVE_SHIPMENT_REQUEST_COMPLETE /
//       _DELETE_SHIPMENT_REQUEST_DRAFTING.
//   - 단, 버튼메타(SCM_ADM_MNU_BTN_MPG_M)는 SEARCH/SAVE/EDIT/INSERT + sub SEARCH **5행만** 등록돼 있다.
//       DELETE · EXCEL · GET_CHANGE_REQ_NO · GET_SCP_DAY_PERIOD · GET_SHIPMENT_STATUS · GET_ERP_SO_NO_CNT ·
//       SEARCH_NEW · SAVE_DRAFTING · SAVE_COMPLETE · USER_CHECK 미등록 → 해당 FE 경로는 메타 등록 후 배선.
//       (자매 SSP0200 은 18행 등록. 등록 SQL 은 다음 회차 산출물.)
export enum SHEETS {
  MAIN = 'main', // spdMain "Shipment Change Request" (65컬럼)
  SUB = 'sub', // spdSub "Change Request" (58컬럼, 읽기전용)
}

// NSCM 단일 cursor 표준 'o_rc1'. 서브 GET SP 는 2개 결과셋(상세 + Model PIC)이나 주 표시셋은 o_rc1.
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  SUB: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS SpdSheet 명 그대로 (design 03 §0).
//   실측: PROGRAM_ID='SSP0201' -> "Shipment Change Request" 65행 / "Change Request" 58행 (총 123행 배포됨).
export const ADMIN_SHEET_NAME: Record<SHEETS, string> = {
  [SHEETS.MAIN]: 'Shipment Change Request',
  [SHEETS.SUB]: 'Change Request',
};

// ====================================================================================
// 조회조건 콤보/lookup ID (design 02 §2/§5 — TO-BE Oracle 실측, ora.py)
// ====================================================================================
//   - MyDivision(CMBO_SQL): 권한 division + ATTRIBUTE3<>'EE'(EE 제외 WHERE 내장). Division 40 고정.
//   - To Site: ShipmentPlanToSite_SCP(CMBO_SQL) @divisionId 재조회.
//   - From Site: CN-1 미확정(iter-2 재확인) — AS-IS 활성코드 Data.UserPlantSiteByDivisionOspPack 는
//       C# Data.* 메서드로 asis.py procs 조회 0건(MSSQL SP/함수 아님) → WHERE 실측 불가. TO-BE 엔
//       유사명 ShipmentPlanPlantSite_SCP(PLANT+EE_SHIPMENT_PLAN, SSP_UI_EXCEPT_COMPANY 제외)만 존재.
//       OSP 외주/Packer 권한 반영 여부를 DB 로 검증할 수 없어 의미 등가 미확정 — 잠정 유지, 04 CN-1
//       확인필요(사용자 축) 인계(convert-core §2.6 이름재사용 단정 금지).
export const COMBO = {
  DIVISION: 'MyDivision',
  TO_SITE: 'ShipmentPlanToSite_SCP',
  FROM_SITE: 'ShipmentPlanPlantSite_SCP', // CN-1: OSP팩 의미 등가 미검증(확인필요)
} as const;

export const LOOKUP = {
  CHANGE_REQ_TYPE: 'CHANGE_REQ_TYPE', // Plan Type: P/C/N/A (ALL 없음, 기본 C)
  SHIPMENT_STATUS: 'SHIPMENT_STATUS', // Status: P/C/D/R (P 제외 + ALL 선두, 기본 ALL)
  SALES_TYPE_CODE: 'SALES_TYPE_CODE', // 그리드 FCST_TYPE 셀콤보
} as const;

// 조회조건 sentinel/기본값 (design 02 §4)
export const ALL = 'ALL';
export const FIXED_DIVISION = '40'; // R3: Division "40" 고정 + disabled
export const DEFAULT_PLAN_TYPE = 'C'; // Plan Type 기본 Confirm (SelectedIndex=1)
export const DEFAULT_STATUS = ALL; // Status 기본 ALL
export const PLAN_TYPE_PLAN = 'P'; // Plan 분기(from=오늘+9D 재계산)
export const PERIOD_OFFSET_DAY = '30'; // Period 기본 30일 (SCM0001_GET_SCP_DAY_PERIOD)
export const PLAN_TYPE_P_FROM_OFFSET = 9; // Plan Type='P' 시 from = 오늘+9D (design 02 §3 cascade#2)

// ====================================================================================
// 그리드 셀 콤보 (design 03 §1.3)
// ====================================================================================
// A. 메타 구동 콤보(FPComboBox, admin 메타 정상 등록 — 자동 배선). CELL_COMBO_DATA_TYPE 로 DataGrid 자동.
export const META_COMBO = {
  SHIPMENT_STATUS: 'LookupCommon', // PARAM1=SHIPMENT_STATUS (lookup)
  FCST_TYPE: 'LookupCommon', // PARAM1=SALES_TYPE_CODE (lookup)
  INCOTERMS: 'Incoterms', // CMBO_SQL
  CHANGE_REASON_CODE: 'CHANGE_REASON_CODE_ALL', // CMBO_SQL
} as const;

// B. 코드 구동 cascade 셀 콤보(AS-IS SetCellTypeCombo — per-row 재조회). 콤보 SQL_ID 는 등록됐으나
//    SCM_MST_SHEET_COLUMNS 의 이 컬럼들은 CELL_COMBO_DATA_TYPE/ATTRIBUTE2/10 이 공란(미이관, design 03 §6).
//    per-row cascade 는 공용 DataGrid 가 admin 메타(PARAM10='D' + ATTRIBUTE2 부모바인드)로만 구동한다
//    (useRowParamCombos — FE 전용 cascade 경로 없음). 그래서 05_register.sql 메타 등록이 유일한 재현 수단.
//    iter-2(GAP-02): 의미 명확·자기완결 2종만 메타 등록 완료(ora.py exec 재조회 확인):
//      - TRANSPORT_MODE      : `TransMode`(CN-2 확정 — ora.py 실측 3종 중 @div/@from/@to/@incoterms +
//                              BOD 상세 반환형이 AS-IS FindData_BOD 파생과 등가. TransModeCode=정적 lookup,
//                              SSP16LocTransMode_SCP=패킹CODE형 → 배제).
//      - TO_SITE_SHIPTO_CODE : `ShipToCodeByDivision`(@div/@scmSiteId=TO_SITE).
//    보류 4종(04 리포트 확인필요): DIVISION_ID(전량 잠금—실익 없음), FROM_SITE_DESCRIPTION(CN-1 OSP팩
//      SQL_ID 미확정), TO_SITE_DESCRIPTION(콤보 CODE=site_id vs 컬럼=description 저장규약+TO_SITE 동기),
//      END_CUSTOMER(콤보 @param5 상수 'P' 를 행-파라미터 메타로 전달 불가).
export const CASCADE_CELL_COMBO = {
  DIVISION_ID: 'MyDivision', // 고정 목록(EE 제외), 재조회 아님, 전량 잠금(메타 보류)
  FROM_SITE_DESCRIPTION: COMBO.FROM_SITE, // division (CN-1 미확정 — 메타 보류)
  TO_SITE_DESCRIPTION: 'ToSiteByDivisionEEForSSP_SCP', // division (code/desc 규약 — 메타 보류)
  TO_SITE_SHIPTO_CODE: 'ShipToCodeByDivision', // division + toSite (메타 등록됨 PARAM10='D')
  TRANSPORT_MODE: 'TransMode', // division+fromSite+toSite+incoterms (CN-2 확정, 메타 등록됨 PARAM10='D')
  END_CUSTOMER: 'EndCustomerByItemForSSP_SCP', // division+toSite+item+fromSite+'P'(상수 — 메타 보류)
} as const;

// ====================================================================================
// 편집 화이트리스트 (design 03 §3.1 lock 39건)
// ====================================================================================
// 기존행 status='C' AND erp_status!='C' 일 때 편집가능한 컬럼셋(그 외 전부 잠금).
export const EXISTING_ROW_EDIT_COLUMNS = [
  'SHIPMENT_CONFIRM_QTY',
  'SHIPMENT_DATE',
  'TRANSPORT_MODE',
  'CHANGE_REASON_CODE',
  'CHANGE_REASON_DETAIL',
  'REMARKS2',
  'REMARKS',
  'REMARKS3',
  'TO_SITE_SHIPTO_CODE',
] as const;

// 신규행(action='I') 편집가능 컬럼셋 (design 03 §3.1 :747-750).
export const NEW_ROW_EDIT_COLUMNS = [
  'ITEM_ID',
  'FCST_TYPE',
  'FROM_SITE_DESCRIPTION',
  'TO_SITE_DESCRIPTION',
  'INCOTERMS',
  'SHIPMENT_CONFIRM_QTY',
  'SHIPMENT_DATE',
  'TRANSPORT_MODE',
  'CHANGE_REASON_CODE',
  'CHANGE_REASON_DETAIL',
  'REMARKS2',
  'REMARKS',
  'REMARKS3',
  'TO_SITE_SHIPTO_CODE',
  'PROJECT_CODE',
  'END_CUSTOMER',
] as const;

// 라벨 `*` 필수 컬럼(메인, INPUT_TP_CD 전건 'S'라 라벨 매핑으로 필수검증 — design 03 §1.1/§4.4).
export const REQUIRED_MAIN_COLUMNS = [
  'ITEM_ID',
  'PROJECT_CODE',
  'END_CUSTOMER',
  'FCST_TYPE',
  'FROM_SITE_DESCRIPTION',
  'TO_SITE_DESCRIPTION',
  'SHIPMENT_CONFIRM_QTY',
  'SHIPMENT_DATE',
  'TRANSPORT_MODE',
] as const;

// 팝업(이미지셀) 컬럼 — 더블클릭 팝업으로만 값 입력(인라인 편집 취소, nscm-patterns §5-16).
export const ITEM_POPUP_COLUMN = 'ITEM_ID'; // SSP0026_ItembyDivisionPopup
export const PROJECT_POPUP_COLUMN = 'PROJECT_CODE'; // SCM0002_ProjectbyDivisionPopup

// EDIT_MAIN 파생마다 재계산되는 변경검지 플래그(design 03 §3.2). 저장 대상 판정 근거.
export const EDIT_MAIN_FLAG = 'EDIT_MAIN';
// SO No 그룹 전파 키(같은 ERP_SO_NO 전행에 동일 변경 복제, design 03 §3.2).
export const SO_GROUP_KEY = 'ERP_SO_NO';

// 폭 0 + VISIBLE_FLAG='Y' 인 핵심 편집 2열의 최소폭 보정 — 자매 SSP0200 과 동일 값/동일 방식.
//   메타가 두 열을 COLUMN_WIDTH=0 으로 두고 있어(ora.py 실측, SSP0200 도 같다) 보정 없이는 폭 0 으로
//   렌더돼 입력이 도달 불가다. 메타 폭을 UPDATE 하지 않고 FE 최소폭으로 올리는 것이 자매의 처방이다
//   (07_register_column-width-parity.sql 은 VISIBLE_FLAG 만 'Y' 로 복원했다).
export const MIN_WIDTH_OVERRIDE: Record<string, number> = {
  CHANGE_REASON_CODE: 110,
  CHANGE_REASON_DETAIL: 150,
};

// 동적 컬럼/헤더 토글 대상 (design 03 §2)
export const PLAN_TOGGLE_COLUMNS = ['ERP_SO_NO', 'CONFIRM_ID']; // changeType='P' -> width 0

// ====================================================================================
// spdSub "Change Request" 런타임 파생 (AS-IS InitSpread(shtSub) cs:597~653 실측)
// ====================================================================================
export const SUB_COLUMN = {
  CHK: 'CHK', // 헤더 체크박스(cs:606~613) + MergePolicy.None(cs:615~617)
  REMARKS: 'REMARKS', // "화면에서만 제거함" 런타임 폭 0 (cs:622)
  ERP_SO_NO: 'ERP_SO_NO', // changeType='P' 면 숨김 (cs:627) / 그 외 표시 (cs:649)
} as const;

// 2단 헤더 그룹라벨 — 메타 SMALL_CLASS_LABEL_NAME 기본값이 else 분기(Confirmed/Change)다.
//   changeType='P' 일 때만 Plan/Confirm 으로 교체한다(cs:629~630 vs cs:651~652, 각 span 7열).
//   앵커 컬럼: 비NEW군 선두 LT_DAY / NEW군 선두 NEW_LT_DAY.
export const SUB_GROUP_LABEL = {
  DEFAULT: { confirmed: 'Confirmed', change: 'Change' }, // changeType != 'P' (메타 SCLS 일치)
  PLAN: { confirmed: 'Plan', change: 'Confirm' }, // changeType == 'P'
} as const;
export const DIVISION_EXCLUSIVE = {
  END_CUSTOMER: 'END_CUSTOMER', // div 40/EE 노출
  PROJECT_CODE: 'PROJECT_CODE', // div!=40/EE 노출
  PROJECT_NAME: 'PROJECT_NAME',
} as const;
export const EE_DIVISION = 'EE';

// ====================================================================================
// TO-BE MSG 코드 (SCM_ADM_MSG_M 문구 역조회 — Hook #114. AS-IS 번호를 그대로 쓰지 않는다).
//   AS-IS 원 MSG 번호는 주석 병기(design 01 §2 R8/R14). 미검증 코드는 defaultValue fallback 유지.
// ====================================================================================
export const MSG = {
  REQUIRED_DIVISION: 'MSG00097', // 조회 필수(Division) — "Division 을 선택하세요."
  NO_CHANGES: 'MSG00133', // 변경 없음 — bolChang_Flag==false ("수정한 내용이 없습니다")
  SAVE_CONFIRM: 'MSG00001', // 저장 확인 다이얼로그 "Would you like to save it?" (AS-IS 번호 MSG00012). iter-3 GAP-11: TO-BE MSG00012='Maximum of 10 tabs allowed.' 오매핑을 실측(EN/KO.json) 정문구 MSG00001 로 수정
  SAVE_SUCCESS: 'MSG00672', // 저장 성공(건수)
  SAVE_FAIL: 'MSG00003', // 저장 실패
  ERP_BLOCK: 'MSG00267', // R8: ERP 중단기간 차단 alert
  ALREADY_COMPLETE: 'MSG00174', // SHIPMENT_STATUS='R'(요청완료) 저장 차단
  CANCEL_CONFIRM: 'MSG00195', // 취소 확인 다이얼로그
  QTY_ZERO: 'MSG00202', // 수량 0 차단("0보다 큰 수를 입력하십시오")
  DATE_UNDER_BASE: 'MSG00201', // 출하일 하한(현재+D일 미만) 차단
  DATE_OVER_MAX: 'MSG00194', // 출하일 상한(현재+D일 초과) 차단
  ERP_STATUS_LOCKED: 'MSG00189', // erp_status='C'(DO 생성됨) 변경 차단
  REASON_CODE_REQUIRED: 'MSG00287', // Reason Detail 입력 전 Reason Code 필수
  FROM_SITE_REQUIRED: 'MSG00098', // To Site/Incoterms 선행 필수(From Site 등)
  TRANS_MODE_UNAVAILABLE: 'MSG00293', // TransMode 후보 없음(FindData_BOD 실패)
  REQUIRED_FIELD: 'MSG00013', // 필수값 누락 "Please enter the required fields."(승인자/제목/변경사유/사유상세, AS-IS 번호 MSG00002). iter-3 GAP-11: TO-BE MSG00002='Saved successfully.' 오매핑을 실측(EN/KO.json) 정문구 MSG00013 로 수정
  // ── 신규행 저장(SAVE_SHIPMENT_CONFIRM_NEW) 응답 RESULT_CODE 분기 (AS-IS L994~1010) ──
  //   'N' AS-IS MSG00261 "Model 조회 후 입력하여 주십시오" -> SCM_ADM_MSG_M 문구 역조회
  //       (convert-core §4.1). TO-BE 에 MSG00261 번호는 부재하고 MSG01269 가 동치 문구다.
  NEW_MODEL_REQUIRED: 'MSG01269', // "Please check the model before entering."
  //   'F' AS-IS MSG00328 — TO-BE 에 **같은 번호로 같은 문구**가 실재(실측):
  //       "The sales price has not been entered. Please enter the sales price before proceeding."
  NEW_PRICE_REQUIRED: 'MSG00328',
} as const;

// ====================================================================================
// UI 라벨 코드 (SCM_ADM_MSG_M MSG_TP_CD='LBL' 문구 역조회). AS-IS 번호 그대로 쓰지 않는다(#114).
//   Division=LBL00001(표준), Search=LBL00112(표준). 등가 없으면 defaultValue fallback 유지.
// ====================================================================================
export const LBL = {
  DIVISION: 'LBL00001',
  FROM_SITE: 'LBL00022',
  TO_SITE: 'LBL00023',
  // Plan Type(cboChangeType) 라벨 — AS-IS `PlanType1.Visibility=Never`(Designer:810) 로 **렌더하지 않는다**.
  //   값은 store 에서 'C'(Confirm) 고정이다. 상수는 근거 추적용으로만 남긴다(사용처 0건).
  PLAN_TYPE: 'LBL00040',
  STATUS: 'LBL00014',
  SHIPMENT_DATE: 'LBL01115', // 자매 SSP0200 과 동일 코드(DB·번들 실측 'Shipment Date')
  // 조회조건 Model 필드 라벨 = "Model/Nickname"(사용자 지시 2026-10-07. 자매 SSP0015 400ceb57 선례).
  //   LBL00618 은 SCM_ADM_MSG_M(KO/EN/CN 전건 'Model/Nickname', USE_YN='Y') + public/locales 번들 양쪽
  //   실측 완료 — 신규 등록 불요. 종전 LBL00669('Model')에서 교체. 4자매 화면 동일 적용.
  //   라벨칸 폭 override 는 두지 않는다 — 상세 근거는 SSP0200 constants 의 동일 주석 참조.
  MODEL_NICKNAME: 'LBL00618',
  // SO No(txtSoNo) 라벨 — AS-IS `lblSONo.Visibility=Never`(Designer:824, `lblSONo.Control=txtSoNo` 로
  //   입력칸까지 감싼 항목이라 필드 전체 비노출) → **렌더하지 않는다**. 자매 SSP0200 은 노출한다.
  //   store `erpSoNo` 는 payload 계약상 유지하고 항상 ''(전체) 로 나간다. 상수는 근거 추적용(사용처 0건).
  SO_NO: 'LBL01111',
  CONFIRM_ID: 'LBL01063',
  SEARCH: 'LBL00112',
  CANCEL: 'LBL00107',
  REQUEST_COMPLETE: 'LBL01105',
  TITLE: 'LBL01125',
  // 요청정보 섹션 헤더 — AS-IS `usrLabel2.Text = "Request Info"`(Designer:1351, Location 12,12).
  //   LBL01107: DB·번들 실측 등록분 — 자매 SSP0200 과 동일 코드.
  REQUEST_INFO: 'LBL01107',
  REQUESTOR: 'LBL01108',
  DEPT_NAME: 'LBL01071',
  APPROVAL: 'LBL01052',
  CHANGE_REASON: 'LBL01060',
  REASON_DETAIL: 'LBL01104',
} as const;

// ====================================================================================
// 화면 전용 문구 키 — AS-IS 에 대응 MSG/LBL 코드가 없는 자리(hook #114: 번호를 빌리면 그 코드가
//   등록되는 순간 엉뚱한 문구가 뜬다). `_` 접두 미등록 키라 항상 defaultValue 로 표시된다.
// ====================================================================================
export const SCREEN_TEXT = {
  // New 버튼 캡션 — AS-IS `btnNew.Text="New"`(Designer 실측, 로케일 무관 고정 영문)이라 i18n LBL01028
  //   (KO='신규')을 쓰지 않는다. 자매 SSP0200 과 동일 축.
  NEW: '_ssp0201.new',
  // Delete 가 저장 전 신규행만 지운다는 안내. 선택행에 신규행이 하나도 없을 때만 띄운다 —
  //   조용히 무동작이면 "버튼이 고장났다" 로 읽힌다. AS-IS 에 대응 문구가 없다(DeleteButton 빈 본문).
  DELETE_INSERT_ONLY: '_ssp0201.deleteInsertOnly',
  // 메인 그리드 SHIPMENT_CONFIRM_QTY 동적 헤더 — AS-IS cs:562/574 가 `MessageHelper.GetTerm()` 으로
  //   "Shipment Plan Qty"(changeType='P') / "Shipment Confirm Qty"(그 외)를 넣는다. TO-BE 는 두 문구가
  //   `SCM_ADM_MSG_M` 0행이라(자매 SSP0200 R-70 D3/D6 실측) MSG/LBL 코드를 빌리지 않고 화면 전용 키로 둔다.
  //   `*` 는 메타 COLUMN_LABEL_NAME('Shipment Qty*')의 필수 표식을 승계한 것이다(REQUIRED_MAIN_COLUMNS 포함).
  QTY_HEADER_PLAN: '_ssp0201.qtyHeaderPlan',
  QTY_HEADER_CONFIRM: '_ssp0201.qtyHeaderConfirm',
  // spdSub 2단 헤더 changeType='P' 분기 그룹라벨(cs:629~630 "Plan"/"Confirm"). 메타 기본값
  //   Confirmed/Change 는 SCLS 에 실재하지만 Plan/Confirm 은 메타에 없어 FE 가 공급한다.
  //   'Confirmed'/'Change'/'Plan'/'Confirm' 4문구 모두 SCM_ADM_MSG_M 0행이라 화면 전용 키로 둔다.
  SUB_GROUP_PLAN: '_ssp0201.subGroupPlan',
  SUB_GROUP_CONFIRM: '_ssp0201.subGroupConfirm',
} as const;
