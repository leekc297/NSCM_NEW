import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import { i18n } from '@foundation/i18n';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';

import { UserManagementForm } from './components/UserManagementForm';
import { UserManagementGrid } from './components/UserManagementGrid';
import type { RESPONSE_SET } from './user-management.constants';
import { MENU_ID, SHEETS } from './user-management.constants';
import { useUserManagementStore } from './useUserManagementStore';

export const UserManagement = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef =
    useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.USER_MGMT, RESPONSE_SET.USER_MGMT>>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const filters = useUserManagementStore(state => state.filters);
  const setFilters = useUserManagementStore(state => state.setFilters);
  const staticColumn = useUserManagementStore(state => state.staticColumns);
  const fetchStaticColumns = useUserManagementStore(state => state.fetchStaticColumns);

  const isOpenSearchArea = useUserManagementStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useUserManagementStore(state => state.setOpenSearchArea);
  const searchParams = useUserManagementStore(state => state.searchParams);

  const { saveWithValidation } = useSaveWithValidation();

  const { data } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.USER_MGMT,
    tabId,
    filters,
    enabled: filters !== undefined,
  });

  const { mutate } = useProcMutation<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.USER_MGMT,
    tabId,
  });

  useEffect(() => {
    void fetchStaticColumns();
  }, [tabId, fetchStaticColumns]);

  const onSave = () => {
    const saveData = data?.o_rc?.filter?.(item => item.CRUD_TYPE) ?? [];
    saveWithValidation(saveData, staticColumn, mutate);
  };

  const onInsert = () => {
    if (!gridRef.current) return;
    GridAction.addRow(gridRef.current, {
      LANG_CD: i18n.language.toUpperCase(),
      TMZ_CD: 'AS054', // TO-DO : 세션에 timezone 추가되고 나면 timezone default value 세션 값으로
      ACNT_LOK_YN: 'N',
      PERM_KEP_CNC_YN: 'N',
      USE_YN: 'Y',
    });
  };

  const hotkeyConfig: HotkeyConfig = {
    save: onSave,
    insert: onInsert,
    search: setFilters,
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
      <UserManagementForm />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={data?.o_rc.length ?? 0}
        excelFileName='User'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <UserManagementGrid gridRef={gridRef} gridFilterRef={gridFilterRef} data={data?.o_rc ?? []} />
    </>
  );
};
