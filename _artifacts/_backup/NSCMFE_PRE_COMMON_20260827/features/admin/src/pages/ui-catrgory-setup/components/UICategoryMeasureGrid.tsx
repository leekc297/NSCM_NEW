import { type FlexGrid as TFlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import type { MENU_ID, SHEETS} from '../ui-category-setup.constants';
import { RESPONSE_SET } from '../ui-category-setup.constants';
import { useUICategorySetupStore } from '../useUICategorySetupStore';

interface UICategoryMeasureGridProps {
  gridRef: MutableRefObject<
    TFlexGrid<ResponseData<MENU_ID, SHEETS.COLUMN, RESPONSE_SET.MEASURE>> | undefined
  >;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.COLUMN, RESPONSE_SET.MEASURE>[];
}

export const UICategoryMeasureGrid = ({
  gridRef,
  gridFilterRef,
  data,
}: UICategoryMeasureGridProps) => {
  const staticColumns = useUICategorySetupStore(state => state.staticColumns);

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.COLUMN, RESPONSE_SET.MEASURE>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns[RESPONSE_SET.MEASURE] ?? []}
    />
  );
};
