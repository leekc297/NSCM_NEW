import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, RESPONSE_SET, SHEETS } from './erp-edi-master.constants';
import type { SearchCondition } from './types';

type FiltersBySheet = {
  [SHEETS.SUMMARY]?: ProcRequest<MENU_ID, SHEETS.SUMMARY>;
  [SHEETS.REPAIR]?: ProcRequest<MENU_ID, SHEETS.REPAIR>;
  [SHEETS.SALES_SITE]?: ProcRequest<MENU_ID, SHEETS.SALES_SITE>;
  [SHEETS.SSPM]?: ProcRequest<MENU_ID, SHEETS.SSPM>;
};

interface UpdateHistoryEntry {
  SDATE?: string;
  EDATE?: string;
  UPDATED_BY?: string;
}

interface ErpEdiMasterState {
  initialized: boolean;
  filters: FiltersBySheet;
  // DMF0004 표준: state 이름 = searchParams (자매 화면 cross-check)
  searchParams: SearchCondition;
  openSearchArea: boolean;
  staticColumns: {
    summary: RawFlexGridColumnConfig[];
    repair: RawFlexGridColumnConfig[];
    salesSite: RawFlexGridColumnConfig[];
    sspm: RawFlexGridColumnConfig[];
  };
  // 메인 useTabProcQuery 결과 → useEffect 로 setUpdateHistory 호출 (Form 이 구독)
  updateHistory: UpdateHistoryEntry | undefined;
}

interface ErpEdiMasterAction {
  reset: () => void;
  /** DMF0004 표준 명칭 (Form 호출). Partial<SearchCondition> 받음 */
  setSearchParams: (params: Partial<SearchCondition>) => void;
  /** DMF0004 표준 명칭 (Form 호출). Summary + Repair filters 동시 set */
  setSummaryFilters: () => void;
  setRepairFilter: () => void;
  setSubFilter: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setUpdateHistory: (entry: UpdateHistoryEntry | undefined) => void;
  /**
   * BE 메타 GET → 4 sheet 의 staticColumns 자동 채움 (DMF0004 표준).
   * 메모리 feedback_grid_no_hardcoded_static_columns + feedback_fetchstaticcolumns_no_initialized_guard.
   * + G1 GET — 저장된 검색조건 자동 restore (initialized 가드).
   * BE: POST /admin/menu/{MENU_ID}/column { sheetNm } + GET /admin/menu/{MENU_ID}/search-conditions
   */
  fetchStaticColumns: () => Promise<void>;
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
    divisionId: '81',
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
  searchParams: initSearch,
  openSearchArea: true,
  staticColumns: { summary: [], repair: [], salesSite: [], sspm: [] },
  updateHistory: undefined,
};

export const useErpEdiMasterStore = createPersistedStoreWithTab<
  ErpEdiMasterState & ErpEdiMasterAction
>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchParams: params => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...params };
      });
    },
    // AS-IS FindData_Main + FindData_SubRepair (.cs L727, L800): Summary + Repair 동시 호출
    setSummaryFilters: () => {
      set(state => {
        const c = state.searchParams;
        state.filters = {
          ...state.filters,
          [SHEETS.SUMMARY]: {
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
    // AS-IS spdSummary_CellDoubleClick (.cs L1887) → FindData_SubRepair_New (.cs L1051)
    setRepairFilter: () => {
      set(state => {
        const c = state.searchParams;
        state.filters = {
          ...state.filters,
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
    setSubFilter: () => {
      set(state => {
        const c = state.searchParams;
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
    setUpdateHistory: entry => {
      set(state => {
        state.updateHistory = entry;
      });
    },
    /**
     * fetchStaticColumns — DMF0004 표준 (useSalesSiteStore:91 fetchStaticColumns 패턴 동일).
     * 메모리 feedback_fetchstaticcolumns_no_initialized_guard: initialized 가드는 `if (initialized) return` 이 아닌
     * 후반부의 search-conditions restore 부분에만 적용. column meta 는 매번 fetch.
     */
    fetchStaticColumns: async () => {
      // 개별 try/catch — 한 sheet fail 해도 다른 sheet 는 채움 (Promise.all 일괄 throw 방지)
      // + Array.isArray 가드 — BE 응답 형식이 예상과 다를 시 안전 (column 안 보임 사고 2026-06-10 fix)
      const fetchOne = async (sheetNm: string, extra?: Record<string, unknown>): Promise<RawFlexGridColumnConfig[]> => {
        try {
          const res = await apiClient.post<RawFlexGridColumnConfig[]>(
            `/admin/menu/${MENU_ID}/column`,
            { sheetNm, ...extra }
          );
          const result = res.data?.result;
          return Array.isArray(result) ? result : [];
        } catch {
          return [];
        }
      };
      const divId = get().searchParams.divisionId === '40' ? '40' : undefined;
      const [summary, repair, salesSite, sspm] = await Promise.all([
        fetchOne(SHEETS.SUMMARY, { divisionId: divId }),
        fetchOne(SHEETS.REPAIR),
        fetchOne(SHEETS.SALES_SITE),
        fetchOne(SHEETS.SSPM),
      ]);
      set(state => {
        state.staticColumns = { summary, repair, salesSite, sspm };
      });
      if (get().initialized) return;
      // G1 GET — 저장된 검색조건 자동 restore (Phase 7 PoC 패턴)
      try {
        const param = await apiClient.get<
          { paramNm: keyof SearchCondition; paramCtn: string }[]
        >(`/admin/menu/${MENU_ID}/search-conditions`);
        if (param.data.result?.length > 0) {
          const restored = param.data.result.reduce((acc, curr) => {
            acc[curr.paramNm] = curr.paramCtn as SearchCondition[typeof curr.paramNm];
            return acc;
          }, {} as Partial<SearchCondition>);
          set(state => {
            state.searchParams = { ...state.searchParams, ...restored };
          });
        }
      } catch {
        // G1 GET 실패는 silently fail — default initSearch 유지
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  // storageName v2 — store schema 변경 (staticColumns key 'main' → 'summary' 등) 으로 sessionStorage stale state 무시.
  // 어제 v1 schema 의 staticColumns 가 새 selector state.staticColumns.summary 와 호환 안 됨 → DataGrid.filter() null read 사고 (2026-06-10).
  'erp-edi-master-v2'
);

// (placeholder ref — type-check 의미 없는 미사용 변수 회피)
void RESPONSE_SET;
