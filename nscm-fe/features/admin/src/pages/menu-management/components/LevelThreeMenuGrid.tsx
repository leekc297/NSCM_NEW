import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import {
  type SHEETS,
  type RESPONSE_SET,
  type MENU_ID,
  SHEET_INDEX,
} from '../menu-management.constants';
import { useMenuManagementStore } from '../useMenuManagementStore';

interface LevelTwoMenuGridProps {
  gridRef: MutableRefObject<
    FlexGrid<ResponseData<MENU_ID, SHEETS.LEVEL_THREE_MENU, RESPONSE_SET.OUTPUT>> | undefined
  >;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<
    EditTracker<ResponseData<MENU_ID, SHEETS.LEVEL_THREE_MENU, RESPONSE_SET.OUTPUT>> | undefined
  >;
  setActiveTab: (tab: SHEET_INDEX) => void;
  data: ResponseData<MENU_ID, SHEETS.LEVEL_THREE_MENU, RESPONSE_SET.OUTPUT>[];
}

export const LevelThreeMenuGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  setActiveTab,
  data,
}: LevelTwoMenuGridProps) => {
  const { setToast } = useMessageStore();
  const { t } = useTranslation();

  const staticColumns = useMenuManagementStore(state => state.staticColumns);
  const setClickedRow = useMenuManagementStore(state => state.setClickedRow);
  const setOpenMessageModal = useMenuManagementStore(state => state.setOpenMessageModal);

  const handleFocus = () => {
    setActiveTab(SHEET_INDEX.LEVEL_THREE_MENU);
  };

  const handleDblClick = (e: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    const binding = GridUtils.getBinding(grid, ht.col);

    if (!dataItem || !binding) return;

    if (dataItem.CRUD_TYPE === CRUD_TYPE.DELETE) {
      setToast({ type: 'warning', message: t('MSG00005', '_변경사항을 먼저 저장하세요.') });
    } else if (binding === 'MNU_MSG_NM') {
      setClickedRow(ht.row);
      setOpenMessageModal(true);
    }
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.LEVEL_THREE_MENU, RESPONSE_SET.OUTPUT>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns.levelThreeMenu ?? []}
      gotFocus={handleFocus}
      dblClick={handleDblClick}
    />
  );
};
