import {
  AllowMerging,
  CellType,
  type FlexGrid,
  type CellRangeEventArgs,
  CellRange,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useMemo, useRef, useState, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { ComboResponse } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils, parseComboFilterBindings } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { RegionModal } from '../../../components';
import type { MENU_ID, SHEETS } from '../sales-site.constants';
import { RESPONSE_SET, SHEET_INDEX } from '../sales-site.constants';
import { useSalesSiteStore } from '../useSalesSiteStore';
import { applySalesSite, resolveComboCodeByDivision } from '../utils/sales-site.util';

interface SalesSiteGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.SITE>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.SITE, RESPONSE_SET.SITE>[];
  setActiveTab: (tab: SHEET_INDEX) => void;
}

export const SalesSiteGrid = ({
  gridRef,
  gridFilterRef,
  data,
  setActiveTab,
}: SalesSiteGridProps) => {
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.SITE>> | undefined>();

  const staticColumns = useSalesSiteStore(state => state.staticColumns);
  const setDetailFilters = useSalesSiteStore(state => state.setDetailFilters);

  const [clickedRow, setClickedRow] = useState<number>(-1);
  const [openRegionModal, setOpenRegionModal] = useState<boolean>(false);

  const salesSiteColumns = useMemo(
    () =>
      staticColumns[RESPONSE_SET.SITE].map(column =>
        column.colNm !== 'END_CUSTOMER' || parseComboFilterBindings(column.attribute2).DIVISION_ID
          ? column
          : {
              ...column,
              attribute2: [column.attribute2, 'DIVISION_ID:DIVISION_ID'].filter(Boolean).join(','),
            }
      ),
    [staticColumns]
  );

  // 채번에 쓰는 값은 NAME 이 아니라 CODE 다. 붙여넣기로 셀에 NAME 이 들어온 경우만
  //   저장 경로(SalesSite.tsx handleSave)와 같은 규칙으로 division 기준 CODE 를 되찾는다.
  const getSoldToCustomerCode = (dataItem: ResponseData<MENU_ID, SHEETS.SITE>) =>
    resolveComboCodeByDivision(
      (gridRef.current?.columns.getColumn('SOLDTO_CUSTOMER')?.dataMap?.collectionView?.items ??
        []) as ComboResponse[],
      String(dataItem.DIVISION_ID ?? ''),
      String(dataItem.SOLDTO_CUSTOMER ?? '')
    );

  const setRegion = (
    countryCode: string,
    countryName: string,
    cityCode: string,
    cityName: string
  ) => {
    const dataItem = GridUtils.getRow(gridRef.current, clickedRow);
    if (!dataItem || dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT) return;

    editTrackerRef.current?.storeChange(
      dataItem,
      'COUNTRY_NAME',
      dataItem.COUNTRY_NAME,
      countryName
    );
    editTrackerRef.current?.storeChange(dataItem, 'CITY_NAME', dataItem.CITY_NAME, cityName);

    dataItem.COUNTRY = countryCode;
    dataItem.COUNTRY_NAME = countryName;
    dataItem.CITY = cityCode;
    dataItem.CITY_NAME = cityName;
    applySalesSite(dataItem, editTrackerRef.current, getSoldToCustomerCode(dataItem));
    gridRef.current?.refreshRange(new CellRange(clickedRow, 0, clickedRow, -1));
  };

  const handleFocus = () => {
    setActiveTab(SHEET_INDEX.SITE);
  };

  const handleAutoSalesSite = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.SITE>>,
    cellRangeEventArgs: CellRangeEventArgs
  ) => {
    const row = cellRangeEventArgs.row;
    const col = cellRangeEventArgs.col;
    const binding = grid.columns[col]?.binding;
    const dataItem = GridUtils.getRow(grid, row);

    if (!binding || !dataItem || dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT) return;
    if (!['SOLDTO_CUSTOMER', 'COUNTRY', 'CITY'].includes(binding)) return;

    applySalesSite(dataItem, editTrackerRef.current, getSoldToCustomerCode(dataItem));
    grid.refreshRange(new CellRange(row, 0, row, -1));
  };

  const handleGridDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    const binding = GridUtils.getBinding(grid, ht.col);
    if (!dataItem || !binding) return;

    if (
      dataItem.CRUD_TYPE === CRUD_TYPE.INSERT &&
      (binding === 'COUNTRY_NAME' || binding === 'CITY_NAME')
    ) {
      setClickedRow(ht.row);
      setOpenRegionModal(true);
      return;
    }

    if (GridUtils.isEditableCell(grid, ht.row, ht.col)) return;

    setDetailFilters({
      divisionId: dataItem?.DIVISION_ID,
      salesSite: dataItem?.SCM_SITE_ID,
      activeFlag: dataItem?.VALID_YN,
    });
  };

  return (
    <>
      <DataGrid<ResponseData<MENU_ID, SHEETS.SITE>>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={data}
        staticColumns={salesSiteColumns}
        allowMerging={AllowMerging.Cells}
        alternatingRowStep={0}
        gotFocus={handleFocus}
        cellEditEnded={handleAutoSalesSite}
        dblClick={handleGridDblClick}
      />
      <RegionModal
        open={openRegionModal}
        modalClose={() => setOpenRegionModal(false)}
        setSelectedValue={setRegion}
        country={GridUtils.getRow(gridRef.current, clickedRow)?.COUNTRY_NAME}
        city={GridUtils.getRow(gridRef.current, clickedRow)?.CITY_NAME}
      />
    </>
  );
};
