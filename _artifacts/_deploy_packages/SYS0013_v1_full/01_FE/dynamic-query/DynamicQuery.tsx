import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useProcMutation, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { DynamicQueryColumnsGrid } from './components/DynamicQueryColumnsGrid';
import { DynamicQueryForm } from './components/DynamicQueryForm';
import { DynamicQueryHistoryGrid } from './components/DynamicQueryHistoryGrid';
import { DynamicQueryMainGrid } from './components/DynamicQueryMainGrid';
import { DynamicQueryParametersGrid } from './components/DynamicQueryParametersGrid';
import { DynamicQueryResultGrid } from './components/DynamicQueryResultGrid';
import { MENU_ID, SHEETS } from './dynamic-query.constants';
import type {
  ColumnMetaRow,
  HistoryRow,
  ParameterMetaRow,
  QueryRow,
  ResultRow,
} from './dynamic-query.types';
import { useDynamicQueryStore } from './useDynamicQueryStore';

export const DynamicQuery = ({ tabId, title }: PageProps<MENU_ID>) => {
  const mainGridRef = useRef<FlexGrid<QueryRow>>(null);
  const resultGridRef = useRef<FlexGrid<ResultRow>>(null);
  const columnsGridRef = useRef<FlexGrid<ColumnMetaRow>>(null);
  const parametersGridRef = useRef<FlexGrid<ParameterMetaRow>>(null);
  const historyGridRef = useRef<FlexGrid<HistoryRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);

  const initialized = useDynamicQueryStore(s => s.initialized);
  const fetchSearchConditions = useDynamicQueryStore(s => s.fetchSearchConditions);
  const fetchStaticColumns = useDynamicQueryStore(s => s.fetchStaticColumns);
  const filters = useDynamicQueryStore(s => s.filters);
  const setFilter = useDynamicQueryStore(s => s.setFilter);
  const openSearchArea = useDynamicQueryStore(s => s.openSearchArea);
  const setOpenSearchArea = useDynamicQueryStore(s => s.setOpenSearchArea);
  const selectedQueryId = useDynamicQueryStore(s => s.selectedQueryId);

  const setAlert = useMessageStore(s => s.setAlert);
  const setToast = useMessageStore(s => s.setToast);
  const queryClient = useQueryClient();

  const { data: mainData } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });

  const { data: resultData } = useTabProcQuery<MENU_ID, SHEETS.RESULT>({
    menuId: MENU_ID,
    sheetName: SHEETS.RESULT,
    tabId,
    filters: filters[SHEETS.RESULT],
    enabled: !!filters[SHEETS.RESULT],
  });

  const { data: columnsData } = useTabProcQuery<MENU_ID, SHEETS.COLUMNS>({
    menuId: MENU_ID,
    sheetName: SHEETS.COLUMNS,
    tabId,
    filters: filters[SHEETS.COLUMNS],
    enabled: !!filters[SHEETS.COLUMNS] && !!selectedQueryId,
  });

  const { data: parametersData } = useTabProcQuery<MENU_ID, SHEETS.PARAMETERS>({
    menuId: MENU_ID,
    sheetName: SHEETS.PARAMETERS,
    tabId,
    filters: filters[SHEETS.PARAMETERS],
    enabled: !!filters[SHEETS.PARAMETERS] && !!selectedQueryId,
  });

  const { data: historyData } = useTabProcQuery<MENU_ID, SHEETS.HISTORY>({
    menuId: MENU_ID,
    sheetName: SHEETS.HISTORY,
    tabId,
    filters: filters[SHEETS.HISTORY],
    enabled: !!filters[SHEETS.HISTORY] && !!selectedQueryId,
  });

  useEffect(() => {
    if (!initialized) void fetchSearchConditions();
    void fetchStaticColumns();
    if (!filters[SHEETS.MAIN]) setFilter();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const handleSearch = () => {
    setFilter();
    // ⭐ master hook §2.4 — Search 시 admin SYS0004 메타 refetch
    void fetchStaticColumns();
  };

  const { mutate: mutateSave } = useProcMutation<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
  });

  const { mutate: mutateExecute } = useProcMutation<MENU_ID, SHEETS.RESULT>({
    menuId: MENU_ID,
    sheetName: SHEETS.RESULT,
    procedureAction: 'EXECUTE' as never,
    tabId,
  });

  const handleSave = () => {
    if (!selectedQueryId) {
      void setAlert({ type: 'alert', content: 'Query 를 선택하세요' });
      return;
    }
    mutateSave([{ QUERY_ID: selectedQueryId }] as never[], {
      onSuccess: () => {
        void queryClient.invalidateQueries({ queryKey: [tabId] });
        setToast({ type: 'success', message: '저장 완료' });
      },
    });
  };

  const handleExecute = () => {
    if (!selectedQueryId) {
      void setAlert({ type: 'alert', content: '실행할 Query 를 선택하세요' });
      return;
    }
    mutateExecute([{ QUERY_ID: selectedQueryId }] as never[], {
      onSuccess: () => {
        void queryClient.invalidateQueries({ queryKey: [tabId] });
        setToast({ type: 'success', message: '실행 완료' });
      },
    });
  };

  const hotkeyConfig: HotkeyConfig = {
    search: handleSearch,
    save: handleSave,
    insert: false,
    delete: false,
    condition: false,
    resetCondition: false,
    manual: false,
    upload: false,
  };

  const customButtons = [{ label: 'Execute', action: handleExecute }];

  const mainRows = (mainData?.o_rc1 ?? []) as unknown as QueryRow[];
  const resultRows = (resultData?.o_rc1 ?? []) as unknown as ResultRow[];
  const columnsRows = (columnsData?.o_rc1 ?? []) as unknown as ColumnMetaRow[];
  const parametersRows = (parametersData?.o_rc1 ?? []) as unknown as ParameterMetaRow[];
  const historyRows = (historyData?.o_rc1 ?? []) as unknown as HistoryRow[];

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && <DynamicQueryForm onSearch={handleSearch} />}

      <SubTitle
        menuId={MENU_ID}
        grid={mainGridRef}
        gridFilter={gridFilterRef}
        dataCount={mainRows.length}
        excelFileName='DynamicQuery'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        customButtons={customButtons}
      />

      <DynamicQueryMainGrid gridRef={mainGridRef} gridFilterRef={gridFilterRef} data={mainRows} />

      <TabWrapper persist>
        <TabItem label='Result'>
          <DynamicQueryResultGrid gridRef={resultGridRef} data={resultRows} />
        </TabItem>
        <TabItem label='Columns'>
          <DynamicQueryColumnsGrid gridRef={columnsGridRef} data={columnsRows} />
        </TabItem>
        <TabItem label='Parameters'>
          <DynamicQueryParametersGrid gridRef={parametersGridRef} data={parametersRows} />
        </TabItem>
        <TabItem label='History'>
          <DynamicQueryHistoryGrid gridRef={historyGridRef} data={historyRows} />
        </TabItem>
      </TabWrapper>
    </>
  );
};
