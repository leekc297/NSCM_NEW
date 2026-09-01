import { CellRange, CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, useState, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid, SsoDeptModal, SsoUserModal } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import type { MENU_ID, RESPONSE_SET, SHEETS } from '../user-management.constants';
import { useUserManagementStore } from '../useUserManagementStore';

interface UserManagementGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.USER_MGMT>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.USER_MGMT>[];
}

export const UserManagementGrid = ({ gridRef, gridFilterRef, data }: UserManagementGridProps) => {
  const editTrackerRef =
    useRef<EditTracker<ResponseData<MENU_ID, SHEETS.USER_MGMT, RESPONSE_SET.USER_MGMT>>>();

  const [clickedRow, setClickedRow] = useState<number>(-1);

  const staticColumns = useUserManagementStore(state => state.staticColumns);
  const openSsoUserModal = useUserManagementStore(state => state.openSsoUserModal);
  const setOpenSsoUserModal = useUserManagementStore(state => state.setOpenSsoUserModal);
  const openSsoDeptModal = useUserManagementStore(state => state.openSsoDeptModal);
  const setOpenSsoDeptModal = useUserManagementStore(state => state.setOpenSsoDeptModal);

  const { t } = useTranslation();
  const { setAlert } = useMessageStore();

  const setUser = (userId: string, userNm: string, userEngNm: string) => {
    const dataItem = GridUtils.getRow(gridRef.current, clickedRow);
    if (!dataItem) return;

    if (dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT) return;
    editTrackerRef.current?.storeChange(dataItem, 'USER_ID', dataItem.USER_ID, userId);
    editTrackerRef.current?.storeChange(dataItem, 'USER_NM', dataItem.USER_NM, userNm);
    editTrackerRef.current?.storeChange(dataItem, 'USER_ENG_NM', dataItem.USER_ENG_NM, userEngNm);

    dataItem.USER_ID = userId;
    dataItem.USER_NM = userNm;
    dataItem.USER_ENG_NM = userEngNm;

    if (dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT && dataItem.CRUD_TYPE !== CRUD_TYPE.DELETE)
      dataItem.CRUD_TYPE = CRUD_TYPE.MODIFY;

    gridRef.current?.refreshRange(new CellRange(clickedRow, 0, clickedRow, -1));
  };

  const setDept = (deptId: string, deptNm: string) => {
    const dataItem = GridUtils.getRow(gridRef.current, clickedRow);
    if (!dataItem) return;

    editTrackerRef.current?.storeChange(dataItem, 'DEPT_ID', dataItem.DEPT_ID, deptId);
    editTrackerRef.current?.storeChange(dataItem, 'DEPT_NM', dataItem.DEPT_NM, deptNm);

    dataItem.DEPT_ID = deptId;
    dataItem.DEPT_NM = deptNm;

    if (dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT && dataItem.CRUD_TYPE !== CRUD_TYPE.DELETE)
      dataItem.CRUD_TYPE = CRUD_TYPE.MODIFY;

    gridRef.current?.refreshRange(new CellRange(clickedRow, 0, clickedRow, -1));
  };

  const handleDblClick = (e: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;

    const ht = grid.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;

    const binding = GridUtils.getBinding(grid, ht.col);

    if (binding === 'USER_ID' && dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT)
      void setAlert({ type: 'alert', content: t('MSG00007', '_변경이 불가한 데이터입니다.') });

    if (binding === 'USER_ID' && dataItem.CRUD_TYPE === CRUD_TYPE.INSERT) {
      setClickedRow(ht.row);
      setOpenSsoUserModal(true);
      return;
    }

    if (binding === 'DEPT_ID') {
      setClickedRow(ht.row);
      setOpenSsoDeptModal(true);
    }
  };

  return (
    <>
      <DataGrid<ResponseData<MENU_ID, SHEETS.USER_MGMT>>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={data}
        staticColumns={staticColumns}
        dblClick={handleDblClick}
      />
      <SsoUserModal
        open={openSsoUserModal}
        modalClose={() => setOpenSsoUserModal(false)}
        setSelectedValue={setUser}
        initialUser={GridUtils.getRow(gridRef.current, clickedRow)?.USER_NM}
      />
      <SsoDeptModal
        open={openSsoDeptModal}
        modalClose={() => setOpenSsoDeptModal(false)}
        setSelectedValue={setDept}
        initialDept={GridUtils.getRow(gridRef.current, clickedRow)?.DEPT_NM}
      />
    </>
  );
};
