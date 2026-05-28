import type { Menu } from '@foundation/models';

import { createPersistedStore } from './createStore';

interface UIState {
  sidebarOpen: boolean;
  sidebarMenu: Menu;
  progress: number;
}

interface UIAction {
  toggleSidebar: () => void;
  setSidebarOpen: (open: boolean) => void;
  setSidebarMenu: (menu: Menu) => void;
  setProgress: (progress: number) => void;
}

const initUIState: UIState = {
  sidebarOpen: false,
  sidebarMenu: {} as Menu,
  progress: 0,
};

export const useUIStore = createPersistedStore<UIState & UIAction>(
  (set, _get) => ({
    ...initUIState,
    toggleSidebar: () => {
      set(state => {
        state.sidebarOpen = !!state.sidebarMenu.mnuId && !state.sidebarOpen;
      });
    },
    setSidebarOpen: open => {
      set(state => {
        state.sidebarOpen = open;
      });
    },
    setSidebarMenu: menu => {
      set(state => {
        state.sidebarMenu = menu;
      });
    },
    setProgress: progress => {
      set(state => {
        if (progress < 100) state.progress = progress;
        else state.progress = 0;
      });
    },
  }),
  'UI-store'
);
