import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './program.constants';

interface SearchParamProps {
  search: string;
}

interface ProgramState {
  initialized: boolean;
  filters?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  searchParams: SearchParamProps;
  staticColumns: RawFlexGridColumnConfig[];
  isOpenSearchArea: boolean;
}

interface ProgramAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
}

const initSearch: SearchParamProps = { search: '' };

const initState: ProgramState = {
  initialized: false,
  filters: undefined,
  searchParams: initSearch,
  staticColumns: [],
  isOpenSearchArea: true,
} as const;

export const useProgramStore = createPersistedStoreWithTab<ProgramState & ProgramAction>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
      });
    },
    setFilters: () => {
      set(state => {
        state.filters = { ...state.searchParams };
      });
    },
    fetchStaticColumns: async () => {
      const result = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        { sheetNm: SHEETS.MAIN }
      );
      set(state => {
        state.staticColumns = result.data.result;
      });
      set(state => {
        state.initialized = true;
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
  }),
  'program'
);
