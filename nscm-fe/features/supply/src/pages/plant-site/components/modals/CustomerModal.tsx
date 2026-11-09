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

import { useCustomerModalStore } from './customerModalStore';
import styles from './PlantSiteModal.module.scss';

// Customer 공용 팝업(COM0002) — SCP0001 SOLDTO/SHIPTO 셀(R-27)에서 division 파라미터로 연다.
const MODAL_MENU = 'COM0002' as const;
const MODAL_SHEET = 'customer' as const;

interface CustomerModalProps {
  open: boolean;
  modalClose: () => void;
  setSelectedValue: (
    soldToCode: string,
    soldToDesc: string,
    shipToCode: string,
    shipToDesc: string,
    shipToRegion: string,
    shipToCity: string
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

  const gridRef = useRef<FlexGrid<ResponseData<typeof MODAL_MENU, typeof MODAL_SHEET, 'o_rc1'>> | undefined>();
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

  const initialized = useCustomerModalStore(state => state.initialized);
  const staticColumns = useCustomerModalStore(state => state.staticColumns);
  const fetchStaticColumns = useCustomerModalStore(state => state.fetchStaticColumns);

  const [searchParam, setSearchParam] = useState<{
    divisionId: string;
    soldTo: string;
    shipTo: string;
  }>({ divisionId, soldTo: '', shipTo: '' });
  const [soldToInput, setSoldToInput] = useState<string>('');
  const [shipToInput, setShipToInput] = useState<string>('');

  const {
    data: customerData,
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

  const itemsSource = useMemo(() => customerData?.o_rc1 ?? [], [customerData]);

  const handleSearch = () => {
    setSearchParam(param => ({ divisionId: param.divisionId, soldTo: soldToInput, shipTo: shipToInput }));
  };

  const pick = (row: ResponseData<typeof MODAL_MENU, typeof MODAL_SHEET, 'o_rc1'>) => {
    setSelectedValue(
      row.SOLDTO_CODE,
      row.SOLDTO_DESCRIPTION,
      row.SHIPTO_CODE,
      row.SHIPTO_DESCRIPTION,
      row.SHIPTO_REGION_NAME,
      row.SHIPTO_CITY_NAME
    );
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
    setSearchParam({ divisionId, soldTo, shipTo });
    setSoldToInput(soldTo);
    setShipToInput(shipTo);
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  // 단일매치 자동선택+자동닫힘 미이식(사용자 지시 2026-11-05) — AS-IS SCM0002_PlantCustomerby
  //   DivisionPopup.cs FindData(cs:249-259)는 결과 1건이면 즉시 Close 하나, Form_Load 가 현재 셀값
  //   (soldTo+shipTo)을 시드해 FindData 를 자동 실행하므로 값이 있는 셀을 다시 열면 바로 닫혀 수정이
  //   불가능했다(AS-IS 잠재버그). TO-BE 는 자동닫힘을 제거하고, 선택은 항상 사용자 조작(행 더블클릭/
  //   OK 버튼)으로만 확정한다.

  useEffect(() => {
    if (gridRef.current) attachRowNoHeader(gridRef.current, t(LBL.NO, '_No'));
  }, [gridRef, t, itemsSource]);

  return (
    <CustomDialog
      size={1200}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      disableScale
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t(LBL.CUSTOMER_POPUP, '_Customer by Division')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t(LBL.SEARCH_POPUP, '_Search')}
            onSearch={handleSearch}
            conditions={
              <>
                <Grid size={4}>
                  <FormItem
                    label={t(LBL.DIVISION, '_Div')}
                    labelAlign='right'
                    render={() => <InputField fullWidth disabled value={divisionId} />}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t(LBL.SOLD_TO, '_Sold-To')}
                    labelAlign='right'
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
                    label={t(LBL.SHIP_TO, '_Ship-To')}
                    labelAlign='right'
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
