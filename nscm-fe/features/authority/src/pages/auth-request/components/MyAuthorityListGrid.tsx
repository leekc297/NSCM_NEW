import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import type { MENU_ID, RESPONSE_SET } from '../auth-request.constants';
import { SHEETS } from '../auth-request.constants';
import { useAuthRequestStore } from '../useAuthRequestStore';

interface MyAuthorityListGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.MY_AUTHORITY_LIST>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.MY_AUTHORITY_LIST, RESPONSE_SET.OUTPUT>[];
  recentlyAddedKeys?: Set<string>;
}

export const MyAuthorityListGrid = ({
  gridRef,
  gridFilterRef,
  data,
  recentlyAddedKeys,
}: MyAuthorityListGridProps) => {
  const staticColumns = useAuthRequestStore(state => state.staticColumns[SHEETS.MY_AUTHORITY_LIST]);
  const recentKeysRef = useRef<Set<string> | undefined>(recentlyAddedKeys);
  recentKeysRef.current = recentlyAddedKeys;
  const handlerInstalledRef = useRef(false);

  const applyRowSelection = (grid: FlexGrid) => {
    const recent = recentKeysRef.current;
    const hasRecentAdd = !!recent && recent.size > 0;

    for (let i = 0; i < grid.rows.length; i += 1) {
      const row = grid.rows[i];
      const item = row?.dataItem as
        | ResponseData<MENU_ID, SHEETS.MY_AUTHORITY_LIST, RESPONSE_SET.OUTPUT>
        | undefined;
      if (!row || !item) continue;

      if (hasRecentAdd) {
        const key = `${item.USER_GR_ID}::${item.DIVISION_ID}`;
        row.isSelected = recent.has(key);
      } else {
        row.isSelected = false;
      }
    }
  };

  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    if (!handlerInstalledRef.current) {
      grid.loadedRows.addHandler((sender: FlexGrid) => {
        applyRowSelection(sender);
      });
      handlerInstalledRef.current = true;
    }

    applyRowSelection(grid);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [data, gridRef, recentlyAddedKeys]);

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.MY_AUTHORITY_LIST>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
      useCheckbox
      isReadOnly
    />
  );
};
