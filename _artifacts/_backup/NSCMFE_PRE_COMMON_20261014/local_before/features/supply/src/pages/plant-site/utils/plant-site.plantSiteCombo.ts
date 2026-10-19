// 조회조건/셀 콤보 SQL_ID 카탈로그(전건 SCM_ADM_CMBO_SQL_M 등록·USE_YN=Y 실측, design 03 §1.5).
//   셀 콤보 후보는 admin 컬럼 메타(CELL_COMBO_DATA_TYPE)가 단일 원천이라 FE 하드코딩하지 않는다.
//   여기 상수는 조회조건 콤보(useTabComboQueries)와 저장 후 무효화 대상만 둔다.
export const COMBO = {
  DIVISION: 'Division_SCP', // 조회 Division(+FE EE 필터). site.DIVISION_ID 셀은 메타 Division_SCP_NoEE(05_register [5])
  YES_OR_NO: 'YesOrNo', // 조회 OSP·Active / 다수 셀
  LOOKUP_COMMON: 'LookupCommon', // @lookupType 바인드 — 신규행 기본값 DEFAULT_PERIOD 조회(R-07)
  // 조회 Plant Site(다중선택) — Bod(SCP0007) From Site 조회조건과 동일 콤보(SITE_TYPE='PLANT') 재사용.
  //   서버 재조회 없는 필터 방식(전체 1회 조회 + division 클라 필터, plant-site.util.filterPlantSiteByDivision).
  //   SP(PKG_SCP0001.GET_PLANT_SITE)는 아직 단일 LIKE 계약이라 다중 선택값은 콤마로 합쳐 보내진다 — IN
  //   리스트로 실제 필터되게 하려면 SP 쪽 보완이 별도로 필요하다.
  PLANT_SITE: 'FromSiteByDivision1Ex_SCP_ALL',
  // 조회 Plant/Vendor(다중선택) — SQL_ID 자체가 @divisionId 바인드를 받아 서버에서 IN-list/'ALL'
  //   필터링한다(PLANT_SITE 와 달리 클라 필터 불요). useTabComboQueries 에 ComboParam 객체로
  //   { comboId, divisionId: searchParams.divisionId } 형태로 전달한다. CODE=PLANT_ID.
  PLANT_VENDOR: 'PlantVendorByDivision',
} as const;

// site 신규행 SHIP/PROD_FROZEN 기본값 원천 lookup(AS-IS dtPlanPeriod, cs:56·1439~1452).
export const DEFAULT_PERIOD_LOOKUP_TYPE = 'DEFAULT_PERIOD';

// 셀 콤보 후보 화면 직접 주입 대상(lookupType) — admin 메타는 site.OPERATION_GROUP/FROZEN_TYPE·
//   location.ELECTRODE_TYPE 전부 FPComboBox+LookupCommon+ATTRIBUTE1 로 정확히 등록돼 있으나, 공용
//   DataGrid 자동 콤보 로더가 컬럼별 ATTRIBUTE1(=lookupType)을 읽지 않아(FE/BE attribute1 소비처 0건)
//   BE 가 @lookupType 미전달 시 '' 로 치환해 후보 0건을 반환한다 — shipment-change-request-plan 화면과
//   동일 결함(useShipmentChangeRequestPlanCellCombos.ts 주석). 화면이 직접 조회해 dataMap 을 주입한다.
export const OPERATION_GROUP_LOOKUP_TYPE = 'OPERATION_GROUP';
export const FROZEN_TYPE_LOOKUP_TYPE = 'FROZEN_TYPE';
export const ELECTRODE_TYPE_LOOKUP_TYPE = 'ELECTRODE_TYPE';

// site.LOGISTIC_PLANT_ID Warranty 행 단일 옵션(A002) 제한을 위해 화면이 직접 조회(G02-b).
//   공용 DataGrid 자동 콤보는 컬럼 전체에 같은 dataMap 을 적용해 행별 제한을 표현할 수 없다.
export const LOGISTIC_PLANT_COMBO_ID = 'PlantByDivision1_SCP_ALL';

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
  'PlantVendorByDivision',
] as const;
