import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './warehouse-capacity.constants';
import type { SearchCondition } from './warehouse-capacity.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

interface StaticColumnsBySheet {
  main: RawFlexGridColumnConfig[];
  itemMapping: RawFlexGridColumnConfig[];
}

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch(31행 등록됨,
  //   design 03 §0/§1). 미등록/실패 시 빈 배열.
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
  // 기본 사업부 = 세션 division (supply 표준, outsourcing-capacity/formation 동일 관례).
  divisionId: useSessionStore.getState().session.div ?? '',
  planGroupIds: [],
  siteIds: [],
  stages: [],
  warehouses: [],
  validYn: 'ALL',
  fromYyyymmdd: '',
  toYyyymmdd: '',
  itemId: '',
};

const emptyStaticColumns: StaticColumnsBySheet = {
  main: [],
  itemMapping: [],
};

const initState: State = {
  initialized: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  staticColumns: emptyStaticColumns,
};

// 다중 선택 배열 -> SP 파라미터 문자열. 콤마 결합(design 02 §7 cascade 필터 재현, SCP0129/0130 선례).
//   빈 선택 = 'ALL'(서버 필터 미적용) — AS-IS 필터방식/재조회방식 확정 전까지의 보수적 기본값.
const joinOrAll = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join(','));
const orAll = (v: string): string => (v && v.trim() ? v.trim() : 'ALL');

export const useWarehouseCapacityStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // GET 파라미터(procedures.d.ts SCP0133.main.request, design 03 §4.2 9파라미터 순서 그대로).
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: orAll(c.divisionId),
            opmzPlanGrId: joinOrAll(c.planGroupIds),
            siteId: joinOrAll(c.siteIds),
            stage: joinOrAll(c.stages),
            whNm: joinOrAll(c.warehouses),
            fromYyyymmdd: c.fromYyyymmdd,
            toYyyymmdd: c.toYyyymmdd,
            itemId: orAll(c.itemId),
            validYn: orAll(c.validYn),
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
    // admin SCM_MST_SHEET_COLUMNS 동적 fetch — 2시트(Warehouse Capacity/Warehouse Item Mapping,
    //   design 03 §0). 미등록/실패 시 빈 배열 유지.
    fetchStaticColumns: async () => {
      try {
        const [main, itemMapping] = await Promise.all([
          apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
            sheetNm: ADMIN_SHEET_NAME.MAIN,
          }),
          apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
            sheetNm: ADMIN_SHEET_NAME.ITEM_MAPPING,
          }),
        ]);
        set(state => {
          state.staticColumns = {
            main: main.data.result ?? [],
            itemMapping: itemMapping.data.result ?? [],
          };
        });
      } catch {
        // 미등록/실패 = 빈 배열 유지(console 금지 룰)
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'warehouse-capacity-store'
);
