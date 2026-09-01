// RouterSync — 활성 탭 ↔ URL(#/view/:mnuId) 양방향 동기화.
//
// 설계: 화면 렌더링은 ViewContainer(keep-alive)가 소유하고, 라우터는 URL 미러만 담당한다.
//  - react-router 가 화면을 직접 렌더링하면 라우트 전환 시 unmount 되어 keep-alive 가 깨진다.
//    URL 미러 방식은 이 충돌이 없다.
//  - URL 식별자는 mnuId(메뉴 코드)만 사용한다 — 주소창에 노출되므로 사람이 읽을 수 있는 값으로.
//    같은 메뉴를 여러 탭으로 연 경우(멀티 모드) URL 은 그 탭들을 구분하지 못하지만,
//    "어느 탭이 활성인지"는 MDI 스토어의 activeIndex(sessionStorage 영속)가 정확히 기억한다.
//  - 탭 전환/오픈 → URL push (다른 메뉴로 이동 시 뒤로가기 이력 생성)
//  - URL 변경(딥링크/뒤로가기/직접 입력) → 해당 mnuId 탭 활성화, 없으면 새로 오픈
//  - MDI 스토어는 sessionStorage 영속 → 새로고침 시 activeIndex 로 활성 탭 복원
import { useEffect, useRef } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';

import { useSessionStore } from '@shared/stores';

import { useMDIStore } from './useMDIStore';

const VIEW_PREFIX = '/view/';

const getViewPath = (mnuId: string) => `${VIEW_PREFIX}${encodeURIComponent(mnuId)}`;

interface RouterSyncProps {
  /**
   * 마운트 시점에 활성 탭 URL 로 미러링할지 여부.
   * `/` · `/home` 처럼 셸만 매칭된 경로는 활성 탭 URL 로 보정해야 하지만,
   * 404 로 진입한 경우엔 보정하면 안 된다(NotFound 가 뜨기도 전에 튕겨나감).
   * 마운트 이후의 탭 전환/오픈은 이 값과 무관하게 항상 미러링한다
   * (404 화면에서 사이드바 메뉴를 눌러 빠져나갈 수 있어야 하므로).
   */
  mirrorOnMount?: boolean;
}

export const RouterSync = ({ mirrorOnMount = true }: RouterSyncProps) => {
  const navigate = useNavigate();
  const location = useLocation();
  const isFirstRun = useRef(true);

  const tabs = useMDIStore(state => state.tabs);
  const activeIndex = useMDIStore(state => state.activeIndex);
  // 메뉴 로딩 완료 후 딥링크를 재해석하기 위한 의존성
  const menus = useSessionStore(state => state.session?.menus);

  const activeTab = tabs[activeIndex];

  // store → URL : 탭 전환/오픈/닫기로 활성 탭이 바뀌면 URL 을 미러링
  useEffect(() => {
    const isMount = isFirstRun.current;
    isFirstRun.current = false;

    if (!activeTab) return;
    if (isMount && !mirrorOnMount) return; // 404 진입 — URL 을 유지해야 NotFound 가 보인다

    const target = getViewPath(String(activeTab.mnuId));
    if (location.pathname !== target) navigate(target);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [activeTab?.tabId]);

  // URL → store : 딥링크 / 뒤로·앞으로 / 주소 직접 입력
  useEffect(() => {
    if (!location.pathname.startsWith(VIEW_PREFIX)) return;

    const [mnuIdRaw] = location.pathname.slice(VIEW_PREFIX.length).split('/');
    const mnuId = decodeURIComponent(mnuIdRaw ?? '');
    if (!mnuId) return;

    const store = useMDIStore.getState();
    // 이미 이 메뉴가 활성이면 유지 — 같은 메뉴의 다른 탭으로 강제 전환하지 않는다.
    // (새로고침 시 activeIndex 로 복원된 정확한 탭을 URL 이 덮어쓰지 않게 하는 역할도 겸한다)
    if (String(store.tabs[store.activeIndex]?.mnuId) === mnuId) return;

    const idx = store.tabs.findIndex(t => String(t.mnuId) === mnuId);
    if (idx >= 0) {
      store.setActiveTab(idx);
      return;
    }

    // 스토어에 없는 메뉴(공유 링크/스토리지 초기화) → 새로 오픈
    const path = useSessionStore.getState().findMenuPath(mnuId);
    const leaf = path?.[path.length - 1];
    if (leaf) store.openTab(leaf);
  }, [location.pathname, menus]);

  return null;
};
