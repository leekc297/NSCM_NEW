import { CellRange, CellType, SelectionMode, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, useState, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid, SsoUserModal } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import { type MENU_ID, SHEETS } from '../group-user.constants';
import { useGroupUserStore } from '../useGroupUserStore';

// 타입 SSOT — procedures.d.ts SYS0014.userInfo (USER_ID/USER_NM/DEPT_NM/USE_YN)
type UserInfoRow = ResponseData<MENU_ID, SHEETS.USER_INFO>;

interface Props {
  gridRef: MutableRefObject<FlexGrid | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: UserInfoRow[];
  onFocus?: () => void;
}

export const GroupUserInfoGrid = ({ gridRef, gridFilterRef, data, onFocus }: Props) => {
  const { t } = useTranslation();
  const editTrackerRef = useRef<EditTracker<UserInfoRow>>();
  const [clickedRow, setClickedRow] = useState<number>(-1);
  const [openSsoUser, setOpenSsoUser] = useState(false);
  const setAlert = useMessageStore(state => state.setAlert);

  const staticColumns = useGroupUserStore(state => state.staticColumns[SHEETS.USER_INFO]);
  const setSelectedUserId = useGroupUserStore(state => state.setSelectedUserId);

  const handleSelectionChanged = (g: FlexGrid) => {
    const row = g.selectedItems[0] as { USER_ID?: string } | undefined;
    if (row?.USER_ID) setSelectedUserId(String(row.USER_ID));
  };

  const handleDblClick = (e: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;
    const dataItem = GridUtils.getRow(grid, ht.row) as { CRUD_TYPE?: string } | undefined;
    if (!dataItem) return;
    const binding = GridUtils.getBinding(grid, ht.col);

    if (binding === 'USER_ID' && dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT) {
      void setAlert({ type: 'alert', content: t('MSG00007', '_변경이 불가한 데이터입니다.') });
      return;
    }
    if (binding === 'USER_ID' && dataItem.CRUD_TYPE === CRUD_TYPE.INSERT) {
      setClickedRow(ht.row);
      setOpenSsoUser(true);
    }
  };

  const setUser = (userId: string, userNm: string, _userEngNm: string, deptId?: string) => {
    const dataItem = GridUtils.getRow(gridRef.current, clickedRow) as
      | { USER_ID?: string; USER_NM?: string; DEPT_NM?: string; CRUD_TYPE?: string }
      | undefined;
    if (!dataItem) return;
    if (dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT) return;

    editTrackerRef.current?.storeChange(
      dataItem as UserInfoRow,
      'USER_ID',
      dataItem.USER_ID ?? '',
      userId
    );
    editTrackerRef.current?.storeChange(
      dataItem as UserInfoRow,
      'USER_NM',
      dataItem.USER_NM ?? '',
      userNm
    );
    if (deptId !== undefined) {
      editTrackerRef.current?.storeChange(
        dataItem as UserInfoRow,
        'DEPT_NM',
        dataItem.DEPT_NM ?? '',
        deptId
      );
      dataItem.DEPT_NM = deptId;
    }
    dataItem.USER_ID = userId;
    dataItem.USER_NM = userNm;

    gridRef.current?.refreshRange(new CellRange(clickedRow, 0, clickedRow, -1));
  };

  return (
    <>
      <DataGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={data}
        staticColumns={staticColumns}
        selectionMode={SelectionMode.Row}
        selectionChanged={handleSelectionChanged}
        dblClick={handleDblClick}
        gotFocus={() => onFocus?.()}
      />
      <SsoUserModal
        open={openSsoUser}
        modalClose={() => setOpenSsoUser(false)}
        setSelectedValue={setUser}
        initialUser={
          (GridUtils.getRow(gridRef.current, clickedRow) as { USER_NM?: string })?.USER_NM
        }
      />
    </>
  );
};
