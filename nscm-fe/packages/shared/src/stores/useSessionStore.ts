import { apiClient } from '@foundation/apis';
import type { Menu, UserSession } from '@foundation/models';

import { createPersistedStore } from './createStore';

interface SessionState {
  isLogin: boolean;
  session: UserSession;
}

interface SessionAction {
  reset: () => void;
  login: (userId: string) => Promise<void>;
  logout: () => void;
  fetchSession: () => Promise<void>;
  findMenuPath: (menuId: string) => Menu[] | null;
  changeLanguage: (langCd: string) => void;
  toggleFavorite: (menuId: string, favorite: boolean) => void;
}

const initSessionState: SessionState = {
  isLogin: false,
  session: {} as UserSession,
};

export const useSessionStore = createPersistedStore<SessionState & SessionAction>(
  (set, get) => ({
    ...initSessionState,
    reset: () => set(() => ({ ...initSessionState })),
    login: async userId => {
      try {
        const sessionResult = await apiClient.post<UserSession>('/user/login', {
          userId: userId,
        });

        set(state => {
          state.session = sessionResult.data.result;
          state.isLogin = true;
        });
      } catch (e) {
        console.error('Failed to fetch:', e);
        set(state => {
          state.isLogin = false;
        });
      }
    },
    logout: () => {
      void apiClient.post('/user/logout').then(() => set(initSessionState));
    },
    fetchSession: async () => {
      try {
        const sessionResult = await apiClient.get<UserSession>('/user/session');

        set(state => {
          state.session = sessionResult.data.result;
          state.isLogin = true;
        });
      } catch (e) {
        console.error('Failed to fetch:', e);

        set(state => {
          state.isLogin = false;
        });
      }
    },
    findMenuPath: menuId => {
      const { session } = get();
      if (!session.menus) return null;
      const findMenuPath = (menus: Menu[], targetId: string): Menu[] | null => {
        for (const menu of menus) {
          if (menu.mnuId === targetId) {
            return [menu];
          }

          if (menu.children && menu.children.length > 0) {
            const path = findMenuPath(menu.children, targetId);

            if (path) {
              return [menu, ...path];
            }
          }
        }

        return null;
      };
      return findMenuPath(session.menus, menuId);
    },
    changeLanguage: langCd => {
      void apiClient
        .post('/user/session/lang-cd', { langCd: langCd })
        .then(() => get().fetchSession());
    },
    toggleFavorite: (menuId, favorite) => {
      void apiClient
        .post('/admin/menu/favorite', { mnuId: menuId, favorite })
        .then(() => get().fetchSession());
    },
  }),
  'Session-store'
);
