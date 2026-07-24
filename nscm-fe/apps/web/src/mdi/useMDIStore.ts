/* @refresh reload */
import { ROUTE_PATHS } from '@foundation/constants';
import type { Menu } from '@foundation/models';
import { getUuid } from '@foundation/utils';
import { createPersistedStore, useSessionStore, useUIStore } from '@shared/stores';

import { MDI_TAB_MODE } from './mdi.config';
import type { AnyTab } from './MDI.types';

interface MDIState {
  tabs: AnyTab[];
  activeIndex: number;
}

interface MDIActions {
  openTab: (menu: Omit<Menu, 'children' | 'sortOrd'>) => void;
  setActiveTab: (tabIndex: number) => void;
  setActiveByTabId: (tabId: string) => void;
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
      if (menu.mnuUrl === '/home') {
        set(state => {
          state.activeIndex = 0;
        });
        return;
      }

      // single 모드: 이미 열린 같은 메뉴가 있으면 새 탭 대신 그 탭으로 포커스
      if (MDI_TAB_MODE === 'single') {
        const existingIndex = get().tabs.findIndex(t => t.mnuId === menu.mnuId);
        if (existingIndex >= 0) {
          set(state => {
            state.activeIndex = existingIndex;
          });
          return;
        }
      }

      const tabId = getUuid();

      const menuPath = useSessionStore.getState().findMenuPath(menu.mnuId as string);

      // 사이드바를 이 메뉴에 맞춰 전환한다 — 링크/URL/즐겨찾기로 들어와도 좌측 메뉴가 따라오도록.
      // path = [상단메뉴, (2레벨 그룹), ..., 리프] 이므로 path[0] 이 사이드바에 띄울 상단 메뉴,
      // path[1] 은 펼쳐야 할 그룹이다(2단 메뉴면 path[1] 이 리프 자신이라 펼칠 그룹이 없다).
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
        mnuDesc: menu.mnuDesc,
        mnuId: menu.mnuId,
        routePath: menu.routePath,
        mnuUrl: menuPath?.map(m => m.mnuUrl).join('/') ?? '',
        mnuMsgId: menu.mnuMsgId,
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
    setActiveByTabId: tabId => {
      const idx = get().tabs.findIndex(t => t.tabId === tabId);
      if (idx >= 0)
        set(state => {
          state.activeIndex = idx;
        });
    },
    closeTab: tabIndex => {
      set(state => {
        if (tabIndex === -1) return;
        if (!state.tabs[tabIndex]?.closable) return;

        state.tabs.splice(tabIndex, 1);

        if (state.activeIndex >= tabIndex) state.activeIndex -= 1;
      });
    },
    closeOtherTabs: () => {
      const { activeIndex, tabs } = get();
      if (activeIndex === 0) {
        set({ ...initMDIState });
      } else {
        const tab = tabs[activeIndex];
        set(state => {
          state.tabs = [...initMDIState.tabs, tab];
          state.activeIndex = 1;
        });
      }
    },
    closeAllTabs: () => {
      set({ ...initMDIState });
    },
  }),
  'MDI-store'
);
