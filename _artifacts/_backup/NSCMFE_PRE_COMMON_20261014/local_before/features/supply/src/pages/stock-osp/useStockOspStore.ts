import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS, TAB_INDEX } from './stock-osp.constants';
import type { SearchCondition } from './stock-osp.types';

// useTabProcQuery enabled 가드용 filter payload — store 보관 참조만 전달(인라인 객체 금지, 참조비교 함정).
type FiltersBySheet = {
  [SHEETS.OSP]?: ProcRequest<MENU_ID, SHEETS.OSP>;
  [SHEETS.PACK]?: ProcRequest<MENU_ID, SHEETS.PACK>;
};

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  activeTab: TAB_INDEX;
  // admin SCM_MST_SHEET_COLUMNS 동적 fetch — 시트별(Osp 14 / Pack 15, design 03 §1). 컬럼명 하드코딩 금지.
  staticColumns: Partial<Record<SHEETS, RawFlexGridColumnConfig[]>>;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: (sheet: SHEETS) => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setActiveTab: (tab: TAB_INDEX) => void;
  fetchStaticColumns: (sheets: SHEETS[]) => Promise<void>;
}

// 기본 조회조건 — Division 은 세션 사업부 기본(페이지 mount 시 권한 첫 항목으로 재보정) / 멀티 = [](ALL) /
//   Status = ''(전체) / 날짜는 Form PeriodField 기본 로직에 위임(빈 값 시작).
const initSearch: SearchCondition = {
  divisionId: useSessionStore.getState().session.div ?? '',
  plantSiteIds: [],
  itemId: '',
  fromYyyymmdd: '',
  toYyyymmdd: '',
  inspectionId: '',
  status: '',
  cutoffFromYyyymmdd: '',
  cutoffToYyyymmdd: '',
};

const initState: State = {
  initialized: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  activeTab: TAB_INDEX.OSP,
  staticColumns: {},
};

const trim = (v: string): string => (v && v.trim() ? v.trim() : '');
// 다중 Plant Site → SP 파라미터. 전체선택/미선택(빈 배열) = 빈 문자열(NULL=전체), 부분선택 = 콤마 결합
//   (design 02 §Osp/§Pack — 콤보 SQL 이 INSTR/등호로 파싱. 'ALL' 문자열 전달 금지).
const multiParam = (ids: string[]): string => (ids.length === 0 ? '' : ids.join(','));

export const useStockOspStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // GET SP 파라미터 매핑 (PROC_M COL_NM = P_ 제거 camelCase, ALL_ARGUMENTS 실측):
    //   Osp  P_SCP0041_GET_STOCK_OSP(5)      : divisionId/plantSiteId/itemId/fromYyyymmdd/toYyyymmdd
    //   Pack P_SCP0041_GET_PACK_HOLD_STOCK(9): + inspectionId/status/cutoffFromYyyymmdd/cutoffToYyyymmdd
    //   sesUserId/mnuId 는 BE 세션 자동주입 — payload 미포함.
    setFilter: sheet => {
      set(state => {
        const c = state.searchCondition;
        if (sheet === SHEETS.OSP) {
          state.filters[SHEETS.OSP] = {
            divisionId: c.divisionId,
            plantSiteId: multiParam(c.plantSiteIds),
            itemId: trim(c.itemId),
            fromYyyymmdd: trim(c.fromYyyymmdd),
            toYyyymmdd: trim(c.toYyyymmdd),
          };
        } else {
          state.filters[SHEETS.PACK] = {
            divisionId: c.divisionId,
            plantSiteId: multiParam(c.plantSiteIds),
            itemId: trim(c.itemId),
            fromYyyymmdd: trim(c.fromYyyymmdd),
            toYyyymmdd: trim(c.toYyyymmdd),
            inspectionId: trim(c.inspectionId),
            status: trim(c.status),
            cutoffFromYyyymmdd: trim(c.cutoffFromYyyymmdd),
            cutoffToYyyymmdd: trim(c.cutoffToYyyymmdd),
          };
        }
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
    setActiveTab: tab =>
      set(state => {
        state.activeTab = tab;
      }),

    // admin SCM_MST_SHEET_COLUMNS 동적 fetch — 시트별. 미등록/실패 시 기존 배열 유지(하드코딩 fallback 금지).
    fetchStaticColumns: async sheets => {
      await Promise.all(
        sheets.map(async sheet => {
          try {
            const res = await apiClient.post<RawFlexGridColumnConfig[]>(
              `/admin/menu/${MENU_ID}/column`,
              { sheetNm: ADMIN_SHEET_NAME[sheet] }
            );
            const next = res.data.result ?? [];
            if (next.length > 0) {
              set(state => {
                if (JSON.stringify(state.staticColumns[sheet]) !== JSON.stringify(next)) {
                  state.staticColumns[sheet] = next;
                }
              });
            }
          } catch {
            // 미등록/실패 (console 금지 룰 · 하드코딩 fallback 금지)
          }
        })
      );
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'stock-osp-store'
);
