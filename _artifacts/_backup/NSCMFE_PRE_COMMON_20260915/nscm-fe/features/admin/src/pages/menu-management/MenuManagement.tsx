import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction, GridUtils } from '@foundation/utils';
import { MainTitle, MessageModal, SubTitle } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';

import { LevelOneMenuGrid } from './components/LevelOneMenuGrid';
import { LevelThreeMenuGrid } from './components/LevelThreeMenuGrid';
import { LevelTwoMenuGrid } from './components/LevelTwoMenuGrid';
import type { RESPONSE_SET } from './menu-management.constants';
import { MENU_ID, SHEET_INDEX, SHEETS } from './menu-management.constants';
import styles from './MenuManagement.module.scss';
import { useMenuManagementStore } from './useMenuManagementStore';

type MessageEditableRow = WijmoRowItem & {
  MNU_MSG_ID?: string;
  MNU_MSG_NM?: string;
  CRUD_TYPE?: string;
};

export const MenuManagement = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRefs = [
    useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.LEVEL_ONE_MENU, RESPONSE_SET.OUTPUT>>>(),
    useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.LEVEL_TWO_MENU, RESPONSE_SET.OUTPUT>>>(),
    useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.LEVEL_THREE_MENU, RESPONSE_SET.OUTPUT>>>(),
  ] as const;
  const gridFilterRefs = [
    useRef<FlexGridFilter>(),
    useRef<FlexGridFilter>(),
    useRef<FlexGridFilter>(),
  ];
  const editTrackerRefs = [
    useRef<EditTracker<ResponseData<MENU_ID, SHEETS.LEVEL_ONE_MENU, RESPONSE_SET.OUTPUT>>>(),
    useRef<EditTracker<ResponseData<MENU_ID, SHEETS.LEVEL_TWO_MENU, RESPONSE_SET.OUTPUT>>>(),
    useRef<EditTracker<ResponseData<MENU_ID, SHEETS.LEVEL_THREE_MENU, RESPONSE_SET.OUTPUT>>>(),
  ] as const;
  const initialized = useMenuManagementStore(state => state.initialized);
  const filters = useMenuManagementStore(state => state.filters);
  const setFilters = useMenuManagementStore(state => state.setFilters);
  const staticColumns = useMenuManagementStore(state => state.staticColumns);
  const fetchStaticColumns = useMenuManagementStore(state => state.fetchStaticColumns);
  const isOpenSearchArea = useMenuManagementStore(state => state.isOpenSearchArea);

  const levelTwoMenuCleared = useMenuManagementStore(state => state.levelTwoMenuCleared);
  const levelThreeMenuCleared = useMenuManagementStore(state => state.levelThreeMenuCleared);
  const clickedLevelOneMenu = useMenuManagementStore(state => state.clickedLevelOneMenu);
  const clickedLevelTwoMenu = useMenuManagementStore(state => state.clickedLevelTwoMenu);
  const clickedRow = useMenuManagementStore(state => state.clickedRow);
  const openMessageModal = useMenuManagementStore(state => state.openMessageModal);
  const setOpenMessageModal = useMenuManagementStore(state => state.setOpenMessageModal);

  const [activeTab, setActiveTab] = useState<SHEET_INDEX>(SHEET_INDEX.LEVEL_ONE_MENU);

  const { saveWithValidation } = useSaveWithValidation();

  const queries = [
    useTabProcQuery<MENU_ID, SHEETS.LEVEL_ONE_MENU>({
      menuId: MENU_ID,
      sheetName: SHEETS.LEVEL_ONE_MENU,
      tabId,
      filters: filters[SHEETS.LEVEL_ONE_MENU],
      enabled: !!filters[SHEETS.LEVEL_ONE_MENU],
    }),
    useTabProcQuery<MENU_ID, SHEETS.LEVEL_TWO_MENU>({
      menuId: MENU_ID,
      sheetName: SHEETS.LEVEL_TWO_MENU,
      tabId,
      filters: filters[SHEETS.LEVEL_TWO_MENU],
      enabled: !!filters[SHEETS.LEVEL_TWO_MENU],
    }),
    useTabProcQuery<MENU_ID, SHEETS.LEVEL_THREE_MENU>({
      menuId: MENU_ID,
      sheetName: SHEETS.LEVEL_THREE_MENU,
      tabId,
      filters: filters[SHEETS.LEVEL_THREE_MENU],
      enabled: !!filters[SHEETS.LEVEL_THREE_MENU],
    }),
  ] as const;

  const mutates = [
    useProcMutation<MENU_ID>({
      menuId: MENU_ID,
      sheetName: SHEETS.LEVEL_ONE_MENU,
      tabId,
    }).mutate,
    useProcMutation<MENU_ID>({
      menuId: MENU_ID,
      sheetName: SHEETS.LEVEL_TWO_MENU,
      tabId,
    }).mutate,
    useProcMutation<MENU_ID>({
      menuId: MENU_ID,
      sheetName: SHEETS.LEVEL_THREE_MENU,
      tabId,
    }).mutate,
  ] as const;

  const rows = [
    queries[SHEET_INDEX.LEVEL_ONE_MENU].data?.o_rc ?? [],
    queries[SHEET_INDEX.LEVEL_TWO_MENU].data?.o_rc ?? [],
    queries[SHEET_INDEX.LEVEL_THREE_MENU].data?.o_rc ?? [],
  ] as const;

  const onInsert = () => {
    if (!gridRefs[activeTab].current) return;
    switch (activeTab) {
      case SHEET_INDEX.LEVEL_ONE_MENU: {
        const grid = gridRefs[SHEET_INDEX.LEVEL_ONE_MENU].current;
        if (!grid) return;

        GridAction.addRow(grid, {
          SORT_ORD: GridUtils.getNextSortOrd(grid),
          USE_YN: 'Y',
        });
        break;
      }
      case SHEET_INDEX.LEVEL_TWO_MENU:
        if (!levelTwoMenuCleared && clickedLevelOneMenu) {
          const grid = gridRefs[SHEET_INDEX.LEVEL_TWO_MENU].current;
          if (!grid) return;

          GridAction.addRow(grid, {
            LEVEL_ONE_MNU_ID: clickedLevelOneMenu,
            SORT_ORD: GridUtils.getNextSortOrd(grid),
            USE_YN: 'Y',
          });
        }
        break;
      case SHEET_INDEX.LEVEL_THREE_MENU:
        if (!levelThreeMenuCleared && clickedLevelTwoMenu) {
          const grid = gridRefs[SHEET_INDEX.LEVEL_THREE_MENU].current;
          if (!grid) return;

          GridAction.addRow(grid, {
            LEVEL_ONE_MNU_ID: clickedLevelOneMenu,
            LEVEL_TWO_MNU_ID: clickedLevelTwoMenu,
            MNU_TP_CD: 'SCREEN',
            UNIT_TP_CD: '-',
            SORT_ORD: GridUtils.getNextSortOrd(grid),
            USE_YN: 'Y',
          });
        }
        break;
    }
  };

  const onDelete = () => {
    if (!gridRefs[activeTab].current) return;
    GridAction.removeRow(gridRefs[activeTab].current as FlexGrid, true);
  };

  const onSave = () => {
    const mutate = mutates[activeTab];
    if (!mutate) return;

    const data = rows[activeTab]?.filter(item => item.CRUD_TYPE) ?? [];
    const staticColumn =
      staticColumns[
        activeTab === SHEET_INDEX.LEVEL_ONE_MENU
          ? SHEETS.LEVEL_ONE_MENU
          : activeTab === SHEET_INDEX.LEVEL_TWO_MENU
            ? SHEETS.LEVEL_TWO_MENU
            : SHEETS.LEVEL_THREE_MENU
      ];
    saveWithValidation(data, staticColumn, mutate);
  };

  const hotkeyConfig: HotkeyConfig = {
    insert: onInsert,
    // delete: onDelete,
    search: () => setFilters(SHEETS.LEVEL_ONE_MENU, filters[SHEETS.LEVEL_ONE_MENU]),
    save: onSave,
    manual: false,
    excel: false,
    condition: false,
    resetCondition: false,
    upload: false,
  };

  const updateMessageForGrid = <T extends MessageEditableRow>(
    grid: FlexGrid<T> | undefined,
    editTrackerRef: MutableRefObject<EditTracker<T> | undefined>,
    messageId: string,
    message: string
  ) => {
    const dataItem = GridUtils.getRow<T>(grid, clickedRow);
    if (!grid || !dataItem) return;

    editTrackerRef.current?.storeChange(
      dataItem,
      'MNU_MSG_ID',
      dataItem.MNU_MSG_ID ?? '',
      messageId
    );
    editTrackerRef.current?.storeChange(dataItem, 'MNU_MSG_NM', dataItem.MNU_MSG_NM ?? '', message);

    dataItem.MNU_MSG_ID = messageId;
    dataItem.MNU_MSG_NM = message;
    if (dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT && dataItem.CRUD_TYPE !== CRUD_TYPE.DELETE) {
      dataItem.CRUD_TYPE = CRUD_TYPE.MODIFY;
    }

    GridUtils.refreshRow(grid, clickedRow);
  };

  const setMessage = (messageId: string, message: string) => {
    switch (activeTab) {
      case SHEET_INDEX.LEVEL_ONE_MENU: {
        updateMessageForGrid(
          gridRefs[SHEET_INDEX.LEVEL_ONE_MENU].current,
          editTrackerRefs[SHEET_INDEX.LEVEL_ONE_MENU],
          messageId,
          message
        );
        break;
      }
      case SHEET_INDEX.LEVEL_TWO_MENU: {
        updateMessageForGrid(
          gridRefs[SHEET_INDEX.LEVEL_TWO_MENU].current,
          editTrackerRefs[SHEET_INDEX.LEVEL_TWO_MENU],
          messageId,
          message
        );
        break;
      }
      case SHEET_INDEX.LEVEL_THREE_MENU: {
        updateMessageForGrid(
          gridRefs[SHEET_INDEX.LEVEL_THREE_MENU].current,
          editTrackerRefs[SHEET_INDEX.LEVEL_THREE_MENU],
          messageId,
          message
        );
        break;
      }
    }
  };

  useEffect(() => {
    if (!initialized) {
      void fetchStaticColumns();
      setFilters(SHEETS.LEVEL_ONE_MENU, {});
    }
  }, [tabId]);

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        disableSearchArea
      />
      {/* dataCount 는 하드코딩 0 이 아니라 툴바 대상(activeTab) 그리드의 실제 건수를 반영한다.
          3 개 그리드가 항상 동시에 보이는 화면이라, 어느 그리드 건수인지는 포커스(activeTab)
          기준으로 특정된다(다른 화면의 lastFocus 패턴과 동일). */}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRefs[activeTab]}
        gridFilter={gridFilterRefs[activeTab]}
        dataCount={rows[activeTab]?.length ?? 0}
        excelFileName='Menu'
        hotkeyConfig={hotkeyConfig}
      />
      <div className={styles.upperGrid}>
        <LevelOneMenuGrid
          gridRef={gridRefs[SHEET_INDEX.LEVEL_ONE_MENU]}
          gridFilterRef={gridFilterRefs[SHEET_INDEX.LEVEL_ONE_MENU]}
          editTrackerRef={editTrackerRefs[SHEET_INDEX.LEVEL_ONE_MENU]}
          setActiveTab={setActiveTab}
          data={rows[SHEET_INDEX.LEVEL_ONE_MENU]}
        />
        <LevelTwoMenuGrid
          gridRef={gridRefs[SHEET_INDEX.LEVEL_TWO_MENU]}
          gridFilterRef={gridFilterRefs[SHEET_INDEX.LEVEL_TWO_MENU]}
          editTrackerRef={editTrackerRefs[SHEET_INDEX.LEVEL_TWO_MENU]}
          setActiveTab={setActiveTab}
          data={levelTwoMenuCleared ? [] : rows[SHEET_INDEX.LEVEL_TWO_MENU]}
        />
      </div>
      <LevelThreeMenuGrid
        gridRef={gridRefs[SHEET_INDEX.LEVEL_THREE_MENU]}
        gridFilterRef={gridFilterRefs[SHEET_INDEX.LEVEL_THREE_MENU]}
        editTrackerRef={editTrackerRefs[SHEET_INDEX.LEVEL_THREE_MENU]}
        setActiveTab={setActiveTab}
        data={levelThreeMenuCleared ? [] : rows[SHEET_INDEX.LEVEL_THREE_MENU]}
      />
      <MessageModal
        open={openMessageModal}
        modalClose={() => setOpenMessageModal(false)}
        setSelectedValue={setMessage}
        initialType='MNU'
        initialMessage={
          GridUtils.getRow(
            gridRefs[activeTab].current as unknown as FlexGrid<MessageEditableRow>,
            clickedRow
          )?.MNU_MSG_NM
        }
        messageTypeFilters={['MNU']}
      />
    </>
  );
};
