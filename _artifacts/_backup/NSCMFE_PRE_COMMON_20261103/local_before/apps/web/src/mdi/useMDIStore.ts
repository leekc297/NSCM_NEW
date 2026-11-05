/* @refresh reload */
import { ROUTE_PATHS } from '@foundation/constants';
import type { Menu } from '@foundation/models';
import { getUuid } from '@foundation/utils';
import {
  confirmIfTabDirty,
  confirmIfTabsDirty,
  createPersistedStore,
  useSessionStore,
  useUIStore,
} from '@shared/stores';

import { MDI_TAB_MODE } from './mdi.config';
import type { AnyTab } from './MDI.types';

interface MDIState {
  tabs: AnyTab[];
  activeIndex: number;
}

interface MDIActions {
  openTab: (menu: Omit<Menu, 'children' | 'sortOrd'>) => void;
  setActiveTab: (tabIndex: number) => void;
  closeTab: (tabIndex: number) => void;
  closeOtherTabs: () => void;
  closeAllTabs: () => void;
}

const homeTab: AnyTab = {
  tabId: 'tab-home',
  mnuDesc: 'home',
  mnuId: 'home',
  mnuUrl: ROUTE_PATHS.HOME,
  mnuMsgId: 'LBL00312' as translation,
  closable: false,
};

const initMDIState: MDIState = {
  tabs: [homeTab],
  activeIndex: 0,
};

export const useMDIStore = createPersistedStore<MDIState & MDIActions>(
  (set, get) => ({
    ...initMDIState,
    openTab: menu => {
      // 클릭 시점의 최신 메뉴를 session.menus 에서 다시 찾는다 — 사이드바/링크가 넘기는 menu 는
      //   클릭 당시의 복사본이라, 그 뒤 메뉴 관리에서 바뀐 routePath 를 모른다. 최신 리프를 기준으로
      //   열어 재로그인 없이 route 변경이 반영되게 한다. 트리에 없으면(홈 등) 넘어온 menu 를 쓴다.
      // path = [상단메뉴, (2레벨 그룹), ..., 리프] 이므로 마지막 원소가 이 메뉴 자신(리프)이다.
      const menuPath = useSessionStore.getState().findMenuPath(menu.mnuId as string);
      const freshMenu = menuPath?.[menuPath.length - 1] ?? menu;

      // route path 가 외부 URL 이면 내부 뷰로 해석하지 않고 새 창으로 연다.
      //   viewRegistry 는 routePath 를 features/*/pages 폴더로 매칭하므로 외부 URL 은 매칭 실패로
      //   빈 화면이 됐다. rel=noopener 로 새 창의 window.opener 역참조를 막는다.
      // 판정: 스킴(http/https)·프로토콜상대(//)뿐 아니라 스킴 없는 도메인(naver.com, www.naver.com)도
      //   외부로 본다 — 내부 routePath 는 'demand/demand-master/sales-site' 처럼 첫 세그먼트가
      //   폴더명(점 없음)이라, 첫 세그먼트에 점이 있으면 외부 도메인으로 판정한다.
      // 정규화: 스킴이 없으면 https:// 를 붙여 window.open 이 상대경로로 열지 않게 한다.
      const rawPath = freshMenu.routePath?.trim() ?? '';
      const hasScheme = /^https?:\/\//i.test(rawPath);
      const firstSegment = rawPath.split('/')[0];
      const isExternalUrl = hasScheme || rawPath.startsWith('//') || firstSegment.includes('.');
      if (rawPath && isExternalUrl) {
        const href = hasScheme
          ? rawPath
          : rawPath.startsWith('//')
            ? `https:${rawPath}`
            : `https://${rawPath}`;
        globalThis.window.open(href, '_blank', 'noopener,noreferrer');
        return;
      }

      if (menu.mnuUrl === '/home') {
        set(state => {
          state.activeIndex = 0;
        });
        return;
      }

      // single 모드: 이미 열린 같은 메뉴가 있으면 새 탭 대신 그 탭으로 포커스한다.
      //   포커스 시 그 사이 바뀐 routePath/라벨을 최신으로 갱신 — routePath 가 바뀌었으면
      //   ViewContainer 가 새 화면으로 재해석해, 재접속(재클릭)만으로 새 페이지가 열린다.
      if (MDI_TAB_MODE === 'single') {
        const existingIndex = get().tabs.findIndex(t => t.mnuId === menu.mnuId);
        if (existingIndex >= 0) {
          set(state => {
            const tab = state.tabs[existingIndex];
            tab.routePath = freshMenu.routePath;
            tab.mnuDesc = freshMenu.mnuDesc;
            tab.mnuMsgId = freshMenu.mnuMsgId;
            state.activeIndex = existingIndex;
          });
          return;
        }
      }

      const tabId = getUuid();

      // 사이드바를 이 메뉴에 맞춰 전환한다 — 링크/URL/즐겨찾기로 들어와도 좌측 메뉴가 따라오도록.
      // path[0] 이 사이드바에 띄울 상단 메뉴, path[1] 은 펼쳐야 할 그룹이다
      // (2단 메뉴면 path[1] 이 리프 자신이라 펼칠 그룹이 없다).
      if (menuPath?.length) {
        useUIStore
          .getState()
          .syncSidebarToMenu(
            menuPath[0],
            menuPath.length >= 3 ? String(menuPath[1].mnuId) : undefined
          );
      }

      const newTab: AnyTab = {
        tabId: tabId,
        mnuDesc: freshMenu.mnuDesc,
        mnuId: freshMenu.mnuId,
        routePath: freshMenu.routePath,
        mnuUrl: menuPath?.map(m => m.mnuUrl).join('/') ?? '',
        mnuMsgId: freshMenu.mnuMsgId,
        closable: true,
      };
      set(state => {
        state.tabs = [...state.tabs, newTab];
        state.activeIndex = state.tabs.length - 1;
      });
    },
    setActiveTab: tabIndex => {
      set(state => {
        state.activeIndex = tabIndex;
      });
    },
    closeTab: tabIndex => {
      if (tabIndex === -1) return;
      const tab = get().tabs[tabIndex];
      if (!tab?.closable) return;

      // ⭐ 미저장 변경 가드 — 탭의 그리드에 저장 안 한 변경(I/M/D)이 있으면 confirm 후 닫는다.
      void confirmIfTabDirty(tab.tabId).then(ok => {
        if (!ok) return;
        set(state => {
          // confirm 대기 중 탭 목록이 바뀌었을 수 있으므로 tabId 로 다시 찾는다
          const index = state.tabs.findIndex(t => t.tabId === tab.tabId);
          if (index === -1) return;
          state.tabs.splice(index, 1);
          if (state.activeIndex >= index) state.activeIndex -= 1;
        });
      });
    },
    closeOtherTabs: () => {
      const { activeIndex, tabs } = get();
      const keep = tabs[activeIndex];
      const closing = tabs.filter(tab => tab.closable && tab !== keep);

      void confirmIfTabsDirty(closing.map(tab => tab.tabId)).then(ok => {
        if (!ok) return;
        if (activeIndex === 0) {
          set({ ...initMDIState });
        } else {
          set(state => {
            state.tabs = [...initMDIState.tabs, keep];
            state.activeIndex = 1;
          });
        }
      });
    },
    closeAllTabs: () => {
      const closing = get().tabs.filter(tab => tab.closable);
      void confirmIfTabsDirty(closing.map(tab => tab.tabId)).then(ok => {
        if (ok) set({ ...initMDIState });
      });
    },
  }),
  'MDI-store'
);
