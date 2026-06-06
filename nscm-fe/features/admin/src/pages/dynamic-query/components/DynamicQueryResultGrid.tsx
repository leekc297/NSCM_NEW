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
    return Object.keys(first).map((key, idx) => ({
      COLUMN_NAME: key,
      COLUMN_LABEL_NAME: key,
      SORT_ORDER_NO: (idx + 1) * 10,
      COLUMN_WIDTH: 120,
      FIXED_FLAG: 'N',
      VISIBLE_FLAG: 'Y',
      HORIZONTAL_ALIGN_CODE: 'Left',
      CELL_CONTROL_OBJECT_TYPE_CODE: 'S',
      VALID_YN: 'Y',
      DISPLAY_FLAG: 'Y',
    })) as RawFlexGridColumnConfig[];
  }, [data]);

  return (
    <DataGrid<ResultRow>
      gridRef={gridRef as MutableRefObject<FlexGrid<ResultRow> | undefined>}
      itemsSource={data}
      staticColumns={staticColumns}
    />
  );
};
