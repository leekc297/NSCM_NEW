export const MENU_ID = 'SSP0201' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SSP.Plan.UIL SSP0201_ShipmentChangeRequest (출하 변경 요청, 5838라인):
//   설계 근거: .atlas/gscm-design/SSP0201/design/00_checklist.md ~ 03_grid-columns.md, 상세 매핑 __asis-mapping__.md
//   - 그리드 2개: spdMain "Shipment Change Request"(65컬럼, 편집) / spdSub "Change Request"(58컬럼, 전량 읽기전용)
//   - GET  SP : PKG_SSP0201.P_SSP0201_GET_SHIPMENT_CHANGE_REQUEST(메인) / _GET_SHIPMENT_REQUEST_DRAFTING(서브)
//   - SAVE SP : _SAVE_SHIPMENT_REQUEST_DRAFTING(NewNonSoNo/NonSoNo/SoNo 3분기) / _SAVE_SHIPMENT_REQUEST_COMPLETE
//   - 편집 상태기계(R1/R2/R13): 조회=전체 lock(뷰) -> Edit(SwitchLock)=편집진입 -> Save/Cancel 성공 후 뷰 복귀
//   - Division "40" 고정 + disabled(R3). Insert=실동작 / Delete=NO-OP(R12) / dead UI 5버튼 미노출(R4, CN-4)
//   - 주의: PKG_SSP0201 미배포(convert-sp 후속) — 실 조회/저장 런타임 검증은 SP 배포 후 가능.
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

// 동적 컬럼/헤더 토글 대상 (design 03 §2)
export const PLAN_TOGGLE_COLUMNS = ['ERP_SO_NO', 'CONFIRM_ID']; // changeType='P' -> width 0
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
} as const;

// ====================================================================================
// UI 라벨 코드 (SCM_ADM_MSG_M MSG_TP_CD='LBL' 문구 역조회). AS-IS 번호 그대로 쓰지 않는다(#114).
//   Division=LBL00001(표준), Search=LBL00112(표준). 등가 없으면 defaultValue fallback 유지.
// ====================================================================================
export const LBL = {
  DIVISION: 'LBL00001',
  FROM_SITE: 'LBL00022',
  TO_SITE: 'LBL00023',
  PLAN_TYPE: 'LBL00040',
  STATUS: 'LBL00014',
  MODEL: 'LBL00669',
  SO_NO: 'LBL01111',
  CONFIRM_ID: 'LBL01063',
  SEARCH: 'LBL00112',
  EDIT: 'LBL00783',
  NEW: 'LBL01028',
  CANCEL: 'LBL00107',
  REQUEST_COMPLETE: 'LBL01105',
  TITLE: 'LBL01125',
  REQUESTOR: 'LBL01108',
  DEPT_NAME: 'LBL01071',
  APPROVAL: 'LBL01052',
  CHANGE_REASON: 'LBL01060',
  REASON_DETAIL: 'LBL01104',
} as const;
