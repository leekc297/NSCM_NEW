import { SelectionMode } from '@mescius/wijmo.grid';
import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useTabid } from '@shared/stores';

import { MENU_ID, SHEETS } from '../auth-request.constants';
import { useAuthRequestStore } from '../useAuthRequestStore';

interface AuthorityGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.AUTHORITY>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
}

export const AuthorityGrid = ({ gridRef, gridFilterRef }: AuthorityGridProps) => {
  const tabId = useTabid();
  const filters = useAuthRequestStore(state => state.filters[SHEETS.AUTHORITY]);
  const staticColumns = useAuthRequestStore(state => state.staticColumns[SHEETS.AUTHORITY]);

  const { data } = useTabProcQuery<MENU_ID, SHEETS.AUTHORITY>({
    menuId: MENU_ID,
    sheetName: SHEETS.AUTHORITY,
    tabId,
    filters,
    enabled: !!filters,
  });

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.AUTHORITY>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data?.o_rc ?? []}
      staticColumns={staticColumns}
      selectionMode={SelectionMode.Row}
      isReadOnly
    />
  );
};
