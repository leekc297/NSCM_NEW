// 조회조건/셀 콤보 SQL_ID 카탈로그(전건 SCM_ADM_CMBO_SQL_M 등록·USE_YN=Y 실측, design 03 §1.5).
//   셀 콤보 후보는 admin 컬럼 메타(CELL_COMBO_DATA_TYPE)가 단일 원천이라 FE 하드코딩하지 않는다.
//   여기 상수는 조회조건 콤보(useTabComboQueries)와 저장 후 무효화 대상만 둔다.
export const COMBO = {
  DIVISION: 'Division_SCP', // 조회 Division(+FE EE 필터). site.DIVISION_ID 셀은 메타 Division_SCP_NoEE(05_register [5])
  YES_OR_NO: 'YesOrNo', // 조회 OSP·Active / 다수 셀
  LOOKUP_COMMON: 'LookupCommon', // @lookupType 바인드 — 신규행 기본값 DEFAULT_PERIOD 조회(R-07)
} as const;

// site 신규행 SHIP/PROD_FROZEN 기본값 원천 lookup(AS-IS dtPlanPeriod, cs:56·1439~1452).
export const DEFAULT_PERIOD_LOOKUP_TYPE = 'DEFAULT_PERIOD';

// 저장 성공 직후 다시 받아야 할 콤보. site 마스터가 원천인 콤보(plant/site 후보)를 넣는다.
//   MDI keep-alive 라 리마운트 재조회가 없어 명시 무효화가 필요하다(nscm-patterns §3.3).
export const PLANT_SITE_STALE_COMBO_IDS = [
  'PlantByDivision1_SCP_ALL',
  'StorageByDivPlant_SCP',
  'Location',
  'BuildingByPlant',
  'OperationByBuilding',
  'StorageID',
  'SaleSiteByDivision',
  'LINK_PLANT_SITE_CODE_SCP_ALL',
] as const;
