import { CellRange, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction, GridUtils } from '@foundation/utils';
import { MainTitle, SubTitle, MessageModal } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';

import { MENU_ID, SHEETS } from './api-management.constants';
import { ApiManagementForm } from './components/ApiManagementForm';
import { ApiManagementGrid } from './components/ApiManagementGrid';
import { useApiManagementStore } from './useApiManagementStore';

export const ApiManagement = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.LIST>>>();
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.LIST>>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const initialized = useApiManagementStore(state => state.initialized);
  const filters = useApiManagementStore(state => state.filters);
  const staticColumn = useApiManagementStore(state => state.staticColumns);
  const setFilters = useApiManagementStore(state => state.setFilters);
  const setSearchParams = useApiManagementStore(state => state.setSearchParams);
  const fetchStaticColumns = useApiManagementStore(state => state.fetchStaticColumns);
  const isOpenSearchArea = useApiManagementStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useApiManagementStore(state => state.setOpenSearchArea);
  const openMessageModal = useApiManagementStore(state => state.openMessageModal);
  const setOpenMessageModal = useApiManagementStore(state => state.setOpenMessageModal);
  const clickedRow = useApiManagementStore(state => state.clickedRow);
  const searchParams = useApiManagementStore(state => state.searchParams);

  const { saveWithValidation } = useSaveWithValidation();

  // API ID 는 폼이 로컬 state 로 들고 있다 (key-in 마다 스토어를 쓰면 페이지 전체가 리렌더돼 입력이 밀림).
  //   최신 입력값은 이 ref 로 읽고 조회 직전에 커밋한다.
  //   필수: SubTitle 의 F5 리스너는 window 캡처 단계라 인풋 blur 보다 먼저 실행된다 —
  //   커밋 없이 setFilters 를 부르면 방금 친 값이 빠진 채로 조회된다.
  const apiIdInputRef = useRef(searchParams.apiId);
  const handleSearch = () => {
    if (apiIdInputRef.current !== searchParams.apiId) {
      setSearchParams({ apiId: apiIdInputRef.current });
    }
    setFilters();
  };

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
    tabId,
  });

  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
  }, [tabId]);

  const onSave = () => {
    const saveData = data?.o_rc?.filter(item => item.CRUD_TYPE);
    saveWithValidation(saveData, staticColumn, mutate);
  };

  const setMessage = (messageId: string, message: string) => {
    const dataItem = GridUtils.getRow(gridRef.current, clickedRow);
    if (!dataItem) return;

    editTrackerRef.current?.storeChange(
      dataItem,
      'API_MSG_ID',
      dataItem.API_MSG_ID ?? '-',
      messageId
    );
    editTrackerRef.current?.storeChange(dataItem, 'API_MSG_NM', dataItem.API_MSG_NM ?? '', message);

    dataItem.API_MSG_ID = messageId;
    dataItem.API_MSG_NM = message;

    if (dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT && dataItem.CRUD_TYPE !== CRUD_TYPE.DELETE)
      dataItem.CRUD_TYPE = CRUD_TYPE.MODIFY;

    gridRef.current?.refreshRange(new CellRange(clickedRow, 0, clickedRow, -1));
  };

  const handleInsert = () => {
    if (!gridRef.current) return;

    GridAction.addRow(gridRef.current, {
      USE_YN: 'Y',
      API_MSG_ID: '-',
    });
  };

  const handleDelete = () => {
    if (!gridRef.current) return;
    GridAction.removeRow(gridRef.current);
  };

  const hotkeyConfig: HotkeyConfig = {
    insert: handleInsert,
    delete: handleDelete,
    save: onSave,
    search: handleSearch,
    upload: false,
    manual: false,
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <ApiManagementForm onSearch={handleSearch} apiIdInputRef={apiIdInputRef} />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={data?.o_rc.length ?? 0}
        excelFileName='Api'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <ApiManagementGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        data={data?.o_rc ?? []}
      />
      <MessageModal
        open={openMessageModal}
        modalClose={() => setOpenMessageModal(false)}
        setSelectedValue={setMessage}
        initialType='LBL'
        initialMessage={GridUtils.getRow(gridRef.current, clickedRow)?.API_MSG_NM}
        messageTypeFilters={['LBL']}
      />
    </>
  );
};
