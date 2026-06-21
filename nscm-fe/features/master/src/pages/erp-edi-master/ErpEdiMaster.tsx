import { type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState } from 'react';

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
//   [검색] Division (Form) + Last Update Start/End (AS-IS .cs L2918 DMF0000_GET_UPDATE_HISTORY)
//   [1단] Summary    : DMF0008_GET_EDI_MST_SUMMARY (sheet 'summary')
//   [2단] Repair     : DMF0008_GET_EDI_MST_REPAIR  (sheet 'repair')
//   [3단 2 tab] Sub  : Sales Site / SSPM
//
// 룰 v2 _tobe/01_file_structure.md §1.5 + hook components-folder-pattern.md (2026-06-09):
//   진입 페이지 = composition + layout 만. 4 grid + Form 은 components/ sub-component.
// 룰 #24 menu-button-dynamic-fetch + #62 ui-dynamic-property-management (2026-06-15):
//   useTabBtnPermissions + hasButton(BTN_CD) — admin USE_YN='N' 자동 반영.
const ErpEdiMaster = ({ tabId, title }: PageProps<MENU_ID>) => {
  // V08/V09 fix (2026-06-20): useState(*GridRef) 안티패턴 제거.
  // SubTitle 의 grid/gridFilter 는 activeTab 기반 삼항으로 직접 전달 (Lookup.tsx L208 표준).
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
  const setSalesSiteOnly = useErpEdiMasterStore(s => s.setSalesSiteOnly);
  const setSspmOnly = useErpEdiMasterStore(s => s.setSspmOnly);
  const setSalesSiteFilters = useErpEdiMasterStore(s => s.setSalesSiteFilters);
  const setSspmFilters = useErpEdiMasterStore(s => s.setSspmFilters);
  const repairContext = useErpEdiMasterStore(s => s.repairContext);
  const setRepairContext = useErpEdiMasterStore(s => s.setRepairContext);
  const openSearchArea = useErpEdiMasterStore(s => s.openSearchArea);
  const setOpenSearchArea = useErpEdiMasterStore(s => s.setOpenSearchArea);
  const fetchStaticColumns = useErpEdiMasterStore(s => s.fetchStaticColumns);
  const staticColumns = useErpEdiMasterStore(s => s.staticColumns);
  const setUpdateHistory = useErpEdiMasterStore(s => s.setUpdateHistory);

  const { t } = useTranslation();

  const setAlert = useMessageStore(s => s.setAlert);
  const setToast = useMessageStore(s => s.setToast);

  const { saveWithValidation } = useSaveWithValidation();

  // V07 fix (2026-06-20): 동적 권한 hook 도입 (Hook #24/#62).
  // admin USE_YN='N' 시 자동 false. BE 메타 (SCM_ADM_USER_GR_MNU_BTN_MPG_M) 등록 필요.
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

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

  // F02 (2026-06-20): AS-IS .cs L2918 DMF0000_GET_UPDATE_HISTORY 호출.
  // setSummaryFilters 가 filters[UPDATE_HISTORY] 도 함께 set (Store) → 자동 fetch.
  const { data: updateHistoryData } = useTabProcQuery<MENU_ID, SHEETS.UPDATE_HISTORY>({
    menuId: MENU_ID,
    sheetName: SHEETS.UPDATE_HISTORY,
    tabId,
    filters: filters[SHEETS.UPDATE_HISTORY],
    enabled: !!filters[SHEETS.UPDATE_HISTORY],
  });

  useEffect(() => {
    const row = updateHistoryData?.o_rc1?.[0];
    if (row) {
      setUpdateHistory({
        SDATE: String(row.SDATE ?? ''),
        EDATE: String(row.EDATE ?? ''),
        UPDATED_BY: String(row.UPDATED_BY ?? ''),
      });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [updateHistoryData]);

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
        content: t('MSG00606', '_데이터가 저장되었습니다.'),
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

  // AS-IS btnStatusUpdate_Click (.cs L2565~2620): PR_DM_DNM_EDI_CALLOFF_STATUS 호출 + Summary + Repair refetch
  const handleStatusUpdate = async () => {
    try {
      await apiClient.post(`/${MENU_ID}/summary/STATUS_UPDATE/call-proc`, {});
      setToast({ type: 'success', message: 'Status Update 완료. 재조회합니다.' });
      setSummaryFilters();
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

  // RepairGrid onDblClick — AS-IS .cs L1973 단일 sheet 분기 (성능 — 2 SP → 1 SP).
  // targetSheet 에 따라 해당 sub tab 으로 전환 + 단일 filter set.
  const handleRepairDoubleClick = (
    targetSheet: 'SALES_SITE' | 'SSPM',
    row: ResponseData<MENU_ID, SHEETS.REPAIR>
  ) => {
    setSearchParams({
      selectedSoldTo: String(row.ERP_SOLDTO ?? ''),
      selectedShipTo: String(row.ERP_SHIPTO ?? ''),
      selectedItemId: String(row.ERP_ITEM_ID ?? ''),
      selectedScmSiteId: String(row.GSCM_SALES_SITE_ID ?? ''),
    });
    if (targetSheet === 'SALES_SITE') {
      setSalesSiteOnly();
      setActiveTab(SHEET_INDEX.SALES_SITE);
    } else {
      setSspmOnly();
      setActiveTab(SHEET_INDEX.SSPM);
    }
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
    if (useSessionStore.getState().session?.groupId === 'SCP Planner') {
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

  // V07 fix (2026-06-20): hasButton 권한 분기.
  // BTN_CD 표준: SEARCH / SAVE / INSERT / STATUS_UPDATE (DMF0008 메타 SCM_ADM_USER_GR_MNU_BTN_MPG_M).
  // 2026-06-20 사용자 요구: Condition / ResetCondition 기본 활성 (SubTitle DefaultButtonActions).
  // → 명시 미정의 = 자동 활성 (F6 / F10).
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? setSummaryFilters : false,
    save: hasButton('SAVE') ? handleSave : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    delete: false,
    manual: false,
    upload: false,
  };

  // V07: customButtons 도 권한 분기 (STATUS_UPDATE BTN_CD).
  const customButtons = hasButton('STATUS_UPDATE')
    ? [
        {
          label: 'Status Update',
          action: () => void handleStatusUpdate(),
        },
      ]
    : [];

  // V11 fix (2026-06-20): typo dead code `?? salesSiteData?.o_rc1` 제거.
  // safeRows<T>() inline helper 제거 → 도메인 표준 `?? []` (DMF0004 SalesSite.tsx L186 참조).
  const summaryRows = summaryData?.o_rc1 ?? [];
  const repairRows = repairData?.o_rc1 ?? [];
  const salesSiteRows = salesSiteData?.o_rc1 ?? [];
  const sspmRows = sspmData?.o_rc1 ?? [];

  // V08/V09 + V10 fix (2026-06-20): activeTab 기반 grid/filter ref 삼항 (Lookup.tsx L208 표준).
  // dataCount = Repair count (사용자 결정 — Repair = 주 작업 영역).
  const activeGridRef =
    activeTab === SHEET_INDEX.SALES_SITE ? salesSiteGridRef : sspmGridRef;
  const activeGridFilterRef =
    activeTab === SHEET_INDEX.SALES_SITE ? salesSiteFilterRef : sspmFilterRef;

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
        grid={activeGridRef}
        gridFilter={activeGridFilterRef}
        dataCount={repairRows.length}
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
        <div className={styles.sectionTitle}>Repair</div>
        <ErpEdiMasterRepairGrid
          gridRef={repairGridRef}
          gridFilterRef={repairFilterRef}
          data={repairRows}
          onDblClick={handleRepairDoubleClick}
        />
      </div>

      {/* 3단 — Tab (flex-grow 3 = 30%): Sales Site / SSPM */}
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
