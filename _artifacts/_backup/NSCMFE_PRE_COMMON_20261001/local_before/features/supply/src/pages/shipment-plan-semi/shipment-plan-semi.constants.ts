export const MENU_ID = 'SCP0010' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Analysis.UIL SCP0010_Shipment_Plan_SEMI (단일 그리드 spdMain, 서브그리드 없음):
//   설계 근거: .atlas/gscm-design/SCP0010/design/00_checklist.md ~ 03_grid-columns.md
//   - GET SP: PKG_SCP0010.P_SCP0010_GET_SHIP_PLAN_SEMI (O_RC1 메인 + O_RC2 Plan상태 + O_RC3 Fix정보 + O_RESULT_CURSOR)
//   - 헤더구조 SP: PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN (SCP0009 와 공용, D_/W_/M_ 전체 항상 계산)
//   - 저장 SP 3종: P_SCP0010_SAVE_SEMI_DATASET(일반) / _FIX_DS(Fix/Unfix) / _WEEKLY(81계열 LOT분배, design 03 §4.4)
//   - 조회조건 cascade: cboDivision -> {cboOperGroup, clbFromSite/clbToSite, clbElecType(Enabled토글만), cboPlanDate->Type->Seq}
//   - 그리드: 정보컬럼 27개(전부 INPUT_TP_CD='S' 읽기전용) + 동적 D_/W_/M_ pivot(Bucket 무관 항상 전체 계산, SHIP_PLAN_AMEND 행만 편집가능)
export enum SHEETS {
  MAIN = 'main', // spdMain — 단일 그리드(정보컬럼 27 + 동적 pivot)
  CALENDAR = 'calendar', // 헤더구조(3-span D_/W_/M_) 전용 SP, PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN
}

// NSCM 단일 cursor 표준 — 단, MAIN 은 4-cursor 계약(o_rc1=데이터/o_rc2=Plan상태/o_rc3=Fix정보/o_result_cursor=성공응답, design 03 §4.2)
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  CALENDAR: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — DB 실측(design 03 §0) 그대로.
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'Shipment Plan SEMI',
};
// Measure 레지스트리 SHEET_NAME 2종(design 03 §0.1) — Operation Group 값(A=Cell)에 따라 분기
export const MEASURE_SHEET_NAME = {
  CELL: 'CELL',
  ELECTRODE: 'ELECTRODE',
} as const;
// TitleSet 저장 columnType — 'M'=Measure(shipment-plan-fg/sales-plan 등 동일 관례)
export const TITLESET_MEASURE_TYPE = 'M';

// Bucket — cboBucketType(Daily/Weekly/Monthly). GET SP 자체엔 Bucket 파라미터가 없다(design 03 §2.1
//   — SCP0009 와 달리 항상 D_/W_/M_ 전부 계산, Bucket 은 클라 visible 토글 전용).
export enum BUCKET_TYPE {
  DAILY = 'DAILY',
  WEEKLY = 'WEEKLY',
  MONTHLY = 'MONTHLY',
}

// Measure 코드마스터(design 03 §0.1, DB 실측 13건 — CELL 5종 + ELECTRODE 8종). 편집가능 = SHIP_PLAN_AMEND 유일(§3.1 R-K).
export const MEASURE = {
  SHIP_REQ: 'SHIP_REQ',
  SHIP_PLAN: 'SHIP_PLAN',
  SHIP_PLAN_AMEND: 'SHIP_PLAN_AMEND',
  CHAR_COMPLETED_QTY: 'CHAR_COMPLETED_QTY',
  INVENTORY: 'INVENTORY',
  SHIP_REQ_CELL_QTY: 'SHIP_REQ_CELL_QTY',
  SHIP_PLAN_CELL_QTY: 'SHIP_PLAN_CELL_QTY',
  SHIP_PLAN_AMEND_CELL_QTY: 'SHIP_PLAN_AMEND_CELL_QTY',
  COMPLETED_QTY: 'COMPLETED_QTY',
} as const;
// INVENTORY 행 — W_/M_ 값을 서버 SUM 이 아니라 그 주/월 마지막 D_ 값으로 클라 후처리(design 03 §2.5).
export const INVENTORY_MEASURE = MEASURE.INVENTORY;

// ====================================================================================
// 조회조건 콤보 ID — design 02 §2 DB 실측 확정(SCM_ADM_CMBO_SQL_M, 2026-09-24 PASS 8종)
// ====================================================================================
export const COMBO = {
  DIVISION: 'Division_SCP', // 무필터, EE 제외 없음(design 02 §2.1 — GetDivisionWithoutEE 오적용 금지)
  OPERATION_GROUP: 'LookupCommon', // lookupType=OPERATION_GROUP_SEMI/_EE(division EE 여부 분기) — base 공용 SQL, 화면전용 SQL_ID 아님(design 02 §2.2, SCP0009 의 OperationGroup_SCP 와 혼동 금지)
  FROM_SITE: 'AllPlantSiteDescription_SCP', // 전량 + division/operationGroup 클라 필터(design 02 §2.3)
  // ToSite 2원천 분기(design 02 §2.4) — SCP0009 의 유사이름 콤보(ToSiteShipmentPlanFG1_SCP_ALL/SaleSiteByDivision1_SCP_ALL)와
  //   절대 혼동 금지(convert-core §2.6). EE_UC/그 외(81/82/40 등) -> TO_SITE_ALL, EE(UC 제외) -> TO_SITE_EE_LOOKUP.
  TO_SITE_ALL: 'ShipmentPlanSEMIToStie1_SCP_ALL', // division EE_UC 또는 그 외(81/82/40 등) — 오타 "Stie" AS-IS 그대로 이관
  TO_SITE_EE_LOOKUP: 'ToSiteShipmentPlanSEMI1_SCP_ALL', // division EE(UC 제외)
  ELECTRODE: 'LookupCommon', // lookupType=ELECTRODE_TYPE, 초기 1회만(design 02 §2.5)
  PLAN_DATE: 'DATE_WEEKLY1_SCP_ALL', // 전량 + division 클라 필터(design 02 §2.6)
  PLAN_TYPE: 'PlanType1_SCP_ALL', // 전량 + division+planDate 클라 필터, 최신행 자동선택
  PLAN_SEQ: 'PlanSeq1_SCP_ALL', // 전량 + division+planDate+planType 클라 필터, SQL DESC 정렬로 최댓값 자동선택
} as const;
export const OPERATION_GROUP_LOOKUP_TYPE = {
  NORMAL: 'OPERATION_GROUP_SEMI',
  EE: 'OPERATION_GROUP_SEMI_EE',
} as const;
export const ELECTRODE_LOOKUP_TYPE = 'ELECTRODE_TYPE';

// 조회조건 저장/복원 제외 대상(design 02 §4 ConditionNotUseList) — Plan Date/Type/Seq. 필수값 검증과는 무관(그대로 적용).
export const CONDITION_NOT_USE_LIST = ['planStartYyyymmdd', 'planType', 'planSeq'] as const;

// AS-IS Validation MSG ID — TO-BE SCM_ADM_MSG_M 실측 역매핑 필요(design 02 §4.5 다수 "TO-BE 미등록").
//   design 문서가 실측을 완료하지 못한 항목은 영문 defaultValue fallback 유지(Hook #114 — 임의 매핑 금지).
export const MSG = {
  REQUIRED_FIELD: 'MSG00002', // 필수 입력사항입니다(Division/OperationGroup 만, design 01 §3)
  PERIOD_REQUIRED: 'MSG00049', // 기간 From/To 값 존재 검증 상당(design 02 §0-4 Check_PeriodDate_New)
  PERIOD_FROM_AFTER_TO: 'MSG00108', // From > To 검증 상당
  LOCKED_MODE: 'MSG00010', // 수정모드가 아니므로 저장할 수 없습니다(design 01 §2 #2-3)
  SAVE_NOT_ALLOWED: 'MSG00182', // SCP0013_GET_PLAN_TYPE_SAVE_YN false
  CONFIRM_UNFIX: 'MSG00016', // Unfix 확인(Yes/No, design 01 §2 #3)
  CONFIRM_RESEARCH: 'MSG00265', // New 팝업 OK 후 재조회 확인(design 01 §2 #5)
  SAVE_SUCCESS: 'MSG00004', // 저장 성공
  SAVE_FAIL: 'MSG00003', // 저장 실패
  QTY_NEGATIVE: 'MSG00225', // Quantity must be 0 or greater.(구 MSG00084 TO-BE 미등록 — gap-resolve iter-1 실측, production-plan-line/shipment-plan-fg 미러링)
  QTY_MAX: 'MSG00165', // You have exceeded the number of digits you can enter.(구 MSG00317 TO-BE 미등록 — 동일 미러링)
  NO_CHANGE: 'MSG00004', // 변경사항 없음(공용)
  NEW_POPUP_NOT_READY: 'MSG00284', // New 팝업(SCM0002_ShipmentPlanInsertPopup) 미구현 임시 안내(iter-4, 기존 MSG00000 은 DB 미등록이라 교체) — "The grid is not ready."
} as const;

// 저장 값 범위(design 03 §4.3)
export const QTY_MIN = 0;
export const QTY_MAX = 99999999;
