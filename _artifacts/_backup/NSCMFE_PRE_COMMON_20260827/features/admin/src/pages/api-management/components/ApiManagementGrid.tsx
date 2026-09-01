import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject } from 'react';

import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, SHEETS } from '../api-management.constants';
import { useApiManagementStore } from '../useApiManagementStore';

interface ApiManagementGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.LIST>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<ResponseData<MENU_ID, SHEETS.LIST>> | undefined>;
  data: ResponseData<MENU_ID, SHEETS.LIST>[];
}

export const ApiManagementGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
}: ApiManagementGridProps) => {
  const staticColumns = useApiManagementStore(state => state.staticColumns);
  const setClickedRow = useApiManagementStore(state => state.setClickedRow);
  const setOpenMessageModal = useApiManagementStore(state => state.setOpenMessageModal);

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);

    if (!dataItem) return;

    const binding = GridUtils.getBinding(grid, ht.col);
    if (binding === 'API_MSG_NM') {
      setClickedRow(ht.row);
      setOpenMessageModal(true);
    }
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.LIST>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
      dblClick={handleDblClick}
    />
  );
};
