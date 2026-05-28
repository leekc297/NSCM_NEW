import { type FlexGrid } from '@mescius/wijmo.grid';

import { CELL_INPUT_EDIT_TYPE, CRUD_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig } from '@foundation/models';

type SortableRowItem = {
  SORT_ORD?: string | number | null;
};

const toSortableRowItem = (value: unknown): SortableRowItem | null => {
  if (!value || typeof value !== 'object') return null;
  return value as SortableRowItem;
};

export const GridUtils = {
  getRow: <T>(grid: FlexGrid<T> | null | undefined, index: number) => {
    return grid?.rows[index]?.dataItem as T | null;
  },
  getBinding: <T>(grid: FlexGrid<T> | null | undefined, index: number) => {
    return grid?.columns[index]?.binding as keyof T | null | undefined;
  },
  getSelectedRows: <T>(grid: FlexGrid<T> | null | undefined) => {
    return grid?.selectedRows.map(row => row.dataItem as T);
  },
  getNextSortOrd: <T>(grid: FlexGrid<T> | null | undefined) => {
    if (!grid) return '1';

    let maxSortOrd = 0;

    for (let i = 0; i < grid.rows.length; i += 1) {
      const rowItem = toSortableRowItem(grid.rows[i]?.dataItem);
      const parsed = Number.parseInt(String(rowItem?.SORT_ORD ?? '0'), 10);
      if (Number.isFinite(parsed) && parsed > maxSortOrd) {
        maxSortOrd = parsed;
      }
    }

    return String(maxSortOrd + 1);
  },
  getColumn: <T>(grid: FlexGrid<T> | null | undefined, index: number) => {
    // TODO: 성능 개선 필요 (n -> log n)
    if (!grid) return undefined;
    const flatColumns = (grid.columnGroups as FlexGridColumnConfig[])
      .flatMap(largeGroup => largeGroup.columns ?? [largeGroup])
      .flatMap(smallGroup => smallGroup.columns ?? [smallGroup]);
    return flatColumns[index];
  },
  isEditableCell: <T>(grid: FlexGrid<T> | null | undefined, row: number, col: number) => {
    if (!grid) return false;

    const rowData = GridUtils.getRow(grid, row) as WijmoRowItem;
    const column = GridUtils.getColumn(grid, col);

    const crudType = rowData.CRUD_TYPE;
    const editFlag = rowData.EDIT_FLAG;
    const inputEditType = column?._inputEditType;

    switch (inputEditType) {
      case CELL_INPUT_EDIT_TYPE.MANDATORY:
      case CELL_INPUT_EDIT_TYPE.OPTIONAL:
        return editFlag !== 'N';
      case CELL_INPUT_EDIT_TYPE.MANDATORY_INSERT_ONLY:
      case CELL_INPUT_EDIT_TYPE.OPTIONAL_INSERT_ONLY:
        return editFlag !== 'N' && crudType === CRUD_TYPE.INSERT;
      case CELL_INPUT_EDIT_TYPE.SEARCH_ONLY:
      default:
        return false;
    }
  },
};
