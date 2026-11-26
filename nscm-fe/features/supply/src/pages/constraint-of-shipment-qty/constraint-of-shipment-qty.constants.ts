export const MENU_ID = 'SCP0132' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Forms.UIL.Master SCP0132_ConstraintOfShipmentQty (단일 그리드, pivot 없음):
//   설계 근거: .atlas/gscm-design/SCP0132/design/00_checklist.md ~ 03_grid-columns.md
//   - GET SP : SCP.SCP0132_GET_CONSTRAINT_OF_SHIPMENT_QTY (10 param, 23컬럼) — TO-BE PKG_SCP0132 미배포(convert-sp 후속)
//   - SAVE SP: SCP.SCP0132_SAVE_CONSTRAINT_OF_SHIPMENT_QTY (25 param, pre-key 4종 포함)
//   - 조회조건 cascade: Division -> {PlanGroup, FromSite, ToSite, Stage, ModelGroup} 5갈래 fan-out(동시 갱신, 순차 아님)
export enum SHEETS {
  MAIN = 'main', // spdMain 단일 시트
  // 조회조건 콤보 다중커서 전용 시트 — AS-IS GetSearchInfo(SCP0132_GET_SEARCH_INFO) 1회 호출로
  //   PlanGroup/ToSite/FromSite/Stage/ModelGroup/Item 을 DataSet Tables[0]~[5] 로 받는다(.cs:174~190).
  //   자매 SCP0128 의 init 시트와 동형(SCM_ADM_MNU_BTN_MPG_M 전용 SHT_NM='init' + MNU_BTN_CD='SEARCH').
  INIT = 'init',
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = { MAIN: 'o_rc1' } as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// init(GET_SEARCH_INFO) 커서 ↔ 조회조건 콤보 매핑 — AS-IS InitControls(.cs:174~190) DataSet Tables
//   순서가 정본이다: Tables[0]=PlanGroup / [1]=ToSite / [2]=FromSite / [3]=Stage / [4]=ModelGroup /
//   [5]=Item(팝업 원천, 조회조건 콤보 아님). SCP0128 과 달리 ToSite 가 FromSite 보다 먼저 온다.
export const INIT_SET = {
  PLAN_GROUP: 'o_rc1',
  TO_SITE: 'o_rc2',
  FROM_SITE: 'o_rc3',
  STAGE: 'o_rc4',
  MODEL_GROUP: 'o_rc5',
  ITEM: 'o_rc6',
} as const;

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — 실측 PROGRAM_ID='SCP0132' 23컬럼.
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'CONSTRAINT OF SHIPMENT QTY',
};

// ====================================================================================
// 조회조건/셀 콤보 SQL_ID (design 02 §2 / 03 §1)
// ====================================================================================
// 조회조건 콤보 중 CMBO_SQL 원천은 Division/Valid 둘뿐이다. PlanGroup/ToSite/FromSite/Stage/
//   ModelGroup 은 CMBO 가 아니라 전용 SP SCP0132_GET_SEARCH_INFO(init 시트) 다중커서에서 온다
//   (INIT_SET 매핑·AS-IS .cs:174~190). 이전 회차가 설계 당시 AS-IS .cs 부재로 범용 SQL_ID
//   (PlanGroup_SCP_ALL/FromSite/ToSite/Stage/ModelGroup)를 잠정 배선했으나, AS-IS 원문 확보로
//   전용 SP 다중커서가 정본임이 확정돼 제거했다(2026-10-13).
export const COMBO = {
  // Division_SCP = 사용자 권한 조인 + "코드 이름" 표시(design 02 §2.1, AS-IS BLUtils.GetDivision).
  DIVISION: 'Division_SCP',
  // Valid — 파라미터 없는 정적 Y/N 2행(design 02 §2.2, AS-IS Data.Type.YesOrNo 와 1:1).
  VALID: 'YesOrNo',
} as const;

// AS-IS Validation MSG(design 03 §3.1).
export const MSG = {
  // 필수값 일괄체크(8개 OR). AS-IS .cs:678 은 GMessageBox("MSG00001")("모든 항목은 필수입력입니다")였으나
  //   TO-BE DB 에서 MSG00001 은 "저장 하시겠습니까?"(공통 SAVE_CONFIRM)로 재정의돼 의미가 다르다 —
  //   그대로 쓰면 필수값 Alert 에 "저장 하시겠습니까?" 가 떴다(2026-10-14 실측·교정). TO-BE 필수값
  //   메시지는 MSG00013("필수 입력란을 입력해 주세요 / Please enter the required fields.", KO/EN/CN USE_YN=Y).
  REQUIRED_FIELDS: 'MSG00013',
  MIN_MAX_INVALID: 'MSG00099', // 등록됨(KO/EN/CN USE_YN=Y, DB 실측 2026-10-14) — "{0}은 {1} 보다 클 수 없습니다." ({0}=MIN타이틀,{1}=MAX타이틀)
  MIN_MAX_BOTH_EMPTY: 'MSG00022', // "{0} 와 {1} 둘 중에 하나는 필수 입력입니다." ({0}=MIN,{1}=MAX, AS-IS .cs:735)
  PERIOD_INVALID: 'MSG00219', // 등록됨(EN 본문 공백) — "The start date can not be later than the end date." fallback
  ITEM_NOT_EXIST: 'MSG00458', // "MODEL: {0} 유효하지 않은 모델입니다!" (AS-IS .cs:757)
  QTY_NOT_INTEGER: 'MSG00460', // "정수값만 입력가능합니다!" — 수량 칸 원장 NUMBER(18,0), AS-IS 정수 변환 실패로 저장 중단
  DATE_INVALID: 'MSG01081', // "유효한 날짜 형식이 아닙니다. {0}" — AS-IS MSG00046 과 같은 문구(TO-BE MSG00046 은 다른 뜻)
  PERIOD_DATE_INVALID: 'MSG00611', // "유효한 날짜 형식이 아닙니다. (YYYYMMDD)" — 조회조건 Period 없는 날짜
  SAVE_SUCCESS: 'MSG00672', // 공통 규약 — "{0} data saved."
  NO_CHANGE: 'MSG00004', // 공통 규약 — "No changes to save."
  REQUIRED_SELECT: 'MSG01122', // 공통 규약 — "Select {0}."
} as const;

// 다국어 LABEL(design 02 §4.5).
export const LBL = {
  DIVISION: 'LBL00001',
  PLAN_GROUP: 'LBL00002',
  FROM_SITE: 'LBL00022',
  TO_SITE: 'LBL00023',
  // Item Group — 사용자 지시(2026-11-05) 조회조건 명칭 "Model Group" -> "Item Group" 변경(다국어).
  //   기등록 LBL00063("Item Group", KO/EN/CN USE_YN=Y)로 교체. LBL01092("Model Group")는 의미가
  //   달라 재사용/덮어쓰기 금지(messaging-i18n MSG-06). 라벨 표기만 바뀌며 backing 데이터는
  //   모델그룹(MDL_GR_NM)/INIT_SET.MODEL_GROUP cascade 그대로다.
  ITEM_GROUP: 'LBL00063',
  STAGE: 'LBL00061',
  // Valid — AS-IS lblValid "Active"(사용자 지정 LBL00007). 이전 LBL00639("Valid")에서 교체.
  VALID: 'LBL00007',
  // Item ID — 표준 라벨은 Model/Nickname(LBL00618)이나, 이 화면은 조회 내용에 Nickname 이 없어
  //   "Model"(LBL00669, KO/EN/CN 등록)로 표기한다. 고객 테스트 요청(2026-11-23) 표준화 예외처리.
  ITEM_ID: 'LBL00669',
  // Period — AS-IS lblPeriod "Period*"(UsrDateRangePicker3 단일 컨트롤). From Date/To Date 2분할이
  //   아니라 하나의 기간 범위다(.Designer.cs:520~527 lblPeriod + dCalendar UsrDateRangePicker3).
  //   라벨값은 사용자 지정 LBL00013("Period"). 이전 LBL00062 에서 교체.
  PERIOD: 'LBL00013',
  // 조회 버튼 — "Search(F5)"(사용자 지정 LBL00112). SearchArea 기본 라벨('조회') 대체.
  SEARCH: 'LBL00112',
} as const;

// Valid(cboValid) 조회조건 기본값 — AS-IS cboValid.DataBind(Data.Type.YesOrNo, true)(.cs:171)로
//   콤보가 [ALL, Y, N] 3행이고 기본 선택이 ALL 이다. CustomDropdown 단일 allOption 은 value==='ALL'
//   일 때만 ALL 항목이 선택 표시되므로(CustomDropdown L369) 초기값도 'ALL' 센티널로 둔다.
//   조회 시 ALL → 빈 문자열 변환은 store setFilter 가 담당(AS-IS .cs:452 pValidYn = Equals("ALL")?"":...).
export const VALID_DEFAULT = 'ALL';

// 저장 전 필수 8컬럼(design 03 §1/§4 validations#2 MSG00001 원문 8개 OR 조건). STAGE/MDL_GR_NM 은
//   그리드 라벨상 '*' 이나 이 조건식에는 없음(design 03 §6#5 확인 필요) — 라벨 표기를 임의로
//   정정하지 않고 원문 8개만 검증 대상으로 둔다.
export const REQUIRED_COLUMNS = [
  'DIVISION_ID',
  'OPMZ_PLAN_GR_ID',
  'FROM_STE_ID',
  'ITEM_ID',
  'TO_STE_ID',
  'FROM_YYYYMMDD',
  'TO_YYYYMMDD',
  'VALID_YN',
] as const;

// 칸 제목에 * 가 있지만 AS-IS 저장 검사의 공백 대상이 아닌 칸(갭분석 C-25). 공용 저장 검사가 * 를 필수로
//   판정하므로 넘기는 칸 목록에서 뺀다. Min·Max 는 둘 중 하나만 필수(MSG00022), Stage·Item Group 은 검사 없음(.cs:678).
export const NOT_REQUIRED_ON_SAVE_COLUMNS = [
  'MDL_GR_NM',
  'STAGE',
  'SIPM_MIN_QYT',
  'SIPM_MAX_QTY',
] as const;

// 조회직후/EditButton 미해제 상태에서도 편집 가능한 컬럼(design 03 §1 — DIVISION_ID·VAL_TP_CD~
//   PRE_KEY_VALUES 제외 나머지 전부, §1 각주). PRE_KEY_VALUES 는 COLUMN_WIDTH=0(비노출)이라
//   편집가능 목록 판단에서 실질적 의미 없음 — 항상잠금 목록에만 포함한다.
export const EDITABLE_COLUMNS = [
  'OPMZ_PLAN_GR_ID',
  'MDL_GR_NM',
  'ITEM_ID',
  'STAGE',
  'FROM_STE_ID',
  'TO_STE_ID',
  'FROM_YYYYMMDD',
  'TO_YYYYMMDD',
  'SIPM_MIN_QYT',
  'SIPM_MAX_QTY',
  'SAT_SIPM_MIN_QTY',
  'SAT_SIPM_MAX_QTY',
  'SUN_SIPM_MIN_QTY',
  'SUN_SIPM_MAX_QTY',
  'VALUE_DESCRIPTION',
  'VALID_YN',
] as const;

// 신규행/조회직후 공통 항상 잠금 — DIVISION_ID + VAL_TP_CD~PRE_KEY_VALUES 구간(design 03 §1 #1,#18~23).
export const ALWAYS_LOCKED_COLUMNS = [
  'DIVISION_ID',
  'VAL_TP_CD',
  'CREATED_BY',
  'CREATION_DATE',
  'LAST_UPDATED_BY',
  'LAST_UPDATE_DATE',
  'PRE_KEY_VALUES',
] as const;

// 신규행 잠금 범위(design 03 §1 #23 각주) — PRE_KEY_VALUES 는 신규행 잠금범위에서 제외(코드상
//   확인된 비대칭, 의도 여부는 확인 필요). 편집화면엔 COLUMN_WIDTH=0 이라 노출되지 않는다.
export const NEW_ROW_LOCKED_COLUMNS = [
  'DIVISION_ID',
  'VAL_TP_CD',
  'CREATED_BY',
  'CREATION_DATE',
  'LAST_UPDATED_BY',
  'LAST_UPDATE_DATE',
] as const;
