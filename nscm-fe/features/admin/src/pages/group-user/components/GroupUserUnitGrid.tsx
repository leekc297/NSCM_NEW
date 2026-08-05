import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, type MutableRefObject } from 'react';

import { type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID } from '../group-user.constants';
import { SHEETS } from '../group-user.constants';
import { useGroupUserStore } from '../useGroupUserStore';

// division/plant/customer 동일 shape (GET_AUTH_LIST: UNIT_ID/UPPR_UNIT_ID/EDIT_YN/USE_YN)
type UnitRow = ResponseData<MENU_ID, SHEETS.DIVISION>;

interface Props {
  gridRef: MutableRefObject<FlexGrid<UnitRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: UnitRow[];
}

export const GroupUserUnitGrid = ({ gridRef, gridFilterRef, data }: Props) => {
  const editTrackerRef = useRef<EditTracker<UnitRow>>();
  const staticColumns = useGroupUserStore(state => state.staticColumns[SHEETS.DIVISION]);
  const setFocusSeet = useGroupUserStore(state => state.setFocusSeet);

  return (
    <DataGrid<UnitRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
      gotFocus={() => setFocusSeet(SHEETS.DIVISION)}
    />
  );
};
