import { apiClient } from '@foundation/apis';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './customer-fcst-master.constants';
import { getFcstRangeByBucket } from './utils/CustomerFcstMasterDateColumns';

interface SearchParamProps {
  planWeek: string;
  divisionId: string;
  endCustomer: string;
  scmSiteId: string;
  bucketType: string;
  validYn: string;
  userId: string;
}

type FiltersBySheet = {
  [SHEETS.CUSTOMER_FCST]?: ProcRequest<MENU_ID, SHEETS.CUSTOMER_FCST>;
  [SHEETS.CUSTOMER_PSI]?: ProcRequest<MENU_ID, SHEETS.CUSTOMER_PSI>;
  [SHEETS.CUSTOMER_PSI_PIVOT]?: ProcRequest<MENU_ID, SHEETS.CUSTOMER_PSI_PIVOT>;
};

interface CustomerFcstMasterState {
  initialized: boolean;
  filters: FiltersBySheet;
  searchParams: SearchParamProps;
  staticColumns: {
    [SHEETS.CUSTOMER_FCST]: RawFlexGridColumnConfig[];
    [SHEETS.CUSTOMER_PSI]: RawFlexGridColumnConfig[];
  };
  dateColumns: FlexGridColumnConfig[];
  openSearchArea: boolean;
}

interface CustomerFcstMasterAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilter: () => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
  fetchDateColumns: () => void;
}

const initSearchParams: SearchParamProps = {
  planWeek: '',
  divisionId: '81',
  endCustomer: 'ALL',
  scmSiteId: 'ALL',
  bucketType: 'WEEKLY',
  validYn: 'ALL',
  userId: '',
};

const initCustomerFcstMasterState: CustomerFcstMasterState = {
  initialized: false,
  filters: {},
  searchParams: initSearchParams,
  staticColumns: {
    [SHEETS.CUSTOMER_FCST]: [],
    [SHEETS.CUSTOMER_PSI]: [],
  },
  dateColumns: [],
  openSearchArea: true,
} as const;

export const useCustomerFcstMasterStore = createPersistedStoreWithTab<
  CustomerFcstMasterState & CustomerFcstMasterAction
>(
  (set, get) => ({
    ...initCustomerFcstMasterState,
    reset: () => set(initCustomerFcstMasterState),
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
        if (searchParams.divisionId) {
          state.fetchStaticColumns();
          state.filters = initCustomerFcstMasterState.filters;
        }
      });
    },
    setFilter: () => {
      set(state => {
        const next = { ...state.searchParams };
        state.filters = {
          [SHEETS.CUSTOMER_FCST]: next,
          [SHEETS.CUSTOMER_PSI]: next,
          [SHEETS.CUSTOMER_PSI_PIVOT]: next,
        };
      });
    },
    fetchStaticColumns: async () => {
      const [fcstColumns, psiColumns] = await Promise.all([
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.CUSTOMER_FCST,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.CUSTOMER_PSI,
        }),
      ]);
      set(state => {
        state.staticColumns = {
          [SHEETS.CUSTOMER_FCST]: fcstColumns.data.result,
          [SHEETS.CUSTOMER_PSI]: psiColumns.data.result,
        };
      });
      if (get().initialized) return;
      const param = await apiClient.get<{ paramNm: keyof SearchParamProps; paramCtn: string }[]>(
        `/admin/menu/${MENU_ID}/search-conditions`
      );

      if (param.data.result?.length > 0) {
        const searchParams = param.data.result.reduce((acc, curr) => {
          acc[curr.paramNm] = curr.paramCtn;
          return acc;
        }, {} as SearchParamProps);

        set(state => {
          state.searchParams = searchParams;
        });
      }
      set(state => {
        state.initialized = true;
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      });
    },
    fetchDateColumns: () => {
      set({
        dateColumns: getFcstRangeByBucket(get().searchParams.bucketType ?? 'WEEKLY'),
      });
    },
  }),
  'customer-fcst-master'
);
