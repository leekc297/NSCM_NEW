import { apiClient } from '@foundation/apis';
import type { Menu, UserSession } from '@foundation/models';
import { clearAllPersistedCaches } from '@foundation/query-client';

import { createPersistedStore } from './createStore';

interface SessionState {
  isLogin: boolean;
  session: UserSession;
}

interface SessionAction {
  reset: () => void;
  login: (userId: string) => Promise<void>;
  logout: () => Promise<void>;
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

        // 인터셉터가 500/403 응답을 reject 하지 않고 그대로 resolve 하므로 result 가 없을 수 있다.
        // 검증 없이 저장하면 session=undefined + isLogin=true 가 sessionStorage 에 영속되어
        // 이후 모든 화면(Header 등)이 session.langCd 접근에서 깨진다.
        const session = sessionResult.data?.result;
        if (!session?.userId) throw new Error(sessionResult.data?.message ?? 'login failed');

        // 크래시/탭 강제종료로 로그아웃 정리(useClearAppData)와 unload 핸들러를 모두 놓친
        // 이전 세션의 영속 캐시를 여기서 회수한다. 로그아웃 시 삭제가 못 막는 유일한 경로다.
        // 필수: isLogin=true 커밋 전에 끝낸다. 뒤로 가면 로그인 직후 재조회된 쿼리가 채운
        // 캐시를 도로 지운다. 로그인 실패 경로(위 throw)에서는 호출되지 않는다.
        await clearAllPersistedCaches();

        set(state => {
          state.session = session;
          state.isLogin = true;
        });
      } catch (e) {
        console.error('Failed to fetch:', e);
        set(state => {
          state.isLogin = false;
        });
      }
    },
    // 서버 세션을 먼저 끊고 나서 로컬 상태를 비운다 — 호출부(Home)가 await 후 캐시를 정리할 수 있도록
    // Promise 를 반환한다. 기다리지 않으면 clearAllData() 가 아직 살아있는 서버 세션과 겹쳐,
    // queryClient.clear() 직후 재조회되는 쿼리들이 이전 계정 데이터로 캐시를 다시 채운다.
    // 요청이 실패해도 로컬은 반드시 로그아웃 상태로 만든다(로그아웃 못 하고 갇히는 상황 방지).
    logout: async () => {
      try {
        await apiClient.post('/user/logout');
      } catch (e) {
        console.error('Failed to logout:', e);
      }
      set(initSessionState);
    },
    fetchSession: async () => {
      try {
        const sessionResult = await apiClient.get<UserSession>('/user/session');

        // login() 과 동일한 가드. 비로그인 세션은 userId 가 null 인 빈 객체로 오므로 로그인 상태로 취급하지 않는다.
        const session = sessionResult.data?.result;
        if (!session?.userId) throw new Error(sessionResult.data?.message ?? 'no session');

        set(state => {
          state.session = session;
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
