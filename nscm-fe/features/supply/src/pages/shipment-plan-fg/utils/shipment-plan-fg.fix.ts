// Fix/Unfix 대상 셀 판정과 선택 범위 수집 — AS-IS Set_FixCellColor(.cs:1648-1734)와 SaveData_FixInfo(.cs:4296-4561) 이식.
//   그리드(wijmo)에 직접 의존하지 않도록 최소 구조(GridLike)만 받는다.
import type { EditTracker } from '@foundation/utils';

import { MEASURE } from '../shipment-plan-fg.constants';
import type { FixInfoRow } from '../shipment-plan-fg.types';

import { dynColKindOf } from './shipment-plan-fg.editLock';

type Rec = Record<string, unknown>;

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

// Fix 정보(O_RC3) 행과 그리드 행을 잇는 키 — AS-IS GetFilterStr(KEY_IDX, FROM_SITE, INCOTERMS, BOD_ID, .cs:1672-1695).
//   그리드 행은 KEY_IDX 가 없으면 SP 정의(DIVISION_ID‖BIZ_TYPE‖PROJECT_CODE‖ITEM_ID‖TO_SITE‖INCOTERMS)로 조립한다.
export const rowFixKey = (row: Rec): string => {
  const keyIdx =
    s(row.KEY_IDX) ||
    [row.DIVISION_ID, row.BIZ_TYPE, row.PROJECT_CODE, row.ITEM_ID, row.TO_SITE, row.INCOTERMS].map(s).join('');
  return [keyIdx, s(row.FROM_SITE), s(row.INCOTERMS), s(row.BOD_ID)].join('|');
};

const fixInfoKey = (r: FixInfoRow): string =>
  [s(r.KEY_IDX), s(r.FROM_SITE), s(r.INCOTERMS), s(r.BOD_ID)].join('|');

export interface FixedCellSet {
  days: Set<string>; // `${rowKey}|D_yyyymmdd`
  weeks: Set<string>; // `${rowKey}|${주 시작일}` — Weekly W_ 헤더 셀 색칠용
  weekOrMonthStart: Map<string, string>; // binding -> 주/월 시작일(그리드 계산값)
}

export const buildFixedCellSet = (
  fixInfoRows: FixInfoRow[],
  weekOrMonthStart: Map<string, string>
): FixedCellSet => {
  const days = new Set<string>();
  const weeks = new Set<string>();
  fixInfoRows.forEach(r => {
    const day = s(r.YYYYMMDD); // 'D_'+일자
    if (!day) return;
    const rowKey = fixInfoKey(r);
    days.add(`${rowKey}|${day}`);
    const weekStart = weekOrMonthStart.get(day);
    if (weekStart) weeks.add(`${rowKey}|${weekStart}`);
  });
  return { days, weeks, weekOrMonthStart };
};

// 그 행의 그 셀이 Fix 상태인가. D_ 는 일자 키, W_ 는 주 시작일 키로 판정한다(M_ 은 항상 false).
export const isCellFixed = (set: FixedCellSet, row: Rec, binding: string): boolean => {
  const kind = dynColKindOf(binding);
  if (kind === 'D') return set.days.has(`${rowFixKey(row)}|${binding}`);
  if (kind === 'W') {
    const weekStart = set.weekOrMonthStart.get(binding);
    return !!weekStart && set.weeks.has(`${rowFixKey(row)}|${weekStart}`);
  }
  return false;
};

interface RangeLike {
  row: number;
  col: number;
  topRow: number;
  bottomRow: number;
  leftCol: number;
  rightCol: number;
}

export interface GridLike {
  rows: { dataItem?: unknown; isVisible: boolean }[];
  columns: { binding?: string | null; visible: boolean }[];
  selectedRanges?: RangeLike[];
  selection?: RangeLike;
}

export interface FixCell {
  rowIndex: number;
  row: Rec;
  binding: string; // 항상 D_ 컬럼(W_ 선택은 같은 주 D_ 로 펼친다)
}

export interface CollectedFixCells {
  hasSelection: boolean;
  cells: FixCell[]; // 저장 대상
  touched: FixCell[]; // 미저장 검사 대상 — 저장 대상 + 선택된 W_ 셀
}

// 선택 범위에서 Fix/Unfix 대상 셀을 모은다(.cs:4296-4561).
//   SHIP_PLAN_AMEND 행만, 필터로 숨긴 행(.cs:4354)과 숨은 컬럼(.cs:4364) 제외, D_ 셀은 그대로, W_ 셀은 같은 주의
//   D_ 셀로 펼친다(.cs:4436-4517). Unfix 는 Fix 상태인 셀만(.cs:4378, 4447).
export const collectFixCells = (
  grid: GridLike,
  mode: 'FIX' | 'UNFIX',
  fixed: FixedCellSet
): CollectedFixCells => {
  const ranges = (grid.selectedRanges?.length ? grid.selectedRanges : grid.selection ? [grid.selection] : []).filter(
    r => r.row >= 0 && r.col >= 0
  );
  const result: CollectedFixCells = { hasSelection: ranges.length > 0, cells: [], touched: [] };
  if (!result.hasSelection) return result;

  // 주 시작일 -> 그 주의 D_ 컬럼들(컬럼 순서 유지)
  const dayBindingsByWeek = new Map<string, string[]>();
  grid.columns.forEach(c => {
    const binding = c.binding ?? '';
    const weekStart = fixed.weekOrMonthStart.get(binding);
    if (dynColKindOf(binding) !== 'D' || !weekStart) return;
    dayBindingsByWeek.set(weekStart, [...(dayBindingsByWeek.get(weekStart) ?? []), binding]);
  });

  const seen = new Set<string>();
  const push = (rowIndex: number, row: Rec, binding: string) => {
    const key = `${rowIndex}|${binding}`;
    if (seen.has(key)) return;
    seen.add(key);
    const cell: FixCell = { rowIndex, row, binding };
    result.touched.push(cell);
    if (mode === 'UNFIX' && !isCellFixed(fixed, row, binding)) return;
    result.cells.push(cell);
  };

  ranges.forEach(range => {
    for (let r = range.topRow; r <= range.bottomRow; r += 1) {
      const gridRow = grid.rows[r];
      const row = gridRow?.dataItem as Rec | undefined;
      if (!row || !gridRow.isVisible || s(row.MEASURE) !== MEASURE.SHIP_PLAN_AMEND) continue;
      for (let c = range.leftCol; c <= range.rightCol; c += 1) {
        const column = grid.columns[c];
        const binding = column?.binding ?? '';
        if (!column?.visible) continue;
        const kind = dynColKindOf(binding);
        if (kind === 'D') {
          push(r, row, binding);
        } else if (kind === 'W') {
          const weekStart = fixed.weekOrMonthStart.get(binding);
          (weekStart ? (dayBindingsByWeek.get(weekStart) ?? []) : []).forEach(day => push(r, row, day));
        }
      }
    }
  });
  return result;
};

// 선택 셀 중 편집했지만 아직 저장하지 않은 셀이 있는가 — AS-IS 글자색 Red(.cs:4368, 4453) 대응.
export const hasUnsavedCell = (touched: FixCell[], tracker: EditTracker | undefined): boolean => {
  const originals = tracker?.getOriginalValues();
  if (!originals) return false;
  return touched.some(cell => {
    const changed = originals.get(cell.row as never);
    return !!changed && Object.prototype.hasOwnProperty.call(changed, cell.binding);
  });
};
