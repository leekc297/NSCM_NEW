import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { GridUtils } from '@foundation/utils';
import { SearchArea, DataGrid, CustomDialog } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { MODAL_SHEET_SLOC, MODAL_SLOC } from './storage-location-modal.constants';
import styles from './StorageLocationModal.module.scss';
import { useSlocModalStore } from './storageLocationModalStore';

interface StorageLocationModalProps {
  open: boolean;
  modalClose: () => void;
  setSelectedValue: (plantId: string, storageId: string, storageDesc: string) => void;
  divisionId?: string;
  storageId?: string;
}

export const StorageLocationModal = ({
  open,
  modalClose,
  setSelectedValue,
  divisionId = '',
  storageId = '',
}: StorageLocationModalProps) => {
  const { t } = useTranslation();

  const gridRef = useRef<
    FlexGrid<ResponseData<MODAL_SLOC, MODAL_SHEET_SLOC, 'o_rc1'>> | undefined
  >();

  const initialized = useSlocModalStore(state => state.initialized);
  const staticColumns = useSlocModalStore(state => state.staticColumns);
  const fetchStaticColumns = useSlocModalStore(state => state.fetchStaticColumns);

  const [divisions] = useTabComboQueries({
    filters: ['MyDivision'],
  });

  // 실제 조회 조건 — Search 버튼/Enter(그리고 팝업 오픈) 시에만 갱신되고, 그때 프로시저를 재호출한다.
  //   (useTabProcQuery 는 filters 가 query key 라 값이 바뀌면 재조회. COM0003 은 storageId 를
  //   IN 파라미터로 받는다 — configs/types/procedures.d.ts COM0003.sloc.request 참고)
  const [searchParam, setSearchParam] = useState<{
    divisionId: string;
    storageId: string;
  }>({ divisionId, storageId });

  // 입력 중인 값 — 조회하지 않고 로컬 state 에만 담아둔다.
  const [storageIdInput, setStorageIdInput] = useState<string>(storageId);

  const {
    data: slocData,
    isLoading,
    isFetching,
  } = useTabProcQuery<MODAL_SLOC>({
    menuId: MODAL_SLOC,
    sheetName: MODAL_SHEET_SLOC,
    tabId: MODAL_SLOC,
    filters: searchParam,
    enabled: true,
  });
  const loading = isLoading || isFetching;

  // 필터링은 프로시저(storageId 파라미터)가 하고, 그리드는 조회 결과를 그대로 보여준다.
  //   useMemo — 매 렌더 새 배열이면 그리드가 re-bind 되어 스크롤·선택이 초기화된다.
  const itemsSource = useMemo(() => slocData?.o_rc1 ?? [], [slocData]);

  const handleSearch = () => {
    setSearchParam(param => ({ ...param, storageId: storageIdInput }));
  };

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;

    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const slocData = GridUtils.getRow(grid, ht.row);
    if (!slocData) return;

    setSelectedValue(slocData.PLANT_ID, slocData.STORAGE_ID, slocData.STORAGE_DESCRIPTION);
    modalClose();
  };

  const handleSubmit = () => {
    const selections = gridRef.current
      ?.selectedItems as ResponseData<MODAL_SLOC, MODAL_SHEET_SLOC, 'o_rc1'>[];
    if (!selections?.length) return;

    setSelectedValue(
      selections[0].PLANT_ID,
      selections[0].STORAGE_ID,
      selections[0].STORAGE_DESCRIPTION
    );
    modalClose();
  };

  useEffect(() => {
    if (!open) return;
    setSearchParam({
      divisionId: divisionId,
      storageId: storageId,
    });
    setStorageIdInput(storageId);
    if (!initialized) void fetchStaticColumns();
  }, [open]);

  return (
    <CustomDialog
      size={1000}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00335', '_Sloc by Division')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t('LBL00664', 'Search')}
            onSearch={handleSearch}
            conditions={
              <>
                <Grid size={6}>
                  <FormItem
                    label={t('LBL00001', '_Division')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        disabled
                        value={divisions?.find(item => item.CODE === divisionId)?.NAME ?? ''}
                      />
                    )}
                  />
                </Grid>
                <Grid size={6}>
                  <FormItem
                    label={t('LBL00319', '_Storage')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={storageIdInput}
                        onChange={e => setStorageIdInput(e.target.value)}
                        onKeyDown={e => e.key === 'Enter' && handleSearch()}
                      />
                    )}
                  />
                </Grid>
              </>
            }
          />
          <div className={styles.gridWrapper}>
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={loading}
              placement='parent'
            />
            <DataGrid<ResponseData<MODAL_SLOC, MODAL_SHEET_SLOC>>
              gridRef={gridRef}
              isReadOnly
              staticColumns={staticColumns}
              itemsSource={itemsSource}
              dblClick={handleDblClick}
            />
          </div>
          <div className={styles.buttonWrapper}>
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
