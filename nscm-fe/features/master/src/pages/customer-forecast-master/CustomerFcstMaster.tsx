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
import { MENU_ID, SHEET_NAME } from './customer-fcst-master.constants';
import { useCustomerFcstMasterStore } from './useCustomerFcstMasterStore';

export const CustomerFcstMaster = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEET_NAME, 'o_rc1'>> | undefined>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEET_NAME>>>();

  const initialized = useCustomerFcstMasterStore(state => state.initialized);
  const filters = useCustomerFcstMasterStore(state => state.filters);
  const dateColumns = useCustomerFcstMasterStore(state => state.dateColumns);
  const setFilter = useCustomerFcstMasterStore(state => state.setFilter);
  const staticColumn = useCustomerFcstMasterStore(state => state.staticColumns);
  const fetchStaticColumns = useCustomerFcstMasterStore(state => state.fetchStaticColumns);
  const fetchDateColumns = useCustomerFcstMasterStore(state => state.fetchDateColumns);
  const searchParams = useCustomerFcstMasterStore(state => state.searchParams);
  const openSearchArea = useCustomerFcstMasterStore(state => state.openSearchArea);
  const setOpenSearchArea = useCustomerFcstMasterStore(state => state.setOpenSearchArea);

  const { saveWithValidation } = useSaveWithValidation();

  const { data: fcstData } = useTabProcQuery<MENU_ID, SHEET_NAME>({
    menuId: MENU_ID,
    sheetName: SHEET_NAME,
    tabId,
    filters: filters,
    enabled: !!filters,
  });

  const { mutate: saveMutation } = useProcMutation<MENU_ID, SHEET_NAME>({
    menuId: MENU_ID,
    sheetName: SHEET_NAME,
    tabId,
  });

  const handleSearch = () => {
    setFilter();
    fetchDateColumns();
    editTrackerRef.current?.clearChanges();
    gridRef.current?.invalidate();
  };

  const handleInsert = () => {
    if (!gridRef.current) return;

    const dateBindings = Object.fromEntries(
      dateColumns
        .map(item => item.columns?.[0]?.binding)
        .filter(Boolean)
        .map(binding => [binding, 'Y'])
    ) as Record<string, string>;

    GridAction.addRow(gridRef.current, {
      DIVISION_ID: filters?.divisionId ?? '81',
      SUMMARY_BUCKET_TYPE: filters?.bucketType,
      MEASURE_GROUP: 'CUST_FCST',
      EDI_FCST_YN: 'Y',
      VALID_YN: 'Y',
      ...dateBindings,
    });
  };

  const handleDelete = () => {
    if (!gridRef.current) return;
    GridAction.removeRow(gridRef.current, true);
  };

  const handleSave = () => {
    if (!gridRef.current || !editTrackerRef.current) return;

    const saveData: ResponseData<MENU_ID, SHEET_NAME>[] = [];
    const editMap = editTrackerRef.current.getOriginalValues();
    fcstData?.o_rc1
      .filter(row => row.CRUD_TYPE)
      .forEach(row => {
        Object.keys(row).forEach(key => {
          if (!key.startsWith('D_')) return;

          const changeMap = editMap.get(row);
          if (row.CRUD_TYPE === CRUD_TYPE.MODIFY && (!changeMap || !(key in changeMap))) return;

          const pivotedData = {
            PLAN_WEEK: row.PLAN_WEEK,
            DIVISION_ID: row.DIVISION_ID,
            DEPT_ID: row.DEPT_ID,
            CUSTOMER_CODE: row.CUSTOMER_CODE,
            SCM_SITE_ID: row.SCM_SITE_ID,
            MEASURE_GROUP: row.MEASURE_GROUP,
            MEASURE: row.MEASURE,
            EDI_FCST_YN: row.EDI_FCST_YN ?? 'Y',
            UPLOAD_UOM: row.UPLOAD_UOM,
            UPLOAD_BUCKET_TYPE: row.UPLOAD_BUCKET_TYPE,
            VALID_YN: row.VALID_YN,
            UPLOAD_ORDER: row.UPLOAD_ORDER,
            EDIT_FLAG: row.EDIT_FLAG,
            CRUD_TYPE: row.CRUD_TYPE ?? CRUD_TYPE.MODIFY,
            CUSTOMER_PSI: '',
            SUMMARY_BUCKET_TYPE: row.SUMMARY_BUCKET_TYPE,
            SUMMARY_BUCKET_VALUE: key.split('_')[1],
            SUMMARY_BUCKET_YN: row[key] ?? 'N',
          };

          saveData.push(pivotedData);
        });
      });

    saveWithValidation(saveData, staticColumn, saveMutation);
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
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={fcstData?.o_rc1.length ?? 0}
        excelFileName='Customer FCST Master'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <CustomerFcstMasterFcstGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        data={fcstData?.o_rc1 ?? []}
      />
    </>
  );
};
