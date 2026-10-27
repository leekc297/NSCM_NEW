export const MENU_ID = 'SCP0009' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Analysis.UIL SCP0009_Shipment_Plan_FG — spdMain 단일 그리드(하단 서브그리드 spdPeggingInfo/spdPlanProblem 은 제외, 사용자 결정):
//   설계 근거: .atlas/gscm-design/SCP0009/design/00_checklist.md ~ 03_grid-columns.md
//   - GET SP: PKG_SCP0009.P_SCP0009_GET_SHIPMENT_PLAN_FG (O_RC1 메인 + O_RC2 Plan상태 + O_RC3 Fix정보)
//   - 헤더구조 SP: PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN (D_/W_/M_ 전체, Bucket 무관)
//   - 저장 SP(Weekly): P_SCP0009_SAVE_ANL_SHIP_PLAN_FG_WEEKLY — Daily 저장 SP 매핑은 확인 필요(design 03 §6#6)
//   - 조회조건 cascade: cboDivision -> {cboBizType, clbFromSite/clbToSite, clbTeam, cboPlanDate->Type->Seq}
//   - 그리드: 정보컬럼 44개(전부 INPUT_TP_CD='S' 읽기전용) + 동적 D_/W_/M_ pivot(값만 SHIP_PLAN_AMEND 행 편집가능)
export enum SHEETS {
  MAIN = 'main', // spdMain — Shipment Request (44 정보컬럼 + 동적 pivot)
  // 헤더구조(3-span D_/W_/M_) 전용 SP — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN
  //   (API_ID SCP0009_SHEET_CALENDAR_3SPAN_GET). 05_register.sql 의 iter-3 UPDATE 적용 후 이 SP 로 연결된다.
  //   PKG_SCP0009.P_SCP0009_GET_SHIP_PLAN_FG_TITLE_PARAL 은 헤더 메타가 아닌 pivot 데이터를 반환하므로 쓰지 않는다.
  CALENDAR = 'calendar',
}

// 저장가능 판정(Get_IsSaveYn) 호출 시트 — SCM_ADM_MNU_BTN_MPG_M 의 SCP0009/saveYn/SEARCH →
//   API P_SCP0013_SAVE_YN_GET(PKG_SCP0013.P_SCP0013_GET_PLAN_SAVE_YN, 2026-10-06 등록, 05_register.sql 끝).
//   SHEETS enum 에 넣지 않는 이유: 이 시트는 procedures.d.ts(SCP0009)에 타입이 없어 untyped apiClient.post 로만 부른다.
export const SAVE_YN_SHEET = 'saveYn';

// NSCM 단일 cursor 표준 — 단, MAIN 은 3-cursor 계약(o_rc1=데이터/o_rc2=Plan상태/o_rc3=Fix정보, design 03 §2.5)
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  CALENDAR: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — DB 실측(design 03 §0) 그대로.
//   Measure 레지스트리는 컬럼 sheetNm 과 별도 SHEET_NAME('Shipment Plan FG')이라 라우팅 SHEETS 에 없음(§1.D).
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'Shipment Request',
};
// Measure 레지스트리 SHEET_NAME (btnMeasure_Click 이 여는 SCM0002_TitleSetForm_Popup 대상, design 03 §0)
export const MEASURE_SHEET_NAME = 'Shipment Plan FG';
// TitleSet 저장 columnType — 'C'=컬럼(ColumnLayoutModal 내부 고정), 'M'=Measure(sales-plan/mkt-fcst 등 동일 관례)
export const TITLESET_MEASURE_TYPE = 'M';

// Bucket — cboBucketType(Daily/Weekly/Monthly). 조회 SP P_BUCKET 파라미터 값 그대로 사용(design 02/03).
export enum BUCKET_TYPE {
  DAILY = 'DAILY',
  WEEKLY = 'WEEKLY',
  MONTHLY = 'MONTHLY',
}

// Measure 코드마스터 10종 (design 03 §1.D, DB 실측). 편집가능 = SHIP_PLAN_AMEND 유일(§3.1 R-K).
export const MEASURE = {
  MKT_FCST: 'MKT_FCST',
  ALLOCATION: 'ALLOCATION',
  BALANCE: 'BALANCE',
  WH_IN_BALANCE: 'WH_IN_BALANCE',
  WH_IN: 'WH_IN',
  SHIP_REQ: 'SHIP_REQ',
  SHIP_PLAN: 'SHIP_PLAN',
  SHIP_PLAN_AMEND: 'SHIP_PLAN_AMEND',
  SHIP_PLAN_ENERGY: 'SHIP_PLAN_ENERGY',
  SHIP_PLAN_AMEND_ENERGY: 'SHIP_PLAN_AMEND_ENERGY',
} as const;
// 소수 3자리 표시 Measure(design 03 §2.2) — 나머지는 2자리
export const ENERGY_MEASURES = new Set<string>([MEASURE.SHIP_PLAN_ENERGY, MEASURE.SHIP_PLAN_AMEND_ENERGY]);

// ====================================================================================
// 조회조건 콤보 ID — design 02 §2 DB 실측 확정(SCM_ADM_CMBO_SQL_M, 2026-09-23 PASS)
// ====================================================================================
export const COMBO = {
  DIVISION: 'Division_SCP', // 무필터, EE 제외 없음 (design 02 §2.1 — GetDivisionWithoutEE 오적용 금지)
  OPERATION_GROUP: 'OperationGroup_SCP', // division 비EE
  OPERATION_GROUP_EE: 'OperationGroupEE_SCP', // division EE(EE/EE_UC)
  FROM_SITE: 'AllPlantSiteDescription_SCP', // 전량 + division/operationGroup 클라 필터(design 02 §2.3)
  TO_SITE_EE: 'ToSiteShipmentPlanFG1_SCP_ALL', // division EE* 전용(design 02 §2.4)
  TO_SITE_EE_UC: 'SaleSiteByDivision1_SCP_ALL', // division==EE_UC 전용
  // 그 외 division 은 FROM_SITE(AllPlantSiteDescription_SCP) 재사용(design 02 §2.4)
  TEAM: 'TeambyDivision', // 도메인 접미사 없음(base Data.Common 경로) — division='40' 내부 UNION 분기
  END_CUSTOMER_DEPT: 'EndCustomerByDivisionDept', // division IN (81,82) — 화면에 안 보이는 To Site 2차 재조회 입력용
  SITE_BY_END_CUSTOMER: 'SiteByEndCustomer', // division IN (81,82)
  SITE_BY_END_CUSTOMER_40: 'SiteByEndCustomer40', // 그 외
  ELECTRODE: 'LookupCommon', // lookupType=ELECTRODE_TYPE, 초기 1회만
  PLAN_DATE: 'DATE_WEEKLY1_SCP_ALL', // 전량 + division 클라 필터(design 02 §2.8)
  PLAN_TYPE: 'PlanType1_SCP_ALL', // 전량 + division+planDate 클라 필터, 최신행 자동선택
  PLAN_SEQ: 'PlanSeq1_SCP_ALL', // 전량 + division+planDate+planType 클라 필터
  BUCKET: 'BucketType', // DAILY/WEEKLY/MONTHLY (cboBucketType)
} as const;
export const ELECTRODE_LOOKUP_TYPE = 'ELECTRODE_TYPE';

// 조회조건 저장/복원 제외 대상(design 02 §4 ConditionNotUseList) — Plan Date/Type/Seq
export const CONDITION_NOT_USE_LIST = ['planStartYyyymmdd', 'planType', 'planSeq'] as const;

// AS-IS Validation MSG ID — TO-BE SCM_ADM_MSG_M 실측 역매핑 필요(design 00/02/03 §6 다수 "TO-BE 미등록").
//   design 문서가 실측을 완료하지 못한 항목은 영문 defaultValue fallback 유지(Hook #114 — 임의 매핑 금지).
export const MSG = {
  REQUIRED_FIELD: 'MSG00013', // 필수값을 입력하세요 — MSG00002 는 TO-BE 에서 "저장 성공" 문구라 공용 REQUIRED_INPUT 으로 교체
  NO_PERMISSION: 'MSG00096', // No permission.
  SAVE_NOT_ALLOWED: 'MSG01196', // This Plan can not be modified.(저장가능 판정 N — AS-IS MSG00182 는 TO-BE 미등록, 같은 문구 MSG01196 으로 대체)
  SELECT_CELL: 'MSG01153', // Select a date and enter it.(Fix/Unfix 선택 셀 없음 — AS-IS MSG00134 는 TO-BE 미등록, 같은 문구 MSG01153 으로 대체)
  UNSAVED_DATA: 'MSG01059', // There are unsaved data.(구 MSG00026 은 TO-BE "환율 정보 반영 실패" 오표시)
  NO_DELETE_DATA: 'MSG01078', // No data to delete.(구 MSG00046 은 TO-BE 미등록 — production-plan-fix 미러링)
  LOCKED_MODE: 'MSG01046', // Can not save as it is not in modify mode.(구 MSG00010 은 TO-BE "조회조건 저장됨" 오표시)
  // 구 MSG00016("삭제하시겠습니까?")은 TO-BE 에 "page not found" 로 잘못 등록돼 있어 재사용 불가(convert-core
  //   §2.3 — 신규 번역 금지, 기존 등록행만 재사용). MSG00683("삭제 하시겠습니까?"/"Do you want to delete it?")
  //   을 쓴다 — 자매 화면 production-plan-fix/SCP0025 가 동일 결함(종전 MSG01438 "Release"는 의미 재해석이라
  //   AS-IS 와 불일치)을 먼저 겪고 정정한 선례를 그대로 따른다(2026-10-13 사용자 지시).
  CONFIRM_UNFIX: 'MSG00683', // Do you want to delete it?

  CONFIRM_RESEARCH: 'MSG01273', // Do you want to re-search?(New 팝업 저장 후 재조회 확인 — AS-IS MSG00265 는 TO-BE 에서 다른 문구라 교체, 2026-10-07 조회)
  SAVE_SUCCESS: 'MSG00002', // Saved successfully.(구 MSG00004 는 TO-BE "No changes to save." 오표시 — NO_CHANGE 가 이 ID 를 쓴다)
  SAVE_FAIL: 'MSG00003', // 저장 실패 — TO-BE 실측 필요
  // MSG00084/MSG00317(AS-IS 원 코드)은 TO-BE 미등록(gap-resolve iter-1 NEW8, ora.py 실측 확정) —
  //   자매 화면 `production-plan-line`이 동일 결함을 먼저 겪고 미러링한 실등록 대체 코드를 그대로
  //   따른다(convert-core §2.3 — 신규 번역 금지, 기존 등록행 재사용만 허용).
  QTY_NEGATIVE: 'MSG00225', // Quantity must be 0 or greater.(구 MSG00084 미등록 — production-plan-line 미러링)
  QTY_MAX: 'MSG00165', // You have exceeded the number of digits you can enter.(구 MSG00317 미등록 — production-plan-line 미러링)
  PERIOD_FROM_REQUIRED: 'MSG00720', // 기간 시작일 필수 — AS-IS MSG00171 대응, 신규 채번 등록(G21b)
  PERIOD_OVER_365: 'MSG00721', // 조회기간 초과 {0}일 — AS-IS MSG00172 대응, 신규 채번 등록(G21b)
  NO_CHANGE: 'MSG00004', // 변경사항 없음(공용) — useProcMutation 표준 경로 사용 시 해당없음
  // New Plan 팝업(SCM0002_ShipmentPlanInsertPopup) — AS-IS ID 가 TO-BE 에 없거나 다른 문구라 대체한 ID(2026-10-07 SCM_ADM_MSG_M 조회).
  //   대응표: .atlas/gscm-design/SCM0002/design/00_checklist.md §4.
  SYSTEM_ERROR: 'MSG01075', // System error. Capture the screen...(AS-IS MSG00042 는 TO-BE 미등록)
  NO_ROW_SELECTED: 'MSG01104', // No rows selected.(AS-IS MSG00071 은 TO-BE 미등록)
  SELECT_FIRST: 'MSG01126', // First, select {0}.(AS-IS MSG00098 은 TO-BE 미등록)
  CONFIRM_SAVE: 'MSG00001', // Would you like to save it?(AS-IS MSG00012)
  DUPLICATE_NEW: 'MSG00428', // There are duplicate entries among the newly entered data.(AS-IS MSG00260)
  ALREADY_REGISTERED: 'MSG01271', // Production plan for this model is already registered. 뒤에 {0} 이 붙는다(AS-IS MSG00295)
  SAVED_COUNT: 'MSG00672', // {0} data saved.(AS-IS MSG00004 는 TO-BE "No changes to save." 로 다름)
} as const;

// 저장(P_SCP0009_SAVE_ANL_SHIP_PLAN_FG_WEEKLY) 값 범위(design 03 §4.3)
export const QTY_MIN = 0;
export const QTY_MAX = 99999999;

// 일자 헤더 주말 글자색 — AS-IS cs:908 (토 Blue / 일 Red). 값은 같은 도메인 waterfall-shipment-plan-fg 와 맞춘다.
export const WEEKEND_HEADER_COLOR = { SAT: '#1565c0', SUN: '#d32f2f' } as const;

// 조회기간 프리셋 주 수. AS-IS 마지막 버튼(btnWLast)은 SP `SCM0001_GET_SCP_DAILY_PLAN_PERIOD(division)`
//   결과로 라벨(`"W"+주수`)을 정하고 52 이면 숨기는데(.cs:525-531, 576), 이 SP 가 TO-BE 에 없어 AS-IS 화면 캡처
//   (Division 81)에서 확인한 82 로 고정한다. Division 별 값은 SP 배포 후 대체 필요(확인 필요).
export const PERIOD_WEEKS = { W26: 26, W52: 52, W82: 82 } as const;

// UI 라벨 — SCM_ADM_MSG_M(MSG_TP_CD='LBL') 실측 매핑. 값 = LBL 코드.
export const LBL = {
  SEARCH: 'LBL00112',
  DIVISION: 'LBL00001',
  OPERATION_GROUP: 'LBL00027',
  PLAN_DATE: 'LBL00039',
  PLAN_TYPE: 'LBL00040',
  SEQ: 'LBL00768',
  PERIOD: 'LBL00013',
  FROM_SITE: 'LBL00022',
  TO_SITE: 'LBL00023',
  TEAM: 'LBL00044',
  ELECTRODE: 'LBL00038',
  PROJECT: 'LBL00012',
  MODEL: 'LBL00618', // Model/Nickname
  BUCKET: 'LBL00710',
  ALL: 'LBL00632',
  SUM: 'LBL00687',
  COLUMN: 'LBL00309',
  MEASURE: 'LBL00310',
  FIX: 'LBL00771',
  UNFIX: 'LBL00772',
  CLOSE: 'LBL00627',
  NO: 'LBL00674',
  OK: 'LBL00716',
  SAVE: 'LBL00111',
} as const;

// 화면 전용 문구 키 — New 버튼 캡션은 AS-IS `btnNew.Text="New"`(Designer 실측, 로케일 무관 고정 영문)이라
//   LBL01028(KO='신규')을 쓰지 않는다. `_` 접두 미등록 키라 항상 defaultValue 'New' 로 뜬다.
export const SCREEN_TEXT = {
  NEW: '_shipmentPlanFg.new',
} as const;
