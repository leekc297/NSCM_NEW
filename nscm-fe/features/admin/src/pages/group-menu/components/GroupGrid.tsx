import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject } from 'react';

import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, RESPONSE_SET } from '../group-menu.constants';
import { SHEET_INDEX, SHEETS } from '../group-menu.constants';
import { useGroupMenuStore } from '../useGroupMenuStore';

interface GroupGridProps {
  gridRef: MutableRefObject<
    FlexGrid<ResponseData<MENU_ID, SHEETS.GROUP, RESPONSE_SET.OUTPUT>> | undefined
  >;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  setActiveTab: (tab: SHEET_INDEX) => void;
  data: ResponseData<MENU_ID, SHEETS.GROUP, RESPONSE_SET.OUTPUT>[];
}

export const GroupGrid = ({ gridRef, gridFilterRef, setActiveTab, data }: GroupGridProps) => {
  const staticColumns = useGroupMenuStore(state => state.staticColumns);
  const setFilters = useGroupMenuStore(state => state.setFilters);

  const handleFocus = () => {
    setActiveTab(SHEET_INDEX.GROUP);
  };

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;

    if (GridUtils.isEditableCell(grid, ht.row, ht.col)) return;

    setFilters(SHEETS.MENU, {
      groupId: String(dataItem.USER_GR_ID),
    });
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.GROUP, RESPONSE_SET.OUTPUT>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns.group ?? []}
      gotFocus={handleFocus}
      dblClick={handleDblClick}
    />
  );
};
