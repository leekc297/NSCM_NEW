import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { MENU_ID, RESPONSE_SET, SHEETS } from './sales-site-project-model.constants';

interface SearchParamProps {
  divisionId: string;
  deptId: string;
  endCustomer: string;
  salesSite: string;
  projectCode: string;
  itemId: string;
  activeFlag: string;
  owner: string;
}

type filtersBySheet = {
  [SHEETS.PRODUCTION]?: ProcRequest<MENU_ID, SHEETS.PRODUCTION>;
  [SHEETS.PURCHASE]?: ProcRequest<MENU_ID, SHEETS.PURCHASE>;
};

interface SalesSiteProjectModelState {
  initialized: boolean;
  filters: filtersBySheet;
  searchParams: SearchParamProps;
  staticColumns: {
    [key in SHEETS]: RawFlexGridColumnConfig[];
  };
  openSearchArea: boolean;
  openPurchaseGrid: boolean;
}

interface SalesSiteProjectModelAction {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setOpenPurchaseGrid: (open?: boolean) => void;
  setProductionFilter: () => void;
  setPurchaseFilter: (filter?: ProcRequest<MENU_ID, SHEETS.PURCHASE>) => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  fetchStaticColumns: () => Promise<void>;
}

const initSearchParams: SearchParamProps = {
  divisionId: useSessionStore.getState().session.div ?? '40',
  deptId: 'ALL',
  endCustomer: 'ALL',
  salesSite: 'ALL',
  projectCode: '',
  itemId: '',
  activeFlag: 'ALL',
  owner: '',
};

const initSalesSiteProjectModelState: SalesSiteProjectModelState = {
  initialized: false,
  openSearchArea: true,
  openPurchaseGrid: true,
  filters: {
    [SHEETS.PRODUCTION]: undefined,
    [SHEETS.PURCHASE]: undefined,
  },
  searchParams: initSearchParams,
  staticColumns: {
    [SHEETS.PRODUCTION]: [],
    [SHEETS.PURCHASE]: [],
  },
};

export const useSalesSiteProjectModelStore = createPersistedStoreWithTab<
  SalesSiteProjectModelState & SalesSiteProjectModelAction
>(
  (set, get) => ({
    ...initSalesSiteProjectModelState,
    reset: () => set(initSalesSiteProjectModelState),
    setOpenSearchArea: open => {
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      });
    },
    setOpenPurchaseGrid: open => {
      set(state => {
        state.openPurchaseGrid = open ?? !state.openPurchaseGrid;
      });
    },
    setProductionFilter: () => {
      set(state => {
        state.filters[SHEETS.PRODUCTION] = { ...state.searchParams };
        state.filters[SHEETS.PURCHASE] = undefined;
      });
    },
    setPurchaseFilter: (filter?: ProcRequest<MENU_ID, SHEETS.PURCHASE>) => {
      set(state => {
        state.filters[SHEETS.PURCHASE] = filter ? { ...filter } : undefined;
      });
    },
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
        if (searchParams.divisionId) {
          void state.fetchStaticColumns();
          state.filters = initSalesSiteProjectModelState.filters;
        }
      });
    },
    fetchStaticColumns: async () => {
      const columnDivision = get().searchParams.divisionId ?? '81';
      const [production, purchase] = await Promise.all([
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: RESPONSE_SET.PRODUCTION,
          divisionId: columnDivision.startsWith('81_') ? '81' : columnDivision,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: RESPONSE_SET.PURCHASE,
          divisionId: columnDivision.startsWith('81_') ? '81' : columnDivision,
        }),
      ]);
      set(state => {
        state.staticColumns = {
          [SHEETS.PRODUCTION]: production.data.result,
          [SHEETS.PURCHASE]: purchase.data.result,
        };
      });
      if (get().initialized) return;
      void (async () => {
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
      })();
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'sales-site-project-model'
);
