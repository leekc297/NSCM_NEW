import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useRef, useState } from 'react';

import _ from '@foundation/lodash';
import { GridUtils } from '@foundation/utils';
import { SearchArea, DataGrid, CustomDialog } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { MODAL_REGION, MODAL_SHEET_REGION } from './region-modal.constants';
import styles from './RegionModal.module.scss';
import { useRegionModalStore } from './regionModalStore';

interface RegionModalProps {
  open: boolean;
  modalClose: () => void;
  setSelectedValue: (
    countryCode: string,
    countryName: string,
    cityCode: string,
    cityName: string
  ) => void;
  country?: string;
  city?: string;
}

const EMPTY_FILTER = { country: '', city: '' };

export const RegionModal = ({
  open,
  modalClose,
  setSelectedValue,
  country = '',
  city = '',
}: RegionModalProps) => {
  const { t } = useTranslation();

  const gridRef = useRef<
    FlexGrid<ResponseData<MODAL_REGION, MODAL_SHEET_REGION, 'o_rc1'>> | undefined
  >();

  const initialized = useRegionModalStore(state => state.initialized);
  const staticColumns = useRegionModalStore(state => state.staticColumns);
  const fetchStaticColumns = useRegionModalStore(state => state.fetchStaticColumns);

  const [modalFilters, setModalFilters] = useState<{
    country: string;
    city: string;
  }>(EMPTY_FILTER);

  const { data: regionData } = useTabProcQuery<MODAL_REGION>({
    menuId: MODAL_REGION,
    sheetName: MODAL_SHEET_REGION,
    tabId: MODAL_REGION,
    filters: EMPTY_FILTER,
    enabled: true,
  });

  const countryKeyword = modalFilters.country.toLowerCase();
  const cityKeyword = modalFilters.city.toLowerCase();

  // Country/City 입력은 코드와 명칭 중 하나만 맞아도 통과
  const itemsSource = (regionData?.o_rc1 ?? []).filter(
    region =>
      ((region.COUNTRY ?? '').toLowerCase().includes(countryKeyword) ||
        (region.COUNTRY_NAME ?? '').toLowerCase().includes(countryKeyword)) &&
      ((region.CITY ?? '').toLowerCase().includes(cityKeyword) ||
        (region.CITY_NAME ?? '').toLowerCase().includes(cityKeyword))
  );

  const handleFilterChange = _.debounce((country: string, city: string) => {
    setModalFilters({
      country: country,
      city: city,
    });
  }, 50);

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;

    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const regionData = GridUtils.getRow(grid, ht.row);
    if (!regionData) return;

    setSelectedValue(
      regionData.COUNTRY,
      regionData.COUNTRY_NAME,
      regionData.CITY,
      regionData.CITY_NAME
    );

    modalClose();
  };

  const handleSubmit = () => {
    const selections = GridUtils.getSelectedRows(gridRef.current);

    if (!selections) return;

    setSelectedValue(
      selections[0].COUNTRY,
      selections[0].COUNTRY_NAME,
      selections[0].CITY,
      selections[0].CITY_NAME
    );
    modalClose();
  };

  useEffect(() => {
    if (!open) return;
    setModalFilters({
      country: country,
      city: city,
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
          <h2 className='headerTitle'>{t('LBL00332', '_City by Country')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            conditions={
              <>
                <Grid size={6}>
                  <FormItem
                    label={t('LBL00317', '_Country')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={modalFilters.country}
                        onChange={e => handleFilterChange(e.target.value, modalFilters.city)}
                      />
                    )}
                  />
                </Grid>
                <Grid size={6}>
                  <FormItem
                    label={t('LBL00318', '_City')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={modalFilters.city}
                        onChange={e => handleFilterChange(modalFilters.country, e.target.value)}
                      />
                    )}
                  />
                </Grid>
              </>
            }
          />
          <div className={styles.gridWrapper}>
            <DataGrid<ResponseData<MODAL_REGION, MODAL_SHEET_REGION, 'o_rc1'>>
              gridRef={gridRef}
              isReadOnly
              staticColumns={staticColumns}
              itemsSource={itemsSource}
              dblClick={handleDblClick}
            />
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Close'
              onClick={modalClose}
            />
            <Button
              appearance='contained'
              buttonLabel='OK'
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              priority='primary'
              size='medium'
              onClick={handleSubmit}
            />
          </div>
        </div>
      }
    />
  );
};
