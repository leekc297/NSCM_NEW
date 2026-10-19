import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useRef, useState } from 'react';

import { GridUtils } from '@foundation/utils';
import { SearchArea, DataGrid, CustomDialog } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { ArrowChevron2Icon, ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { MODAL_OWNER, MODAL_SHEET_OWNER } from './owner-modal.constants';
import styles from './OwnerModal.module.scss';
import { useOwnerModalStore } from './ownerModalStore';

interface OwnerModalProps {
  open: boolean;
  modalClose: () => void;
  setSelectedValue: (
    selectedOwners: ResponseData<MODAL_OWNER, MODAL_SHEET_OWNER, 'o_rc1'>[]
  ) => void;
  divisionId: string;
  ownerId?: string;
  /** true 면 담당자를 한 명만 확정할 수 있다 — 2명 이상 선택 후 OK 시 경고하고 닫지 않는다. */
  singleSelect?: boolean;
}

export const OwnerModal = ({
  open,
  modalClose,
  setSelectedValue,
  divisionId,
  ownerId,
  singleSelect = false,
}: OwnerModalProps) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const candidateGridRef = useRef<
    FlexGrid<ResponseData<MODAL_OWNER, MODAL_SHEET_OWNER, 'o_rc1'>> | undefined
  >();
  const selectedGridRef = useRef<
    FlexGrid<ResponseData<MODAL_OWNER, MODAL_SHEET_OWNER, 'o_rc1'>> | undefined
  >();

  const initialized = useOwnerModalStore(state => state.initialized);
  const staticColumns = useOwnerModalStore(state => state.staticColumns);
  const fetchStaticColumns = useOwnerModalStore(state => state.fetchStaticColumns);

  // 실제 조회 조건 — Search 버튼/Enter(그리고 팝업 오픈) 시에만 갱신되고, 그때 프로시저를 재호출한다.
  //   (useTabProcQuery 는 filters 가 query key 라 값이 바뀌면 재조회. COM0004 는 user 를 IN
  //   파라미터로 받는다 — configs/types/procedures.d.ts COM0004.owner.request 참고)
  const [searchParam, setSearchParam] = useState<{
    divisionId: string;
    user: string;
  }>({ divisionId, user: '' });

  // divisionId prop 이 팝업을 닫지 않고도 바뀌는 호출처가 있을 수 있어 반영해 둔다
  //   (기존 DEFAULT_FILTER 가 divisionId 의존 useMemo 였던 것과 동일한 반응성 유지).
  useEffect(() => {
    setSearchParam(prev => ({ ...prev, divisionId }));
  }, [divisionId]);

  // 입력 중인 값 — 조회하지 않고 로컬 state 에만 담아둔다.
  const [userInput, setUserInput] = useState<string>('');

  const { data: userData } = useTabProcQuery<MODAL_OWNER>({
    menuId: MODAL_OWNER,
    sheetName: MODAL_SHEET_OWNER,
    tabId: 'OwnerModal',
    filters: searchParam,
    enabled: true,
  });

  const [selectedUsers, setSelectedUsers] = useState<
    ResponseData<MODAL_OWNER, MODAL_SHEET_OWNER, 'o_rc1'>[]
  >([]);

  // 필터링(user 키워드)은 프로시저가 하고, 여기서는 이미 선택된 사용자만 후보에서 제외한다.
  const candidateUsers = (userData?.o_rc1 ?? []).filter(
    user => !selectedUsers.some(selected => selected.USER_ID === user.USER_ID)
  );

  const handleSearch = () => setSearchParam(prev => ({ ...prev, user: userInput }));

  const handleSelectUsers = () => {
    const selectedItems = candidateGridRef.current?.selectedItems as ResponseData<
      MODAL_OWNER,
      MODAL_SHEET_OWNER,
      'o_rc1'
    >[];

    if (!selectedItems || selectedItems.length === 0) return;

    setSelectedUsers(prev => [...prev, ...selectedItems]);

    candidateGridRef.current?.select(-1, -1);
  };

  const handleCancelUsers = () => {
    const canceledItems = selectedGridRef.current?.selectedItems as ResponseData<
      MODAL_OWNER,
      MODAL_SHEET_OWNER,
      'o_rc1'
    >[];
    if (!canceledItems || canceledItems.length === 0) return;

    const userIdsToRemove = new Set(canceledItems.map(item => item.USER_ID));
    setSelectedUsers(prev => prev.filter(user => !userIdsToRemove.has(user.USER_ID)));

    selectedGridRef.current?.select(-1, -1);
  };

  const handleSubmit = () => {
    if (singleSelect && selectedUsers.length > 1) {
      void setAlert({
        type: 'alert',
        content: t('MSG01000', 'Owner(sales)는 한명만 선택 가능합니다.'),
      });
      return;
    }

    setSelectedValue(selectedUsers);
    modalClose();
  };

  const handleCandidateDblClick = (mouseEvent: MouseEvent) => {
    const grid = candidateGridRef.current;
    if (!grid) return;

    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const selectedItem = GridUtils.getRow(grid, ht.row);
    if (!selectedItem) return;

    setSelectedUsers(prev => [...prev, selectedItem]);
  };

  const handleSelectedDblClick = (mouseEvent: MouseEvent) => {
    const grid = selectedGridRef.current;
    if (!grid) return;

    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const selectedItem = GridUtils.getRow(grid, ht.row);
    if (!selectedItem) return;

    setSelectedUsers(prev => prev.filter(item => item.USER_ID !== selectedItem.USER_ID));
  };

  useEffect(() => {
    if (!open) return;
    setSearchParam(prev => ({ ...prev, user: '' }));
    setUserInput('');
    const ownerList = ownerId?.split(',') || [];
    const allUsers = userData?.o_rc1 ?? [];
    setSelectedUsers(allUsers.filter(user => ownerList.includes(user.USER_ID)));
    if (!initialized) void fetchStaticColumns();
  }, [open, ownerId]);

  return (
    <CustomDialog
      size={800}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00336', '_OwnerPopup')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t('LBL00664', 'Search')}
            onSearch={handleSearch}
            conditions={
              <Grid size={4}>
                <FormItem
                  label={t('LBL00326', '_User ID')}
                  labelAlign='right'
                  render={() => (
                    <InputField
                      fullWidth
                      value={userInput}
                      onChange={e => setUserInput(e.target.value)}
                      onKeyDown={e => e.key === 'Enter' && handleSearch()}
                    />
                  )}
                />
              </Grid>
            }
          />
          <div className={styles.gridWrapper}>
            <DataGrid<ResponseData<MODAL_OWNER, MODAL_SHEET_OWNER, 'o_rc1'>>
              gridRef={candidateGridRef}
              isReadOnly
              staticColumns={staticColumns}
              itemsSource={candidateUsers}
              dblClick={handleCandidateDblClick}
            />
            <div className={styles.arrowButtonWrapper}>
              <Button
                iconComponent={<ArrowChevron2Icon appearance='single' direction='right' />}
                onClick={handleSelectUsers}
              />
              <Button
                iconComponent={<ArrowChevron2Icon appearance='single' direction='left' />}
                onClick={handleCancelUsers}
              />
            </div>
            <DataGrid<ResponseData<MODAL_OWNER, MODAL_SHEET_OWNER, 'o_rc1'>>
              gridRef={selectedGridRef}
              isReadOnly
              staticColumns={staticColumns}
              itemsSource={selectedUsers}
              dblClick={handleSelectedDblClick}
            />
          </div>
          <div className={styles.buttonWrapper}>
            {/* <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Default'
              onClick={() => {}}
            /> */}
            <Button
              appearance='contained'
              buttonLabel='OK'
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              priority='primary'
              size='medium'
              onClick={handleSubmit}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Close'
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
