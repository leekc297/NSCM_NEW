import { DataType } from '@mescius/wijmo';
import { CellRange, CellRangeEventArgs, FlexGrid } from '@mescius/wijmo.grid';
import { describe, expect, it } from 'vitest';

import type { FlexGridColumnConfig } from '@foundation/models';

import { normalizeDynamicColumns } from './columnMapping';
import { EditTracker } from './editTracker';

// DMF0020 Sales Future Price 의 주차(W_yyyymmdd) 컬럼과 동일 형태 — 숫자 format 만 있고 dataType 미지정.
const dynColumns = (): FlexGridColumnConfig[] =>
  normalizeDynamicColumns([
    {
      header: '2026-08',
      columns: [
        {
          header: 'W31',
          columns: [
            { header: '0801', binding: 'W_20260801', format: 'n3', width: 90 },
            { header: '0803', binding: 'W_20260803', format: 'n3', width: 90 },
          ],
        },
      ],
    },
  ]);

const makeGrid = (items: WijmoRowItem[], columns: FlexGridColumnConfig[] = dynColumns()) => {
  const host = document.createElement('div');
  document.body.appendChild(host);
  const grid = new FlexGrid(host, {
    autoGenerateColumns: false,
    columnGroups: columns as never,
    itemsSource: items,
  });
  new EditTracker(grid);
  return grid;
};

// dataType 보정을 타지 않는 컬럼 — normalizeDynamicColumns 를 거치지 않는 그리드(정적 컬럼 등)에서
//   Wijmo 는 items[0] 로만 타입을 추론한다. 첫 행이 비면 Object 로 남아 입력이 문자열로 저장된다.
//   EditTracker 는 그 경우에도 원복을 판정해야 하므로 안전망을 따로 검증한다.
const untypedColumns = (): FlexGridColumnConfig[] => [
  { header: '0801', binding: 'W_20260801', format: 'n3', width: 90, isRequired: false },
];

// jsdom 은 레이아웃(clientHeight)이 없어 startEditing 이 죽는다 →
//   Wijmo `_EditHandler.finishEditing` 과 같은 순서로 재현한다:
//   beginningEdit → cells.setCellData(입력문자열, coerce=true) → cellEditEnded.
const typeInto = (grid: FlexGrid, row: number, col: number, text: string) => {
  const rng = new CellRange(row, col);
  grid.beginningEdit.raise(grid, new CellRangeEventArgs(grid.cells, rng));
  grid.cells.setCellData(row, col, text, true, false);
  grid.cellEditEnded.raise(grid, new CellRangeEventArgs(grid.cells, rng));
};

// Delete 키 = Wijmo `_KeyboardHandler._deleteRange` 와 동일 경로(빈 문자열 커밋).
const pressDelete = (grid: FlexGrid, row: number, col: number) => typeInto(grid, row, col, '');

describe('EditTracker — 수정 후 원래 값으로 되돌리면 CRUD_TYPE 이 풀린다', () => {
  it('값이 있는 셀 — 수정 후 같은 값 재입력', () => {
    const items: WijmoRowItem[] = [{ W_20260801: 61386, W_20260803: 70000 }];
    const grid = makeGrid(items);

    typeInto(grid, 0, 0, '80000');
    expect(items[0].CRUD_TYPE).toBe('M');

    typeInto(grid, 0, 0, '61386');
    expect(items[0].CRUD_TYPE).toBeUndefined();
  });

  it('값이 있는 셀 — Delete 로 비운 뒤 같은 값 재입력', () => {
    const items: WijmoRowItem[] = [{ W_20260801: 61386, W_20260803: 70000 }];
    const grid = makeGrid(items);

    pressDelete(grid, 0, 0);
    expect(items[0].CRUD_TYPE).toBe('M');

    typeInto(grid, 0, 0, '61386');
    expect(items[0].CRUD_TYPE).toBeUndefined();
  });

  it('원래 빈(null) 셀 — 입력했다가 다시 비움', () => {
    const items: WijmoRowItem[] = [{ W_20260801: 61386, W_20260803: null }];
    const grid = makeGrid(items);

    typeInto(grid, 0, 1, '5000');
    expect(items[0].CRUD_TYPE).toBe('M');

    pressDelete(grid, 0, 1);
    expect(items[0].CRUD_TYPE).toBeUndefined();
  });

  it('응답에 키 자체가 없던(undefined) 셀 — 입력했다가 다시 비움', () => {
    const items: WijmoRowItem[] = [{ W_20260801: 61386 }]; // W_20260803 키 없음
    const grid = makeGrid(items);

    typeInto(grid, 0, 1, '5000');
    expect(items[0].CRUD_TYPE).toBe('M');

    pressDelete(grid, 0, 1);
    expect(items[0].CRUD_TYPE).toBeUndefined();
  });

  it('dataType 미보정 + 첫 행이 빈 컬럼(입력이 문자열로 저장) 에서도 원복된다', () => {
    const items: WijmoRowItem[] = [{ W_20260801: null }, { W_20260801: 61386 }];
    const grid = makeGrid(items, untypedColumns());
    expect(grid.columns[0].dataType).toBe(DataType.Object);

    pressDelete(grid, 1, 0);
    expect(items[1].CRUD_TYPE).toBe('M');

    // 빈 셀에 다시 입력하면 숫자가 아니라 문자열로 저장된다 — 그래도 원본(number)과 같다고 봐야 한다.
    typeInto(grid, 1, 0, '61386');
    expect(items[1].W_20260801).toBe('61386');
    expect(items[1].CRUD_TYPE).toBeUndefined();
  });

  it('여러 셀 중 하나만 되돌리면 수정상태가 유지된다', () => {
    const items: WijmoRowItem[] = [{ W_20260801: 61386, W_20260803: 70000 }];
    const grid = makeGrid(items);

    typeInto(grid, 0, 0, '80000');
    typeInto(grid, 0, 1, '90000');
    typeInto(grid, 0, 0, '61386');

    expect(items[0].CRUD_TYPE).toBe('M');

    typeInto(grid, 0, 1, '70000');
    expect(items[0].CRUD_TYPE).toBeUndefined();
  });

  it('표기가 다른 문자열은 변경으로 남긴다 (숫자 오탐 방지)', () => {
    const items: WijmoRowItem[] = [{ W_20260801: null }, { W_20260801: 100 }];
    const grid = makeGrid(items, untypedColumns());

    pressDelete(grid, 1, 0);
    typeInto(grid, 1, 0, '0100'); // 숫자값은 같아도 표기가 달라 사용자 입력을 존중
    expect(items[1].W_20260801).toBe('0100');
    expect(items[1].CRUD_TYPE).toBe('M');
  });

  it('신규행(I) / 삭제행(D) 의 CRUD_TYPE 은 덮지 않는다', () => {
    const items: WijmoRowItem[] = [{ W_20260801: 61386, W_20260803: null, CRUD_TYPE: 'I' }];
    const grid = makeGrid(items);

    typeInto(grid, 0, 0, '80000');
    expect(items[0].CRUD_TYPE).toBe('I');

    typeInto(grid, 0, 0, '61386');
    expect(items[0].CRUD_TYPE).toBe('I');
  });
});
