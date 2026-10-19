import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';

import { MessageManagementForm } from './components/MessageManagementForm';
import { MessageManagementGrid } from './components/MessageManagementGrid';
import { MENU_ID, SHEETS } from './message-management.constants';
import { useMessageManagementStore } from './useMessageManagementStore';

export const MessageManagement = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const initialized = useMessageManagementStore(state => state.initialized);
  const filters = useMessageManagementStore(state => state.filters);
  const setFilters = useMessageManagementStore(state => state.setFilters);
  const staticColumns = useMessageManagementStore(state => state.staticColumns);
  const fetchStaticColumns = useMessageManagementStore(state => state.fetchStaticColumns);
  const isOpenSearchArea = useMessageManagementStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useMessageManagementStore(state => state.setOpenSearchArea);
  const addRowMessageType = useMessageManagementStore(state => state.addRowMessageType);
  const searchParams = useMessageManagementStore(state => state.searchParams);

  const { saveWithValidation } = useSaveWithValidation();

  const { data } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.MSG_MGMT,
    tabId,
    filters,
    enabled: filters !== undefined,
  });

  const { mutate } = useProcMutation<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.MSG_MGMT,
    tabId,
  });

  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
  }, [tabId]);

  const onSave = () => {
    const saveData = data?.o_rc?.filter?.(item => item.CRUD_TYPE) ?? [];
    saveWithValidation(saveData, staticColumns, mutate);
  };

  const onInsert = () => {
    if (!gridRef.current) return;
    GridAction.addRow(gridRef.current, {
      MSG_TP_CD: addRowMessageType,
      USE_YN: 'Y',
    });
  };

  // USE_YN 으로 사용 여부를 관리하는 그리드라 삭제는 신규행 제거 전용으로만 쓴다.
  // removeRow 두 번째 인자 deleteOnlyNew=true 로 기존행에 D flag 를 찍지 않는다
  //   (기존 메시지 비활성은 USE_YN='N' 으로 처리).
  const onDelete = () => {
    if (!gridRef.current) return;
    GridAction.removeRow(gridRef.current, true);
  };

  const hotkeyConfig: HotkeyConfig = {
    save: onSave,
    insert: onInsert,
    delete: onDelete,
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
      <MessageManagementForm />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={data?.o_rc.length ?? 0}
        excelFileName='Message'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <MessageManagementGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        data={data?.o_rc ?? []}
      />
    </>
  );
};
