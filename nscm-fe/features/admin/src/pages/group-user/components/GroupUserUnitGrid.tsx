import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

interface Props {
  gridRef: MutableRefObject<FlexGrid | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: { UNIT_ID: string; UPPR_UNIT_ID: string; EDIT_YN: string; USE_YN: string }[];
  staticColumns: RawFlexGridColumnConfig[];
}

export const GroupUserUnitGrid = ({ gridRef, gridFilterRef, data, staticColumns }: Props) => {
  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
      useCheckbox
    />
  );
};
