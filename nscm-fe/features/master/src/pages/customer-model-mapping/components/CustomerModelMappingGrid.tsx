import { CellRange, CellType, type CellRangeEventArgs, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, useState, type MutableRefObject } from 'react';

import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { ItemByDivisionModal, ProjectByDivisionModal } from '../../../components';
import type { MENU_ID, SHEETS } from '../customer-model-mapping.constants';
import { useCustomerModelMappingStore } from '../useCustomerModelMappingStore';

interface CustomerModelMappingProps {
  gridRef: MutableRefObject<
    FlexGrid<ResponseData<MENU_ID, SHEETS.CUSTOMER_MODEL_MAPPING>> | undefined
  >;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.CUSTOMER_MODEL_MAPPING>[];
}

export const CustomerModelMappingGrid = ({
  gridRef,
  gridFilterRef,
  data,
}: CustomerModelMappingProps) => {
  const editTrackerRef = useRef<
    EditTracker<ResponseData<MENU_ID, SHEETS.CUSTOMER_MODEL_MAPPING>> | undefined
  >();

  const staticColumn = useCustomerModelMappingStore(state => state.staticColumn);

  const [openPrjByDivisionModal, setOpenPrjByDivisionModal] = useState<boolean>(false);
  const [openModelByDivisionModal, setOpenModelByDivisionModal] = useState<boolean>(false);

  const [clickedRow, setClickedRow] = useState(-1);
  const clickedDataItem = GridUtils.getRow(gridRef.current, clickedRow);

  const handleProjectSelected = (projects: string, projectsNames?: string) => {
    if (!clickedDataItem || !projects) return;

    const projectCode = projects?.split(',')[0] ?? '';
    const projectsName = projectsNames?.split(',')[0] ?? '';

    editTrackerRef.current?.storeChange(
      clickedDataItem,
      'PROJECT_CODE',
      clickedDataItem.PROJECT_CODE,
      projectCode
    );
    editTrackerRef.current?.storeChange(
      clickedDataItem,
      'PROJECT_NAME',
      clickedDataItem.PROJECT_NAME,
      projectsName
    );

    clickedDataItem.PROJECT_CODE = projectCode;
    clickedDataItem.PROJECT_NAME = projectsName;

    gridRef.current?.refreshRange(new CellRange(clickedRow, 0, clickedRow, -1));
  };

  const handleItemSelected = (itemCode: string, itemName?: string, itemType?: string) => {
    if (!clickedDataItem) return;

    editTrackerRef.current?.storeChange(
      clickedDataItem,
      'ITEM_ID',
      clickedDataItem.ITEM_ID,
      itemCode ?? ''
    );
    editTrackerRef.current?.storeChange(
      clickedDataItem,
      'ITEM_CLASS_NAME',
      clickedDataItem.ITEM_CLASS_NAME,
      itemType ?? ''
    );
    editTrackerRef.current?.storeChange(
      clickedDataItem,
      'ITEM_NAME',
      clickedDataItem.ITEM_NAME,
      itemName ?? ''
    );

    clickedDataItem.ITEM_ID = itemCode;
    clickedDataItem.ITEM_CLASS_NAME = itemType ?? '';
    clickedDataItem.ITEM_NAME = itemName ?? '';

    gridRef.current?.refreshRange(new CellRange(clickedRow, 0, clickedRow, -1));
  };

  const handleGridDblclick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    const editable = GridUtils.isEditableCell(grid, ht.row, ht.col);
    if (!editable) return;
    const binding = GridUtils.getBinding(grid, ht.col);
    const dataItem = GridUtils.getRow(grid, ht.row);

    if (!dataItem) return;

    if (binding === 'PROJECT_CODE') {
      setClickedRow(ht.row);
      setOpenPrjByDivisionModal(true);
    } else if (binding === 'ITEM_ID' || binding === 'ITEM_CLASS_NAME') {
      setClickedRow(ht.row);
      setOpenModelByDivisionModal(true);
    }
  };

  // ⭐ B3 격차 보강 (Phase 7 A1 후속, 2026-06-04) — DMF0006 격차 #1
  // AS-IS DMF0006_CustomerModelMapping.cs L1147~1156:
  //   CONVERT_QTY_CELL / CONVERT_QTY_MODULE / CONVERT_QTY_PACK 음수 입력 시 "0" 보정.
  // 룰 07 §2.10.2 (validation 변형).
  const handleNegativeGuard = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.CUSTOMER_MODEL_MAPPING>>,
    cellRangeEventArgs: CellRangeEventArgs
  ) => {
    if (cellRangeEventArgs.panel.cellType !== CellType.Cell) return;
    const binding = grid.columns[cellRangeEventArgs.col]?.binding;
    if (
      binding !== 'CONVERT_QTY_CELL' &&
      binding !== 'CONVERT_QTY_MODULE' &&
      binding !== 'CONVERT_QTY_PACK'
    )
      return;

    const dataItem = GridUtils.getRow(grid, cellRangeEventArgs.row);
    if (!dataItem) return;

    const raw = (dataItem as Record<string, unknown>)[binding];
    const value = Number(raw ?? 0);
    if (value >= 0) return;

    editTrackerRef.current?.storeChange(dataItem, binding, raw, 0);
    (dataItem as Record<string, unknown>)[binding] = 0;
    grid.refreshRange(new CellRange(cellRangeEventArgs.row, cellRangeEventArgs.col, cellRangeEventArgs.row, cellRangeEventArgs.col));
  };

  return (
    <>
      <DataGrid<ResponseData<MENU_ID, SHEETS.CUSTOMER_MODEL_MAPPING>>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={data}
        staticColumns={staticColumn ?? []}
        dblClick={handleGridDblclick}
        cellEditEnded={handleNegativeGuard}
      />
      <ProjectByDivisionModal
        open={openPrjByDivisionModal}
        modalClose={() => setOpenPrjByDivisionModal(false)}
        setSelectedValue={(projects, projectsNames) => {
          handleProjectSelected(projects, projectsNames);
        }}
        preSearchParams={{
          divisionId: clickedDataItem?.DIVISION_ID,
          deptId: clickedDataItem?.DEPT_ID || 'ALL',
          endCustomer: clickedDataItem?.END_CUSTOMER || 'ALL',
          salesSite: clickedDataItem?.SCM_SITE_ID || 'ALL',
          projectCode: clickedDataItem?.PROJECT_CODE,
        }}
        callFromCell={false}
      />
      <ItemByDivisionModal
        open={openModelByDivisionModal}
        modalClose={() => setOpenModelByDivisionModal(false)}
        setSelectedValue={(items, itemName, itemType) => {
          handleItemSelected(items, itemName, itemType);
        }}
        preSearchParams={{
          divisionId: clickedDataItem?.DIVISION_ID,
          deptId: clickedDataItem?.DEPT_ID || 'ALL',
          endCustomer: clickedDataItem?.END_CUSTOMER || 'ALL',
          salesSite: clickedDataItem?.SCM_SITE_ID || 'ALL',
          projectCode: clickedDataItem?.PROJECT_CODE || 'ALL',
          activeFlag: clickedDataItem?.VALID_YN || 'ALL',
          itemId: clickedDataItem?.ITEM_ID || '',
        }}
        callFromCell={false}
      />
    </>
  );
};
