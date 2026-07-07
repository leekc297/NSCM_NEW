import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, SHEETS } from '../group-user.constants';

// division/plant/customer 동일 shape (GET_AUTH_LIST: UNIT_ID/UPPR_UNIT_ID/EDIT_YN/USE_YN)
type UnitRow = ResponseData<MENU_ID, SHEETS.DIVISION>;

interface Props {
  gridRef: MutableRefObject<FlexGrid<UnitRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: UnitRow[];
  staticColumns: RawFlexGridColumnConfig[];
  onFocus?: () => void;
}

export const GroupUserUnitGrid = ({
  gridRef,
  gridFilterRef,
  data,
  staticColumns,
  onFocus,
}: Props) => {
  const editTrackerRef = useRef<EditTracker<UnitRow>>();

  return (
    <DataGrid<UnitRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
      gotFocus={() => onFocus?.()}
    />
  );
};
