import { type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import {
  useProcMutation,
  useSaveWithValidation,
  useTabBtnPermissions,
  useTabProcQuery,
} from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ErpEdiMasterForm } from './components/ErpEdiMasterForm';
import { ErpEdiMasterRepairGrid } from './components/ErpEdiMasterRepairGrid';
import { ErpEdiMasterSalesSiteGrid } from './components/ErpEdiMasterSalesSiteGrid';
import { ErpEdiMasterSspmGrid } from './components/ErpEdiMasterSspmGrid';
import { ErpEdiMasterSummaryGrid } from './components/ErpEdiMasterSummaryGrid';
import { MENU_ID, SHEETS, SHEET_INDEX } from './erp-edi-master.constants';
import { EMPTY_SALES_SITE_ROW, EMPTY_SSPM_ROW } from './erp-edi-master.empty-rows';
import styles from './ErpEdiMaster.module.scss';
import { useErpEdiMasterStore } from './useErpEdiMasterStore';

// AS-IS DMF0008_ErpEdiMaster — 3단 구조:
//   [검색] Division (Form)
//   [1단] Summary    : DMF0008_GET_EDI_MST_SUMMARY (sheet 'summary' — BE 메타 cross-check 2026-06-10)
//   [2단] Repair     : DMF0008_GET_EDI_MST_REPAIR  (sheet 'repair')
//   [3단 2 tab] Sub  : Sales Site / SSPM
//
// 룰 v2 _tobe/01_file_structure.md §1.5 + hook components-folder-pattern.md (2026-06-09):
//   진입 페이지 = composition + layout 만. 4 grid + Form 은 components/ sub-component.
//   메모리 feedback_grid_no_hardcoded_static_columns: column 정의는 store.staticColumns (BE 메타 GET).
// 2026-06-10 사용자 요구: 버튼 영역 UpdateHistoryBar (Update Start/End/By) 삭제.
const ErpEdiMaster = ({ tabId, title }: PageProps<MENU_ID>) => {
  const summaryGridRef = useRef<FlexGridType<ResponseData<MENU_ID, SHEETS.SUMMARY>>>();
  const repairGridRef = useRef<FlexGridType<ResponseData<MENU_ID, SHEETS.REPAIR>>>();
  const salesSiteGridRef =
    useRef<FlexGridType<ResponseData<MENU_ID, SHEETS.SALES_SITE, 'o_rc1'>>>();
  const sspmGridRef = useRef<FlexGridType<ResponseData<MENU_ID, SHEETS.SSPM>>>();
  const summaryFilterRef = useRef<FlexGridFilter>();
  const repairFilterRef = useRef<FlexGridFilter>();
  const salesSiteFilterRef = useRef<FlexGridFilter>();
  const sspmFilterRef = useRef<FlexGridFilter>();

  // DMF0004 표준 store hooks
  const filters = useErpEdiMasterStore(s => s.filters);
  const initialized = useErpEdiMasterStore(s => s.initialized);
  const searchParams = useErpEdiMasterStore(s => s.searchParams);
  const setSearchParams = useErpEdiMasterStore(s => s.setSearchParams);
  const setSummaryFilters = useErpEdiMasterStore(s => s.setSummaryFilters);
  const setRepairFilter = useErpEdiMasterStore(s => s.setRepairFilter);
  const setSubFilter = useErpEdiMasterStore(s => s.setSubFilter);
  const setSalesSiteFilters = useErpEdiMasterStore(state => state.setSalesSiteFilters);
  const setSspmFilters = useErpEdiMasterStore(state => state.setSspmFilters);
  const repairContext = useErpEdiMasterStore(state => state.repairContext);
  const setRepairContext = useErpEdiMasterStore(state => state.setRepairContext);
  const openSearchArea = useErpEdiMasterStore(s => s.openSearchArea);
  const setOpenSearchArea = useErpEdiMasterStore(s => s.setOpenSearchArea);
  const fetchStaticColumns = useErpEdiMasterStore(state => state.fetchStaticColumns);
  const staticColumns = useErpEdiMasterStore(state => state.staticColumns);

  // ⭐ master hook §3 / child hook menu-button-dynamic-fetch §2.1 —
  //   admin SYS0009 Menu Button (`SCM_ADM_MNU_BTN_MPG_M` USE_YN + `USER_GR_MNU_BTN_MPG_M` 권한) 동적 fetch.
  //   하드코딩 hotkeyConfig 금지 — admin USE_YN='N' 즉시 반영 보장.
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const { t } = useTranslation();

  const setAlert = useMessageStore(s => s.setAlert);
  const setToast = useMessageStore(s => s.setToast);

  const { saveWithValidation } = useSaveWithValidation();

  const [activeGrid, setActiveGrid] = useState(summaryGridRef);
  const [activeGridFilter, setActiveGridFilter] = useState(summaryFilterRef);
  const [activeTab, setActiveTab] = useState<SHEET_INDEX>(SHEET_INDEX.SALES_SITE);

  const { data: summaryData } = useTabProcQuery<MENU_ID, SHEETS.SUMMARY>({
    menuId: MENU_ID,
    sheetName: SHEETS.SUMMARY,
    tabId,
    filters: filters[SHEETS.SUMMARY],
    enabled: !!filters[SHEETS.SUMMARY],
  });

  const { data: repairData } = useTabProcQuery<MENU_ID, SHEETS.REPAIR>({
    menuId: MENU_ID,
    sheetName: SHEETS.REPAIR,
    tabId,
    filters: filters[SHEETS.REPAIR],
    enabled: !!filters[SHEETS.REPAIR],
  });

  const { data: salesSiteData } = useTabProcQuery<MENU_ID, SHEETS.SALES_SITE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SALES_SITE,
    tabId,
    filters: filters[SHEETS.SALES_SITE],
    enabled: !!filters[SHEETS.SALES_SITE],
  });

  const { data: sspmData } = useTabProcQuery<MENU_ID, SHEETS.SSPM>({
    menuId: MENU_ID,
    sheetName: SHEETS.SSPM,
    tabId,
    filters: filters[SHEETS.SSPM],
    enabled: !!filters[SHEETS.SSPM],
  });

  // ⭐ 2026-06-17 사용자 요구 — Last Update Start/End 데이터 표시.
  //   AS-IS .cs L2918: DMF0000_GET_UPDATE_HISTORY (SDATE/EDATE/UPDATED_BY).
  //
  // useTabProcQuery 우회 — apiClient.post 직접 호출 + try/catch silent.
  //   사유: useTabProcQuery 가 BE 응답 401/403/-9994 시 자동 alert 표시 → 화면 진입 시
  //   권한 없음 alert 3회 사고 (2026-06-17 사용자 보고).
  //   UpdateHistory 는 부가 정보 → 메타 미등록 시 silent fail (UI 영향 없음).
  //
  // ⭐ 2026-06-17 fix — 응답 구조 `result.o_rc1[0]` 정확 처리.
  //   SP body 의 OUT cursor 이름이 O_RC1 → BE 응답 key = 'o_rc1'.
  //   이전 코드는 `result` 자체를 array 로 처리 → 데이터 못 받음 사고.
  const setUpdateHistory = useErpEdiMasterStore(state => state.setUpdateHistory);
  const refetchUpdateHistory = async (): Promise<void> => {
    try {
      const res = await apiClient.post<{
        o_rc1?: Array<{ SDATE?: string; EDATE?: string; UPDATED_BY?: string }>;
      }>(`/${MENU_ID}/${SHEETS.UPDATE_HISTORY}/SEARCH/call-proc`, { menuId: MENU_ID });
      const rows = (res.data?.result?.o_rc1 ?? []) as Array<{
        SDATE?: string;
        EDATE?: string;
        UPDATED_BY?: string;
      }>;
      if (rows[0]) setUpdateHistory(rows[0]);
    } catch {
      // silent — 권한 미등록 / 메타 미등록 시 무시 (UpdateHistory 는 부가 정보)
    }
  };
  useEffect(() => {
    void refetchUpdateHistory();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const { mutate: mutateSalesSite } = useProcMutation<MENU_ID, SHEETS.SALES_SITE, 'o_rc1'>({
    menuId: MENU_ID,
    sheetName: SHEETS.SALES_SITE,
    tabId,
    onSuccess: () => {
      setSalesSiteFilters({
        divisionId: repairContext?.division ?? '',
        soldTo: repairContext?.erpSoldTo ?? '',
        shipTo: repairContext?.erpShipTo ?? '',
        scmSiteId: repairContext?.gscmSalesSiteId ?? '',
      });
    },
  });

  const { mutate: mutateSspm } = useProcMutation<MENU_ID, SHEETS.SSPM, 'o_rc1'>({
    menuId: MENU_ID,
    sheetName: SHEETS.SSPM,
    tabId,
    onSuccess: () => {
      setSspmFilters({
        divisionId: repairContext?.division ?? '',
        itemId: repairContext?.erpItemId ?? '',
        scmSiteId: repairContext?.gscmSalesSiteId ?? '',
      });
      void setAlert({
        type: 'alert',
        content: t('', '_데이터가 저장되었습니다.'),
      });
    },
  });

  // 진입 시 fetchStaticColumns 1회 (메모리 feedback_fetchstaticcolumns_no_initialized_guard)
  useEffect(() => {
    void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // initialized 후 summary/repair filters 자동 세팅
  useEffect(() => {
    if (initialized && !filters[SHEETS.SUMMARY]) setSummaryFilters();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [initialized]);

  // AS-IS btnStatusUpdate_Click (.cs L2996~3057) 1:1 매핑:
  //   L3000-3001: Repair / Sub grid Rows.Clear → repairContext clear (filters reset 효과)
  //   L3027: SP "DM.PR_DM_DNM_EDI_CALLOFF_STATUS" 실행
  //   L3052: FindData_Main() 재조회 = Summary + Repair refetch (setSummaryFilters 동등)
  //   L3055: GetUpdateHistory() 재조회 = Update Start/End refetch
  const handleStatusUpdate = async () => {
    try {
      // ⭐ 2026-06-17 fix — URL 의 sheet 명 'summary' → 'main' (BE 메타 040 file 등록 기준).
      //   기존 'summary' 호출 시 BE 메타 미등록 → SP 호출 실패 → SCM_SYS_LOG_BATCH 에 row INSERT 안 됨
      //   → UpdateHistory 결과 NULL 사고 (2026-06-17 사용자 보고).
      await apiClient.post(`/${MENU_ID}/main/STATUS_UPDATE/call-proc`, {});
      setToast({ type: 'success', message: 'Status Update 완료. 재조회합니다.' });
      // L3000-3001: Sub grid clear (선택된 repair row 정보 reset)
      setRepairContext(undefined);
      // L3052: Summary + Repair refetch
      setSummaryFilters();
      // L3055: UpdateHistory refetch
      void refetchUpdateHistory?.();
    } catch (e) {
      const msg = e instanceof Error ? e.message : 'Status Update 실패';
      void setAlert({ type: 'alert', content: msg });
    }
  };

  // SummaryGrid onDblClick: (sFlag, division, senderName)
  const handleSummaryDoubleClick = (sFlag: string, _division: string, senderName: string) => {
    setSearchParams({ senderName, flag: sFlag });
    setRepairFilter();
    setRepairContext(undefined);
  };

  // RepairGrid onDblClick: (col, row)
  const handleRepairDoubleClick = (_col: number, row: ResponseData<MENU_ID, SHEETS.REPAIR>) => {
    setSearchParams({
      selectedSoldTo: String(row.ERP_SOLDTO ?? ''),
      selectedShipTo: String(row.ERP_SHIPTO ?? ''),
      selectedItemId: String(row.ERP_ITEM_ID ?? ''),
      selectedScmSiteId: String(row.GSCM_SALES_SITE_ID ?? ''),
    });
    setSubFilter();
    const ctx = {
      division: row.DIVISION_ID,
      senderName: row.EDI_SENDER_NAME,
      flag: filters[SHEETS.REPAIR]?.flag ?? '',
      erpSoldTo: row.ERP_SOLDTO,
      erpShipTo: row.ERP_SHIPTO,
      erpItemId: row.ERP_ITEM_ID,
      gscmSalesSiteId: row.GSCM_SALES_SITE_ID,
      activeSs: row.ACTIVE_SS,
      gscmSspm: row.GSCM_SSPM,
    };
    setRepairContext(ctx);
  };

  const handleInsert = () => {
    if (!repairContext) return;
    if (
      (useSessionStore.getState().session as { groupId?: string } | undefined)?.groupId ===
      'SCP Planner'
    ) {
      void setAlert({
        type: 'alert',
        content: t('MSG00096', '사용 권한이 없습니다.'),
      });
      return;
    }

    if (activeTab === SHEET_INDEX.SALES_SITE) {
      if (!salesSiteGridRef.current) return;
      GridAction.addRow(salesSiteGridRef.current, {
        ...EMPTY_SALES_SITE_ROW,
        DIVISION_ID: repairContext.division,
        REP_SOLDTO_CODE: repairContext.erpSoldTo,
        REP_SHIPTO_CODE: repairContext.erpShipTo,
      });
    } else {
      if (!sspmGridRef.current) return;
      GridAction.addRow(sspmGridRef.current, {
        ...EMPTY_SSPM_ROW,
        DIVISION_ID: repairContext.division,
        SOLDTO_CODE: repairContext.erpSoldTo,
        SHIPTO_CODE: repairContext.erpShipTo,
        ITEM_ID: repairContext.erpItemId,
      });
    }
  };

  const handleSave = () => {
    if (activeTab === SHEET_INDEX.SALES_SITE) {
      const saveData = salesSiteData?.o_rc1?.filter?.(item => item.CRUD_TYPE) ?? [];
      saveWithValidation(saveData, staticColumns[SHEETS.SALES_SITE], mutateSalesSite);
    } else {
      const saveData = sspmData?.o_rc1?.filter?.(item => item.CRUD_TYPE) ?? [];
      saveWithValidation(saveData, staticColumns[SHEETS.SSPM], mutateSspm);
    }
  };

  // ⭐ master hook §3 / child hook menu-button-dynamic-fetch §2.1 —
  //   `hasButton(BTN_CD)` 조건부 callback. admin 이 SYS0009 에서 USE_YN='N' 또는
  //   사용자 그룹 권한 박탈 시 즉시 비활성 (hotkey 무효).
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? setSummaryFilters : false,
    save: hasButton('SAVE') ? handleSave : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    delete: false,
    condition: false,
    resetCondition: false,
    manual: false,
    upload: false,
  };

  // ⭐ 사용자 명시 — 'Status Update' 버튼 항상 노출 (DMF0043 동일 정책).
  const customButtons = useMemo(
    () => [
      {
        label: 'Status Update',
        action: () => void handleStatusUpdate(),
      },
    ],
    // eslint-disable-next-line react-hooks/exhaustive-deps
    []
  );

  // Wijmo FlexGrid Array 가드 + null filter (룰 12 §11.5)
  const safeRows = <T,>(data: unknown): T[] => {
    if (!Array.isArray(data)) return [];
    return data.filter((r): r is T => r != null && typeof r === 'object');
  };
  const summaryRows = useMemo(
    () => safeRows<ResponseData<MENU_ID, SHEETS.SUMMARY>>(summaryData?.o_rc1),
    [summaryData]
  );
  const repairRows = useMemo(
    () => safeRows<ResponseData<MENU_ID, SHEETS.REPAIR>>(repairData?.o_rc1),
    [repairData]
  );
  const salesSiteRows = useMemo(
    () =>
      safeRows<ResponseData<MENU_ID, SHEETS.SALES_SITE, 'o_rc1'>>(
        salesSiteData?.o_rc1 ?? salesSiteData?.o_rc1
      ),
    [salesSiteData]
  );
  const sspmRows = useMemo(
    () => safeRows<ResponseData<MENU_ID, SHEETS.SSPM>>(sspmData?.o_rc1),
    [sspmData]
  );

  // AS-IS .cs L861: TotalCount = ds.Tables[0].Compute("SUM(CNT)", "")
  const repairTotal = useMemo(
    () => repairRows.reduce((sum, r) => sum + (Number(r.CNT) || 0), 0),
    [repairRows]
  );

  useEffect(() => {
    if (activeTab === SHEET_INDEX.SALES_SITE) {
      setActiveGrid(salesSiteGridRef as never);
      setActiveGridFilter(salesSiteFilterRef as never);
    } else {
      setActiveGrid(sspmGridRef as never);
      setActiveGridFilter(sspmFilterRef as never);
    }
  }, [activeTab]);

  return (
    <div className={styles.container}>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <ErpEdiMasterForm />

      <SubTitle
        menuId={MENU_ID}
        grid={activeGrid}
        gridFilter={activeGridFilter}
        dataCount={summaryRows.length}
        excelFileName='ErpEdiMaster'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
        customButtons={customButtons}
      />

      {/* 1단 — Summary (flex-grow 3 = 30%) */}
      <div className={styles.summarySection}>
        <div className={styles.sectionTitle}>Summary</div>
        <ErpEdiMasterSummaryGrid
          gridRef={summaryGridRef}
          gridFilterRef={summaryFilterRef}
          data={summaryRows}
          onDblClick={handleSummaryDoubleClick}
        />
      </div>

      {/* 2단 — Repair (flex-grow 3 = 30%) — 2026-06-17 사용자 요구: Total 수량 숨김 */}
      <div className={styles.repairSection}>
        <div className={styles.sectionTitle}>Repair</div>
        <ErpEdiMasterRepairGrid
          gridRef={repairGridRef}
          gridFilterRef={repairFilterRef}
          data={repairRows}
          onDblClick={handleRepairDoubleClick}
        />
      </div>

      {/* 3단 — Tab (flex-grow 4 = 40%): Sales Site / SSPM */}
      <div className={styles.subSection}>
        <TabWrapper
          persist
          activeTabIndex={activeTab}
          setActiveTabIndex={setActiveTab as (idx: number) => void}
        >
          <TabItem label='Sales Site'>
            <ErpEdiMasterSalesSiteGrid
              gridRef={salesSiteGridRef}
              gridFilterRef={salesSiteFilterRef}
              data={salesSiteRows}
            />
          </TabItem>
          <TabItem label='SSPM'>
            <ErpEdiMasterSspmGrid
              gridRef={sspmGridRef}
              gridFilterRef={sspmFilterRef}
              data={sspmRows}
            />
          </TabItem>
        </TabWrapper>
      </div>
    </div>
  );
};
export default ErpEdiMaster;
