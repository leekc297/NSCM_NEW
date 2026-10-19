export const MENU_ID = 'SCP0124' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  MAIN = 'main',
}

export enum RESPONSE_SET {
  MAIN = 'o_rc1',
}

/**
 * 조회조건 콤보 SQL_ID — 01_layout.md/02_search-combo.md 실측 확정분만 배선한다.
 *
 * DIVISION: AS-IS `BLUtils.GetDivision(false, "")` 의 최종 SQL_ID 를 소스 미확보로 확정하지
 *   못했다(Division/MyDivision/Division_SCP 3후보, 02_search-combo.md §2.1). 인자 시그니처
 *   `(isAddAll=false, filterText="")`가 가장 근접한 `Division`(공통, @param1 단일 파라미터)을
 *   잠정 채택한다 — 확인 필요(소스 재확인 시 교체 대상, 02_search-combo.md §7-1).
 * PLAN_GROUP: `PlanGroup_SCP_ALL`(유력 후보, DB 실측 — DIVISION_ID 를 SELECT 절에 내려주는
 *   전량조회형이라 §3 cascade 필터 방식과 정합). 실제 호출부(C#)는 미확인(§7-3).
 * ACTIVITY_CODE/PROCESS_CODE: `Data_SCP.CommonAll(ActivityCode)`/`Data.Common(LookupCommon,
 *   OPMZ_PRS_CD)` 실측 확정(02_search-combo.md §2.2).
 * PLANT: 공급 SQL_ID 미확정 — comboCalls/filterCalls 어디에도 공급 호출이 없고(§2.3),
 *   `Plant*By*` 54건 중 `PlantId` 정확 일치가 없다(변수명 `dtPlantIdAll`만으로 단정 시
 *   convert-core §2.6 이름-매칭 함정 재현). 배선하지 않는다 — 확인 필요.
 */
export const PLAN_GROUP_DASHBOARD_COMBO_ID = {
  DIVISION: 'Division',
  PLAN_GROUP: 'PlanGroup_SCP_ALL',
  ACTIVITY_CODE: 'ActivityCode_SCP_ALL',
} as const;

/** LookupCommon 콤보 고정 파라미터 — OPMZ_PRS_CD(SCP 공정 프로세스), 02_search-combo.md §2.2. */
export const PROCESS_CODE_LOOKUP_TYPE = 'OPMZ_PRS_CD';

/**
 * cboCompleted — comboCalls/filterCalls 어디에도 공급 호출이 없어(02_search-combo.md §2.3)
 * DB 콤보가 아니라 Y/N 리터럴로 잠정 판정한다(AS-IS 소스 미확보로 확정은 아님 — 확인 필요).
 */
export const COMPLETED_YN_OPTIONS = [
  { label: 'Y', value: 'Y' },
  { label: 'N', value: 'N' },
] as const;

export const PLAN_GROUP_DASHBOARD_COLUMN = {
  PLAN_START_YYYYMMDD: 'PLAN_START_YYYYMMDD',
  DIVISION_ID: 'DIVISION_ID',
  OPMZ_PRS_CD: 'OPMZ_PRS_CD',
  OPMZ_PLAN_GR_ID: 'OPMZ_PLAN_GR_ID',
  OPMZ_PLAN_GR_NAME: 'OPMZ_PLAN_GR_NAME',
  OWNER: 'OWNER',
  COMPLETED_YN: 'COMPLETED_YN',
  FP_TARGET_YN: 'FP_TARGET_YN',
  OPMZ_ACTV_CD: 'OPMZ_ACTV_CD',
  OPMZ_ACTV_NAME: 'OPMZ_ACTV_NAME',
  OPMZ_PLAN_ID: 'OPMZ_PLAN_ID',
  LAST_UPDATED_BY: 'LAST_UPDATED_BY',
  LAST_UPDATE_DATE: 'LAST_UPDATE_DATE',
} as const;
