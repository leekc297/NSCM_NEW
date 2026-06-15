import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  ColumnSettingModal,
  ItemByDivisionModal,
  ProjectByDivisionModal,
} from 'features/master/src/components';

import { MasterChgModal } from './components/modals/MasterChgModal';
import { MeasureSelectModal } from './components/modals/MeasureSelectModal';
import { MktForecastMasterForm } from './components/MktForecastMasterForm';
import { MktForecastMasterGrid, type ComboItem } from './components/MktForecastMasterGrid';
import { useMktForecastCellEditCascade } from './hooks/useMktForecastCellEditCascade';
import { useMktForecastMutation } from './hooks/useMktForecastMutation';
import { useMktForecastValidation } from './hooks/useMktForecastValidation';
import { MAIN_COLUMNS, MENU_ID, SHEETS } from './mkt-forecast-master.constants';
import type { MktFcstRow } from './mkt-forecast-master.types';
import { useMktForecastMasterStore } from './useMktForecastMasterStore';
import { markRowAsDeleted, markRowAsInserted } from './utils/crudTypeMarker';
import { longToPivot } from './utils/longToPivot';

import styles from './MktForecastMaster.module.scss';

// AS-IS DMF0003_1_MktFcst.cs (7,056줄, 메인 1순위) — 메인 화면
// Phase 1 ✅ : 메뉴 + 화면 진입 + 18-field SearchArea + 43 fixed cols 단순 조회
// Phase 2 ✅ : Edit/Insert/Delete/Save (60 validation) + Division 3-way 분기
// Phase 3 ⏳ : 동적 PIVOT 컬럼 + 117 expression (LockRange 80 + 합계 32 + SUM 헤더 5)
// Phase 4 ⏳ : Sub-Grid PSI/Car + Multi-sheet
// Phase 5 ⏳ : 5 신규 POPUP (MasterChg/PR/PRHistory/SspSync/SspSyncCompare)
// Phase 6 ⏳ : SSP 색상 + 8주 + Calc/Report
// Phase 7 ⏳ : 격차 G9/G10 + i18n 마무리 + 4축 매핑 100%
//
// 룰 25 §1.5.1 Button 10대 (CRUD 6 + Aux 4):
//   F5 Search / F7 Save / F8 Insert / F9 Delete / F12 Excel
//   F3 Sort / F4 Filter / F6 Condition / F10 Reset (자동)
export const MktForecastMaster = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGridType<MktFcstRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const userId = useSessionStore(state => state.session.userId);

  const sc = useMktForecastMasterStore(s => s.searchCondition);
  const filters = useMktForecastMasterStore(s => s.filters);
  const setFilter = useMktForecastMasterStore(s => s.setFilter);
  const openSearchArea = useMktForecastMasterStore(s => s.openSearchArea);
  const setOpenSearchArea = useMktForecastMasterStore(s => s.setOpenSearchArea);
  // 사용자 명시 요구 (2026-06-07): popup 에서 선택된 Measure 만 grid 표시
  const selectedMeasures = useMktForecastMasterStore(s => s.selectedMeasures);
  const setSelectedMeasures = useMktForecastMasterStore(s => s.setSelectedMeasures);

  const validate = useMktForecastValidation();
  const { saveRows } = useMktForecastMutation();

  // 신규/수정 행 추적 (CRUD_TYPE) — SP 결과와 합쳐 grid itemsSource
  const [insertedRows, setInsertedRows] = useState<MktFcstRow[]>([]);

  // 사용자 명시 요구 (2026-06-07): Measure 선택 / Grid Column 선택 / Master Change modal
  const [openMeasureSelect, setOpenMeasureSelect] = useState(false);
  const [openColumnSelect, setOpenColumnSelect] = useState(false);
  const [openMasterChg, setOpenMasterChg] = useState(false);
  // 사용자 명시 요구 (2026-06-07): Insert popup cell — Project / Item modal
  const [openProjectModal, setOpenProjectModal] = useState(false);
  const [openItemModal, setOpenItemModal] = useState(false);
  // popup 호출 시 어느 row 의 어느 column 을 편집 중인지 기억
  const editingPopupRowRef = useRef<{ row: MktFcstRow; binding: string } | null>(null);

  // 메인 GET SP — SCM_MGR.DMF0003_GET_MKT_FCST_DATA (22 IN + 4 OUT)
  const { data, refetch, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const loading = isLoading || isFetching;

  // 사용자 명시 요구 (2026-06-07): Insert cell dropdown 정밀 적용
  //   자매 DMF0020 SalesFuturePriceFlexGrid 패턴 동등 — 자매 검증 SQL_ID + column binding 별 직접 매핑
  const [
    endCustomersData,
    sitesData,
    incotermsData,
    fcstTypeData,
    customsHandbookData,
    plantSiteData,
    measureData,
  ] = useTabComboQueries({
    filters: [
      'EndCustomerByDivisionDept',                                  // 자매 DMF0020 검증 SQL
      'SiteByEndCustomer',                                          // 자매 DMF0020 검증 SQL
      'Incoterms',
      { comboId: 'FcstType', divisionId: sc.divisionId },           // @divisionId 명시 필수
      { comboId: 'CustomsHandbook', divisionId: sc.divisionId },    // @divisionId 명시 필수
      'PlantSite',
      'Measure',
    ] as never,
  });

  // 자매 DMF0020 dataMaps 패턴 — column binding 별 직접 매핑 (`_comboKey` 우회)
  //   Grid 의 useEffect 가 col.binding 으로 직접 comboData[binding] 조회 → dataMap 적용
  const comboData: Record<string, ComboItem[]> = useMemo(() => ({
    END_CUSTOMER:   (endCustomersData    ?? []) as unknown as ComboItem[],
    SCM_SITE_ID:    (sitesData           ?? []) as unknown as ComboItem[],
    INCOTERMS:      (incotermsData       ?? []) as unknown as ComboItem[],
    FCST_TYPE:      (fcstTypeData        ?? []) as unknown as ComboItem[],
    DOM_EXP:        (customsHandbookData ?? []) as unknown as ComboItem[],
    PLANT_SITE_ID:  (plantSiteData       ?? []) as unknown as ComboItem[],
    MEASURE:        (measureData         ?? []) as unknown as ComboItem[],
  }), [endCustomersData, sitesData, incotermsData, fcstTypeData, customsHandbookData, plantSiteData, measureData]);

  // 화면 진입 자동 조회 (AS-IS Form_Load → InitControls → FindData)
  useEffect(() => {
    if (!filters[SHEETS.MAIN] && sc.divisionId) setFilter();
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId]);

  // 사용자 명시 요구 (2026-06-07): Measure 선택 상태를 화면 close/reopen 후에도 유지
  //   store 의 createPersistedStoreWithTab 은 sessionStorage (tabId 별) → tab close 시 사라짐
  //   localStorage 로 별도 persist — 화면 재오픈 시 복원 (tabId 무관, 동일 사용자)
  //
  //   ⚠️ useEffect 2 (변경 감지 → setItem) 패턴은 mount 시 default 값으로 saved 덮어쓰기 사고 발생
  //   → 명시적 callback 안에서만 localStorage 저장 (handleMeasureApply)
  const MEASURES_LS_KEY = 'mkt-forecast-selected-measures';
  // mount 시 localStorage 복원 (1회만)
  useEffect(() => {
    try {
      const saved = localStorage.getItem(MEASURES_LS_KEY);
      if (saved) {
        const parsed = JSON.parse(saved) as unknown;
        if (Array.isArray(parsed) && parsed.length > 0 && parsed.every(x => typeof x === 'string')) {
          setSelectedMeasures(parsed as string[]);
        }
      }
    } catch { /* noop */ }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);
  // Measure popup 적용 시 store update + localStorage 동시 저장
  const handleMeasureApply = (measures: string[]) => {
    setSelectedMeasures(measures);
    try {
      localStorage.setItem(MEASURES_LS_KEY, JSON.stringify(measures));
    } catch { /* noop */ }
  };

  // cellEditEnded cascade — CRUD_TYPE marker (Phase 2)
  const { handleCellEditEnded } = useMktForecastCellEditCascade({
    gridRef: gridRef as React.RefObject<FlexGridType<MktFcstRow> | null>,
  });

  // F5 Search — AS-IS L957 FindButton override
  const handleSearch = () => {
    const v = validate.validateFind(sc);
    if (!v.ok) return;
    void setToast({ message: '조회 중입니다...', type: 'default', duration: 2000 });
    setFilter();
    refetch?.();
    setInsertedRows([]);
  };

  // F8 Insert — AS-IS L964 InsertButton override → InsertRow (DefColumns Main fixed cols 신규 row)
  //   사용자 명시 요구 (2026-06-07): 추가된 row 로 grid scroll + 자동 select
  const handleInsert = () => {
    const newRow = markRowAsInserted({
      DIVISION_ID: sc.divisionId,
      DEPT_ID: '',
      DEPT_NAME_KO: '',
      TEAM_ID: '',
      TEAM_NAME_KO: '',
      END_CUSTOMER: '',
      BIZ_TYPE: '',
      SCM_SITE_ID: '',
      PLANT_SITE_ID: '',
      PROJECT_CODE: '',
      PROJECT_CODE_NAME: '',
      PROJECT_OWNER: '',
      ITEM_ID: '',
      NICK_NAME: '',
      INCOTERMS: '',
      FCST_TYPE: '',
      DOM_EXP: '',
      MEASURE: 'MKT_FCST',
      YYYYMMDD: sc.startYyyymmdd,
      QTY: 0,
    });
    setInsertedRows(prev => [newRow, ...prev]);
    // 신규 row 는 list 최상단 (index 0) — render 후 scroll + select + 첫 editable cell edit mode
    //   DIVISION_ID 는 read-only ('S') → END_CUSTOMER (첫 editable col) 로 startEditing
    setTimeout(() => {
      const g = gridRef.current;
      if (!g) return;
      try {
        g.scrollIntoView(0, 0);
        // 첫 editable col 찾기 (IM/IO type)
        let firstEditableCol = 0;
        for (let i = 0; i < g.columns.length; i++) {
          const binding = g.columns[i].binding ?? '';
          const meta = MAIN_COLUMNS.find(m => m.key === binding);
          if (meta && (meta._inputEditType === 'IM' || meta._inputEditType === 'IO')) {
            firstEditableCol = i;
            break;
          }
        }
        g.select(0, firstEditableCol);
        g.startEditing(true, 0, firstEditableCol);
      } catch { /* noop */ }
    }, 50);
  };

  // 사용자 명시 요구 (2026-06-07): popup cell 더블클릭 → modal 호출
  const handlePopupCellDblClick = (row: MktFcstRow, modalKey: string, binding: string) => {
    editingPopupRowRef.current = { row, binding };
    if (modalKey === 'ProjectByDivision') setOpenProjectModal(true);
    else if (modalKey === 'ItemByDivision') setOpenItemModal(true);
  };

  // popup modal setSelectedValue callback — row column update + cascade (PROJECT_CODE_NAME / PROJECT_OWNER 자동)
  const handleProjectSelected = (selected: { PROJECT_CODE?: string; PROJECT_NAME?: string; PROJECT_OWNER?: string; BIZ_TYPE?: string } | null) => {
    const target = editingPopupRowRef.current;
    if (!target || !selected) return;
    Object.assign(target.row, {
      PROJECT_CODE:      selected.PROJECT_CODE ?? '',
      PROJECT_CODE_NAME: selected.PROJECT_NAME ?? '',
      PROJECT_OWNER:     selected.PROJECT_OWNER ?? '',
      BIZ_TYPE:          selected.BIZ_TYPE ?? '',
    });
    gridRef.current?.refresh(false);
  };

  const handleItemSelected = (selected: { ITEM_ID?: string; ITEM_NAME?: string; NICK_NAME?: string } | null) => {
    const target = editingPopupRowRef.current;
    if (!target || !selected) return;
    Object.assign(target.row, {
      ITEM_ID:   selected.ITEM_ID ?? '',
      ITEM_NAME: selected.ITEM_NAME ?? '',
      NICK_NAME: selected.NICK_NAME ?? '',
    });
    gridRef.current?.refresh(false);
  };

  // F9 Delete — AS-IS L969 DeleteButton override (신규 row 만 제거, 기존 row 는 'D' marker)
  const handleDelete = () => {
    const g = gridRef.current;
    if (!g) return;
    const sel = g.selectedItems[0] as MktFcstRow | undefined;
    if (!sel) {
      void setAlert({ type: 'alert', content: '[MSG00113] 삭제할 행을 선택하세요.' });
      return;
    }
    // 신규 row ('I') 는 insertedRows 에서 제거
    if (sel.EDIT_FLAG === 'I') {
      setInsertedRows(prev => prev.filter(r => r !== sel));
      return;
    }
    // 기존 row 는 'D' marker (실제 삭제는 Save 시 SP 호출)
    const deleted = markRowAsDeleted(sel);
    Object.assign(sel, deleted);
    g.refresh(false);
  };

  // F7 Save — AS-IS L1392 SaveButton override → SaveData
  const handleSave = async () => {
    const spRows = (((data as { o_rc1?: MktFcstRow[] })?.o_rc1 ?? []) as unknown as MktFcstRow[]);
    const allRows = [...insertedRows, ...spRows];
    const modifiedRows = allRows.filter(r => r.EDIT_FLAG === 'I' || r.EDIT_FLAG === 'U' || r.EDIT_FLAG === 'D');

    const v = validate.validateSaveRows(modifiedRows, sc);
    if (!v.ok) return;

    const ok = await setAlert({ type: 'confirm', content: '[MSG00004] 저장하시겠습니까?' });
    if (!ok) return;

    void setToast({ message: '저장 중입니다...', type: 'default', duration: 3000 });

    const result = await saveRows(modifiedRows, {
      userId: userId ?? 'admin',
      bucketType: sc.bucketType,
      asFromSite: sc.asFromSite ? 'Y' : 'N',
    });

    if (result.ok) {
      setInsertedRows([]);
      refetch?.();
    }
  };

  // F3 Sort — 사용자 명시 요구 (2026-06-07): button 클릭 시 동작
  const handleSort = () => {
    const g = gridRef.current;
    if (g) GridAction.toggleColumnSort(g);
  };
  // F4 Filter — 사용자 명시 요구 (2026-06-07): F4 버튼 누름 시 Grid 에 filter 적용
  //   처음 누름 — FlexGridFilter 생성 (column header 에 filter icon 표시)
  //   두번째 누름 부터 — current column 의 filter editor toggle
  const handleFilter = () => {
    const g = gridRef.current;
    if (!g) return;
    if (!gridFilterRef.current) {
      // 처음 누름 — attach
      gridFilterRef.current = new FlexGridFilter(g);
      return;
    }
    GridAction.toggleColumnFilter(g, gridFilterRef.current);
  };

  // Button 10대 hotkey 매핑 (Phase 2 ✅ F5/F7/F8/F9 활성)
  const hotkeyConfig: HotkeyConfig = {
    search: handleSearch,
    insert: handleInsert,
    save: handleSave,
    delete: handleDelete,
    sort: handleSort,
    filter: handleFilter,
    manual: false,
    upload: false,
    // F12 Excel : SubTitle 자동
    // F6 Condition / F10 Reset : SubTitle DefaultButtonActions (생략 = 자동)
  };

  // SP long format (row 별 YYYYMMDD + QTY) → wide PIVOT (D_/W_/M_YYYYMMDD column 별 QTY 채움)
  // 사용자 명시 요구 (2026-06-07): selectedMeasures 만 grid 표시 (popup 으로 사용자 선택 가능)
  const spRows = (((data as { o_rc1?: MktFcstRow[] })?.o_rc1 ?? []) as unknown as MktFcstRow[]);
  const filteredSpRows = spRows.filter(r => selectedMeasures.includes(String(r.MEASURE ?? '')));
  const pivotedRows = ((): MktFcstRow[] => {
    if (filteredSpRows.length === 0) return [];
    return longToPivot(filteredSpRows as never, sc.bucketType as 'D' | 'W' | 'M');
  })();
  const rows: MktFcstRow[] = [...insertedRows, ...pivotedRows];

  return (
    <div className={styles.container}>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />

      {openSearchArea && (
        <MktForecastMasterForm onSearch={handleSearch} />
      )}

      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='MktForecastMaster'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        customButtons={[
          { label: '⊞', title: 'Grid 항목 표시 (AS-IS btnColumn_Click)', action: () => setOpenColumnSelect(true) },
          { label: '⊟', title: 'Measure 선택 (AS-IS btnMeasure_Click)', action: () => setOpenMeasureSelect(true) },
        ]}
        searchParam={sc}
      />

      {/* Phase 5 — Grid Column 선택 (공용 ColumnSettingModal) */}
      <ColumnSettingModal
        open={openColumnSelect}
        modalClose={() => setOpenColumnSelect(false)}
        menuId={MENU_ID}
        sheetName='main'
        columnType='main'
        divisionId={sc.divisionId}
        fallbackColumns={MAIN_COLUMNS.filter(c => c.visible !== false).map(c => ({ key: c.key, header: c.header, width: c.width }))}
        onSave={() => { /* SCM_MST_TITLESET_USER 영구 저장 */ }}
      />

      {/* Phase 5 — MasterChg modal */}
      <MasterChgModal
        open={openMasterChg}
        onClose={() => setOpenMasterChg(false)}
        divisionId={sc.divisionId}
      />

      {/* Phase 6 — Measure 선택 modal (AS-IS btnMeasure_Click) */}
      <MeasureSelectModal
        open={openMeasureSelect}
        onClose={() => setOpenMeasureSelect(false)}
        defaultSelected={selectedMeasures}
        onApply={handleMeasureApply}
        divisionId={sc.divisionId}
      />

      {/* Insert Project popup (AS-IS cellTypeImage Project — L1865) */}
      <ProjectByDivisionModal
        open={openProjectModal}
        modalClose={() => setOpenProjectModal(false)}
        preSearchParams={{
          divisionId: sc.divisionId,
          deptId: 'ALL',
          endCustomer: 'ALL',
          salesSite: 'ALL',
          projectCode: '',
        } as never}
        callFromCell={true}
        setSelectedValue={(project: string, projectName?: string, _projectStatus?: string, bizTypeName?: string) => {
          handleProjectSelected({
            PROJECT_CODE: project,
            PROJECT_NAME: projectName,
            BIZ_TYPE: bizTypeName,
          });
        }}
      />

      {/* Insert Item popup (AS-IS cellTypeImage ItemId / ItemId40 — L1867 / L1874) */}
      <ItemByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        preSearchParams={{
          divisionId: sc.divisionId,
          deptId: 'ALL',
          endCustomer: 'ALL',
          salesSite: 'ALL',
          projectCode: '',
          itemId: '',
        } as never}
        callFromCell={true}
        setSelectedValue={(items: string, itemName?: string, _itemType?: string) => {
          handleItemSelected({
            ITEM_ID: items,
            ITEM_NAME: itemName,
            NICK_NAME: itemName,
          });
        }}
      />

      <div className={styles.gridWrap}>
        {loading
          ? <div style={{ padding: 16, color: '#1976d2' }}>⏳ 조회 중입니다...</div>
          : <MktForecastMasterGrid
              rows={rows}
              gridRef={gridRef as never}
              gridFilterRef={gridFilterRef as never}
              divisionId={sc.divisionId}
              searchCondition={sc}
              onCellEditEnded={handleCellEditEnded as never}
              comboData={comboData}
              onPopupCellDblClick={handlePopupCellDblClick}
            />
        }
      </div>
    </div>
  );
};
