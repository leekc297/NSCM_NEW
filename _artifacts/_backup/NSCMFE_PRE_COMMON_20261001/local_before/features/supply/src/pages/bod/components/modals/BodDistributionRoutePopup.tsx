import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { RegionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDialog, CustomDropdown, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon, FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { BOD_COMBO_ID } from '../../bod.constants';

import { ROUTE_POPUP_MENU_ID, ROUTE_POPUP_SHEETS } from './bod-distribution-route-popup.constants';
import styles from './BodDistributionRoutePopup.module.scss';
import { useBodDistributionRoutePopupStore } from './bodDistributionRoutePopupStore';

export type RouteRow = ResponseData<ROUTE_POPUP_MENU_ID, ROUTE_POPUP_SHEETS.ROUTE>;

interface BodDistributionRoutePopupProps {
  open: boolean;
  modalClose: () => void;
  /** 더블클릭한 BOD 그리드 행의 상위 셀 값 — cascade-combo-filter.md §5-G.1 #5. */
  preSearchParams: { fromCountry: string; fromCity: string; toCountry: string; toCity: string; transMode: string };
  onSelect: (row: RouteRow) => void;
}

/**
 * AS-IS SCP0007_DistributionRoutePopup — BOD 그리드 ROUTE_ID 셀 더블클릭 시 오픈.
 * SP(SCP.SCP0005_GET_DISTRIBUTION_ROUTE)는 SCP0005 Distribution Route(미전환)와 공용.
 *
 * 그리드 컬럼은 admin 컬럼메타(SCM_MST_SHEET_COLUMNS: PROGRAM_ID='SCP0005', SHEET_NAME='route',
 * AS-IS InitSpread 33컬럼)에서 fetchStaticColumns 로 동적 조회한다 — 하드코딩 금지(ui-category hook).
 * DAYS_MON~SUN 7개는 메타상 VISIBLE_FLAG='N'(숨김)이라 그리드엔 안 보이나 선택 행 데이터(o_rc1)에는
 * 포함되어 BOD 그리드 주입에 쓰인다.
 *
 * From/To City 국가·도시 검색: AS-IS 공통 팝업 SCM0002_CitybyCountry → TO-BE 공용 RegionModal
 * (COM0001, SCP0005 distribution-route 와 동일 컴포넌트 재사용). RegionModal 을 배선해 두되,
 * 이 화면은 BOD 행 더블클릭으로 열리는 조회전용 팝업(AS-IS isConditionReadOnly=true,
 * SCP0007_DistributionRoutePopup.cs L213-222)이라 검색조건 5개 + From/To 검색버튼을 전부 disabled
 * 로 둔다(AS-IS btnFromSrch/btnToSrch.Enabled=false 그대로). 편집 가능한 컨텍스트에서 재사용될 때
 * 버튼만 활성화하면 RegionModal 이 국가+도시를 함께 채운다.
 */
export const BodDistributionRoutePopup = ({
  open,
  modalClose,
  preSearchParams,
  onSelect,
}: BodDistributionRoutePopupProps) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid<RouteRow>>();
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

  const searchParams = useBodDistributionRoutePopupStore(state => state.searchParams);
  const setSearchParams = useBodDistributionRoutePopupStore(state => state.setSearchParams);
  const staticColumn = useBodDistributionRoutePopupStore(state => state.staticColumn);
  const fetchStaticColumns = useBodDistributionRoutePopupStore(state => state.fetchStaticColumns);

  // Trans Mode 콤보 — AS-IS cboTransMode. 팝업/검색 콤보는 TransModeCode(value=CODE 'TRK', label=NAME
  // 'TRUCK'). 조회전용 팝업이라 disabled 로 값만 표시하되, AS-IS 처럼 텍스트가 아니라 콤보로 보여준다.
  const [transModes] = useTabComboQueries({ filters: [BOD_COMBO_ID.TRANS_MODE] });

  // BOD 그리드 TRANSPORT_MODE 컬럼은 코드가 아니라 명칭('TRUCK')을 담는다(Bod.tsx: route.TRANSPORT_MODE_NAME,
  // 그리드 콤보는 별개 콤보 'TransMode'). 팝업 콤보는 value=CODE 라 넘어온 명칭을 코드로 환산해야 선택으로
  // 잡힌다. 공백은 ALL(allOption).
  const transModeValue = useMemo(() => {
    const raw = searchParams.transMode?.trim();
    if (!raw || raw === 'ALL') return 'ALL';
    return (
      transModes?.find(item => item.CODE === raw)?.CODE ??
      transModes?.find(item => item.NAME === raw)?.CODE ??
      raw
    );
  }, [searchParams.transMode, transModes]);

  // From/To 도시검색 팝업(RegionModal) 모드 — 'from'/'to' 검색버튼이 각각 국가+도시를 함께 채운다.
  const [regionMode, setRegionMode] = useState<'from' | 'to' | null>(null);

  const setRegion = (countryCode: string, _countryName: string, cityCode: string) => {
    if (regionMode === 'from') {
      setSearchParams({ fromCountry: countryCode, fromCity: cityCode });
    } else if (regionMode === 'to') {
      setSearchParams({ toCountry: countryCode, toCity: cityCode });
    }
    setRegionMode(null);
  };

  const regionCountry = regionMode === 'from' ? searchParams.fromCountry : searchParams.toCountry;
  const regionCity = regionMode === 'from' ? searchParams.fromCity : searchParams.toCity;

  useEffect(() => {
    if (!open) return;
    setSearchParams(preSearchParams);
    if (staticColumn.length === 0) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  const filters = useMemo(
    () =>
      open
        ? {
            fromCountry: searchParams.fromCountry,
            fromCity: searchParams.fromCity,
            toCountry: searchParams.toCountry,
            toCity: searchParams.toCity,
            // SP P_TRANSPORT_MODE(PKG_SCP0005 L238-239): 공백=전체, 그 외는 코드로 IN 매칭.
            // 그리드는 명칭('TRUCK')·공백을 보내므로 코드로 환산하고, ALL/공백은 '' (전체)로.
            transportMode: transModeValue === 'ALL' ? '' : transModeValue,
            validYn: 'Y', // AS-IS 고정값(SCP0007_DistributionRoutePopup.cs L442)
          }
        : undefined,
    [open, searchParams, transModeValue]
  );

  const { data, refetch, isLoading, isFetching } = useTabProcQuery<
    ROUTE_POPUP_MENU_ID,
    ROUTE_POPUP_SHEETS.ROUTE
  >({
    menuId: ROUTE_POPUP_MENU_ID,
    sheetName: ROUTE_POPUP_SHEETS.ROUTE,
    tabId: ROUTE_POPUP_MENU_ID,
    filters,
    enabled: !!filters,
  });

  // ROUTE_ID 는 Oracle NUMBER 로 와서 Wijmo 가 천단위 콤마를 붙인다(BodGrid.tsx 의 동일 처리와
  // 동일 사유 — 일련번호라 콤마가 불필요, 2026-09-23 리뷰 이슈). 문자열로 coerce 해 콤마를 없앤다.
  const rows = useMemo(
    () => (data?.o_rc1 ?? []).map(row => ({ ...row, ROUTE_ID: row.ROUTE_ID == null ? row.ROUTE_ID : String(row.ROUTE_ID) })),
    [data]
  );
  const loading = isLoading || isFetching;

  const handleSearch = () => void refetch?.();

  const handleApply = () => {
    const selected = gridRef.current?.selectedItems?.[0] as RouteRow | undefined;
    if (!selected) return;
    onSelect(selected);
    modalClose();
  };

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const onDbl = () => handleApply();
    g.hostElement?.addEventListener('dblclick', onDbl);
    return () => g.hostElement?.removeEventListener('dblclick', onDbl);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [rows]);

  return (
    <CustomDialog
      open={open}
      size={1000}
      type='modal'
      position='basic'
      handleClose={modalClose}
      disableButtonCancel
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL_DISTRIBUTION_ROUTE', '_Distribution Route')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContent}>
          <SearchArea
            searchButtonLabel={t('LBL00112', '_Search')}
            onSearch={handleSearch}
            conditions={
              <>
                {/*
                 * AS-IS(SCP0007_DistributionRoutePopup.cs L213-222): SCP0007 BOD 에서 Route Id 셀
                 * 더블클릭으로 열 때 isConditionReadOnly=true 이므로 조회조건 5개(From Country/From City/
                 * To Country/To City/Trans Mode)와 City 검색버튼(btnFromSrch/btnToSrch)이 전부 disabled.
                 * 값은 더블클릭한 BOD 행에서 pre-fill 된다. From/To City 는 AS-IS 에서 공통 팝업
                 * SCM0002_CitybyCountry(SCP0005/SCP0001/DM 다수 공유, 미전환)로 채우지만 read-only 라
                 * 여기선 트리거되지 않는다.
                 */}
                <Grid size={3}>
                  <FormItem
                    label={t('LBL00074', '_From Country')}
                    labelAlign='right'
                    render={() => <InputField fullWidth disabled value={searchParams.fromCountry} />}
                  />
                </Grid>
                <Grid size={3}>
                  <FormItem
                    label={t('LBL00070', '_From City')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        disabled
                        className={commonStyles.popupSearchField}
                        value={searchParams.fromCity}
                        InputProps={{
                          endAdornment: (
                            <Button
                              appearance='outlined'
                              priority='normal'
                              disabled
                              iconComponent={
                                <FunctionSearchIcon
                                  appearance='lined'
                                  onClick={() => setRegionMode('from')}
                                />
                              }
                            />
                          ),
                        }}
                      />
                    )}
                  />
                </Grid>
                <Grid size={3}>
                  <FormItem
                    label={t('LBL00025', '_Trans Mode')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        disabled
                        allOption
                        // 명칭→코드 환산값. 공백이면 'ALL'(allOption → SINGLE_ALL_OPTION label 'ALL').
                        value={transModeValue}
                        options={transModes?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                        onChange={(_, option) => setSearchParams({ transMode: option })}
                      />
                    )}
                  />
                </Grid>
                <Grid size={3}>
                  <FormItem
                    label={t('LBL00075', '_To Country')}
                    labelAlign='right'
                    render={() => <InputField fullWidth disabled value={searchParams.toCountry} />}
                  />
                </Grid>
                <Grid size={3}>
                  <FormItem
                    label={t('LBL00071', '_To City')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        disabled
                        className={commonStyles.popupSearchField}
                        value={searchParams.toCity}
                        InputProps={{
                          endAdornment: (
                            <Button
                              appearance='outlined'
                              priority='normal'
                              disabled
                              iconComponent={
                                <FunctionSearchIcon
                                  appearance='lined'
                                  onClick={() => setRegionMode('to')}
                                />
                              }
                            />
                          ),
                        }}
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
            <ResultArea title='' count={rows.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
              <DataGrid<RouteRow>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                itemsSource={rows}
                staticColumns={staticColumn}
                autoGenerateColumns={false}
                isReadOnly
                className={styles.grid}
              />
            </ResultArea>
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='OK'
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              disabled={loading}
              onClick={handleApply}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00627', '_Close')}
              onClick={modalClose}
            />
          </div>

          {/* From/To 도시검색 팝업 — 공용 RegionModal(AS-IS SCM0002_CitybyCountry 대응, SCP0005 동일 재사용) */}
          <RegionModal
            open={regionMode !== null}
            modalClose={() => setRegionMode(null)}
            setSelectedValue={setRegion}
            country={regionCountry}
            city={regionCity}
          />
        </div>
      }
    />
  );
};
