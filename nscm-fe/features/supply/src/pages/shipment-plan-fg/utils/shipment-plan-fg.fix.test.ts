import { describe, expect, it } from 'vitest';

import { buildFixedCellSet, collectFixCells, type GridLike, hasUnsavedCell, isCellFixed, rowFixKey } from './shipment-plan-fg.fix';
import { buildFixRows } from './shipment-plan-fg.save';

const weekStart = new Map<string, string>([
  ['W_20260209', '20260209'],
  ['D_20260209', '20260209'],
  ['D_20260210', '20260209'],
  ['W_20260216', '20260216'],
  ['D_20260216', '20260216'],
]);

const amendRow = (itemId: string, extra: Record<string, unknown> = {}) => ({
  MEASURE: 'SHIP_PLAN_AMEND',
  DIVISION_ID: '40',
  BIZ_TYPE: 'P',
  PROJECT_CODE: 'PJ',
  ITEM_ID: itemId,
  TO_SITE: 'T1',
  INCOTERMS: 'FOB',
  FROM_SITE: 'F1',
  BOD_ID: 'B1',
  D_20260209: 5,
  D_20260210: 7,
  ...extra,
});

const fixInfo = (itemId: string, day: string) => ({
  KEY_IDX: `40PPJ${itemId}T1FOB`,
  FROM_SITE: 'F1',
  INCOTERMS: 'FOB',
  BOD_ID: 'B1',
  YYYYMMDD: `D_${day}`,
});

const columns = [
  { binding: 'MEASURE', visible: true },
  { binding: 'W_20260209', visible: true },
  { binding: 'D_20260209', visible: true },
  { binding: 'D_20260210', visible: true },
  { binding: 'W_20260216', visible: true },
  { binding: 'D_20260216', visible: false },
];

const range = (top: number, bottom: number, left: number, right: number) => ({
  row: top,
  col: left,
  topRow: top,
  bottomRow: bottom,
  leftCol: left,
  rightCol: right,
});

describe('셀 단위 Fix 판정', () => {
  const set = buildFixedCellSet([fixInfo('I1', '20260210')], weekStart);

  it('같은 행의 같은 일자 셀만 Fix 로 판정한다', () => {
    expect(isCellFixed(set, amendRow('I1'), 'D_20260210')).toBe(true);
    expect(isCellFixed(set, amendRow('I1'), 'D_20260209')).toBe(false);
    expect(isCellFixed(set, amendRow('I2'), 'D_20260210')).toBe(false); // 다른 행
  });

  it('W_ 셀은 Fix 된 일자가 속한 주에서만 Fix 로 판정한다', () => {
    expect(isCellFixed(set, amendRow('I1'), 'W_20260209')).toBe(true);
    expect(isCellFixed(set, amendRow('I1'), 'W_20260216')).toBe(false);
  });

  it('KEY_IDX 가 행에 없으면 정보컬럼으로 조립한다', () => {
    expect(rowFixKey(amendRow('I1'))).toBe('40PPJI1T1FOB|F1|FOB|B1');
    expect(rowFixKey(amendRow('I1', { KEY_IDX: 'X' }))).toBe('X|F1|FOB|B1');
  });
});

describe('collectFixCells', () => {
  const fixed = buildFixedCellSet([fixInfo('I1', '20260210')], weekStart);
  const gridOf = (rows: Record<string, unknown>[], ranges: ReturnType<typeof range>[], visible: boolean[] = []): GridLike => ({
    rows: rows.map((dataItem, i) => ({ dataItem, isVisible: visible[i] ?? true })),
    columns,
    selectedRanges: ranges,
  });

  it('선택이 없으면 hasSelection 이 false 다', () => {
    const grid: GridLike = { rows: [], columns, selectedRanges: [] };
    expect(collectFixCells(grid, 'FIX', fixed).hasSelection).toBe(false);
  });

  it('SHIP_PLAN_AMEND 가 아닌 행과 필터로 숨긴 행은 제외한다', () => {
    const grid = gridOf(
      [amendRow('I1'), { ...amendRow('I2'), MEASURE: 'MKT_FCST' }, amendRow('I3')],
      [range(0, 2, 2, 3)],
      [true, true, false]
    );
    const { cells } = collectFixCells(grid, 'FIX', fixed);
    expect(cells.map(c => `${c.rowIndex}:${c.binding}`)).toEqual(['0:D_20260209', '0:D_20260210']);
  });

  it('W_ 셀 선택은 같은 주의 D_ 셀로 펼치고 숨은 D_ 도 포함한다', () => {
    const grid = gridOf([amendRow('I1')], [range(0, 0, 4, 4)]); // W_20260216 (D_20260216 은 숨김 컬럼)
    const { cells, touched } = collectFixCells(grid, 'FIX', fixed);
    expect(cells.map(c => c.binding)).toEqual(['D_20260216']);
    expect(touched.map(c => c.binding)).toEqual(['D_20260216']);
  });

  it('Unfix 는 Fix 상태인 셀만 대상으로 한다', () => {
    const grid = gridOf([amendRow('I1'), amendRow('I2')], [range(0, 1, 2, 3)]);
    const { cells } = collectFixCells(grid, 'UNFIX', fixed);
    expect(cells.map(c => `${c.rowIndex}:${c.binding}`)).toEqual(['0:D_20260210']);
  });

  it('여러 범위가 겹쳐도 같은 셀은 한 번만 담는다', () => {
    const grid = gridOf([amendRow('I1')], [range(0, 0, 2, 3), range(0, 0, 3, 3)]);
    expect(collectFixCells(grid, 'FIX', fixed).cells).toHaveLength(2);
  });
});

describe('hasUnsavedCell', () => {
  it('편집 이력이 있는 선택 셀이 있으면 true 다', () => {
    const row = amendRow('I1');
    const tracker = { getOriginalValues: () => new Map([[row, { D_20260209: 3 }]]) };
    expect(hasUnsavedCell([{ rowIndex: 0, row, binding: 'D_20260209' }], tracker as never)).toBe(true);
    expect(hasUnsavedCell([{ rowIndex: 0, row, binding: 'D_20260210' }], tracker as never)).toBe(false);
  });
});

describe('buildFixRows', () => {
  it('조회조건의 Plan/Bucket 값과 Fix 플래그를 쓰고 수량은 콤마를 제거한다', () => {
    const row = amendRow('I1', { D_20260209: '1,234', D_20260210: '' });
    const rows = buildFixRows(
      [
        { row, binding: 'D_20260209' },
        { row, binding: 'D_20260210' },
      ],
      {
        userId: 'U',
        timeZone: '',
        fixReason: 'why',
        activeFlag: 'I',
        planStartYyyymmdd: '20260209',
        planType: 'PR',
        seq: '2',
        bucketType: 'WEEKLY',
      }
    );
    expect(rows.map(r => r.qty)).toEqual(['1234', '0']);
    expect(rows[0]).toMatchObject({
      activeFlag: 'I',
      planStartYyyymmdd: '20260209',
      planType: 'PR',
      seq: '2',
      bucketType: 'WEEKLY',
      fixReason: 'why',
      yyyymmdd: '20260209',
      itemId: 'I1',
    });
  });
});
