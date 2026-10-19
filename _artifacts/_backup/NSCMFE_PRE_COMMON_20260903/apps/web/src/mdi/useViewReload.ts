// useViewReload — 화면 컴포넌트 강제 remount 트리거.
//
// ViewContainer 는 각 탭 뷰의 React key 에 이 nonce 를 결합한다. nonce 가 바뀌면 그 탭만
// unmount→mount 되어 화면 컴포넌트가 다시 초기화·재조회된다. 이 앱은 F5 를 그리드 재조회로
// 가로채므로 브라우저 새로고침으로는 컴포넌트가 다시 마운트되지 않는다 — 이 스토어가 그
// 컴포넌트 단위 리로드를 제공한다(전체 페이지 reload 아님).
//
// 용도: Atlas 브리지의 reload page tool — 브라우저 에이전트가 call_page_tool 로 활성 화면을
// 다시 마운트시킬 때 사용한다. (영속화하지 않는다 — 재마운트 이력은 세션을 넘길 이유가 없다)
import { createStandardStore } from '@shared/stores';

interface ViewReloadState {
  /** tabId → remount nonce. key 에 결합되어, 증가할 때마다 해당 탭이 remount 된다. */
  nonce: Record<string, number>;
  reload: (tabId: string) => void;
}

export const useViewReload = createStandardStore<ViewReloadState>(
  set => ({
    nonce: {},
    reload: tabId =>
      set(state => {
        state.nonce[tabId] = (state.nonce[tabId] ?? 0) + 1;
      }),
  }),
  'view-reload'
);
