import { beforeEach, describe, expect, it, vi } from 'vitest';

import {
  confirmIfDirtyKey,
  discardDirtyKey,
  registerDirtyCheck,
  registerDirtyReset,
} from './useDirtyRegistry';

vi.mock('@foundation/i18n', () => ({ t: (_code: string, fallback: string) => fallback }));

// vi.mock 팩토리는 import 보다 먼저 실행되므로 목 함수도 hoist 해서 만든다.
const { setAlert } = vi.hoisted(() => ({
  setAlert: vi.fn<(options: { type: string; content: string }) => Promise<boolean>>(),
}));
vi.mock('./useMessageStore', () => ({
  useMessageStore: { getState: () => ({ setAlert }) },
}));

const KEY = 'scope:test';

beforeEach(() => {
  setAlert.mockReset();
});

describe('registerDirtyReset / discardDirtyKey', () => {
  it('키에 등록된 되돌리기를 모두 호출하고, 해제 후에는 호출하지 않는다', () => {
    const first = vi.fn();
    const second = vi.fn();
    const unregisterFirst = registerDirtyReset([KEY], first);
    const unregisterSecond = registerDirtyReset([KEY], second);

    discardDirtyKey(KEY);
    expect(first).toHaveBeenCalledTimes(1);
    expect(second).toHaveBeenCalledTimes(1);

    unregisterFirst();
    discardDirtyKey(KEY);
    expect(first).toHaveBeenCalledTimes(1);
    expect(second).toHaveBeenCalledTimes(2);

    unregisterSecond();
  });

  it('되돌리기 하나가 던져도 나머지는 실행된다', () => {
    const thrower = vi.fn(() => {
      throw new Error('destroyed grid');
    });
    const survivor = vi.fn();
    const unregisterThrower = registerDirtyReset([KEY], thrower);
    const unregisterSurvivor = registerDirtyReset([KEY], survivor);

    expect(() => discardDirtyKey(KEY)).not.toThrow();
    expect(survivor).toHaveBeenCalledTimes(1);

    unregisterThrower();
    unregisterSurvivor();
  });

  it('등록된 되돌리기가 없는 키는 아무 일도 하지 않는다', () => {
    expect(() => discardDirtyKey('scope:없는키')).not.toThrow();
  });
});

describe('confirmIfDirtyKey', () => {
  it('확인을 누르면 등록된 변경을 실제로 되돌린다', async () => {
    const reset = vi.fn();
    const unregisterCheck = registerDirtyCheck([KEY], () => true);
    const unregisterReset = registerDirtyReset([KEY], reset);
    setAlert.mockResolvedValue(true);

    await expect(confirmIfDirtyKey(KEY, 'close')).resolves.toBe(true);
    expect(reset).toHaveBeenCalledTimes(1);

    unregisterCheck();
    unregisterReset();
  });

  it('취소를 누르면 되돌리지 않는다 — 편집분이 그대로 남아야 한다', async () => {
    const reset = vi.fn();
    const unregisterCheck = registerDirtyCheck([KEY], () => true);
    const unregisterReset = registerDirtyReset([KEY], reset);
    setAlert.mockResolvedValue(false);

    await expect(confirmIfDirtyKey(KEY, 'close')).resolves.toBe(false);
    expect(reset).not.toHaveBeenCalled();

    unregisterCheck();
    unregisterReset();
  });

  it('dirty 가 아니면 confirm 도 되돌리기도 없다', async () => {
    const reset = vi.fn();
    const unregisterCheck = registerDirtyCheck([KEY], () => false);
    const unregisterReset = registerDirtyReset([KEY], reset);

    await expect(confirmIfDirtyKey(KEY, 'search')).resolves.toBe(true);
    expect(setAlert).not.toHaveBeenCalled();
    expect(reset).not.toHaveBeenCalled();

    unregisterCheck();
    unregisterReset();
  });
});
