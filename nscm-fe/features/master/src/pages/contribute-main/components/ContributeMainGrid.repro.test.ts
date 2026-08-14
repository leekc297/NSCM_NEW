import { DataType } from '@mescius/wijmo';
import { CellRange, CellRangeEventArgs, FlexGrid } from '@mescius/wijmo.grid';
import { describe, expect, it, vi } from 'vitest';

import { normalizeDynamicColumns } from '@foundation/utils';

import type { MainRow } from '../types';

import { buildDynamicColumns } from './ContributeMainGrid';

// 컴포넌트가 끌고 오는 UI 배럴(=ag-grid CSS 까지 딸려온다)은 이 테스트와 무관하므로 차단한다.
//   여기서 검증하는 것은 컬럼 설정 → wijmo 커밋 동작뿐이다.
vi.mock('@shared/components', () => ({ DataGrid: () => null }));
vi.mock('@shared/stores', () => ({
  useMessageStore: () => () => undefined,
  createPersistedStoreWithTab: () => () => undefined,
}));

// 재현용 SP 응답 1행 — 2026-01 월별 PIVOT (기여율 8개 + 구분 1개).
const sampleRow = (): MainRow =>
  ({
    DEPARTMENT_ID: 'D1',
    DEPT_ID: 'DP1',
    END_CUST_REPORT: 'EC1',
    SOLDTO_CUST_REPORT: 'SC1',
    EDIT_FLAG: 'N',
    'M#202601#RBU_0001': 10,
    'M#202601#RBU_0006': 90,
    'M#202601#RBU_0999': null,
  }) as unknown as MainRow;

const makeGrid = (items: MainRow[]) => {
  const host = document.createElement('div');
  document.body.appendChild(host);
  return new FlexGrid(host, {
    autoGenerateColumns: false,
    columnGroups: normalizeDynamicColumns(buildDynamicColumns(items, false)) as never,
    itemsSource: items,
  });
};

// editTracker.test.ts 와 동일 — jsdom 에는 레이아웃이 없어 startEditing 이 죽으므로
//   Wijmo `_EditHandler.finishEditing` 의 커밋 경로(setCellData(coerce=true))만 재현한다.
const commitTyped = (grid: FlexGrid, row: number, col: number, text: string) => {
  const rng = new CellRange(row, col);
  grid.beginningEdit.raise(grid, new CellRangeEventArgs(grid.cells, rng));
  const ok = grid.cells.setCellData(row, col, text, true, false);
  grid.cellEditEnded.raise(grid, new CellRangeEventArgs(grid.cells, rng));
  return ok;
};

const indexOfBinding = (grid: FlexGrid, binding: string) => {
  for (let i = 0; i < grid.columns.length; i++) {
    if (grid.columns[i].binding === binding) return i;
  }
  return -1;
};

describe('구분(RBU_0999) 컬럼 — 입력값이 셀을 벗어날 때 유지되는가', () => {
  it('구분 leaf 는 dataType=String, 기여율 leaf 는 dataType=Number 로 정규화된다', () => {
    const columns = normalizeDynamicColumns(buildDynamicColumns([sampleRow()], false));
    const leaves = columns.flatMap(group => group.columns ?? [group]);

    const division = leaves.find(leaf => leaf.binding === 'M#202601#RBU_0999');
    const ratio = leaves.find(leaf => leaf.binding === 'M#202601#RBU_0001');

    expect(division?.dataType).toBe(DataType.String);
    expect(ratio?.dataType).toBe(DataType.Number);
  });

  it('구분 셀에 문자열을 커밋하면 행 데이터에 남는다', () => {
    const items = [sampleRow()];
    const grid = makeGrid(items);
    const col = indexOfBinding(grid, 'M#202601#RBU_0999');

    expect(col).toBeGreaterThanOrEqual(0);
    expect(grid.columns[col].dataType).toBe(DataType.String);

    const ok = commitTyped(grid, 0, col, 'COMMISSION');

    expect(ok).toBe(true);
    expect((items[0] as unknown as Record<string, unknown>)['M#202601#RBU_0999']).toBe(
      'COMMISSION'
    );
  });

  it('커밋 후 셀/행을 벗어나도(collectionView commitEdit) 값이 남는다', () => {
    const items = [sampleRow(), sampleRow()];
    const grid = makeGrid(items);
    const divisionCol = indexOfBinding(grid, 'M#202601#RBU_0999');
    const ratioCol = indexOfBinding(grid, 'M#202601#RBU_0001');
    const cv = grid.editableCollectionView;

    // Wijmo `_EditHandler.startEditing` — 편집 시작 시 행 단위 editItem(=원본 clone 스냅샷).
    cv.editItem(items[0]);
    commitTyped(grid, 0, divisionCol, 'COMMISSION');

    // 같은 행의 다른 셀로 이동 → editItem 재호출(같은 item 이면 clone 유지) → 값 커밋.
    cv.editItem(items[0]);
    commitTyped(grid, 0, ratioCol, '20');

    // 다른 행으로 이동 → rowEditEnding → commitEdit.
    cv.commitEdit();

    const row = items[0] as unknown as Record<string, unknown>;
    expect(row['M#202601#RBU_0999']).toBe('COMMISSION');
    expect(row['M#202601#RBU_0001']).toBe(20);
  });
});
