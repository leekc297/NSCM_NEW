import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

import { IcGridColumnSetup } from '@foundation/assets';
import type { BUTTON_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { queryClient } from '@foundation/query-client';
import { type EditTracker, GridAction, isInsertRow } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { ProgressIndicator } from '@shared/lges';

import { SalesPriceModelGroupForm } from './components/SalesPriceModelGroupForm';
import { SalesPriceModelGroupGrid } from './components/SalesPriceModelGroupGrid';
import { SalesPriceModelGroupModals } from './components/SalesPriceModelGroupModals';
import { useSalesPriceModelGroupSave } from './hooks/useSalesPriceModelGroupSave';
import {
  MENU_ID,
  MODAL_KEY,
  MSG,
  PROC_ACTION,
  SCREEN_DIVISION,
  SEARCH_COMBO,
  SHEETS,
  SITE_EC_COMBO_ID,
} from './sales-price-model-group.constants';
import type { ExchangeRateRow, ModelGroupRow, PeriodAxisRow } from './sales-price-model-group.types';
import { useSalesPriceModelGroupStore } from './useSalesPriceModelGroupStore';
import { showAlert } from './utils/sales-price-model-group.util';
import { buildExchangeRateMap } from './utils/sales-price-model-group.util';
import {
  periodKeysOf,
  thisWeekMonday,
  weeksByMonthOf,
} from './utils/sales-price-model-group.util';
import { bundleKeyOf, cellOf, INSERT_GROUP_ID } from './utils/sales-price-model-group.util';

// DMF0083 Sales Price Model Group — 82 사업부 Model Group 단위 대표 판가 여부와 LOC 단가 (설계서 v8, 원천 DMF0020).
export const SalesPriceModelGroup = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid<ModelGroupRow> | null>(null);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);
  const editTrackerRef = useRef<EditTracker<ModelGroupRow> | undefined>(undefined);

  const initialized = useSalesPriceModelGroupStore(s => s.initialized);
  const searchParams = useSalesPriceModelGroupStore(s => s.searchParams);
  const filters = useSalesPriceModelGroupStore(s => s.filters);
  const openSearchArea = useSalesPriceModelGroupStore(s => s.openSearchArea);
  const staticColumns = useSalesPriceModelGroupStore(s => s.staticColumns);
  const originalStaticColumns = useSalesPriceModelGroupStore(s => s.originalStaticColumns);
  const staticMeasures = useSalesPriceModelGroupStore(s => s.staticMeasures);
  const setSearchParams = useSalesPriceModelGroupStore(s => s.setSearchParams);
  const setFilters = useSalesPriceModelGroupStore(s => s.setFilters);
  const clearFilters = useSalesPriceModelGroupStore(s => s.clearFilters);
  const setOpenSearchArea = useSalesPriceModelGroupStore(s => s.setOpenSearchArea);
  const fetchStaticColumns = useSalesPriceModelGroupStore(s => s.fetchStaticColumns);
  const fetchBatchColumns = useSalesPriceModelGroupStore(s => s.fetchBatchColumns);
  const fetchStaticMeasures = useSalesPriceModelGroupStore(s => s.fetchStaticMeasures);
  const fetchGridLayout = useSalesPriceModelGroupStore(s => s.fetchGridLayout);
  const restoreSearchConditions = useSalesPriceModelGroupStore(s => s.restoreSearchConditions);

  const division = searchParams.divisionId;
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  // 편집은 82 사업부에서만 (설계서 [사업부별 분기] G4). 저장 권한이 없으면 그리드가 스스로 잠긴다(saveAuth).
  const editable = division === SCREEN_DIVISION;

  // 진입 — 저장 조회조건 복원(1회), 사업부가 이미 있으면(탭 재진입) 메타를 다시 받는다.
  useEffect(() => {
    if (!initialized) void restoreSearchConditions();
    if (division) {
      void fetchGridLayout(division);
      void fetchStaticColumns(division);
      void fetchBatchColumns(division);
      void fetchStaticMeasures(division);
    }
  }, [tabId]); // eslint-disable-line react-hooks/exhaustive-deps

  // Div 기본값 = 권한 사업부에 82 가 있으면 82, 없으면 빈 값(설계서 O10).
  const [myDivisions] = useTabComboQueries({ filters: [SEARCH_COMBO.division] });
  useEffect(() => {
    if (division) return;
    const codes = (myDivisions ?? []).map(r => String(r.CODE ?? ''));
    if (codes.includes(SCREEN_DIVISION)) setSearchParams({ divisionId: SCREEN_DIVISION });
  }, [myDivisions, division, setSearchParams]);

  const applied = filters[SHEETS.MAIN];
  const { data, refetch, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: applied,
    enabled: !!applied,
  });

  // 기간 칸 뼈대(main / SPREAD_TITLE_DATE)와 환율(main / EXCHANGE_RATE) — 조회한 기간, 조회 전에는 조회조건 기간.
  const fromYyyymmdd = String(applied?.fromYyyymmdd ?? searchParams.fromYyyymmdd);
  const toYyyymmdd = String(applied?.toYyyymmdd ?? searchParams.toYyyymmdd);
  const axisFilters = useMemo(() => ({ fromYyyymmdd, toYyyymmdd }), [fromYyyymmdd, toYyyymmdd]);
  const { data: axisData } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    procedureAction: PROC_ACTION.SPREAD_TITLE_DATE as BUTTON_TYPE,
    tabId,
    filters: axisFilters,
    enabled: !!fromYyyymmdd && !!toYyyymmdd,
  });
  const exchangeFilters = useMemo(
    () => ({ divisionId: division, fromYyyymmdd, toYyyymmdd }),
    [division, fromYyyymmdd, toYyyymmdd]
  );
  const { data: exchangeData } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    procedureAction: PROC_ACTION.EXCHANGE_RATE as BUTTON_TYPE,
    tabId,
    filters: exchangeFilters,
    enabled: !!division && !!fromYyyymmdd && !!toYyyymmdd,
  });

  // 행 추가(GridAction.addRowSet)가 이 배열에 신규 행을 끼워 넣는다 — 조회 결과마다 새 배열을 만든다.
  const rows = useMemo<ModelGroupRow[]>(
    () => [...((data?.o_rc1 as unknown as ModelGroupRow[] | undefined) ?? [])],
    [data]
  );
  const axisRows = axisData?.o_rc1 as unknown as PeriodAxisRow[] | undefined;
  const periodKeys = useMemo(() => periodKeysOf(axisRows), [axisRows]);
  const weeksByMonth = useMemo(() => weeksByMonthOf(axisRows), [axisRows]);
  const rateMap = useMemo(
    () => buildExchangeRateMap(exchangeData?.o_rc1 as unknown as ExchangeRateRow[] | undefined),
    [exchangeData]
  );

  // Sales Site → End Customer 자동 입력 원천 (설계서 R46).
  const siteEcFilter = useMemo(() => ({ comboId: SITE_EC_COMBO_ID, divisionId: division }), [division]);
  const [siteEcRows] = useTabComboQueries({ filters: [siteEcFilter], enabled: !!division });
  const siteEndCustomerMap = useMemo(() => {
    const map = new Map<string, string>();
    for (const r of siteEcRows ?? []) {
      const name = String(r.NAME ?? '').trim();
      if (name && name !== '-') map.set(String(r.CODE ?? '').trim(), name);
    }
    return map;
  }, [siteEcRows]);

  const [insertCount, setInsertCount] = useState(0);
  const countInserted = () =>
    ((gridRef.current?.collectionView?.sourceCollection) ?? []).filter(
      isInsertRow
    ).length;

  // 그리드 비우기 — 사업부 변경 · 컬럼 설정 저장 뒤(SRCH-07, UI-08). 다시 조회는 Search 로만.
  const clearGrid = useCallback(() => {
    editTrackerRef.current?.clearChanges();
    clearFilters();
    queryClient.removeQueries({ queryKey: [tabId] });
    setInsertCount(0);
  }, [clearFilters, tabId]);
  const prevDivisionRef = useRef(division);
  useEffect(() => {
    if (prevDivisionRef.current === division) return;
    prevDivisionRef.current = division;
    clearGrid();
  }, [division, clearGrid]);

  const handleSearch = useCallback(() => {
    if (!division) return showAlert(t(MSG.REQUIRE_DIVISION, '_Division 을 선택하세요.'));
    if (searchParams.fromYyyymmdd > searchParams.toYyyymmdd) {
      return showAlert(t(MSG.PERIOD_INVERTED, '_조회 기간이 잘못되었습니다.'));
    }
    editTrackerRef.current?.clearChanges();
    setInsertCount(0);
    setFilters();
    void fetchStaticColumns(division);
    void fetchStaticMeasures(division);
  }, [division, searchParams, setFilters, fetchStaticColumns, fetchStaticMeasures, t]);

  // Insert Row — Measure 메타(KRW · USD · LOC) 한 묶음을 고른 행 묶음 위에 넣는다(설계서 B27).
  const handleInsert = () => {
    const g = gridRef.current;
    if (!g) return;
    const measures = staticMeasures[SHEETS.MAIN].map(m => m.colNm).filter(Boolean);
    const groupId = `I_${Date.now()}`;
    const newRows = measures.map(measure => ({
      [INSERT_GROUP_ID]: groupId,
      DIVISION_ID: division,
      DEPT_ID: '',
      END_CUSTOMER: '',
      SCM_SITE_ID: '',
      PROJECT_CODE: '',
      PROJECT_NAME: '',
      MDL_GR: '',
      PRC_RPSN: '',
      INCOTERMS: '',
      FCST_TYPE: '',
      CURRENCY: '',
      MDL_GR_EXIST: '',
      MEASURE: measure,
    }));
    GridAction.addRowSet(g as unknown as FlexGrid<WijmoRowItem>, newRows, 'above', {
      preserveMergeManager: true,
      groupKey: row => (isInsertRow(row) ? `I:${cellOf(row, INSERT_GROUP_ID)}` : `E:${bundleKeyOf(row)}`),
    });
    setInsertCount(countInserted());
  };

  // Remove — 신규 묶음만 지운다(설계서 B27, 해석 A). 저장된 단가는 LOC 를 0 으로 저장하면 삭제된다.
  const handleDelete = () => {
    const g = gridRef.current;
    if (!g) return;
    const selected = g.selectedItems as ModelGroupRow[];
    if (selected.length === 0 || !selected.every(isInsertRow)) {
      return showAlert(t(MSG.ONLY_NEW_DELETE, '_신규 입력 (Insert) 한 행만 삭제할 수 있습니다.'));
    }
    GridAction.removeRow(g as unknown as FlexGrid<WijmoRowItem>, true, true, {
      groupKey: row => cellOf(row, INSERT_GROUP_ID),
    });
    setInsertCount(countInserted());
  };

  const { handleSave, saving } = useSalesPriceModelGroupSave({
    gridRef,
    editTrackerRef,
    staticColumns: staticColumns[SHEETS.MAIN],
    weeksByMonth,
    rateMap,
    fromYyyymmdd,
    onSaved: () => {
      setInsertCount(0);
      void refetch();
    },
  });

  const [popupRow, setPopupRow] = useState<ModelGroupRow | null>(null);
  const [openProject, setOpenProject] = useState(false);
  const [openItem, setOpenItem] = useState(false);
  const [openColumnSetting, setOpenColumnSetting] = useState(false);
  const [openPriceBatch, setOpenPriceBatch] = useState(false);
  const handlePopupCellDblClick = useCallback((modalKey: string, row: ModelGroupRow) => {
    setPopupRow(row);
    if (modalKey === MODAL_KEY.PROJECT) setOpenProject(true);
    else if (modalKey === MODAL_KEY.ITEM) setOpenItem(true);
  }, []);

  const canSave = hasButton('SAVE', SHEETS.MAIN) && editable;
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') && editable ? handleInsert : false,
    delete: hasButton('DELETE') && editable ? handleDelete : false,
    save: canSave ? handleSave : false,
    // 설계서 grid-1 속성 "엑셀업로드 X" — 업로드 기능이 없는 화면이라 버튼을 그리지 않는다(AUTH-03 근거).
    upload: false,
    // 매뉴얼은 권한이 있을 때만 SubTitle 기본 동작(F1)을 쓴다 — 없으면 숨긴다.
    ...(hasButton('MANUAL') ? {} : { manual: false as const }),
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
        <SalesPriceModelGroupForm onSearch={handleSearch} hasInsertRows={insertCount > 0} />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef as never}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ModelGroupSalesPrice'
        useHotkey
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
        customButtons={[
          // 텍스트 버튼을 아이콘 버튼 앞에 둔다(UI-02). Price Batch Input = 편집 사업부 + main / SAVE 권한(설계서 L28).
          ...(canSave
            ? [
                {
                  label: t('LBL01274', '_Price Bulk Input'),
                  title: t('LBL01274', '_Price Bulk Input'),
                  action: () => setOpenPriceBatch(true),
                },
              ]
            : []),
          ...(hasButton('SEARCH', SHEETS.TITLE_SET)
            ? [
                {
                  label: t('LBL00605', '_Column Setting'),
                  title: t('LBL00605', '_Column Setting'),
                  action: () => setOpenColumnSetting(true),
                  iconComponent: <IcGridColumnSetup />,
                  buttonLabel: '',
                },
              ]
            : []),
        ]}
      />
      <SalesPriceModelGroupGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        data={rows}
        staticColumns={staticColumns[SHEETS.MAIN]}
        periodKeys={periodKeys}
        bucketType={searchParams.bucketType}
        divisionId={division}
        monday={thisWeekMonday()}
        rateMap={rateMap}
        siteEndCustomerMap={siteEndCustomerMap}
        onPopupCellDblClick={handlePopupCellDblClick}
      />
      <SalesPriceModelGroupModals
        columnSetting={{ open: openColumnSetting, close: () => setOpenColumnSetting(false) }}
        priceBatch={{ open: openPriceBatch, close: () => setOpenPriceBatch(false) }}
        projectCell={{ open: openProject, close: () => setOpenProject(false) }}
        itemCell={{ open: openItem, close: () => setOpenItem(false) }}
        popupRow={popupRow}
        gridRef={gridRef}
        editTrackerRef={editTrackerRef}
        divisionId={division}
        mainFromYyyymmdd={fromYyyymmdd}
        endCustomers={searchParams.endCustomers}
        staticColumns={staticColumns[SHEETS.MAIN]}
        originalStaticColumns={originalStaticColumns[SHEETS.MAIN]}
        onColumnSettingSaved={() => {
          clearGrid();
          void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
          void fetchGridLayout(division);
        }}
        onBatchSaved={() => {
          if (applied) void refetch();
        }}
      />
      <ProgressIndicator shape='circular' placement='parent' open={saving || isLoading || isFetching} />
    </>
  );
};
