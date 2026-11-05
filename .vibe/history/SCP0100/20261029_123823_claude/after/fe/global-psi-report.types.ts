import type { MENU_ID, SHEETS } from './global-psi-report.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. SCP0100 은 procedures.d.ts 미등재라 Base 인덱스시그니처
//   fallback(Record<string, WijmoRowItem>)으로 해석된다(자매 SCP0111 동일). PIVOT 값(M_/W_/B_ 기간칼럼)·
//   MEASURE_NAME·CELL_CF 등 표시/색상 판정 컬럼은 GET SP 반환에 포함(design 03 §4).
export type ReportRow = ResponseData<MENU_ID, SHEETS.REPORT>;
export type SearchLevelRow = ResponseData<MENU_ID, SHEETS.SEARCH_LEVEL>;
export type SearchLevelDetailRow = ResponseData<MENU_ID, SHEETS.SEARCH_LEVEL_DETAIL>;

// 조회조건 (Form 입력 상태 — searchCondition). design 02 §1 인벤토리 16조건 + §4.4 GET 17-param 매핑.
//   read-only 리포트 — 저장/입력 필드 없음.
export interface SearchCondition {
  divisionId: string; // cboDivision — 권한 division. EE/'40'/'82' 3중 제외(design 02 §2.7). cascade 최상위
  fromYyyymmdd: string; // dtpFrom — 조회 시작일(P_FROM_YYYYMMDD). dStart>dPlan 검증 대상(design 02 §4.4)
  toYyyymmdd: string; // dtpTo — 조회 종료일(P_TO_YYYYMMDD)
  planStartYyyymmdd: string; // cboPlanDate — Plan 시작일(P_PLAN_START_YYYYMMDD). division·bucket cascade(SP)
  planType: string; // cboPlanType — lookup PLAN_TYPE, 기본 'FN'(design 02 §4.2)
  bucket: string; // cboBucket — MONTHLY(기본)/WEEKLY. M_/W_ pivot visible 토글(design 03 §2.5)
  display: string; // cboDisplay — lookup STOCK_TREND_DISPLAY, 기본 GRID(OnlyGrid). 레이아웃 D1~D4(design 01)
  searchLevel: string; // cboSearchLevel — lookup PRODUCT_LEVEL, idx0=CELL_GROUP(design 02 §4.2)
  fromSite: string; // cboFromSite — SP P_SCP0100_GET_SITE load-once(design 02 §2.2). P_FROM_SITE
  toSite: string; // cboToSite — SP P_SCP0100_GET_SITE load-once. P_TO_SITE
  itemId: string; // txtItemId — btnItemId 팝업(ItemByDivisionModal)이 채움. P_ITEM_ID
  nickName: string; // txtNickName — P_NICK_NAME
  project: string; // txtProject — btnProject 팝업(ProjectByDivisionModal)이 채움. P_PROJECT
  cellGroup: string; // P_CELL_GROUP — CELL_GROUP 조건
  chkCellQty: boolean; // chkCellQty — AS-IS NO-OP(design 01 §2). P_CHK_CELL_QTY
  chkAs: boolean; // chkAS — AS-IS NO-OP(design 01 §2). P_CHK_AS
}
