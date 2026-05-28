import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import _ from '@foundation/lodash';
import { GridUtils } from '@foundation/utils';
import { SearchArea, DataGrid, CustomDialog } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
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

  const EMPTY_FILER = useMemo(() => ({ divisionId: divisionId, storageId: '' }), [divisionId]);

  const [modalFilters, setModalFilters] = useState<{
    divisionId: string;
    storageId: string;
  }>(EMPTY_FILER);

  const { data: slocData } = useTabProcQuery<MODAL_SLOC>({
    menuId: MODAL_SLOC,
    sheetName: MODAL_SHEET_SLOC,
    tabId: MODAL_SLOC,
    filters: EMPTY_FILER,
    enabled: true,
  });

  const itemsSource = (slocData?.o_rc1 ?? []).filter(sloc =>
    (sloc.STORAGE_ID ?? '').toLowerCase().includes(modalFilters.storageId.toLowerCase())
  );

  const handleFilterChange = _.debounce((storageId: string) => {
    setModalFilters(filter => ({
      ...filter,
      storageId: storageId,
    }));
  }, 50);

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

  useEffect(() => {
    if (!open) return;
    setModalFilters({
      divisionId: divisionId,
      storageId: storageId,
    });
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
                        defaultValue={storageId}
                        onChange={e => handleFilterChange(e.target.value)}
                      />
                    )}
                  />
                </Grid>
              </>
            }
          />
          <div className={styles.gridWrapper}>
            <DataGrid<ResponseData<MODAL_SLOC, MODAL_SHEET_SLOC>>
              gridRef={gridRef}
              isReadOnly
              staticColumns={staticColumns}
              itemsSource={itemsSource}
              dblClick={handleDblClick}
            />
          </div>
        </div>
      }
    />
  );
};
