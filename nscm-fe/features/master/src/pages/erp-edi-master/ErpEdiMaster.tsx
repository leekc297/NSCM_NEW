import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';
import { TitleArea } from '@shared/lges';
import { useMessageStore } from '@shared/stores';

import { ErpEdiMasterForm } from './components/ErpEdiMasterForm';
import { ErpEdiMasterRepairGrid } from './components/ErpEdiMasterRepairGrid';
import { ErpEdiMasterSalesSiteGrid } from './components/ErpEdiMasterSalesSiteGrid';
import { ErpEdiMasterSspmGrid } from './components/ErpEdiMasterSspmGrid';
import { ErpEdiMasterSummaryGrid } from './components/ErpEdiMasterSummaryGrid';
import type { RESPONSE_SET } from './erp-edi-master.constants';
import { MENU_ID, SHEET_INDEX, SHEETS } from './erp-edi-master.constants';
import { EMPTY_SALES_SITE_ROW, EMPTY_SSPM_ROW } from './erp-edi-master.empty-rows';
import styles from './ErpEdiMaster.module.scss';
import { useErpEdiMasterStore } from './useErpEdiMasterStore';

export const ErpEdiMaster = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const { setAlert } = useMessageStore();

  const { saveWithValidation } = useSaveWithValidation();

  const summaryGridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.SUMMARY>>>();
  const summaryGridFilterRef = useRef<FlexGridFilter>();
  const repairGridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.REPAIR>>>();
  const repairGridFilterRef = useRef<FlexGridFilter>();
  const salesSiteGridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.SALES_SITE>>>();
  const salesSiteGridFilterRef = useRef<FlexGridFilter>();
  const sspmGridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.SSPM>>>();
  const sspmGridFilterRef = useRef<FlexGridFilter>();

  const initialized = useErpEdiMasterStore(state => state.initialized);
  const filters = useErpEdiMasterStore(state => state.filters);
  const setSummaryFilters = useErpEdiMasterStore(state => state.setSummaryFilters);
  const setRepairFilters = useErpEdiMasterStore(state => state.setRepairFilters);
  const setSalesSiteFilters = useErpEdiMasterStore(state => state.setSalesSiteFilters);
  const setSspmFilters = useErpEdiMasterStore(state => state.setSspmFilters);
  const repairContext = useErpEdiMasterStore(state => state.repairContext);
  const setRepairContext = useErpEdiMasterStore(state => state.setRepairContext);
  const fetchStaticColumns = useErpEdiMasterStore(state => state.fetchStaticColumns);
  const fetchUpdateHistory = useErpEdiMasterStore(state => state.fetchUpdateHistory);
  const staticColumns = useErpEdiMasterStore(state => state.staticColumns);
  const searchParams = useErpEdiMasterStore(state => state.searchParams);
  const openSearchArea = useErpEdiMasterStore(state => state.openSearchArea);
  const setOpenSearchArea = useErpEdiMasterStore(state => state.setOpenSearchArea);

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

  const { mutate: mutateSalesSite } = useProcMutation<MENU_ID, SHEETS.SALES_SITE, RESPONSE_SET.CUD>(
    {
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
    }
  );

  const { mutate: mutateSspm } = useProcMutation<MENU_ID, SHEETS.SSPM, RESPONSE_SET.CUD>({
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

  // V1 [BLOCKED:DESIGN]: NowGroupID === 'SCP Planner' 권한 차단 — UserSession 에 groupId 필드 없음.
  // 세션 스키마 확장 또는 별도 권한 hook 등록 후 적용. 현재는 통과시킨다.

  const handleInsert = () => {
    if (!repairContext) return;

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

  const handleStatusUpdate = () => {
    // F5 [BLOCKED:BE]: PR_DM_DNM_EDI_CALLOFF_STATUS API_M 미등록.
    // 등록 후 별도 SHEET (예: 'statusUpdate') 추가 + useProcMutation 으로 호출.
    // 성공 후 setSummaryFilters() + void fetchUpdateHistory() 재호출.
    void setAlert({
      type: 'alert',
      content: t('', '_STATUS UPDATE 기능은 BE API 등록 후 사용 가능합니다.'),
    });
  };

  // Summary dblClick → Repair 재조회 (V12, V17)
  const handleSummaryDblClick = (sFlag: string, division: string, senderName: string) => {
    // V17: sFlag=='4' AND GSCM_MASTER_DATA == '0' (Repair 그리드의 더블클릭 행에 따라 외부에서 검증)
    setRepairFilters({ division, senderName, flag: sFlag });
    setRepairContext(undefined);
  };

  // Repair dblClick → Sub 탭 전환 + 데이터 재조회
  const handleRepairDblClick = (col: number, row: ResponseData<MENU_ID, SHEETS.REPAIR>) => {
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

    // GSCM_SSPM 컬럼 인덱스 기준 분기 — repair staticColumns 에서 GSCM_SSPM binding 위치를 col 과 비교
    const gscmSspmCol = staticColumns[SHEETS.REPAIR].findIndex(c => c.colNm === 'GSCM_SSPM');
    if (gscmSspmCol < 0 || col < gscmSspmCol) {
      setSalesSiteFilters({
        divisionId: ctx.division,
        soldTo: ctx.erpSoldTo,
        shipTo: ctx.erpShipTo,
        scmSiteId: ctx.gscmSalesSiteId,
      });
      setActiveTab(SHEET_INDEX.SALES_SITE);
    } else {
      setSspmFilters({
        divisionId: ctx.division,
        itemId: ctx.erpItemId,
        scmSiteId: ctx.gscmSalesSiteId,
      });
      setActiveTab(SHEET_INDEX.SSPM);
    }
  };

  const hotkeyConfig: HotkeyConfig = {
    insert: handleInsert,
    save: handleSave,
    delete: false,
    search: () => {
      setSummaryFilters();
      void fetchStaticColumns();
    },
    excel: false,
    manual: false,
    upload: false,
  };

  useEffect(() => {
    if (!initialized) {
      void fetchStaticColumns();
      void fetchUpdateHistory();
    }
  }, [tabId]);

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <ErpEdiMasterForm />
      <SubTitle
        menuId={MENU_ID}
        grid={
          activeTab === SHEET_INDEX.SALES_SITE
            ? (salesSiteGridRef as never)
            : (sspmGridRef as never)
        }
        gridFilter={
          activeTab === SHEET_INDEX.SALES_SITE ? salesSiteGridFilterRef : sspmGridFilterRef
        }
        dataCount={
          activeTab === SHEET_INDEX.SALES_SITE
            ? (salesSiteData?.o_rc1?.length ?? 0)
            : (sspmData?.o_rc1?.length ?? 0)
        }
        excelFileName='ERP EDI Master'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
        customButtons={[
          {
            label: t('', '_Status Update'),
            action: handleStatusUpdate,
          },
        ]}
      />
      <div className={styles.contents}>
        <div className={styles.topRow}>
          <div className={styles.summaryModule}>
            <TitleArea isSubTitle title={t('', '_Summary')} depth='h4' />
            <ErpEdiMasterSummaryGrid
              gridRef={summaryGridRef}
              gridFilterRef={summaryGridFilterRef}
              data={summaryData?.o_rc1 ?? []}
              onDblClick={handleSummaryDblClick}
            />
          </div>
          <div className={styles.repairModule}>
            <TitleArea isSubTitle title={t('', '_SCM 기준정보 정비 필요 리스트')} depth='h4' />
            <ErpEdiMasterRepairGrid
              gridRef={repairGridRef}
              gridFilterRef={repairGridFilterRef}
              data={repairData?.o_rc1 ?? []}
              onDblClick={handleRepairDblClick}
            />
          </div>
        </div>
        <div className={styles.tabModule}>
          <TabWrapper
            persist
            activeTabIndex={activeTab}
            setActiveTabIndex={setActiveTab as (idx: number) => void}
          >
            <TabItem label={t('', '_Sales Site')}>
              <ErpEdiMasterSalesSiteGrid
                gridRef={salesSiteGridRef}
                gridFilterRef={salesSiteGridFilterRef}
                data={salesSiteData?.o_rc1 ?? []}
              />
            </TabItem>
            <TabItem label={t('', '_SSPM')}>
              <ErpEdiMasterSspmGrid
                gridRef={sspmGridRef}
                gridFilterRef={sspmGridFilterRef}
                data={sspmData?.o_rc1 ?? []}
              />
            </TabItem>
          </TabWrapper>
        </div>
      </div>
    </>
  );
};
