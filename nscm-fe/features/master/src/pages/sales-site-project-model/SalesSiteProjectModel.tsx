import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';
import { Panel, PanelGroup } from '@shared/panel';

import { SalesSiteProjectModelForm } from './componenets/SalesSiteProjectModelForm';
import { SalesSiteProjectModelGrid } from './componenets/SalesSiteProjectModelGrid';
import { SalesSiteProjectModelPurchaseGrid } from './componenets/SalesSiteProjectModelPurchaseGrid';
import { MENU_ID, SHEET_INDEX, SHEETS } from './sales-site-project-model.constants';
import styles from './SalesSiteProjectModel.module.scss';
import { useSalesSiteProjectModelStore } from './useSalesSiteProjectModelStore';

export const SalesSiteProjectModel = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { saveWithValidation } = useSaveWithValidation();

  const gridRefs = [useRef<FlexGrid>(), useRef<FlexGrid>()];
  const gridFilterRefs = [useRef<FlexGridFilter>(), useRef<FlexGridFilter>()];

  const initialized = useSalesSiteProjectModelStore(state => state.initialized);
  const filters = useSalesSiteProjectModelStore(state => state.filters);
  const openPurchaseGrid = useSalesSiteProjectModelStore(state => state.openPurchaseGrid);
  const staticColumns = useSalesSiteProjectModelStore(state => state.staticColumns);
  const fetchStaticColumns = useSalesSiteProjectModelStore(state => state.fetchStaticColumns);
  const setProductionFilter = useSalesSiteProjectModelStore(state => state.setProductionFilter);
  const searchParams = useSalesSiteProjectModelStore(state => state.searchParams);
  const openSearchArea = useSalesSiteProjectModelStore(state => state.openSearchArea);
  const setOpenSearchArea = useSalesSiteProjectModelStore(state => state.setOpenSearchArea);

  const [activeTab, setActiveTab] = useState<SHEET_INDEX>(SHEET_INDEX.PRODUCTION);

  const { data: productionData } = useTabProcQuery<MENU_ID, SHEETS.PRODUCTION>({
    menuId: MENU_ID,
    sheetName: SHEETS.PRODUCTION,
    tabId,
    filters: filters[SHEETS.PRODUCTION],
    enabled: !!filters[SHEETS.PRODUCTION],
  });

  const { data: purchaseData } = useTabProcQuery<MENU_ID, SHEETS.PURCHASE>({
    menuId: MENU_ID,
    sheetName: SHEETS.PURCHASE,
    tabId,
    filters: filters[SHEETS.PURCHASE],
    enabled: !!filters[SHEETS.PURCHASE],
  });

  const { mutate: mutateProduction } = useProcMutation<MENU_ID, SHEETS.PRODUCTION>({
    menuId: MENU_ID,
    sheetName: SHEETS.PRODUCTION,
    tabId,
  });

  const { mutate: mutatePurchase } = useProcMutation<MENU_ID, SHEETS.PURCHASE>({
    menuId: MENU_ID,
    sheetName: SHEETS.PRODUCTION as SHEETS.PURCHASE,
    tabId,
  });

  const handleSubmit = () => {
    setProductionFilter();
    void fetchStaticColumns();
    setActiveTab(SHEET_INDEX.PRODUCTION);
  };

  const handleInsert = () => {
    if (activeTab !== SHEET_INDEX.PRODUCTION) return;
    if (!gridRefs[activeTab].current) return;

    GridAction.addRow(gridRefs[activeTab].current, {
      DIVISION_ID: filters[SHEETS.PRODUCTION]?.divisionId ?? '81',
    });
  };

  const handleSave = () => {
    if (activeTab === SHEET_INDEX.PRODUCTION) {
      const saveData = productionData?.production?.filter(item => item.CRUD_TYPE) ?? [];
      const staticColumn = staticColumns.production;
      saveWithValidation(saveData, staticColumn, mutateProduction);
    } else if (activeTab === SHEET_INDEX.PURCHASE) {
      const saveData = purchaseData?.purchase?.filter(item => item.CRUD_TYPE) ?? [];
      const staticColumn = staticColumns.purchase;
      saveWithValidation(saveData, staticColumn, mutatePurchase);
    }
  };

  const handleDelete = () => {
    if (!gridRefs[activeTab].current) return;

    GridAction.removeRow(gridRefs[activeTab].current, true);
  };

  const hotkeyConfig: HotkeyConfig = {
    insert: handleInsert,
    save: handleSave,
    search: handleSubmit,
    delete: handleDelete,
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
      <SalesSiteProjectModelForm onSubmit={handleSubmit} setActiveTab={setActiveTab} />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRefs[activeTab]}
        gridFilter={gridFilterRefs[activeTab]}
        dataCount={
          activeTab === SHEET_INDEX.PRODUCTION
            ? (productionData?.production ?? []).length
            : (purchaseData?.purchase ?? []).length
        }
        excelFileName='Sales-Site-Project-Model'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <PanelGroup className={styles.customPanelGroup} orientation='vertical'>
        <Panel>
          <SalesSiteProjectModelGrid
            gridRef={gridRefs[SHEET_INDEX.PRODUCTION]}
            gridFilterRef={gridFilterRefs[SHEET_INDEX.PRODUCTION]}
            data={productionData?.production ?? []}
            setActiveTab={setActiveTab}
          />
        </Panel>
        {openPurchaseGrid && searchParams.divisionId !== '40' && (
          <Panel>
            <SalesSiteProjectModelPurchaseGrid
              gridRef={gridRefs[SHEET_INDEX.PURCHASE]}
              gridFilterRef={gridFilterRefs[SHEET_INDEX.PURCHASE]}
              data={purchaseData?.purchase ?? []}
              setActiveTab={setActiveTab}
            />
          </Panel>
        )}
      </PanelGroup>
    </>
  );
};
