import { AllowMerging, CellRange, CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, useState, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { ItemByDivisionModal, OwnerModal, TeamModal, ProjectModal } from '../../../components';
import type { MODAL_OWNER } from '../../../components/ownerModal/owner-modal.constants';
import type { RESPONSE_SET, MENU_ID } from '../sales-site-project-model.constants';
import { SHEETS, SHEET_INDEX } from '../sales-site-project-model.constants';
import { useSalesSiteProjectModelStore } from '../useSalesSiteProjectModelStore';

interface SalesSiteProjectModelGridProps {
  gridRef: MutableRefObject<
    FlexGrid<ResponseData<MENU_ID, SHEETS.PRODUCTION, RESPONSE_SET.PRODUCTION>> | undefined
  >;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.PRODUCTION, RESPONSE_SET.PRODUCTION>[];
  setActiveTab: (tab: SHEET_INDEX) => void;
}

export const SalesSiteProjectModelGrid = ({
  gridRef,
  gridFilterRef,
  data,
  setActiveTab,
}: SalesSiteProjectModelGridProps) => {
  const editTrackerRef = useRef<
    EditTracker<ResponseData<MENU_ID, SHEETS.PRODUCTION, RESPONSE_SET.PRODUCTION>> | undefined
  >();

  const filters = useSalesSiteProjectModelStore(state => state.filters);
  const staticColumns = useSalesSiteProjectModelStore(state => state.staticColumns);
  const setPurchaseFilter = useSalesSiteProjectModelStore(state => state.setPurchaseFilter);

  const [openTeamModal, setOpenTeamModal] = useState<boolean>(false);
  const [openOwnerModal, setOpenOwnerModal] = useState<boolean>(false);
  const [openItemModal, setOpenItemModal] = useState<boolean>(false);
  const [openProjectModal, setOpenProjectModal] = useState<boolean>(false);
  const [ownerOpenByPm, setOwnerOpenByPm] = useState<boolean>(false);
  const [clickedRow, setClickedRow] = useState(-1);
  const clickedDataItem = GridUtils.getRow(gridRef.current, clickedRow);

  const handleTeamSelected = (teamId: string, teamName?: string) => {
    if (!clickedDataItem) return;

    editTrackerRef.current?.storeChange(
      clickedDataItem,
      'DEPT_ID',
      clickedDataItem.DEPT_ID,
      teamId ?? ''
    );
    editTrackerRef.current?.storeChange(
      clickedDataItem,
      'TEAM_NAME',
      clickedDataItem.TEAM_NAME,
      teamName ?? ''
    );
    clickedDataItem.DEPT_ID = teamId;
    clickedDataItem.TEAM_NAME = teamName ?? '';

    gridRef.current?.refreshRange(new CellRange(clickedRow, 0, clickedRow, -1));
  };

  const handleOwnerSelected = (selectedUsers: ResponseData<MODAL_OWNER, 'owner', 'o_rc1'>[]) => {
    if (!clickedDataItem || !selectedUsers) return;

    const owners = selectedUsers.map(item => item.USER_ID).join(',');
    const ownersNames = selectedUsers.map(item => item.USER_NAME_EN).join(',');

    if (ownerOpenByPm) {
      editTrackerRef.current?.storeChange(
        clickedDataItem,
        'PRJ_OWNR_ID',
        clickedDataItem.PRJ_OWNR_ID,
        owners
      );
      clickedDataItem.PRJ_OWNR_ID = owners;
    } else {
      editTrackerRef.current?.storeChange(clickedDataItem, 'OWNER', clickedDataItem.OWNER, owners);
      editTrackerRef.current?.storeChange(
        clickedDataItem,
        'OWNER_NAME',
        clickedDataItem.OWNER_NAME,
        ownersNames
      );

      clickedDataItem.OWNER = owners;
      clickedDataItem.OWNER_NAME = ownersNames;
    }

    gridRef.current?.refreshRange(new CellRange(clickedRow, 0, clickedRow, -1));
  };

  const handleProjectSelected = (projects: string, projectsNames?: string) => {
    if (!clickedDataItem || !projects) return;

    const projectCode = projects?.split(',')[0] ?? '';
    const projectName = projectsNames?.split(',')[0] ?? '';

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
      projectName
    );

    clickedDataItem.PROJECT_CODE = projectCode;
    clickedDataItem.PROJECT_NAME = projectName;

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
      'ITEM_NAME',
      clickedDataItem.ITEM_NAME,
      itemName ?? ''
    );
    editTrackerRef.current?.storeChange(
      clickedDataItem,
      'ITEM_CLASS_NAME',
      clickedDataItem.ITEM_TYPE,
      itemType ?? ''
    );

    clickedDataItem.ITEM_ID = itemCode;
    clickedDataItem.ITEM_NAME = itemName ?? '';
    clickedDataItem.ITEM_CLASS_NAME = itemType ?? '';

    gridRef.current?.refreshRange(new CellRange(clickedRow, 0, clickedRow, -1));
  };

  const handleFocus = () => {
    setActiveTab(SHEET_INDEX.PRODUCTION);
  };

  const handleGridDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    const binding = GridUtils.getBinding(grid, ht.col);

    if (!dataItem || !binding) return;

    if (binding === 'DEPT_ID' || binding === 'TEAM_NAME') {
      setClickedRow(ht.row);
      setOpenTeamModal(true);
      return;
    } else if (binding === 'OWNER' || binding === 'PRJ_OWNR_ID') {
      setClickedRow(ht.row);
      setOwnerOpenByPm(binding === 'PRJ_OWNR_ID');
      setOpenOwnerModal(true);
      return;
    } else if (
      dataItem.DIVISION_ID !== '40' &&
      dataItem.CRUD_TYPE === CRUD_TYPE.INSERT &&
      binding === 'PROJECT_CODE'
    ) {
      setClickedRow(ht.row);
      setOpenProjectModal(true);
      return;
    } else if (
      dataItem.CRUD_TYPE === CRUD_TYPE.INSERT &&
      dataItem.DIVISION_ID === '40' &&
      ['ITEM_ID', 'ITEM_NAME', 'ITEM_CLASS_NAME'].includes(binding)
    ) {
      setClickedRow(ht.row);
      setOpenItemModal(true);
    }

    if (dataItem?.DIVISION_ID === '40' || GridUtils.isEditableCell(grid, ht.row, ht.col)) return;

    setClickedRow(ht.row);
    setPurchaseFilter({
      divisionId: dataItem.DIVISION_ID,
      salesSite: dataItem.SCM_SITE_ID,
      projectCode: dataItem.PROJECT_CODE,
      activeFlag: dataItem.VALID_YN,
    });
  };

  return (
    <>
      <DataGrid<ResponseData<MENU_ID, SHEETS.PRODUCTION, RESPONSE_SET.PRODUCTION>>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={data}
        staticColumns={staticColumns[SHEETS.PRODUCTION]}
        allowMerging={AllowMerging.ColumnHeaders}
        gotFocus={handleFocus}
        dblClick={handleGridDblClick}
      />
      <TeamModal
        open={openTeamModal}
        modalClose={() => setOpenTeamModal(false)}
        setSelectedValue={handleTeamSelected}
        teamId={clickedDataItem?.DEPT_ID}
        teamName={clickedDataItem?.TEAM_NAME}
      />
      <OwnerModal
        open={openOwnerModal}
        modalClose={() => setOpenOwnerModal(false)}
        setSelectedValue={handleOwnerSelected}
        divisionId={filters.production?.divisionId ?? '40'}
        ownerId={ownerOpenByPm ? clickedDataItem?.PRJ_OWNR_ID : clickedDataItem?.OWNER}
      />
      <ItemByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        setSelectedValue={handleItemSelected}
        preSearchParams={{
          divisionId: clickedDataItem?.DIVISION_ID ?? 'ALL',
          deptId: clickedDataItem?.DEPT_ID ?? 'ALL',
          endCustomer: clickedDataItem?.END_CUSTOMER ?? 'ALL',
          salesSite: clickedDataItem?.SCM_SITE_ID ?? 'ALL',
          projectCode: clickedDataItem?.PROJECT_CODE ?? '',
          itemId: clickedDataItem?.ITEM_ID ?? '',
          activeFlag: clickedDataItem?.MDM_ACTIVE ?? 'Y',
        }}
        callFromCell={true}
      />
      <ProjectModal
        open={openProjectModal}
        modalClose={() => setOpenProjectModal(false)}
        setSelectedValue={handleProjectSelected}
        preSearchParams={{
          divisionId: clickedDataItem?.DIVISION_ID ?? 'ALL',
        }}
        preProject={clickedDataItem?.PROJECT_CODE ?? ''}
      />
    </>
  );
};
