import { CollectionView } from '@mescius/wijmo';
import { AllowMerging, CellType, Column, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { IFlexGridXlsxOptions, XlsxFormatItemEventArgs } from '@mescius/wijmo.grid.xlsx';
import { FlexGridXlsxConverter } from '@mescius/wijmo.grid.xlsx';
import { HAlign, VAlign, WorkbookFont, WorkbookStyle } from '@mescius/wijmo.xlsx';
import dayjs from 'dayjs';

import { apiClient } from '@foundation/apis';
import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE, CRUD_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig } from '@foundation/models';

import { GridUtils } from './gridUtils';
import { CustomMergeManager } from './mergeManager';

export const GridAction = {
  GridAction: {},

  clear: <T extends WijmoRowItem = WijmoRowItem>(
    funcSetGridData: (gridData: CollectionView<T>) => void,
    funcSetDataCount: (dataCount: number) => void,
    grid: FlexGrid<T>,
    gridFilter?: FlexGridFilter
  ) => {
    funcSetGridData(new CollectionView());
    funcSetDataCount(0);
    grid.select(-1, -1);
    grid.mergeManager = new CustomMergeManager(grid);
    gridFilter?.clear();
  },

  // F1: Open manual
  getManual: (manualUrl: string) => {
    // TODO: 화면 별 manual file (pdf or ppt) - 강민재
    console.error(manualUrl);
  },

  // F2: Toggle edit mode - deprecated
  toggleEditMode: <T extends WijmoRowItem = WijmoRowItem>(grid: FlexGrid<T>) => {
    grid.isReadOnly = !grid.isReadOnly;
    grid.invalidate();
  },

  // F3: Toggle sort property of columns
  toggleColumnSort: <T extends WijmoRowItem = WijmoRowItem>(grid: FlexGrid<T>) => {
    const selection = grid?.selection;
    const minCol = Math.min(selection.col, selection.col2);
    const maxCol = Math.max(selection.col, selection.col2);

    for (let selectedCol = minCol; selectedCol <= maxCol; selectedCol++) {
      const binding = grid.columns[selectedCol].binding;
      if (!grid.collectionView.sortDescriptions.some(sd => sd.property === binding))
        grid.columns[selectedCol].allowSorting = !grid.columns[selectedCol].allowSorting;
    }

    grid.invalidate();
  },

  // F4 : Toggle filter
  toggleColumnFilter: <T extends WijmoRowItem = WijmoRowItem>(
    grid: FlexGrid<T>,
    gridFilter: FlexGridFilter
  ) => {
    const selection = grid.selection;
    const minCol = Math.min(selection.col, selection.col2);
    const maxCol = Math.max(selection.col, selection.col2);

    for (let selectedCol = minCol; selectedCol <= maxCol; selectedCol++) {
      const binding = grid.columns[selectedCol].binding ?? '';
      const bindingIndex = gridFilter.filterColumns.indexOf(binding);

      if (bindingIndex === -1) gridFilter.filterColumns.push(binding);
      else gridFilter.filterColumns.splice(bindingIndex, 1);
    }

    grid.invalidate();
  },

  // F6: Save personalized condition
  personalizeCondition: async (menuId: string, searchParam: Record<keyof object, string>) => {
    await apiClient.post(
      `/admin/menu/${menuId}/search-conditions`,
      Object.entries(searchParam).map(([key, data]) => ({
        paramNm: key,
        paramCtn: data,
      }))
    );
  },

  // F8: Add row
  addRow: <T extends WijmoRowItem = WijmoRowItem>(
    grid: FlexGrid<T>,
    defaultCopyProps: Partial<T>,
    placement: 'below' | 'top' | 'bottom' | 'above' = 'above'
  ) => {
    if (grid.isReadOnly) return;
    const itemsSource = grid.itemsSource as T[];
    const editFlag = itemsSource.every(item => item?.EDIT_FLAG === 'N');
    // TODO: 조회 없이 (그리드에 데이터 없이) 추가할 때 handle 추가적으로 필요  - 강민재
    if (itemsSource.length !== 0 && editFlag) return;

    let insertRowIndex: number = 0;
    const newRow = {
      ...defaultCopyProps,
      CRUD_TYPE: 'I',
    } as unknown as T;

    switch (placement) {
      case 'below':
        insertRowIndex = grid.collectionView.items.length > 0 ? (grid?.selection.row ?? -1) : 0;
        break;
      case 'bottom':
        insertRowIndex = grid?.collectionView.items.length;
        break;
      case 'top':
      case 'above':
        // Insert the new row above of the current selected row
        insertRowIndex = -1;
        if (grid.collectionView.items.length) {
          insertRowIndex = (grid?.selection.row ?? 0) - 1;
        }
        break;
      default:
        break;
    }

    grid.collectionView.sourceCollection.splice(insertRowIndex + 1, 0, newRow);
    (grid.collectionView as CollectionView).itemsAdded.push(newRow);

    grid.mergeManager = new CustomMergeManager(grid);
    grid.collectionView.refresh();
    grid.invalidate();
  },

  // F9: Remove row
  removeRow: <T extends WijmoRowItem = WijmoRowItem>(
    grid: FlexGrid<T>,
    deleteOnlyNew: boolean = false
  ) => {
    if (grid.isReadOnly) return false;

    const rows = GridUtils.getSelectedRows(grid);
    if (!rows?.length) return false;

    rows.forEach(row => {
      if (row.CRUD_TYPE === CRUD_TYPE.CREATE || row.CRUD_TYPE === CRUD_TYPE.INSERT)
        grid.editableCollectionView.remove(row);
      else if (!deleteOnlyNew) row['CRUD_TYPE'] = CRUD_TYPE.DELETE;
    });

    grid.editableCollectionView.commitEdit();
    grid.mergeManager = new CustomMergeManager(grid);
    grid.invalidate();

    return true;
  },

  // F10: Reset personalized condition
  resetPersonalizedCondition: async (menuId: string) => {
    await apiClient.post(`/admin/menu/${menuId}/search-conditions/reset`);
  },

  // F11 : Excel download
  excelDownload: <T extends WijmoRowItem = WijmoRowItem>(
    grid: FlexGrid<T>,
    menuName: string,
    setProgress?: (progress: number) => void
  ) => {
    grid.beginUpdate();

    const fileName = `${menuName}_${dayjs().format('YYYYMMDD_hhmmss')}`;

    const clonedAllowMerging = grid.allowMerging;
    const clonedColumnGroups = [...(grid.columnGroups as FlexGridColumnConfig[])];
    const clonedColumnHeaderHeight = grid.columnHeaders.rows[0].height;
    const flatColumnGroups = clonedColumnGroups
      .flatMap(largeGroup => largeGroup.columns ?? [largeGroup])
      .flatMap(smallGroup => smallGroup.columns ?? [smallGroup]);

    /**
     * TODO: 현재 Wijmo 버전에서는 columnGroups 사용시,
     * includeStyles: false, includeColumnHeaders: true
     * 위 속성들과 호환이 되지 않음 (컬럼헤더의 로우 개수만큼 데이터의 상위 n개가 엑셀에 불러와지지 않음... formatItem에서 애초에 index를 찍을 때 스킵되는 버그)
     */
    grid.columns.clear();
    grid.columnGroups = [];
    // grid.columnHeaders.rows.clear();

    flatColumnGroups.forEach(columnGroup =>
      grid.columns.push(
        new Column({
          binding: columnGroup.binding,
          header: columnGroup.header,
          align: columnGroup.align,
          allowMerging: false,
          visible: columnGroup.visible,
          width: columnGroup.width,
        })
      )
    );

    grid.allowMerging = AllowMerging.None;
    grid.columnHeaders.rows[0].height = 48;

    const headerFontStyle = new WorkbookFont();
    headerFontStyle.family = 'Spoqa Han Sans Neo';
    headerFontStyle.size = 12;
    headerFontStyle.bold = true;

    const fontStyle = new WorkbookFont();
    fontStyle.family = 'Spoqa Han Sans Neo';
    fontStyle.size = 12;
    fontStyle.bold = false;

    const columnHeaderStyle = new WorkbookStyle();
    columnHeaderStyle.wordWrap = true;
    columnHeaderStyle.vAlign = VAlign.Center;
    columnHeaderStyle.hAlign = HAlign.Center;
    columnHeaderStyle.font = headerFontStyle;

    const cellStyle = new WorkbookStyle();
    cellStyle.vAlign = VAlign.Center;
    cellStyle.font = fontStyle;

    const getCellColor = (row: number, col: number): string | undefined => {
      const column = flatColumnGroups[col];
      const dataItem = GridUtils.getRow(grid, row);

      if (column && dataItem) {
        const isEditable =
          column._inputEditType !== CELL_INPUT_EDIT_TYPE.SEARCH_ONLY &&
          dataItem.EDIT_FLAG !== 'N' &&
          !(column._inputEditType?.startsWith('I') && dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT);

        if (isEditable) return '#fff8cd';
      }

      return row % 2 === 0 ? undefined : '#F7F7F8';
    };

    const convertOptions: IFlexGridXlsxOptions = {
      includeStyles: false,
      includeColumnHeaders: true,
      includeRowHeaders: false,
      formatItem: (xlsxFormatItemEventArgs: XlsxFormatItemEventArgs) => {
        const cellType = xlsxFormatItemEventArgs.panel.cellType;
        const xlsxCell = xlsxFormatItemEventArgs.xlsxCell;
        const row = xlsxFormatItemEventArgs.row;
        const col = xlsxFormatItemEventArgs.col;

        /**
         * TODO: 느려지는 원인 (window에서 실제로 보이는 style을 가져오는 작업)
         * const cellEelement = xlsxFormatItemEventArgs.panel.getCellElement(row, col);
         * const computedStyle = window.getComputedStyle(cellEelement);
         */

        if (cellType === CellType.ColumnHeader)
          xlsxCell.style = { ...xlsxCell.style, ...columnHeaderStyle };
        else if (cellType === CellType.Cell) {
          xlsxCell.style = {
            ...xlsxCell.style,
            ...cellStyle,
            fill: {
              color: getCellColor(row, col),
            },
          };

          const dataType = flatColumnGroups[col]._ctrlType;
          xlsxCell.isDate = dataType === CELL_CONTROL_TYPE.DATE; // TODO: CELL_CONTROL_TYPE DATE 타입 추가 시 조건 변경 필요 - 강민재
          xlsxCell.isNumber = dataType === CELL_CONTROL_TYPE.NUMBER;
        }
      },
    };

    const resetGridProps = () => {
      grid.allowMerging = clonedAllowMerging;
      grid.columns.clear();
      grid.columnGroups = clonedColumnGroups;
      grid.columnHeaders.rows[0].height = clonedColumnHeaderHeight;
      grid.endUpdate();
    };

    return new Promise<void>((resolve, reject) => {
      FlexGridXlsxConverter.saveAsync(
        grid,
        convertOptions,
        fileName,
        () => {
          resetGridProps();
          resolve();
        },
        reason => {
          resetGridProps();
          reject(reason instanceof Error ? reason : new Error(String(reason)));
        },
        setProgress,
        true,
        50
      );
    });
  },
};
