import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS, TACT_MODE } from './tact-time.constants';
import type { MainRow, SearchCondition } from './tact-time.types';

type FiltersBySheet = {
  [SHEETS.PLANT]?: ProcRequest<MENU_ID, SHEETS.PLANT>;
  [SHEETS.PACKER]?: ProcRequest<MENU_ID, SHEETS.PACKER>;
  [SHEETS.EXCEPT]?: ProcRequest<MENU_ID, SHEETS.EXCEPT>;
};

type StaticColumnsBySheet = {
  [SHEETS.PLANT]: RawFlexGridColumnConfig[];
  [SHEETS.PACKER]: RawFlexGridColumnConfig[];
  [SHEETS.EXCEPT]: RawFlexGridColumnConfig[];
};

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch (미등록 시 빈 배열 →
  //   그리드가 constants 컬럼셋으로 fallback). 확인 필요: SCP0020 admin 등록 여부(design 03 §6).
  staticColumns: StaticColumnsBySheet;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setMode: (mode: TACT_MODE) => void;
  setFilter: () => void;
  clearFilters: () => void;
  // spdMain 선택행 더블클릭 -> 하단 spdExcept 파생 조회 (design 01 D-5 / 03 §4.2)
  setExceptFilter: (row: MainRow  ) => void;
  clearExceptFilter: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
}

const initSearch: SearchCondition = {
  // 기본 사업부 = 세션 division (formation 표준). 없으면 '40' fallback.
  divisionId: useSessionStore.getState().session.div ?? '40',
  plantSiteIds: [],
  lineIds: [],
  operationGroupId: 'P', // AS-IS 기본값 = P(Packer). ALL 옵션 없음 (cs:221 setListBox false).
  valid: 'ALL',
  itemId: '',
  mode: TACT_MODE.PACKER, // AS-IS 기본 활성 = Packer (design 01 D-3)
};

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.PLANT]: [],
  [SHEETS.PACKER]: [],
  [SHEETS.EXCEPT]: [],
};

const initState: State = {
  initialized: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  staticColumns: emptyStaticColumns,
};

// 다중 선택 배열 -> SP 파라미터 문자열 (빈 배열 = 'ALL' 센티널, design 02 §5.3)
const joinOrAll = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join(','));
const orAll = (v: string): string => (v && v.trim() ? v.trim() : 'ALL');
const str = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

export const useTactTimeStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    setMode: mode =>
      set(state => {
        // 모드 전환 = cascade 공급 경로 변경(design 02 §3) + 하위(plantSite/line) 초기화 + 그리드/필터 리셋.
        state.searchCondition = { ...get().searchCondition, mode, plantSiteIds: [], lineIds: [] };
        state.filters = {};
      }),
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        // design 02 §2.7 — Plant GET 만 p_valid 전달, Packer GET 은 미전달.
        if (c.mode === TACT_MODE.PLANT) {
          state.filters = {
            [SHEETS.PLANT]: {
              divisionId: orAll(c.divisionId),
              plantSiteId: joinOrAll(c.plantSiteIds),
              lineId: joinOrAll(c.lineIds),
              operationGroupId: orAll(c.operationGroupId),
              itemId: orAll(c.itemId),
              valid: orAll(c.valid),
              debugMode: 'N',
            },
          };
        } else {
          state.filters = {
            [SHEETS.PACKER]: {
              divisionId: orAll(c.divisionId),
              plantSiteId: joinOrAll(c.plantSiteIds),
              lineId: joinOrAll(c.lineIds),
              operationGroupId: orAll(c.operationGroupId),
              itemId: orAll(c.itemId),
              debugMode: 'N',
            },
          };
        }
      });
    },
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    setExceptFilter: row =>
      set(state => {
        const r = row as Record<string, unknown>;
        state.filters = {
          ...state.filters,
          [SHEETS.EXCEPT]: {
            divisionId: orAll(str(r.DIVISION_ID)),
            plantSite: orAll(str(r.PLANT_SITE_ID)),
            operationId: orAll(str(r.OPERATION_ID)),
            itemId: orAll(str(r.ITEM_ID)),
            lineId: orAll(str(r.LINE_ID)),
            debugMode: 'N',
          },
        };
      }),
    clearExceptFilter: () =>
      set(state => {
        delete state.filters[SHEETS.EXCEPT];
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),

    // admin SCM_MST_SHEET_COLUMNS 동적 fetch — 미등록/실패 시 빈 배열 유지(그리드 constants fallback).
    fetchStaticColumns: async () => {
      const sheets: (keyof StaticColumnsBySheet)[] = [SHEETS.PLANT, SHEETS.PACKER, SHEETS.EXCEPT];
      await Promise.all(
        sheets.map(async sheet => {
          try {
            const res = await apiClient.post<RawFlexGridColumnConfig[]>(
              `/admin/menu/${MENU_ID}/column`,
              { sheetNm: ADMIN_SHEET_NAME[sheet] ?? sheet }
            );
            const next = res.data.result ?? [];
            if (next.length === 0) return;
            set(state => {
              if (JSON.stringify(state.staticColumns[sheet]) !== JSON.stringify(next)) {
                state.staticColumns[sheet] = next;
              }
            });
          } catch {
            // 미등록/실패 = constants fallback (console 금지 룰)
          }
        })
      );
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'tact-time-store'
);
