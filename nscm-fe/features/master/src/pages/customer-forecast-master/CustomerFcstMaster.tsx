import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery, useProcMutation, useSaveWithValidation } from '@shared/hooks';

import { CustomerFcstMasterFcstGrid } from './componenets/CustomerFcstMasterFcstGrid';
import { CustomerFcstMasterForm } from './componenets/CustomerFcstMasterForm';
import { MENU_ID, SHEETS } from './customer-fcst-master.constants';
import { useCustomerFcstMasterStore } from './useCustomerFcstMasterStore';

type FcstRow = ResponseData<MENU_ID, SHEETS.CUSTOMER_FCST>;

export const CustomerFcstMaster = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const fcstGridRef = useRef<FlexGrid<FcstRow>>();
  const fcstGridFilterRef = useRef<FlexGridFilter>();
  const fcstEditTrackerRef = useRef<EditTracker<FcstRow>>();

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

  const { mutate: saveFcst } = useProcMutation<MENU_ID, SHEETS.CUSTOMER_FCST>({
    menuId: MENU_ID,
    sheetName: SHEETS.CUSTOMER_FCST,
    tabId,
  });

  const handleSearch = () => {
    setFilter();
    fetchDateColumns();
    fcstEditTrackerRef.current?.clearChanges();
    fcstGridRef.current?.invalidate();
  };

  const buildDateBindings = () =>
    Object.fromEntries(
      dateColumns
        .map(item => item.columns?.[0]?.binding)
        .filter(Boolean)
        .map(binding => [binding, 'Y'])
    ) as Record<string, string>;

  const handleInsert = () => {
    if (!fcstGridRef.current) return;
    const dateBindings = buildDateBindings();
    GridAction.addRow(fcstGridRef.current, {
      DIVISION_ID: searchParams.divisionId ?? '81',
      SUMMARY_BUCKET_TYPE: searchParams.bucketType,
      EDI_FCST_YN: 'Y',
      VALID_YN: 'Y',
      MEASURE_GROUP: 'CUST_FCST',
      ...dateBindings,
    });
  };

  const handleDelete = () => {
    if (!fcstGridRef.current) return;
    GridAction.removeRow(fcstGridRef.current, true);
  };

  const buildPivotedRow = (
    row: Record<string, string | undefined>,
    key: string
  ): Record<string, string> => ({
    PLAN_WEEK: row.PLAN_WEEK ?? '',
    DIVISION_ID: row.DIVISION_ID ?? '',
    DEPT_ID: row.DEPT_ID ?? '',
    CUSTOMER_CODE: row.CUSTOMER_CODE ?? '',
    SCM_SITE_ID: row.SCM_SITE_ID ?? '',
    MEASURE_GROUP: row.MEASURE_GROUP ?? 'CUST_FCST',
    MEASURE: row.MEASURE ?? '',
    EDI_FCST_YN: row.EDI_FCST_YN ?? 'Y',
    UPLOAD_UOM: row.UPLOAD_UOM ?? '',
    UPLOAD_BUCKET_TYPE: row.UPLOAD_BUCKET_TYPE ?? '',
    VALID_YN: row.VALID_YN ?? 'Y',
    UPLOAD_ORDER: row.UPLOAD_ORDER ?? '',
    EDIT_FLAG: row.EDIT_FLAG ?? '',
    CRUD_TYPE: row.CRUD_TYPE ?? CRUD_TYPE.MODIFY,
    SUMMARY_BUCKET_TYPE: row.SUMMARY_BUCKET_TYPE ?? '',
    SUMMARY_BUCKET_VALUE: key.split('_')[1],
    SUMMARY_BUCKET_YN: row[key] ?? 'N',
  });

  const handleSave = () => {
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
          saveData.push(buildPivotedRow(row, key) as unknown as FcstRow);
        });
      });
    saveWithValidation(saveData, staticColumns[SHEETS.CUSTOMER_FCST], saveFcst);
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
        grid={fcstGridRef}
        gridFilter={fcstGridFilterRef}
        dataCount={fcstData?.o_rc1.length ?? 0}
        excelFileName='Customer FCST Master'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <CustomerFcstMasterFcstGrid
        gridRef={fcstGridRef}
        gridFilterRef={fcstGridFilterRef}
        editTrackerRef={fcstEditTrackerRef}
        data={fcstData?.o_rc1 ?? []}
      />
    </>
  );
};
