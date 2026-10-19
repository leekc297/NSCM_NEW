import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { attachRowNoHeader, GridUtils } from '@foundation/utils';
import { CustomDialog, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { LBL } from '../../plant-site.constants';

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

  const pick = (row: ResponseData<typeof MODAL_MENU, typeof MODAL_SHEET, 'o_rc1'>) => {
    setSelectedValue(row.COUNTRY, row.CITY);
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
    setSearchParam({ country, city });
    setCountryInput(country);
    setCityInput(city);
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  // 단일 매치 자동선택+자동닫힘은 두지 않는다 — 형제 화면 SCP0005(RegionModal)와 동일 동작.
  //   값이 있는 셀을 더블클릭하면 그 값으로 미리 조회돼 결과가 1건뿐이라, 자동선택을 걸면 팝업이
  //   열리자마자 닫혀 재선택이 불가능하다(사용자 보고 2026-10-06, "입력된 컬럼만 바로 닫힘").
  //   AS-IS SCM0002 FindData 의 단일매치 자동선택은 팝업 오픈이 아니라 사용자 Search 시의 동작이라,
  //   오픈 프리필에까지 적용하던 이전 구현이 과했다 — 사용자가 행을 더블클릭/OK 로 직접 고른다.

  useEffect(() => {
    if (gridRef.current) attachRowNoHeader(gridRef.current, t(LBL.NO, '_No'));
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
          <h2 className='headerTitle'>{t(LBL.REGION_POPUP, '_City by Country')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t(LBL.SEARCH_POPUP, '_Search')}
            onSearch={handleSearch}
            conditions={
              <>
                <Grid size={3}>
                  <FormItem
                    label={t(LBL.COUNTRY, '_Country')}
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
                    label={t(LBL.CITY, '_City')}
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
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              priority='primary'
              size='medium'
              buttonLabel={t(LBL.OK, '_OK')}
              onClick={handleSubmit}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t(LBL.CLOSE, '_Close')}
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
