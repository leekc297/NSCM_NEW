import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useTabid } from '@shared/stores';

import { MENU_ID, SHEETS } from '../auth-request.constants';
import { useAuthRequestStore } from '../useAuthRequestStore';

interface DivisionGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.DIVISION>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
}

export const DivisionGrid = ({ gridRef, gridFilterRef }: DivisionGridProps) => {
  const tabId = useTabid();
  const filters = useAuthRequestStore(state => state.filters[SHEETS.DIVISION]);
  const staticColumns = useAuthRequestStore(state => state.staticColumns[SHEETS.DIVISION]);

  const { data } = useTabProcQuery<MENU_ID, SHEETS.DIVISION>({
    menuId: MENU_ID,
    sheetName: SHEETS.DIVISION,
    tabId,
    filters,
    enabled: !!filters,
  });

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.DIVISION>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data?.o_rc ?? []}
      staticColumns={staticColumns}
      useCheckbox
      isReadOnly
    />
  );
};
