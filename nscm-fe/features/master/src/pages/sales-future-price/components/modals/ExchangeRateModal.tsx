import { type FlexGrid } from '@mescius/wijmo.grid';
import { useRef, useState } from 'react';

import type { EditTracker } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid, SearchArea } from '@shared/components';
import { useProcMutation, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { Grid, Stack } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { MENU_ID } from '../../sales-future-price.constants';

import styles from './ExchangeRateModal.module.scss';

interface ExchangeRateModalProps {
  open: boolean;
  modalClose: () => void;
  defaultDivision: string;
}

const SHEET_NM = 'exchangeRate' as never;

export const ExchangeRateModal = ({
  open,
  modalClose,
  defaultDivision,
}: ExchangeRateModalProps) => {
  const { t } = useTranslation();
  const { setAlert } = useMessageStore();

  const gridRef = useRef<FlexGrid<WijmoRowItem>>();
  const editTrackerRef = useRef<EditTracker<WijmoRowItem>>();

  const [filter, setFilter] = useState({
    divisionId: defaultDivision,
    periodFrom: '',
    periodTo: '',
  });
  const [enabled, setEnabled] = useState(false);

  const [divisions] = useTabComboQueries({ filters: ['MyDivision'] });

  const { data, refetch } = useTabProcQuery({
    menuId: MENU_ID as MenuId,
    sheetName: SHEET_NM,
    tabId: 'exchange-rate-modal',
    filters: filter as never,
    enabled,
  });

  const { mutate } = useProcMutation({
    menuId: MENU_ID as MenuId,
    sheetName: SHEET_NM,
    tabId: 'exchange-rate-modal',
    onSuccess: () => {
      void setAlert({ type: 'alert', content: t('MSG00005', '_저장되었습니다.') });
      void refetch();
    },
  });

  /** P2  AS-IS: DMF0020_SalesFuturePricePopUp.cs — FindData 기간 역전 (MSG00108) */
  const validatePeriodOrder = (): boolean => {
    if (!filter.periodFrom || !filter.periodTo) return true;
    const f = parseInt(filter.periodFrom.replace(/[-/]/g, ''), 10);
    const tEnd = parseInt(filter.periodTo.replace(/[-/]/g, ''), 10);
    if (f > tEnd) {
      void setAlert({ type: 'alert', content: t('MSG00108', '_조회된 데이터가 없습니다.') });
      return false;
    }
    return true;
  };

  /** P1  AS-IS: EditButton / SaveData — `!siMain.IsLock(SheetName)` (MSG00142) */
  const guardLock = (): boolean => {
    if (gridRef.current?.isReadOnly) {
      void setAlert({ type: 'alert', content: t('MSG00142', '_수정 모드에서만 사용 가능합니다.') });
      return false;
    }
    return true;
  };

  const onSearch = () => {
    if (!validatePeriodOrder()) return;
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
          <h2 className='headerTitle'>{t('LBL00093', '_Exchange Rate')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t('LBL00112', '_Search')}
            onSearch={onSearch}
            conditions={
              <>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL_COMMON_DIVISION', '_사업부')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        value={filter.divisionId}
                        options={
                          divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                        }
                        onChange={(_, option) =>
                          setFilter({ ...filter, divisionId: option as string })
                        }
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00098', '_From')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        placeholder='YYYYMM'
                        value={filter.periodFrom}
                        onChange={event =>
                          setFilter({ ...filter, periodFrom: event.target.value })
                        }
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00099', '_To')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        placeholder='YYYYMM'
                        value={filter.periodTo}
                        onChange={event => setFilter({ ...filter, periodTo: event.target.value })}
                      />
                    )}
                  />
                </Grid>
              </>
            }
          />
          <div className={styles.gridWrapper}>
            <DataGrid<WijmoRowItem>
              gridRef={gridRef}
              editTrackerRef={editTrackerRef}
              staticColumns={[]}
              itemsSource={(data as { o_rc?: WijmoRowItem[] } | undefined)?.o_rc ?? []}
              frozenColumns={3}
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
