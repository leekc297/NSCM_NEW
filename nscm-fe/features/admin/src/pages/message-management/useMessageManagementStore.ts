import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './message-management.constants';

interface SearchParamProps {
  messageType: string;
  message: string;
  useYn: string;
}

interface MessageManagementState {
  initialized: boolean;
  filters?: ProcRequest<MENU_ID, SHEETS.MSG_MGMT>;
  searchParams: SearchParamProps;
  staticColumns: RawFlexGridColumnConfig[];
  isOpenSearchArea: boolean;
  addRowMessageType: string;
}

interface MessageManagementAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
}

const initMessageManagementParam: SearchParamProps = {
  messageType: 'ALL',
  message: '',
  useYn: 'Y',
};

const initMessageManagementState: MessageManagementState = {
  initialized: false,
  filters: undefined,
  searchParams: initMessageManagementParam,
  staticColumns: [],
  isOpenSearchArea: true,
  addRowMessageType: '',
} as const;

export const useMessageManagementStore = createPersistedStoreWithTab<
  MessageManagementState & MessageManagementAction
>(
  (set, get) => ({
    ...initMessageManagementState,
    reset: () => set(initMessageManagementState),
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
      });
    },
    setFilters: () => {
      set(state => {
        state.filters = { ...state.searchParams };
        if (
          state.searchParams &&
          state.searchParams.messageType !== 'ALL' &&
          state.searchParams.messageType.split(',').length === 1
        ) {
          state.addRowMessageType = state.searchParams.messageType;
        } else {
          state.addRowMessageType = '';
        }
      });
    },
    fetchStaticColumns: async () => {
      const result = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        {
          sheetNm: SHEETS.MSG_MGMT,
        }
      );
      set(state => {
        state.staticColumns = result.data.result;
      });
      if (get().initialized) return;
      const param = await apiClient.get<{ paramNm: keyof SearchParamProps; paramCtn: string }[]>(
        `/admin/menu/${MENU_ID}/search-conditions`
      );

      if (param.data.result?.length > 0) {
        const searchParams = param.data.result.reduce(
          (acc, curr) => {
            acc[curr.paramNm] = curr.paramCtn;
            return acc;
          },
          { ...initMessageManagementParam, useYn: '' } as SearchParamProps
        );

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
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
  }),
  'message-management'
);
