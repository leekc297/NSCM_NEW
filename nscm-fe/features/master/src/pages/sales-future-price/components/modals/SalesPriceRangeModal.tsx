import { type FlexGrid } from '@mescius/wijmo.grid';
import { useRef, useState } from 'react';

import dayjs from '@foundation/dayjs';
import type { EditTracker } from '@foundation/utils';
import { CustomDialog, DataGrid, SearchArea } from '@shared/components';
import { useProcMutation, useTabProcQuery } from '@shared/hooks';
import { Button, DatePickerCalendar, FormItem } from '@shared/lges';
import { Grid, Stack } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { MENU_ID } from '../../sales-future-price.constants';

import styles from './SalesPriceRangeModal.module.scss';

interface SalesPriceRangeModalProps {
  open: boolean;
  modalClose: () => void;
}

const SHEET_NM = 'salesPriceRange' as never;

export const SalesPriceRangeModal = ({ open, modalClose }: SalesPriceRangeModalProps) => {
  const { t } = useTranslation();
  const { setAlert } = useMessageStore();

  const gridRef = useRef<FlexGrid<WijmoRowItem>>();
  const editTrackerRef = useRef<EditTracker<WijmoRowItem>>();

  const [filter, setFilter] = useState({ periodFrom: '', periodTo: '' });
  const [enabled, setEnabled] = useState(false);

  const { data, refetch } = useTabProcQuery({
    menuId: MENU_ID as MenuId,
    sheetName: SHEET_NM,
    tabId: 'sales-price-range-modal',
    filters: filter as never,
    enabled,
  });

  const { mutate } = useProcMutation({
    menuId: MENU_ID as MenuId,
    sheetName: SHEET_NM,
    tabId: 'sales-price-range-modal',
    onSuccess: () => {
      void setAlert({ type: 'alert', content: t('MSG00005', '_저장되었습니다.') });
      void refetch();
    },
  });

  /** AS-IS: btnSavePricePeriod_Click L2369 — `!siMain.IsLock` (MSG00408) */
  const guardLock = (): boolean => {
    if (gridRef.current?.isReadOnly) {
      void setAlert({ type: 'alert', content: t('MSG00408', '_수정모드에서는 입력할 수 없습니다.') });
      return false;
    }
    return true;
  };

  const onSearch = () => {
    setEnabled(true);
    void refetch();
  };

  const onSave = () => {
    if (!guardLock()) return;
    const rows = (data as { o_rc?: WijmoRowItem[] } | undefined)?.o_rc ?? [];
    const saveData = rows.filter(item => item.CRUD_TYPE);
    if (saveData.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00018', '_변경된 사항이 없습니다.') });
      return;
    }
    void setAlert({
      type: 'confirm',
      content: t('MSG00004', '_저장하시겠습니까?'),
      onConfirm: () => mutate(saveData as never),
    });
  };

  return (
    <CustomDialog
      size={1200}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00094', '_Sales Price Range')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t('LBL00112', '_Search')}
            onSearch={onSearch}
            conditions={
              <Grid size={6}>
                <FormItem
                  label={t('LBL00086', '_Period')}
                  labelAlign='right'
                  render={() => (
                    <DatePickerCalendar
                      sx={{ width: '100%' }}
                      usecase='date-range-multi'
                      elevation
                      size='large'
                      value={[
                        filter.periodFrom ? dayjs(filter.periodFrom) : dayjs(),
                        filter.periodTo ? dayjs(filter.periodTo) : dayjs(),
                      ]}
                      onChange={date => {
                        const [from, to] = date as [unknown, unknown];
                        setFilter({
                          periodFrom: from ? String(from) : '',
                          periodTo: to ? String(to) : '',
                        });
                      }}
                    />
                  )}
                />
              </Grid>
            }
          />
          <div className={styles.gridWrapper}>
            <DataGrid<WijmoRowItem>
              gridRef={gridRef}
              editTrackerRef={editTrackerRef}
              staticColumns={[]}
              itemsSource={(data as { o_rc?: WijmoRowItem[] } | undefined)?.o_rc ?? []}
            />
          </div>
          <Stack direction='row' spacing={1} className={styles.actionBar}>
            <Button appearance='outlined' priority='normal' onClick={onSave}>
              {t('LBL00057', '_Save')}
            </Button>
            <Button appearance='outlined' priority='normal' onClick={modalClose}>
              {t('LBL00103', '_Close')}
            </Button>
          </Stack>
        </div>
      }
    />
  );
};
