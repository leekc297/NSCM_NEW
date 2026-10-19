import type { MENU_ID, SHEETS } from './constraint-of-shipment-qty.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. TO-BE PKG_SCP0132 미배포 상태라 Base index fallback 으로
//   해석된다(자매 SCP0131 sales-site-priority 동일 방식). 컬럼셋 정본은 DB SCM_MST_SHEET_COLUMNS
//   23행(design 03 §1).
export type ConstraintOfShipmentQtyRow = ResponseData<MENU_ID, SHEETS.MAIN>;

// 조회조건(Form 입력 상태 — searchParams). design 02 §1 인벤토리 9개:
//   division(단일, cascade 트리거) / planGroup·fromSite·toSite·stage·modelGroup(5갈래 fan-out,
//   다중선택) / itemId(텍스트+팝업) / from~to(기간) / validYn(단일).
export interface SearchCondition {
  divisionId: string;
  planGroupIds: string[];
  fromSiteIds: string[];
  toSiteIds: string[];
  stageIds: string[];
  modelGroupIds: string[];
  itemId: string;
  fromDate: string;
  toDate: string;
  validYn: string;
}

// 조회영역 cascade 콤보 원본 행 — DIVISION_ID 로 클라 필터(design 02 §3, filterCalls#1~#7).
export interface CascadeComboSource {
  CODE: string;
  NAME: string;
  DIVISION_ID: string;
}
