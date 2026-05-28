import { CellRange, CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, useState, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { CustomerModal } from '../../../components';
import type { MENU_ID } from '../sales-site.constants';
import { SHEETS, RESPONSE_SET, SHEET_INDEX } from '../sales-site.constants';
import { useSalesSiteStore } from '../useSalesSiteStore';

interface SalesSiteCustomerGridProps {
  gridRef: MutableRefObject<
    FlexGrid<ResponseData<MENU_ID, SHEETS.CUSTOMER, RESPONSE_SET.CUSTOMER>> | undefined
  >;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.CUSTOMER, RESPONSE_SET.CUSTOMER>[];
  setActiveTab: (tab: SHEET_INDEX) => void;
}

export const SalesSiteCustomerGrid = ({
  gridRef,
  gridFilterRef,
  data,
  setActiveTab,
}: SalesSiteCustomerGridProps) => {
  const editTrackerRef = useRef<
    EditTracker<ResponseData<MENU_ID, SHEETS.CUSTOMER, RESPONSE_SET.CUSTOMER>> | undefined
  >();

  const filters = useSalesSiteStore(state => state.filters);
  const staticColumns = useSalesSiteStore(state => state.staticColumns);

  const [clickedRow, setClickedRow] = useState(-1);
  const [openCustomerModal, setOpenCustomerModal] = useState(false);

  const setCustomers = (
    soldTo: string,
    soldToDesc: string,
    shipTo: string,
    shipToDesc: string,
    shipToRegion?: string,
    shipToCity?: string
  ) => {
    const dataItem = GridUtils.getRow(gridRef.current, clickedRow);
    if (!dataItem || dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT) return;

    editTrackerRef.current?.storeChange(dataItem, 'SOLDTO_CODE', dataItem.SOLDTO_CODE, soldTo);
    editTrackerRef.current?.storeChange(
      dataItem,
      'SOLDTO_DESCRIPTION',
      dataItem.SOLDTO_DESCRIPTION,
      soldToDesc
    );
    editTrackerRef.current?.storeChange(dataItem, 'SHIPTO_CODE', dataItem.SHIPTO_CODE, shipTo);
    editTrackerRef.current?.storeChange(
      dataItem,
      'SHIPTO_DESCRIPTION',
      dataItem.SHIPTO_DESCRIPTION,
      shipToDesc
    );
    editTrackerRef.current?.storeChange(
      dataItem,
      'SHIPTO_REGION_NAME',
      dataItem.SHIPTO_REGION_NAME,
      shipToRegion ?? ''
    );
    editTrackerRef.current?.storeChange(
      dataItem,
      'SHIPTO_CITY_NAME',
      dataItem.SHIPTO_CITY_NAME,
      shipToCity ?? ''
    );

    dataItem.SOLDTO_CODE = soldTo;
    dataItem.SOLDTO_DESCRIPTION = soldToDesc;
    dataItem.SHIPTO_CODE = shipTo;
    dataItem.SHIPTO_DESCRIPTION = shipToDesc;
    dataItem.SHIPTO_REGION_NAME = shipToRegion ?? '';
    dataItem.SHIPTO_CITY_NAME = shipToCity ?? '';

    gridRef.current?.refreshRange(new CellRange(clickedRow, 0, clickedRow, -1));
  };

  const handleFocus = () => {
    setActiveTab(SHEET_INDEX.CUSTOMER);
  };

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    const binding = GridUtils.getBinding(grid, ht.col);

    if (!dataItem || !binding) return;

    if (
      dataItem.CRUD_TYPE === CRUD_TYPE.INSERT &&
      (binding === 'SOLDTO_CODE' || binding === 'SHIPTO_CODE')
    ) {
      setClickedRow(ht.row);
      setOpenCustomerModal(true);
    }
  };

  return (
    <>
      <DataGrid<ResponseData<MENU_ID, SHEETS.CUSTOMER, RESPONSE_SET.CUSTOMER>>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={data}
        staticColumns={staticColumns[RESPONSE_SET.CUSTOMER] ?? []}
        gotFocus={handleFocus}
        dblClick={handleDblClick}
      />
      <CustomerModal
        open={openCustomerModal}
        modalClose={() => setOpenCustomerModal(false)}
        setSelectedValue={setCustomers}
        divisionId={filters[SHEETS.SITE]?.divisionId ?? ''}
        soldTo={GridUtils.getRow(gridRef.current, clickedRow)?.SOLDTO_DESCRIPTION}
        shipTo={GridUtils.getRow(gridRef.current, clickedRow)?.SHIPTO_DESCRIPTION}
      />
    </>
  );
};
