import { type FlexGrid } from '@mescius/wijmo.grid';
import { type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import { SHEETS } from '../dynamic-query.constants';
import type { ColumnMetaRow } from '../dynamic-query.types';
import { useDynamicQueryStore } from '../useDynamicQueryStore';

interface Props {
  gridRef: MutableRefObject<FlexGrid<ColumnMetaRow> | null>;
  data: ColumnMetaRow[];
}

export const DynamicQueryColumnsGrid = ({ gridRef, data }: Props) => {
  const staticColumns = useDynamicQueryStore(s => s.staticColumns[SHEETS.COLUMNS]);
  return (
    <DataGrid<ColumnMetaRow>
      gridRef={gridRef as MutableRefObject<FlexGrid<ColumnMetaRow> | undefined>}
      itemsSource={data}
      staticColumns={staticColumns}
    />
  );
};
