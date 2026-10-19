import type { FlexGrid } from '@mescius/wijmo.grid';
import { describe, expect, it } from 'vitest';

import { EditTracker } from './editTracker';
import { GridAction, keepRowVisibleUnderFilter, revertRowChanges } from './gridAction';

/** FlexGridFilter 가 실제로 참조하는 필드만 가진 최소 grid. */
type FakeGrid = { _newAddedRowsSet?: WeakSet<object> };

const asGrid = (fake: FakeGrid) => fake as unknown as FlexGrid<WijmoRowItem>;

/** FlexGridFilter._filter 와 같은 판정 — 예외 Set 에 있으면 조건 검사 없이 통과. */
const filterLikeWijmo = (
  grid: FakeGrid,
  row: WijmoRowItem,
  matches: (row: WijmoRowItem) => boolean
) => (grid._newAddedRowsSet?.has(row) ?? false) || matches(row);

/**
 * discardChanges 가 실제로 만지는 것만 가진 최소 그리드.
 * CustomMergeManager / EditTracker 가 생성 시 구독하는 이벤트도 함께 흉내낸다.
 */
const createDiscardGrid = (source: WijmoRowItem[]) => {
  const event = () => ({ addHandler: () => undefined });
  const collectionView = {
    sourceCollection: source,
    collectionChanged: event(),
    clearChangesCount: 0,
    refreshCount: 0,
    clearChanges() {
      this.clearChangesCount += 1;
    },
    refresh() {
      this.refreshCount += 1;
    },
  };

  const grid = {
    collectionView,
    mergeManager: null as unknown,
    finishEditingCount: 0,
    finishEditing() {
      this.finishEditingCount += 1;
      return true;
    },
    invalidate: () => undefined,
    // CustomMergeManager 구독 대상
    cellEditEnded: event(),
    loadedRows: event(),
    itemsSourceChanged: event(),
    sortedColumn: event(),
    // EditTracker 구독 대상
    beginningEdit: event(),
    pastingCell: event(),
    pastedCell: event(),
    formatItem: event(),
  };

  return { grid, collectionView };
};

const asDiscardGrid = (grid: ReturnType<typeof createDiscardGrid>['grid']) =>
  grid as unknown as FlexGrid<WijmoRowItem>;

describe('revertRowChanges (그리드 없이 데이터만으로 되돌리기 — 언마운트 경로)', () => {
  it('그리드 인스턴스 없이도 신규행 제거와 마킹 해제를 한다', () => {
    const rows: WijmoRowItem[] = [
      { ID: 'new', CRUD_TYPE: 'I' },
      { ID: 'del', CRUD_TYPE: 'D' },
      { ID: 'mod', CRUD_TYPE: 'M' },
      { ID: 'kept' },
    ];

    expect(revertRowChanges(rows)).toBe(true);

    expect(rows).toEqual([{ ID: 'del' }, { ID: 'mod' }, { ID: 'kept' }]);
  });

  it('EditTracker 가 파괴된 그리드를 물고 있어도 값 복원까지는 마친다', () => {
    const row: WijmoRowItem = { ID: 'a', QTY: 999 };
    const { grid } = createDiscardGrid([row]);
    const tracker = new EditTracker(asDiscardGrid(grid));
    tracker.storeChange(row, 'QTY', 100, 999);

    // 언마운트 후처럼 그리드가 죽은 상황 — clearChanges 내부의 invalidate 가 던진다.
    grid.invalidate = () => {
      throw new Error('disposed control');
    };

    expect(() => revertRowChanges([row], tracker)).not.toThrow();
    expect(row['QTY']).toBe(100);
    expect(row.CRUD_TYPE).toBeUndefined();
  });

  it('되돌릴 것이 없거나 배열이 없으면 false', () => {
    expect(revertRowChanges([{ ID: 'a' }])).toBe(false);
    expect(revertRowChanges(undefined)).toBe(false);
    expect(revertRowChanges(null)).toBe(false);
  });
});

describe('GridAction.discardChanges', () => {
  it('신규행(I)을 화면이 넘긴 배열에서 직접 제거한다 (배열 참조 유지)', () => {
    const source: WijmoRowItem[] = [
      { ID: 'new1', CRUD_TYPE: 'I' },
      { ID: 'kept' },
      { ID: 'new2', CRUD_TYPE: 'I' },
    ];
    const { grid } = createDiscardGrid(source);

    const discarded = GridAction.discardChanges(asDiscardGrid(grid));

    expect(discarded).toBe(true);
    // 새 배열로 교체하면 화면/react-query 캐시가 든 배열은 오염된 채 남는다 — 같은 배열이어야 한다.
    expect(grid.collectionView.sourceCollection).toBe(source);
    expect(source).toEqual([{ ID: 'kept' }]);
  });

  it('기존 행의 삭제(D)/수정(M) 마킹을 해제한다', () => {
    const source: WijmoRowItem[] = [
      { ID: 'a', CRUD_TYPE: 'D' },
      { ID: 'b', CRUD_TYPE: 'M' },
    ];
    const { grid } = createDiscardGrid(source);

    GridAction.discardChanges(asDiscardGrid(grid));

    expect(source).toHaveLength(2);
    expect(source.every(row => row.CRUD_TYPE === undefined)).toBe(true);
  });

  it('EditTracker 가 기록한 원본값으로 셀을 되돌린다', () => {
    const row: WijmoRowItem = { ID: 'a', QTY: 100, NAME: '원본' };
    const { grid } = createDiscardGrid([row]);
    const tracker = new EditTracker(asDiscardGrid(grid));

    // 사용자가 두 셀을 고침 — storeChange 가 원본을 기록하고 CRUD_TYPE 을 M 으로 만든다.
    tracker.storeChange(row, 'QTY', 100, 999);
    tracker.storeChange(row, 'NAME', '원본', '수정본');
    row['QTY'] = 999;
    row['NAME'] = '수정본';
    expect(row.CRUD_TYPE).toBe('M');

    GridAction.discardChanges(asDiscardGrid(grid), tracker);

    expect(row['QTY']).toBe(100);
    expect(row['NAME']).toBe('원본');
    expect(row.CRUD_TYPE).toBeUndefined();
    expect(tracker.hasChanges()).toBe(false);
  });

  it('편집 중인 셀을 먼저 끝내고 CollectionView 변경 추적도 비운다', () => {
    const { grid, collectionView } = createDiscardGrid([{ ID: 'a', CRUD_TYPE: 'I' }]);

    GridAction.discardChanges(asDiscardGrid(grid));

    // finishEditing 이 먼저여야 EditTracker 가 원본을 기록한 뒤 되돌릴 수 있다.
    expect(grid.finishEditingCount).toBe(1);
    expect(collectionView.clearChangesCount).toBe(1);
    expect(collectionView.refreshCount).toBe(1);
  });

  it('되돌릴 변경이 없으면 false, 그리드가 없으면 아무 일도 하지 않는다', () => {
    const { grid } = createDiscardGrid([{ ID: 'a' }, { ID: 'b' }]);

    expect(GridAction.discardChanges(asDiscardGrid(grid))).toBe(false);
    expect(GridAction.discardChanges(undefined)).toBe(false);
    expect(GridAction.discardChanges(null)).toBe(false);
  });
});

describe('keepRowVisibleUnderFilter', () => {
  it('예외 Set 이 없으면 만들어서 행을 등록한다', () => {
    const grid: FakeGrid = {};
    const row = { CRUD_TYPE: 'I' } as WijmoRowItem;

    keepRowVisibleUnderFilter(asGrid(grid), row);

    expect(grid._newAddedRowsSet?.has(row)).toBe(true);
  });

  it('필터가 이미 만든 예외 Set 을 재사용한다 (교체하지 않는다)', () => {
    const existing = new WeakSet<object>();
    const alreadyExcluded = { CRUD_TYPE: 'I' } as WijmoRowItem;
    existing.add(alreadyExcluded);
    const grid: FakeGrid = { _newAddedRowsSet: existing };
    const row = { CRUD_TYPE: 'I' } as WijmoRowItem;

    keepRowVisibleUnderFilter(asGrid(grid), row);

    expect(grid._newAddedRowsSet).toBe(existing);
    expect(existing.has(row)).toBe(true);
    expect(existing.has(alreadyExcluded)).toBe(true);
  });

  it('신규행 여러 건을 모두 등록한다', () => {
    const grid: FakeGrid = {};
    const rows = [{ CRUD_TYPE: 'I' }, { CRUD_TYPE: 'I' }] as WijmoRowItem[];

    rows.forEach(row => keepRowVisibleUnderFilter(asGrid(grid), row));

    expect(rows.every(row => grid._newAddedRowsSet?.has(row))).toBe(true);
  });

  it('등록된 신규행은 필터 조건에 안 맞아도 통과한다 (미등록 행은 걸러진다)', () => {
    const grid: FakeGrid = {};
    const matchesFilter = (row: WijmoRowItem) => row['NAME'] === 'A';
    const newRow = { CRUD_TYPE: 'I' } as WijmoRowItem;
    const otherRow = { NAME: 'B' } as WijmoRowItem;

    expect(filterLikeWijmo(grid, newRow, matchesFilter)).toBe(false);

    keepRowVisibleUnderFilter(asGrid(grid), newRow);

    expect(filterLikeWijmo(grid, newRow, matchesFilter)).toBe(true);
    expect(filterLikeWijmo(grid, otherRow, matchesFilter)).toBe(false);
  });
});
