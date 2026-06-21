import { toggleClass } from '@mescius/wijmo';
import {
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';

// 룰 12 §11.7 (2026-06-02) — 조회 전용 grid 의 모든 cell 회색 표시 (read-only 시각 강조).
// DMF0008 Summary / Repair (조회 전용) 의 DataGrid `formatItem` prop 으로 전달.
// SCSS `:global(.wj-cell-non-editable)` (ErpEdiMaster.module.scss) 가 `background: #f1f4f3` 적용.
// 다른 formatItem 핸들러와 함께 사용 시 chain 으로 호출 (gray 먼저 → 색상 override 나중 호출).
export const applyReadOnlyColoring = <T = unknown>(
  _grid: FlexGridType<T>,
  args: FormatItemEventArgs
): void => {
  if (args.panel.cellType !== CellType.Cell) return;
  toggleClass(args.cell, 'wj-cell-non-editable', true);
};
