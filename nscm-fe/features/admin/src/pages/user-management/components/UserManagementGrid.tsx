import { CellType, type FlexGrid, type FormatItemEventArgs } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, useState, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid, SsoDeptModal, SsoUserModal } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import type { MENU_ID, RESPONSE_SET, SHEETS } from '../user-management.constants';
import { useUserManagementStore } from '../useUserManagementStore';

import { AssignGroupModal } from './AssignGroupModal';
import styles from './UserManagementGrid.module.scss';

// AS-IS UserInfo.cs 의 Assign Group View 버튼 컬럼 binding. 이 컬럼 셀 클릭 시 소속 그룹 모달을 연다.
const ASSIGN_GROUP_BINDING = 'MY_GROUP';

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
  const openAssignGroupModal = useUserManagementStore(state => state.openAssignGroupModal);
  const setOpenAssignGroupModal = useUserManagementStore(state => state.setOpenAssignGroupModal);

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

    GridUtils.refreshRow(gridRef.current, clickedRow);
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

    GridUtils.refreshRow(gridRef.current, clickedRow);
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

    // DEPT_ID 모달은 컬럼이 편집 가능할 때만 연다 — 메타 INPUT_TP_CD 가 단일 진실.
    //   조회 전용(S/SEARCH_ONLY)으로 바뀌면 팝업 아이콘과 함께 모달도 열리지 않는다.
    if (binding === 'DEPT_ID' && GridUtils.isEditableCell(grid, ht.row, ht.col)) {
      setClickedRow(ht.row);
      setOpenSsoDeptModal(true);
    }
  };

  // Assign Group: "View" 셀 클릭 시 해당 행 사용자의 소속 그룹 모달을 연다 (AS-IS 는 단일클릭 버튼).
  //   신규 미저장 행은 USER_ID 없어 제외. MY_GROUP 은 메타 등록 표시 컬럼이라 binding 유니온에 없어 문자열 비교.
  const handleClick = (e: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;

    const ht = grid.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;

    if ((GridUtils.getBinding(grid, ht.col) as string) === ASSIGN_GROUP_BINDING && dataItem.USER_ID) {
      setClickedRow(ht.row);
      setOpenAssignGroupModal(true);
    }
  };

  // AS-IS UserInfo.cs 의 "View" 버튼 재현 — MY_GROUP 컬럼 셀에 View 링크를 그린다.
  //   메타 컬럼은 값이 없어 셀이 비므로 여기서 표시. 저장된 행(USER_ID 존재)에만 노출.
  const handleFormatItem = (_sender: FlexGrid, e: FormatItemEventArgs) => {
    const grid = gridRef.current;
    if (!grid) return;
    if (e.panel.cellType !== CellType.Cell) return;
    if ((GridUtils.getBinding(grid, e.col) as string) !== ASSIGN_GROUP_BINDING) return;

    const dataItem = GridUtils.getRow(grid, e.row);
    e.cell.innerHTML = dataItem?.USER_ID ? `<span class="${styles.viewLink}">View</span>` : '';
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
        click={handleClick}
        formatItem={handleFormatItem}
      />
      <SsoUserModal
        open={openSsoUserModal}
        modalClose={() => setOpenSsoUserModal(false)}
        setSelectedValue={setUser}
        initialUser={GridUtils.getRow(gridRef.current, clickedRow)?.USER_NM}
        ssoUserYn='Y'
      />
      <SsoDeptModal
        open={openSsoDeptModal}
        modalClose={() => setOpenSsoDeptModal(false)}
        setSelectedValue={setDept}
        initialDept={GridUtils.getRow(gridRef.current, clickedRow)?.DEPT_NM}
      />
      <AssignGroupModal
        open={openAssignGroupModal}
        userId={GridUtils.getRow(gridRef.current, clickedRow)?.USER_ID}
        onClose={() => setOpenAssignGroupModal(false)}
      />
    </>
  );
};
