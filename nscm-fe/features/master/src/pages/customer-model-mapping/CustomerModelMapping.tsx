import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery, useProcMutation, useSaveWithValidation } from '@shared/hooks';

import { CustomerModelMappingForm } from './components/CustomerModelMappingForm';
import { CustomerModelMappingGrid } from './components/CustomerModelMappingGrid';
import { MENU_ID, SHEETS } from './customer-model-mapping.constants';
import { useCustomerModelMappingStore } from './useCustomerModelMappingStore';

export const CustomerModelMapping = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS>>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const isOpenSearchArea = useCustomerModelMappingStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useCustomerModelMappingStore(state => state.setOpenSearchArea);
  const filters = useCustomerModelMappingStore(state => state.filters);
  const setFilters = useCustomerModelMappingStore(state => state.setFilters);
  const initialized = useCustomerModelMappingStore(state => state.initialized);
  const fetchStaticColumns = useCustomerModelMappingStore(state => state.fetchStaticColumns);
  const staticColumn = useCustomerModelMappingStore(state => state.staticColumn);
  const searchParams = useCustomerModelMappingStore(state => state.searchParams);

  const { saveWithValidation } = useSaveWithValidation();

  const { data } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.CUSTOMER_MODEL_MAPPING,
    tabId,
    filters,
    enabled: !!filters,
  });

  const { mutate } = useProcMutation<MENU_ID, SHEETS.CUSTOMER_MODEL_MAPPING>({
    menuId: MENU_ID,
    sheetName: SHEETS.CUSTOMER_MODEL_MAPPING,
    tabId,
  });

  const handleInsert = () => {
    if (!gridRef.current) return;

    GridAction.addRow(gridRef.current, {
      DIVISION_ID: filters?.divisionId ?? '81',
    });
  };

  const handleDelete = () => {
    if (!gridRef.current) return;
    GridAction.removeRow(gridRef.current, true);
  };

  const handleSave = () => {
    const saveData = data?.o_rc1.filter(row => row.CRUD_TYPE);
    saveWithValidation(saveData, staticColumn, mutate);
  };

  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
  }, [tabId]);

  const hotkeyConfig: HotkeyConfig = {
    insert: handleInsert,
    delete: handleDelete,
    search: setFilters,
    save: handleSave,
    manual: false,
    upload: false,
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <CustomerModelMappingForm />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={data?.o_rc1.length ?? 0}
        excelFileName='Customer-Model-Mapping'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <CustomerModelMappingGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        data={data?.o_rc1 ?? []}
      />
    </>
  );
};
