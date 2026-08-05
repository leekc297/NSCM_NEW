// ViewContainer — 열린 탭(MDI) 지연 마운트(lazy keep-alive) 렌더러.
//
// "열려는 있으나 아직 한 번도 보지 않은 탭"은 마운트하지 않는다(useTabActivation).
// 탭은 처음 활성화되는 순간 마운트되고, 그 뒤로는 display 토글로만 숨겨져 계속 살아있다 →
// 탭 전환 시 unmount/재조회/재초기화 없이 그리드 스크롤·입력·쿼리 캐시 상태가 그대로 유지된다.
//
// 이 지연 마운트가 없으면, 새로고침 시 sessionStorage 에서 복원된 열린 탭이 전부 동시에
// 마운트되어 모든 탭이 컬럼/그리드 조회를 터뜨린다. 활성화 이력은 저장하지 않으므로(useTabActivation)
// 새로고침 후에는 활성 탭 하나만 마운트/조회되고, 나머지는 클릭하는 순간 로드된다.
//
// 각 화면은 자기 tabId 의 TabIdContext.Provider 로 감싼다
// (createPersistedStoreWithTab 의 탭별 스토어 격리를 위해 필수).
// 각 화면은 ErrorBoundary 로 격리 — 한 화면의 렌더 에러가 앱 전체를 백지화하지 않는다.
import { Component, Suspense, useEffect, type ReactNode } from 'react';

import { clsx } from '@shared/clsx';
import { ProgressIndicator } from '@shared/lges';
import { useTheme } from '@shared/mui';
import { TabIdContext, useUIStore } from '@shared/stores';

import { HomePage } from '../pages/Home';
import { NotFoundPage } from '../pages/NotFound';

import { useMDIStore } from './useMDIStore';
import { useTabActivation } from './useTabActivation';
import styles from './ViewContainer.module.scss';
import { resolveView, type AnyPage } from './viewRegistry';

class ViewErrorBoundary extends Component<{ children: ReactNode }, { error: Error | null }> {
  state: { error: Error | null } = { error: null };

  static getDerivedStateFromError(error: Error) {
    return { error };
  }

  render() {
    if (this.state.error) {
      return (
        <div className={styles.viewError}>
          <p className={styles.viewErrorTitle}>화면을 표시하는 중 오류가 발생했습니다.</p>
          <p className={styles.viewErrorDetail}>
            {String(this.state.error?.message ?? this.state.error)}
          </p>
          <button
            type='button'
            className={styles.viewErrorRetry}
            onClick={() => this.setState({ error: null })}
          >
            다시 시도
          </button>
        </div>
      );
    }
    return this.props.children;
  }
}

/** home 탭은 PageProps 를 받지 않는 HomePage 를 렌더 */
const HomeView: AnyPage = () => <HomePage />;

const Fallback = () => (
  <div className={styles.fallback}>
    <ProgressIndicator shape='circular' open />
  </div>
);

export const ViewContainer = () => {
  const tabs = useMDIStore(state => state.tabs);
  const activeIndex = useMDIStore(state => state.activeIndex);
  const activeTabId = tabs[activeIndex]?.tabId;
  const { palette } = useTheme();

  // 지연 마운트 이력 — 활성화된 적 있는 탭만 마운트한다(위 파일 주석 참고).
  const activated = useTabActivation(state => state.activated);
  const activate = useTabActivation(state => state.activate);

  // 활성 탭은 항상 마운트 대상으로 이력에 등록한다.
  useEffect(() => {
    if (activeTabId) activate(activeTabId);
  }, [activeTabId, activate]);

  // Page 영역 전체화면 (MainTitle 의 전체화면 아이콘이 토글) — 활성 탭 뷰에만 적용하는 공통 처리.
  const pageFullscreen = useUIStore(state => state.pageFullscreen);
  const setPageFullscreen = useUIStore(state => state.setPageFullscreen);

  // 탭 전환/최초 마운트 시 전체화면 해제 — 다른 탭이 예기치 않게 전체화면으로 열리는 것 방지.
  useEffect(() => {
    setPageFullscreen(false);
  }, [activeTabId, setPageFullscreen]);

  // ESC 로 전체화면 종료
  useEffect(() => {
    if (!pageFullscreen) return;
    const escHandler = (keyboardEvent: KeyboardEvent) => {
      if (keyboardEvent.key === 'Escape') setPageFullscreen(false);
    };
    globalThis.window.addEventListener('keydown', escHandler);
    return () => globalThis.window.removeEventListener('keydown', escHandler);
  }, [pageFullscreen, setPageFullscreen]);

  return (
    <div className={styles.viewport}>
      {tabs.map(tab => {
        const isActive = tab.tabId === activeTabId;

        // 지연 마운트: 활성 탭이거나 한 번이라도 활성화된 적 있는 탭만 마운트한다.
        // (활성 탭은 위 effect 로 이력에 등록되지만, effect 는 렌더 후 실행되므로
        //  최초 렌더에서 활성 탭이 빈 화면이 되지 않도록 isActive 도 함께 본다.)
        const shouldMount = isActive || Boolean(activated[tab.tabId]);
        if (!shouldMount) return null;

        // DB 메뉴 정보(routePath/mnuUrl)로 화면 컴포넌트 해석 — viewRegistry 참조
        const View =
          tab.mnuId === 'home'
            ? HomeView
            : resolveView({ routePath: tab.routePath, mnuUrl: tab.mnuUrl });

        const isFullscreen = isActive && pageFullscreen;

        return (
          <div
            key={tab.tabId}
            className={clsx(styles.view, { [styles.viewFullscreen]: isFullscreen })}
            style={{
              // flex column — 페이지 = MainTitle + SearchArea + SubTitle + Result(그리드) 수직 배치.
              // Result 영역(DataGrid, flex:1 1 0)이 남은 높이를 채우고 스크롤은 그리드 내부에 생긴다.
              display: isActive ? 'flex' : 'none',
              ...(isFullscreen && { backgroundColor: palette.background.default }),
            }}
          >
            <TabIdContext.Provider value={tab.tabId}>
              <ViewErrorBoundary>
                <Suspense fallback={<Fallback />}>
                  {/*
                    VIEW_REGISTRY 에 mnuId 매핑이 없는 탭(메뉴는 DB 에 있으나 화면 미구현/오타).
                    null 을 렌더하면 빈 화면이라 원인을 알 수 없으므로 404 를 표시한다.
                    탭 단위로만 처리 — 탭 바와 다른 탭들은 그대로 유지된다.
                  */}
                  {View ? (
                    <View tabId={tab.tabId} title={tab.mnuMsgId} menu={tab} />
                  ) : (
                    <NotFoundPage />
                  )}
                </Suspense>
              </ViewErrorBoundary>
            </TabIdContext.Provider>
          </div>
        );
      })}
    </div>
  );
};
