import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import type { MENU_ID, SHEETS } from '../ui-category-setup.constants';
import { RESPONSE_SET } from '../ui-category-setup.constants';
import { useUICategorySetupStore } from '../useUICategorySetupStore';

interface UICategoryColumnGridProps {
  gridRef: MutableRefObject<
    FlexGrid<ResponseData<MENU_ID, SHEETS, RESPONSE_SET.COLUMN>> | undefined
  >;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS, RESPONSE_SET.COLUMN>[];
}

export const UICategoryColumnGrid = ({
  gridRef,
  gridFilterRef,
  data,
}: UICategoryColumnGridProps) => {
  const staticColumns = useUICategorySetupStore(state => state.staticColumns);

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS, RESPONSE_SET.COLUMN>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns[RESPONSE_SET.COLUMN] ?? []}
    />
  );
};
