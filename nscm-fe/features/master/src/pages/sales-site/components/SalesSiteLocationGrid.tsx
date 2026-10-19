import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, useState, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { StorageLocationModal } from '../../../components';
import type { MENU_ID } from '../sales-site.constants';
import { SHEETS, RESPONSE_SET, SHEET_INDEX } from '../sales-site.constants';
import { useSalesSiteStore } from '../useSalesSiteStore';

interface SalesSiteLocationGridProps {
  gridRef: MutableRefObject<
    FlexGrid<ResponseData<MENU_ID, SHEETS.LOCATION, RESPONSE_SET.LOCATION>> | undefined
  >;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.LOCATION, RESPONSE_SET.LOCATION>[];
  setActiveTab: (tab: SHEET_INDEX) => void;
}

export const SalesSiteLocationGrid = ({
  gridRef,
  gridFilterRef,
  data,
  setActiveTab,
}: SalesSiteLocationGridProps) => {
  const editTrackerRef = useRef<
    EditTracker<ResponseData<MENU_ID, SHEETS.LOCATION, RESPONSE_SET.LOCATION>> | undefined
  >();

  const filters = useSalesSiteStore(state => state.filters);
  const staticColumns = useSalesSiteStore(state => state.staticColumns);

  const [openSlocModal, setOpenSlocModal] = useState<boolean>(false);
  const [clickedRow, setClickedRow] = useState(-1);
  const clickedItem = GridUtils.getRow(gridRef.current, clickedRow);

  const setSloc = (plantId: string, storageId: string, storageDesc: string) => {
    if (!clickedItem || clickedItem.CRUD_TYPE !== CRUD_TYPE.INSERT) return;

    editTrackerRef.current?.storeChange(clickedItem, 'PLANT_ID', clickedItem.PLANT_ID, plantId);
    editTrackerRef.current?.storeChange(
      clickedItem,
      'LOCATION_CODE',
      clickedItem.LOCATION_CODE,
      storageId
    );
    editTrackerRef.current?.storeChange(
      clickedItem,
      'LOCATION_DESCRIPTION',
      clickedItem.LOCATION_DESCRIPTION,
      storageDesc
    );

    clickedItem.PLANT_ID = plantId;
    clickedItem.LOCATION_CODE = storageId;
    clickedItem.LOCATION_DESCRIPTION = storageDesc;
    GridUtils.refreshRow(gridRef.current, clickedRow);
  };

  const handleFocus = () => {
    setActiveTab(SHEET_INDEX.LOCATION);
  };

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    const binding = GridUtils.getBinding(grid, ht.col);

    if (!dataItem || !binding) return;

    if (dataItem.CRUD_TYPE === CRUD_TYPE.INSERT && binding === 'LOCATION_CODE') {
      setClickedRow(ht.row);
      setOpenSlocModal(true);
    }
  };

  return (
    <>
      <DataGrid<ResponseData<MENU_ID, SHEETS.LOCATION, RESPONSE_SET.LOCATION>>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={data}
        staticColumns={staticColumns[RESPONSE_SET.LOCATION] ?? []}
        gotFocus={handleFocus}
        dblClick={handleDblClick}
      />
      <StorageLocationModal
        open={openSlocModal}
        modalClose={() => setOpenSlocModal(false)}
        setSelectedValue={setSloc}
        divisionId={filters[SHEETS.SITE]?.divisionId}
        storageId={clickedItem?.LOCATION_CODE}
      />
    </>
  );
};
