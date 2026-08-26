import { CellRange, CellRangeEventArgs, type FlexGrid } from '@mescius/wijmo.grid';
import { render } from '@testing-library/react';
import { describe, expect, it, vi } from 'vitest';

import type { MainRow } from '../types';

import { ContributeMainGrid } from './ContributeMainGrid';

// 공용 DataGrid 대신, 이 화면이 실제로 올라타는 계약만 그대로 흉내낸 그리드를 쓴다.
//   - 자식(DataGrid)의 useEffect 에서 FlexGrid 생성 + EditTracker 등록
//   - 그 다음 부모(ContributeMainGrid)의 useEffect 가 자기 핸들러를 등록
//   React 는 자식 effect 를 먼저 실행하므로 운영과 같은 등록 순서가 재현된다
//   (Wijmo Event 는 등록 순서대로 호출 — 나중에 등록된 화면 핸들러가 최종값을 결정한다).
vi.mock('@shared/components', async () => {
  const { createElement, useEffect, useRef } = await import('react');
  const { FlexGrid: WjFlexGrid } = await import('@mescius/wijmo.grid');
  const { EditTracker, normalizeDynamicColumns } = await import('@foundation/utils');

  const DataGrid = (props: Record<string, never>) => {
    const p = props as unknown as {
      gridRef: { current: FlexGrid | undefined };
      dynamicColumns: unknown[];
      itemsSource: unknown[];
    };
    const hostRef = useRef<HTMLDivElement>(null);
    useEffect(() => {
      if (!hostRef.current) return;
      const grid = new WjFlexGrid(hostRef.current, {
        autoGenerateColumns: false,
        columnGroups: normalizeDynamicColumns(p.dynamicColumns as never) as never,
        itemsSource: p.itemsSource,
      });
      new EditTracker(grid);
      p.gridRef.current = grid;
      // eslint-disable-next-line react-hooks/exhaustive-deps
    }, []);
    return createElement('div', { ref: hostRef });
  };
  return { DataGrid };
});

vi.mock('@shared/stores', () => ({
  useMessageStore: () => () => undefined,
  createPersistedStoreWithTab: () => () => undefined,
}));

vi.mock('../useContributeMainStore', () => ({
  useContributeMainStore: (selector: (s: unknown) => unknown) =>
    selector({ searchParams: { chkYear: false }, staticColumns: {} }),
}));

// vite AutoImport 로 주입되는 전역 — 테스트에는 그 플러그인이 없어 직접 채운다.
vi.stubGlobal('useTranslation', () => ({ t: (_code: string, fallback: string) => fallback }));

// 2026-01 월별 PIVOT 1행. EDIT_FLAG='Y' = 편집 가능 행.
const sampleRow = (): MainRow =>
  ({
    DEPARTMENT_ID: 'D1',
    DEPT_ID: 'DP1',
    END_CUST_REPORT: 'EC1',
    SOLDTO_CUST_REPORT: 'SC1',
    EDIT_FLAG: 'Y',
    'M#202601#RBU_0001': 11,
    'M#202601#RBU_0006': 89,
    'M#202601#RBU_0999': null,
  }) as unknown as MainRow;

// jsdom 에는 레이아웃이 없어 startEditing 이 죽는다 →
//   Wijmo `_EditHandler.finishEditing` 과 같은 순서로 재현한다.
const typeInto = (grid: FlexGrid, row: number, col: number, text: string) => {
  const rng = new CellRange(row, col);
  grid.beginningEdit.raise(grid, new CellRangeEventArgs(grid.cells, rng));
  grid.cells.setCellData(row, col, text, true, false);
  grid.cellEditEnded.raise(grid, new CellRangeEventArgs(grid.cells, rng));
};

const indexOfBinding = (grid: FlexGrid, binding: string) => {
  for (let i = 0; i < grid.columns.length; i++) {
    if (grid.columns[i].binding === binding) return i;
  }
  return -1;
};

const mountGrid = (items: MainRow[]) => {
  const gridRef: { current: FlexGrid | undefined } = { current: undefined };
  render(<ContributeMainGrid gridRef={gridRef as never} data={items} />);
  if (!gridRef.current) throw new Error('grid 가 생성되지 않았다');
  return gridRef.current;
};

describe('ContributeMainGrid — 수정 후 원래 값으로 되돌리면 수정상태(M)가 풀린다', () => {
  it('11 → 12 → 11 이면 CRUD_TYPE 이 해제된다', () => {
    const items = [sampleRow()];
    const grid = mountGrid(items);
    const col = indexOfBinding(grid, 'M#202601#RBU_0001');

    typeInto(grid, 0, col, '12');
    expect(items[0].CRUD_TYPE).toBe('M');

    typeInto(grid, 0, col, '11');
    expect(items[0].CRUD_TYPE).toBeUndefined();
  });

  it('실제로 바뀐 값은 수정상태로 남는다', () => {
    const items = [sampleRow()];
    const grid = mountGrid(items);
    const col = indexOfBinding(grid, 'M#202601#RBU_0001');

    typeInto(grid, 0, col, '12');
    expect(items[0].CRUD_TYPE).toBe('M');
  });

  it('붙여넣기로 원래 값을 다시 넣어도 수정상태가 풀린다', () => {
    const items = [sampleRow()];
    const grid = mountGrid(items);
    const col = indexOfBinding(grid, 'M#202601#RBU_0001');

    typeInto(grid, 0, col, '12');
    expect(items[0].CRUD_TYPE).toBe('M');

    // 붙여넣기 경로 — Wijmo 는 pastingCell → setCellData → pastedCell 로 흐른다.
    const rng = new CellRange(0, col);
    grid.pastingCell.raise(grid, new CellRangeEventArgs(grid.cells, rng));
    grid.cells.setCellData(0, col, '11', true, false);
    grid.pastedCell.raise(grid, new CellRangeEventArgs(grid.cells, rng));

    expect(items[0].CRUD_TYPE).toBeUndefined();
  });
});
