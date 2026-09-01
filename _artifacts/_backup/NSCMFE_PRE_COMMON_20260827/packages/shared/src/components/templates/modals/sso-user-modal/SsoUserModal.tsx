import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import _ from 'lodash';
import { useEffect, useRef, useState } from 'react';

import { GridUtils } from '@foundation/utils';
import { SearchArea, DataGrid, CustomDialog } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import type { DialogNavigationSize } from '@shared/lges';
import { Grid } from '@shared/mui';

import { POPUP_ID, SHEETS } from './sso-user-modal.constants';
import styles from './SsoUserModal.module.scss';
import { useSsoUserModalStore } from './useSsoUserModalStore';

interface SsoUserModalProps {
  size?: DialogNavigationSize;
  open: boolean;
  modalClose: () => void;
  setSelectedValue: (userId: string, userNm: string, userEngNm: string) => void;
  initialUser?: string;
}

export const SsoUserModal = ({
  size = 800,
  open,
  modalClose,
  setSelectedValue,
  initialUser = '',
}: SsoUserModalProps) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<ResponseData<POPUP_ID, SHEETS.SSO_USER>> | undefined>();

  const initialized = useSsoUserModalStore(state => state.initialized);
  const staticColumns = useSsoUserModalStore(state => state.staticColumns);
  const fetchStaticColumns = useSsoUserModalStore(state => state.fetchStaticColumns);

  const [modalFilters, setModalFilters] = useState<{
    user: string;
  }>({
    user: initialUser,
  });

  const { data } = useTabProcQuery<POPUP_ID, SHEETS.SSO_USER>({
    menuId: POPUP_ID,
    sheetName: SHEETS.SSO_USER,
    tabId: POPUP_ID,
    filters: undefined,
    enabled: true,
  });

  const itemsSource = (data?.o_rc ?? []).filter(
    user =>
      (user.USER_ID ?? '').toLowerCase().includes(modalFilters.user.toLowerCase()) ||
      (user.USER_ENG_NM ?? '').toLowerCase().includes(modalFilters.user.toLowerCase()) ||
      (user.USER_NM ?? '').toLowerCase().includes(modalFilters.user.toLowerCase())
  );

  const handleFilterChange = _.debounce((user: string) => {
    setModalFilters({
      user: user,
    });
  }, 50);

  const handleDblClick = (e: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;

    const ht = grid.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;

    setSelectedValue(dataItem.USER_ID, dataItem.USER_NM, dataItem.USER_ENG_NM);

    modalClose();
  };

  useEffect(() => {
    if (!open) return;
    setModalFilters({
      user: initialUser,
    });
    if (!initialized) void fetchStaticColumns();
  }, [open]);

  return (
    <CustomDialog
      size={size}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00352', '_User Popup')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t('LBL00722', '_Search')}
            conditions={
              <Grid size={8}>
                <FormItem
                  label={t('LBL00339', '_User ID(Name)')}
                  labelAlign='right'
                  render={() => (
                    <InputField
                      fullWidth
                      defaultValue={initialUser}
                      onChange={event => handleFilterChange(event.target.value)}
                    />
                  )}
                  labelSize='long'
                />
              </Grid>
            }
          />
          <div className={styles.gridWrapper}>
            <DataGrid<ResponseData<POPUP_ID, SHEETS.SSO_USER>>
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
