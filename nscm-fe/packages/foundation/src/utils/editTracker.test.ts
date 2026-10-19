import { DataType } from '@mescius/wijmo';
import { CellRange, CellRangeEventArgs, FlexGrid } from '@mescius/wijmo.grid';
import { describe, expect, it } from 'vitest';

import type { FlexGridColumnConfig } from '@foundation/models';

import { normalizeDynamicColumns } from './columnMapping';
import { clampNegativeCellToZero, clearCellValue, EditTracker } from './editTracker';

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

describe('clampNegativeCellToZero — 음수 입력 시 0 보정 (AS-IS DMF0006 Dsdm_Changed)', () => {
  // DataGrid 와 같은 순서로 재현: EditTracker 의 cellEditEnded 가 먼저 돌고, 그 뒤 clamp 가 붙는다.
  const makeTracked = (items: WijmoRowItem[]) => {
    const host = document.createElement('div');
    document.body.appendChild(host);
    const grid = new FlexGrid(host, {
      autoGenerateColumns: false,
      columnGroups: untypedColumns() as never,
      itemsSource: items,
    });
    const tracker = new EditTracker(grid);
    // clamp 는 EditTracker 뒤에 등록된다(= 등록 순서상 나중에 실행).
    grid.cellEditEnded.addHandler((_s, e) =>
      clampNegativeCellToZero(items[e.row], 'W_20260801', tracker)
    );
    return { grid, tracker };
  };

  it('값이 있던 셀에 음수 입력 → 0 으로 보정되고 수정상태(M) 유지', () => {
    const items: WijmoRowItem[] = [{ W_20260801: 100 }];
    const { grid } = makeTracked(items);

    typeInto(grid, 0, 0, '-5');
    expect(items[0].W_20260801).toBe('0');
    expect(items[0].CRUD_TYPE).toBe('M'); // 100 → 0 은 실제 변경
  });

  it('원본이 0 인 셀에 음수 입력 → 0 보정 후 수정상태가 풀린다', () => {
    const items: WijmoRowItem[] = [{ W_20260801: 0 }];
    const { grid } = makeTracked(items);

    typeInto(grid, 0, 0, '-5');
    expect(items[0].W_20260801).toBe('0');
    expect(items[0].CRUD_TYPE).toBeUndefined(); // 0 → 0, 변경 아님
  });

  it('양수 · 0 · 빈칸 입력은 건드리지 않는다', () => {
    const items: WijmoRowItem[] = [{ W_20260801: 100 }, { W_20260801: 100 }, { W_20260801: 100 }];
    const { grid } = makeTracked(items);

    // 첫 행이 number 라 Wijmo 가 입력을 number 로 coerce 한다 — clamp 가 손대지 않았음을 확인.
    typeInto(grid, 0, 0, '7');
    expect(items[0].W_20260801).toBe(7);

    typeInto(grid, 1, 0, '0');
    expect(items[1].W_20260801).toBe(0);

    pressDelete(grid, 2, 0);
    expect(items[2].W_20260801).toBeNull(); // 빈칸(null)은 clamp 대상 아님 — 음수만 보정
  });

  it('원래 빈 셀에 음수 입력 → 0 으로 보정된다 (빈→0 은 실제 변경이므로 M)', () => {
    const items: WijmoRowItem[] = [{ W_20260801: null }, { W_20260801: 100 }];
    const { grid } = makeTracked(items);

    typeInto(grid, 0, 0, '-5');
    expect(items[0].W_20260801).toBe('0');
    // 문자열 '0' 은 사용자가 셀에 명시 입력한 표기 → 원본 빈칸과 구분해 변경으로 본다
    //   (isSameValue: 빈칸 vs 숫자 0 만 동일, 빈칸 vs '0' 은 상이). AS-IS 도 빈 셀에 -5 입력 =
    //   SetText("0") = 수정으로 취급한다.
    expect(items[0].CRUD_TYPE).toBe('M');
  });
});

describe('clearCellValue — 상위 변경 시 하위 셀 cascade 비우기 (AS-IS DMF0006 spdMain_ComboSelChange)', () => {
  // clearCellValue 는 그리드 셀 입력이 아니라 row + tracker 에 직접 작용한다. 상위 셀을 먼저
  //   EditTracker 로 바꿔 둔 뒤(= 원본 기록이 있는 상태) 하위 셀 cascade 를 재현한다.
  const makeTracked = (items: WijmoRowItem[]) => {
    const host = document.createElement('div');
    document.body.appendChild(host);
    const grid = new FlexGrid(host, {
      autoGenerateColumns: false,
      columnGroups: [
        { header: 'Team', binding: 'DEPT_ID', width: 90 },
        { header: 'End Customer', binding: 'END_CUSTOMER', width: 90 },
        { header: 'Sales Site', binding: 'SCM_SITE_ID', width: 90 },
      ] as never,
      itemsSource: items,
    });
    const tracker = new EditTracker(grid);
    return { grid, tracker };
  };

  it('값이 있던 하위 셀을 비우면 빈값 + 수정상태(M)', () => {
    const items: WijmoRowItem[] = [{ DEPT_ID: 'T1', END_CUSTOMER: 'C1', SCM_SITE_ID: 'S1' }];
    const { tracker } = makeTracked(items);

    clearCellValue(items[0], 'END_CUSTOMER', tracker);
    clearCellValue(items[0], 'SCM_SITE_ID', tracker);

    expect(items[0].END_CUSTOMER).toBe('');
    expect(items[0].SCM_SITE_ID).toBe('');
    expect(items[0].CRUD_TYPE).toBe('M');
  });

  it('이미 비어 있는 셀은 건드리지 않는다 (거짓 M 방지)', () => {
    const items: WijmoRowItem[] = [{ DEPT_ID: 'T1', END_CUSTOMER: null, SCM_SITE_ID: '' }];
    const { tracker } = makeTracked(items);

    clearCellValue(items[0], 'END_CUSTOMER', tracker);
    clearCellValue(items[0], 'SCM_SITE_ID', tracker);

    expect(items[0].END_CUSTOMER).toBeNull(); // null 그대로 — 손대지 않음
    expect(items[0].SCM_SITE_ID).toBe('');
    expect(items[0].CRUD_TYPE).toBeUndefined();
  });

  it('비웠다가 원래 값으로 되돌리면 수정상태가 풀린다', () => {
    const items: WijmoRowItem[] = [{ DEPT_ID: 'T1', END_CUSTOMER: 'C1', SCM_SITE_ID: 'S1' }];
    const { tracker } = makeTracked(items);

    clearCellValue(items[0], 'END_CUSTOMER', tracker);
    expect(items[0].CRUD_TYPE).toBe('M');

    tracker.storeChange(items[0], 'END_CUSTOMER', '', 'C1');
    items[0].END_CUSTOMER = 'C1';
    expect(items[0].CRUD_TYPE).toBeUndefined();
  });

  it('신규행(I) 의 CRUD_TYPE 은 덮지 않는다', () => {
    const items: WijmoRowItem[] = [
      { DEPT_ID: 'T1', END_CUSTOMER: 'C1', SCM_SITE_ID: 'S1', CRUD_TYPE: 'I' },
    ];
    const { tracker } = makeTracked(items);

    clearCellValue(items[0], 'END_CUSTOMER', tracker);
    expect(items[0].END_CUSTOMER).toBe('');
    expect(items[0].CRUD_TYPE).toBe('I');
  });
});
