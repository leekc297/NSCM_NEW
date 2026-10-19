/**
 * AS-IS SCP0007_DistributionRoutePopup — SCP0007 BOD 의 Route ID 셀 더블클릭 팝업.
 * 조회 SP(SCP.SCP0005_GET_DISTRIBUTION_ROUTE)는 SCP0005 Distribution Route 화면과 공용이라
 * MENU_ID 는 그 화면 것을 그대로 쓴다(procedures.d.ts SCP0005 참조).
 * 그리드 컬럼은 admin 컬럼메타(SCM_MST_SHEET_COLUMNS: PROGRAM_ID='SCP0005', SHEET_NAME='route')에서
 * 동적 fetch 한다 — bodDistributionRoutePopupStore.fetchStaticColumns 참조(하드코딩 금지).
 */
export const ROUTE_POPUP_MENU_ID = 'SCP0005' as const;
export type ROUTE_POPUP_MENU_ID = typeof ROUTE_POPUP_MENU_ID;

export enum ROUTE_POPUP_SHEETS {
  ROUTE = 'route',
}
