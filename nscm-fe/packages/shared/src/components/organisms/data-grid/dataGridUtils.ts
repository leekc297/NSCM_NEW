import {
  Tooltip,
  addClass,
  Globalize,
  isNumber,
  Rect,
  SortDescription,
  toggleClass,
} from '@mescius/wijmo';
import type {
  CellRangeEventArgs,
  Column,
  FormatItemEventArgs,
  FlexGrid,
} from '@mescius/wijmo.grid';
import { CellRange, CellType, GroupRow } from '@mescius/wijmo.grid';
import { Selector } from '@mescius/wijmo.grid.selector';
import dayjs from 'dayjs';
import isoWeek from 'dayjs/plugin/isoWeek';

import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE, CRUD_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';

dayjs.extend(isoWeek);

interface SummaryInfo {
  cnt: number;
  cntAll: number;
  sum: number;
  avg: number;
}

export const useDataGridUtils = <T extends WijmoRowItem = WijmoRowItem>() => {
  const _aggregateRange = (
    tally: SummaryInfo,
    grid: FlexGrid<T>,
    ranges: CellRange[],
    rangeIndex: number
  ) => {
    const range = ranges[rangeIndex];
    if (range.topRow === range.bottomRow && range.leftCol === range.rightCol) return;

    for (let row = range.topRow; row <= range.bottomRow; row++) {
      for (let col = range.leftCol; col <= range.rightCol; col++) {
        const isOverlapped = ranges.slice(0, rangeIndex).some(range => range.contains(row, col));
        const cellData = grid.getCellData(row, col, false) as WijmoPrimitive;

        if (isOverlapped || !grid.getColumn(col).visible) continue;
        if (!cellData || cellData === '' || !isNumber(cellData)) continue;

        const value = Number(cellData.toFixed(2));

        tally.cntAll++;
        tally.cnt++;
        tally.sum += value;
      }
    }

    tally.avg = Number.parseFloat(
      (tally?.cnt ?? 0) > 0 ? ((tally?.sum ?? 0) / (tally?.cnt ?? 0)).toFixed(2) : '0'
    );
  };

  const _showAreaInfo = (grid: FlexGrid<T>): SummaryInfo => {
    const tally: SummaryInfo = { cnt: 0, cntAll: 0, sum: 0, avg: 0 };
    const ranges: CellRange[] = grid.selectedRanges;

    for (let rangeIndex = 0; rangeIndex < ranges.length; rangeIndex++)
      _aggregateRange(tally, grid, ranges, rangeIndex);

    return tally;
  };

  const setSummaryTooltip = (grid: FlexGrid<T>) => {
    const tooltip = new Tooltip();

    grid.addEventListener(grid.hostElement, 'mouseup', (mouseEvent: MouseEvent) => {
      const ht = grid.hitTest(mouseEvent);

      if (ht.cellType === CellType.Cell) {
        const areaData = _showAreaInfo(grid);

        if (areaData && areaData.cntAll > 1) {
          const { cntAll, avg, sum } = areaData;
          const content = `
              <div class='grid_summary_popup'>
                <div class='grid_summary_popup_area'>
                  <div class='grid_summary_popup_title'>Count</div>
                  <div class='grid_summary_popup_cnt'>${Globalize.formatNumber(cntAll, 'n0')}</div>
                  <div class='grid_summary_popup_title'>Average</div>
                  <div class='grid_summary_popup_avg'>${Globalize.formatNumber(avg, 'G2')}</div>
                  <div class='grid_summary_popup_title'>Sum</div>
                  <div class='grid_summary_popup_sum'>${Globalize.formatNumber(sum, 'G2')}</div>
                </div>
              </div>`;
          tooltip.show(
            grid.hostElement,
            content,
            new Rect(mouseEvent.clientX, mouseEvent.clientY, 0, 0)
          );

          return;
        }
      }
    });

    grid.scrollPositionChanged.addHandler(() => tooltip.hide());
    grid.selectionChanging.addHandler(() => tooltip.hide());
  };

  const setAggregationRow = (grid: FlexGrid<T>, placement: 'above' | 'below') => {
    if (placement === 'below') {
      grid.columnFooters.rows.push(new GroupRow());
      grid.bottomLeftCells.setCellData(0, 0, 'Σ');
    } else if (placement === 'above') {
      // TODO: aggregation row above 처리 (wijmo demo 참고), 필요없을 시 구현 X - 강민재
    }
  };

  // TODO: checkbox 컬럼, 필요시 추가 구현 필요 - 강민재
  const setCheckbox = (grid: FlexGrid<T>) => new Selector(grid, {});

  const formatPopupIcon = (grid: FlexGrid<T>, formatItemEventArgs: FormatItemEventArgs) => {
    const row = formatItemEventArgs.row;
    const col = formatItemEventArgs.col;
    const cellType = formatItemEventArgs.panel.cellType;
    const dataItem = grid.rows[row]?.dataItem as WijmoRowItem;
    const columnConfig = GridUtils.getColumn(grid, col);

    if (!dataItem || !columnConfig) return;
    if (cellType !== CellType.Cell) return;

    const cellCtrlType = columnConfig._ctrlType;
    const cellInputEditType = columnConfig._inputEditType;
    const cellCrudType = dataItem['CRUD_TYPE'];

    const isEditableCell =
      (cellCrudType === CRUD_TYPE.INSERT &&
        (cellInputEditType === CELL_INPUT_EDIT_TYPE.MANDATORY_INSERT_ONLY ||
          cellInputEditType === CELL_INPUT_EDIT_TYPE.OPTIONAL_INSERT_ONLY)) ||
      cellInputEditType === CELL_INPUT_EDIT_TYPE.MANDATORY ||
      cellInputEditType === CELL_INPUT_EDIT_TYPE.OPTIONAL;

    toggleClass(
      formatItemEventArgs.cell,
      'is-popup',
      cellCtrlType === CELL_CONTROL_TYPE.MODAL && isEditableCell
    );
  };

  const formatSortableColumns = (grid: FlexGrid<T>, event: FormatItemEventArgs) => {
    const panel = event.panel;
    const binding = grid.columns[event.col]?.binding;
    const allowSorting = grid.columns[event.col]?.allowSorting ?? false;

    const isSortable =
      allowSorting &&
      panel.cellType === CellType.ColumnHeader &&
      !grid.collectionView.sortDescriptions.some(
        sortDescription => sortDescription.property === binding
      );

    toggleClass(event.cell, 'is-sortable', isSortable);

    if (isSortable) {
      const existingIcon = event.cell.querySelector('.wj-sort-unsorted-icon');
      if (!existingIcon) {
        const iconSpan = document.createElement('span');
        iconSpan.className = 'wj-sort-unsorted-icon';
        event.cell.appendChild(iconSpan);
      }
    } else {
      const unsortedIcon = event.cell.querySelector('.wj-sort-unsorted-icon');
      if (unsortedIcon) {
        unsortedIcon.remove();
      }
    }
  };

  const formatEditableColumns = (grid: FlexGrid<T>, formatItemEventArgs: FormatItemEventArgs) => {
    const row = formatItemEventArgs.row;
    const col = formatItemEventArgs.col;
    const cellType = formatItemEventArgs.panel.cellType;

    if (cellType === CellType.RowHeader) {
      const rowHeaderCell = formatItemEventArgs.cell;

      if (col === 0) formatItemEventArgs.cell.textContent = (row + 1).toString();
      else if (!grid.isReadOnly && col === 1) {
        delete rowHeaderCell.dataset.status;
        const dataItem = GridUtils.getRow(grid, row);
        if (!dataItem || !dataItem.CRUD_TYPE) return;

        rowHeaderCell.dataset.status = dataItem['CRUD_TYPE'];
      }
    } else if (cellType === CellType.Cell) {
      toggleClass(
        formatItemEventArgs.cell,
        'wj-cell-editable',
        GridUtils.isEditableCell(grid, row, col)
      );

      const crudType = GridUtils.getRow(grid, row)?.CRUD_TYPE;
      const columnGroupProps = GridUtils.getColumn(grid, col);

      toggleClass(
        formatItemEventArgs.cell,
        'wj-cell-popup',
        columnGroupProps?._ctrlType === CELL_CONTROL_TYPE.MODAL &&
          (columnGroupProps?._inputEditType === CELL_INPUT_EDIT_TYPE.MANDATORY ||
            columnGroupProps?._inputEditType === CELL_INPUT_EDIT_TYPE.OPTIONAL ||
            (columnGroupProps?._inputEditType?.startsWith('I') && crudType === CRUD_TYPE.INSERT))
      );
    } else if (cellType === CellType.ColumnHeader) {
      if (row !== grid.columnHeaders.rows.length - 1) return;
      const inputEditType = GridUtils.getColumn(grid, col)?._inputEditType;
      const isMandatory =
        inputEditType === CELL_INPUT_EDIT_TYPE.MANDATORY ||
        inputEditType === CELL_INPUT_EDIT_TYPE.MANDATORY_INSERT_ONLY;

      toggleClass(formatItemEventArgs.cell, 'is-required', isMandatory);
    }
  };

  const setEditableColumns = (grid: FlexGrid<T>) => {
    const defaultEditHandler = (sender: FlexGrid, cellRangeEventArgs: CellRangeEventArgs) => {
      const row = cellRangeEventArgs.row;
      const col = cellRangeEventArgs.col;

      cellRangeEventArgs.cancel = !GridUtils.isEditableCell(grid, row, col);
    };

    const cellEditHandler = (sender: FlexGrid, cellRangeEventArgs: CellRangeEventArgs) => {
      const column = GridUtils.getColumn(sender, cellRangeEventArgs.col);
      const ctrlType = column?._ctrlType;

      if (ctrlType === CELL_CONTROL_TYPE.MODAL) {
        cellRangeEventArgs.cancel = true;
        return;
      }

      defaultEditHandler(sender, cellRangeEventArgs);
    };

    grid.pastingCell.addHandler(defaultEditHandler);
    grid.beginningEdit.addHandler(cellEditHandler);
  };

  const setHandleUppercase = (grid: FlexGrid<T>) => {
    // TOOD: uppercase handling - 강민재
    grid.cellEditEnded.addHandler((sender: FlexGrid, cellRangeEventArgs: CellRangeEventArgs) => {
      const row = cellRangeEventArgs.row;
      const col = cellRangeEventArgs.col;
      const cellValue = sender.getCellData(row, col, false) as WijmoPrimitive;
      const uppercase = GridUtils.getColumn(grid, col)?._uppercase;
      if (cellValue && typeof cellValue === 'string' && uppercase) {
        sender.setCellData(row, col, cellValue.toUpperCase(), true);
      }
    });
  };

  const setMoveCellByTab = (grid: FlexGrid<T>) => {
    grid.hostElement.addEventListener('keydown', (keyboardEvent: KeyboardEvent) => {
      if (keyboardEvent.code !== 'Tab' || keyboardEvent.key !== 'Tab') return;
      if (keyboardEvent.altKey || keyboardEvent.ctrlKey || keyboardEvent.metaKey) return;

      keyboardEvent.preventDefault();

      const selection = grid.selection;
      if (!selection || selection.row < 0 || selection.col < 0) return;

      let nextRow = selection.row;
      let nextCol = selection.col + 1;

      while (
        nextRow < grid.rows.length &&
        nextCol < grid.rows.length &&
        !grid.columns[nextCol]?.isVisible
      ) {
        if (nextCol + 1 >= grid.columns.length) {
          nextRow += 1;
          nextCol = 0;
        } else nextCol += 1;
      }

      while (nextCol < grid.columns.length && !grid.columns[nextCol]?.isVisible) nextCol += 1;

      if (nextCol >= grid.columns.length) {
        nextRow = selection.row + 1;
        nextCol = 0;
      }

      if (nextRow < grid.rows.length) grid.select(nextRow, nextCol);
    });
  };

  // TODO: border column handle 필요
  const setMoveByMetakey = (grid: FlexGrid<T>, border: number = 0) => {
    grid.hostElement.addEventListener('keydown', (keyboardEvent: KeyboardEvent) => {
      if (!keyboardEvent.ctrlKey) return;
      if (!keyboardEvent.key.startsWith('Arrow')) return;

      const findLastVisibleColumnIndex = (columns: Column[]) => {
        for (let columnIndex = columns.length - 1; columnIndex >= 0; columnIndex--) {
          if (columns[columnIndex]?.isVisible) {
            return columnIndex;
          }
        }
        return columns.length - 1;
      };

      const selection: CellRange = grid.selection;
      const row = selection.row;
      const col = selection.col;
      const row2 = selection.row2;
      const col2 = selection.col2;
      let newRow: number = selection.row;
      let newCol: number = selection.col;

      switch (keyboardEvent.key) {
        case 'ArrowUp':
          newRow = 0;
          break;
        case 'ArrowDown':
          newRow = grid.rows.length - 1;
          break;
        case 'ArrowLeft':
          newCol = border > 0 && newCol >= border ? border : 0;
          break;
        case 'ArrowRight':
          newCol =
            border > 0 && newCol < border ? border - 1 : findLastVisibleColumnIndex(grid.columns);
          break;
        default:
          return;
      }

      keyboardEvent.preventDefault();

      if (keyboardEvent.shiftKey)
        grid.select(
          new CellRange(newRow >= row ? row2 : row, newCol >= col ? col2 : col, newRow, newCol),
          true
        );
      else grid.select(new CellRange(newRow, newCol));

      grid.scrollIntoView(newRow, newCol, true);
    });
  };

  const setSortableColumnHeaderClick = (grid: FlexGrid<T>) => {
    grid.hostElement.addEventListener('click', (mouseEvent: MouseEvent) => {
      const target = mouseEvent.target as HTMLElement;
      const ht = grid.hitTest(mouseEvent);
      const column = grid.columns[ht.col];
      if (ht.cellType !== CellType.ColumnHeader || !column?.allowSorting) return;

      const clickedNativeSortIcon = !!target?.closest('.wj-glyph-up, .wj-glyph-down');
      const clickedCustomIcon = !!target?.closest('.wj-sort-unsorted-icon');

      if (!clickedNativeSortIcon && !clickedCustomIcon) return;

      mouseEvent.preventDefault();
      mouseEvent.stopPropagation();

      const binding = column.binding;
      const sortDescription = grid.collectionView.sortDescriptions.find(
        sd => sd.property === binding
      );

      grid.collectionView.sortDescriptions.clear();

      if (!mouseEvent.ctrlKey) {
        grid.collectionView.sortDescriptions.push(
          new SortDescription(binding ?? '', sortDescription ? !sortDescription.ascending : true)
        );
      }

      grid.select(-1, -1);
      grid.scrollIntoView(0, 0, true);
    });
  };

  const setResultColumn = (grid: FlexGrid<T>) => {
    const lastWeekSunday = dayjs().startOf('isoWeek').subtract(1, 'day');
    const year = lastWeekSunday.get('year');
    const month = String(lastWeekSunday.get('month') + 1).padStart(2, '0');

    const monthBinding = `M_${year}${month}`;
    const weekBinding = `W_${year}${month}${String(lastWeekSunday.isoWeek()).padStart(2, '0')}`;
    const dayBinding = `D_${lastWeekSunday.format('YYYYMMDD')}`;

    const _borderForLastResultColumn = (
      sender: FlexGrid<T>,
      formatItemEventArgs: FormatItemEventArgs
    ) => {
      const col = formatItemEventArgs.col;
      const cellType = formatItemEventArgs.panel.cellType;
      const binding = sender.columns[col]?.binding;
      const isVisible = sender.columns[col]?.visible;
      const rootColumnGroups = (sender.columnGroups as FlexGridColumnConfig[]).flatMap(
        e => e.columns
      );

      if (!rootColumnGroups) return;

      if (binding && cellType === CellType.Cell && isVisible) {
        if (binding === dayBinding && sender.columns[col]?.visible)
          addClass(formatItemEventArgs.cell, 'last-result-column');
        else if (binding === weekBinding) {
          const weekColumnGroups = rootColumnGroups.find(cg => cg?.binding === monthBinding);
          const weekCollapsed = weekColumnGroups?.columns?.find(
            cg => cg?.binding === weekBinding
          )?.isCollapsed;
          if (weekCollapsed) addClass(formatItemEventArgs.cell, 'last-result-column');
        } else if (binding === monthBinding) {
          const monthCollapsed = rootColumnGroups.find(
            cg => cg?.binding === monthBinding
          )?.isCollapsed;
          if (monthCollapsed) addClass(formatItemEventArgs.cell, 'last-result-column');
        }
      }
    };

    grid.formatItem.addHandler(_borderForLastResultColumn);
  };

  // TODO: cell input에 따른 cell combo 실시간 필터링 - 강민재
  // const setCellDropdownFilter = (grid: FlexGrid<T>) => {
  //   grid.prepareCellForEdit.addHandler(
  //     (sender: FlexGrid<T>, cellRangeEventArgs: CellRangeEventArgs) => {
  //       const row = cellRangeEventArgs.row;
  //       const col = cellRangeEventArgs.col;
  //       const column = GridUtils.getColumn(sender, col);
  //       if (
  //         column?._ctrlType !== CELL_CONTROL_TYPE.COMBO ||
  //         !column.dataMap ||
  //         !sender.activeEditor
  //       )
  //         return;
  //       const cellCombo = Control.getControl(
  //         sender.activeEditor.closest('.wj-control')
  //       ) as ComboBox;
  //       if (!(cellCombo instanceof ComboBox)) return;
  //       const cellComboCollectionView = cellCombo.itemsSource as CollectionView;
  //       if (!(cellComboCollectionView instanceof CollectionView)) return;
  //       cellCombo.textChanged.removeAllHandlers();
  //       cellCombo.textChanged.addHandler(() => {
  //         const textInput = cellCombo.text?.toLowerCase();
  //         const displayPath = (column.dataMap as DataMap).displayMemberPath;
  //         cellComboCollectionView.filter = item => {
  //           if (!textInput) return true;
  //           return (item[displayPath]?.toString().toLowerCase() || '').includes(textInput);
  //         };
  //       });
  //     }
  //   );
  // };

  return {
    setSummaryTooltip,
    setAggregationRow,
    setCheckbox,
    formatPopupIcon,
    formatEditableColumns,
    formatSortableColumns,
    setEditableColumns,
    setMoveCellByTab,
    setMoveByMetakey,
    setSortableColumnHeaderClick,
    setResultColumn,
    setHandleUppercase,
  };
};
