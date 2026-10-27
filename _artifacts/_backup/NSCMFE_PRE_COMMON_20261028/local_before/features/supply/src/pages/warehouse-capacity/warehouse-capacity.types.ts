import type { MENU_ID, SHEETS } from './warehouse-capacity.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. Warehouse Capacity 시트(15컬럼, design 03 §1.1).
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;

// 조회조건(Form 입력 상태 — searchParams). design 02 §1 인벤토리 10항목 중 DB 공급 필요분:
//   Division(단일) / PlanGroup·Site·Stage·Warehouse(다중, cascade) / Valid(단일) / Period(From~To)
//   / Item ID(팝업 결과 수신).
export interface SearchCondition {
  divisionId: string;
  planGroupIds: string[];
  siteIds: string[];
  stages: string[];
  warehouses: string[];
  validYn: string;
  fromYyyymmdd: string;
  toYyyymmdd: string;
  itemId: string;
}
