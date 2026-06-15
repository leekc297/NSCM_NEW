import { type FlexGrid } from '@mescius/wijmo.grid';
import { type MutableRefObject, useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import type { ResultRow } from '../dynamic-query.types';

interface Props {
  gridRef: MutableRefObject<FlexGrid<ResultRow> | null>;
  data: ResultRow[];
}

export const DynamicQueryResultGrid = ({ gridRef, data }: Props) => {
  // Dynamic columns from first data row (user SQL execution result — column shape varies)
  const staticColumns = useMemo<RawFlexGridColumnConfig[]>(() => {
    if (!data || data.length === 0) return [];
    const first = data[0] as Record<string, unknown>;
    return Object.keys(first).map((key): RawFlexGridColumnConfig => ({
      colNm: key,
      colLblNm: key,
      colWth: 120,
      fixed: false,
      visible: true,
      display: true,
    }));
  }, [data]);

  return (
    <DataGrid<ResultRow>
      gridRef={gridRef as MutableRefObject<FlexGrid<ResultRow> | undefined>}
      itemsSource={data}
      staticColumns={staticColumns}
    />
  );
};
