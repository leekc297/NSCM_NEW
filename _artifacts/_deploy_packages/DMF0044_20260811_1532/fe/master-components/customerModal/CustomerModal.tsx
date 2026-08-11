import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import _ from '@foundation/lodash';
import { GridUtils } from '@foundation/utils';
import { DataGrid, CustomDialog, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { MODAL_CUSTOMER, MODAL_SHEET_CUSTOMER } from './customer-modal.constants';
import styles from './CustomerModal.module.scss';
import { useCustomerModalStore } from './customerModalStore';

interface CustomerModalProps {
  open: boolean;
  modalClose: () => void;
  setSelectedValue: (
    soldTo: string,
    soldToDesc: string,
    shipTo: string,
    shipToDesc: string,
    shipToRegion?: string,
    shipToCity?: string
  ) => void;
  divisionId?: string;
  soldTo?: string;
  shipTo?: string;
}

export const CustomerModal = ({
  open,
  modalClose,
  setSelectedValue,
  divisionId = '',
  soldTo = '',
  shipTo = '',
}: CustomerModalProps) => {
  const { t } = useTranslation();

  const gridRef = useRef<
    FlexGrid<ResponseData<MODAL_CUSTOMER, MODAL_SHEET_CUSTOMER, 'o_rc1'>> | undefined
  >();

  const initialized = useCustomerModalStore(state => state.initialized);
  const staticColumns = useCustomerModalStore(state => state.staticColumns);
  const fetchStaticColumns = useCustomerModalStore(state => state.fetchStaticColumns);

  const [divisions] = useTabComboQueries({
    filters: ['MyDivision'],
  });

  const EMPTY_FILTER = useMemo(
    () => ({ divisionId: divisionId, soldTo: '', shipTo: '' }),
    [divisionId]
  );

  const [modalFilters, setModalFilters] = useState<{
    divisionId: string;
    soldTo: string;
    shipTo: string;
  }>(EMPTY_FILTER);

  const { data: customerData } = useTabProcQuery<MODAL_CUSTOMER>({
    menuId: MODAL_CUSTOMER,
    sheetName: MODAL_SHEET_CUSTOMER,
    tabId: MODAL_CUSTOMER,
    filters: EMPTY_FILTER,
    enabled: true,
  });

  const itemsSource = (customerData?.o_rc1 ?? []).filter(
    customer =>
      (customer.SOLDTO_CODE ?? '').toLowerCase().includes(modalFilters.soldTo.toLowerCase()) &&
      (customer.SHIPTO_CODE ?? '').toLowerCase().includes(modalFilters.shipTo.toLowerCase())
  );

  const handleFilterChange = _.debounce((soldTo: string, shipTo: string) => {
    setModalFilters(filter => ({
      divisionId: filter.divisionId,
      soldTo: soldTo,
      shipTo: shipTo,
    }));
  }, 50);

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;

    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const regionData = GridUtils.getRow(grid, ht.row);
    if (!regionData) return;

    setSelectedValue(
      regionData.SOLDTO_CODE,
      regionData.SOLDTO_DESCRIPTION,
      regionData.SHIPTO_CODE,
      regionData.SHIPTO_DESCRIPTION,
      regionData.SHIPTO_REGION_NAME,
      regionData.SHIPTO_CITY_NAME
    );

    modalClose();
  };

  useEffect(() => {
    if (!open) return;
    setModalFilters({
      divisionId: divisionId,
      soldTo: soldTo,
      shipTo: shipTo,
    });
    if (!initialized) void fetchStaticColumns();
  }, [open]);

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
          <h2 className='headerTitle'>{t('LBL00337', '_Customer by Division')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            conditions={
              <>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00001', '_Division')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        disabled
                        value={
                          divisions?.find(item => item.CODE === modalFilters.divisionId)?.NAME ?? ''
                        }
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00081', '_Sold-To')}
                    labelAlign='right'
                    labelSize='long'
                    render={() => (
                      <InputField
                        fullWidth
                        value={modalFilters.soldTo}
                        onChange={e => handleFilterChange(e.target.value, modalFilters.shipTo)}
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00320', '_Ship-To')}
                    labelAlign='right'
                    labelSize='long'
                    render={() => (
                      <InputField
                        fullWidth
                        value={modalFilters.shipTo}
                        onChange={e => handleFilterChange(modalFilters.soldTo, e.target.value)}
                      />
                    )}
                  />
                </Grid>
              </>
            }
          />
          <div className={styles.gridWrapper}>
            <DataGrid<ResponseData<MODAL_CUSTOMER, MODAL_SHEET_CUSTOMER, 'o_rc1'>>
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
