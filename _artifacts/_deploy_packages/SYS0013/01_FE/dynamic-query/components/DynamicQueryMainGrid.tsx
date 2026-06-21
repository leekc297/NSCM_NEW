import { SelectionMode, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import { SHEETS } from '../dynamic-query.constants';
import type { QueryRow } from '../dynamic-query.types';
import { useDynamicQueryStore } from '../useDynamicQueryStore';

interface Props {
  gridRef: MutableRefObject<FlexGrid<QueryRow> | null>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: QueryRow[];
}

export const DynamicQueryMainGrid = ({ gridRef, gridFilterRef, data }: Props) => {
  const setSelectedQueryId = useDynamicQueryStore(s => s.setSelectedQueryId);
  const staticColumns = useDynamicQueryStore(s => s.staticColumns[SHEETS.MAIN]);

  const handleSelectionChanged = (g: FlexGrid<QueryRow>) => {
    const row = g.selectedItems[0] as QueryRow | undefined;
    if (row) setSelectedQueryId(String(row.QUERY_ID));
  };

  return (
    <DataGrid<QueryRow>
      gridRef={gridRef as MutableRefObject<FlexGrid<QueryRow> | undefined>}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
      selectionMode={SelectionMode.Row}
      selectionChanged={handleSelectionChanged}
    />
  );
};
