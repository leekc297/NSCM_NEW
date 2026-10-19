import { type FlexGrid } from '@mescius/wijmo.grid';
import { type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import { SHEETS } from '../dynamic-query.constants';
import type { Parameters } from '../dynamic-query.types';
import { useDynamicQueryStore } from '../useDynamicQueryStore';

interface Props {
  gridRef: MutableRefObject<FlexGrid<Parameters> | null>;
  data: Parameters[];
}

export const DynamicQueryModalParametersGrid = ({ gridRef, data }: Props) => {
  const staticColumns = useDynamicQueryStore(s => s.staticColumns[SHEETS.POPUP_PARAMETERS]);
  return (
    <DataGrid<Parameters>
      gridRef={gridRef as MutableRefObject<FlexGrid<Parameters> | undefined>}
      itemsSource={data}
      staticColumns={staticColumns}
    />
  );
};
