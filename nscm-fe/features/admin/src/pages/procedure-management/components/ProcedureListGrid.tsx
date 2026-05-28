import type { FlexGrid } from '@mescius/wijmo.grid';
import { CellType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, SHEETS } from '../procedure-management.constants';
import { SHEET_INDEX } from '../procedure-management.constants';
import { useProcedureManagementStore } from '../useProcedureManagementStore';

interface ProcedureManagementGridProps {
  gridRef: MutableRefObject<
    FlexGrid<ResponseData<MENU_ID, SHEETS.PROCEDURE_LIST, 'o_rc'>> | undefined
  >;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.PROCEDURE_LIST>[];
  setActiveGrid: (activeGrid: SHEET_INDEX) => void;
}

export const ProcedureListGrid = ({
  gridRef,
  gridFilterRef,
  data,
  setActiveGrid,
}: ProcedureManagementGridProps) => {
  const staticColumns = useProcedureManagementStore(state => state.staticColumns);
  const setInfoFilter = useProcedureManagementStore(state => state.setInfoFilter);

  const handleFocus = () => {
    setActiveGrid(SHEET_INDEX.PROCEDURE_LIST);
  };

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const row = ht.row;
    const dataItem = GridUtils.getRow(grid, row);

    if (!dataItem || GridUtils.isEditableCell(grid, ht.row, ht.col)) return;

    setInfoFilter({
      OWNER: dataItem.OWNER,
      PROC_NM: dataItem.PROC_NM,
      isYn: dataItem.CRUD_TYPE === CRUD_TYPE.INSERT ? 'N' : 'Y',
    });
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.PROCEDURE_LIST>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns.procList}
      gotFocus={handleFocus}
      dblClick={handleDblClick}
    />
  );
};
