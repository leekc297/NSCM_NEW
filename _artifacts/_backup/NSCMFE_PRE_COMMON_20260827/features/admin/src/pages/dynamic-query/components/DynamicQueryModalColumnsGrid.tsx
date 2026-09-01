import { type FlexGrid } from '@mescius/wijmo.grid';
import { type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import { SHEETS } from '../dynamic-query.constants';
import type { Columns } from '../dynamic-query.types';
import { useDynamicQueryStore } from '../useDynamicQueryStore';

interface Props {
  gridRef: MutableRefObject<FlexGrid<Columns> | null>;
  data: Columns[];
}

export const DynamicQueryModalColumnsGrid = ({ gridRef, data }: Props) => {
  const staticColumns = useDynamicQueryStore(s => s.staticColumns[SHEETS.POPUP_COLUMNS]);

  return (
    <DataGrid<Columns>
      gridRef={gridRef as MutableRefObject<FlexGrid<Columns> | undefined>}
      itemsSource={data}
      staticColumns={staticColumns}
    />
  );
};
