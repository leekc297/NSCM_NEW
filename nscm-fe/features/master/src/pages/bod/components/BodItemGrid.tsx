import { CellRange, CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useMemo, useRef, useState, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { ItemByDivisionModal } from '../../../components';
import type { MENU_ID, SHEETS } from '../bod.constants';
import { RESPONSE_SET, SHEET_INDEX } from '../bod.constants';
import { useBodStore } from '../useBodStore';

interface BodItemGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.BOD_ITEM>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.BOD_ITEM, RESPONSE_SET.BOD_ITEM>[];
  setActiveTab: (tab: SHEET_INDEX) => void;
}

/**
 * DMF0015 BOD Item — Sub Grid (Detail)
 * AS-IS spdSub — 10 column
 * 룰 v2: _tobe/07_datagrid.md + _tobe/10_popup_modal.md
 *
 * 동작:
 * - dblClick (ITEM_ID + CRUD_TYPE.INSERT) → ItemByDivisionModal (AS-IS SCM0002_ItembySitePopup)
 * - cellEditEnded → EditTracker 자동 추적
 *
 * G12 격차: AS-IS SCM0002_ItembySitePopup ↔ ItemByDivisionModal 사용
 *   (ItemBySiteModal 미존재 — 차후 신규 또는 ItemByDivisionModal 의 siteId prop 확장)
 */
export const BodItemGrid = ({ gridRef, gridFilterRef, data, setActiveTab }: BodItemGridProps) => {
  const editTrackerRef =
    useRef<EditTracker<ResponseData<MENU_ID, SHEETS.BOD_ITEM>> | undefined>();

  const staticColumns = useBodStore(state => state.staticColumns);

  const [openItemModal, setOpenItemModal] = useState(false);
  const [clickedRow, setClickedRow] = useState(-1);
  const clickedDataItem = GridUtils.getRow(gridRef.current, clickedRow);

  const handleFocus = () => {
    setActiveTab(SHEET_INDEX.BOD_ITEM);
  };

  // 룰 v2 _tobe/06_search_area.md §3.6 — useMemo (refetch loop 방지)
  //
  // ⭐ G12 격차 해소 (보완 3): AS-IS SCM0002_ItembySitePopup → TO-BE ItemByDivisionModal 재사용
  //   - ItemByDivisionModal 의 preSearchParams.salesSite prop 이 이미 site 필터링 지원
  //   - 별도 ItemBySiteModal 신규 작성 불필요
  //   - 향후 부모 Main row 의 TO_SITE 를 정밀 전달하려면 setBodItemFilter 인자에
  //     scmSiteId 추가 + Bod.tsx 의 BodGrid dblClick 안에서 함께 setting
  const preSearchParams = useMemo(
    () => ({
      divisionId: clickedDataItem?.DIVISION_ID,
      deptId: 'ALL',
      endCustomer: 'ALL',
      salesSite: 'ALL', // 후속: 부모 Main row 의 TO_SITE 로 갱신
      projectCode: '',
    }),
    [clickedDataItem]
  );

  const handleItemSelected = (itemCode: string, itemName?: string) => {
    if (!clickedDataItem || !itemCode) return;

    editTrackerRef.current?.storeChange(
      clickedDataItem,
      'ITEM_ID',
      clickedDataItem.ITEM_ID,
      itemCode
    );
    clickedDataItem.ITEM_ID = itemCode;

    gridRef.current?.refreshRange(new CellRange(clickedRow, 0, clickedRow, -1));
  };

  const handleGridDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    const binding = GridUtils.getBinding(grid, ht.col);
    if (!dataItem || !binding) return;

    // AS-IS spdSub_CellDoubleClick: ItemId 더블클릭 + INSERT 시 popup
    // 룰 v2 _tobe/07_datagrid.md §3.5 CRUD_TYPE 가드
    if (
      dataItem.CRUD_TYPE === CRUD_TYPE.INSERT &&
      binding === 'ITEM_ID' &&
      GridUtils.isEditableCell(grid, ht.row, ht.col)
    ) {
      setClickedRow(ht.row);
      setOpenItemModal(true);
    }
  };

  return (
    <>
      <DataGrid<ResponseData<MENU_ID, SHEETS.BOD_ITEM>>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={data}
        staticColumns={staticColumns[RESPONSE_SET.BOD_ITEM]}
        gotFocus={handleFocus}
        dblClick={handleGridDblClick}
      />
      <ItemByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        setSelectedValue={(items, itemName) => handleItemSelected(items, itemName)}
        preSearchParams={preSearchParams}
        callFromCell={false}
      />
    </>
  );
};
