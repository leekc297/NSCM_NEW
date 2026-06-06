import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { MENU_ID, SHEETS, RESPONSE_SET } from './bod.constants';
import type { SearchParamProps } from './bod.types';

/**
 * DMF0015 BOD — Zustand Store (Phase 6 PoC)
 * 룰 v2 _tobe/04_store.md 표준 적용
 */
type filtersBySheet = {
  [key in SHEETS]?: ProcRequest<MENU_ID, key>;
};

interface BodState {
  initialized: boolean;
  filters: filtersBySheet;
  searchParams: SearchParamProps;
  staticColumns: {
    [key in RESPONSE_SET]: RawFlexGridColumnConfig[];
  };
  openSearchArea: boolean;
}

interface BodAction {
  reset: () => void;
  setMainFilter: () => void;
  setBodItemFilter: (filter?: ProcRequest<MENU_ID, SHEETS.BOD_ITEM>) => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
}

const initSearchParams: SearchParamProps = {
  divisionId: useSessionStore.getState().session.div ?? '40',
  bodType: 'ALL',
  fromSite: 'ALL',
  toSite: 'ALL',
  activeFlag: 'ALL',
};

const initBodState: BodState = {
  initialized: false,
  filters: {
    [SHEETS.MAIN]: undefined,
    [SHEETS.BOD_ITEM]: undefined,
  },
  searchParams: initSearchParams,
  staticColumns: {
    [RESPONSE_SET.MAIN]: [],
    [RESPONSE_SET.BOD_ITEM]: [],
  },
  openSearchArea: true,
} as const;

export const useBodStore = createPersistedStoreWithTab<BodState & BodAction>(
  (set, get) => ({
    ...initBodState,
    reset: () => set(initBodState),
    setMainFilter: () => {
      set(state => {
        state.filters[SHEETS.MAIN] = { ...state.searchParams };
        // master row 미선택 → Sub 초기화
        state.filters[SHEETS.BOD_ITEM] = undefined;
      });
    },
    setBodItemFilter: (filter?: ProcRequest<MENU_ID, SHEETS.BOD_ITEM>) => {
      set(state => {
        state.filters[SHEETS.BOD_ITEM] = filter ? { ...filter } : undefined;
      });
    },
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
        if (searchParams.divisionId) {
          // Division 변경 시 column 메타 + filter reset
          void state.fetchStaticColumns();
          state.filters = initBodState.filters;
        }
      });
    },
    fetchStaticColumns: async () => {
      const [main, bodItem] = await Promise.all([
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: RESPONSE_SET.MAIN,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: RESPONSE_SET.BOD_ITEM,
        }),
      ]);
      set(state => {
        state.staticColumns = {
          [RESPONSE_SET.MAIN]: main.data.result,
          [RESPONSE_SET.BOD_ITEM]: bodItem.data.result,
        };
      });

      // G1 — 저장된 검색조건 자동 restore (룰 v2 _tobe/04_store.md §1.1 §6)
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
  'bod'   // persistent slug
);
