import type { MENU_ID, SHEETS } from './precede-safety-stock-day.constants';

export type PrecedeSafetyStockDayRow = ResponseData<MENU_ID, SHEETS.MAIN>;

export interface SearchParamProps {
  divisionId: string;
  planGroupId: string; // 다중선택 — 콤마결합 문자열(design/02_search-combo.md §5)
  scmSiteId: string; // 확인 필요(SQL_ID 미확정) — 항상 'ALL' 고정 전송(clbSite 필드 미노출)
  itemId: string;
  stage: string;
  validYn: string;
  valueType: string; // 확인 필요(공급원 미상) — 필드 미노출, 항상 빈 값 전송
  periodFrom: string;
  periodTo: string;
}
