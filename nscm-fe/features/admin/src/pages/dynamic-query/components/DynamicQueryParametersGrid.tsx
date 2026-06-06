import { type FlexGrid } from '@mescius/wijmo.grid';
import { type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import { SHEETS } from '../dynamic-query.constants';
import type { ParameterMetaRow } from '../dynamic-query.types';
import { useDynamicQueryStore } from '../useDynamicQueryStore';

interface Props {
  gridRef: MutableRefObject<FlexGrid<ParameterMetaRow> | null>;
  data: ParameterMetaRow[];
}

export const DynamicQueryParametersGrid = ({ gridRef, data }: Props) => {
  const staticColumns = useDynamicQueryStore(s => s.staticColumns[SHEETS.PARAMETERS]);
  return (
    <DataGrid<ParameterMetaRow>
      gridRef={gridRef as MutableRefObject<FlexGrid<ParameterMetaRow> | undefined>}
      itemsSource={data}
      staticColumns={staticColumns}
    />
  );
};
