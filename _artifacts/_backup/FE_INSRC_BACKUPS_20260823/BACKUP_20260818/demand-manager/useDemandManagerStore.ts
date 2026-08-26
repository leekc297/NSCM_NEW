import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { DIVISION_40, MENU_ID, SHEETS } from './demand-manager.constants';
import type { SearchCondition } from './demand-manager.types';

// SP filter payload — useTabProcQuery 는 filters 를 참조로 비교하므로 store 참조를 그대로 넘긴다
// (인라인 객체 금지 — 무한 재조회 방지).
type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.LOOKUP_PROJECT]?: ProcRequest<MENU_ID, SHEETS.LOOKUP_PROJECT>;
};

interface State {
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  openSearchArea: boolean;
  staticColumns: RawFlexGridColumnConfig[];
  // 조회 시점에 고정한 기간 — 그리드 월 컬럼 산출의 단일 원천
  appliedFrom: string;
  appliedTo: string;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  applyColumnVisibility: (visibleKeys: string[]) => void;
}

// AS-IS InitControls — 기본 기간은 전년 1월 ~ 익년 12월 (36개월)
const defaultFrom = () => `${dayjs().subtract(1, 'year').format('YYYY')}01`;
const defaultTo = () => `${dayjs().add(1, 'year').format('YYYY')}12`;

const initSearch: SearchCondition = {
  versionNo: '', // ⭐ 버전 팝업 주입 전까지 조회 차단 (MSG00283)
  periodFrom: defaultFrom(),
  periodTo: defaultTo(),
};

const initState: State = {
  filters: {},
  searchCondition: initSearch,
  openSearchArea: true,
  staticColumns: [],
  appliedFrom: '',
  appliedTo: '',
};

export const useDemandManagerStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    setFilter: () => {
      set(state => {
        const c: SearchCondition = { ...initSearch, ...state.searchCondition };
        state.filters = {
          // ── PKG_DMF0068.P_DMF0068_GET_ORDERLIST (sesUserId·mnuId 는 BE 자동주입) ──
          [SHEETS.MAIN]: {
            divisionId: DIVISION_40,
            versionNo: c.versionNo,
            fromDt: c.periodFrom,
            toDt: c.periodTo,
          },
          // ── PKG_DMF0068.P_DMF0068_GET_LOOKUPPROJECT (Project 셀 콤보) ──
          [SHEETS.LOOKUP_PROJECT]: {
            divisionId: DIVISION_40,
            versionNo: c.versionNo,
          },
        };
        // 그리드 월 컬럼은 "조회에 사용된" 기간으로만 산출한다 (조회조건 편집 중 흔들리지 않도록 고정)
        state.appliedFrom = c.periodFrom;
        state.appliedTo = c.periodTo;
      });
    },
    clearFilters: () =>
      set(state => {
        state.filters = {};
        state.appliedFrom = '';
        state.appliedTo = '';
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),

    // ⭐ master hook §2.3 — Column 동적 fetch (SHEET_COLUMNS 159건 'ContributeSalesList')
    fetchStaticColumns: async () => {
      try {
        const result = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          {
            sheetNm: SHEETS.MAIN, // 'ContributeSalesList' — 등록명 그대로 (룰 #91)
            divisionId: DIVISION_40,
          }
        );
        set(state => {
          state.staticColumns = result.data.result ?? [];
        });
      } catch {
        // BE 메타 미응답 시 silent — 빈 배열 유지 (console 금지 룰)
      }
    },

    applyColumnVisibility: visibleKeys => {
      set(state => {
        const cur = state.staticColumns;
        if (!cur || cur.length === 0) return;
        const visibleSet = new Set(visibleKeys);
        state.staticColumns = cur.map(c => ({ ...c, display: visibleSet.has(c.colNm) }));
      });
    },
  }),
  'demand-manager'
);
