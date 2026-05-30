import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useTabProcQuery, useProcMutation, useSaveWithValidation } from '@shared/hooks';

import { CustomerFcstMasterFcstGrid } from './componenets/CustomerFcstMasterFcstGrid';
import { CustomerFcstMasterForm } from './componenets/CustomerFcstMasterForm';
import { CustomerFcstMasterPsiGrid } from './componenets/CustomerFcstMasterPsiGrid';
import { MENU_ID, SHEET_INDEX, SHEETS } from './customer-fcst-master.constants';
import { useCustomerFcstMasterStore } from './useCustomerFcstMasterStore';

type FcstRow = ResponseData<MENU_ID, SHEETS.CUSTOMER_FCST>;
type PsiRow = ResponseData<MENU_ID, SHEETS.CUSTOMER_PSI>;

export const CustomerFcstMaster = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const fcstGridRef = useRef<FlexGrid<FcstRow>>();
  const psiGridRef = useRef<FlexGrid<PsiRow>>();
  const fcstGridFilterRef = useRef<FlexGridFilter>();
  const psiGridFilterRef = useRef<FlexGridFilter>();
  const fcstEditTrackerRef = useRef<EditTracker<FcstRow>>();
  const psiEditTrackerRef = useRef<EditTracker<PsiRow>>();

  const [activeIndex, setActiveIndex] = useState<SHEET_INDEX>(SHEET_INDEX.CUSTOMER_FCST);

  const initialized = useCustomerFcstMasterStore(state => state.initialized);
  const filters = useCustomerFcstMasterStore(state => state.filters);
  const dateColumns = useCustomerFcstMasterStore(state => state.dateColumns);
  const setFilter = useCustomerFcstMasterStore(state => state.setFilter);
  const staticColumns = useCustomerFcstMasterStore(state => state.staticColumns);
  const fetchStaticColumns = useCustomerFcstMasterStore(state => state.fetchStaticColumns);
  const fetchDateColumns = useCustomerFcstMasterStore(state => state.fetchDateColumns);
  const searchParams = useCustomerFcstMasterStore(state => state.searchParams);
  const openSearchArea = useCustomerFcstMasterStore(state => state.openSearchArea);
  const setOpenSearchArea = useCustomerFcstMasterStore(state => state.setOpenSearchArea);

  const { saveWithValidation } = useSaveWithValidation();

  const { data: fcstData } = useTabProcQuery<MENU_ID, SHEETS.CUSTOMER_FCST>({
    menuId: MENU_ID,
    sheetName: SHEETS.CUSTOMER_FCST,
    tabId,
    filters: filters[SHEETS.CUSTOMER_FCST],
    enabled: !!filters[SHEETS.CUSTOMER_FCST],
  });
  const { data: psiData } = useTabProcQuery<MENU_ID, SHEETS.CUSTOMER_PSI>({
    menuId: MENU_ID,
    sheetName: SHEETS.CUSTOMER_PSI,
    tabId,
    filters: filters[SHEETS.CUSTOMER_PSI],
    enabled: !!filters[SHEETS.CUSTOMER_PSI],
  });

  const { mutate: saveFcst } = useProcMutation<MENU_ID, SHEETS.CUSTOMER_FCST>({
    menuId: MENU_ID,
    sheetName: SHEETS.CUSTOMER_FCST,
    tabId,
  });
  const { mutate: savePsi } = useProcMutation<MENU_ID, SHEETS.CUSTOMER_PSI>({
    menuId: MENU_ID,
    sheetName: SHEETS.CUSTOMER_PSI,
    tabId,
  });

  const handleSearch = () => {
    setFilter();
    fetchDateColumns();
    fcstEditTrackerRef.current?.clearChanges();
    psiEditTrackerRef.current?.clearChanges();
    fcstGridRef.current?.invalidate();
    psiGridRef.current?.invalidate();
  };

  const buildDateBindings = () =>
    Object.fromEntries(
      dateColumns
        .map(item => item.columns?.[0]?.binding)
        .filter(Boolean)
        .map(binding => [binding, 'Y'])
    ) as Record<string, string>;

  const handleInsert = () => {
    const dateBindings = buildDateBindings();
    const common = {
      DIVISION_ID: searchParams.divisionId ?? '81',
      SUMMARY_BUCKET_TYPE: searchParams.bucketType,
      EDI_FCST_YN: 'Y',
      VALID_YN: 'Y',
      ...dateBindings,
    };
    if (activeIndex === SHEET_INDEX.CUSTOMER_FCST) {
      if (!fcstGridRef.current) return;
      GridAction.addRow(fcstGridRef.current, { ...common, MEASURE_GROUP: 'CUST_FCST' });
    } else {
      if (!psiGridRef.current) return;
      GridAction.addRow(psiGridRef.current, { ...common, MEASURE_GROUP: 'PSI' });
    }
  };

  const handleDelete = () => {
    if (activeIndex === SHEET_INDEX.CUSTOMER_FCST) {
      if (!fcstGridRef.current) return;
      GridAction.removeRow(fcstGridRef.current, true);
    } else {
      if (!psiGridRef.current) return;
      GridAction.removeRow(psiGridRef.current, true);
    }
  };

  const buildPivotedRow = (
    row: Record<string, string | undefined>,
    key: string,
    measureGroup: 'CUST_FCST' | 'PSI'
  ): Record<string, string> => ({
    PLAN_WEEK: row.PLAN_WEEK ?? '',
    DIVISION_ID: row.DIVISION_ID ?? '',
    DEPT_ID: row.DEPT_ID ?? '',
    CUSTOMER_CODE: row.CUSTOMER_CODE ?? '',
    SCM_SITE_ID: row.SCM_SITE_ID ?? '',
    MEASURE_GROUP: row.MEASURE_GROUP ?? measureGroup,
    MEASURE: row.MEASURE ?? '',
    EDI_FCST_YN: row.EDI_FCST_YN ?? 'Y',
    UPLOAD_UOM: row.UPLOAD_UOM ?? '',
    UPLOAD_BUCKET_TYPE: row.UPLOAD_BUCKET_TYPE ?? '',
    VALID_YN: row.VALID_YN ?? 'Y',
    UPLOAD_ORDER: row.UPLOAD_ORDER ?? '',
    EDIT_FLAG: row.EDIT_FLAG ?? '',
    CRUD_TYPE: row.CRUD_TYPE ?? CRUD_TYPE.MODIFY,
    CUSTOMER_PSI: row.CUSTOMER_PSI ?? '',
    SUMMARY_BUCKET_TYPE: row.SUMMARY_BUCKET_TYPE ?? '',
    SUMMARY_BUCKET_VALUE: key.split('_')[1],
    SUMMARY_BUCKET_YN: row[key] ?? 'N',
  });

  const handleSave = () => {
    if (activeIndex === SHEET_INDEX.CUSTOMER_FCST) {
      const rows = fcstData?.o_rc1 ?? [];
      const editMap = fcstEditTrackerRef.current?.getOriginalValues();
      const saveData: FcstRow[] = [];
      rows
        .filter(row => row.CRUD_TYPE)
        .forEach(row => {
          Object.keys(row).forEach(key => {
            if (!key.startsWith('D_')) return;
            const changeMap = editMap?.get(row);
            if (row.CRUD_TYPE === CRUD_TYPE.MODIFY && (!changeMap || !(key in changeMap))) return;
            saveData.push(buildPivotedRow(row, key, 'CUST_FCST') as unknown as FcstRow);
          });
        });
      saveWithValidation(saveData, staticColumns[SHEETS.CUSTOMER_FCST], saveFcst);
    } else {
      const rows = psiData?.o_rc1 ?? [];
      const editMap = psiEditTrackerRef.current?.getOriginalValues();
      const saveData: PsiRow[] = [];
      rows
        .filter(row => row.CRUD_TYPE)
        .forEach(row => {
          Object.keys(row).forEach(key => {
            if (!key.startsWith('D_')) return;
            const changeMap = editMap?.get(row);
            if (row.CRUD_TYPE === CRUD_TYPE.MODIFY && (!changeMap || !(key in changeMap))) return;
            saveData.push(buildPivotedRow(row, key, 'PSI') as unknown as PsiRow);
          });
        });
      saveWithValidation(saveData, staticColumns[SHEETS.CUSTOMER_PSI], savePsi);
    }
  };

  const hotkeyConfig: HotkeyConfig = {
    search: handleSearch,
    insert: handleInsert,
    save: handleSave,
    delete: handleDelete,
    manual: false,
    upload: false,
  };

  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
  }, [tabId]);

  const isFcstTab = activeIndex === SHEET_INDEX.CUSTOMER_FCST;
  const activeDataCount = isFcstTab
    ? (fcstData?.o_rc1.length ?? 0)
    : (psiData?.o_rc1.length ?? 0);

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <CustomerFcstMasterForm onSubmit={handleSearch} />
      <SubTitle
        menuId={MENU_ID}
        grid={isFcstTab ? fcstGridRef : psiGridRef}
        gridFilter={isFcstTab ? fcstGridFilterRef : psiGridFilterRef}
        dataCount={activeDataCount}
        excelFileName='Customer FCST Master'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <TabWrapper
        persist
        activeTabIndex={activeIndex}
        setActiveTabIndex={inx => setActiveIndex(inx)}
      >
        <TabItem label={t('LBL_DMF0007_CUSTOMER_FCST', '_Customer FCST')}>
          <CustomerFcstMasterFcstGrid
            gridRef={fcstGridRef}
            gridFilterRef={fcstGridFilterRef}
            editTrackerRef={fcstEditTrackerRef}
            data={fcstData?.o_rc1 ?? []}
          />
        </TabItem>
        <TabItem label={t('LBL_DMF0007_CUSTOMER_PSI', '_Customer PSI')}>
          <CustomerFcstMasterPsiGrid
            gridRef={psiGridRef}
            gridFilterRef={psiGridFilterRef}
            editTrackerRef={psiEditTrackerRef}
            data={psiData?.o_rc1 ?? []}
          />
        </TabItem>
      </TabWrapper>
    </>
  );
};
