import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { attachRowNoHeader, GridUtils } from '@foundation/utils';
import { DataGrid, CustomDialog, ResultArea, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
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
  // ResultArea 가 F4/헤더 필터 적용 후 실제 표시 건수를 "총 N건"에 반영하려면 이 ref 가 필요하다.
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

  const initialized = useCustomerModalStore(state => state.initialized);
  const staticColumns = useCustomerModalStore(state => state.staticColumns);
  const fetchStaticColumns = useCustomerModalStore(state => state.fetchStaticColumns);

  const [divisions] = useTabComboQueries({
    filters: ['MyDivision'],
  });

  // 실제 조회 조건 — Search 버튼/Enter(그리고 팝업 오픈) 시에만 갱신되고, 그때 프로시저를 재호출한다.
  //   (useTabProcQuery 는 filters 가 query key 라 값이 바뀌면 재조회)
  const [searchParam, setSearchParam] = useState<{
    divisionId: string;
    soldTo: string;
    shipTo: string;
  }>({ divisionId: divisionId, soldTo: '', shipTo: '' });

  // 입력 중인 값 — 조회하지 않고 로컬 state 에만 담아둔다.
  const [soldToInput, setSoldToInput] = useState<string>('');
  const [shipToInput, setShipToInput] = useState<string>('');

  const {
    data: customerData,
    isLoading,
    isFetching,
  } = useTabProcQuery<MODAL_CUSTOMER>({
    menuId: MODAL_CUSTOMER,
    sheetName: MODAL_SHEET_CUSTOMER,
    tabId: MODAL_CUSTOMER,
    filters: searchParam,
    enabled: open,
  });
  const loading = isLoading || isFetching;

  // 필터링은 프로시저(soldTo/shipTo 파라미터)가 하고, 그리드는 조회 결과를 그대로 보여준다.
  //   useMemo — 매 렌더 새 배열이면 그리드가 re-bind 되어 스크롤·선택이 초기화된다.
  const itemsSource = useMemo(() => customerData?.o_rc1 ?? [], [customerData]);

  const handleSearch = () => {
    setSearchParam(param => ({
      divisionId: param.divisionId,
      soldTo: soldToInput,
      shipTo: shipToInput,
    }));
  };

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

  const handleSubmit = () => {
    const selections = gridRef.current?.selectedItems as ResponseData<
      MODAL_CUSTOMER,
      MODAL_SHEET_CUSTOMER,
      'o_rc1'
    >[];
    if (!selections?.length) return;

    setSelectedValue(
      selections[0].SOLDTO_CODE,
      selections[0].SOLDTO_DESCRIPTION,
      selections[0].SHIPTO_CODE,
      selections[0].SHIPTO_DESCRIPTION,
      selections[0].SHIPTO_REGION_NAME,
      selections[0].SHIPTO_CITY_NAME
    );
    modalClose();
  };

  useEffect(() => {
    if (!open) return;
    setSearchParam({
      divisionId: divisionId,
      soldTo: soldTo,
      shipTo: shipTo,
    });
    setSoldToInput(soldTo);
    setShipToInput(shipTo);
    if (!initialized) void fetchStaticColumns();
  }, [open]);

  useEffect(() => {
    if (gridRef.current) attachRowNoHeader(gridRef.current, t('LBL00674', 'No'));
  }, [gridRef, t, itemsSource]);

  return (
    <CustomDialog
      size={1400}
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
          <h2 className='headerTitle'>{t('LBL00337', '_Customer by Division')}</h2>
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
                    label={t('LBL00001', '_Division')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        disabled
                        value={
                          divisions?.find(item => item.CODE === searchParam.divisionId)?.NAME ?? ''
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
                        value={soldToInput}
                        onChange={e => setSoldToInput(e.target.value)}
                        onKeyDown={e => e.key === 'Enter' && handleSearch()}
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
                        value={shipToInput}
                        onChange={e => setShipToInput(e.target.value)}
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
              <DataGrid<ResponseData<MODAL_CUSTOMER, MODAL_SHEET_CUSTOMER, 'o_rc1'>>
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
