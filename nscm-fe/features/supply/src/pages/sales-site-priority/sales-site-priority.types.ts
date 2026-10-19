import type { MENU_ID, SHEETS } from './sales-site-priority.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. TO-BE PKG_SCP0131 미배포 상태라 Base index fallback 으로
//   해석된다(자매 SCP0037 operation-lt 동일 방식). 컬럼셋 정본은 DB SCM_MST_SHEET_COLUMNS 14행(design 03 §1).
export type SalesSitePriorityRow = ResponseData<MENU_ID, SHEETS.MAIN>;

// 조회조건 (Form 입력 상태 — searchParams). design 02 §1 인벤토리:
//   division(단일) / planGroup(다중) / site(다중) / itemId(텍스트+팝업) / from~to(기간) / validYn(단일).
export interface SearchCondition {
  divisionId: string;
  planGroupIds: string[];
  siteIds: string[];
  itemId: string;
  fromDate: string;
  toDate: string;
  validYn: string;
}

// 조회영역 Plan Group/Site 콤보 원본 행 — DIVISION_ID 로 cascade 클라 필터(design 02 §3).
export interface CascadeComboSource {
  CODE: string;
  NAME: string;
  DIVISION_ID: string;
}
