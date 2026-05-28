import type { StoreApi } from 'zustand';
import { create } from 'zustand';
import { immer } from 'zustand/middleware/immer';

import type { BaseTabState } from './createStore';

interface MotherStoreState {
  registory: Map<string, StoreApi<BaseTabState>>;
}

interface MotherStoreActions {
  get: (key: string) => BaseTabState | null;
  register: (key: string, store: StoreApi<BaseTabState>) => void;
  unregister: (key: string) => void;
}

type MotherStore = MotherStoreState & MotherStoreActions;

export const useMotherStore = create<MotherStore>()(
  immer((set, get) => ({
    registory: new Map(),

    get: (key: string) => {
      const { registory } = get();
      const store = registory.get(key);
      if (store) return store.getState();
      return null;
    },

    register: (key: string, store: StoreApi<BaseTabState>) => {
      const { registory } = get();
      registory.set(key, store);
    },

    unregister: (key: string) => {
      set(state => {
        state.registory.delete(key);
      });
      sessionStorage.removeItem(key);
    },
  }))
);
