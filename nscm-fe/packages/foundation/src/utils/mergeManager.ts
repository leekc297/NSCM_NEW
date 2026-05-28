import { AllowMerging, CellRange, CellType, MergeManager } from '@mescius/wijmo.grid';
import type { FlexGrid, GridPanel } from '@mescius/wijmo.grid';

import { CRUD_TYPE } from '@foundation/constants';

export class CustomMergeManager<T extends WijmoRowItem = WijmoRowItem> extends MergeManager {
  private readonly _mergeKeyCache = new Map<string, string>();

  private invalidateRow(row: number): void {
    for (const key of this._mergeKeyCache.keys()) {
      if (key.startsWith(row + ':')) this._mergeKeyCache.delete(key);
    }
  }

  private bindInvalidateEvents(): void {
    this.grid.cellEditEnded.addHandler((s, e) => {
      this.invalidateRow(e.row);
    });

    this.grid.collectionView?.collectionChanged.addHandler(() => {
      this._mergeKeyCache.clear();
    });

    this.grid.sortedColumn.addHandler(() => {
      this._mergeKeyCache.clear();
    });
  }

  constructor(private readonly grid: FlexGrid<T>) {
    super();
    this.bindInvalidateEvents();
  }

  private _getMergeKey(panel: GridPanel, row: number, col: number): string {
    if (row < 0) return '';

    const cacheKey = `${row}:${col}`;
    const cached = this._mergeKeyCache.get(cacheKey);
    if (cached !== undefined) return cached;

    let key: string;
    if (col === 0) key = String(panel.getCellData(row, 0, false));
    else {
      const prev = this._getMergeKey(panel, row, col - 1);
      key = prev + '|' + panel.getCellData(row, col, false);
    }

    this._mergeKeyCache.set(cacheKey, key);
    return key;
  }

  private _getTopLeftMergedRange(
    panel: GridPanel,
    currentRow: number,
    currentCol: number
  ): CellRange | null {
    const rng = new CellRange(currentRow, currentCol);

    for (let rightCol = rng.col; rightCol < panel.columns.length - 1; rightCol++) {
      if (
        panel.getCellData(rng.row, rightCol, true) !==
        panel.getCellData(rng.row, rightCol + 1, true)
      )
        break;
      rng.col2 = rightCol + 1;
    }
    for (let leftCol = rng.col; leftCol > 0; leftCol--) {
      if (
        panel.getCellData(rng.row, leftCol, true) !== panel.getCellData(rng.row, leftCol - 1, true)
      )
        break;
      rng.col = leftCol - 1;
    }

    for (let downRow = rng.row; downRow < panel.rows.length - 1; downRow++) {
      if (
        panel.getCellData(downRow, rng.col, true) !== panel.getCellData(downRow + 1, rng.col, true)
      )
        break;
      rng.row2 = downRow + 1;
    }
    for (let upRow = rng.row; upRow > 0; upRow--) {
      if (panel.getCellData(upRow, rng.col, true) !== panel.getCellData(upRow - 1, rng.col, true))
        break;
      rng.row = upRow - 1;
    }

    return rng;
  }

  private _isSameHorizontalRange(
    panel: GridPanel,
    row: number,
    col: number,
    left: number,
    right: number
  ): boolean {
    const val = panel.getCellData(row, col, false) as WijmoPrimitive;
    let l = col,
      r = col;

    while (l > 0 && panel.getCellData(row, l - 1, false) === val) l--;
    while (r < panel.columns.length - 1 && panel.getCellData(row, r + 1, false) === val) r++;

    return l === left && r === right;
  }

  private _getColumnHeaderMergedRange(
    panel: GridPanel,
    currentRow: number,
    currentCol: number
  ): CellRange | null {
    const rng = new CellRange(currentRow, currentCol);
    const cellValue = panel.getCellData(currentRow, currentCol, false) as WijmoPrimitive;

    if (cellValue === null || cellValue === undefined || cellValue === '') return null;
    if (
      ![AllowMerging.All, AllowMerging.AllHeaders, AllowMerging.ColumnHeaders].includes(
        panel.grid.allowMerging
      )
    )
      return null;

    while (rng.col > 0 && panel.getCellData(currentRow, rng.col - 1, false) === cellValue)
      rng.col--;

    while (
      rng.col2 < panel.columns.length - 1 &&
      panel.getCellData(currentRow, rng.col2 + 1, false) === cellValue
    )
      rng.col2++;

    while (rng.row > 0) {
      const topValue = panel.getCellData(rng.row - 1, currentCol, false) as WijmoPrimitive;

      if (topValue !== cellValue) break;
      if (!this._isSameHorizontalRange(panel, rng.row - 1, currentCol, rng.col, rng.col2)) break;

      rng.row--;
    }

    while (rng.row2 < panel.rows.length - 1) {
      const bottomValue = panel.getCellData(rng.row2 + 1, currentCol, false) as WijmoPrimitive;

      if (bottomValue !== cellValue) break;
      if (!this._isSameHorizontalRange(panel, rng.row2 + 1, currentCol, rng.col, rng.col2)) break;

      rng.row2++;
    }

    return rng.isSingleCell ? null : rng;
  }

  private _getCellMergedRange(
    panel: GridPanel,
    currentRow: number,
    currentCol: number
  ): CellRange | null {
    if (!panel.columns[currentCol]?.allowMerging) return null;
    if (![AllowMerging.All, AllowMerging.Cells].includes(panel.grid.allowMerging)) return null;

    const rng = new CellRange(currentRow, currentCol);
    const item = panel.grid.collectionView.items[currentRow] as WijmoRowItem;
    const rowCrudStat = item?.CRUD_TYPE;
    if (rowCrudStat === CRUD_TYPE.INSERT) return null;

    let minRow = panel.viewRange.row;
    const maxRow = panel.viewRange.row2;
    const staticHeight = panel.grid.rows.defaultSize;
    const checkCount = minRow * staticHeight + panel.grid.scrollPosition.y + staticHeight;
    const currentKey = this._getMergeKey(panel, currentRow, currentCol);

    if (1 < checkCount && checkCount <= 15 && ((minRow === 0 && checkCount <= 12) || minRow > 0))
      minRow = minRow + 1;

    while (rng.row > minRow) {
      const r = rng.row - 1;
      if (rng.row <= 0 || this._getMergeKey(panel, r, currentCol) !== currentKey) break;

      const nextCrudType = (panel.grid.collectionView.items[r] as WijmoRowItem)?.CRUD_TYPE;
      if (nextCrudType && nextCrudType === CRUD_TYPE.INSERT) break;
      rng.row--;
    }

    while (rng.row2 < maxRow) {
      const r = rng.row2 + 1;
      if (this._getMergeKey(panel, r, currentCol) !== currentKey) break;
      const nextCrudType = (panel.grid.collectionView.items[r] as WijmoRowItem)?.CRUD_TYPE;
      if (nextCrudType && nextCrudType === CRUD_TYPE.INSERT) break;
      rng.row2++;
    }

    if (rng.isSingleCell) return null;
    else return rng;
  }

  // TODO: 그 외의 영역에서 merge 필요할 경우 추가 구현 필요 - 강민재
  getMergedRange(panel: GridPanel, currentRow: number, currentCol: number): CellRange | null {
    const cellType = panel.cellType;
    const mergeType = panel.grid.allowMerging;

    if (cellType === CellType.TopLeft)
      return this._getTopLeftMergedRange(panel, currentRow, currentCol);
    if (mergeType === AllowMerging.None) return null;
    if (cellType === CellType.ColumnHeader)
      return this._getColumnHeaderMergedRange(panel, currentRow, currentCol);
    else if (cellType === CellType.Cell)
      return this._getCellMergedRange(panel, currentRow, currentCol);
    else return null;
  }
}
