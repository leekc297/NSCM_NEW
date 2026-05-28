import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import type { MENU_ID, RESPONSE_SET } from '../auth-request.constants';
import { APPROVAL_RESULT, SHEETS } from '../auth-request.constants';
import { useAuthRequestStore } from '../useAuthRequestStore';

interface MyAuthorityListGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.MY_AUTHORITY_LIST>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.MY_AUTHORITY_LIST, RESPONSE_SET.OUTPUT>[];
}

export const MyAuthorityListGrid = ({ gridRef, gridFilterRef, data }: MyAuthorityListGridProps) => {
  const staticColumns = useAuthRequestStore(state => state.staticColumns[SHEETS.MY_AUTHORITY_LIST]);

  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    for (let i = 0; i < grid.rows.length; i += 1) {
      const row = grid.rows[i];
      const item = row?.dataItem as
        | ResponseData<MENU_ID, SHEETS.MY_AUTHORITY_LIST, RESPONSE_SET.OUTPUT>
        | undefined;
      if (!row || !item) continue;

      const result = (item.APPROVAL_RESULT ?? '').trim();
      const isReject = result === (APPROVAL_RESULT.REJECT as string);
      const isFinalApproved =
        result.length > 0 && result !== (APPROVAL_RESULT.REQUESTING as string) && !isReject;

      if (isReject) {
        row.isSelected = false;
      } else if (isFinalApproved) {
        row.isSelected = true;
      }
    }
  }, [data, gridRef]);

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
