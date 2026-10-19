import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './distribution-route.constants';
import type { SearchCondition } from './distribution-route.types';

type FiltersBySheet = {
  [SHEETS.ROUTE]?: ProcRequest<MENU_ID, SHEETS.ROUTE>;
};

type StaticColumnsBySheet = {
  [SHEETS.ROUTE]: RawFlexGridColumnConfig[];
};

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // ui-dynamic-property-management — admin SCM_MST_SHEET_COLUMNS 동적 fetch (미등록 시 빈 배열 →
  //   그리드가 constants 컬럼셋으로 fallback). design 03 §0: PROGRAM_ID=SCP0005, SHEET_NAME='Distribution
  //   Route' 39행(31 'O' + 8 'S') 등록 실측(2026-09-25 ora.py).
  staticColumns: StaticColumnsBySheet;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
}

const initSearch: SearchCondition = {
  fromCountry: '',
  fromCity: '',
  toCountry: '',
  toCity: '',
  transportMode: 'ALL', // clbTransMode 기본 ALL=미선택/전체 (design 02 §4 — NameList="ALL")
  validYn: 'Y', // cboValidYN 기본 = 첫 항목 'Y' (design 02 §4 line 166, IsAllFlag=false → ALL 없음)
};

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.ROUTE]: [],
};

const initState: State = {
  initialized: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  staticColumns: emptyStaticColumns,
};

// 'ALL' sentinel / 공백 -> 빈값 치환 (design 02 §2.3/§4 — GET SP 파라미터 'ALL'->'').
const orEmpty = (v: string): string => {
  const t = (v ?? '').trim();
  return !t || t.toUpperCase() === 'ALL' ? '' : t;
};

export const useDistributionRouteStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        // GET SP SCP.SCP0005_GET_DISTRIBUTION_ROUTE 파라미터 매핑 (design 02 §4 / 03 §4.1 IN 순서):
        //   p_from_country, p_from_city, p_to_country, p_to_city, p_transport_mode, p_valid_yn.
        state.filters = {
          [SHEETS.ROUTE]: {
            fromCountry: orEmpty(c.fromCountry),
            fromCity: orEmpty(c.fromCity),
            toCountry: orEmpty(c.toCountry),
            toCity: orEmpty(c.toCity),
            transportMode: orEmpty(c.transportMode),
            validYn: orEmpty(c.validYn),
          },
        };
      });
    },
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),

    // admin SCM_MST_SHEET_COLUMNS 동적 fetch — 미등록/실패 시 빈 배열 유지(그리드 constants fallback).
    //   fetch 키 = ADMIN_SHEET_NAME('Distribution Route') — API 매핑 SHT_NM('route')과 분리(design 03 §6 #1).
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME[SHEETS.ROUTE] }
        );
        const next = res.data.result ?? [];
        if (next.length > 0) {
          set(state => {
            if (JSON.stringify(state.staticColumns[SHEETS.ROUTE]) !== JSON.stringify(next)) {
              state.staticColumns[SHEETS.ROUTE] = next;
            }
          });
        }
      } catch {
        // 미등록/실패 = constants fallback (console 금지 룰)
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'distribution-route-store'
);
