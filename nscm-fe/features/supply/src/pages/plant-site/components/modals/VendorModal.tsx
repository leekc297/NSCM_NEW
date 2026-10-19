import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { attachRowNoHeader, GridUtils } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { LBL, MENU_ID, SHEETS } from '../../plant-site.constants';
import { COMBO } from '../../utils/plant-site.plantSiteCombo';
import { comboAllToNull, str, toComboOptions } from '../../utils/plant-site.util';

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
  // Packer 조회조건(AS-IS cboPaker, Yes-or-No 콤보) — 호출부 prop 없이 항상 ALL 로 시작(SelectedIndex=0 재현).
  const [pakerInput, setPakerInput] = useState<string>('ALL');
  // AS-IS SCM0002_VendorPopup 은 인자 없이 열려 빈 그리드로 뜨고 Search 를 눌러야 조회된다
  //   (SCP0001_PlantSite.cs:1602·1623 new SCM0002_VendorPopup()). 팝업 오픈만으로 자동조회하지 않도록
  //   첫 Search 전까지 조회·표시를 막는다(사용자 보고 2026-10-06).
  const [hasSearched, setHasSearched] = useState<boolean>(false);

  const [yesOrNo] = useTabComboQueries({ filters: [COMBO.YES_OR_NO] });
  const yesNoOptions = toComboOptions(yesOrNo);

  const {
    data: vendorData,
    isLoading,
    isFetching,
  } = useTabProcQuery<MENU_ID, SHEETS.VENDOR>({
    menuId: MENU_ID,
    sheetName: SHEETS.VENDOR,
    tabId: `${MENU_ID}_vendor`,
    filters: searchParam,
    enabled: open && hasSearched,
  });
  const loading = isLoading || isFetching;

  // 첫 Search 전에는 캐시가 있어도 빈 그리드로 둔다(오픈 자동조회 방지, enabled 와 2중 가드).
  const itemsSource = useMemo(
    () => (hasSearched ? vendorData?.o_rc1 ?? [] : []),
    [vendorData, hasSearched]
  );

  const handleSearch = () => {
    setHasSearched(true);
    setSearchParam({ vendorCode: codeInput, vendorName: nameInput, paker: comboAllToNull(pakerInput) });
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
    setHasSearched(false); // 재오픈마다 자동조회 금지 상태로 초기화
    setSearchParam({ vendorCode, vendorName, paker: null });
    setCodeInput(vendorCode);
    setNameInput(vendorName);
    setPakerInput('ALL');
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

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
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t(LBL.PLANT_VENDOR, '_Plant/Vendor')}</h2>
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
                    label={t(LBL.VENDOR_CODE, '_Vendor Code')}
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
                    label={t(LBL.VENDOR_NAME, '_Vendor Name')}
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
                <Grid size={4}>
                  <FormItem
                    label='Packer'
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        isInput={false}
                        allOption
                        limitTags={1}
                        value={pakerInput}
                        options={yesNoOptions}
                        onChange={(_, option) => setPakerInput(str(option) || 'ALL')}
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
