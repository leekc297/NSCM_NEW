import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction, type EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { WarehouseCapacityForm } from './components/WarehouseCapacityForm';
import { WarehouseCapacityGrid } from './components/WarehouseCapacityGrid';
import { WarehouseItemMappingGrid } from './components/WarehouseItemMappingGrid';
import { useWarehouseCapacityStore } from './useWarehouseCapacityStore';
import { MENU_ID, MSG, SHEETS } from './warehouse-capacity.constants';
import type { MainRow } from './warehouse-capacity.types';
import styles from './WarehouseCapacity.module.scss';

// AS-IS GSCM.SCP.Master.UIL SCP0133_WarehouseCapacity — spdMain 2시트(Warehouse Capacity/
//   Warehouse Item Mapping). 격리 세션(GSCM 원본 미확보 + AS-IS MSSQL 접속 불가) — design 00~03
//   3중 ERROR, 확인 필요 15건+ 존재(design 02 §7). 이 activity 는 확정된 부분만 실동작으로
//   배선하고, 미확정 부분은 안전한 기본값(전량 조회 후 클라 필터, 편집 화이트리스트 보수적 적용)
//   으로 배선하되 주석/impl-notes 에 확인 필요임을 명시한다(anti-simplification §1).
//
// 편집제어: AS-IS SwitchLock(EditButton, design 01 §2 #2) "수정 모드" 토글 어포던스는 TO-BE 미이식
//   (전 화면 공통 결정, `.atlas/memory/editbutton-toggle-not-ported.md`). 조회 직후에도 바로 편집
//   가능하며, 항상 잠겨야 하는 컬럼만 `warehouseCapacityEditLock.isCellEditable` 화이트리스트로
//   판정한다.
//
// Warehouse Item Mapping 시트는 전용 GET SP 가 없다(design 03 §6-9 확인 필요) — 이 회차는 로컬
// 행 배열(Insert 전용)만 관리하고 조회 배선은 SP 계약 확정 후로 미룬다.
export const WarehouseCapacity = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const { saveWithValidation } = useSaveWithValidation();
  // admin 버튼 권한(SCM_ADM_USER_GR_MNU_BTN_MPG_M) — SCP0133 은 design 01 DB 실측상 미등록
  //   상태였다(0 rows). 05_register.sql 로 등록을 시도하되, 미등록 상태에서는 hasButton 이 전부
  //   false 를 반환해 버튼이 노출되지 않는 것이 정상이다(CLAUDE.md §2 체크리스트, 추측 우회 금지).
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const gridRef = useRef<FlexGrid<MainRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const trackerRef = useRef<EditTracker<MainRow>>();

  const itemMappingGridRef = useRef<FlexGrid>();
  const itemMappingGridFilterRef = useRef<FlexGridFilter>();
  const itemMappingTrackerRef = useRef<EditTracker>();
  // Warehouse Item Mapping — 전용 GET SP 없음(design 03 §6-9 확인 필요). 로컬 배열로 Insert만 지원.
  const [itemMappingRows, _setItemMappingRows] = useState<WijmoRowItem[]>([]);

  const sc = useWarehouseCapacityStore(s => s.searchCondition);
  const setSearchCondition = useWarehouseCapacityStore(s => s.setSearchCondition);
  const filters = useWarehouseCapacityStore(s => s.filters);
  const setFilter = useWarehouseCapacityStore(s => s.setFilter);
  const openSearchArea = useWarehouseCapacityStore(s => s.openSearchArea);
  const setOpenSearchArea = useWarehouseCapacityStore(s => s.setOpenSearchArea);
  const staticColumns = useWarehouseCapacityStore(s => s.staticColumns);
  const fetchStaticColumns = useWarehouseCapacityStore(s => s.fetchStaticColumns);
  const restoreSearchCondition = useWarehouseCapacityStore(s => s.restoreSearchCondition);
  const initialized = useWarehouseCapacityStore(s => s.initialized);

  const [activeSheet, setActiveSheet] = useState(0);
  const [openItem, setOpenItem] = useState(false);

  const { data } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const { mutate } = useProcMutation<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
  });

  const rows = useMemo<MainRow[]>(() => data?.o_rc1 ?? [], [data]);

  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
    // F6 로 저장한 조회조건을 진입 시 1회 복원한다(store 비영속 — 새로고침 생존은 이 GET 뿐).
    //   복원은 searchCondition 만 채우고 filters 는 비운 채라 자동조회 없이 Search 대기 상태가 된다.
    void restoreSearchCondition();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // design 02 §4 필수조건(Division/PlanGroup/Warehouse/Site/Stage/From/To 7항목, AS-IS MSG00001
  //   의도 — TO-BE 문구는 MSG00013 로 재매핑, Hook #114). 편집중 재조회는 MSG00703 로 경고
  //   (AS-IS MSG00046 의도 재매핑).
  const handleSearch = () => {
    const requiredMissing =
      !sc.divisionId ||
      sc.planGroupIds.length === 0 ||
      sc.warehouses.length === 0 ||
      sc.siteIds.length === 0 ||
      sc.stages.length === 0 ||
      !sc.fromYyyymmdd ||
      !sc.toYyyymmdd;
    if (requiredMissing) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRED_FIELD, '_Please enter the required fields.') });
      return;
    }
    if (sc.fromYyyymmdd > sc.toYyyymmdd) {
      void setAlert({ type: 'alert', content: t(MSG.INVALID_PERIOD, '_Invalid period (start > end).') });
      return;
    }
    if (trackerRef.current?.hasChanges() || itemMappingTrackerRef.current?.hasChanges()) {
      void setAlert({
        type: 'alert',
        content: t(MSG.UNSAVED_RESEARCH, '_There are unsaved changes. Do you want to search again?'),
      });
      return;
    }
    setFilter();
    void fetchStaticColumns();
  };

  // InsertButton — design 01 §5 항목6 "확인 필요"(ActiveRowIndex<0 등 표준 가드 존재 여부 미확정,
  //   원본 재확인 전까지 가드를 임의로 넣지도 빼지도 않는다).
  const handleInsert = () => {
    if (activeSheet === 0) {
      if (!gridRef.current) return;
      GridAction.addRow(gridRef.current, {
        DIVISION_ID: sc.divisionId,
      });
    } else {
      if (!itemMappingGridRef.current) return;
      GridAction.addRow(itemMappingGridRef.current, {
        DIVISION_ID: sc.divisionId,
      });
    }
  };

  // DeleteButton — 가드: 선택 행 없음(fps==null 상당) 이면 무동작(design 01 §2 #3, hasMessage=false).
  const handleDelete = () => {
    const grid = activeSheet === 0 ? gridRef.current : itemMappingGridRef.current;
    if (!grid) return;
    GridAction.removeRow(grid, true);
  };

  // SaveButton — WhCapa 시트만 실동작 배선(procedures.d.ts SAVE 계약이 SCP0133.main 하나뿐이라 —
  //   ItemMapping SAVE SP 계약은 §6-9 확인 필요 해소 후 추가). activeSheet 로 명시 분기하지 않으면
  //   Item Mapping 탭에서 Save 를 눌러도 WhCapa 그리드 상태만 조용히 확인해 오판 소지가 있어
  //   (독립 검증 지적) 탭별로 명시 분기한다.
  const handleSave = () => {
    if (activeSheet !== 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_No changes to save.') });
      return;
    }
    const grid = gridRef.current;
    grid?.finishEditing();
    const dirtyRows = (
      (grid?.collectionView?.sourceCollection ?? []) as { CRUD_TYPE?: string }[]
    ).filter(row => row.CRUD_TYPE);
    if (dirtyRows.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_No changes to save.') });
      return;
    }
    const src = (grid?.collectionView?.sourceCollection ?? []);
    const saveData = src.filter(item => item.CRUD_TYPE);
    saveWithValidation(saveData, staticColumns.main, mutate);
  };

  // admin 미등록(SCM_ADM_MNU_BTN_MPG_M 0 rows, design 01 DB 실측) 이면 hasButton 이 전부 false 를
  //   반환해 버튼이 노출되지 않는다 — 05_register.sql 적용 후 실제 동작한다.
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    save: hasButton('SAVE') ? handleSave : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    manual: false,
    upload: false,
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <WarehouseCapacityForm onSearch={handleSearch} onItemSearch={() => setOpenItem(true)} />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={activeSheet === 0 ? gridRef : itemMappingGridRef}
        gridFilter={activeSheet === 0 ? gridFilterRef : itemMappingGridFilterRef}
        dataCount={activeSheet === 0 ? rows.length : itemMappingRows.length}
        excelFileName='WarehouseCapacity'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
      />

      <div className={styles.tableWrapper}>
        <TabWrapper persist activeTabIndex={activeSheet} setActiveTabIndex={setActiveSheet}>
          <TabItem label={t('LBL00641', '_Warehouse Capacity')}>
            <WarehouseCapacityGrid
              rows={rows}
              gridRef={gridRef}
              gridFilterRef={gridFilterRef}
              editTrackerRef={trackerRef}
              adminColumns={staticColumns.main}
              onFocus={() => undefined}
            />
          </TabItem>
          <TabItem label={t('LBL01142', '_Warehouse Item Mapping')}>
            <WarehouseItemMappingGrid
              rows={itemMappingRows}
              gridRef={itemMappingGridRef}
              gridFilterRef={itemMappingGridFilterRef}
              editTrackerRef={itemMappingTrackerRef}
              adminColumns={staticColumns.itemMapping}
              divisionId={sc.divisionId}
              onFocus={() => undefined}
            />
          </TabItem>
        </TabWrapper>
      </div>

      {/* 조회영역 Item ID 팝업 — MaterialByDivisionModal(COM0013, design 02 §4.6 확정). */}
      <MaterialByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={itemIds => setSearchCondition({ itemId: itemIds })}
        preSearchParams={{ divisionId: sc.divisionId, scpModuleType: 'SCP0133' }}
      />
      {/* itemMappingRows 는 아직 SP 계약이 없어 setItemMappingRows 를 명시적으로 갱신하는 로직이
          없다 — Insert(GridAction.addRow)가 grid CollectionView 를 직접 조작하므로 로컬 상태는
          초기값만 제공한다(§6-9 확인 필요 해소 전 임시 배선). */}
    </>
  );
};
