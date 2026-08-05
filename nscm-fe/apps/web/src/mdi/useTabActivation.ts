// useTabActivation — 지연 마운트(lazy keep-alive)용 "활성화된 적 있는 탭" 이력.
//
// ViewContainer 는 이 이력에 있는 탭만 마운트한다. 즉 탭은 처음 활성화되는 순간
// 마운트되고, 그 뒤로는 keep-alive 로 계속 살아있다(다시 클릭해도 재조회 없음).
//
// 이 스토어는 의도적으로 영속화하지 않는다(createStandardStore = sessionStorage 미저장).
//  - 저장하면 새로고침 후 "이전에 열어봤던 모든 탭"이 다시 마운트되어(→ 전부 컬럼/그리드 조회)
//    지연 마운트가 무의미해진다. 새로고침 시 활성 탭 하나만 조회되게 하려면 이력이 초기화돼야 한다.
//  - 모듈 레벨 스토어라 ViewContainer 리마운트(홈 ↔ /view 라우트 전환)에도 이력이 유지되고,
//    페이지 새로고침 시에만(모듈 재평가) 초기화된다.
import { createStandardStore } from '@shared/stores';

interface TabActivationState {
  /** 마운트된 적 있는 탭 id 집합 (Record 로 얕은 비교/불변 갱신) */
  activated: Record<string, true>;
  activate: (tabId: string) => void;
  /** 탭을 닫을 때 이력에서 제거 — 같은 UUID 재사용은 없지만 메모리 누수 방지용 */
  deactivate: (tabId: string) => void;
}

export const useTabActivation = createStandardStore<TabActivationState>(
  set => ({
    activated: {},
    activate: tabId =>
      set(state => {
        // 이미 있으면 건드리지 않는다 — immer 가 변경 없음으로 처리해 불필요한 리렌더 방지
        if (!state.activated[tabId]) state.activated[tabId] = true;
      }),
    deactivate: tabId =>
      set(state => {
        delete state.activated[tabId];
      }),
  }),
  'tab-activation'
);
