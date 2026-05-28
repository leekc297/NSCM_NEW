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
 */
export const createPersistedStoreWithTab = <T extends BaseTabState>(
  stateCreator: PersistedImmerCreator<T & BaseTabState>,
  storageName: string
) => {
  const storeRegistry = new Map<string, StoreApi<T & BaseTabState>>();

  return <U>(selector: (state: T) => U) => {
    const tabId = useContext(TabIdContext) ?? '';

    const storeKey = `${tabId}`;

    const store = storeRegistry.get(storeKey);

    if (store) return useStore(store, selector);
    else {
      const storeApi = createStore<T & BaseTabState>()(
        persist(
          immer((set, get, api) => {
            const initialState = stateCreator(set, get, api);

            const reset = () => {
              storeRegistry.delete(storeKey);
              useMotherStore.getState().unregister(storeKey);
            };
            registerStore(reset);

            return { ...initialState, _tabId: tabId };
          }),
          {
            name: storeKey,
            storage: createJSONStorage(() => sessionStorage),
          }
        )
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
