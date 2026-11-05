import type { MENU_ID, SHEETS } from './inventory-raw.constants';

export interface InventoryRawSearchParams {
  divisionId: string;
  plantSiteIds: string[];
  inventoryType: string;
  planStartYyyymmdd: string;
  itemId: string;
}

// 그리드 행 — procedures.d.ts(SSOT) 기반. SP `SSP.SSP0017_GET_INVENTORY_RAW` 반환 31컬럼
// (design/03_grid-columns.md §1, DB 컬럼메타 원천, 배포·런타임 조회 확인).
export type InventoryRawRow = ResponseData<MENU_ID, SHEETS.MAIN>;
