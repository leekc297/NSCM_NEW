import { describe, expect, it } from 'vitest';

import { computeReorder } from './columnLayoutList.utils';

describe('computeReorder', () => {
  const keys = ['a', 'b', 'c', 'd'];

  it('drag 을 target 위치로 이동한다 (아래로)', () => {
    expect(computeReorder(keys, 'a', 'c')).toEqual(['b', 'c', 'a', 'd']);
  });

  it('drag 을 target 위치로 이동한다 (위로)', () => {
    expect(computeReorder(keys, 'd', 'b')).toEqual(['a', 'd', 'b', 'c']);
  });

  it('from/to 가 같거나 없으면 원본 참조를 그대로 반환한다', () => {
    expect(computeReorder(keys, 'a', 'a')).toBe(keys);
    expect(computeReorder(keys, 'x', 'b')).toBe(keys);
  });
});
