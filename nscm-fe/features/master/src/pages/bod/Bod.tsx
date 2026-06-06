import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction, GridUtils } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import {
  useProcMutation,
  useSaveWithValidation,
  useSearchConditionPersistence,
  useTabProcQuery,
} from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { BodForm } from './components/BodForm';
import { BodGrid } from './components/BodGrid';
import { BodItemGrid } from './components/BodItemGrid';
import { MENU_ID, SHEET_INDEX, SHEETS } from './bod.constants';
import { useBodStore } from './useBodStore';

/**
 * DMF0015 BOD (Bill of Delivery) — Phase 6 PoC
 *
 * AS-IS: DM0015_BOD (1330 lines + Designer 566)
 * 룰셋 v2 적용:
 * - _tobe/03_main_component.md (7 단계 구조, Multi-sheet 변형)
 * - _tobe/09_subtitle_hotkey.md (10 키 매핑)
 * - G1 useSearchConditionPersistence (SubTitle DefaultButtonActions 자동 활성)
 */
export const Bod = ({ tabId, title }: PageProps<MENU_ID>) => {
  // [1] Grid refs (2 sheet: Main + Sub)
  const gridRefs = [useRef<FlexGrid>(), useRef<FlexGrid>()];
  const gridFilterRefs = [useRef<FlexGridFilter>(), useRef<FlexGridFilter>()];

  // [2] Store selector (개별)
  const initialized = useBodStore(state => state.initialized);
  const filters = useBodStore(state => state.filters);
  const setMainFilter = useBodStore(state => state.setMainFilter);
  const staticColumns = useBodStore(state => state.staticColumns);
  const fetchStaticColumns = useBodStore(state => state.fetchStaticColumns);
  const searchParams = useBodStore(state => state.searchParams);
  const openSearchArea = useBodStore(state => state.openSearchArea);
  const setOpenSearchArea = useBodStore(state => state.setOpenSearchArea);

  const [activeTab, setActiveTab] = useState<SHEET_INDEX>(SHEET_INDEX.MAIN);

  const { saveWithValidation } = useSaveWithValidation();
  const { t } = useTranslation();
  const setAlert = useMessageStore(state => state.setAlert);

  // G1 — SubTitle condition / resetCondition 자동 활성
  const { saveCondition, resetCondition } = useSearchConditionPersistence(MENU_ID);

  // [3] Hook — Main + Sub 별 useTabProcQuery / useProcMutation
  const { data: mainData } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });

  const { data: bodItemData } = useTabProcQuery<MENU_ID, SHEETS.BOD_ITEM>({
    menuId: MENU_ID,
    sheetName: SHEETS.BOD_ITEM,
    tabId,
    filters: filters[SHEETS.BOD_ITEM],
    enabled: !!filters[SHEETS.BOD_ITEM],
  });

  const { mutate: mutateMain } = useProcMutation<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
  });

  const { mutate: mutateBodItem } = useProcMutation<MENU_ID, SHEETS.BOD_ITEM>({
    menuId: MENU_ID,
    sheetName: SHEETS.BOD_ITEM,
    tabId,
  });

  // [4] Handler
  const handleSearch = () => {
    setMainFilter();
  };

  const handleInsert = () => {
    if (!gridRefs[activeTab].current) return;
    if (activeTab === SHEET_INDEX.MAIN) {
      // AS-IS DM0015_BOD InsertRow Main: ValidYn='Y' default
      GridAction.addRow(gridRefs[activeTab].current, {
        DIVISION_ID: filters[SHEETS.MAIN]?.divisionId ?? '81',
        VALID_YN: 'Y',
      });
    } else {
      // Sub: 부모 row 의 Division/BodID 자동 복사 (AS-IS DM0015_BOD line 1078-1080)
      // 룰 07 §2.2 GridUtils.getRow 표준 helper 사용
      const mainGrid = gridRefs[SHEET_INDEX.MAIN].current;
      if (!mainGrid) return;
      const selectedRow = mainGrid.selection?.row ?? -1;
      const parentItem = GridUtils.getRow(mainGrid, selectedRow);
      if (!parentItem) {
        // AS-IS MSG00071 — Main row 먼저 선택
        void setAlert({ type: 'alert', content: t('MSG00071', '_먼저 Main 행을 선택하세요.') });
        return;
      }
      GridAction.addRow(gridRefs[activeTab].current, {
        DIVISION_ID: parentItem.DIVISION_ID,
        BOD_ID: parentItem.BOD_ID,
        VALID_YN: 'Y',
      });
    }
  };

  const handleDelete = () => {
    if (!gridRefs[activeTab].current) return;
    GridAction.removeRow(gridRefs[activeTab].current, true);
  };

  const handleSave = () => {
    if (activeTab === SHEET_INDEX.MAIN) {
      const saveData = mainData?.bod?.filter?.(item => item.CRUD_TYPE) ?? [];
      saveWithValidation(saveData, staticColumns.bod, mutateMain);
    } else {
      const saveData = bodItemData?.bodItem?.filter?.(item => item.CRUD_TYPE) ?? [];
      saveWithValidation(saveData, staticColumns.bodItem, mutateBodItem);
    }
  };

  // [5] useEffect — initialized check (G1 GET 자동 restore 포함)
  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
  }, [tabId]);

  // [6] hotkeyConfig — manual/upload false 의무 + condition/resetCondition 자동 활성 (G1)
  const hotkeyConfig: HotkeyConfig = {
    insert: handleInsert,
    delete: handleDelete,
    search: handleSearch,
    save: handleSave,
    condition: () => saveCondition(searchParams),   // G1 (F6)
    resetCondition,                                  // G1 (F10)
    manual: false,
    upload: false,
  };

  const activeDataCount =
    activeTab === SHEET_INDEX.MAIN
      ? (mainData?.bod?.length ?? 0)
      : (bodItemData?.bodItem?.length ?? 0);

  // [7] JSX — MainTitle → Form → SubTitle → Grid (master/detail)
  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <BodForm onSubmit={handleSearch} />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRefs[activeTab]}
        gridFilter={gridFilterRefs[activeTab]}
        dataCount={activeDataCount}
        excelFileName='BOD-Master'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <BodGrid
        gridRef={gridRefs[SHEET_INDEX.MAIN]}
        gridFilterRef={gridFilterRefs[SHEET_INDEX.MAIN]}
        data={mainData?.bod ?? []}
        setActiveTab={setActiveTab}
      />
      <BodItemGrid
        gridRef={gridRefs[SHEET_INDEX.BOD_ITEM]}
        gridFilterRef={gridFilterRefs[SHEET_INDEX.BOD_ITEM]}
        data={bodItemData?.bodItem ?? []}
        setActiveTab={setActiveTab}
      />
    </>
  );
};
