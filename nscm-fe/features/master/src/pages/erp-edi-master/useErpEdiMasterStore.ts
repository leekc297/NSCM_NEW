import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { MENU_ID, SHEETS } from './erp-edi-master.constants';

interface SearchParamProps {
  divisionId: string;
}

interface UpdateHistory {
  SDATE: string;
  EDATE: string;
  UPDATED_BY: string;
}

interface RepairContext {
  division: string;
  senderName: string;
  flag: string;
  erpSoldTo: string;
  erpShipTo: string;
  erpItemId: string;
  gscmSalesSiteId: string;
  activeSs: string;
  gscmSspm: string;
}

type filtersBySheet = {
  [key in SHEETS]?: ProcRequest<MENU_ID, key>;
};

interface ErpEdiMasterState {
  initialized: boolean;
  loading: boolean;
  filters: filtersBySheet;
  searchParams: SearchParamProps;
  staticColumns: {
    [SHEETS.SUMMARY]: RawFlexGridColumnConfig[];
    [SHEETS.REPAIR]: RawFlexGridColumnConfig[];
    [SHEETS.SALES_SITE]: RawFlexGridColumnConfig[];
    [SHEETS.SSPM]: RawFlexGridColumnConfig[];
  };

  updateHistory: UpdateHistory | undefined;
  repairContext: RepairContext | undefined;

  openSearchArea: boolean;
  error: string | null;
}

interface ErpEdiMasterAction {
  reset: () => void;
  setSummaryFilters: () => void;
  setRepairFilters: (input: { division: string; senderName: string; flag: string }) => void;
  setSalesSiteFilters: (input: {
    divisionId: string;
    soldTo: string;
    shipTo: string;
    scmSiteId: string;
  }) => void;
  setSspmFilters: (input: { divisionId: string; itemId: string; scmSiteId: string }) => void;
  clearSubFilters: () => void;
  setRepairContext: (ctx: RepairContext | undefined) => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchUpdateHistory: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
}

const initSearchParams: SearchParamProps = {
  divisionId: useSessionStore.getState().session.div ?? '',
};

const initErpEdiMasterStoreState: ErpEdiMasterState = {
  initialized: false,
  loading: false,
  filters: {
    [SHEETS.SUMMARY]: undefined,
    [SHEETS.REPAIR]: undefined,
    [SHEETS.SALES_SITE]: undefined,
    [SHEETS.SSPM]: undefined,
  },
  searchParams: initSearchParams,
  staticColumns: {
    [SHEETS.SUMMARY]: [],
    [SHEETS.REPAIR]: [],
    [SHEETS.SALES_SITE]: [],
    [SHEETS.SSPM]: [],
  },

  updateHistory: undefined,
  repairContext: undefined,

  openSearchArea: true,
  error: null,
} as const;

export const useErpEdiMasterStore = createPersistedStoreWithTab<
  ErpEdiMasterState & ErpEdiMasterAction
>(
  (set, get) => ({
    ...initErpEdiMasterStoreState,

    reset: () => set(initErpEdiMasterStoreState),

    setSummaryFilters: () => {
      const sesUserId = useSessionStore.getState().session.userId ?? '';
      set(state => {
        state.filters[SHEETS.SUMMARY] = {
          divisionId: state.searchParams.divisionId,
          sesUserId,
          menuId: MENU_ID,
        };
        // Search 클릭 시 하위 그리드 초기화
        state.filters[SHEETS.REPAIR] = undefined;
        state.filters[SHEETS.SALES_SITE] = undefined;
        state.filters[SHEETS.SSPM] = undefined;
        state.repairContext = undefined;
      });
    },

    setRepairFilters: input => {
      const sesUserId = useSessionStore.getState().session.userId ?? '';
      set(state => {
        state.filters[SHEETS.REPAIR] = {
          divisionId: input.division,
          senderName: input.senderName,
          flag: input.flag,
          sesUserId,
          menuId: MENU_ID,
        };
        // Repair 재조회 시 sub 그리드 클리어
        state.filters[SHEETS.SALES_SITE] = undefined;
        state.filters[SHEETS.SSPM] = undefined;
      });
    },

    setSalesSiteFilters: input => {
      const sesUserId = useSessionStore.getState().session.userId ?? '';
      set(state => {
        state.filters[SHEETS.SALES_SITE] = {
          divisionId: input.divisionId,
          soldTo: input.soldTo,
          shipTo: input.shipTo,
          scmSiteId: input.scmSiteId,
          sesUserId,
          menuId: MENU_ID,
        };
      });
    },

    setSspmFilters: input => {
      const sesUserId = useSessionStore.getState().session.userId ?? '';
      set(state => {
        state.filters[SHEETS.SSPM] = {
          divisionId: input.divisionId,
          itemId: input.itemId,
          scmSiteId: input.scmSiteId,
          sesUserId,
          menuId: MENU_ID,
        };
      });
    },

    clearSubFilters: () => {
      set(state => {
        state.filters[SHEETS.SALES_SITE] = undefined;
        state.filters[SHEETS.SSPM] = undefined;
      });
    },

    setRepairContext: ctx => {
      set(state => {
        state.repairContext = ctx;
      });
    },

    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
        if (searchParams.divisionId) {
          // Division 변경 시 헤더 재로드 + 하위 필터 초기화
          void state.fetchStaticColumns();
          state.filters = initErpEdiMasterStoreState.filters;
          state.repairContext = undefined;
        }
      });
    },

    fetchStaticColumns: async () => {
      const [summary, repair, salesSite, sspm] = await Promise.all([
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.SUMMARY,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.REPAIR,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.SALES_SITE,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.SSPM,
        }),
      ]);
      set(state => {
        state.staticColumns = {
          [SHEETS.SUMMARY]: summary.data.result,
          [SHEETS.REPAIR]: repair.data.result,
          [SHEETS.SALES_SITE]: salesSite.data.result,
          [SHEETS.SSPM]: sspm.data.result,
        };
      });
      if (get().initialized) return;
      set(state => {
        state.initialized = true;
      });
    },

    fetchUpdateHistory: async () => {
      // TODO(F4): DMF0000_GET_UPDATE_HISTORY — API_M 미등록. BE 등록 후 apiClient.callProc 또는 별도 SHEET 사용
      // 임시 placeholder — 실제 SP 매핑 확정 시 교체
    },

    setOpenSearchArea: open => {
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      });
    },
  }),
  'erp-edi-master'
);
