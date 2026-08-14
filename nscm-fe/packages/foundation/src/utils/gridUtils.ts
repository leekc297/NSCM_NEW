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
  /**
   * 변경분(CRUD_TYPE 마킹된 행) 수집. 저장 대상 조립의 표준 API —
   * 화면에서 `data.filter(i => i.CRUD_TYPE)` 를 직접 조립하지 말고 이것을 사용한다.
   * collectionView.sourceCollection 기준이므로 필터로 숨겨진 행의 변경분도 포함된다.
   */
  getChangedRows: <T>(
    grid: FlexGrid<T> | null | undefined,
    crudType?: (typeof CRUD_TYPE)[keyof typeof CRUD_TYPE]
  ): T[] => {
    const source = (grid?.collectionView?.sourceCollection ?? []) as (T & WijmoRowItem)[];
    return source.filter(item =>
      crudType ? item.CRUD_TYPE === crudType : Boolean(item.CRUD_TYPE)
    );
  },
  /**
   * 미저장 변경 존재 여부. 편집 중인 셀(activeEditor)이 있으면 그 값 역시 아직
   * 저장되지 않은 입력이므로 dirty 로 본다 (wingui isUpdated 의 commit-후-판정과 같은 취지).
   */
  isDirty: <T>(grid: FlexGrid<T> | null | undefined): boolean => {
    if (!grid) return false;
    if (grid.activeEditor) return true;
    return GridUtils.getChangedRows(grid).length > 0;
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
