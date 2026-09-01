import { AllowMerging, CellType, type FlexGrid, type GridPanel } from '@mescius/wijmo.grid';
import { describe, expect, it } from 'vitest';

import { CustomMergeManager } from './mergeManager';

type Row = Record<string, unknown>;

const COLUMNS = ['DIVISION_ID', 'END_CUSTOMER', 'SCM_SITE_ID'];
const DIVISION = 0;

// wijmo 이벤트를 addHandler/raise 만 흉내낸 가짜 그리드.
//   편집 관련 이벤트는 실제 wijmo 순서대로 쏠 수 있게 개별로 노출한다:
//   beginningEdit(편집 시도) → 취소되지 않았을 때만 prepareCellForEdit(편집 시작) → cellEditEnded.
// 재조회 때마다 wijmo 가 새로 만드는 CollectionView — 자기 구독자만 들고 있다.
const createCollectionView = (rows: Row[]) => {
  const changedHandlers: ((sender: unknown, args: unknown) => void)[] = [];
  return {
    items: rows,
    collectionChanged: {
      addHandler: (handler: (sender: unknown, args: unknown) => void) =>
        changedHandlers.push(handler),
    },
    raiseChanged: () => changedHandlers.forEach(handler => handler(null, {})),
  };
};

const createFakeGrid = (rows: Row[]) => {
  const handlers = new Map<string, ((sender: unknown, args: unknown) => void)[]>();
  const event = (name: string) => ({
    addHandler: (handler: (sender: unknown, args: unknown) => void) =>
      handlers.set(name, [...(handlers.get(name) ?? []), handler]),
  });

  let collectionView = createCollectionView(rows);
  // 이벤트와 invalidate 호출을 한 줄로 기록 — 다시 그리는 시점이 에디터 생성 전인지 보기 위함.
  const log: string[] = [];

  const grid = {
    allowMerging: AllowMerging.Cells,
    rows: { defaultSize: 30 },
    scrollPosition: { y: 0 },
    get collectionView() {
      return collectionView;
    },
    itemsSourceChanged: event('itemsSourceChanged'),
    beginningEdit: event('beginningEdit'),
    prepareCellForEdit: event('prepareCellForEdit'),
    cellEditEnded: event('cellEditEnded'),
    sortedColumn: event('sortedColumn'),
    loadedRows: event('loadedRows'),
    invalidate: () => {
      log.push('invalidate');
    },
  };

  const raise = (name: string, row: number) => {
    log.push(name);
    (handlers.get(name) ?? []).forEach(handler => handler(grid, { row }));
  };

  return {
    grid: grid as unknown as FlexGrid,
    log,
    // 편집 불가 셀을 더블클릭한 경우 — beginningEdit 만 오고 취소되어 그 뒤 이벤트가 없다.
    //   취소 판정은 핸들러가 다 끝난 뒤라 마이크로태스크를 한 번 비워야 결과가 보인다.
    attemptEdit: async (row: number) => {
      raise('beginningEdit', row);
      await Promise.resolve();
    },
    // 편집이 실제로 시작된 경우 — 에디터가 만들어지면서 prepareCellForEdit 가 온다.
    beginEdit: async (row: number) => {
      raise('beginningEdit', row);
      raise('prepareCellForEdit', row);
      await Promise.resolve();
    },
    endEdit: (row: number) => raise('cellEditEnded', row),
    // 조회/필터/정렬로 그리드가 행을 다시 바인딩한 경우.
    reloadRows: () => raise('loadedRows', -1),
    // 재조회 — itemsSource 가 바뀌면 wijmo 는 collectionView 를 통째로 새로 만든다.
    requery: () => {
      collectionView = createCollectionView(rows);
      raise('loadedRows', -1);
      raise('itemsSourceChanged', -1);
    },
    // 행 추가/삭제 — 그리드가 행을 다시 바인딩하지 않아 collectionChanged 만 온다.
    changeCollection: () => collectionView.raiseChanged(),
  };
};

// rows 배열을 그대로 들고 있어 필터(splice)처럼 행 구성이 바뀌면 패널도 같이 따라간다.
const createPanel = (grid: FlexGrid, rows: Row[]) =>
  ({
    cellType: CellType.Cell,
    grid,
    columns: COLUMNS.map(() => ({ allowMerging: true })),
    get rows() {
      return rows.map(dataItem => ({ dataItem }));
    },
    get viewRange() {
      return { row: 0, row2: rows.length - 1 };
    },
    getCellData: (row: number, col: number) => rows[row]?.[COLUMNS[col]],
  }) as unknown as GridPanel;

const sameRows = (): Row[] => [
  { DIVISION_ID: '40', END_CUSTOMER: 'CUST1', SCM_SITE_ID: 'S1' },
  { DIVISION_ID: '40', END_CUSTOMER: 'CUST1', SCM_SITE_ID: 'S1' },
  { DIVISION_ID: '40', END_CUSTOMER: 'CUST1', SCM_SITE_ID: 'S1' },
];

describe('CustomMergeManager 빈 값 처리', () => {
  const END_CUSTOMER = 1;

  it('빈 값(공백/null) 셀은 위아래가 같이 비어 있어도 병합하지 않는다', () => {
    const rows: Row[] = [
      { DIVISION_ID: '40', END_CUSTOMER: '', SCM_SITE_ID: 'S1' },
      { DIVISION_ID: '40', END_CUSTOMER: '', SCM_SITE_ID: 'S1' },
      { DIVISION_ID: '40', END_CUSTOMER: '   ', SCM_SITE_ID: 'S1' },
      { DIVISION_ID: '40', END_CUSTOMER: null, SCM_SITE_ID: 'S1' },
    ];
    const { grid } = createFakeGrid(rows);
    const manager = new CustomMergeManager(grid);
    const panel = createPanel(grid, rows);

    expect(manager.getMergedRange(panel, 0, END_CUSTOMER)).toBeNull();
    expect(manager.getMergedRange(panel, 2, END_CUSTOMER)).toBeNull();
    expect(manager.getMergedRange(panel, 3, END_CUSTOMER)).toBeNull();
  });

  it('빈 셀은 그 칸만 빠진다 — 값이 있는 다른 컬럼 병합은 그대로다', () => {
    const rows: Row[] = [
      { DIVISION_ID: '40', END_CUSTOMER: '', SCM_SITE_ID: 'S1' },
      { DIVISION_ID: '40', END_CUSTOMER: '', SCM_SITE_ID: 'S1' },
    ];
    const { grid } = createFakeGrid(rows);
    const manager = new CustomMergeManager(grid);
    const panel = createPanel(grid, rows);

    const merged = manager.getMergedRange(panel, 0, DIVISION);
    expect(merged?.row).toBe(0);
    expect(merged?.row2).toBe(1);
  });
});

describe('CustomMergeManager 행 재바인딩(조회/필터/정렬)', () => {
  const END_CUSTOMER = 1;

  it('필터로 행 구성이 바뀌면 이전 행 기준으로 잡아둔 병합을 버린다', () => {
    const rows: Row[] = [
      { DIVISION_ID: '40', END_CUSTOMER: 'ABS', SCM_SITE_ID: 'S1' },
      { DIVISION_ID: '40', END_CUSTOMER: 'ACE', SCM_SITE_ID: 'S2' },
      { DIVISION_ID: '40', END_CUSTOMER: 'AJ', SCM_SITE_ID: 'S3' },
      { DIVISION_ID: '40', END_CUSTOMER: 'AJ', SCM_SITE_ID: 'S4' },
    ];
    const { grid, reloadRows } = createFakeGrid(rows);
    const manager = new CustomMergeManager(grid);
    const panel = createPanel(grid, rows);

    // 필터 전 렌더 — 이 시점의 행 인덱스 기준으로 판정이 이뤄진다.
    expect(manager.getMergedRange(panel, 2, END_CUSTOMER)?.row).toBe(2);

    // AJ 만 남기는 필터 — 같은 인덱스에 다른 행이 온다.
    rows.splice(0, 2);
    reloadRows();

    const merged = manager.getMergedRange(panel, 0, END_CUSTOMER);
    expect(merged?.row).toBe(0);
    expect(merged?.row2).toBe(1);
  });

  it('재조회로 collectionView 가 교체된 뒤에도 행 삭제에 캐시를 버린다', () => {
    const rows: Row[] = [
      { DIVISION_ID: '40', END_CUSTOMER: 'ABS', SCM_SITE_ID: 'S1' },
      { DIVISION_ID: '40', END_CUSTOMER: 'AJ', SCM_SITE_ID: 'S2' },
      { DIVISION_ID: '40', END_CUSTOMER: 'AJ', SCM_SITE_ID: 'S3' },
    ];
    const { grid, requery, changeCollection } = createFakeGrid(rows);
    const manager = new CustomMergeManager(grid);
    const panel = createPanel(grid, rows);

    requery();
    // 재조회 후 렌더 — 이 시점 인덱스로 캐시가 채워진다.
    expect(manager.getMergedRange(panel, 1, END_CUSTOMER)?.row).toBe(1);

    // 첫 행 삭제 — 행 재바인딩 없이 collectionChanged 만 오고 아래 행 인덱스가 당겨진다.
    rows.splice(0, 1);
    changeCollection();

    const merged = manager.getMergedRange(panel, 0, END_CUSTOMER);
    expect(merged?.row).toBe(0);
    expect(merged?.row2).toBe(1);
  });
});

describe('CustomMergeManager 편집 행 처리', () => {
  it('값이 같은 연속 행을 세로 병합한다', () => {
    const rows = sameRows();
    const { grid } = createFakeGrid(rows);
    const manager = new CustomMergeManager(grid);
    const panel = createPanel(grid, rows);

    const merged = manager.getMergedRange(panel, 0, DIVISION);

    expect(merged?.row).toBe(0);
    expect(merged?.row2).toBe(2);
  });

  it('편집을 시작해도 병합은 그대로다 — 셀을 클릭했다고 블록이 갈라지지 않는다', async () => {
    const rows = sameRows();
    const { grid, beginEdit } = createFakeGrid(rows);
    const manager = new CustomMergeManager(grid);
    const panel = createPanel(grid, rows);

    // wijmo 는 이미 선택된 셀을 다시 클릭하면 편집을 시작한다 = 사용자에겐 그냥 포커스 이동.
    await beginEdit(1);

    const merged = manager.getMergedRange(panel, 1, DIVISION);
    expect(merged?.row).toBe(0);
    expect(merged?.row2).toBe(2);
  });

  it('편집 중에는 그리드를 다시 그리지 않는다 — 열려 있는 드롭다운이 닫힌다', async () => {
    const rows = sameRows();
    const { grid, beginEdit, log } = createFakeGrid(rows);
    new CustomMergeManager(grid);

    await beginEdit(1);

    // invalidate 는 10ms 뒤 refresh 를 예약하고 FlexGrid.refresh 는 finishEditing 을 부른다.
    //   편집이 열려 있는 동안 부르면 콤보 드롭다운이 닫혀 클릭이 안 먹는다.
    expect(log).not.toContain('invalidate');
  });

  it('취소된 편집 시도(편집 불가 셀 더블클릭)도 병합을 그대로 둔다', async () => {
    const rows = sameRows();
    const { grid, attemptEdit } = createFakeGrid(rows);
    const manager = new CustomMergeManager(grid);
    const panel = createPanel(grid, rows);

    await attemptEdit(1);

    const merged = manager.getMergedRange(panel, 0, DIVISION);
    expect(merged?.row).toBe(0);
    expect(merged?.row2).toBe(2);
  });

  it('편집이 끝나면 바뀐 값 기준으로 다시 그린다', async () => {
    const rows = sameRows();
    const { grid, beginEdit, endEdit, log } = createFakeGrid(rows);
    const manager = new CustomMergeManager(grid);
    const panel = createPanel(grid, rows);

    await beginEdit(1);
    rows[1].DIVISION_ID = '81';
    endEdit(1);

    // 에디터가 닫힌 뒤이므로 여기서는 다시 그려야 한다 — 값이 바뀌면 병합 구간도 바뀐다.
    expect(log).toContain('invalidate');
    expect(manager.getMergedRange(panel, 0, DIVISION)).toBeNull();
  });
});
