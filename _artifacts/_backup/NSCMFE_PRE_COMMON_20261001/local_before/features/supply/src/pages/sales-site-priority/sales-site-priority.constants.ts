export const MENU_ID = 'SCP0131' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Master.UIL SCP0131_SalesSitePriority (단일 그리드 마스터 CRUD, pivot 없음):
//   설계 근거: .atlas/gscm-design/SCP0131/design/00_checklist.md ~ 03_grid-columns.md
//   - GET SP : SCP.SCP0131_GET_SALES_SITE_PRIORITY (7 param, 14컬럼) — TO-BE PKG_SCP0131 미배포(convert-sp 후속)
//   - SAVE SP: SCP.SCP0131_SAVE_SALES_SITE_PRIORITY (18 param, pre-key 7종 포함)
//   - 저장 전 재조회 SP: SCP.SCP0128_GET_SEARCH_INFO(SCP0128 소유, 재사용) — TO-BE PKG_SCP0128 미배포
//   - 조회조건 cascade: Division -> {PlanGroup, Site} 2-way 클라 필터(재조회 없음, design 02 §3)
export enum SHEETS {
  MAIN = 'main', // spdMain 단일 시트
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = { MAIN: 'o_rc1' } as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — 실측 PROGRAM_ID='SCP0131' 14컬럼.
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'Sales Site Priority',
};

// ====================================================================================
// 조회조건/셀 콤보 SQL_ID (design 02 §2 / 03 §1)
// ====================================================================================
export const COMBO = {
  // Division_SCP = UP_FX_GetCommonDataList_SCP @Code='Division'(권한필터). EE 제외 클라 필터 없음
  //   (AS-IS comboCalls#1 code=false — GetDivisionWithoutEE 아님, design 02 §2-1 확정).
  DIVISION: 'Division_SCP',
  // PlanGroup — 2026-09-26 재확인 시 신규 등록 확인됨(design 시점엔 미등록). DIVISION_ID 반환 —
  //   필터 방식(PARAM10 미지정)과 부합. 화면 전용 division 클라 필터(design 02 §2-2)는 FE 재현.
  PLAN_GROUP: 'PlanGroup',
  // ScmSite/ValidYn 메타 리터럴은 SCM_ADM_CMBO_SQL_M 미등록(확인 필요, design 03 §1.1) —
  //   convert-react 세션 재확인(2026-09-26)도 0 rows. 후보로 등록된 SiteMasterAll_SCP/YesOrNo 를
  //   의미 대조(convert-core §2.6) 후 잠정 배선한다(§ 확인 필요, __asis-mapping__.md 명시).
  SITE: 'SiteMasterAll_SCP',
  VALID: 'YesOrNo',
} as const;

// Site 콤보(SiteMasterAll_SCP) 필수 파라미터 — @siteType. AS-IS 원문 미확보로 화면코드값 확정 불가
//   (확인 필요) — 관대형 게이트가 아니라 정확 매칭 파라미터라 빈 문자열이면 0행이 된다.
//   design 03 §1.1 후보 SQL 실측 기준 'SALES'(화면명 Sales Site Priority)로 잠정 지정, 확인 필요.
export const SITE_TYPE = 'SALES';

// AS-IS Validation MSG (design 00 §4a). AS-IS 번호 그대로 쓰지 않는다 — 문구 기준 SCM_ADM_MSG_M
//   역조회 TO-BE 코드(hook #114). 실측(2026-09-26, LANG_CD EN) — 전건 아래 매핑으로 확인.
export const MSG = {
  REQUIRED_FIELDS: 'MSG00013', // "Please enter the required fields." (AS-IS MSG00001 필수값 8종)
  SAVE_CONFIRM: 'MSG00001', // "Would you like to save it?" (AS-IS MSG00046 저장 확인)
  PERIOD_INVALID: 'MSG01135', // "The start date can not be later than the end date." (AS-IS MSG00219 From>To)
  PRIO_MIN: 'MSG00699', // "Please enter an integer greater than 0." (AS-IS MSG00175 PRIO_RANK<1)
  ITEM_NOT_EXIST: 'MSG01366', // "ITEM_ID does not exist." (AS-IS MSG00458 item 유효성)
  SAVE_SUCCESS: 'MSG00672', // "{0} data saved." (AS-IS MSG00004 저장 성공 건수)
  NO_CHANGE: 'MSG00004', // "No changes to save." (저장 대상 0건 — 공통 규약, AS-IS 대응 없음)
  REQUIRED_SELECT: 'MSG01122', // "Select {0}." (Division 등 조회조건 필수 — 공통 규약)
  // 안전재고 경고(AS-IS MSG00260) — 문구 일치 TO-BE 코드 미확인(확인 필요, __asis-mapping__.md 명시).
  //   영문 defaultValue fallback 만 쓴다(hook #114 등가 없음 처리).
} as const;

// 다국어 LABEL (design 02 §4.5 — 5건 존재 확인, Item ID 1건 신규 필요).
export const LBL = {
  DIVISION: 'LBL00641',
  PLAN_GROUP: 'LBL00002',
  SITE: 'LBL00015',
  PERIOD: 'LBL00013',
  VALID: 'LBL00639',
  SEARCH: 'LBL00664',
  // Item ID — SCM_ADM_MSG_M 미등록(design 02 §4.5 확인 필요). 등록 전까지 defaultValue 로만 표기.
} as const;

// Valid(cboValid) 조회조건 — AS-IS 는 필수값(MSG00001 대상), ALL 센티널 없음(design 02 §2-4).
export const VALID_DEFAULT = 'Y';

// 필수 컬럼 라벨 '*' 7칸(design 03 §1) — DIVISION_ID 는 항상잠금이라 편집화면에서 검증 대상 아님.
//   VALID_YN 은 validations#1 이 필수로 검사하나 라벨 '*' 없음(§1 불일치 — design 03 §6#8) —
//   화면 커스텀 검증(useSalesSitePriorityValidation)에서만 별도로 포함하고, 메타 기반
//   useSaveWithValidation 필수판정 대상에는 넣지 않는다(라벨 불일치를 임의로 정정하지 않음).
export const REQUIRED_COLUMNS = [
  'DIVISION_ID',
  'OPMZ_PLAN_GR_ID',
  'SCM_SITE_ID',
  'ITEM_ID',
  'PRIO_RANK',
  'FROM_YYYYMMDD',
  'TO_YYYYMMDD',
] as const;

// 신규행/기존행(Edit 모드) 공통 편집 가능 컬럼 8칸(design 03 §3.1) — DIVISION_ID·감사4칸·
//   PRE_KEY_VALUES 제외.
export const EDITABLE_COLUMNS = [
  'OPMZ_PLAN_GR_ID',
  'SCM_SITE_ID',
  'ITEM_ID',
  'PRIO_RANK',
  'FROM_YYYYMMDD',
  'TO_YYYYMMDD',
  'VALUE_DESCRIPTION',
  'VALID_YN',
] as const;

// 항상 잠금 컬럼(신규행 포함) — DIVISION_ID + 감사4칸(design 03 §3.1 LockColumn/LockRange).
export const ALWAYS_LOCKED_COLUMNS = [
  'DIVISION_ID',
  'CREATED_BY',
  'CREATION_DATE',
  'LAST_UPDATED_BY',
  'LAST_UPDATE_DATE',
] as const;
