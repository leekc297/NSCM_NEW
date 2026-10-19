import { DataType } from '@mescius/wijmo';
import { CellRange, CellRangeEventArgs, FlexGrid } from '@mescius/wijmo.grid';
import { describe, expect, it, vi } from 'vitest';

import { normalizeDynamicColumns } from '@foundation/utils';

import type { MainRow, SpreadTitleRow } from '../types';

import { buildDynamicColumns, collectRbuCodes } from './ContributeMainGrid';

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
    columnGroups: normalizeDynamicColumns(buildDynamicColumns([], items, false)) as never,
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
    const columns = normalizeDynamicColumns(buildDynamicColumns([], [sampleRow()], false));
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

// 칸 제목 SP(mainTitle) 행 — 2025 년 1월·2월 × 법인 2개 + 구분, 연도 1개. 실제 SP 는 12개월 × 9법인 + 연도 9.
const RBU = ['RBU_0001', 'RBU_0006', 'RBU_0999'];
const titleRow = (key: string, period: string, label: string): SpreadTitleRow =>
  ({
    COLUMN_NAME: key,
    COLUMN_LABEL_NAME: label,
    SMALL_CLASS_LABEL_NAME: label,
    LARGE_CLASS_LABEL_NAME: period,
  }) as SpreadTitleRow;
const titleRows2025 = (): SpreadTitleRow[] => [
  ...['202501', '202502'].flatMap(ym =>
    RBU.map(c =>
      titleRow(`M#${ym}#${c}`, `${ym.slice(0, 4)}-${ym.slice(4)}`, c === 'RBU_0999' ? '구분' : c)
    )
  ),
  ...RBU.map(c => titleRow(`Y#2025#${c}`, '2025', c === 'RBU_0999' ? '구분' : c)),
];
const leavesOf = (cols: ReturnType<typeof buildDynamicColumns>) =>
  cols.flatMap(group => group.columns ?? [group]).map(leaf => leaf.binding);

describe('동적 칸 = 칸 제목 SP 기준 (값이 없는 달·신규 연도도 칸이 있어야 한다)', () => {
  it('데이터가 0행이어도 제목의 월 칸이 전부 생긴다', () => {
    const cols = buildDynamicColumns(titleRows2025(), [], false);
    expect(leavesOf(cols)).toEqual([
      'M#202501#RBU_0001',
      'M#202501#RBU_0006',
      'M#202501#RBU_0999',
      'M#202502#RBU_0001',
      'M#202502#RBU_0006',
      'M#202502#RBU_0999',
    ]);
  });

  it('chkYear 면 Y# 칸만, 기간 헤더는 제목의 LARGE_CLASS_LABEL_NAME 을 쓴다', () => {
    const cols = buildDynamicColumns(titleRows2025(), [], true);
    expect(leavesOf(cols)).toEqual(['Y#2025#RBU_0001', 'Y#2025#RBU_0006', 'Y#2025#RBU_0999']);
    expect(cols[0].header).toBe('2025');
  });

  it('데이터에 1월 값만 있어도 2월 칸이 남고, 제목에 없는 데이터 키는 합집합으로 살린다', () => {
    const data = [{ ...sampleRow(), 'M#202603#RBU_0001': 5 } as unknown as MainRow];
    const bindings = leavesOf(buildDynamicColumns(titleRows2025(), data, false));
    expect(bindings).toContain('M#202502#RBU_0001');
    expect(bindings).toContain('M#202603#RBU_0001');
  });

  it('제목이 비어 있으면 종전처럼 데이터 키로 폴백한다', () => {
    const bindings = leavesOf(buildDynamicColumns([], [sampleRow()], false));
    expect(bindings).toEqual(['M#202601#RBU_0001', 'M#202601#RBU_0006', 'M#202601#RBU_0999']);
  });

  it('저장용 법인 목록은 제목에서 받고 구분(RBU_0999)은 빼며, 제목이 없으면 데이터 키로 폴백한다', () => {
    expect(collectRbuCodes(titleRows2025(), [], false)).toEqual(['RBU_0001', 'RBU_0006']);
    expect(collectRbuCodes([], [sampleRow()], false)).toEqual(['RBU_0001', 'RBU_0006']);
    expect(collectRbuCodes(titleRows2025(), [], true)).toEqual(['RBU_0001', 'RBU_0006']);
  });
});
