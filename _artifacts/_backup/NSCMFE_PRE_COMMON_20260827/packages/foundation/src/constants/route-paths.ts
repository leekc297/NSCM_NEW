/**
 * 라우트 경로 상수
 *
 * 화면(mnuId)별 경로 매핑은 DB 로 이관됨 — SCM_ADM_MNU_M.ROUTE_PATH
 * (세션 메뉴 응답의 menu.routePath 를 viewRegistry.resolveView 가 해석).
 * 여기에는 메뉴 데이터가 아닌 구조적 경로만 남긴다.
 */

export const ROUTE_PATHS = {
  HOME: 'home',
} as const;
