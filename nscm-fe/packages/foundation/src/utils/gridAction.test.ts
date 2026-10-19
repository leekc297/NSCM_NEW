import type { FlexGrid } from '@mescius/wijmo.grid';
import { describe, expect, it } from 'vitest';

import { EditTracker } from './editTracker';
import {
  getInsertAnchor,
  GridAction,
  installInsertPinConverter,
  keepRowVisibleUnderFilter,
  pinInsertedRow,
  revertRowChanges,
} from './gridAction';

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

describe('GridAction.resolveInsertIndex — groupKey 는 정렬된 표시 순서(view)를 기준으로 walk 한다', () => {
  const buildGrid = (opts: {
    source: WijmoRowItem[];
    view: WijmoRowItem[];
    selectionRow: number;
    pins?: [WijmoRowItem, WijmoRowItem][]; // [pending 행, 그 앵커]
  }) => {
    const pinsMap = opts.pins
      ? new WeakMap<WijmoRowItem, { anchor: WijmoRowItem }>(
          opts.pins.map(([row, anchor]) => [row, { anchor }])
        )
      : undefined;
    const grid = {
      collectionView: { sourceCollection: opts.source, items: opts.view },
      selection: { row: opts.selectionRow, col: 0 },
      _insertPins: pinsMap,
    };
    return grid as unknown as FlexGrid<WijmoRowItem>;
  };

  it('물리적으로(source 순서) 떨어져 있어도 표시 순서(view)가 같은 그룹이면 경계를 확장한다', () => {
    const a1: WijmoRowItem = { ID: 'A1', GROUP: 'A' };
    const b1: WijmoRowItem = { ID: 'B1', GROUP: 'B' };
    const a2: WijmoRowItem = { ID: 'A2', GROUP: 'A' };
    const source = [a1, b1, a2]; // 원본 배열은 A/B 그룹이 섞여 있다
    const view = [a1, a2, b1]; // 정렬된 표시 순서는 A 그룹이 붙어 있다
    const grid = buildGrid({ source, view, selectionRow: 0 }); // a1 에 포커스

    const index = GridAction.resolveInsertIndex(grid, source, 'below', {
      groupKey: row => String(row.GROUP ?? ''),
    });

    // a2(source index 2) 바로 뒤 = index 3. source 순서로 walk 했다면 b1(index 1)에서
    // groupKey 불일치로 멈춰 index 1 이 나왔을 것이다.
    expect(index).toBe(3);
  });

  it('클릭한 행 자체가 미저장 신규행(pin)이면 그 행의 등록된 앵커로 즉시 치환한다', () => {
    const anchor: WijmoRowItem = { ID: 'ANCHOR', GROUP: 'K1' };
    const pending1: WijmoRowItem = { ID: 'P1', GROUP: '' };
    const pending2: WijmoRowItem = { ID: 'P2', GROUP: '' };
    const source = [anchor, pending1, pending2];
    const grid = buildGrid({
      source,
      view: source,
      selectionRow: 1, // 방금 추가한 세트(pending1)를 다시 클릭한 상황
      pins: [
        [pending1, anchor],
        [pending2, anchor],
      ],
    });

    const index = GridAction.resolveInsertIndex(grid, source, 'above', {
      groupKey: row => String(row.GROUP ?? ''),
    });

    // pending1 을 클릭했지만 그 pin 이 기록한 진짜 앵커(anchor, source index 0)로 치환되고,
    // 거기서 groupKey walk 를 다시 시작한다. anchor 바로 아래(뷰 인덱스 1)는 pending1 인데
    // GROUP 이 비어 있어 anchor 의 groupKey('K1')와 안 맞으므로 walk 는 확장되지 않는다 —
    // 즉 anchor 바로 위(index 0)에 새 세트가 꽂혀, 이미 쌓인 pending 세트보다 anchor에
    // 더 가깝게(누른 순서대로 위에서 아래로 쌓이는 규약) 삽입된다.
    expect(index).toBe(0);
  });

  it('실제(저장된) 행에서 walk 할 때는 groupKey 가 우연히 같아도 미저장 신규행에서 항상 멈춘다 (ForecastPrice/SalesPlan/BusinessPlan 계약)', () => {
    // business-plan.insertAnchor.test.ts 의 "위쪽 신규행에서 멈춘다" 케이스를 공용 함수
    // 계약으로 이식 — pending 행은 pin 등록 여부와 무관하게 CRUD_TYPE 만으로 걸러진다.
    const saved1: WijmoRowItem = { ID: 'S1', GROUP: 'K1' };
    const saved2: WijmoRowItem = { ID: 'S2', GROUP: 'K1' };
    // GROUP 값이 saved1/saved2 와 우연히 같은 미저장 신규행 — 업무 키를 이미 채워 넣은
    // 상태라도 CRUD_TYPE='I' 이면 walk 가 넘어가면 안 된다.
    const pending: WijmoRowItem = { ID: 'P', GROUP: 'K1', CRUD_TYPE: 'I' };
    const source = [pending, saved1, saved2]; // 뷰 순서도 동일
    const grid = buildGrid({ source, view: source, selectionRow: 2 }); // saved2 를 클릭

    const index = GridAction.resolveInsertIndex(grid, source, 'above', {
      groupKey: row => String(row.GROUP ?? ''),
    });

    // saved2 -> saved1 은 GROUP 이 같고 saved1 이 미저장 신규행이 아니므로 walk 가
    // 확장되지만, 그 다음 이웃 pending 은 GROUP 값이 같아도 CRUD_TYPE='I' 라 멈춘다 —
    // 최종 경계는 saved1(source index 1).
    expect(index).toBe(1);
  });
});

describe('GridAction.addRowSet — 세트를 앵커 계산 1회로 원자적으로 삽입한다', () => {
  const buildInsertGrid = (source: WijmoRowItem[], selectionRow: number) => {
    const itemsAdded: WijmoRowItem[] = [];
    const collectionView = {
      sourceCollection: source,
      items: source,
      itemsAdded: { push: (row: WijmoRowItem) => itemsAdded.push(row) },
      sortDescriptions: [] as { property: string; ascending: boolean }[],
      sortConverter: undefined as unknown,
      refresh: () => undefined,
    };
    const grid = {
      isReadOnly: false,
      itemsSource: source,
      collectionView,
      selection: { row: selectionRow, col: 0 },
      mergeManager: undefined,
      invalidate: () => undefined,
    };
    return { grid: grid as unknown as FlexGrid<WijmoRowItem>, itemsAdded };
  };

  it('세트 전체를 호출 순서 그대로, 앵커 바로 위에 한 번에 삽입한다', () => {
    const anchor: WijmoRowItem = { ID: 'X' };
    const source = [anchor];
    const { grid, itemsAdded } = buildInsertGrid(source, 0);

    const added = GridAction.addRowSet(
      grid,
      [{ MEASURE: 'A' }, { MEASURE: 'B' }, { MEASURE: 'C' }],
      'above',
      { preserveMergeManager: true }
    );

    expect(added?.map(r => r.MEASURE)).toEqual(['A', 'B', 'C']);
    expect(source.map(r => r.MEASURE ?? r.ID)).toEqual(['A', 'B', 'C', 'X']);
    expect(itemsAdded).toHaveLength(3);
  });
});

describe('GridAction.removeRow — groupKey로 세트 전체를 함께 지운다 (이슈 3 보완)', () => {
  const buildRemoveGrid = (source: WijmoRowItem[], selectedDataItems: WijmoRowItem[]) => {
    const grid = {
      isReadOnly: false,
      collectionView: { sourceCollection: source },
      editableCollectionView: {
        remove: (row: WijmoRowItem) => {
          const i = source.indexOf(row);
          if (i >= 0) source.splice(i, 1);
        },
        commitEdit: () => undefined,
      },
      selectedRows: selectedDataItems.map(dataItem => ({ dataItem })),
      mergeManager: undefined,
      invalidate: () => undefined,
    };
    return grid as unknown as FlexGrid<WijmoRowItem>;
  };

  it('세트 중 한 행만 선택돼도 같은 groupKey 를 가진 나머지 미저장 행까지 함께 지우고, 다른 세트는 제자리에 남는다', () => {
    // "누른 순서대로 위에서 아래로 쌓인다" 규약 — 세트 A(먼저 삽입) 세트 B(나중 삽입) 둘 다
    // 같은 anchor 위에 쌓여 있고, 병합 안 된 컬럼을 클릭해 세트 A의 A1 한 행만 선택된 상황.
    const a1: WijmoRowItem = { ID: 'A1', INSERT_GROUP_ID: 'A', CRUD_TYPE: 'I' };
    const a2: WijmoRowItem = { ID: 'A2', INSERT_GROUP_ID: 'A', CRUD_TYPE: 'I' };
    const b1: WijmoRowItem = { ID: 'B1', INSERT_GROUP_ID: 'B', CRUD_TYPE: 'I' };
    const b2: WijmoRowItem = { ID: 'B2', INSERT_GROUP_ID: 'B', CRUD_TYPE: 'I' };
    const anchor: WijmoRowItem = { ID: 'ANCHOR' };
    const source = [a1, a2, b1, b2, anchor];
    const grid = buildRemoveGrid(source, [a1]);

    const result = GridAction.removeRow(grid, true, true, {
      groupKey: row => String(row.INSERT_GROUP_ID ?? ''),
    });

    expect(result).toBe(true);
    // 세트 A(A1, A2)는 모두 사라지고, 세트 B는 원래 상대 위치(anchor 바로 위)를 그대로
    // 유지한다 — 관찰이 아니라 이 assert 로 순서 유지가 고정된다.
    expect(source).toEqual([b1, b2, anchor]);
  });

  it('groupKey 없이 부르면 선택된 행만 지운다 (기존 동작 회귀 없음)', () => {
    const a1: WijmoRowItem = { ID: 'A1', INSERT_GROUP_ID: 'A', CRUD_TYPE: 'I' };
    const a2: WijmoRowItem = { ID: 'A2', INSERT_GROUP_ID: 'A', CRUD_TYPE: 'I' };
    const source = [a1, a2];
    const grid = buildRemoveGrid(source, [a1]);

    GridAction.removeRow(grid, true, true);

    expect(source).toEqual([a2]);
  });
});

/**
 * `deleteOnlyNew` 의 두 모드를 서로 구분되게 고정한다.
 *
 * 이 플래그는 "삭제 기능이 없는 화면"의 유일한 안전장치다 — `true` 면 저장 전 신규행만 걷어내고
 * 수정행·기존행은 제거도, `CRUD_TYPE='D'` 마킹도 하지 않아야 한다. 마킹이 새면 그 행이 화면의
 * 저장 payload(`filter(item => item.CRUD_TYPE)`)에 삭제건으로 섞여 **사용자가 지우지 않은 데이터가
 * 서버에서 지워진다**. 소비처: admin/user-management · master/sales-site-project-model ·
 * shipping/shipment-change-request-plan(SSP0200).
 *
 * 종전 테스트는 신규행 케이스만 덮고 있어 이 계약이 비어 있었다(2026-10-03 보완).
 */
describe('GridAction.removeRow — deleteOnlyNew 가 신규행 외를 보호한다', () => {
  const buildGrid = (source: WijmoRowItem[], selectedDataItems: WijmoRowItem[]) =>
    ({
      isReadOnly: false,
      collectionView: { sourceCollection: source },
      editableCollectionView: {
        remove: (row: WijmoRowItem) => {
          const i = source.indexOf(row);
          if (i >= 0) source.splice(i, 1);
        },
        commitEdit: () => undefined,
      },
      selectedRows: selectedDataItems.map(dataItem => ({ dataItem })),
      mergeManager: undefined,
      invalidate: () => undefined,
    }) as unknown as FlexGrid<WijmoRowItem>;

  it('true: 수정행·기존행만 선택하면 아무것도 지우지 않고 D 마킹도 하지 않는다', () => {
    const modified: WijmoRowItem = { ID: 'M1', CRUD_TYPE: 'M' };
    const existing: WijmoRowItem = { ID: 'E1' };
    const source = [modified, existing];

    GridAction.removeRow(buildGrid(source, [modified, existing]), true, true);

    expect(source).toEqual([modified, existing]);
    expect(modified.CRUD_TYPE).toBe('M'); // 'D' 로 덮이지 않는다
    expect(existing.CRUD_TYPE).toBeUndefined(); // 없던 마킹이 생기지 않는다
  });

  it('true: 섞여 선택되면 신규행만 빠지고 나머지는 그대로다', () => {
    const inserted: WijmoRowItem = { ID: 'I1', CRUD_TYPE: 'I' };
    const created: WijmoRowItem = { ID: 'C1', CRUD_TYPE: 'C' };
    const modified: WijmoRowItem = { ID: 'M1', CRUD_TYPE: 'M' };
    const existing: WijmoRowItem = { ID: 'E1' };
    const source = [inserted, created, modified, existing];

    GridAction.removeRow(buildGrid(source, [inserted, created, modified, existing]), true, true);

    expect(source).toEqual([modified, existing]);
    expect(modified.CRUD_TYPE).toBe('M');
    expect(existing.CRUD_TYPE).toBeUndefined();
  });

  it('false(기본): 기존행은 지우지 않고 D 로 마킹한다 — 두 모드가 구분된다', () => {
    const inserted: WijmoRowItem = { ID: 'I1', CRUD_TYPE: 'I' };
    const existing: WijmoRowItem = { ID: 'E1' };
    const source = [inserted, existing];

    GridAction.removeRow(buildGrid(source, [inserted, existing]), false, true);

    expect(source).toEqual([existing]);
    expect(existing.CRUD_TYPE).toBe('D');
  });
});

describe('installInsertPinConverter — 정렬 기준 컬럼 값을 직접 입력해도 pin 이 풀리지 않는다 (이슈 2)', () => {
  it('신규행의 정렬 컬럼 값을 바꿔도 정렬 비교값은 계속 앵커 값을 따른다', () => {
    const anchor: WijmoRowItem = { ID: 'ANCHOR', CODE: 'B' };
    const newRow: WijmoRowItem = { ID: 'NEW', CODE: '' };
    const sortDescriptions = [{ property: 'CODE', ascending: true }];
    const grid = {
      collectionView: { sortDescriptions, sortConverter: undefined as unknown },
    } as unknown as FlexGrid<WijmoRowItem>;

    pinInsertedRow(grid, newRow, anchor);
    installInsertPinConverter(grid);
    const converter = (
      grid.collectionView as unknown as { sortConverter: unknown }
    ).sortConverter as (sd: { property: string }, item: WijmoRowItem, value: unknown) => unknown;

    expect(converter(sortDescriptions[0], newRow, newRow.CODE)).toBe('B');

    // 사용자가 정렬 기준 컬럼(CODE) 값을 직접 입력 — 예전 설계라면 여기서 pin 이 풀려
    // rawValue('ZZZZ')를 그대로 돌려줬을 것이다.
    newRow.CODE = 'ZZZZ';
    expect(converter(sortDescriptions[0], newRow, newRow.CODE)).toBe('B');
  });
});

describe('getInsertAnchor — pin 조회 (sortDescriptions 유무와 무관하게 등록됨)', () => {
  it('sortDescriptions 가 비어 있어도(= wijmo 헤더 정렬 없음) pin 을 등록·조회할 수 있다', () => {
    const anchor: WijmoRowItem = { ID: 'ANCHOR' };
    const newRow: WijmoRowItem = { ID: 'NEW' };
    const grid = {
      collectionView: { sortDescriptions: [] as { property: string; ascending: boolean }[] },
    } as unknown as FlexGrid<WijmoRowItem>;

    pinInsertedRow(grid, newRow, anchor);

    expect(getInsertAnchor(grid, newRow)).toBe(anchor);
  });

  it('pin 이 없는 행은 undefined', () => {
    const grid = {
      collectionView: { sortDescriptions: [] as { property: string; ascending: boolean }[] },
    } as unknown as FlexGrid<WijmoRowItem>;

    expect(getInsertAnchor(grid, { ID: 'X' })).toBeUndefined();
  });
});
