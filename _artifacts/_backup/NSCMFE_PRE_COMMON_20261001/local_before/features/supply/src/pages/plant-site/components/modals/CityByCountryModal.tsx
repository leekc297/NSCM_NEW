import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { attachRowNoHeader, GridUtils } from '@foundation/utils';
import { CustomDialog, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { useCityByCountryModalStore } from './cityByCountryModalStore';
import styles from './PlantSiteModal.module.scss';

// City by Country 공용 팝업(COM0001) — SCP0001 COUNTRY/CITY 셀(R-20)에서 연다.
const MODAL_MENU = 'COM0001' as const;
const MODAL_SHEET = 'region' as const;

interface CityByCountryModalProps {
  open: boolean;
  modalClose: () => void;
  setSelectedValue: (country: string, city: string) => void;
  country?: string;
  city?: string;
}

export const CityByCountryModal = ({
  open,
  modalClose,
  setSelectedValue,
  country = '',
  city = '',
}: CityByCountryModalProps) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<ResponseData<typeof MODAL_MENU, typeof MODAL_SHEET, 'o_rc1'>> | undefined>();
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

  const initialized = useCityByCountryModalStore(state => state.initialized);
  const staticColumns = useCityByCountryModalStore(state => state.staticColumns);
  const fetchStaticColumns = useCityByCountryModalStore(state => state.fetchStaticColumns);

  const [searchParam, setSearchParam] = useState<{ country: string; city: string }>({
    country: '',
    city: '',
  });
  const [countryInput, setCountryInput] = useState<string>(country);
  const [cityInput, setCityInput] = useState<string>(city);

  const {
    data: regionData,
    isLoading,
    isFetching,
  } = useTabProcQuery<typeof MODAL_MENU>({
    menuId: MODAL_MENU,
    sheetName: MODAL_SHEET,
    tabId: MODAL_MENU,
    filters: searchParam,
    enabled: open,
  });
  const loading = isLoading || isFetching;

  const itemsSource = useMemo(() => regionData?.o_rc1 ?? [], [regionData]);

  const handleSearch = () => {
    setSearchParam({ country: countryInput, city: cityInput });
  };

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    const row = GridUtils.getRow(grid, ht.row);
    if (!row) return;
    setSelectedValue(row.COUNTRY, row.CITY);
    modalClose();
  };

  const handleSubmit = () => {
    const selections = GridUtils.getSelectedRows(gridRef.current);
    if (!selections) return;
    setSelectedValue(selections[0].COUNTRY, selections[0].CITY);
    modalClose();
  };

  useEffect(() => {
    if (!open) return;
    setSearchParam({ country, city });
    setCountryInput(country);
    setCityInput(city);
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  useEffect(() => {
    if (gridRef.current) attachRowNoHeader(gridRef.current, t('LBL00674', 'No'));
  }, [gridRef, t, itemsSource]);

  return (
    <CustomDialog
      size={1000}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00332', '_City by Country')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t('LBL00664', 'Search')}
            onSearch={handleSearch}
            conditions={
              <>
                <Grid size={3}>
                  <FormItem
                    label={t('LBL00317', '_Country')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={countryInput}
                        onChange={e => setCountryInput(e.target.value)}
                        onKeyDown={e => e.key === 'Enter' && handleSearch()}
                      />
                    )}
                  />
                </Grid>
                <Grid size={3}>
                  <FormItem
                    label={t('LBL00318', '_City')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={cityInput}
                        onChange={e => setCityInput(e.target.value)}
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
              <DataGrid<ResponseData<typeof MODAL_MENU, typeof MODAL_SHEET, 'o_rc1'>>
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
