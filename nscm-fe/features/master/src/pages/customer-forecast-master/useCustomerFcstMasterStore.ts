import { apiClient } from '@foundation/apis';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { SHEET_NAME, MENU_ID } from './customer-fcst-master.constants';
import { getFcstRangeByBucket } from './utils/CustomerFcstMasterDateColumns';

interface SearchParamProps {
  planWeek: string;
  divisionId: string;
  endCustomer: string;
  scmSiteId: string;
  bucketType: string;
  validYn: string;
  userId: string;
}

interface CustomerFcstMasterState {
  initialized: boolean;
  filters?: ProcRequest<MENU_ID, SHEET_NAME>;
  searchParams: SearchParamProps;
  staticColumns: RawFlexGridColumnConfig[];
  dateColumns: FlexGridColumnConfig[];
  openSearchArea: boolean;
}

interface CustomerFcstMasterAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilter: () => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
  fetchDateColumns: () => void;
}

const initSearchParams: SearchParamProps = {
  planWeek: '',
  // 빈 값 진입 — 화면 자동선택(FilterMyDivision 첫 행/세션 division)이 채운다. 하드코딩('81')이면
  //   가드(if (searchParams.divisionId) return)에 걸려 자동선택이 발화하지 않고, '81' 권한이 없는
  //   사용자에게도 '81' 이 세팅된다. 서버 저장 검색조건(/search-conditions)이 있으면 그 값이
  //   우선 복원되고(fetchStaticColumns), 없을 때만 자동선택이 목록 첫 행/세션 division 을 채운다.
  divisionId: '',
  endCustomer: 'ALL',
  scmSiteId: 'ALL',
  bucketType: 'WEEKLY',
  validYn: 'ALL',
  userId: '',
};

const initCustomerFcstMasterState: CustomerFcstMasterState = {
  initialized: false,
  filters: undefined,
  searchParams: initSearchParams,
  staticColumns: [],
  dateColumns: [],
  openSearchArea: true,
} as const;

export const useCustomerFcstMasterStore = createPersistedStoreWithTab<
  CustomerFcstMasterState & CustomerFcstMasterAction
>(
  (set, get) => ({
    ...initCustomerFcstMasterState,
    reset: () => set(initCustomerFcstMasterState),
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
        if (searchParams.divisionId) {
          state.fetchStaticColumns();
          state.filters = initCustomerFcstMasterState.filters;
        }
      });
    },
    setFilter: () => {
      set(state => {
        state.filters = { ...state.searchParams };
      });
    },
    fetchStaticColumns: async () => {
      const staticColumns = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        {
          sheetNm: SHEET_NAME,
        }
      );
      set(state => {
        state.staticColumns = staticColumns.data.result;
      });
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
    fetchDateColumns: () => {
      set({
        dateColumns: getFcstRangeByBucket(get().filters?.bucketType ?? 'WEEKLY'),
      });
    },
  }),
  'customer-fcst-master'
);
