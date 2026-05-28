import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';

import { ProcedureInfoGrid } from './components/ProcedureInfoGrid';
import { ProcedureListGrid } from './components/ProcedureListGrid';
import { ProcedureManagementForm } from './components/ProcedureManagementForm';
import { MENU_ID, SHEET_INDEX, SHEETS } from './procedure-management.constants';
import styles from './ProcedureManagement.module.scss';
import { useProcedureManagementStore } from './useProcedureManagementStore';

export const ProcedureManagement = ({ tabId, title }: PageProps<MENU_ID>) => {
  const [activeGrid, setActiveGrid] = useState<SHEET_INDEX>(SHEET_INDEX.PROCEDURE_LIST);

  const gridRefs = [useRef<FlexGrid>(), useRef<FlexGrid>()];
  const gridFilterRefs = [useRef<FlexGridFilter>(), useRef<FlexGridFilter>()];

  const initialized = useProcedureManagementStore(state => state.initialized);
  const isOpenSearchArea = useProcedureManagementStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useProcedureManagementStore(state => state.setOpenSearchArea);
  const filters = useProcedureManagementStore(state => state.filters);
  const setListFilter = useProcedureManagementStore(state => state.setListFilter);
  const staticColumns = useProcedureManagementStore(state => state.staticColumns);
  const fetchStaticColumns = useProcedureManagementStore(state => state.fetchStaticColumns);
  const searchParams = useProcedureManagementStore(state => state.searchParams);

  const { saveWithValidation } = useSaveWithValidation();

  const { data: procedureList } = useTabProcQuery<MENU_ID, SHEETS.PROCEDURE_LIST>({
    menuId: MENU_ID,
    sheetName: SHEETS.PROCEDURE_LIST,
    tabId,
    filters: filters[SHEETS.PROCEDURE_LIST],
    enabled: !!filters[SHEETS.PROCEDURE_LIST],
  });

  const { data: procedureInfo } = useTabProcQuery<MENU_ID, SHEETS.PROCEDURE_INFO>({
    menuId: MENU_ID,
    sheetName: SHEETS.PROCEDURE_INFO,
    tabId,
    filters: filters[SHEETS.PROCEDURE_INFO],
    enabled: !!filters[SHEETS.PROCEDURE_INFO],
  });

  const { mutate: saveProcedureList } = useProcMutation<MENU_ID, SHEETS.PROCEDURE_LIST>({
    menuId: MENU_ID,
    sheetName: SHEETS.PROCEDURE_LIST,
    tabId,
  });

  const { mutate: saveProcedureInfo } = useProcMutation<MENU_ID, SHEETS.PROCEDURE_INFO>({
    menuId: MENU_ID,
    sheetName: SHEETS.PROCEDURE_INFO,
    tabId,
  });

  const handleInfoSave = () => {
    if (activeGrid === SHEET_INDEX.PROCEDURE_LIST) {
      const saveData = procedureList?.o_rc?.filter(item => item.CRUD_TYPE) ?? [];
      const staticColumn = staticColumns.procList;
      saveWithValidation(saveData, staticColumn, saveProcedureList);
    } else {
      const saveData = procedureInfo?.o_rc?.filter(item => item.CRUD_TYPE) ?? [];
      const staticColumn = staticColumns.procInfo;
      saveWithValidation(saveData, staticColumn, saveProcedureInfo);
    }
  };

  const hotkeyConfig: HotkeyConfig = {
    insert: false,
    delete: false,
    save: handleInfoSave,
    search: setListFilter,
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
      <ProcedureManagementForm />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRefs[activeGrid]}
        gridFilter={gridFilterRefs[activeGrid]}
        dataCount={gridRefs[activeGrid].current?.rows.length ?? 0}
        excelFileName='procedure'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <div className={styles.upperGrid}>
        <ProcedureListGrid
          gridRef={gridRefs[SHEET_INDEX.PROCEDURE_LIST]}
          gridFilterRef={gridFilterRefs[SHEET_INDEX.PROCEDURE_LIST]}
          data={procedureList?.o_rc ?? []}
          setActiveGrid={setActiveGrid}
        />
      </div>
      <div className={styles.lowerGrid}>
        <ProcedureInfoGrid
          gridRef={gridRefs[SHEET_INDEX.PROCEDURE_INFO]}
          gridFilterRef={gridFilterRefs[SHEET_INDEX.PROCEDURE_INFO]}
          data={procedureInfo?.o_rc ?? []}
          setActiveGrid={setActiveGrid}
        />
      </div>
    </>
  );
};
