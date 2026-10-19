import { AllowMerging, CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject } from 'react';

import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import type { MENU_ID, RESPONSE_SET } from '../group-menu.constants';
import { SHEET_INDEX, SHEETS } from '../group-menu.constants';
import { useGroupMenuStore } from '../useGroupMenuStore';

interface MenuGridProps {
  gridRef: MutableRefObject<
    FlexGrid<ResponseData<MENU_ID, SHEETS.MENU, RESPONSE_SET.OUTPUT>> | undefined
  >;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  setActiveTab: (tab: SHEET_INDEX) => void;
  data: ResponseData<MENU_ID, SHEETS.MENU, RESPONSE_SET.OUTPUT>[];
}

export const MenuGrid = ({ gridRef, gridFilterRef, setActiveTab, data }: MenuGridProps) => {
  const staticColumns = useGroupMenuStore(state => state.staticColumns);
  const setFilters = useGroupMenuStore(state => state.setFilters);

  const { setToast } = useMessageStore();
  const { t } = useTranslation();

  const handleFocus = () => {
    setActiveTab(SHEET_INDEX.MENU);
  };

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    const binding = GridUtils.getBinding(grid, ht.col);

    if (!dataItem || !dataItem?.MNU_ID || !binding || !['MNU_ID', 'MNU_MSG_NM'].includes(binding))
      return;

    if (dataItem.CRUD_TYPE) {
      setToast({ type: 'warning', message: t('MSG00005', '_변경사항을 먼저 저장하세요.') });
      return;
    }

    if (dataItem.MNU_AUTH_YN !== 'Y') {
      setToast({ type: 'warning', message: t('MSG00008', '_메뉴 권한을 먼저 부여하세요.') });
      return;
    }

    if (GridUtils.isEditableCell(grid, ht.row, ht.col)) return;

    setFilters(SHEETS.BUTTON, {
      groupId: String(dataItem?.USER_GR_ID),
      menuId: String(dataItem?.MNU_ID),
    });
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.MENU, RESPONSE_SET.OUTPUT>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      allowMerging={AllowMerging.Cells}
      itemsSource={data}
      staticColumns={staticColumns.menu ?? []}
      gotFocus={handleFocus}
      dblClick={handleDblClick}
    />
  );
};
