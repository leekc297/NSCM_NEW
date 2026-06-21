import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';

import { ProgramForm } from './components/ProgramForm';
import { ProgramMainGrid } from './components/ProgramMainGrid';
import { MENU_ID, SHEETS } from './program.constants';
import { useProgramStore } from './useProgramStore';

export const Program = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.MAIN>>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const filters = useProgramStore(state => state.filters);
  const setFilters = useProgramStore(state => state.setFilters);
  const staticColumns = useProgramStore(state => state.staticColumns);
  const fetchStaticColumns = useProgramStore(state => state.fetchStaticColumns);
  const isOpenSearchArea = useProgramStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useProgramStore(state => state.setOpenSearchArea);
  const searchParams = useProgramStore(state => state.searchParams);

  const { saveWithValidation } = useSaveWithValidation();

  const { data } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters,
    enabled: filters !== undefined,
  });

  const { mutate } = useProcMutation<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
  });

  useEffect(() => {
    void fetchStaticColumns();
  }, [tabId, fetchStaticColumns]);

  const onSave = () => {
    const saveData = data?.o_rc1?.filter?.(item => item.CRUD_TYPE) ?? [];
    saveWithValidation(saveData, staticColumns, mutate);
  };

  const onInsert = () => {
    if (!gridRef.current) return;
    GridAction.addRow(gridRef.current, { USE_YN: 'Y' });
  };

  const onDelete = () => {
    if (!gridRef.current) return;
    GridAction.removeRow(gridRef.current, false);
  };

  // ⭐ master hook §2.4 — Search 시 admin SYS0004 메타 refetch
  const handleSearch = () => {
    setFilters();
    void fetchStaticColumns();
  };
  const hotkeyConfig: HotkeyConfig = {
    search: handleSearch,
    save: onSave,
    insert: onInsert,
    delete: onDelete,
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
      <ProgramForm />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={data?.o_rc1?.length ?? 0}
        excelFileName='Program'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <ProgramMainGrid gridRef={gridRef} gridFilterRef={gridFilterRef} data={data?.o_rc1 ?? []} />
    </>
  );
};
