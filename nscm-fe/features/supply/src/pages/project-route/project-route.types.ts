// SCP0006 Project Route — 행 타입. procedures.d.ts SCP0006 response 기반 alias + 동적 월 셀 접근용.
import type { MENU_ID, RESPONSE_SET, SHEETS } from './project-route.constants';

export type SiteRow = ResponseData<MENU_ID, SHEETS.SITE, RESPONSE_SET.SITE>;
export type BomRow = ResponseData<MENU_ID, SHEETS.BOM, RESPONSE_SET.BOM>;
export type PlantRow = ResponseData<MENU_ID, SHEETS.PLANT, RESPONSE_SET.PLANT>;

// Main 더블클릭으로 확정되는 site key(BOM 조회 파라미터 + Plant 신규행 기본값 원천). design/00 A2.
export interface SiteKey {
  divisionId: string;
  scmSiteId: string;
  itemId: string;
  projectCode: string;
}

// BOM 더블클릭으로 확정되는 bom key(Plant 조회/셀콤보 파라미터 + 신규행 ITEM_ID). design/00 A3.
export interface BomKey {
  itemId: string;
  operationId: string;
  cellType: string;
}

// 조회조건(입력 중) 상태.
export interface SearchParamProps {
  divisionId: string;
  scmSiteId: string; // 항상 'ALL'(clbSalesSite 死필터, design/02 C2)
  projectCode: string;
  itemId: string;
  fromYyyymm: string;
  toYyyymm: string;
  status: string;
}
