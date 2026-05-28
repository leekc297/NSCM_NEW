import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';

import { GroupManagementGrid } from './components/GroupManagementGrid';
import { MENU_ID, SHEETS } from './group-management.constants';
import { useGroupManagementStore } from './useGroupManagementStore';

export const GroupManagement = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const initialized = useGroupManagementStore(state => state.initialized);
  const filters = useGroupManagementStore(state => state.filters);
  const setFilters = useGroupManagementStore(state => state.setFilters);
  const staticColumns = useGroupManagementStore(state => state.staticColumns);
  const fetchStaticColumns = useGroupManagementStore(state => state.fetchStaticColumns);
  const isOpenSearchArea = useGroupManagementStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useGroupManagementStore(state => state.setOpenSearchArea);

  const { saveWithValidation } = useSaveWithValidation();

  const { data } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.GROUP_MGMT,
    tabId,
    filters,
    enabled: filters !== undefined,
  });

  const { mutate } = useProcMutation<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.GROUP_MGMT,
    tabId,
  });

  const onSave = () => {
    const saveData = data?.o_rc?.filter(item => item.CRUD_TYPE);
    saveWithValidation(saveData, staticColumns, mutate);
  };

  const onInsert = () => {
    if (!gridRef.current) return;
    GridAction.addRow(gridRef.current, {
      USE_YN: 'Y',
    });
  };

  const onDelete = () => {
    if (!gridRef.current) return;
    GridAction.removeRow(gridRef.current, true);
  };

  const hotkeyConfig: HotkeyConfig = {
    save: onSave,
    insert: onInsert,
    delete: onDelete,
    search: () => setFilters({ group: '', useYn: 'ALL' }),
    manual: false,
    condition: false,
    resetCondition: false,
    upload: false,
  };

  useEffect(() => {
    if (initialized) return;

    void fetchStaticColumns();
    setFilters({ group: '', useYn: 'ALL' });
  }, [tabId]);

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
        disableSearchArea
      />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={data?.o_rc.length ?? 0}
        excelFileName='Group'
        hotkeyConfig={hotkeyConfig}
      />
      <GroupManagementGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        data={data?.o_rc ?? []}
      />
    </>
  );
};
