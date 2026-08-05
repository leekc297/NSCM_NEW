import { toggleClass } from '@mescius/wijmo';
import {
  CellRange,
  CellType,
  type CellRangeEventArgs,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useState, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  ItemByDivisionModal,
  OwnerByDivisionModal,
  ProjectByDivisionModal,
} from '../../../components';
import type { MENU_ID, SHEETS } from '../erp-edi-master.constants';
import { useErpEdiMasterStore } from '../useErpEdiMasterStore';

interface ErpEdiMasterSspmGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.SSPM>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.SSPM>[];
}

const YELLOW_HIGHLIGHT_COLUMNS = new Set(['SALES_PLANT', 'EDI', 'VALID_YN']);

export const ErpEdiMasterSspmGrid = ({
  gridRef,
  gridFilterRef,
  data,
}: ErpEdiMasterSspmGridProps) => {
  const staticColumns = useErpEdiMasterStore(state => state.staticColumns.sspm);

  const [openProjectModal, setOpenProjectModal] = useState(false);
  const [openItemModal, setOpenItemModal] = useState(false);
  const [openOwnerModal, setOpenOwnerModal] = useState(false);
  const [clickedRow, setClickedRow] = useState<number>(-1);

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    const binding = GridUtils.getBinding(grid, ht.col);
    if (!dataItem || !binding) return;
    if (dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT) return;

    setClickedRow(ht.row);

    if (binding === 'PROJECT_CODE') {
      setOpenProjectModal(true);
    } else if (binding === 'ITEM_ID') {
      setOpenItemModal(true);
    } else if (binding === 'USER_ID') {
      setOpenOwnerModal(true);
    }
  };

  const handleFormatItem = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.SSPM>>,
    args: FormatItemEventArgs
  ) => {
    if (args.panel.cellType !== CellType.Cell) return;
    const binding = GridUtils.getBinding(grid, args.col);
    if (typeof binding !== 'string') return;
    // 편집 가능 컬럼 = 표준 Yellow(`wj-cell-editable`). 그 외 = White+zebra (클래스 없음). hook #95.
    toggleClass(args.cell, 'wj-cell-editable', YELLOW_HIGHLIGHT_COLUMNS.has(binding));
  };

  const handleCellEditEnded = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.SSPM>>,
    e: CellRangeEventArgs
  ) => {
    const dataItem = GridUtils.getRow(grid, e.row);
    const binding = GridUtils.getBinding(grid, e.col);
    if (!dataItem || !binding) return;
    if (dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT) return;

    // cascade 안 cascade 방지 (deferUpdate 로 batch — 룰 07 §2.10.8)
    grid.deferUpdate(() => {
      if (binding === 'DEPT_ID') {
        // Team 변경 → 뒤 두 단계(End Customer + SCM Sale Site) 모두 클리어
        dataItem.END_CUSTOMER = '';
        dataItem.END_CUSTOMER40 = '';
        dataItem.SCM_SITE_ID = '';
        dataItem.SCM_SITE_ID40 = '';
      } else if (binding === 'END_CUSTOMER' || binding === 'END_CUSTOMER40') {
        // End Customer 변경 → SCM Sale Site 클리어
        dataItem.SCM_SITE_ID = '';
        dataItem.SCM_SITE_ID40 = '';
      }
    });
    grid.refreshRange(new CellRange(e.row, 0, e.row, -1));
  };

  const setProject = (projects: string, projectsNames?: string) => {
    const dataItem = GridUtils.getRow(gridRef.current, clickedRow);
    if (!dataItem) return;
    dataItem.PROJECT_CODE = projects;
    dataItem.PROJECT_NAME = projectsNames ?? '';
    gridRef.current?.refresh();
  };

  const setItem = (items: string, itemName?: string, itemType?: string) => {
    const dataItem = GridUtils.getRow(gridRef.current, clickedRow);
    if (!dataItem) return;
    dataItem.ITEM_ID = items;
    dataItem.ITEM_NAME = itemName ?? '';
    dataItem.ITEM_TYPE = itemType ?? '';
    gridRef.current?.refresh();
  };

  const setOwner = (owners: string) => {
    const dataItem = GridUtils.getRow(gridRef.current, clickedRow);
    if (!dataItem) return;
    dataItem.USER_ID = owners;
    gridRef.current?.refresh();
  };

  const dataItem = GridUtils.getRow(gridRef.current, clickedRow);
  const cascadeDeptId = dataItem?.DEPT_ID || 'ALL';
  const cascadeEndCustomer = dataItem?.END_CUSTOMER40 || dataItem?.END_CUSTOMER || 'ALL';
  const cascadeSalesSite = dataItem?.SCM_SITE_ID40 || dataItem?.SCM_SITE_ID || 'ALL';

  return (
    <>
      <DataGrid<ResponseData<MENU_ID, SHEETS.SSPM>>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        itemsSource={data}
        staticColumns={staticColumns}
        dblClick={handleDblClick}
        formatItem={handleFormatItem}
        cellEditEnded={handleCellEditEnded}
        isReadOnly={true}
      />
      {openProjectModal && (
        <ProjectByDivisionModal
          open={openProjectModal}
          modalClose={() => setOpenProjectModal(false)}
          setSelectedValue={setProject}
          preSearchParams={{
            divisionId: dataItem?.DIVISION_ID ?? '',
            deptId: cascadeDeptId,
            endCustomer: cascadeEndCustomer,
            salesSite: cascadeSalesSite,
            projectCode: '',
          }}
          callFromCell
        />
      )}
      {openItemModal && (
        <ItemByDivisionModal
          open={openItemModal}
          modalClose={() => setOpenItemModal(false)}
          setSelectedValue={setItem}
          preSearchParams={{
            divisionId: dataItem?.DIVISION_ID ?? '',
            deptId: cascadeDeptId,
            endCustomer: cascadeEndCustomer,
            salesSite: cascadeSalesSite,
            projectCode: dataItem?.PROJECT_CODE || 'ALL',
            activeFlag: 'ALL',
            itemId: '',
          }}
          callFromCell
        />
      )}
      {openOwnerModal && (
        <OwnerByDivisionModal
          open={openOwnerModal}
          modalClose={() => setOpenOwnerModal(false)}
          setSelectedValue={setOwner}
          preSearchParams={{
            divisionId: dataItem?.DIVISION_ID ?? '',
            deptId: cascadeDeptId,
            endCustomer: cascadeEndCustomer,
            projectCode: dataItem?.PROJECT_CODE || 'ALL',
            salesSite: cascadeSalesSite,
            owner: '',
          }}
          multiCheckbox
        />
      )}
    </>
  );
};
