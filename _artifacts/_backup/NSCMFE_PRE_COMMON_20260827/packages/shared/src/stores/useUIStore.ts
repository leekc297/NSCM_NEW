import type { Menu } from '@foundation/models';

import { createPersistedStore } from './createStore';

interface UIState {
  sidebarOpen: boolean;
  sidebarMenu: Menu;
  /**
   * 사이드바에서 펼쳐둘 2레벨 그룹의 mnuId.
   * 새 탭이 열릴 때(openTab) 그 메뉴의 상위 그룹으로 설정되어 해당 그룹이 자동으로 펼쳐진다.
   * 사용자가 직접 접고 펴는 것과는 별개 — SidebarMenu 의 로컬 상태를 덮어쓰는 용도.
   */
  sidebarOpenGroupId?: string;
  progress: number;
  /** Page 영역(활성 탭 뷰) 전체화면 여부 — MainTitle 의 전체화면 아이콘이 토글, ViewContainer 가 적용 */
  pageFullscreen: boolean;
}

interface UIAction {
  toggleSidebar: () => void;
  setSidebarOpen: (open: boolean) => void;
  setSidebarMenu: (menu: Menu) => void;
  /** 새 탭이 열릴 때 사이드바를 그 메뉴에 맞춰 전환한다(상단 메뉴 교체 + 그룹 펼침 + 열기) */
  syncSidebarToMenu: (rootMenu: Menu, groupId?: string) => void;
  setProgress: (progress: number) => void;
  setPageFullscreen: (fullscreen: boolean) => void;
  togglePageFullscreen: () => void;
}

const initUIState: UIState = {
  sidebarOpen: false,
  sidebarMenu: {} as Menu,
  sidebarOpenGroupId: undefined,
  progress: 0,
  pageFullscreen: false,
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
    syncSidebarToMenu: (rootMenu, groupId) => {
      set(state => {
        state.sidebarMenu = rootMenu;
        state.sidebarOpenGroupId = groupId;
        state.sidebarOpen = true;
      });
    },
    setProgress: progress => {
      set(state => {
        if (progress < 100) state.progress = progress;
        else state.progress = 0;
      });
    },
    setPageFullscreen: fullscreen => {
      set(state => {
        state.pageFullscreen = fullscreen;
      });
    },
    togglePageFullscreen: () => {
      set(state => {
        state.pageFullscreen = !state.pageFullscreen;
      });
    },
  }),
  'UI-store'
);
