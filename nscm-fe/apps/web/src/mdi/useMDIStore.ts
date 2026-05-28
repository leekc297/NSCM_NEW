/* @refresh reload */
import { ROUTE_PATHS } from '@foundation/constants';
import type { Menu } from '@foundation/models';
import { getUuid } from '@foundation/utils';
import { createPersistedStore, useSessionStore } from '@shared/stores';

import { router } from '../core/Router';

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

const navigate = (path: string, tabIndex: number) => {
  void router.navigate('/' + path, { state: tabIndex });
};

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
        set(state => (state.activeIndex = 0));
        return;
      }
      const existingTab = get().tabs.some(t => t.mnuId === menu.mnuId);

      if (existingTab) {
        // TODO: setMessage(이미 열린 탭이 있습니다. 또 여시겠습니까?)
      }

      const tabId = getUuid();

      const newTab: AnyTab = {
        tabId: tabId,
        mnuDesc: menu.mnuDesc,
        mnuId: menu.mnuId,
        mnuUrl:
          useSessionStore
            .getState()
            .findMenuPath(menu.mnuId as string)
            ?.map(menu => menu.mnuUrl)
            .join('/') ?? '',
        mnuMsgId: menu.mnuMsgId,
        closable: true,
      };
      set(state => {
        state.tabs = [...state.tabs, newTab];
        state.activeIndex = state.tabs.length - 1;
      });
      const { activeIndex, tabs } = get();
      navigate(tabs[activeIndex].mnuUrl, activeIndex);
    },
    setActiveTab: tabIndex => {
      set(state => {
        state.activeIndex = tabIndex;
      });
      const { activeIndex, tabs } = get();
      navigate(tabs[activeIndex].mnuUrl, activeIndex);
    },
    closeTab: tabIndex => {
      set(state => {
        if (tabIndex === -1) return;
        if (!state.tabs[tabIndex]?.closable) return;

        state.tabs.splice(tabIndex, 1);

        if (state.activeIndex >= tabIndex) state.activeIndex -= 1;
      });
      const { activeIndex, tabs } = get();
      navigate(tabs[activeIndex].mnuUrl, activeIndex);
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
      navigate(tabs[activeIndex].mnuUrl, activeIndex);
    },
    closeAllTabs: () => {
      set({ ...initMDIState });
      const { activeIndex, tabs } = get();
      navigate(tabs[activeIndex].mnuUrl, activeIndex);
    },
  }),
  'MDI-store'
);
