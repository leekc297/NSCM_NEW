import { beforeAll, beforeEach, describe, expect, it } from 'vitest';

import { createPersistedStore, createStandardStore } from './createStore';
import { resetAllStores } from './storeRegistry';

type CounterState = {
  count: number;
  inc: () => void;
};

const createMemoryStorage = () => {
  const storage = new Map<string, string>();

  return {
    getItem: (key: string) => storage.get(key) ?? null,
    setItem: (key: string, value: string) => {
      storage.set(key, value);
    },
    removeItem: (key: string) => {
      storage.delete(key);
    },
    clear: () => {
      storage.clear();
    },
  };
};

beforeAll(() => {
  // Vitest/node 환경에서 persist 미들웨어가 참조할 sessionStorage를 주입한다.
  Object.defineProperty(globalThis, 'sessionStorage', {
    value: createMemoryStorage(),
    configurable: true,
  });
});

beforeEach(() => {
  resetAllStores();
  globalThis.sessionStorage.clear();
});

describe('createStore helpers', () => {
  it('createStandardStore: state updates and can be reset by resetAllStores', () => {
    const useCounterStore = createStandardStore<CounterState>(
      set => ({
        count: 0,
        inc: () => set(state => void (state.count += 1)),
      }),
      'counter-standard'
    );

    expect(useCounterStore.getState().count).toBe(0);

    useCounterStore.getState().inc();
    useCounterStore.getState().inc();
    expect(useCounterStore.getState().count).toBe(2);

    resetAllStores();
    expect(useCounterStore.getState().count).toBe(0);
  });

  it('createPersistedStore: creates store and updates state without crashing', () => {
    const usePersistedCounterStore = createPersistedStore<CounterState>(
      set => ({
        count: 0,
        inc: () => set(state => void (state.count += 1)),
      }),
      'counter-persisted'
    );

    expect(usePersistedCounterStore.getState().count).toBe(0);

    usePersistedCounterStore.getState().inc();
    expect(usePersistedCounterStore.getState().count).toBe(1);
  });
});
