import type { MENU_ID, SHEETS } from './validation-shipment-result.constants';

// 조회조건(입력 중) — SearchArea 가 읽고 쓴다. AS-IS Find_Data(cs 291~329) 8-IN 파라미터 대응.
//   divisionId=단일 코드 / plantSiteId·salesSiteId=텍스트 / projectCode·itemId=팝업 콤마 다중 /
//   resultType=단일 코드(I/C/B) / from·to=YYYYMMDD 날짜범위.
export interface SearchParams {
  divisionId: string; // cboDivision(MyDivision, 단일) → p_division_id
  plantSiteId: string; // txtPlantSite(텍스트) → p_plant_site_id
  salesSiteId: string; // txtSaleSite(텍스트) → p_sales_site_id
  projectCode: string; // txtProject + ProjectByDivisionModal(콤마 다중) → p_project_code
  itemId: string; // txtItemId + ItemByDivisionModal(콤마 다중) → p_item_id
  resultType: string; // cboResultType(LookupCommon, 단일) → p_result_type
  fromYyyymmdd: string; // drpPeriod From(YYYYMMDD) → p_from_yyyymmdd
  toYyyymmdd: string; // drpPeriod To(YYYYMMDD) → p_to_yyyymmdd
}

// 조회 결과 행 — GET SP 반환 23컬럼 ∩ SCM_MST_SHEET_COLUMNS 메타(VALID='Y' 23행, design 03 §1).
//   컬럼셋은 admin 메타 구동이라 동적 인덱스 시그니처로 받는다(코드가 특정 컬럼을 직접 참조하지 않음).
export type ValidationShipmentResultRow = ResponseData<MENU_ID, SHEETS.MAIN>;
