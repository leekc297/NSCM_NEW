import type { TFunction } from 'i18next';

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

/**
 * 메뉴 라벨 표시용 공통 해석기 — 다국어(mnuMsgId) → mnuDesc → mnuId 순으로 폴백한다.
 *
 * 탭(MDITabs)과 페이지 타이틀(MainTitle)이 공유한다. 두 곳은 원래 폴백이 프로그램 ID(mnuId)라
 * 다국어 라벨이 없는 메뉴는 화면명 대신 DMF0005 같은 ID 가 노출됐다. 사이드바/브레드크럼의
 * t(mnuMsgId, mnuDesc) 와 동일하게 최소한 화면명(mnuDesc)이 보이도록 mnuDesc 를 우선 폴백하고,
 * 그마저 없을 때만 mnuId 로 떨어진다.
 */
export const resolveMenuLabel = (
  t: TFunction,
  menu: { mnuMsgId: string; mnuDesc?: string | null; mnuId?: string | number | null }
): string => t(menu.mnuMsgId, menu.mnuDesc || String(menu.mnuId ?? ''));
