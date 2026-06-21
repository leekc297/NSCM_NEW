import { CellType, type CellRangeEventArgs, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, SHEET_NAME } from '../customer-fcst-master.constants';
import { useCustomerFcstMasterStore } from '../useCustomerFcstMasterStore';

interface CustomerFcstMasterFcstGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEET_NAME>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<ResponseData<MENU_ID, SHEET_NAME>> | undefined>;
  data: ResponseData<MENU_ID, SHEET_NAME>[];
}

export const CustomerFcstMasterFcstGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
}: CustomerFcstMasterFcstGridProps) => {
  const staticColumns = useCustomerFcstMasterStore(state => state.staticColumns);
  const dateColumns = useCustomerFcstMasterStore(state => state.dateColumns);

  const handleActiveChange = (
    sender: FlexGrid<ResponseData<MENU_ID, SHEET_NAME>>,
    cellRangeEventArgs: CellRangeEventArgs
  ) => {
    if (cellRangeEventArgs.panel.cellType !== CellType.Cell) return;

    const row = cellRangeEventArgs.row;
    const col = cellRangeEventArgs.col;
    const binding = GridUtils.getBinding(sender, col);
    const dataItem = GridUtils.getRow(sender, row);

    if (binding !== 'VALID_YN' || !dataItem) return;
    if (dataItem[binding] !== 'N') return;

    Object.keys(dataItem).forEach(key => {
      if (!key.startsWith('D_')) return;

      if (dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT && dataItem.CRUD_TYPE !== CRUD_TYPE.DELETE)
        editTrackerRef.current?.storeChange(dataItem, key, dataItem[key], 'N');

      dataItem[key] = 'N';
    });
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEET_NAME>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns ?? []}
      dynamicColumns={dateColumns ?? []}
      cellEditEnded={handleActiveChange}
    />
  );
};
