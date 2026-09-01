import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState } from 'react';

import type { ComboResponse, HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';

import { SalesSiteBucketGrid } from './components/SalesSiteBucketGrid';
import { SalesSiteCustomerGrid } from './components/SalesSiteCustomerGrid';
import { SalesSiteForm } from './components/SalesSiteForm';
import { SalesSiteGrid } from './components/SalesSiteGrid';
import { SalesSiteLocationGrid } from './components/SalesSiteLocationGrid';
import type { RESPONSE_SET } from './sales-site.constants';
import { MENU_ID, SHEET_INDEX, SHEETS } from './sales-site.constants';
import styles from './SalesSite.module.scss';
import { useSalesSiteStore } from './useSalesSiteStore';
import { resolveComboCodeByDivision } from './utils/sales-site.util';

export const SalesSite = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRefs = [useRef<FlexGrid>(), useRef<FlexGrid>(), useRef<FlexGrid>(), useRef<FlexGrid>()];
  const gridFilterRefs = [
    useRef<FlexGridFilter>(),
    useRef<FlexGridFilter>(),
    useRef<FlexGridFilter>(),
    useRef<FlexGridFilter>(),
  ];

  const initialized = useSalesSiteStore(state => state.initialized);
  const filters = useSalesSiteStore(state => state.filters);
  const setSiteFilters = useSalesSiteStore(state => state.setSiteFilters);
  const staticColumns = useSalesSiteStore(state => state.staticColumns);
  const fetchStaticColumns = useSalesSiteStore(state => state.fetchStaticColumns);
  const searchParams = useSalesSiteStore(state => state.searchParams);
  const openSearchArea = useSalesSiteStore(state => state.openSearchArea);
  const setOpenSearchArea = useSalesSiteStore(state => state.setOpenSearchArea);

  const [activeTab, setActiveTab] = useState<SHEET_INDEX>(SHEET_INDEX.SITE);
  const [openDetailGrid, setOpenDetailGrid] = useState<boolean>(true);

  const { saveWithValidation } = useSaveWithValidation();

  const { data: siteData } = useTabProcQuery<MENU_ID, SHEETS.SITE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SITE,
    tabId,
    filters: filters[SHEETS.SITE],
    enabled: !!filters[SHEETS.SITE],
  });

  const { data: detailData } = useTabProcQuery<MENU_ID, SHEETS.CUSTOMER>({
    menuId: MENU_ID,
    sheetName: SHEETS.CUSTOMER,
    tabId,
    filters: filters[SHEETS.CUSTOMER],
    enabled: !!filters[SHEETS.CUSTOMER],
  });

  const { mutate: mutateSite } = useProcMutation<MENU_ID, SHEETS.SITE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SITE,
    tabId,
  });

  const { mutate: mutateCustomer } = useProcMutation<
    MENU_ID,
    SHEETS.CUSTOMER,
    RESPONSE_SET.CUSTOMER
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.CUSTOMER,
    tabId,
  });

  const { mutate: mutateLocation } = useProcMutation<
    MENU_ID,
    SHEETS.LOCATION,
    RESPONSE_SET.LOCATION
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.LOCATION,
    tabId,
  });

  const { mutate: mutateBucket } = useProcMutation<MENU_ID, SHEETS.BUCKET, RESPONSE_SET.BUCKET>({
    menuId: MENU_ID,
    sheetName: SHEETS.BUCKET,
    tabId,
  });

  const detailDataCountByTab: Record<number, number> = {
    [SHEET_INDEX.SITE]: siteData?.salesSite.length ?? 0,
    [SHEET_INDEX.CUSTOMER]: detailData?.salesCustomer.length ?? 0,
    [SHEET_INDEX.LOCATION]: detailData?.salesLocation.length ?? 0,
    [SHEET_INDEX.BUCKET]: detailData?.salesBucket.length ?? 0,
  };

  const handleInsert = () => {
    if (!gridRefs[activeTab].current) return;

    const scmSiteId =
      activeTab === SHEET_INDEX.SITE ? undefined : filters[SHEETS.CUSTOMER]?.salesSite;

    // Rep 기본값은 N. Y 로 바꿀 때의 중복 검사는 Customer 그리드 cellEditEnded 에서 처리한다.
    GridAction.addRow(gridRefs[activeTab].current, {
      DIVISION_ID: filters[SHEETS.SITE]?.divisionId ?? '81',
      SCM_SITE_ID: scmSiteId,
      VMI_YN: 'N',
      VALID_YN: 'Y',
      REP_YN: 'N',
      SHIP_PLAN_AUTO: 'N',
    });
  };

  const handleDelete = () => {
    if (!gridRefs[activeTab].current) return;
    GridAction.removeRow(gridRefs[activeTab].current);
  };

  const handleSave = () => {
    switch (activeTab) {
      case SHEET_INDEX.SITE: {
        const grid = gridRefs[SHEET_INDEX.SITE].current;
        const endCustomerRows = (grid?.columns.getColumn('END_CUSTOMER')?.dataMap?.collectionView
          .items ?? []) as ComboResponse[];
        const soldToCustomerRows = (grid?.columns.getColumn('SOLDTO_CUSTOMER')?.dataMap
          ?.collectionView.items ?? []) as ComboResponse[];
        const saveData = (siteData?.salesSite?.filter?.(item => item.CRUD_TYPE) ?? []).map(
          item => ({
            ...item,
            END_CUSTOMER: resolveComboCodeByDivision(
              endCustomerRows,
              String(item.DIVISION_ID ?? ''),
              String(item.END_CUSTOMER ?? '')
            ),
            SOLDTO_CUSTOMER: resolveComboCodeByDivision(
              soldToCustomerRows,
              String(item.DIVISION_ID ?? ''),
              String(item.SOLDTO_CUSTOMER ?? '')
            ),
          })
        );
        const staticColumn = staticColumns.salesSite;
        saveWithValidation(saveData, staticColumn, mutateSite);
        break;
      }
      case SHEET_INDEX.CUSTOMER: {
        const saveData = detailData?.salesCustomer?.filter?.(item => item.CRUD_TYPE) ?? [];
        const staticColumn = staticColumns.salesCustomer;
        saveWithValidation(saveData, staticColumn, mutateCustomer);
        break;
      }
      case SHEET_INDEX.LOCATION: {
        const saveData = detailData?.salesLocation?.filter?.(item => item.CRUD_TYPE) ?? [];
        const staticColumn = staticColumns.salesLocation;
        saveWithValidation(saveData, staticColumn, mutateLocation);
        break;
      }
      case SHEET_INDEX.BUCKET: {
        const saveData = detailData?.salesBucket?.filter?.(item => item.CRUD_TYPE) ?? [];
        const staticColumn = staticColumns.salesBucket;
        saveWithValidation(saveData, staticColumn, mutateBucket);
        break;
      }
    }
  };

  const hotkeyConfig: HotkeyConfig = {
    insert: handleInsert,
    save: handleSave,
    delete: handleDelete,
    search: () => {
      setSiteFilters();
      void fetchStaticColumns();
    },
    manual: false,
    upload: false,
  };

  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
  }, [tabId]);

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <SalesSiteForm
        setActiveTab={setActiveTab}
        openDetailGrid={openDetailGrid}
        setOpenDetailGrid={setOpenDetailGrid}
      />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRefs[activeTab]}
        gridFilter={gridFilterRefs[activeTab]}
        dataCount={detailDataCountByTab[activeTab] ?? 0}
        excelFileName='Sales Site'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      {/* 상하 드래그 분할 — 초기 비율은 기존 flex-grow 5:3 을 그대로 옮긴 62.5 : 37.5.
          Detail 체크 해제 시 아래 Panel/Separator 가 통째로 빠져 상단이 100% 를 차지한다. */}
      <PanelGroup className={styles.tableWrapper} orientation='vertical'>
        <Panel defaultSize={62.5} minSize={20}>
          <SalesSiteGrid
            gridRef={gridRefs[SHEET_INDEX.SITE]}
            gridFilterRef={gridFilterRefs[SHEET_INDEX.SITE]}
            data={siteData?.salesSite ?? []}
            setActiveTab={setActiveTab}
          />
        </Panel>

        {openDetailGrid && <PanelSeparator className={styles.splitBar} />}
        {openDetailGrid && (
          <Panel defaultSize={37.5} minSize={15}>
            <div className={styles.lowerGrid}>
              <TabWrapper persist>
                <TabItem label={t('LBL00314', '_Sales Customer')}>
                  <SalesSiteCustomerGrid
                    gridRef={gridRefs[SHEET_INDEX.CUSTOMER]}
                    gridFilterRef={gridFilterRefs[SHEET_INDEX.CUSTOMER]}
                    data={detailData?.salesCustomer ?? []}
                    setActiveTab={setActiveTab}
                  />
                </TabItem>
                <TabItem label={t('LBL00315', '_Sales Location')}>
                  <SalesSiteLocationGrid
                    gridRef={gridRefs[SHEET_INDEX.LOCATION]}
                    gridFilterRef={gridFilterRefs[SHEET_INDEX.LOCATION]}
                    data={detailData?.salesLocation ?? []}
                    setActiveTab={setActiveTab}
                  />
                </TabItem>
                <TabItem label={t('LBL00032', '_Sales Bucket')}>
                  <SalesSiteBucketGrid
                    gridRef={gridRefs[SHEET_INDEX.BUCKET]}
                    gridFilterRef={gridFilterRefs[SHEET_INDEX.BUCKET]}
                    data={detailData?.salesBucket ?? []}
                    setActiveTab={setActiveTab}
                  />
                </TabItem>
              </TabWrapper>
            </div>
          </Panel>
        )}
      </PanelGroup>
    </>
  );
};
