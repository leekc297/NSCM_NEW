import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import _ from 'lodash';
import { useEffect, useRef, useState } from 'react';

import { GridUtils } from '@foundation/utils';
import { SearchArea, DataGrid, CustomDialog } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import type { DialogNavigationSize } from '@shared/lges';
import { Grid } from '@shared/mui';

import { SHEETS, POPUP_ID } from './sso-dept-modal.constants';
import styles from './SsoDeptModal.module.scss';
import { useSsoDeptModalStore } from './useSsoDeptModalStore';

interface SsoDeptModalProps {
  size?: DialogNavigationSize;
  open: boolean;
  modalClose: () => void;
  setSelectedValue: (deptId: string, deptNm: string) => void;
  initialDept?: string;
}

export const SsoDeptModal = ({
  size = 800,
  open,
  modalClose,
  setSelectedValue,
  initialDept = '',
}: SsoDeptModalProps) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<ResponseData<POPUP_ID, SHEETS.SSO_DEPT>> | undefined>();

  const initialized = useSsoDeptModalStore(state => state.initialized);
  const staticColumns = useSsoDeptModalStore(state => state.staticColumns);
  const fetchStaticColumns = useSsoDeptModalStore(state => state.fetchStaticColumns);

  const [modalFilters, setModalFilters] = useState<{
    dept: string;
  }>({
    dept: initialDept,
  });

  const { data } = useTabProcQuery<POPUP_ID, SHEETS.SSO_DEPT>({
    menuId: POPUP_ID,
    sheetName: SHEETS.SSO_DEPT,
    tabId: POPUP_ID,
    filters: undefined,
    enabled: true,
  });

  const itemsSource = (data?.o_rc ?? []).filter(
    dept =>
      (dept.DEPT_ID ?? '').toLowerCase().includes(modalFilters.dept.toLowerCase()) ||
      (dept.DEPT_NM ?? '').toLowerCase().includes(modalFilters.dept.toLowerCase())
  );

  const handleFilterChange = _.debounce((dept: string) => {
    setModalFilters({
      dept: dept,
    });
  }, 50);

  const handleDblClick = (e: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;

    const ht = grid.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;

    setSelectedValue(dataItem.DEPT_ID, dataItem.DEPT_NM);
    modalClose();
  };

  useEffect(() => {
    if (!open) return;
    setModalFilters({
      dept: initialDept,
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
          <h2 className='headerTitle'>{t('LBL00353', '_Dept Popup')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t('LBL00112', '_Search')}
            conditions={
              <Grid size={8}>
                <FormItem
                  label={t('LBL00338', '_Dept ID(Name)')}
                  labelAlign='right'
                  render={() => (
                    <InputField
                      fullWidth
                      defaultValue={initialDept}
                      onChange={event => handleFilterChange(event.target.value)}
                    />
                  )}
                  labelSize='long'
                />
              </Grid>
            }
          />
          <div className={styles.gridWrapper}>
            <DataGrid<ResponseData<POPUP_ID, SHEETS.SSO_DEPT>>
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
