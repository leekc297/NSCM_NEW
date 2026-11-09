import { CellRange, CellType, type FlexGrid, type GridPanel, MergeManager } from '@mescius/wijmo.grid';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig } from '@foundation/models';
import { ensureTopLeftMergeManager } from '@foundation/utils';

import { BUCKET_TYPE } from '../sales-price-model-group.constants';
import type { ModelGroupRow } from '../sales-price-model-group.types';

import {
  cellOf,
  isoWeekLabel,
  MONTH_KEY_RE,
  sameBundle,
  WEEK_KEY_RE,
} from './sales-price-model-group.util';

// DMF0083 그리드 전용 도우미 — 기간 칸 구성, 머리글 높이, 머지 관리자 (메인 그리드 · Price Batch Input 공용).

// ===== 기간 칸 =====
// 화면에 세울 기간 칸 — 시간축 키 ∪ 조회 결과 키 중 지금 Bucket 의 칸만 (주 = W_, 월 = M_).
//   시간축이 먼저다: BE 가 값 없는 칸을 응답에서 빼므로 행 키만 보면 값 있는 주만 칸이 선다(원천 DMF0020 과 같은 이유).
export const periodBindingsOf = (
  axisKeys: readonly string[],
  rows: readonly ModelGroupRow[],
  bucketType: BUCKET_TYPE
): string[] => {
  const pattern = bucketType === BUCKET_TYPE.MONTHLY ? MONTH_KEY_RE : WEEK_KEY_RE;
  const set = new Set<string>(axisKeys.filter(k => pattern.test(k)));
  for (const row of rows) for (const k of Object.keys(row)) if (pattern.test(k)) set.add(k);
  return [...set].sort();
};

const leafOf = (binding: string, header: string, width: number): FlexGridColumnConfig => ({
  binding,
  header,
  align: 'right',
  format: 'n3', // 설계서 W_ O57 "소수 3자리 (n3)"
  width,
  allowDragging: false,
  allowMerging: false,
  allowResizing: true,
  allowSorting: false,
  visible: true,
  // 기간 칸은 메타에 없는 동적 칸이다 — 편집 가능 여부는 그리드 beginningEdit 가 LOC 행만 연다.
  _inputEditType: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
  _display: true,
});

// 기간 칸 머리글 — 주: 연월 → 주차(Wxx) → 일자(MMDD) 3단 / 월: 연월 1단.
export const buildPeriodColumns = (
  bindings: readonly string[],
  bucketType: BUCKET_TYPE,
  width = 90
): FlexGridColumnConfig[] => {
  if (bindings.length === 0) return [];
  if (bucketType === BUCKET_TYPE.MONTHLY) {
    return bindings.map(b => leafOf(b, `${b.slice(2, 6)}-${b.slice(6, 8)}`, width));
  }
  const months = new Map<string, Map<string, FlexGridColumnConfig[]>>();
  for (const b of bindings) {
    const ymd = b.slice(2);
    const ym = `${ymd.slice(0, 4)}-${ymd.slice(4, 6)}`;
    const weeks = months.get(ym) ?? new Map<string, FlexGridColumnConfig[]>();
    const week = isoWeekLabel(ymd);
    const leaves = weeks.get(week) ?? [];
    leaves.push(leafOf(b, ymd.slice(4, 8), width));
    weeks.set(week, leaves);
    months.set(ym, weeks);
  }
  return [...months.entries()].map(([ym, weeks]) => ({
    header: ym,
    align: 'center',
    allowSorting: false,
    allowMerging: false,
    columns: [...weeks.entries()].map(([week, leaves]) => ({
      header: week,
      align: 'center',
      allowSorting: false,
      allowMerging: false,
      columns: leaves,
    })),
  }));
};

// ===== 머리글 높이 =====
// 머리글 총높이 48px (UI-04). 고정 칸은 1단, 주 칸은 3단이라 깊이가 달라 실제 머리글 행 수로 나눈다.
const HEADER_TOTAL_HEIGHT = 48;

// 공용 DataGrid 가 컬럼을 다시 적용할 때마다 높이를 되돌리므로 updatedLayout 마다 맞춘다.
//   이미 맞으면 건너뛴다(무한 갱신 방지). 반환 값은 해제 함수 — 그리드 effect 한 곳에서만 건다.
export const attachHeaderHeightNormalizer = (grid: FlexGrid): (() => void) => {
  const normalize = () => {
    const rows = grid.columnHeaders?.rows;
    if (!rows || rows.length === 0) return;
    const per = Math.round(HEADER_TOTAL_HEIGHT / rows.length);
    const done =
      Math.round(rows.defaultSize) === per &&
      Array.from({ length: rows.length }).every((_, i) => Math.round(rows[i]?.height ?? 0) === per);
    if (done) return;
    rows.defaultSize = per;
    for (let i = 0; i < rows.length; i++) rows[i].height = per;
  };
  grid.updatedLayout.addHandler(normalize);
  normalize();
  return () => {
    grid.updatedLayout.removeHandler(normalize);
  };
};

// ===== 머지 =====
// 주 칸 헤더 머지 그룹 — 1단 연월, 2단 주차.
const weekHeaderOf = (binding: string): { ym: string; wk: string } | null => {
  if (!WEEK_KEY_RE.test(binding)) return null;
  const ymd = binding.slice(2);
  return { ym: ymd.slice(0, 6), wk: isoWeekLabel(ymd) };
};

// 그리드 머지 (원천 DMF0020 HierarchicalMergeManager 와 같은 규칙).
//   ① 데이터 셀: mergeBindings 칸을 묶음 단위로 세로 머지 — 앞 칸부터 값이 모두 같고 같은 묶음일 때만.
//      화면에 보이는 행(viewRange) 안에서만 합쳐 스크롤해도 머지 셀의 값이 보인다(GRID-10).
//   ② 열 머리글: 고정 칸은 머리글 전 단 세로 머지, 주 칸은 연월 · 주차 가로 머지.
//   DataGrid 는 mergeManager prop 을 그리드 생성 때 한 번만 걸므로, 칸 목록은 생성자 값이 아니라 조회 함수로 받는다.
//   isSameGroup: 메인 그리드는 같은 묶음(Measure 3행)끼리만, 팝업은 행마다 묶음이 달라 값만 같으면 합친다.
export class ModelGroupMergeManager extends MergeManager {
  constructor(
    private readonly getMergeBindings: () => readonly string[],
    private readonly getFixedBindings: () => readonly string[],
    private readonly isSameGroup: (a: ModelGroupRow, b: ModelGroupRow) => boolean = sameBundle
  ) {
    super();
  }

  getMergedRange(panel: GridPanel, r: number, c: number, _clip = true): CellRange | null {
    const binding = panel.columns[c]?.binding ?? '';
    const mergeBindings = this.getMergeBindings();

    if (panel.cellType === CellType.Cell && mergeBindings.includes(binding)) {
      const rowAt = (i: number): ModelGroupRow | undefined =>
        (panel.rows[i] as unknown as { dataItem?: ModelGroupRow } | undefined)?.dataItem;
      const current = rowAt(r);
      if (!current) return null;
      const left = mergeBindings.slice(0, mergeBindings.indexOf(binding) + 1);
      const same = (i: number): boolean => {
        const other = rowAt(i);
        if (!other || !this.isSameGroup(current, other)) return false;
        // 값은 문자열로 맞춰 비교한다 — 편집 뒤 같은 값이 다른 타입으로 들어와도 묶음이 갈라지지 않게.
        return left.every(k => cellOf(current, k) === cellOf(other, k));
      };
      let top = r;
      let bottom = r;
      while (top > panel.viewRange.row && same(top - 1)) top--;
      while (bottom < panel.viewRange.row2 && same(bottom + 1)) bottom++;
      return top === bottom ? null : new CellRange(top, c, bottom, c);
    }

    if (panel.cellType === CellType.ColumnHeader) {
      if (this.getFixedBindings().includes(binding)) {
        return new CellRange(0, c, panel.rows.length - 1, c);
      }
      const head = weekHeaderOf(binding);
      if (!head || r > 1) return null;
      const match = (i: number): boolean => {
        const other = weekHeaderOf(panel.columns[i]?.binding ?? '');
        return !!other && other.ym === head.ym && (r === 0 || other.wk === head.wk);
      };
      let left = c;
      let right = c;
      while (left > 0 && match(left - 1)) left--;
      while (right < panel.columns.length - 1 && match(right + 1)) right++;
      return new CellRange(r, left, r, right);
    }
    return null;
  }
}

// 화면 머지 관리자를 계속 유지한다.
//   공용 DataGrid 는 mergeManager prop 을 그리드 생성 때 한 번만 건다. 그런데 미저장 변경을 버리는 경로
//   (조회 전 MSG00704 확인 → GridAction.discardChanges)와 GridAction.clear 가 그리드 머지를 공용
//   CustomMergeManager 로 바꿔 버린다. 그 뒤로는 묶음 머지가 사라지고, 공용 머지의 행 캐시가 편집한 행만
//   비워져 Price Master Representative 를 바꾸면 묶음 첫 행만 떨어져 보였다(사용자 보고 2026-11-06).
//   행을 다시 그리거나 레이아웃이 바뀔 때 화면이 건 머지가 아니면 다시 건다. 반환 값은 해제 함수.
export const keepMergeManager = (grid: FlexGrid, manager: MergeManager): (() => void) => {
  // 화면이 마지막으로 건 인스턴스(좌상단 No 머지 감싸기 포함). 이것과 다르면 누가 바꾼 것이다.
  let ours: MergeManager | null = null;
  const reassert = () => {
    if (ours !== null && grid.mergeManager === ours) return;
    grid.mergeManager = manager;
    ensureTopLeftMergeManager(grid);
    ours = grid.mergeManager;
    grid.invalidate();
  };
  reassert();
  grid.loadedRows.addHandler(reassert);
  grid.updatedLayout.addHandler(reassert);
  return () => {
    grid.loadedRows.removeHandler(reassert);
    grid.updatedLayout.removeHandler(reassert);
  };
};
