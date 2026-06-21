import { CellType, type FlexGrid, type FormatItemEventArgs } from '@mescius/wijmo.grid';
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
    if (typeof binding !== 'string' || !YELLOW_HIGHLIGHT_COLUMNS.has(binding)) return;
    args.cell.style.backgroundColor = 'rgba(255, 212, 0, 1)';
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

  return (
    <>
      <DataGrid<ResponseData<MENU_ID, SHEETS.SSPM>>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        itemsSource={data}
        staticColumns={staticColumns}
        dblClick={handleDblClick}
        formatItem={handleFormatItem}
      />
      {openProjectModal && (
        <ProjectByDivisionModal
          open={openProjectModal}
          modalClose={() => setOpenProjectModal(false)}
          setSelectedValue={setProject}
          preSearchParams={{
            divisionId: dataItem?.DIVISION_ID ?? '',
            deptId: 'ALL',
            endCustomer: 'ALL',
            salesSite: 'ALL',
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
            deptId: 'ALL',
            endCustomer: 'ALL',
            salesSite: 'ALL',
            projectCode: 'ALL',
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
            deptId: 'ALL',
            endCustomer: 'ALL',
            projectCode: 'ALL',
            salesSite: 'ALL',
            owner: '',
          }}
        />
      )}
    </>
  );
};
