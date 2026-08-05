import { renderHook, act } from '@testing-library/react';
import { describe, it, expect, beforeEach } from 'vitest';

import type { Menu } from '@foundation/models';

import { useMDIStore } from './useMDIStore';

// 타 컴포넌트 혹은 API 등의 side effect 가능한 callback -> act 사용 필요
// renderHook을 통해 result.current로 snapshot 없이 or useStore.getState()를 통해 snapshot 계속해서 갱신

const PROC_NAME = 'DMF0082' as const;
type PROC_NAME = typeof PROC_NAME;

const testTab: Omit<Menu, 'children'> = {
  mnuId: 'test',
  upprMnuId: null,
  mnuUrl: '/test',
  mnuMsgId: 'TEST' as translation,
  mnuDesc: 'test',
};

describe('mdiStore', () => {
  beforeEach(() => {
    const { result } = renderHook(() => useMDIStore());
    localStorage.clear();
    act(() => {
      result.current.closeAllTabs();
    });
    expect(result.current.tabs.length).toBe(1);
    expect(result.current.activeIndex).toBe(0);
  });

  it('test: open tab', () => {
    const { result } = renderHook(() => useMDIStore());

    act(() => result.current.openTab(testTab));
    expect(result.current.tabs.length).toBe(2);
    expect(result.current.activeIndex).toBe(1);

    act(() => result.current.openTab(testTab));
    expect(result.current.tabs.length).toBe(3);
    expect(result.current.activeIndex).toBe(2);
  });

  it('test: close tab', () => {
    const { result } = renderHook(() => useMDIStore());

    act(() => {
      result.current.openTab(testTab);
    });
    act(() => {
      result.current.openTab(testTab);
    });
    act(() => {
      result.current.openTab(testTab);
    });
    act(() => {
      result.current.openTab(testTab);
    });

    expect(result.current.tabs.length).toBe(5);
    expect(result.current.activeIndex).toBe(4);

    // close home
    act(() => result.current.closeTab(0));
    expect(result.current.tabs.length).toBe(5);
    expect(result.current.activeIndex).toBe(4);

    // close tab
    act(() => result.current.closeTab(1));
    expect(result.current.tabs.length).toBe(4);
    expect(result.current.activeIndex).toBe(3);

    // close active tab
    act(() => result.current.closeTab(3));
    expect(result.current.tabs.length).toBe(3);
    expect(result.current.activeIndex).toBe(2);

    // close other tabs
    act(() => result.current.closeOtherTabs());
    expect(result.current.tabs.length).toBe(2);
    expect(result.current.activeIndex).toBe(1);

    // close all tabs
    act(() => result.current.closeAllTabs());
    expect(result.current.tabs.length).toBe(1);
    expect(result.current.activeIndex).toBe(0);
  });

  it('test: set active tab', () => {
    const { result } = renderHook(() => useMDIStore());
    expect(result.current.activeIndex).toBe(0);

    act(() => result.current.openTab(testTab));
    expect(result.current.activeIndex).toBe(1);

    act(() => result.current.openTab(testTab));
    expect(result.current.activeIndex).toBe(2);

    act(() => result.current.setActiveTab(1));
    expect(result.current.activeIndex).toBe(1);

    act(() => result.current.setActiveTab(1));
    expect(result.current.activeIndex).toBe(1);
  });

  it('test: set filters', () => {
    const { result } = renderHook(() => useMDIStore());

    act(() => result.current.openTab(testTab));
  });
});
