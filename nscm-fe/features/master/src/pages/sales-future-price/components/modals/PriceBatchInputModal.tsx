import { type CellRangeEventArgs, type FlexGrid } from '@mescius/wijmo.grid';
import { useRef, useState } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid, SearchArea } from '@shared/components';
import { useProcMutation, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { Grid, Stack } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { MENU_ID } from '../../sales-future-price.constants';

import styles from './PriceBatchInputModal.module.scss';

interface BaseFilter {
  divisionId: string;
  scmSiteIds: string[];
  projectCodes: string[];
  itemIds: string[];
  periodFrom: string;
  periodTo: string;
  versionId: string;
}

interface PriceBatchInputModalProps {
  open: boolean;
  modalClose: () => void;
  baseFilter: BaseFilter;
}

const SHEET_NM = 'priceBatchInput' as never;

/**
 * P5  AS-IS: DMF0020_SaveSalesFuturePrice_Popup.cs — SaveData MSG00002
 * 9 필수 컬럼 (validation.md POPUP §3.2)
 */
const REQUIRED_FIELDS: { key: string; label: string }[] = [
  { key: 'DIVISION_ID', label: 'Division' },
  { key: 'END_CUSTOMER', label: 'End Customer' },
  { key: 'SCM_SITE_ID', label: 'Sales Site' },
  { key: 'ITEM_ID', label: 'Model' },
  { key: 'INCOTERMS', label: 'Incoterms' },
  { key: 'FCST_TYPE', label: 'FCST Type' },
  { key: 'DOM_EXP', label: 'Customs Handbook' },
  { key: 'CURRENCY', label: 'Currency' },
  { key: 'MEASURE', label: 'Measure' },
];

export const PriceBatchInputModal = ({
  open,
  modalClose,
  baseFilter,
}: PriceBatchInputModalProps) => {
  const { t } = useTranslation();
  const { setAlert } = useMessageStore();

  const gridRef = useRef<FlexGrid<WijmoRowItem>>();
  const editTrackerRef = useRef<EditTracker<WijmoRowItem>>();

  const [filter, setFilter] = useState<BaseFilter & { salesSite: string }>({
    ...baseFilter,
    salesSite: 'ALL',
  });
  const [enabled, setEnabled] = useState(false);

  const { data, refetch } = useTabProcQuery({
    menuId: MENU_ID as MenuId,
    sheetName: SHEET_NM,
    tabId: 'price-batch-input-modal',
    filters: filter as never,
    enabled,
  });

  const { mutate } = useProcMutation({
    menuId: MENU_ID as MenuId,
    sheetName: SHEET_NM,
    tabId: 'price-batch-input-modal',
    onSuccess: () => {
      void setAlert({ type: 'alert', content: t('MSG00005', '_저장되었습니다.') });
      void refetch();
    },
  });

  /** P3  AS-IS: L2369 EditButton — `!siMain.IsLock(SheetName)` (MSG00135) */
  const guardLock1 = (): boolean => {
    if (gridRef.current?.isReadOnly) {
      void setAlert({ type: 'alert', content: t('MSG00135', '_수정 모드에서만 사용 가능합니다.') });
      return false;
    }
    return true;
  };

  /** P4  AS-IS: EditButton/SaveData 추가 가드 (MSG00408) */
  const guardLock2 = (): boolean => {
    if (gridRef.current?.isReadOnly) {
      void setAlert({ type: 'alert', content: t('MSG00408', '_수정모드에서는 입력할 수 없습니다.') });
      return false;
    }
    return true;
  };

  /** P6  AS-IS: FindData — Period 역전 (MSG00108) */
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

  const onFind = () => {
    if (!validatePeriodOrder()) return;
    setEnabled(true);
    void refetch();
  };

  /**
   * AS-IS: DMF0020_SaveSalesFuturePrice_Popup.cs — PriceAll 셀 변경 시
   * 해당 행의 모든 W_* 주차 컬럼에 일괄 채움 + CRUD_TYPE='U' 마킹
   */
  const onCellEditEnded = (s: FlexGrid, e: CellRangeEventArgs) => {
    const binding = GridUtils.getBinding(s, e.col);
    if (binding !== 'PriceAll') return;
    const row = s.rows[e.row]?.dataItem as WijmoRowItem | undefined;
    if (!row) return;
    const value = row.PriceAll;
    s.columns
      .filter(c => typeof c.binding === 'string' && c.binding.startsWith('W_'))
      .forEach(c => {
        if (c.binding) row[c.binding] = value;
      });
    if (row.CRUD_TYPE !== CRUD_TYPE.INSERT && row.CRUD_TYPE !== CRUD_TYPE.DELETE) {
      row.CRUD_TYPE = CRUD_TYPE.MODIFY;
    }
  };

  const onSave = () => {
    if (!guardLock1()) return;
    if (!guardLock2()) return;
    const rows = (data as { o_rc?: WijmoRowItem[] } | undefined)?.o_rc ?? [];
    const saveData = rows.filter(item => item.CRUD_TYPE);
    if (saveData.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00018', '_변경된 사항이 없습니다.') });
      return;
    }
    // P5: 9 필수 컬럼 검사 (Zod 미설치 — plain object 검증)
    for (const row of saveData) {
      for (const r of REQUIRED_FIELDS) {
        const v = row[r.key];
        if (v === undefined || v === null || v === '') {
          void setAlert({
            type: 'alert',
            content: t('MSG00002', '_[{0}]은 필수 입력사항입니다.', { 0: r.label }),
          });
          return;
        }
      }
    }
    void setAlert({
      type: 'confirm',
      content: t('MSG00004', '_저장하시겠습니까?'),
      onConfirm: () => mutate(saveData as never),
    });
  };

  return (
    <CustomDialog
      size={1400}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00095', '_Price 일괄입력')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t('LBL00112', '_Search')}
            onSearch={onFind}
            conditions={
              <>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00050', '_Division')}
                    labelAlign='right'
                    render={() => (
                      <InputField fullWidth value={filter.divisionId} disabled />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00082', '_Sales Site')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        value={filter.salesSite}
                        options={[
                          { label: 'ALL', value: 'ALL' },
                          ...(filter.scmSiteIds ?? []).map(s => ({ label: s, value: s })),
                        ]}
                        onChange={(_, option) =>
                          setFilter({ ...filter, salesSite: option as string })
                        }
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
              frozenColumns={11}
              allowMerging='Cells'
              cellEditEnded={onCellEditEnded}
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
