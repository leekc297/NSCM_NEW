import { type FlexGrid } from '@mescius/wijmo.grid';
import { type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import { SHEETS } from '../dynamic-query.constants';
import type { HistoryRow } from '../dynamic-query.types';
import { useDynamicQueryStore } from '../useDynamicQueryStore';

interface Props {
  gridRef: MutableRefObject<FlexGrid<HistoryRow> | null>;
  data: HistoryRow[];
}

export const DynamicQueryHistoryGrid = ({ gridRef, data }: Props) => {
  const staticColumns = useDynamicQueryStore(s => s.staticColumns[SHEETS.HISTORY]);
  return (
    <DataGrid<HistoryRow>
      gridRef={gridRef as MutableRefObject<FlexGrid<HistoryRow> | undefined>}
      itemsSource={data}
      staticColumns={staticColumns}
    />
  );
};
