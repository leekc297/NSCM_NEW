import { type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { ErpEdiMasterForm } from './components/ErpEdiMasterForm';
import { ErpEdiMasterRepairGrid } from './components/ErpEdiMasterRepairGrid';
import { ErpEdiMasterSalesSiteGrid } from './components/ErpEdiMasterSalesSiteGrid';
import { ErpEdiMasterSspmGrid } from './components/ErpEdiMasterSspmGrid';
import { ErpEdiMasterSummaryGrid } from './components/ErpEdiMasterSummaryGrid';
import { MENU_ID, SHEETS } from './erp-edi-master.constants';
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
export const ErpEdiMaster = ({ tabId, title }: PageProps<MENU_ID>) => {
  const summaryGridRef = useRef<FlexGridType<ResponseData<MENU_ID, SHEETS.SUMMARY>>>();
  const repairGridRef = useRef<FlexGridType<ResponseData<MENU_ID, SHEETS.REPAIR>>>();
  const salesSiteGridRef = useRef<FlexGridType<ResponseData<MENU_ID, SHEETS.SALES_SITE, 'o_rc1'>>>();
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
  const openSearchArea = useErpEdiMasterStore(s => s.openSearchArea);
  const setOpenSearchArea = useErpEdiMasterStore(s => s.setOpenSearchArea);
  const fetchStaticColumns = useErpEdiMasterStore(s => s.fetchStaticColumns);

  const setAlert = useMessageStore(s => s.setAlert);
  const setToast = useMessageStore(s => s.setToast);

  const { data: summaryData, refetch: refetchSummary } = useTabProcQuery<MENU_ID, SHEETS.SUMMARY>({
    menuId: MENU_ID,
    sheetName: SHEETS.SUMMARY,
    tabId,
    filters: filters[SHEETS.SUMMARY],
    enabled: !!filters[SHEETS.SUMMARY],
  });

  const { data: repairData, refetch: refetchRepair } = useTabProcQuery<MENU_ID, SHEETS.REPAIR>({
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

  // AS-IS btnStatusUpdate_Click (.cs L2565~2620): PR_DM_DNM_EDI_CALLOFF_STATUS 호출 + Summary + Repair refetch
  const handleStatusUpdate = async () => {
    try {
      await apiClient.post(`/${MENU_ID}/summary/STATUS_UPDATE/call-proc`, {});
      setToast({ type: 'success', message: 'Status Update 완료. 재조회합니다.' });
      setSummaryFilters();
      refetchSummary?.();
      refetchRepair?.();
    } catch (e) {
      const msg = e instanceof Error ? e.message : 'Status Update 실패';
      void setAlert({ type: 'alert', content: msg });
    }
  };

  // SummaryGrid onDblClick: (sFlag, division, senderName)
  const handleSummaryDoubleClick = (sFlag: string, _division: string, senderName: string) => {
    setSearchParams({ senderName, flag: sFlag });
    setRepairFilter();
  };

  // RepairGrid onDblClick: (col, row)
  const handleRepairDoubleClick = (
    _col: number,
    row: ResponseData<MENU_ID, SHEETS.REPAIR>
  ) => {
    setSearchParams({
      selectedSoldTo: String(row.ERP_SOLDTO ?? ''),
      selectedShipTo: String(row.ERP_SHIPTO ?? ''),
      selectedItemId: String(row.ERP_ITEM_ID ?? ''),
      selectedScmSiteId: String(row.GSCM_SALES_SITE_ID ?? ''),
    });
    setSubFilter();
  };

  const handleInsert = () => {
    void setAlert({
      type: 'alert',
      content: '미구현 — As-Is DMF0008_ErpEdiMaster.cs L541 InsertRow() 참조',
    });
  };

  const handleSave = () => {
    void setAlert({
      type: 'alert',
      content: '미구현 — As-Is DMF0008_ErpEdiMaster.cs L808 SaveButton 참조',
    });
  };

  const hotkeyConfig: HotkeyConfig = {
    search: setSummaryFilters,
    save: handleSave,
    insert: handleInsert,
    delete: false,
    condition: false,
    resetCondition: false,
    manual: false,
    upload: false,
  };

  const customButtons = [
    {
      label: 'Status Update',
      action: () => void handleStatusUpdate(),
    },
  ];

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
    () => safeRows<ResponseData<MENU_ID, SHEETS.SALES_SITE, 'o_rc1'>>(
      salesSiteData?.O_RESULT_CURSOR ?? salesSiteData?.o_rc1
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
        grid={summaryGridRef}
        gridFilter={summaryFilterRef}
        dataCount={summaryRows.length}
        excelFileName='ErpEdiMaster'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
        customButtons={customButtons}
      />

      {/* 1단 — Summary (flex-grow 4 = 40%) */}
      <div className={styles.summarySection}>
        <div className={styles.sectionTitle}>Summary</div>
        <ErpEdiMasterSummaryGrid
          gridRef={summaryGridRef}
          gridFilterRef={summaryFilterRef}
          data={summaryRows}
          onDblClick={handleSummaryDoubleClick}
        />
      </div>

      {/* 2단 — Repair (flex-grow 3 = 30%) */}
      <div className={styles.repairSection}>
        <div className={styles.sectionTitle}>
          Repair
          {repairTotal > 0 && (
            <span className={styles.repairCount}>Total: {repairTotal.toLocaleString()}</span>
          )}
        </div>
        <ErpEdiMasterRepairGrid
          gridRef={repairGridRef}
          gridFilterRef={repairFilterRef}
          data={repairRows}
          onDblClick={handleRepairDoubleClick}
        />
      </div>

      {/* 3단 — Tab (flex-grow 3 = 30%): Sales Site / SSPM */}
      <div className={styles.subSection}>
        <TabWrapper persist>
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
