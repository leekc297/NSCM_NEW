import { describe, it, expect, beforeEach } from 'vitest';

import { MAX_MOUNTED_TABS } from './mdi.config';
import { useTabActivation } from './useTabActivation';

const reset = () => useTabActivation.setState({ activated: {}, mru: [] });
const activate = (tabId: string, protectedIds?: readonly string[]) =>
  useTabActivation.getState().activate(tabId, protectedIds);
const state = () => useTabActivation.getState();

// t0, t1, ... 순서로 활성화(t0 이 가장 오래됨)
const activateSequence = (count: number, protectedIds?: readonly string[]) => {
  for (let i = 0; i < count; i++) activate(`t${i}`, protectedIds);
};

describe('useTabActivation LRU 언마운트', () => {
  beforeEach(reset);

  it('상한 이하에서는 아무 탭도 언마운트하지 않는다', () => {
    activateSequence(MAX_MOUNTED_TABS);
    expect(Object.keys(state().activated).length).toBe(MAX_MOUNTED_TABS);
    expect(state().activated.t0).toBe(true);
  });

  it('상한을 넘으면 가장 오래된(LRU) 탭부터 언마운트한다', () => {
    activateSequence(MAX_MOUNTED_TABS + 2); // t0..t{MAX+1}

    const { activated } = state();
    expect(Object.keys(activated).length).toBe(MAX_MOUNTED_TABS);
    // 가장 오래된 두 개(t0, t1) 언마운트
    expect(activated.t0).toBeUndefined();
    expect(activated.t1).toBeUndefined();
    // 최근 것들은 유지 (마지막 = 활성 탭)
    expect(activated[`t${MAX_MOUNTED_TABS + 1}`]).toBe(true);
    expect(activated[`t${MAX_MOUNTED_TABS}`]).toBe(true);
  });

  it('방금 활성화된(활성) 탭은 언마운트하지 않는다', () => {
    activateSequence(MAX_MOUNTED_TABS + 1); // 마지막 t{MAX} 가 활성
    expect(state().activated[`t${MAX_MOUNTED_TABS}`]).toBe(true);
  });

  it('보호(dirty) 탭은 LRU여도 언마운트하지 않고 다음으로 오래된 탭을 대신 언마운트한다', () => {
    // t0 을 계속 보호하면서 상한을 1개 초과시킨다
    activateSequence(MAX_MOUNTED_TABS + 1, ['t0']); // t0..t{MAX}

    const { activated } = state();
    expect(Object.keys(activated).length).toBe(MAX_MOUNTED_TABS);
    expect(activated.t0).toBe(true); // 보호 — 유지
    expect(activated.t1).toBeUndefined(); // 대신 다음으로 오래된 것 언마운트
  });

  it('다시 활성화하면 MRU 앞으로 이동해 언마운트에서 밀려난다', () => {
    activateSequence(MAX_MOUNTED_TABS); // t0..t{MAX-1}, t0 이 가장 오래됨
    activate('t0'); // t0 을 다시 활성화 → 최신
    activate('new'); // 상한 초과 유발

    const { activated } = state();
    expect(Object.keys(activated).length).toBe(MAX_MOUNTED_TABS);
    expect(activated.t0).toBe(true); // 재활성화로 보호됨
    expect(activated.t1).toBeUndefined(); // 이제 t1 이 가장 오래됨 → 언마운트
  });

  it('pruneTo 는 닫힌 탭을 이력에서 제거한다', () => {
    activate('a');
    activate('b');
    activate('c');
    useTabActivation.getState().pruneTo(['a', 'c']);

    const { activated, mru } = state();
    expect(activated.a).toBe(true);
    expect(activated.b).toBeUndefined();
    expect(activated.c).toBe(true);
    expect(mru).not.toContain('b');
  });
});
