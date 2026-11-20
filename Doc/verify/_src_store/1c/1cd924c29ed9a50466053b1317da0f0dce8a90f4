// export zustand
import { createContext, useContext } from 'react';
import { create, createStore, useStore } from 'zustand';
import type { StateCreator, StoreApi, UseBoundStore } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import { immer } from 'zustand/middleware/immer';

import { registerStore } from './storeRegistry';
import { useMotherStore } from './useGloablStore';

export { useStore } from 'zustand';

export const TabIdContext = createContext<string | undefined>(undefined);

export const useTabid = () => useContext(TabIdContext) ?? '';

/**
 * 현재 탭 화면의 mnuId(= 화면 코드, 예 'DMF0003'). ViewContainer 가 탭마다 Provider 로 심는다.
 *
 * 콤보 SQL(SCM_ADM_CMBO_SQL_M)의 @mnuId 는 BE makeComboQuery 가 이 값으로 치환한다(PROGRAM_ID = @mnuId
 * 같은 화면 스코프 콤보). 세션 값인 @sesUserId 와 달리 mnuId 는 "어느 화면이 호출했나"라 BE 세션만으로는
 * 알 수 없어 호출부가 실어 보내야 한다. 이 컨텍스트를 콤보 훅(useTabComboQueries/useTabComboQuery)이 읽어
 * 검색조건·그리드 콤보 전부에 mnuId 를 기본 주입한다 — 화면별 하드코딩 없이 sesUserId 처럼 기본값이 된다.
 *
 * 전역 활성 탭이 아니라 "호출한 화면 자신"의 값이라 백그라운드(keep-alive) 탭 재조회에도 오염되지 않는다.
 */
export const MenuIdContext = createContext<string | undefined>(undefined);

export const useMenuId = () => useContext(MenuIdContext);

export interface BaseTabState<T = Record<keyof object, object>> {
  _tabId?: string;
  reset: () => void;
  searchParams?: T;
  setSearchParams?: (searchParams: Partial<T>) => void;
  filters?: unknown; // ProcRequest<MenuId, SheetName<MenuId>>
  setFilters?: unknown; // (filters: ProcRequest<MenuId, SheetName<MenuId>>) => void
}

type PersistedImmerCreator<T> = StateCreator<T, [['zustand/immer', never]], []>;
/**
 * 전역 스토어 선언시 사용.
 * 싱글톤 스토어 빌더
 * use...Store.getState() 사용 가능
 */
export const createPersistedStore = <T extends object>(
  stateCreator: PersistedImmerCreator<T>,
  storageName: string
) => {
  return create<T>()(
    persist(
      immer((set, get, api) => {
        const initialState = stateCreator(set, get, api);

        const reset = () => {
          set(initialState);
        };

        registerStore(reset);

        return initialState;
      }),
      {
        name: `${storageName}`,
        storage: createJSONStorage(() => sessionStorage),
      }
    )
  ) as UseBoundStore<StoreApi<T>>;
};

/**
 * 탭 내부 페이지 스토어 선언시 사용.
 * 현재 오픈된 tabId에 따른 멀티톤 인스턴스 생성.
 * use...Store.getState() 사용 불가.
 *
 * 영속화하지 않는다(sessionStorage 미저장).
 *  - 탭 전환 시 상태 유지는 MDI keep-alive(ViewContainer) + 아래 storeRegistry(모듈 레벨 Map)가
 *    이미 메모리로 보장한다. 페이지가 언마운트돼도 storeRegistry 가 인스턴스를 잡고 있어 상태가 산다.
 *  - sessionStorage 영속화는 오직 "새로고침 생존" 용도였는데, 새로고침 시에는 검색조건/그리드가
 *    초기화되는 것이 요구사항이다(활성 탭만 컬럼을 새로 조회, 조건은 빈 상태). 그래서 persist 를 뺀다.
 */
export const createPersistedStoreWithTab = <T extends BaseTabState>(
  stateCreator: PersistedImmerCreator<T & BaseTabState>,
  _storageName: string
) => {
  const storeRegistry = new Map<string, StoreApi<T & BaseTabState>>();

  return <U>(selector: (state: T) => U) => {
    const tabId = useContext(TabIdContext) ?? '';

    const storeKey = `${tabId}`;

    const store = storeRegistry.get(storeKey);

    if (store) return useStore(store, selector);
    else {
      const storeApi = createStore<T & BaseTabState>()(
        immer((set, get, api) => {
          const initialState = stateCreator(set, get, api);

          const reset = () => {
            storeRegistry.delete(storeKey);
            useMotherStore.getState().unregister(storeKey);
          };
          registerStore(reset);

          return { ...initialState, _tabId: tabId };
        })
      ) as StoreApi<T & BaseTabState>;
      storeRegistry.set(storeKey, storeApi);
      useMotherStore.getState().register(storeKey, storeApi);
      return useStore(storeApi, selector);
    }
  };
};

export type PersistedStore<T extends BaseTabState> = ReturnType<
  typeof createPersistedStoreWithTab<T>
>;

type StandardImmerCreator<T> = StateCreator<T, [['zustand/immer', never]], []>;

export const createStandardStore = <T extends object>(
  stateCreator: StandardImmerCreator<T>,
  _storeName: string
) => {
  return create<T>()(
    immer((set, get, api) => {
      const initialState = stateCreator(set, get, api);

      const reset = () => {
        set(initialState);
      };

      registerStore(reset);

      return initialState;
    })
  ) as UseBoundStore<StoreApi<T>>;
};
