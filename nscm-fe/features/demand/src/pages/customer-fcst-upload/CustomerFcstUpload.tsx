import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByDivisionModal, ProjectByDivisionModal } from 'features/master/src/components';
import { useEffect, useRef, useState } from 'react';

import _ from '@foundation/lodash';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { Alert, MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { FcstUploadModal } from '../../components';

import { CustomerFcstUploadForm } from './components/CustomerFcstUploadForm';
import { CustomerFcstUploadGrid } from './components/CustomerFcstUploadGrid';
import { MENU_ID, SHEETS } from './customer-fcst-upload.constant';
import { useCustomerFcstUploadStore } from './useCustomerFcstUploadStore';

export const CustomerFcstUpload = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS>>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const { setAlert } = useMessageStore();

  const isOpenSearchArea = useCustomerFcstUploadStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useCustomerFcstUploadStore(state => state.setOpenSearchArea);
  const searchParams = useCustomerFcstUploadStore(state => state.searchParams);
  const filters = useCustomerFcstUploadStore(state => state.filters);
  const setFilters = useCustomerFcstUploadStore(state => state.setFilters);
  const initialized = useCustomerFcstUploadStore(state => state.initialized);
  const fetchStaticColumns = useCustomerFcstUploadStore(state => state.fetchStaticColumns);

  const [openPrjByDivisionModal, setOpenPrjByDivisionModal] = useState<boolean>(false);
  const [openModelByDivisionModal, setOpenModelByDivisionModal] = useState<boolean>(false);
  const [openFcstUploadModal, setOpenFcstUploadModal] = useState<boolean>(false);

  const { data, refetch } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.CUSTOMER_FCST_UPLOAD,
    tabId,
    filters,
    enabled: !!filters,
  });

  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
  }, [tabId]);

  const handleSubmit = () => {
    if (_.isEqual(searchParams, filters)) void refetch();
    else setFilters();
  };

  const hotkeyConfig: HotkeyConfig = {
    search: handleSubmit,
    manual: false,
    excel: false,
    delete: false,
    upload: () => setOpenFcstUploadModal(true),
    insert: async () => {
      // TODO: add multi-lang for the content of this message
      await setAlert({
        content: 'This screen does not allowed to directly INSERT, so please use the Excel upload',
      });
    },
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <CustomerFcstUploadForm
        onSubmit={handleSubmit}
        setOpenPrjByDivisionModal={setOpenPrjByDivisionModal}
        setOpenModelByDivisionModal={setOpenModelByDivisionModal}
      />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={data?.o_rc1.length ?? 0}
        excelFileName='Customer-Fcst-Upload'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <CustomerFcstUploadGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        data={data?.o_rc1 ?? []}
      />
      <ProjectByDivisionModal
        open={openPrjByDivisionModal}
        modalClose={() => setOpenPrjByDivisionModal(false)}
        setSelectedValue={() => {}}
        // TODO: replace with real data, just mock for preventing required props error
        preSearchParams={{
          deptId: 'string',
          divisionId: '1',
          endCustomer: '1',
          etc: 'string',
          projectCode: 'string',
          salesSite: 'string',
        }}
        callFromCell={false}
      />
      <ItemByDivisionModal
        open={openModelByDivisionModal}
        modalClose={() => setOpenModelByDivisionModal(false)}
        setSelectedValue={() => {}}
        preSearchParams={{
          deptId: 'string',
          divisionId: '40',
          endCustomer: '1',
          salesSite: 'string',
          projectCode: 'string',
          itemId: 'string',
          activeFlag: 'string',
        }}
        callFromCell={false}
      />
      <FcstUploadModal
        open={openFcstUploadModal}
        modalClose={() => setOpenFcstUploadModal(false)}
      />
      <Alert />
    </>
  );
};
