/**
 * MDI 탭 열기 모드.
 * - 'multi' : 메뉴 클릭마다 새 탭 생성(고객 요구 — 현행). 같은 메뉴가 여러 탭으로 열림.
 * - 'single': 메뉴 1개 ↔ 탭 1개. 이미 열린 메뉴를 다시 클릭하면 기존 탭으로 포커스.
 *
 * keep-alive 렌더링과 URL 미러(#/view/:mnuId/:tabId)는 두 모드 모두 동일하게 동작한다
 * (탭 식별은 tabId 기반).
 */
export type MdiTabMode = 'multi' | 'single';

export const MDI_TAB_MODE: MdiTabMode = 'multi';
