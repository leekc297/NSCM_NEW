import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { ErpEdiMasterForm } from './components/ErpEdiMasterForm';
import { MENU_ID, SHEETS } from './erp-edi-master.constants';
import styles from './ErpEdiMaster.module.scss';
import type { RepairRow, SalesSiteRow, SspmRow, SummaryRow } from './types';
import { useErpEdiMasterStore } from './useErpEdiMasterStore';

// AS-IS DMF0008_ErpEdiMaster — 3단 구조 (2026-06-02 사용자 요구 반영):
//   [검색] Division
//   [1단] Summary  : spdSummary → DMF0008_GET_EDI_MST_SUMMARY (sheet 'main')
//   [2단] Repair   : spdRepair  → DMF0008_GET_EDI_MST_REPAIR  (sheet 'repair')
//   [3단 2 tab] Sub:
//     - TAB 1: SALES_SITE → DMF0008_GET_SALES_SITE (sheet 'salesSite')
//     - TAB 2: SSPM       → DMF0008_GET_SALES_SITE_PROJECT_MODEL (sheet 'sspm')
//
// 사용자 요구 (2026-06-02):
//   - Period 제거 (조건 아님) — store default 유지
//   - 초기화 버튼 삭제
//   - Status Update Button 추가 (AS-IS .cs L2565 btnStatusUpdate_Click)
//     → SP: PR_DM_DNM_EDI_CALLOFF_STATUS (인자 0개)
//     → 실행 후 Summary + Repair 자동 재조회 (Last Update Start/End/Update by 갱신)
export const ErpEdiMaster = ({ tabId, title }: PageProps<MENU_ID>) => {
  const summaryGridRef = useRef<FlexGridType<SummaryRow>>(null);
  const repairGridRef = useRef<FlexGridType<RepairRow>>(null);
  const salesSiteGridRef = useRef<FlexGridType<SalesSiteRow>>(null);
  const sspmGridRef = useRef<FlexGridType<SspmRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);

  const filters = useErpEdiMasterStore(s => s.filters);
  const searchCondition = useErpEdiMasterStore(s => s.searchCondition);
  const setSearchCondition = useErpEdiMasterStore(s => s.setSearchCondition);
  const setFilter = useErpEdiMasterStore(s => s.setFilter);
  const setSubFilter = useErpEdiMasterStore(s => s.setSubFilter);
  const openSearchArea = useErpEdiMasterStore(s => s.openSearchArea);
  const setOpenSearchArea = useErpEdiMasterStore(s => s.setOpenSearchArea);

  const setAlert = useMessageStore(s => s.setAlert);
  const setToast = useMessageStore(s => s.setToast);

  const { data: summaryData, refetch: refetchSummary } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
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

  // AS-IS GetUpdateHistory (.cs L2911): DMF0000_GET_UPDATE_HISTORY — SDATE/EDATE/UPDATED_BY
  const { data: updateHistoryData, refetch: refetchUpdateHistory } = useTabProcQuery<
    MENU_ID,
    SHEETS.UPDATE_HISTORY
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.UPDATE_HISTORY,
    tabId,
    filters: {},
    enabled: true,
  });

  useEffect(() => {
    if (!filters[SHEETS.MAIN]) setFilter();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const handleSearch = () => {
    setFilter();
    refetchSummary?.();
    refetchRepair?.();
  };

  // AS-IS btnStatusUpdate_Click (.cs L2565~2620): PR_DM_DNM_EDI_CALLOFF_STATUS 호출 후
  //   Summary + Repair 자동 재조회 (Last Update Start/End/Update by 컬럼 갱신)
  const handleStatusUpdate = async () => {
    try {
      await apiClient.post(`/${MENU_ID}/main/STATUS_UPDATE/call-proc`, {});
      setToast({ type: 'success', message: 'Status Update 완료. 재조회합니다.' });
      // AS-IS .cs L2569: siRepair/siSub clear → Summary 재조회 + Update History 갱신
      setFilter();
      refetchSummary?.();
      refetchRepair?.();
      refetchUpdateHistory?.();
    } catch (e) {
      const msg = e instanceof Error ? e.message : 'Status Update 실패';
      void setAlert({ type: 'alert', content: msg });
    }
  };

  // AS-IS spdSub_CellDoubleClick: Summary row 더블클릭 → 3단 sub 영역 호출
  const handleSummaryDoubleClick = () => {
    const g = summaryGridRef.current;
    if (!g) return;
    const row = g.selectedItems[0] as SummaryRow | undefined;
    if (!row) return;
    setSearchCondition({
      selectedSoldTo: String(row.ERP_SOLDTO ?? ''),
      selectedShipTo: String(row.ERP_SHIPTO ?? ''),
      selectedItemId: String(row.ERP_ITEM_ID ?? ''),
      selectedScmSiteId: String(row.GSCM_SALES_SITE_ID ?? ''),
    });
    setSubFilter();
  };

  const hotkeyConfig: HotkeyConfig = {
    search: handleSearch,
    save: false,
    insert: false,
    delete: false,
    manual: false,
    upload: false,
  };

  // 버튼 영역 — Status Update Button (사용자 요구 2026-06-02)
  const customButtons = [
    {
      label: 'Status Update',
      action: () => void handleStatusUpdate(),
    },
  ];

  const summaryRows = useMemo<SummaryRow[]>(
    () => (summaryData?.o_rc1 ?? []) as SummaryRow[],
    [summaryData]
  );
  const repairRows = useMemo<RepairRow[]>(
    () => (repairData?.o_rc1 ?? []) as RepairRow[],
    [repairData]
  );
  const salesSiteRows = useMemo<SalesSiteRow[]>(
    () => (salesSiteData?.O_RESULT_CURSOR ?? salesSiteData?.o_rc1 ?? []) as SalesSiteRow[],
    [salesSiteData]
  );
  const sspmRows = useMemo<SspmRow[]>(
    () => (sspmData?.o_rc1 ?? []) as SspmRow[],
    [sspmData]
  );

  // AS-IS L2926~2928: lblUpdateHistory.Text = SDATE \r\n EDATE \r\n UPDATED_BY
  const updateHistory = useMemo<{ sDate: string; eDate: string; updatedBy: string }>(() => {
    const rows = (updateHistoryData?.o_rc1 ?? []) as Array<{
      SDATE?: string; EDATE?: string; UPDATED_BY?: string;
    }>;
    const r = rows[0] ?? {};
    return {
      sDate: String(r.SDATE ?? '-'),
      eDate: String(r.EDATE ?? '-'),
      updatedBy: String(r.UPDATED_BY ?? '-'),
    };
  }, [updateHistoryData]);

  const repairTotal = useMemo<number>(
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
      {openSearchArea && <ErpEdiMasterForm onSearch={handleSearch} />}

      {/* AS-IS L2924~2928: Update History (Status Update 버튼 앞 — 왼쪽) + SubTitle */}
      <div className={styles.subTitleRow}>
        <div className={styles.updateHistoryBar}>
          <div className={styles.historyItem}>
            <span className={styles.historyLabel}>Last Update Start:</span>
            <span className={styles.historyValue}>{updateHistory.sDate}</span>
          </div>
          <div className={styles.historyItem}>
            <span className={styles.historyLabel}>Last Update End:</span>
            <span className={styles.historyValue}>{updateHistory.eDate}</span>
          </div>
          <div className={styles.historyItem}>
            <span className={styles.historyLabel}>Updated By:</span>
            <span className={styles.historyValue}>{updateHistory.updatedBy}</span>
          </div>
        </div>
        <div className={styles.subTitleSlot}>
      <SubTitle
        menuId={MENU_ID}
        grid={summaryGridRef}
        gridFilter={gridFilterRef}
        dataCount={summaryRows.length}
        excelFileName='ErpEdiMaster'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchCondition}
        customButtons={customButtons}
      />
        </div>
      </div>

      <div className={styles.gridSection}>
        <div className={styles.sectionTitle}>Summary</div>
        <div className={styles.gridContainer}>
          <FlexGrid<SummaryRow>
            initialized={(g: FlexGridType<SummaryRow>) => {
              if (summaryGridRef && 'current' in summaryGridRef) {
                (summaryGridRef as { current: FlexGridType<SummaryRow> | null }).current = g;
              }
              g.isReadOnly = true;
              g.itemDoubleClick.addHandler(() => handleSummaryDoubleClick());
            }}
            itemsSource={summaryRows}
            autoGenerateColumns={false}
            className={styles.grid}
          >
            <FlexGridColumn binding='DIVISION_ID' header='Division' width={80} />
            <FlexGridColumn binding='EDI_SENDER_NAME' header='EDI Sender' width={160} />
            <FlexGridColumn binding='GSCM_MASTER_DATA' header='GSCM Master Data' width={140} align='right' format='n0' />
            <FlexGridColumn binding='SUCCESS' header='Success' width={100} align='right' format='n0' />
            <FlexGridColumn binding='EXCEPTION_DATA' header='Exception' width={100} align='right' format='n0' />
            <FlexGridColumn binding='CNT' header='Total Cnt' width={100} align='right' format='n0' />
            <FlexGridColumn binding='EDIT_YN' header='Edit' width={70} />
          </FlexGrid>
        </div>
      </div>

      <div className={styles.gridSection}>
        <div className={styles.sectionTitle}>
          Repair <span className={styles.repairCount}>(정비 필요 합계 수량: {repairTotal})</span>
        </div>
        <div className={styles.gridContainer}>
          <FlexGrid<RepairRow>
            initialized={(g: FlexGridType<RepairRow>) => {
              if (repairGridRef && 'current' in repairGridRef) {
                (repairGridRef as { current: FlexGridType<RepairRow> | null }).current = g;
              }
              g.isReadOnly = true;
            }}
            itemsSource={repairRows}
            autoGenerateColumns={false}
            className={styles.grid}
          >
            <FlexGridColumn binding='DIVISION_ID' header='Division' width={80} />
            <FlexGridColumn binding='EDI_SENDER_NAME' header='EDI Sender' width={140} />
            <FlexGridColumn binding='CUST_UNLOADING_POINT' header='Unloading Point' width={130} />
            <FlexGridColumn binding='CUST_PLANT' header='Cust Plant' width={120} />
            <FlexGridColumn binding='CUST_ITEM_ID' header='Cust Item ID' width={140} />
            <FlexGridColumn binding='ERP_SHIPTO' header='ERP Ship-To' width={120} />
            <FlexGridColumn binding='ERP_SOLDTO' header='ERP Sold-To' width={120} />
            <FlexGridColumn binding='ERP_ITEM_ID' header='ERP Item ID' width={140} />
            <FlexGridColumn binding='SCM_SITE_ID' header='SCM Site' width={100} />
            <FlexGridColumn binding='PROJECT_CODE' header='Project' width={120} />
            <FlexGridColumn binding='END_CUSTOMER' header='End Customer' width={140} />
            <FlexGridColumn binding='GSCM_SALES_SITE_ID' header='GSCM Sales Site' width={130} />
            <FlexGridColumn binding='ACTIVE_SS' header='Active SS' width={100} />
            <FlexGridColumn binding='GSCM_SSPM' header='GSCM SSPM' width={120} />
            <FlexGridColumn binding='GSCM_SSPM_INCOTERMS' header='SSPM Incoterms' width={130} />
            <FlexGridColumn binding='ACTIVE_SSPM' header='Active SSPM' width={110} />
            <FlexGridColumn binding='GSCM_PROJECT' header='GSCM Project' width={120} />
            <FlexGridColumn binding='GSCM_PLANT' header='GSCM Plant' width={120} />
            <FlexGridColumn binding='STATUS_CODE' header='Status' width={80} />
            <FlexGridColumn binding='ERP_STATUS' header='ERP Status' width={100} />
            <FlexGridColumn binding='CNT' header='Count' width={80} align='right' format='n0' />
            <FlexGridColumn binding='EXCEPTION_FLAG' header='Except' width={80} />
            <FlexGridColumn binding='INPUT_DATE' header='Input Date' width={120} />
            <FlexGridColumn binding='LAST_UPDATE_DATE' header='Last Update' width={140} />
            <FlexGridColumn binding='EDIT_YN' header='Edit' width={70} />
          </FlexGrid>
        </div>
      </div>

      <div className={styles.tabSection}>
        <TabWrapper persist>
          <TabItem label='Sales Site'>
            <div className={styles.gridContainer}>
              <FlexGrid<SalesSiteRow>
                initialized={(g: FlexGridType<SalesSiteRow>) => {
                  if (salesSiteGridRef && 'current' in salesSiteGridRef) {
                    (salesSiteGridRef as { current: FlexGridType<SalesSiteRow> | null }).current = g;
                  }
                  g.isReadOnly = true;
                }}
                itemsSource={salesSiteRows}
                autoGenerateColumns={false}
                className={styles.grid}
              >
                <FlexGridColumn binding='DIVISION_ID' header='Division' width={80} />
                <FlexGridColumn binding='SCM_SITE_ID' header='Sales Site*' width={110} />
                <FlexGridColumn binding='REP_SOLDTO_CODE' header='Sold-To*' width={120} />
                <FlexGridColumn binding='REP_SHIPTO_CODE' header='Rep Ship-To*' width={130} />
                <FlexGridColumn binding='SITE_VALID_YN' header='Site Active*' width={100} />
                <FlexGridColumn binding='CUSTOMER_VALID_YN' header='Customer Active*' width={140} />
                <FlexGridColumn binding='SOLDTO_CUSTOMER' header='Sold-To Customer' width={150} />
                <FlexGridColumn binding='END_CUSTOMER' header='End Customer' width={140} />
              </FlexGrid>
            </div>
          </TabItem>
          <TabItem label='SSPM'>
            <div className={styles.gridContainer}>
              <FlexGrid<SspmRow>
                initialized={(g: FlexGridType<SspmRow>) => {
                  if (sspmGridRef && 'current' in sspmGridRef) {
                    (sspmGridRef as { current: FlexGridType<SspmRow> | null }).current = g;
                  }
                  g.isReadOnly = true;
                }}
                itemsSource={sspmRows}
                autoGenerateColumns={false}
                className={styles.grid}
              >
                <FlexGridColumn binding='DIVISION_ID' header='Division' width={80} />
                <FlexGridColumn binding='SCM_SITE_ID' header='SCM Site' width={110} />
                <FlexGridColumn binding='ITEM_ID' header='Model' width={150} />
                <FlexGridColumn binding='ITEM_NAME' header='Item Name' width={180} />
                <FlexGridColumn binding='VALID_YN' header='Active*' width={90} />
              </FlexGrid>
            </div>
          </TabItem>
        </TabWrapper>
      </div>
    </div>
  );
};
