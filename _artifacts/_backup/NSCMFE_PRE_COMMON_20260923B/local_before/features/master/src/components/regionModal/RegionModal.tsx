import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { attachRowNoHeader, GridUtils } from '@foundation/utils';
import { SearchArea, DataGrid, CustomDialog, ResultArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
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
  // ResultArea 가 F4/헤더 필터 적용 후 실제 표시 건수를 "총 N건"에 반영하려면 이 ref 가 필요하다.
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

  const initialized = useRegionModalStore(state => state.initialized);
  const staticColumns = useRegionModalStore(state => state.staticColumns);
  const fetchStaticColumns = useRegionModalStore(state => state.fetchStaticColumns);

  // 실제 조회 조건 — Search 버튼/Enter(그리고 팝업 오픈) 시에만 갱신되고, 그때 프로시저를 재호출한다.
  //   (useTabProcQuery 는 filters 가 query key 라 값이 바뀌면 재조회. COM0001 은 country/city 를
  //   IN 파라미터로 받는다 — configs/types/procedures.d.ts COM0001.region.request 참고)
  const [searchParam, setSearchParam] = useState<{
    country: string;
    city: string;
  }>(EMPTY_FILTER);

  // 입력 중인 값 — 조회하지 않고 로컬 state 에만 담아둔다.
  const [countryInput, setCountryInput] = useState<string>(country);
  const [cityInput, setCityInput] = useState<string>(city);

  const {
    data: regionData,
    isLoading,
    isFetching,
  } = useTabProcQuery<MODAL_REGION>({
    menuId: MODAL_REGION,
    sheetName: MODAL_SHEET_REGION,
    tabId: MODAL_REGION,
    filters: searchParam,
    enabled: true,
  });
  const loading = isLoading || isFetching;

  // 필터링은 프로시저(country/city 파라미터)가 하고, 그리드는 조회 결과를 그대로 보여준다.
  //   useMemo — 매 렌더 새 배열이면 그리드가 re-bind 되어 스크롤·선택이 초기화된다.
  const itemsSource = useMemo(() => regionData?.o_rc1 ?? [], [regionData]);

  const handleSearch = () => {
    setSearchParam({
      country: countryInput,
      city: cityInput,
    });
  };

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
    setSearchParam({
      country: country,
      city: city,
    });
    setCountryInput(country);
    setCityInput(city);
    if (!initialized) void fetchStaticColumns();
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
      // 컬럼 필터 팝업(FlexGridFilter)이 MuiDialog-container 밖에 append 돼 MUI FocusTrap 과
      // 충돌한다 — 필터 팝업의 Search 입력이 클릭/타이핑해도 반응 없어 보이는 원인. CustomDialog.tsx
      // 상단 주석(DMF0082 ExchangeRateModal) 과 동일 원인.
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
                <Grid size={6}>
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
                <Grid size={6}>
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
            <ResultArea
              title=''
              count={itemsSource.length}
              gridRef={gridRef}
              gridFilterRef={gridFilterRef}
            >
              <DataGrid<ResponseData<MODAL_REGION, MODAL_SHEET_REGION, 'o_rc1'>>
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
