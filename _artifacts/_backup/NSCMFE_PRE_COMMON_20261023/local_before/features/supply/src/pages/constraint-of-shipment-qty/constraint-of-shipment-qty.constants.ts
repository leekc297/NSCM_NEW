export const MENU_ID = 'SCP0132' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Forms.UIL.Master SCP0132_ConstraintOfShipmentQty (단일 그리드, pivot 없음):
//   설계 근거: .atlas/gscm-design/SCP0132/design/00_checklist.md ~ 03_grid-columns.md
//   - GET SP : SCP.SCP0132_GET_CONSTRAINT_OF_SHIPMENT_QTY (10 param, 23컬럼) — TO-BE PKG_SCP0132 미배포(convert-sp 후속)
//   - SAVE SP: SCP.SCP0132_SAVE_CONSTRAINT_OF_SHIPMENT_QTY (25 param, pre-key 4종 포함)
//   - 조회조건 cascade: Division -> {PlanGroup, FromSite, ToSite, Stage, ModelGroup} 5갈래 fan-out(동시 갱신, 순차 아님)
export enum SHEETS {
  MAIN = 'main', // spdMain 단일 시트
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = { MAIN: 'o_rc1' } as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — 실측 PROGRAM_ID='SCP0132' 23컬럼.
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'CONSTRAINT OF SHIPMENT QTY',
};

// ====================================================================================
// 조회조건/셀 콤보 SQL_ID (design 02 §2 / 03 §1)
// ====================================================================================
export const COMBO = {
  // Division_SCP = 사용자 권한 조인 + "코드 이름" 표시(design 02 §2.1) — AS-IS BLUtils.GetDivision
  //   본문 미확보로 1·2·4층(convert-core §2.6) 확인 필요. 자매 SCP0131 이 채택한 것과 동일 후보.
  DIVISION: 'Division_SCP',
  // Plan Group — TO-BE 유일 등록 후보(division 파라미터 바인드 없음, 전건 반환). AS-IS 공급원
  //   자체가 확인 필요(design 02 §2.3)라 이 후보를 division 클라 필터와 함께 잠정 배선한다.
  PLAN_GROUP: 'PlanGroup_SCP_ALL',
  // Valid — 파라미터 없는 정적 Y/N 2행(design 02 §2.2, 확정 재사용 가능).
  VALID: 'YesOrNo',
  // From Site/To Site/Stage/Model Group — design 02 §2.3 실측 결과 TO-BE 미배포(SQL_ID 자체 없음,
  //   From/To Site 는 이름 유사 후보 있으나 화이트리스트 미재현이라 재사용 금지 잠정). 아래 4개는
  //   그리드 셀 콤보 CELL_COMBO_DATA_TYPE 명칭과 동일하게 맞춰둔 자리표시자 — 05_register.sql 로
  //   등록을 시도하되 AS-IS 원천 SQL 미확보로 등록 보류, 등록 전까지 이 조건은 빈 옵션으로 렌더된다
  //   (확인 필요, 03_grid-columns.md §6-3).
  FROM_SITE: 'FromSite',
  TO_SITE: 'ToSite',
  STAGE: 'Stage',
  MODEL_GROUP: 'ModelGroup',
} as const;

// From/To Site 화이트리스트(design 02 §2.3/§3) — AS-IS 리터럴 DIVISION_ID IN ('81','40','82').
//   TO-BE 후보 콤보(FromSiteByDivision_SCP 등)는 전부 @divisionId 재조회형이라 이 리터럴을
//   포함하지 않는다(재사용 금지 잠정) — 신규 콤보 미등록 상태이므로 이 화면은 해당 사업부 소속
//   사이트 후보를 마스터에서 직접 가져올 방법이 없다. §확인 필요: convert-sp/신규 콤보 등록 후
//   FromSite/ToSite 후보 목록 자체를 채울 데이터소스가 없어 이번 회차엔 빈 옵션으로 남긴다.
export const SITE_BASE_DIVISIONS = ['81', '40', '82'] as const;

// Stage/Model Group — TO-BE 미배포(design 02 §2.3 §2.6) — 신규 콤보 등록 대상.
//   이번 회차는 등록을 시도하되(05_register.sql), 실 데이터 원천(AS-IS 조회 SQL 본문) 미확보로
//   등록 SQL 자체가 잠정(추측 금지 원칙상 실행 보류) — 화면은 빈 옵션으로 렌더된다(확인 필요).

// AS-IS Validation MSG(design 03 §3.1). TO-BE 미등록 3종(MSG00099/046/022)은 등록 전까지
//   defaultValue 영문 fallback 만 표시한다(convert-core §4.1 — 임의 코드 재사용 금지).
export const MSG = {
  REQUIRED_FIELDS: 'MSG00001', // 등록됨(KO/EN/CN) — AS-IS 동일 msgId, 8개 필수값 일괄체크
  MIN_MAX_INVALID: 'MSG00099', // 미등록 — "Min qty can not be greater than Max qty." fallback (AS-IS MSG00099)
  MIN_MAX_BOTH_EMPTY: 'MSG00022', // 미등록 — "Please enter Min qty or Max qty." fallback (AS-IS MSG00022)
  PERIOD_INVALID: 'MSG00219', // 등록됨(EN 본문 공백) — "The start date can not be later than the end date." fallback
  ITEM_NOT_EXIST: 'MSG00458', // 등록됨 — "MODEL: {0} \nInvalid MODEL Code!"
  SAVE_SUCCESS: 'MSG00672', // 공통 규약 — "{0} data saved."
  NO_CHANGE: 'MSG00004', // 공통 규약 — "No changes to save."
  REQUIRED_SELECT: 'MSG01122', // 공통 규약 — "Select {0}."
  // Sales Site Priority(AS-IS MSG00046) — 대상 컬럼·조건 확인 필요(design 03 §3.1 #3). 미구현.
} as const;

// 다국어 LABEL(design 02 §4.5). To Date/Item ID 는 미등록 — defaultValue 로만 표기.
export const LBL = {
  DIVISION: 'LBL00001',
  PLAN_GROUP: 'LBL00002',
  FROM_SITE: 'LBL00022',
  TO_SITE: 'LBL00023',
  MODEL_GROUP: 'LBL01092',
  STAGE: 'LBL00061',
  VALID: 'LBL00639',
  FROM_DATE: 'LBL00062',
} as const;

// Valid(cboValid) 기본값 — 필수값 8종에 포함(design 03 §3.1 #2).
export const VALID_DEFAULT = '';

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
