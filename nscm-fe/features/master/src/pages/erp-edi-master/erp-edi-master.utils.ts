import { toggleClass } from '@mescius/wijmo';
import {
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';

// 룰 12 §11.7 (2026-06-02): 조회 전용 grid 의 모든 cell 회색 표시 (read-only 시각 강조).
// DMF0008 의 Summary/Repair/SSPM grid 공용 helper.
export const applyReadOnlyColoring = (g: FlexGridType<unknown>): void => {
  g.formatItem.addHandler((_s, e: FormatItemEventArgs) => {
    if (e.panel.cellType !== CellType.Cell) return;
    toggleClass(e.cell, 'wj-cell-non-editable', true);
  });
};
