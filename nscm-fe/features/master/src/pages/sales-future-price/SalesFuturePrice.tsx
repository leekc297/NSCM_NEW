import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import { i18n } from '@foundation/i18n';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { ExchangeRateModal } from './components/modals/ExchangeRateModal';
import { PriceBatchInputModal } from './components/modals/PriceBatchInputModal';
import { SalesPriceRangeModal } from './components/modals/SalesPriceRangeModal';
import { SalesPriceTemplateModal } from './components/modals/SalesPriceTemplateModal';
import { SalesFuturePriceForm } from './components/SalesFuturePriceForm';
import { SalesFuturePriceGrid } from './components/SalesFuturePriceGrid';
import { useSalesFuturePriceValidation } from './hooks/useSalesFuturePriceValidation';
import { MENU_ID } from './sales-future-price.constants';
import { useSalesFuturePriceStore } from './useSalesFuturePriceStore';

type DataRow = WijmoRowItem;

export const SalesFuturePrice = ({ tabId, title }: PageProps<MenuId>) => {
  const { t } = useTranslation();
  const { setAlert } = useMessageStore();
  const { saveWithValidation } = useSaveWithValidation();

  const gridRef = useRef<FlexGrid<DataRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const filters = useSalesFuturePriceStore(state => state.filters);
  const setFilters = useSalesFuturePriceStore(state => state.setFilters);
  const searchParams = useSalesFuturePriceStore(state => state.searchParams);
  const staticColumn = useSalesFuturePriceStore(state => state.staticColumns);
  const fetchStaticColumns = useSalesFuturePriceStore(state => state.fetchStaticColumns);
  const fetchDynamicColumns = useSalesFuturePriceStore(state => state.fetchDynamicColumns);
  const isOpenSearchArea = useSalesFuturePriceStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useSalesFuturePriceStore(state => state.setOpenSearchArea);

  const modals = useSalesFuturePriceStore(state => state.modals);
  const setOpenExchangeRate = useSalesFuturePriceStore(state => state.setOpenExchangeRate);
  const setOpenSalesPriceRange = useSalesFuturePriceStore(state => state.setOpenSalesPriceRange);
  const setOpenPriceBatchInput = useSalesFuturePriceStore(state => state.setOpenPriceBatchInput);
  const setOpenSalesPriceTemplate = useSalesFuturePriceStore(
    state => state.setOpenSalesPriceTemplate
  );

  const {
    confirmSaveData,
    validateFindWorkInProgress,
    validateVersionSelected,
    validatePeriodOrder,
    validateDivisionSelected,
    showSaveError,
    guardEnterEditMode,
  } = useSalesFuturePriceValidation();

  const { data, refetch } = useTabProcQuery({
    menuId: MENU_ID as MenuId,
    sheetName: 'main' as never,
    tabId,
    filters: (filters ?? {}) as never,
    enabled: filters !== undefined,
  });

  const { mutate } = useProcMutation({
    menuId: MENU_ID as MenuId,
    sheetName: 'main' as never,
    tabId,
    onSuccess: () => void refetch(),
  });

  useEffect(() => {
    void fetchStaticColumns();
  }, [tabId, fetchStaticColumns]);

  useEffect(() => {
    if (filters) void fetchDynamicColumns();
  }, [filters, fetchDynamicColumns]);

  const onSearch = () => {
    if (!validateFindWorkInProgress()) return;
    if (!validateVersionSelected(searchParams.versionId)) return;
    if (!validateDivisionSelected(searchParams.divisionId)) return;
    if (!validatePeriodOrder(searchParams.periodFrom, searchParams.periodTo)) return;
    setFilters();
  };

  const onSave = () => {
    const rows = (data as { o_rc?: DataRow[] } | undefined)?.o_rc ?? [];
    const saveData = rows.filter(item => item.CRUD_TYPE);
    if (saveData.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00018', '_변경된 사항이 없습니다.') });
      return;
    }
    confirmSaveData(() => {
      saveWithValidation(saveData as never, staticColumn, mutate as never);
    });
  };
  void showSaveError;

  const onInsert = () => {
    if (!gridRef.current) return;
    if (!guardEnterEditMode()) return;
    GridAction.addRow(gridRef.current, {
      LANG_CD: i18n.language.toUpperCase(),
      DIVISION_ID: searchParams.divisionId,
      AUTHORITY_YN: 'Y',
      FCST_TYPE: '',
      INCOTERMS: '',
      DOM_EXP: '',
      CURRENCY: '',
      MEASURE: '',
    });
  };

  const onExcelUpload = () => {
    void setAlert({ type: 'alert', content: t('MSG00265', '_Excel 업로드 안내') });
  };

  const onBatchClick = () => {
    void setAlert({ type: 'alert', content: t('MSG00143', '_배치 실행 안내') });
  };

  const hotkeyConfig: HotkeyConfig = {
    save: onSave,
    insert: onInsert,
    search: onSearch,
    manual: false,
    upload: onExcelUpload,
  };

  const rows = (data as { o_rc?: DataRow[] } | undefined)?.o_rc ?? [];

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <SalesFuturePriceForm
        onOpenExchangeRate={() => setOpenExchangeRate(true)}
        onOpenSalesPriceRange={() => setOpenSalesPriceRange(true)}
        onOpenPriceBatchInput={() => setOpenPriceBatchInput(true)}
        onOpenSalesPriceTemplate={() => setOpenSalesPriceTemplate(true)}
        onBatchClick={onBatchClick}
      />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef as never}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='SalesFuturePrice'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <SalesFuturePriceGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        data={rows}
      />
      <ExchangeRateModal
        open={modals.openExchangeRate}
        modalClose={() => setOpenExchangeRate(false)}
        defaultDivision={searchParams.divisionId}
      />
      <SalesPriceRangeModal
        open={modals.openSalesPriceRange}
        modalClose={() => setOpenSalesPriceRange(false)}
      />
      <PriceBatchInputModal
        open={modals.openPriceBatchInput}
        modalClose={() => setOpenPriceBatchInput(false)}
        baseFilter={searchParams}
      />
      <SalesPriceTemplateModal
        open={modals.openSalesPriceTemplate}
        modalClose={() => setOpenSalesPriceTemplate(false)}
      />
    </>
  );
};
