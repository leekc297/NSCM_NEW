import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import type { ActiveGrid } from './lookup.constants';
import { MENU_ID, SHEETS } from './lookup.constants';

interface SearchParamProps {
  lookupType: string;
  lookupGroup: string;
  validYn: string;
}

interface LookupFilters {
  [SHEETS.LOOKUP_MASTER]?: ProcRequest<MENU_ID, SHEETS.LOOKUP_MASTER>;
  [SHEETS.LOOKUP_DETAIL]?: ProcRequest<MENU_ID, SHEETS.LOOKUP_DETAIL>;
}

interface LookupStaticColumns {
  [SHEETS.LOOKUP_MASTER]: RawFlexGridColumnConfig[];
  [SHEETS.LOOKUP_DETAIL]: RawFlexGridColumnConfig[];
}

interface LookupState {
  searchParams: SearchParamProps;
  filters: LookupFilters;
  staticColumns: LookupStaticColumns;
  isOpenSearchArea: boolean;
  activeGrid: ActiveGrid;
  selectedLookupType: string;
  dynamicColumnLabels: Record<string, string>;
  hiddenSubColumns: Record<string, true>;
  mainGridReadOnly: boolean;
  subGridReadOnly: boolean;
}

interface LookupAction {
  reset: () => void;
  setSearchParams: (next: Partial<SearchParamProps>) => void;
  setFilters: () => void;
  setSubFilters: (lookupType: string) => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
  setActiveGrid: (grid: ActiveGrid) => void;
  setSelectedLookupType: (lookupType: string) => void;
  applyDynamicSubColumns: (sample: Partial<Record<string, string>>) => void;
  toggleMainGridReadOnly: () => void;
  toggleSubGridReadOnly: () => void;
}

const initSearchParams: SearchParamProps = {
  lookupType: '',
  lookupGroup: '',
  validYn: 'Y',
};

const initLookupState: LookupState = {
  searchParams: initSearchParams,
  filters: {},
  staticColumns: {
    [SHEETS.LOOKUP_MASTER]: [],
    [SHEETS.LOOKUP_DETAIL]: [],
  },
  isOpenSearchArea: true,
  activeGrid: 'main',
  selectedLookupType: '',
  dynamicColumnLabels: {},
  hiddenSubColumns: {},
  mainGridReadOnly: true,
  subGridReadOnly: true,
};

const DYNAMIC_SUB_COLUMNS = [
  'SEGMENT1',
  'SEGMENT2',
  'SEGMENT3',
  'SEGMENT4',
  'SEGMENT5',
  'ATTRIBUTE1',
  'ATTRIBUTE2',
  'ATTRIBUTE3',
  'ATTRIBUTE4',
  'ATTRIBUTE5',
  'ATTRIBUTE6',
  'ATTRIBUTE7',
  'ATTRIBUTE8',
  'ATTRIBUTE9',
  'ATTRIBUTE10',
  'ATTRIBUTE11',
  'ATTRIBUTE12',
  'ATTRIBUTE13',
  'ATTRIBUTE14',
  'ATTRIBUTE15',
] as const;

export const useLookupStore = createPersistedStoreWithTab<LookupState & LookupAction>(
  (set, get) => ({
    ...initLookupState,
    reset: () => set(initLookupState),
    setSearchParams: next => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...next };
      });
    },
    setFilters: () => {
      set(state => {
        state.filters[SHEETS.LOOKUP_MASTER] = { ...state.searchParams };
        state.filters[SHEETS.LOOKUP_DETAIL] = undefined;
        state.selectedLookupType = '';
        state.dynamicColumnLabels = {};
        state.hiddenSubColumns = {};
        state.mainGridReadOnly = true;
      });
    },
    setSubFilters: lookupType => {
      set(state => {
        state.filters[SHEETS.LOOKUP_DETAIL] = { lookupType };
        state.selectedLookupType = lookupType;
        state.subGridReadOnly = true;
      });
    },
    fetchStaticColumns: async () => {
      const [masterRes, detailRes] = await Promise.all([
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.LOOKUP_MASTER,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.LOOKUP_DETAIL,
        }),
      ]);
      set(state => {
        state.staticColumns[SHEETS.LOOKUP_MASTER] = masterRes.data.result;
        state.staticColumns[SHEETS.LOOKUP_DETAIL] = detailRes.data.result;
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    setActiveGrid: grid => {
      set(state => {
        state.activeGrid = grid;
      });
    },
    setSelectedLookupType: lookupType => {
      set(state => {
        state.selectedLookupType = lookupType;
      });
    },
    applyDynamicSubColumns: sample => {
      const labels: Record<string, string> = {};
      const hidden: Record<string, true> = {};
      DYNAMIC_SUB_COLUMNS.forEach(field => {
        const raw = (sample[field] ?? '').toString();
        const trimmed = raw.trim();
        if (trimmed === '' || trimmed === '-' || trimmed === '*') {
          hidden[field] = true;
          return;
        }
        labels[field] = field.startsWith('S') ? `${trimmed}*` : trimmed;
      });
      set(state => {
        state.dynamicColumnLabels = labels;
        state.hiddenSubColumns = hidden;
      });
    },
    toggleMainGridReadOnly: () => {
      set(state => {
        state.mainGridReadOnly = !state.mainGridReadOnly;
      });
    },
    toggleSubGridReadOnly: () => {
      set(state => {
        state.subGridReadOnly = !state.subGridReadOnly;
      });
    },
  }),
  'lookup'
);
