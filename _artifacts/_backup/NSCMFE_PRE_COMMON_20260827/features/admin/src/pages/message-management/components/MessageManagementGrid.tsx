import { type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import type { MENU_ID, SHEETS } from '../message-management.constants';
import { useMessageManagementStore } from '../useMessageManagementStore';

interface MessageManagementGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.MSG_MGMT>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.MSG_MGMT>[];
}

export const MessageManagementGrid = ({
  gridRef,
  gridFilterRef,
  data,
}: MessageManagementGridProps) => {
  const staticColumns = useMessageManagementStore(state => state.staticColumns);

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.MSG_MGMT>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
    />
  );
};
