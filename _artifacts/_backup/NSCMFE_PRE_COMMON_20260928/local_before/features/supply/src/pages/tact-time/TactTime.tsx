import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';
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
  // 필수 컬럼(메타 INPUT_TP_CD=M/IM 또는 라벨 *) 저장검증 — 전 화면 공통(다른 화면과 동일 규약).
  const { saveWithValidation } = useSaveWithValidation();

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
  //   AS-IS 사전조건 재현(SCP0020_TactTime.cs InsertButton): 신규행은 선택 행의 상위키
  //   (division/plant site/item/operation)를 복사하므로 조회된 원본 행이 반드시 있어야 한다.
  //   공통 GridAction.addRow 는 빈 그리드 insert 를 막지 않으므로(util 720행 TODO) 화면에서 가드한다.
  const handleInsert = () => {
    if (focused === 'except') {
      const grid = exceptGridRef.current;
      if (!grid) return;
      // AS-IS: 상단 Tact Time 행을 더블클릭해 선택한 뒤에만 예외행 추가 (cs:873 nMainSelRow<0 -> 가드).
      const src = mainGridRef.current?.selectedItems[0] as Record<string, unknown> | undefined;
      if (!src) {
        void setAlert({
          type: 'alert',
          content: t(MSG.INSERT_GUIDE, 'Edit mode is available after search.'),
        });
        return;
      }
      // AS-IS: 선택 행 LINE_ID 가 비어 있으면 예외행 추가 불가 (cs:909 MSG00002 Line 필수).
      const lineId = typeof src.LINE_ID === 'string' ? src.LINE_ID.trim() : '';
      if (!lineId) {
        void setAlert({ type: 'alert', content: t(MSG.REQUIRED_FIELD, '_Line.') });
        return;
      }
      GridAction.addRow(grid, exceptInsertDefaults(src));
      return;
    }
    const grid = mainGridRef.current;
    if (!grid) return;
    // AS-IS: 조회된 행이 없으면 신규행 추가 불가 (cs:760/817 ActiveRowIndex<0 return).
    //   미조회/0행 조회 상태에서 Insert 차단 — 신규행은 기존 행의 상위키를 복사해야 하기 때문.
    if (mainRows.length === 0) {
      void setAlert({
        type: 'alert',
        content: t(MSG.INSERT_GUIDE, 'Edit mode is available after search.'),
      });
      return;
    }
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
      // 필수 컬럼(메타 M/IM) 검증 통과 시 mutate — 미입력이면 alert 후 저장 차단(전 화면 공통).
      saveWithValidation(
        dirty as unknown as ExceptRow[],
        staticColumns[SHEETS.EXCEPT],
        mutateExcept
      );
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
    // 필수 컬럼(메타 M/IM, 예: Packer LINE_ID=IM) 검증 통과 시 mutate — 미입력이면 alert 후 차단.
    if (isPlant) {
      saveWithValidation(dirty as unknown as PlantRow[], staticColumns[SHEETS.PLANT], mutatePlant);
    } else {
      saveWithValidation(dirty as unknown as PackerRow[], staticColumns[SHEETS.PACKER], mutatePacker);
    }
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
              // 상단 선택행 더블클릭 -> 하단 예외 파생 조회 (design 01 D-5 / 03 §4.2).
              //   포커스(=저장/건수/툴바 대상)는 바꾸지 않는다 — 더블클릭의 유일한 의도는 파생조회다
              //   (AS-IS cs:246 SpdMain_CellDoubleClick). setFocused('except') 를 넣으면 상단 셀을
              //   더블클릭해 편집한 뒤 저장이 하단을 보게 되어 상단 편집분이 "변경 없음(MSG00004)"으로
              //   새고, 좌상단 조회건수도 상단<->하단으로 깜빡인다. 대상 전환은 각 그리드 gotFocus 가 담당.
              setExceptFilter(row);
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
