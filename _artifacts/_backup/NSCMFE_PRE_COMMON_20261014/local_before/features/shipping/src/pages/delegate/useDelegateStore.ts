import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './delegate.constants';
import type { DelegateInput } from './delegate.types';

type FiltersBySheet = {
  [SHEETS.DELEGATE]?: ProcRequest<MENU_ID, SHEETS.DELEGATE>;
};

type StaticColumnsBySheet = Record<SHEETS, RawFlexGridColumnConfig[]>;

interface State {
  initialized: boolean;
  input: DelegateInput;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  activeSheet: SHEETS; // R1/R2 — Delegate 일 때만 SAVE/UnSet 노출 (design 01 §2)
  // ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch. 미등록/실패 시
  //   빈 배열 -> 그리드 constants fallback. 실측: SSP0020 컬럼메타 16행 배포됨(design 03 §0).
  staticColumns: StaticColumnsBySheet;
}

interface Action {
  reset: () => void;
  setInput: (p: Partial<DelegateInput>) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setActiveSheet: (sheet: SHEETS) => void;
  fetchStaticColumns: () => Promise<void>;
}

const initInput: DelegateInput = {
  divisionIds: [],
  fromDate: '',
  toDate: '',
  delegatee: '',
  delegateeId: '',
};

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.DELEGATE]: [],
  [SHEETS.DELEGATED]: [],
};

const initState: State = {
  initialized: false,
  input: initInput,
  filters: {},
  openSearchArea: true,
  activeSheet: SHEETS.DELEGATE,
  staticColumns: emptyStaticColumns,
};

export const useDelegateStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setInput: p =>
      set(state => {
        state.input = { ...get().input, ...p };
      }),
    // GET(SSP0020_GET_DELEGATE) 파라미터 = p_user_id(BE @LoginUser 세션 주입)/p_language 만.
    //   입력영역(division/period/delegatee)은 조회 필터 아님(design 02 §5) — SAVE/UNSET payload 전용.
    setFilter: () => {
      set(state => {
        state.filters = {
          [SHEETS.DELEGATE]: {
            language: useSessionStore.getState().session.langCd ?? '',
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
    setActiveSheet: sheet =>
      set(state => {
        state.activeSheet = sheet;
      }),

    // admin SCM_MST_SHEET_COLUMNS 동적 fetch (2시트) — 미등록/실패 시 빈 배열(그리드 constants fallback).
    fetchStaticColumns: async () => {
      for (const sheet of [SHEETS.DELEGATE, SHEETS.DELEGATED]) {
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
          // 미등록/실패 = constants fallback (console 금지 룰)
        }
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'delegate-store'
);
