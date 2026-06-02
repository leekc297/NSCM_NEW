import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './erp-edi-master.constants';
import type { SearchCondition } from './types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.REPAIR]?: ProcRequest<MENU_ID, SHEETS.REPAIR>;
  [SHEETS.SALES_SITE]?: ProcRequest<MENU_ID, SHEETS.SALES_SITE>;
  [SHEETS.SSPM]?: ProcRequest<MENU_ID, SHEETS.SSPM>;
};

interface ErpEdiMasterState {
  initialized: boolean;
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  openSearchArea: boolean;
}

interface ErpEdiMasterAction {
  reset: () => void;
  setSearchCondition: (params: Partial<SearchCondition>) => void;
  setFilter: () => void;
  setSubFilter: () => void;
  setOpenSearchArea: (open?: boolean) => void;
}

const fmtYyyymmdd = (d: Date): string =>
  `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}${String(d.getDate()).padStart(2, '0')}`;

const initSearch: SearchCondition = (() => {
  const now = new Date();
  const start = new Date(now.getFullYear(), now.getMonth(), 1);
  const end = new Date(now.getFullYear(), now.getMonth() + 3, 0);
  return {
    fromYyyymmdd: fmtYyyymmdd(start),
    toYyyymmdd: fmtYyyymmdd(end),
    divisionId: '40',
    senderName: '',
    flag: 'ALL',
    selectedItemId: '',
    selectedScmSiteId: '',
    selectedSoldTo: '',
    selectedShipTo: '',
  };
})();

const initState: ErpEdiMasterState = {
  initialized: false,
  filters: {},
  searchCondition: initSearch,
  openSearchArea: true,
};

export const useErpEdiMasterStore = createPersistedStoreWithTab<
  ErpEdiMasterState & ErpEdiMasterAction
>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: params => {
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...params };
      });
    },
    // AS-IS FindData_Main + FindData_SubRepair (.cs L727, L800): Summary + Repair 동시 호출
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        state.filters = {
          ...state.filters,
          [SHEETS.MAIN]: {
            fromYyyymmdd: c.fromYyyymmdd,
            toYyyymmdd: c.toYyyymmdd,
            divisionId: c.divisionId,
          },
          [SHEETS.REPAIR]: {
            divisionId: c.divisionId,
            fromYyyymmdd: c.fromYyyymmdd,
            toYyyymmdd: c.toYyyymmdd,
            senderName: c.senderName,
            flag: c.flag,
          },
        };
      });
    },
    // AS-IS FindData_SubSalesSite (.cs L895) + FindData_SubSalesSiteProjectModel (.cs L946)
    // 3단 (sub) 의 SALES_SITE / SSPM 호출 trigger — 메인 row 더블클릭 시 호출
    setSubFilter: () => {
      set(state => {
        const c = state.searchCondition;
        state.filters = {
          ...state.filters,
          [SHEETS.SALES_SITE]: {
            divisionId: c.divisionId,
            soldTo: c.selectedSoldTo,
            shipTo: c.selectedShipTo,
            scmSiteId: c.selectedScmSiteId,
          },
          [SHEETS.SSPM]: {
            divisionId: c.divisionId,
            itemId: c.selectedItemId,
            scmSiteId: c.selectedScmSiteId,
          },
        };
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      });
    },
  }),
  'erp-edi-master'
);
