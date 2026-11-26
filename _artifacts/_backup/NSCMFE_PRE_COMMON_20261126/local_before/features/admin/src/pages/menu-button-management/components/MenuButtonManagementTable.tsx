import type { CellRangeEventArgs, FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject } from 'react';

import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, SHEETS } from '../menu-button-management.constants';
import { useMenuButtonManagementStore } from '../useMenuButtonManagementStore';

interface MenuButtonManagementTableProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.LIST>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.LIST>[];
}

export const MenuButtonManagementTable = ({
  gridRef,
  gridFilterRef,
  data,
}: MenuButtonManagementTableProps) => {
  const staticColumns = useMenuButtonManagementStore(state => state.staticColumns);

  const handleMenuChange = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.LIST>>,
    cellRangeEventArgs: CellRangeEventArgs
  ) => {
    const row = cellRangeEventArgs.row;
    const col = cellRangeEventArgs.col;

    const dataItem = GridUtils.getRow(grid, row);
    const binding = GridUtils.getBinding(grid, col);

    if (!dataItem || binding !== 'MNU_NM') return;

    const menuId = dataItem.MNU_NM;
    dataItem.MNU_ID = menuId;

    GridUtils.refreshRow(grid, row);
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.LIST>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
      cellEditEnded={handleMenuChange}
      pastedCell={handleMenuChange}
    />
  );
};
