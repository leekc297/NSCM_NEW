import type { MENU_ID, SHEETS } from './warehouse-capacity.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. Warehouse Capacity 시트(15컬럼, design 03 §1.1).
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;

// Warehouse Item Mapping 시트(16컬럼, design 03 §1.2) — procedures.d.ts SCP0133.itemMapping.
export type ItemMappingRow = ResponseData<MENU_ID, SHEETS.ITEM_MAPPING>;

// 조회조건(Form 입력 상태 — searchParams). AS-IS 컨트롤 타입(Designer 실측):
//   Division(단일 UsrCombo) / PlanGroup·Site·Warehouse(다중 UsrCheckedList) / Stage(단일 UsrComboBox,
//   cboStage.SelectedValue) / Valid(단일) / Period(From~To) / Item ID(팝업 결과 수신).
export interface SearchCondition {
  divisionId: string;
  planGroupIds: string[];
  siteIds: string[];
  stage: string;
  warehouses: string[];
  validYn: string;
  fromYyyymmdd: string;
  toYyyymmdd: string;
  itemId: string;
}
