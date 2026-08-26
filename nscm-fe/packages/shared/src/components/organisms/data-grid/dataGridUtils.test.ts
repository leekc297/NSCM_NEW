import type { SortDescription } from '@mescius/wijmo';
import type { FlexGrid } from '@mescius/wijmo.grid';
import { CellType } from '@mescius/wijmo.grid';
import { beforeEach, describe, expect, it } from 'vitest';

import { useDataGridUtils } from './dataGridUtils';

// 헤더 클릭 정렬은 F3(GridAction.toggleColumnSort)로 켠 컬럼에서만 걸려야 한다.
// wijmo Column.allowSorting 기본값이 true 라 DataGrid 가 새 컬럼마다 false 로 내려 주고,
// 이 핸들러가 그 값을 스위치로 읽는다.

interface FakeColumn {
  binding: string;
  allowSorting: boolean;
  _dynamic?: boolean;
}

const createFakeGrid = (column: FakeColumn) => {
  const hostElement = document.createElement('div');
  document.body.appendChild(hostElement);

  // wijmo ObservableArray 대역 — 핸들러가 쓰는 clear/push/find 만 있으면 된다.
  const sortDescriptions: SortDescription[] & { clear: () => void } = Object.assign(
    [] as SortDescription[],
    {
      clear: () => {
        sortDescriptions.length = 0;
      },
    }
  );

  const grid = {
    hostElement,
    columns: [column],
    columnGroups: [column],
    collectionView: { sortDescriptions },
    hitTest: () => ({ col: 0, cellType: CellType.ColumnHeader }),
    select: () => undefined,
    scrollIntoView: () => undefined,
  };

  return { grid: grid as unknown as FlexGrid<WijmoRowItem>, sortDescriptions, hostElement };
};

const clickHeader = (hostElement: HTMLElement) => {
  hostElement.dispatchEvent(new MouseEvent('click', { bubbles: true, cancelable: true }));
};

describe('setSortableColumnHeaderClick', () => {
  beforeEach(() => {
    document.body.innerHTML = '';
  });

  it('F3 로 켜지 않은(allowSorting=false) 컬럼은 헤더를 클릭해도 정렬하지 않는다', () => {
    const { grid, sortDescriptions, hostElement } = createFakeGrid({
      binding: 'ITEM_CD',
      allowSorting: false,
    });

    useDataGridUtils().setSortableColumnHeaderClick(grid);
    clickHeader(hostElement);

    expect(sortDescriptions).toHaveLength(0);
  });

  it('F3 로 켠(allowSorting=true) 컬럼은 클릭마다 오름 → 내림 → 해제로 순환한다', () => {
    const { grid, sortDescriptions, hostElement } = createFakeGrid({
      binding: 'ITEM_CD',
      allowSorting: true,
    });

    useDataGridUtils().setSortableColumnHeaderClick(grid);

    clickHeader(hostElement);
    expect(sortDescriptions).toHaveLength(1);
    expect(sortDescriptions[0].property).toBe('ITEM_CD');
    expect(sortDescriptions[0].ascending).toBe(true);

    clickHeader(hostElement);
    expect(sortDescriptions).toHaveLength(1);
    expect(sortDescriptions[0].ascending).toBe(false);

    clickHeader(hostElement);
    expect(sortDescriptions).toHaveLength(0);
  });

  it('동적(주차/월/일) 컬럼은 allowSorting 이 켜져 있어도 정렬하지 않는다', () => {
    const { grid, sortDescriptions, hostElement } = createFakeGrid({
      binding: 'W202601',
      allowSorting: true,
      _dynamic: true,
    });

    useDataGridUtils().setSortableColumnHeaderClick(grid);
    clickHeader(hostElement);

    expect(sortDescriptions).toHaveLength(0);
  });
});
