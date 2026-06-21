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

interface LevelOneMenuGridProps {
  gridRef: MutableRefObject<
    FlexGrid<ResponseData<MENU_ID, SHEETS.LEVEL_ONE_MENU, RESPONSE_SET.OUTPUT>> | undefined
  >;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<
    EditTracker<ResponseData<MENU_ID, SHEETS.LEVEL_ONE_MENU, RESPONSE_SET.OUTPUT>> | undefined
  >;
  setActiveTab: (tab: SHEET_INDEX) => void;
  data: ResponseData<MENU_ID, SHEETS.LEVEL_ONE_MENU, RESPONSE_SET.OUTPUT>[];
}

export const LevelOneMenuGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  setActiveTab,
  data,
}: LevelOneMenuGridProps) => {
  const staticColumns = useMenuManagementStore(state => state.staticColumns);
  const setFilters = useMenuManagementStore(state => state.setFilters);
  const setClickedLevelOneMenu = useMenuManagementStore(state => state.setClickedLevelOneMenu);
  const setClickedLevelTwoMenu = useMenuManagementStore(state => state.setClickedLevelTwoMenu);
  const setClickedRow = useMenuManagementStore(state => state.setClickedRow);
  const setOpenMessageModal = useMenuManagementStore(state => state.setOpenMessageModal);

  const { setToast } = useMessageStore();
  const { t } = useTranslation();

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

    // 2026-06-21 PROC_M signature fix: BE GeneralController.callProc 가 path variable 'mnuId' 로
    // SP IN 파라미터 'mnuId' 강제 덮어쓰기 → SP 가 'SYS0003' 받아 0 row. PROC_M COL_NM 을 'pUpprMnuId' 로
    // 변경하여 path 충돌 회피 (사내 메타 UPDATE 완료, SP body 변경 X).
    setFilters(SHEETS.LEVEL_TWO_MENU, {
      pUpprMnuId: String(dataItem.MNU_ID),
    });
    setClickedLevelOneMenu(String(dataItem.MNU_ID));
    setClickedLevelTwoMenu('');
  };

  const handleFocus = () => {
    setActiveTab(SHEET_INDEX.LEVEL_ONE_MENU);
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.LEVEL_ONE_MENU, RESPONSE_SET.OUTPUT>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns.levelOneMenu ?? []}
      dblClick={handleDblClick}
      gotFocus={handleFocus}
    />
  );
};
