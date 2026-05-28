import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import { BUTTON_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';

import { MenuButtonnManagementForm } from './components/MenuButtonManagementForm';
import { MenuButtonManagementTable } from './components/MenuButtonManagementTable';
import { MENU_ID, SHEETS } from './menu-button-management.constants';
import { useMenuButtonManagementStore } from './useMenuButtonManagementStore';

export const MenuButtonManagement = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.LIST>>>();

  const gridFilterRef = useRef<FlexGridFilter>();
  const initialized = useMenuButtonManagementStore(state => state.initialized);
  const filters = useMenuButtonManagementStore(state => state.filters);
  const setFilters = useMenuButtonManagementStore(state => state.setFilters);
  const staticColumns = useMenuButtonManagementStore(state => state.staticColumns);
  const fetchStaticColumns = useMenuButtonManagementStore(state => state.fetchStaticColumns);
  const isOpenSearchArea = useMenuButtonManagementStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useMenuButtonManagementStore(state => state.setOpenSearchArea);
  const searchParams = useMenuButtonManagementStore(state => state.searchParams);

  const { saveWithValidation } = useSaveWithValidation();

  const { data } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.LIST,
    tabId,
    filters,
    enabled: filters !== undefined,
  });

  const { mutate } = useProcMutation<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.LIST,
    procedureAction: BUTTON_TYPE.SAVE,
    tabId,
  });

  const onSave = () => {
    const saveData = data?.o_rc?.filter(item => item.CRUD_TYPE) ?? [];
    saveWithValidation(saveData, staticColumns, mutate);
  };

  const handleInsert = () => {
    if (!gridRef.current) return;

    GridAction.addRow(gridRef.current, {
      USE_YN: 'Y',
    });
  };

  const handleDelete = () => {
    if (!gridRef.current) return;
    GridAction.removeRow(gridRef.current, true);
  };

  const hotkeyConfig: HotkeyConfig = {
    insert: handleInsert,
    delete: handleDelete,
    save: onSave,
    search: setFilters,
    manual: false,
    upload: false,
  };

  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
  }, [tabId]);

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <MenuButtonnManagementForm />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={data?.o_rc.length ?? 0}
        excelFileName='Menu Button'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <MenuButtonManagementTable
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        data={data?.o_rc ?? []}
      />
    </>
  );
};
