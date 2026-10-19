import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { attachRowNoHeader, GridUtils } from '@foundation/utils';
import { CustomDialog, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { MENU_ID, SHEETS } from '../../plant-site.constants';

import styles from './PlantSiteModal.module.scss';
import { useVendorModalStore } from './vendorModalStore';

// Vendor 검색 팝업(화면 전용 시트 SCP0001.vendor) — PLANT_NAME(신규행 R-17)·HQ Vendor(R-18) 셀이 연다.
interface VendorModalProps {
  open: boolean;
  modalClose: () => void;
  setSelectedValue: (companyId: string, vendorCode: string, vendorName: string) => void;
  vendorCode?: string;
  vendorName?: string;
}

export const VendorModal = ({
  open,
  modalClose,
  setSelectedValue,
  vendorCode = '',
  vendorName = '',
}: VendorModalProps) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.VENDOR, 'o_rc1'>> | undefined>();
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

  const initialized = useVendorModalStore(state => state.initialized);
  const staticColumns = useVendorModalStore(state => state.staticColumns);
  const fetchStaticColumns = useVendorModalStore(state => state.fetchStaticColumns);

  const [searchParam, setSearchParam] = useState<ProcRequest<MENU_ID, SHEETS.VENDOR>>({
    vendorCode: '',
    vendorName: '',
    paker: null,
  });
  const [codeInput, setCodeInput] = useState<string>(vendorCode);
  const [nameInput, setNameInput] = useState<string>(vendorName);

  const {
    data: vendorData,
    isLoading,
    isFetching,
  } = useTabProcQuery<MENU_ID, SHEETS.VENDOR>({
    menuId: MENU_ID,
    sheetName: SHEETS.VENDOR,
    tabId: `${MENU_ID}_vendor`,
    filters: searchParam,
    enabled: open,
  });
  const loading = isLoading || isFetching;

  const itemsSource = useMemo(() => vendorData?.o_rc1 ?? [], [vendorData]);

  const handleSearch = () => {
    setSearchParam({ vendorCode: codeInput, vendorName: nameInput, paker: null });
  };

  const pick = (row: ResponseData<MENU_ID, SHEETS.VENDOR, 'o_rc1'>) => {
    setSelectedValue(row.COMPANY_ID, row.VENDOR_CODE, row.VENDOR_NAME);
    modalClose();
  };

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    const row = GridUtils.getRow(grid, ht.row);
    if (!row) return;
    pick(row);
  };

  const handleSubmit = () => {
    const selections = GridUtils.getSelectedRows(gridRef.current);
    if (!selections) return;
    pick(selections[0]);
  };

  useEffect(() => {
    if (!open) return;
    setSearchParam({ vendorCode, vendorName, paker: null });
    setCodeInput(vendorCode);
    setNameInput(vendorName);
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  useEffect(() => {
    if (gridRef.current) attachRowNoHeader(gridRef.current, t('LBL00674', 'No'));
  }, [gridRef, t, itemsSource]);

  return (
    <CustomDialog
      size={1200}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00004', '_Plant/Vendor')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t('LBL00664', 'Search')}
            onSearch={handleSearch}
            conditions={
              <>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00004', '_Plant/Vendor')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={codeInput}
                        onChange={e => setCodeInput(e.target.value)}
                        onKeyDown={e => e.key === 'Enter' && handleSearch()}
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00509', '_Name')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={nameInput}
                        onChange={e => setNameInput(e.target.value)}
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
            <ResultArea title='' count={itemsSource.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
              <DataGrid<ResponseData<MENU_ID, SHEETS.VENDOR, 'o_rc1'>>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                isReadOnly
                staticColumns={staticColumns}
                itemsSource={itemsSource}
                dblClick={handleDblClick}
              />
            </ResultArea>
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
