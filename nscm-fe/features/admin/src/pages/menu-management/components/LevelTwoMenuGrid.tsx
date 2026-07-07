import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import type { MENU_ID, RESPONSE_SET } from '../menu-management.constants';
import { SHEET_INDEX, SHEETS } from '../menu-management.constants';
import { useMenuManagementStore } from '../useMenuManagementStore';

interface LevelTwoMenuGridProps {
  gridRef: MutableRefObject<
    FlexGrid<ResponseData<MENU_ID, SHEETS.LEVEL_TWO_MENU, RESPONSE_SET.OUTPUT>> | undefined
  >;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<
    EditTracker<ResponseData<MENU_ID, SHEETS.LEVEL_TWO_MENU, RESPONSE_SET.OUTPUT>> | undefined
  >;
  setActiveTab: (tab: SHEET_INDEX) => void;
  data: ResponseData<MENU_ID, SHEETS.LEVEL_TWO_MENU, RESPONSE_SET.OUTPUT>[];
}

export const LevelTwoMenuGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  setActiveTab,
  data,
}: LevelTwoMenuGridProps) => {
  const staticColumns = useMenuManagementStore(state => state.staticColumns);
  const setFilters = useMenuManagementStore(state => state.setFilters);
  const setClickedLevelTwoMenu = useMenuManagementStore(state => state.setClickedLevelTwoMenu);
  const setClickedRow = useMenuManagementStore(state => state.setClickedRow);
  const setOpenMessageModal = useMenuManagementStore(state => state.setOpenMessageModal);

  const { setToast } = useMessageStore();
  const { t } = useTranslation();

  const handleFocus = () => {
    setActiveTab(SHEET_INDEX.LEVEL_TWO_MENU);
  };

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    const binding = GridUtils.getBinding(grid, ht.col);

    if (!dataItem || !binding) return;

    if (dataItem.CRUD_TYPE === CRUD_TYPE.DELETE) {
      setToast({ type: 'warning', message: t('MSG00005', '_변경사항을 먼저 저장하세요.') });
      return;
    } else if (binding === 'MNU_MSG_NM') {
      setClickedRow(ht.row);
      setOpenMessageModal(true);
      return;
    } else if (
      dataItem.CRUD_TYPE === CRUD_TYPE.INSERT ||
      GridUtils.isEditableCell(grid, ht.row, ht.col)
    )
      return;

    setFilters(SHEETS.LEVEL_THREE_MENU, {
      menuId: String(dataItem?.MNU_ID),
    });
    setClickedLevelTwoMenu(String(dataItem?.MNU_ID));
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.LEVEL_TWO_MENU, RESPONSE_SET.OUTPUT>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns.levelTwoMenu ?? []}
      gotFocus={handleFocus}
      dblClick={handleDblClick}
    />
  );
};
