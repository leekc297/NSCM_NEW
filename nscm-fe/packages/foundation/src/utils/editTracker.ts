import { isUndefined, toggleClass } from '@mescius/wijmo';
import { CellType } from '@mescius/wijmo.grid';
import type { CellRangeEventArgs, FlexGrid, FormatItemEventArgs } from '@mescius/wijmo.grid';

import { CRUD_TYPE } from '@foundation/constants';

// TODO: binding 속성 fallback 고려..? - binding 속성 없는 column 없을듯 - 강민재
export class EditTracker<T extends WijmoRowItem = WijmoRowItem> {
  private readonly _grid: FlexGrid<T>;
  private readonly _originalValues: Map<T, Record<string, WijmoPrimitive>>;
  private _originalValue: WijmoPrimitive;

  private _cellChanging(sender: FlexGrid<T>, event: CellRangeEventArgs) {
    this._originalValue = sender.getCellData(event.row, event.col, false) as WijmoPrimitive;
  }

  private _cellChanged(sender: FlexGrid<T>, event: CellRangeEventArgs) {
    const newValue = sender.getCellData(event.row, event.col, false) as WijmoPrimitive;
    const dataItem = event.getRow().dataItem as T;

    this.storeChange(dataItem, event.getColumn().binding ?? '', this._originalValue, newValue);
  }

  storeChange(item: T, binding: string, originalValue: WijmoPrimitive, newValue: WijmoPrimitive) {
    let editItem = this._originalValues.get(item);
    if (!editItem) {
      editItem = {};
      this._originalValues.set(item, editItem);
    }

    const editValue = editItem[binding];
    const actualOriginalValue = isUndefined(editValue) ? originalValue : editValue;

    if (actualOriginalValue === newValue) {
      delete editItem[binding];
      if (Object.keys(editItem).length === 0) this._originalValues.delete(item);
    } else if (isUndefined(editValue)) {
      editItem[binding] = originalValue;
    }

    if (item.CRUD_TYPE !== CRUD_TYPE.INSERT && item.CRUD_TYPE !== CRUD_TYPE.DELETE) {
      const hasChanges = this._originalValues.has(item);
      item.CRUD_TYPE = hasChanges ? CRUD_TYPE.MODIFY : undefined;
      this._grid.invalidate();
    }
  }

  private _hasChange(item: T, binding: string): boolean {
    const editItem = this._originalValues.get(item);
    if (item.CRUD_TYPE === CRUD_TYPE.INSERT) return true;
    if (editItem === null) return true;
    if (editItem && binding in editItem && editItem[binding] === undefined) return true;
    return editItem !== undefined && !isUndefined(editItem[binding]);
  }

  constructor(grid: FlexGrid<T>) {
    this._grid = grid;
    this._originalValues = new Map();
    this._originalValue = null;
    const cellChanging = this._cellChanging.bind(this);
    const cellChanged = this._cellChanged.bind(this);

    grid.beginningEdit.addHandler(cellChanging);
    grid.pastingCell.addHandler(cellChanging);

    grid.cellEditEnded.addHandler(cellChanged);
    grid.pastedCell.addHandler(cellChanged);

    grid.formatItem.addHandler((sender: FlexGrid, event: FormatItemEventArgs) => {
      if (event.panel.cellType === CellType.Cell) {
        const changed = this._hasChange(
          event.getRow().dataItem as T,
          event.getColumn().binding ?? ''
        );
        toggleClass(event.cell, 'cell-changed', changed);
      }
    });
  }

  clearChanges(): void {
    this._originalValues.clear();
    this._grid.invalidate();
  }

  getOriginalValues(): Map<T, Record<string, WijmoPrimitive>> {
    return this._originalValues;
  }
}
