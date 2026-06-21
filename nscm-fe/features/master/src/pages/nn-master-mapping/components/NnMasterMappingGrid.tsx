import {
  AllowMerging,
  CellRange,
  CellType,
  type CellRangeEventArgs,
  type FlexGrid,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { CustomerModal, ItemByDivisionModal, ProjectByDivisionModal } from '../../../components';
import type { MENU_ID, SHEETS } from '../nn-master-mapping.constants';
import type { SearchCondition } from '../nn-master-mapping.types';
import { useNnMasterMappingStore } from '../useNnMasterMappingStore';
import { HierarchicalMergeManager } from '../utils/nn-master-mapping.merge';

interface NnMasterMappingGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.MAIN>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.MAIN>[];
  searchCondition: SearchCondition;
}

// AS-IS .cs L538-602 InsertRow / L515 SmartColMerge / L789~875 Validation 매핑:
//   - column-dependent 머지: HierarchicalMergeManager (utils/nn-master-mapping.merge.ts)
//   - cell edit: EditTracker 표준 (CRUD_TYPE='M' 자동 마킹)
//   - dblClick → Modal 분기: column meta 의 _modalKey 기반
export const NnMasterMappingGrid = ({
  gridRef,
  gridFilterRef,
  data,
  searchCondition,
}: NnMasterMappingGridProps) => {
  const editTrackerRef =
    useRef<EditTracker<ResponseData<MENU_ID, SHEETS.MAIN>> | undefined>(undefined);
  // admin SHEET_COLUMNS 메타 (BE PR_GET_SHEET_COLUMN_LIST 응답) — 룰 #65 ui-category-setup-column-meta 표준.
  //   080_DMF0072_dynamic_property_management.sql 사내 적용 완료 (2026-06-20) → BE 가 23 row 반환.
  //   admin UI Category Setup 의 VISIBLE_FLAG 변경이 즉시 반영됨 (FE hardcoded fallback 제거 완료).
  const staticColumns = useNnMasterMappingStore(s => s.staticColumns.main);

  const [clickedRow, setClickedRow] = useState<number>(-1);
  const [clickedBinding, setClickedBinding] = useState<string | null>(null);
  const [openCustomerModal, setOpenCustomerModal] = useState(false);
  const [openProjectModal, setOpenProjectModal] = useState(false);
  const [openItemModal, setOpenItemModal] = useState(false);

  // AS-IS 의 column-dependent 머지 — DataGrid wrapper 의 mergeManager prop 으로 전달 (useEffect 표준).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    g.mergeManager = new HierarchicalMergeManager();
    g.invalidate();
  }, [staticColumns]); // eslint-disable-line react-hooks/exhaustive-deps

  // cellEditEnded — EditTracker 표준 (DataGrid 가 자동 invalidate)
  const handleCellEditEnded = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.MAIN>>,
    e: CellRangeEventArgs
  ) => {
    const binding = grid.columns[e.col]?.binding;
    if (!binding || binding === 'CRUD_TYPE') return;
    const dataItem = GridUtils.getRow(grid, e.row);
    if (!dataItem) return;
    const newValue = grid.getCellData(e.row, e.col, false) as WijmoPrimitive;
    editTrackerRef.current?.storeChange(dataItem, binding, dataItem[binding], newValue);
  };

  // dblClick → Modal 분기 (column binding 기반)
  // AS-IS .cs InsertRow cellTypeImage 매핑:
  //   - SOLDTO_CODE / SHIPTO_CODE: CustomerModal (신규 행만)
  //   - PROJECT_CODE: ProjectByDivisionModal (신규 행만)
  //   - ITEM_ID: ItemByDivisionModal (Model/Nickname Popup, 신규 행만)
  //   - MAPPING_ITEM_ID: ItemByDivisionModal (Mapping Item Popup, 신규+수정 모두)
  const handleGridDblClick = (mouseEvent: MouseEvent) => {
    const g = gridRef.current;
    if (!g) return;
    const ht = g.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(g, ht.row);
    const binding = GridUtils.getBinding(g, ht.col);
    if (!dataItem || !binding) return;

    const isInsert = dataItem.CRUD_TYPE === CRUD_TYPE.INSERT;
    const isMappingItem = binding === 'MAPPING_ITEM_ID';

    // INSERT row 외에는 MAPPING_ITEM_ID 만 popup 허용
    if (!isInsert && !isMappingItem) return;

    setClickedRow(ht.row);
    setClickedBinding(binding as string);

    if (binding === 'SOLDTO_CODE' || binding === 'SHIPTO_CODE') {
      setOpenCustomerModal(true);
    } else if (binding === 'PROJECT_CODE') {
      setOpenProjectModal(true);
    } else if (binding === 'ITEM_ID' || binding === 'MAPPING_ITEM_ID') {
      setOpenItemModal(true);
    }
  };

  // Modal 콜백 — EditTracker.storeChange + dataItem 할당 + refreshRange (룰 #66)
  const setRowCell = (binding: string, value: string) => {
    const g = gridRef.current;
    if (!g || clickedRow < 0) return;
    const dataItem = GridUtils.getRow(g, clickedRow);
    if (!dataItem) return;
    editTrackerRef.current?.storeChange(dataItem, binding, dataItem[binding], value);
    dataItem[binding] = value;
    g.refreshRange(new CellRange(clickedRow, 0, clickedRow, -1));
  };

  // CustomerModal 은 SOLDTO + SHIPTO 동시 반환 — clicked binding 기준 분기
  const handleCustomerSelect = (soldTo: string, _soldDesc: string, shipTo: string) => {
    if (clickedBinding === 'SOLDTO_CODE') {
      setRowCell('SOLDTO_CODE', soldTo);
      if (shipTo) setRowCell('SHIPTO_CODE', shipTo);
    } else if (clickedBinding === 'SHIPTO_CODE') {
      setRowCell('SHIPTO_CODE', shipTo || soldTo);
    }
    setOpenCustomerModal(false);
  };

  const handleProjectSelect = (projects: string) => {
    setRowCell('PROJECT_CODE', projects);
    setOpenProjectModal(false);
  };

  const handleItemSelect = (items: string) => {
    if (clickedBinding) setRowCell(clickedBinding, items);
    setOpenItemModal(false);
  };

  return (
    <>
      <DataGrid<ResponseData<MENU_ID, SHEETS.MAIN>>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={data}
        staticColumns={staticColumns}
        allowMerging={AllowMerging.Cells}
        cellEditEnded={handleCellEditEnded}
        dblClick={handleGridDblClick}
      />
      <CustomerModal
        open={openCustomerModal}
        modalClose={() => setOpenCustomerModal(false)}
        setSelectedValue={handleCustomerSelect}
        divisionId={searchCondition.divisionId}
      />
      <ProjectByDivisionModal
        open={openProjectModal}
        modalClose={() => setOpenProjectModal(false)}
        setSelectedValue={handleProjectSelect}
        preSearchParams={{
          divisionId: searchCondition.divisionId,
          deptId: searchCondition.deptId,
          endCustomer: searchCondition.endCustomer,
          salesSite: searchCondition.scmSiteId,
          projectCode: '',
          etc: 'N',
        }}
        callFromCell={true}
      />
      <ItemByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        setSelectedValue={handleItemSelect}
        preSearchParams={{
          divisionId: searchCondition.divisionId,
          deptId: searchCondition.deptId,
          endCustomer: searchCondition.endCustomer,
          salesSite: searchCondition.scmSiteId,
          projectCode: '',
          itemId: '',
        }}
        callFromCell={true}
        headerTitle={
          clickedBinding === 'MAPPING_ITEM_ID' ? 'Mapping Item Popup' : 'Model/Nickname Popup'
        }
      />
    </>
  );
};
