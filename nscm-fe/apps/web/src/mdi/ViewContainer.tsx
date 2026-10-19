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
import { Component, Suspense, useCallback, useEffect, useState, type ReactNode } from 'react';

import { clsx } from '@shared/clsx';
import { SEARCH_AREA_MIN_WIDTH } from '@shared/components';
import { ProgressIndicator } from '@shared/lges';
import { useTheme } from '@shared/mui';
import { TabIdContext, MenuIdContext, isTabDirty, useUIStore } from '@shared/stores';

import { HomePage } from '../pages/Home';
import { NotFoundPage } from '../pages/NotFound';

import { useMDIStore } from './useMDIStore';
import { useTabActivation } from './useTabActivation';
import { useViewReload } from './useViewReload';
import styles from './ViewContainer.module.scss';
import { resetView, resolveView, type AnyPage } from './viewRegistry';

// onRetry 는 부모(ViewContainer)가 lazy 캐시를 비우고 재렌더하도록 알린다 —
// 에러 상태만 지우면 부모가 준 children(= 실패를 캐시한 같은 lazy 인스턴스)이 그대로라
// 재요청 없이 같은 에러가 다시 던져진다. resetView 주석 참고.
class ViewErrorBoundary extends Component<
  { children: ReactNode; onRetry: () => void },
  { error: Error | null }
> {
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
            onClick={() => {
              this.props.onRetry();
              this.setState({ error: null });
            }}
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
  const pruneTo = useTabActivation(state => state.pruneTo);

  // 컴포넌트 강제 remount nonce — key 에 결합해 특정 탭만 unmount→mount 시킨다.
  // (Atlas 브리지 reload page tool 이 useViewReload.reload 로 증가시킨다)
  const reloadNonce = useViewReload(state => state.nonce);

  // 닫힌 탭을 마운트 이력에서 먼저 정리한다 — LRU 카운트가 열린 탭만 세도록.
  // (아래 activate effect 보다 먼저 선언 = 먼저 실행 → 탭을 닫아도 잘못된 언마운트가 안 일어남)
  useEffect(() => {
    pruneTo(tabs.map(tab => tab.tabId));
  }, [tabs, pruneTo]);

  // 활성 탭은 항상 마운트 대상으로 이력에 등록하고, 상한 초과 시 LRU 언마운트한다.
  // 미저장 편집(dirty) 탭은 보호 대상으로 넘겨 언마운트에서 제외한다(데이터 유실 방지).
  useEffect(() => {
    if (!activeTabId) return;
    const dirtyTabIds = tabs.filter(tab => isTabDirty(tab.tabId)).map(tab => tab.tabId);
    activate(activeTabId, dirtyTabIds);
  }, [activeTabId, tabs, activate]);

  // 화면 로드 실패 후 "다시 시도" — lazy 캐시를 비우고 재렌더해 새 lazy 인스턴스로 다시 import 한다.
  // nonce 는 재렌더 트리거용(캐시를 비워도 부모가 다시 렌더하지 않으면 옛 인스턴스가 그대로 쓰인다).
  const [, setRetryNonce] = useState(0);
  const retryView = useCallback((menu: { routePath?: string | null; mnuUrl?: string | null }) => {
    resetView(menu);
    setRetryNonce(nonce => nonce + 1);
  }, []);

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
            // nonce 를 key 에 결합 — reload 시 이 값만 바뀌어 해당 탭이 remount 된다.
            key={`${tab.tabId}:${reloadNonce[tab.tabId] ?? 0}`}
            className={clsx(styles.view, { [styles.viewFullscreen]: isFullscreen })}
            style={{
              // flex column — 페이지 = MainTitle + SearchArea + SubTitle + Result(그리드) 수직 배치.
              // Result 영역(DataGrid, flex:1 1 0)이 남은 높이를 채우고 스크롤은 그리드 내부에 생긴다.
              display: isActive ? 'flex' : 'none',
              ...(isFullscreen && { backgroundColor: palette.background.default }),
            }}
          >
            {/* .view(위 style.display)가 스크롤 컨테이너, 이 래퍼가 스크롤 대상 콘텐츠 —
                MainTitle/SearchArea/SubTitle/Result 를 항상 SEARCH_AREA_MIN_WIDTH 이상의
                같은 폭으로 묶어, 뷰포트가 좁아져도 스크롤바가 .view 하나에서만 생기게 한다. */}
            <div className={styles.viewInner} style={{ minWidth: `${SEARCH_AREA_MIN_WIDTH}px` }}>
              <TabIdContext.Provider value={tab.tabId}>
                {/* 콤보 훅이 @mnuId 를 화면 스코프로 기본 주입할 수 있도록 이 탭의 화면 코드를 심는다. */}
                <MenuIdContext.Provider value={String(tab.mnuId)}>
                  <ViewErrorBoundary
                    onRetry={() => retryView({ routePath: tab.routePath, mnuUrl: tab.mnuUrl })}
                  >
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
                </MenuIdContext.Provider>
              </TabIdContext.Provider>
            </div>
          </div>
        );
      })}
    </div>
  );
};
