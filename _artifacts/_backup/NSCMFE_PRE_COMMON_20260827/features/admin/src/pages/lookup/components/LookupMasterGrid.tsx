import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, type MutableRefObject } from 'react';

import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, RESPONSE_SET, SHEETS } from '../lookup.constants';
import { useLookupStore } from '../useLookupStore';

interface LookupMasterGridProps {
  gridRef: MutableRefObject<
    FlexGrid<ResponseData<MENU_ID, SHEETS.LOOKUP_MASTER, RESPONSE_SET.SAVE>> | undefined
  >;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.LOOKUP_MASTER, RESPONSE_SET.SAVE>[];
}

export const LookupMasterGrid = ({ gridRef, gridFilterRef, data }: LookupMasterGridProps) => {
  const editTrackerRef =
    useRef<EditTracker<ResponseData<MENU_ID, SHEETS.LOOKUP_MASTER, RESPONSE_SET.SAVE>>>();

  const staticColumns = useLookupStore(state => state.staticColumns.lookupMaster);
  const setActiveGrid = useLookupStore(state => state.setActiveGrid);
  const setSubFilters = useLookupStore(state => state.setSubFilters);
  const applyDynamicSubColumns = useLookupStore(state => state.applyDynamicSubColumns);
  const mainGridReadOnly = useLookupStore(state => state.mainGridReadOnly);

  const handleGotFocus = () => {
    setActiveGrid('main');
  };

  const handleDblClick = (e: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    if (!mainGridReadOnly) return;

    const ht = grid.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;

    const lookupType = String(dataItem.LOOKUP_TYPE ?? '');
    if (!lookupType) return;

    applyDynamicSubColumns(dataItem);
    setSubFilters(lookupType);
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.LOOKUP_MASTER, RESPONSE_SET.SAVE>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
      gotFocus={handleGotFocus}
      dblClick={handleDblClick}
    />
  );
};
