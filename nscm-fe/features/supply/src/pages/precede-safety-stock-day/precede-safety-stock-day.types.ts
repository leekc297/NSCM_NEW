import type { MENU_ID, SHEETS } from './precede-safety-stock-day.constants';

export type PrecedeSafetyStockDayRow = ResponseData<MENU_ID, SHEETS.MAIN>;

export interface SearchParamProps {
  divisionId: string;
  planGroupId: string; // 다중선택 — 콤마결합 문자열(design/02_search-combo.md §5)
  scmSiteId: string; // Site 다중선택 — 콤마결합 문자열(init o_rc2 원천, Division cascade)
  itemId: string;
  stage: string;
  validYn: string;
  valueType: string; // Type 단일선택(init o_rc4 COVER_DAY_TYPE MAX/MIN 원천, 전역)
  periodFrom: string;
  periodTo: string;
}
