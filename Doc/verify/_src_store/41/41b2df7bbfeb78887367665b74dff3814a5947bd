// viewActionRegistry — 화면(탭)이 노출하는 named action 을 tabId 로 모아 두는 레지스트리.
//
// SubTitle 이 조립한 buttonActions(툴바 액션 — search/save/insert/delete 등, 미저장 가드 포함)를
// 이 레지스트리에 tabId 로 등록한다. Atlas 브리지(apps/web)는 활성 탭의 액션을 여기서 찾아
// browser/bridge 구성이 선언한 page tool 에 바인딩한다. 브리지 config 는 "어떤 action 을 어떤
// tool 이름으로 노출할지"의 선언이고, 실제 함수는 이 레지스트리가 소유한다(코드/데이터 분리).
//
// 순수 모듈(React·MDI 의존 없음) — 활성 탭 해석은 호출자(브리지)가 tabId 를 넘겨 수행한다.
export type ViewAction = (args?: unknown) => unknown;

const actionsByTab = new Map<string, Record<string, ViewAction>>();

export const registerViewActions = (tabId: string, actions: Record<string, ViewAction>): void => {
  actionsByTab.set(tabId, actions);
};

export const unregisterViewActions = (tabId: string): void => {
  actionsByTab.delete(tabId);
};

export const getViewActions = (tabId: string): Record<string, ViewAction> | undefined =>
  actionsByTab.get(tabId);
