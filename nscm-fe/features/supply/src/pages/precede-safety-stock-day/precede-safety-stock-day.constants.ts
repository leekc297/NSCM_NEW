export const MENU_ID = 'SCP0127' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  MAIN = 'main',
  // 조회조건 콤보 다중커서 전용 시트 — SCM_ADM_MNU_BTN_MPG_M(SCP0127, init, SEARCH) 등록(2026-10-11).
  //   자매 SCP0128 의 init 시트와 동형. Site(o_rc2)/Type(o_rc4) 원천.
  INIT = 'init',
}

export enum RESPONSE_SET {
  MAIN = 'o_rc1',
}

// init(GET_SEARCH_INFO) 커서 ↔ 조회조건 콤보 매핑 — PKG_SCP0127 BODY OPEN O_RCn FOR 실측(L35~128).
//   FE 는 Site(o_rc2)/Stage(o_rc3)/Type(o_rc4) 소비(PlanGroup·Item·Valid=기존 배선 유지).
//   Stage 는 o_rc3(OPMZ_STAGE_CD: SEGMENT1=DIVISION_ID/SEGMENT3=CODE/ATTRIBUTE1=NAME)로 교정 —
//   기존 useTabLookupQueries 는 DIVISION_ID 컬럼이 없어 cascade 필터가 무력화돼 빈 콤보였다.
export const INIT_SET = {
  SITE: 'o_rc2',
  STAGE: 'o_rc3',
  TYPE: 'o_rc4',
} as const;

/**
 * 조회조건 콤보 SQL_ID — design/02_search-combo.md §2·§5 실측 확정분만 배선한다.
 *
 * DIVISION: AS-IS `BLUtils.GetDivision(false, "")` 의 정본 SQL_ID 를 소스 미확보로 확정하지
 *   못했다(Division_SCP 유력 후보, §2-1). SCP0124 선례와 동일하게 인자 시그니처가 가장 근접한
 *   `Division_SCP`(DB 실측 등록 확인)을 채택한다 — 확인 필요(원문 재확인 시 교체 대상).
 * PLAN_GROUP: `PlanGroup_SCP_ALL`(유력 후보, DB 실측 등록 확인 — DIVISION_ID 를 SELECT 절에
 *   내려주는 전량조회형이라 §3 cascade 필터 방식과 정합). 실제 호출부(C#)는 미확인(§7).
 * STAGE: init o_rc3(`OPMZ_STAGE_CD`: SEGMENT1=DIVISION_ID/SEGMENT3=CODE/ATTRIBUTE1=NAME, §2-4) —
 *   AS-IS dtStageAll(GetSearchInfo Table[2]) 재현. 선택 Division cascade(DIVISION_ID=division 원값).
 *   기존 useTabLookupQueries 는 DIVISION_ID 컬럼이 없어 cascade 가 무력화돼 빈 콤보였다 → o_rc3 로 교정.
 * VALID: `YesOrNo`(고정 Y/N, §2-6 best-evidence, DB 실측 등록 확인).
 * SITE/STAGE/TYPE: CMBO_SQL 원천이 아니라 전용 SP `PKG_SCP0127.P_SCP0127_GET_SEARCH_INFO`(init 시트)의
 *   다중커서(o_rc2/o_rc3/o_rc4)에서 온다 — `useTabProcQuery({sheetName:'init'})`. 설계 02_search-combo.md
 *   §2-3/§2-5 가 "공급원 미확정"으로 남겼던 것은 AS-IS 소스 미확보 세션의 best-evidence 였고,
 *   DB 실측(2026-10-11)으로 PKG_SCP0127 이 VALID 배포돼 있으며 GET_SEARCH_INFO 가 Site(o_rc2
 *   =SCM_MST_SITE)·Type(o_rc4=COVER_DAY_TYPE MAX/MIN) 커서를 실제로 연다는 것이 확인됐다(자매
 *   SCP0128 과 동형). Site 는 AS-IS RefreshSiteByDivision(SCP0127.cs:262) 을 FE 클라 필터로 재현한다
 *   — EE → DIVISION_ID IN('81','40','82'), EE_* → 81_* 매핑, 그 외 → = division(util matchSiteByDivision).
 */
export const SEARCH_COMBO_ID = {
  DIVISION: 'Division_SCP',
  PLAN_GROUP: 'PlanGroup_SCP_ALL',
  VALID: 'YesOrNo',
} as const;

export const PRECEDE_SAFETY_STOCK_DAY_COLUMN = {
  VALUE_TYPE: 'VALUE_TYPE',
  DIVISION_ID: 'DIVISION_ID',
  OPMZ_PLAN_GR_NAME: 'OPMZ_PLAN_GR_NAME',
  OPMZ_PLAN_GR_ID: 'OPMZ_PLAN_GR_ID',
  SCM_SITE_ID: 'SCM_SITE_ID',
  ITEM_ID: 'ITEM_ID',
  STAGE: 'STAGE',
  FROM_YYYYMMDD: 'FROM_YYYYMMDD',
  TO_YYYYMMDD: 'TO_YYYYMMDD',
  TYPE_APPLY_DAY: 'TYPE_APPLY_DAY',
  VALUE_DESCRIPTION: 'VALUE_DESCRIPTION',
  VALID_YN: 'VALID_YN',
  CREATED_BY: 'CREATED_BY',
  CREATION_DATE: 'CREATION_DATE',
  LAST_UPDATED_BY: 'LAST_UPDATED_BY',
  LAST_UPDATE_DATE: 'LAST_UPDATE_DATE',
  PRE_KEY_VALUES: 'PRE_KEY_VALUES',
} as const;

/**
 * 신규행(insCell) 잠금 범위 — LockRange(DIVISION_ID:DIVISION_ID) + LockRange(CREATED_BY:
 * LAST_UPDATE_DATE)(00_checklist.md §3 gridSignals#10·11). 나머지 10칼럼은 편집가능.
 * PRE_KEY_VALUES 는 이 range 표기에서 제외돼 있으나(§3b 확인 필요) COLUMN_WIDTH=0 으로 화면
 * 비노출이라 실질 영향 없음 — DataGrid 는 admin `INPUT_TP_CD='S'`(전 17칼럼, §1 실측)를 그대로
 * 따르므로 신규행 편집가능 판정은 이 화면이 로컬에서 재현해야 한다(§4.4 커스텀 로직 필요).
 */
export const NEW_ROW_LOCKED_COLUMNS = [
  PRECEDE_SAFETY_STOCK_DAY_COLUMN.DIVISION_ID,
  PRECEDE_SAFETY_STOCK_DAY_COLUMN.CREATED_BY,
  PRECEDE_SAFETY_STOCK_DAY_COLUMN.CREATION_DATE,
  PRECEDE_SAFETY_STOCK_DAY_COLUMN.LAST_UPDATED_BY,
  PRECEDE_SAFETY_STOCK_DAY_COLUMN.LAST_UPDATE_DATE,
] as const;

// AS-IS validation.md 상당(00_checklist.md §3b, 13건 전량 SaveData 소속) MSG ID 매핑.
// G-02(iter-2 gap-resolve): REQUIRED_FIELDS 는 AS-IS "필수값 누락" 의도인데 MSG00001 은
// DB 실측(SCM_ADM_MSG_M, EN) "Would you like to save it?"(저장 확인 문구)라 오매핑이었다.
// 문구가 일치하는 MSG00013("Please enter the required fields.")로 교체(hook #114).
// NO_CHANGE_SAVE 는 실측상 MSG00004="No changes to save."인데 기존 키명이 SAVE_FAIL 로
// 잘못 라벨링돼 있었다(코드 참조 0건 확인, 의미상 미사용 상태) — 명칭만 정정, 값은 동일.
// 화면 라벨 코드(SCM_ADM_MSG_M MSG_TP_CD='LBL' DB 실측 확정). t(LBL.KEY, '_Fallback') 으로 배선.
export const LBL = {
  SEARCH: 'LBL00112',
  DIVISION: 'LBL00001',
  SITE: 'LBL00016', // "SCM Site" — 자매 SCP0128 동일 필드(p_scm_site_id) 확정값(§4.5 2후보 중 SCM Site)
  TYPE: 'LBL00052', // "Type" — §2-5 단일 확정
  PLAN_GROUP: 'LBL00002',
  STAGE: 'LBL00061',
  PERIOD: 'LBL00013',
  ITEM: 'LBL00618', // "Model/Nickname" — 자매 SCP0128 과 동일(사용자 지시 2026-10-11, 설계 §1 "Item" 불채택)
  VALID: 'LBL00007', // "Active" — 자매 SCP0128 과 동일(사용자 지시 2026-10-11, 설계 §1 "Valid" 불채택)
} as const;

export const MSG = {
  REQUIRED_FIELDS: 'MSG00013',
  DUPLICATE_EXISTS: 'MSG00260',
  NO_WORK_DATE: 'MSG00046',
  DATE_RANGE_INVALID: 'MSG00219',
  TYPE_APPLY_DAY_NEGATIVE: 'MSG00085',
  ITEM_NOT_FOUND: 'MSG00458',
  NO_CHANGE_SAVE: 'MSG00004',
  NO_CHANGE: 'MSG_NO_CHANGE',
} as const;
