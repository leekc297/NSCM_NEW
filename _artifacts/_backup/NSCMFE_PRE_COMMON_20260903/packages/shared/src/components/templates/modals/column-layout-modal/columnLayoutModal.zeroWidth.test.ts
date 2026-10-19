import { describe, expect, it } from 'vitest';

import { toZeroWidthColumnSet } from './columnLayoutModal.utils';

/**
 * 사용자 지시 2026-08-22 — "GRID COLUMN SETTING 에서 WIDTH = 0 이면 목록에서 보이지 않도록".
 *
 * 이 테스트가 지키는 것은 **판정 축**이다. 폭 0 을 `ColumnLayoutRow.COL_WIDTH` 로 판정하려 들면
 * `mapBeRow` 의 `width > 0 ? width : DEFAULT_COL_WIDTH` 정규화 때문에 영원히 100 으로 보여
 * 조용히 무력화된다 — 그래서 raw 응답의 `COLUMN_WIDTH` 를 본다.
 */
describe('toZeroWidthColumnSet', () => {
  it('관리자 기본 폭이 0 이면 감춤 대상', () => {
    const set = toZeroWidthColumnSet([
      { COLUMN_NAME: 'TEAM_NAME_KO', COLUMN_WIDTH: '0' },
      { COLUMN_NAME: 'ITEM_ID', COLUMN_WIDTH: '120' },
    ]);
    expect([...set]).toEqual(['TEAM_NAME_KO']);
  });

  it('사용자 저장 폭만 0 이고 관리자 폭이 있으면 **감추지 않는다** (되살릴 길이 없어지므로)', () => {
    const set = toZeroWidthColumnSet([
      { COLUMN_NAME: 'A', COLUMN_WIDTH: '80', USER_COLUMN_WIDTH: '0' },
    ]);
    expect(set.size).toBe(0);
  });

  it('폭이 안 내려오면(null/공백) 감추지 않는다 — 메타 결손으로 목록이 비는 사고 방지', () => {
    const set = toZeroWidthColumnSet([
      { COLUMN_NAME: 'B', COLUMN_WIDTH: null as unknown as string },
      { COLUMN_NAME: 'C', COLUMN_WIDTH: '   ' },
      { COLUMN_NAME: 'D' } as Record<string, string>,
    ]);
    expect(set.size).toBe(0);
  });

  it('컬럼명이 공란인 행은 무시한다', () => {
    const set = toZeroWidthColumnSet([{ COLUMN_NAME: '', COLUMN_WIDTH: '0' }]);
    expect(set.size).toBe(0);
  });

  it('BE 응답이 없어 fallbackColumns 로 목록을 만드는 경로도 동일하게 판정한다', () => {
    const set = toZeroWidthColumnSet(
      [],
      [
        { key: 'E', header: 'E', width: 0 },
        { key: 'F', header: 'F', width: 90 },
        { key: 'G', header: 'G' },
      ]
    );
    expect([...set]).toEqual(['E']);
  });
});
