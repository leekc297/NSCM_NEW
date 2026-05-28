import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { SHEETS, MENU_ID, RESPONSE_SET } from './sales-site.constants';

interface SearchParamProps {
  divisionId: string;
  endCustomer: string;
  salesSite: string;
  activeFlag: string;
  soldToCustomer: string;
}

type filtersBySheet = {
  [key in SHEETS]?: ProcRequest<MENU_ID, key>;
};
interface SalesSiteState {
  initialized: boolean;
  loading: boolean;
  filters: filtersBySheet;
  searchParams: SearchParamProps;
  staticColumns: {
    [key in RESPONSE_SET]: RawFlexGridColumnConfig[];
  };

  openSearchArea: boolean;
  error: string | null;
}

interface SalesSiteAction {
  reset: () => void;
  setSiteFilters: () => void;
  setDetailFilters: (filter?: ProcRequest<MENU_ID, SHEETS.CUSTOMER>) => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
}

const initSearchParams: SearchParamProps = {
  divisionId: useSessionStore.getState().session.div ?? '40',
  endCustomer: 'ALL',
  salesSite: 'ALL',
  activeFlag: 'ALL',
  soldToCustomer: 'ALL',
};

const initSalesSiteStoreState: SalesSiteState = {
  initialized: false,
  loading: false,
  filters: {
    [SHEETS.SITE]: undefined,
    [SHEETS.CUSTOMER]: undefined,
  },
  searchParams: initSearchParams,
  staticColumns: {
    [RESPONSE_SET.SITE]: [],
    [RESPONSE_SET.CUSTOMER]: [],
    [RESPONSE_SET.LOCATION]: [],
    [RESPONSE_SET.BUCKET]: [],
  },

  openSearchArea: true,
  error: null,
} as const;

export const useSalesSiteStore = createPersistedStoreWithTab<SalesSiteState & SalesSiteAction>(
  (set, get) => ({
    ...initSalesSiteStoreState,
    reset: () => set(initSalesSiteStoreState),
    setSiteFilters: () => {
      set(state => {
        state.filters[SHEETS.SITE] = { ...state.searchParams };
        state.filters[SHEETS.CUSTOMER] = undefined;
      });
    },
    setDetailFilters: (filter?: ProcRequest<MENU_ID, SHEETS.CUSTOMER>) => {
      set(state => {
        state.filters[SHEETS.CUSTOMER] = filter ? { ...filter } : undefined;
      });
    },
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
        if (searchParams.divisionId) {
          void state.fetchStaticColumns();
          state.filters = initSalesSiteStoreState.filters;
        }
      });
    },
    fetchStaticColumns: async () => {
      const [site, customer, location, bucket] = await Promise.all([
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: RESPONSE_SET.SITE,
          divisionId: get().searchParams.divisionId === '40' ? '40' : undefined,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: RESPONSE_SET.CUSTOMER,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: RESPONSE_SET.LOCATION,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: RESPONSE_SET.BUCKET,
        }),
      ]);
      set(state => {
        state.staticColumns = {
          [RESPONSE_SET.SITE]: site.data.result,
          [RESPONSE_SET.CUSTOMER]: customer.data.result,
          [RESPONSE_SET.LOCATION]: location.data.result,
          [RESPONSE_SET.BUCKET]: bucket.data.result,
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
  }),
  'sales-site'
);
