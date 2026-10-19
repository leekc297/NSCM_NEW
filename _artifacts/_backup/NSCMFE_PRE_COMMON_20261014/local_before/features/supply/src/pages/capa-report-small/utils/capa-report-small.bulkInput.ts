import type { FlexGrid } from '@mescius/wijmo.grid';

import type { EditTracker } from '@foundation/utils';

import { DAY_TYPE, MEASURE } from '../capa-report-small.constants';
import type { CapaRowItem } from '../capa-report-small.types';

import { kindOf } from './capa-report-small.dynamicColumns';

export type BulkInputError =
  | 'NO_SELECTION' // 선택 셀 없음 (SelectDay)
  | 'INVALID_YN' // NO_WORK Y/N 아님
  | 'INVALID_LOAD_RATE' // 0.0~100.0 벗어남
  | 'INVALID_RAMP_UP' // 0.0~1.0 벗어남
  | 'INVALID_DAILY_CAPA'; // 정수 < 0

interface BulkInputArgs {
  grid: FlexGrid;
  tracker: EditTracker;
  category: string; // measure code (NO_WORK/LOAD_RATE/RAMP_UP/DAILY_CAPA)
  dayType: string; // EveryDay | SelectDay
  value: string;
  isCellEditable: (binding: string, row: CapaRowItem) => boolean;
}

/** 값 검증 (design 03 §R2 / buttonGuards #19~27). null = 통과, 그 외 = 에러코드. */
export const validateBulkValue = (category: string, value: string): BulkInputError | null => {
  const v = value.trim();
  if (category === MEASURE.NO_WORK) {
    return v === 'Y' || v === 'N' ? null : 'INVALID_YN';
  }
  const n = Number(v);
  if (category === MEASURE.LOAD_RATE) {
    return Number.isFinite(n) && n >= 0 && n <= 100 ? null : 'INVALID_LOAD_RATE';
  }
  if (category === MEASURE.RAMP_UP) {
    return Number.isFinite(n) && n >= 0 && n <= 1 ? null : 'INVALID_RAMP_UP';
  }
  if (category === MEASURE.DAILY_CAPA) {
    return Number.isFinite(n) && Number.isInteger(n) && n >= 0 ? null : 'INVALID_DAILY_CAPA';
  }
  return null;
};

/**
 * 선택 영역 일괄입력 (design 03 §R2 — AS-IS btnInput_Click).
 *   - 대상 행 = MEASURE_UI === category. 대상 컬럼 = DAILY_CAPA→M_, 그 외→D_ (편집 가능·현재 표시 셀만).
 *   - DayType EveryDay = 매칭 행의 전 대상 컬럼 / SelectDay = 선택 셀 중 대상만.
 *   - 값은 검증(validateBulkValue) 통과 후 호출한다.
 */
export const applyBulkInput = (args: BulkInputArgs): BulkInputError | null => {
  const { grid, tracker, category, dayType, value, isCellEditable } = args;
  const targetKind = category === MEASURE.DAILY_CAPA ? 'M' : 'D';
  const ranges = grid.selectedRanges;
  if (dayType === DAY_TYPE.SELECT_DAY && (!ranges || ranges.length === 0)) return 'NO_SELECTION';

  const setCell = (r: number, c: number) => {
    const binding = grid.columns[c]?.binding ?? '';
    if (kindOf(binding) !== targetKind) return;
    const col = grid.columns[c];
    if (!col || col.visible === false) return;
    const row = grid.rows[r]?.dataItem as CapaRowItem | undefined;
    if (!row) return;
    if ((typeof row.MEASURE_UI === 'string' ? row.MEASURE_UI : '') !== category) return;
    if (!isCellEditable(binding, row)) return;
    const old = (row as Record<string, unknown>)[binding];
    const next = category === MEASURE.NO_WORK ? value.trim().toUpperCase() : Number(value);
    tracker.storeChange(
      row as never,
      binding,
      old as never,
      next as never
    );
    (row as Record<string, unknown>)[binding] = next;
  };

  if (dayType === DAY_TYPE.EVERY_DAY) {
    // 선택 행(들)의 매칭 행 전체 대상 컬럼. 선택이 없으면 전 행 대상.
    const rowSet = new Set<number>();
    (ranges ?? []).forEach(range => {
      for (let r = range.topRow; r <= range.bottomRow; r++) rowSet.add(r);
    });
    const rows = rowSet.size > 0 ? [...rowSet] : grid.rows.map((_, i) => i);
    for (const r of rows) {
      for (let c = 0; c < grid.columns.length; c++) setCell(r, c);
    }
  } else {
    (ranges ?? []).forEach(range => {
      for (let r = range.topRow; r <= range.bottomRow; r++) {
        for (let c = range.leftCol; c <= range.rightCol; c++) setCell(r, c);
      }
    });
  }
  grid.invalidate();
  return null;
};
