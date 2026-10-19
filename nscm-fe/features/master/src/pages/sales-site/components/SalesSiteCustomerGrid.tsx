import { CellType, type CellRangeEventArgs, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, useState, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import { CustomerModal } from '../../../components';
import type { MENU_ID } from '../sales-site.constants';
import { SHEETS, RESPONSE_SET, SHEET_INDEX } from '../sales-site.constants';
import { useSalesSiteStore } from '../useSalesSiteStore';
import {
  hasRepresentative,
  isRepresentative,
  REP_YN_DUPLICATE_MSG,
  REP_YN_DUPLICATE_MSG_ID,
} from '../utils/sales-site.util';

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

  const { t } = useTranslation();

  const filters = useSalesSiteStore(state => state.filters);
  const staticColumns = useSalesSiteStore(state => state.staticColumns);
  const setAlert = useMessageStore(state => state.setAlert);

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

    GridUtils.refreshRow(gridRef.current, clickedRow);
  };

  const handleFocus = () => {
    setActiveTab(SHEET_INDEX.CUSTOMER);
  };

  // Rep 을 Y 로 바꿨는데 같은 Sales Site 에 이미 Y 가 있으면 → 알럿 후 N 으로 되돌린다.
  //   비교 대상 행은 grid 에서 직접 읽는다 — wijmo 가 핸들러를 렌더 시점 클로저로 물고 있어
  //   prop(data)을 쓰면 조회 전 빈 배열을 계속 보게 된다.
  const handleRepYnChange = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.CUSTOMER, RESPONSE_SET.CUSTOMER>>,
    cellRangeEventArgs: CellRangeEventArgs
  ) => {
    const row = cellRangeEventArgs.row;
    const binding = GridUtils.getBinding(grid, cellRangeEventArgs.col);
    const dataItem = GridUtils.getRow(grid, row);

    if (binding !== 'REP_YN' || !dataItem || !isRepresentative(dataItem.REP_YN)) return;

    const rows = grid.collectionView?.sourceCollection ?? [];
    if (!hasRepresentative(rows, dataItem.SCM_SITE_ID, dataItem)) return;

    void setAlert({
      type: 'alert',
      content: t(REP_YN_DUPLICATE_MSG_ID, REP_YN_DUPLICATE_MSG),
    });

    // 되돌릴 값은 원래 셀 값 타입에 맞춘다(콤보 'N' / 체크박스 false).
    const revertValue = typeof dataItem.REP_YN === 'boolean' ? false : 'N';
    editTrackerRef.current?.storeChange(dataItem, 'REP_YN', dataItem.REP_YN, revertValue);
    dataItem.REP_YN = revertValue as typeof dataItem.REP_YN;
    GridUtils.refreshRow(grid, row);
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
        cellEditEnded={handleRepYnChange}
        dblClick={handleDblClick}
      />
      <CustomerModal
        open={openCustomerModal}
        modalClose={() => setOpenCustomerModal(false)}
        setSelectedValue={setCustomers}
        divisionId={filters[SHEETS.SITE]?.divisionId ?? ''}
        soldTo={GridUtils.getRow(gridRef.current, clickedRow)?.SOLDTO_CODE}
        shipTo={GridUtils.getRow(gridRef.current, clickedRow)?.SHIPTO_CODE}
      />
    </>
  );
};
