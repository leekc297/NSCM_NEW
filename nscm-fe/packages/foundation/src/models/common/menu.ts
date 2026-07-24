export interface Menu {
  mnuId: string | MenuId;
  upprMnuId?: string | null;
  mnuUrl: string;
  // ⭐ SCM_ADM_MNU_M.ROUTE_PATH — 전체 라우트 경로(계층 MNU_URL join). 메뉴 클릭 네비게이션 원천.
  routePath?: string;
  mnuMsgId: translation;
  mnuDesc: string;
  favorite?: boolean;
  children?: Menu[];
}
