import { type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import type { MENU_ID, SHEETS } from '../group-management.constants';
import { useGroupManagementStore } from '../useGroupManagementStore';

interface GroupManagementGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.GROUP_MGMT>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.GROUP_MGMT>[];
}

export const GroupManagementGrid = ({ gridRef, gridFilterRef, data }: GroupManagementGridProps) => {
  const staticColumns = useGroupManagementStore(state => state.staticColumns);

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.GROUP_MGMT>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
    />
  );
};
