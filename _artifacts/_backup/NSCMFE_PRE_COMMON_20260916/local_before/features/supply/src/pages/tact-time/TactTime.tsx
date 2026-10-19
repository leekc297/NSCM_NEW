import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useTabProcQuery } from '@shared/hooks';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore } from '@shared/stores';

import { TactTimeExceptGrid } from './components/TactTimeExceptGrid';
import { TactTimeForm } from './components/TactTimeForm';
import { TactTimeMainGrid } from './components/TactTimeMainGrid';
import { useTactTimeValidation } from './hooks/useTactTimeValidation';
import { MENU_ID, MSG, SHEETS, TACT_MODE } from './tact-time.constants';
import type { ExceptRow, MainRow, PackerRow, PlantRow } from './tact-time.types';
import styles from './TactTime.module.scss';
import { useTactTimeStore } from './useTactTimeStore';
import {
  exceptInsertDefaults,
  packerInsertDefaults,
  plantInsertDefaults,
} from './utils/tactTimeEditLock';

type FocusTarget = 'main' | 'except';

// AS-IS GSCM.SCP.Master.UIL SCP0020_TactTime — 2 그리드(spdMain Plant/Packer + spdExcept).
//   설계: .atlas/gscm-design/SCP0020/design/00~03. 상세 매핑: __asis-mapping__.md.
export const TactTime = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const { validateMainRows, validateExceptRows } = useTactTimeValidation();

  const mainGridRef = useRef<FlexGrid>();
  const mainFilterRef = useRef<FlexGridFilter>();
  const mainTrackerRef = useRef<EditTracker>();
  const exceptGridRef = useRef<FlexGrid>();
  const exceptFilterRef = useRef<FlexGridFilter>();
  const exceptTrackerRef = useRef<EditTracker>();

  const sc = useTactTimeStore(s => s.searchCondition);
  const setSearchCondition = useTactTimeStore(s => s.setSearchCondition);
  const filters = useTactTimeStore(s => s.filters);
  const setFilter = useTactTimeStore(s => s.setFilter);
  const setExceptFilter = useTactTimeStore(s => s.setExceptFilter);
  const openSearchArea = useTactTimeStore(s => s.openSearchArea);
  const setOpenSearchArea = useTactTimeStore(s => s.setOpenSearchArea);
  const staticColumns = useTactTimeStore(s => s.staticColumns);
  const fetchStaticColumns = useTactTimeStore(s => s.fetchStaticColumns);
  const initialized = useTactTimeStore(s => s.initialized);

  // NSCM 표준(formation): 그리드 상시 편집 — 별도 Edit 토글 버튼 없음. 셀별 편집가부는 tactTimeEditLock 가 판정.
  const editMode = true;
  const [focused, setFocused] = useState<FocusTarget>('main');
  const [openItem, setOpenItem] = useState(false);

  const isPlant = sc.mode === TACT_MODE.PLANT;

  const { data: plantData } = useTabProcQuery<MENU_ID, SHEETS.PLANT>({
    menuId: MENU_ID,
    sheetName: SHEETS.PLANT,
    tabId,
    filters: filters[SHEETS.PLANT],
    enabled: !!filters[SHEETS.PLANT],
  });
  const { data: packerData } = useTabProcQuery<MENU_ID, SHEETS.PACKER>({
    menuId: MENU_ID,
    sheetName: SHEETS.PACKER,
    tabId,
    filters: filters[SHEETS.PACKER],
    enabled: !!filters[SHEETS.PACKER],
  });
  const { data: exceptData } = useTabProcQuery<MENU_ID, SHEETS.EXCEPT>({
    menuId: MENU_ID,
    sheetName: SHEETS.EXCEPT,
    tabId,
    filters: filters[SHEETS.EXCEPT],
    enabled: !!filters[SHEETS.EXCEPT],
  });

  const { mutate: mutatePlant } = useProcMutation<MENU_ID, SHEETS.PLANT>({
    menuId: MENU_ID,
    sheetName: SHEETS.PLANT,
    tabId,
  });
  const { mutate: mutatePacker } = useProcMutation<MENU_ID, SHEETS.PACKER>({
    menuId: MENU_ID,
    sheetName: SHEETS.PACKER,
    tabId,
  });
  const { mutate: mutateExcept } = useProcMutation<MENU_ID, SHEETS.EXCEPT>({
    menuId: MENU_ID,
    sheetName: SHEETS.EXCEPT,
    tabId,
  });

  // 참조 안정화 — 조회 전 addRow 신규행이 리렌더에 사라지지 않도록. mode 변경 시 새 [] 로 리셋.
  const mainRows = useMemo<MainRow[]>(
    () => (isPlant ? (plantData?.o_rc1 ?? []) : (packerData?.o_rc1 ?? [])),
    [isPlant, plantData, packerData]
  );
  const exceptRows = useMemo<ExceptRow[]>(() => exceptData?.o_rc1 ?? [], [exceptData]);

  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const handleSearch = () => {
    // Division / Operation Group 필수 (design 02 §6, AS-IS Division*/Operation Group*).
    if (!sc.divisionId) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRED_FIELD, '_Division.') });
      return;
    }
    setFilter();
    void fetchStaticColumns();
  };

  // 신규행 — 포커스 그리드에 기본값 행 추가 (design 03 §3.3). 상위/선택행 복사.
  const handleInsert = () => {
    if (focused === 'except') {
      const grid = exceptGridRef.current;
      if (!grid) return;
      const src =
        (mainGridRef.current?.selectedItems[0] as Record<string, unknown> | undefined) ?? {};
      GridAction.addRow(grid, exceptInsertDefaults(src));
      return;
    }
    const grid = mainGridRef.current;
    if (!grid) return;
    const src = (grid.selectedItems[0] as Record<string, unknown> | undefined) ?? {
      DIVISION_ID: sc.divisionId,
    };
    GridAction.addRow(grid, isPlant ? plantInsertDefaults(src) : packerInsertDefaults(src));
  };

  const handleDelete = () => {
    const grid = focused === 'except' ? exceptGridRef.current : mainGridRef.current;
    if (!grid) return;
    GridAction.removeRow(grid);
  };

  const handleSave = () => {
    if (focused === 'except') {
      const grid = exceptGridRef.current;
      grid?.finishEditing();
      const src = (grid?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
      const dirty = src.filter(r => r.CRUD_TYPE);
      if (dirty.length === 0) {
        setToast({ type: 'error', message: t('MSG00004', '_No changes.') });
        return;
      }
      if (!validateExceptRows(dirty).ok) return;
      mutateExcept(dirty as unknown as ExceptRow[]);
      return;
    }
    const grid = mainGridRef.current;
    grid?.finishEditing();
    const src = (grid?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
    const dirty = src.filter(r => r.CRUD_TYPE);
    if (dirty.length === 0) {
      setToast({ type: 'error', message: t('MSG00004', '_No changes.') });
      return;
    }
    if (!validateMainRows(dirty).ok) return;
    if (isPlant) mutatePlant(dirty as unknown as PlantRow[]);
    else mutatePacker(dirty as unknown as PackerRow[]);
  };

  const hotkeyConfig: HotkeyConfig = {
    search: handleSearch,
    insert: handleInsert,
    save: handleSave,
    delete: handleDelete,
    manual: false,
    upload: false,
  };

  const dataCount = focused === 'except' ? exceptRows.length : mainRows.length;

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <TactTimeForm onSearch={handleSearch} onItemSearch={() => setOpenItem(true)} />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={focused === 'except' ? exceptGridRef : mainGridRef}
        gridFilter={focused === 'except' ? exceptFilterRef : mainFilterRef}
        dataCount={dataCount}
        excelFileName='TactTime'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
      />

      {/* 상(spdMain Plant/Packer) / 하(spdExcept) 수평 split (design 01 D-5). */}
      <PanelGroup className={styles.tableWrapper} orientation='vertical'>
        <Panel defaultSize={60} minSize={20}>
          <TactTimeMainGrid
            mode={sc.mode}
            rows={mainRows}
            gridRef={mainGridRef}
            gridFilterRef={mainFilterRef}
            editTrackerRef={mainTrackerRef}
            editMode={editMode}
            adminColumns={isPlant ? staticColumns[SHEETS.PLANT] : staticColumns[SHEETS.PACKER]}
            onRowDblClick={(row: MainRow) => {
              // 상단 선택행 더블클릭 -> 하단 예외 파생 조회 (design 01 D-5 / 03 §4.2)
              setExceptFilter(row);
              setFocused('except');
            }}
            onFocus={() => setFocused('main')}
          />
        </Panel>
        <PanelSeparator className={styles.splitBar} />
        <Panel defaultSize={40} minSize={15}>
          <div className={styles.lowerGrid}>
            <TactTimeExceptGrid
              rows={exceptRows}
              parentMode={sc.mode}
              gridRef={exceptGridRef}
              gridFilterRef={exceptFilterRef}
              editTrackerRef={exceptTrackerRef}
              editMode={editMode}
              adminColumns={staticColumns[SHEETS.EXCEPT]}
              onFocus={() => setFocused('except')}
            />
          </div>
        </Panel>
      </PanelGroup>

      {/* Model 검색 — 공용 표준 ItemByDivisionModal (20+ 화면 공용, 자체 menuId/sheet 조회) */}
      <ItemByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={itemIds => setSearchCondition({ itemId: itemIds })}
        preSearchParams={{ divisionId: sc.divisionId, itemId: sc.itemId }}
        callFromCell={false}
      />
    </>
  );
};
