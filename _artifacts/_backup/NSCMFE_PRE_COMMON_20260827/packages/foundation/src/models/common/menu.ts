export interface Menu {
  mnuId: string | MenuId;
  upprMnuId?: string | null;
  mnuUrl: string;
  /** 화면 모듈 경로 (DB SCM_ADM_MNU_M.ROUTE_PATH, 예: 'master/sales-site') — viewRegistry 해석 1순위 */
  routePath?: string | null;
  mnuMsgId: translation;
  mnuDesc: string;
  favorite?: boolean;
  children?: Menu[];
}
