import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { SHEETS, MENU_ID, RESPONSE_SET } from './sales-site.constants';

interface SearchParamProps {
  divisionId: string;
  endCustomer: string;
  salesSite: string;
  activeFlag: string;
  soldToCustomer: string;
}

type filtersBySheet = {
  [key in SHEETS]?: ProcRequest<MENU_ID, key>;
};
interface SalesSiteState {
  initialized: boolean;
  loading: boolean;
  filters: filtersBySheet;
  searchParams: SearchParamProps;
  staticColumns: {
    [key in RESPONSE_SET]: RawFlexGridColumnConfig[];
  };

  openSearchArea: boolean;
  error: string | null;
}

interface SalesSiteAction {
  reset: () => void;
  setSiteFilters: () => void;
  setDetailFilters: (filter?: ProcRequest<MENU_ID, SHEETS.CUSTOMER>) => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  fetchStaticColumns: (divisionId?: string) => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
}

const initSearchParams: SearchParamProps = {
  divisionId: useSessionStore.getState().session.div ?? '40',
  endCustomer: 'ALL',
  salesSite: 'ALL',
  activeFlag: 'ALL',
  soldToCustomer: 'ALL',
};

const initSalesSiteStoreState: SalesSiteState = {
  initialized: false,
  loading: false,
  filters: {
    [SHEETS.SITE]: undefined,
    [SHEETS.CUSTOMER]: undefined,
  },
  searchParams: initSearchParams,
  staticColumns: {
    [RESPONSE_SET.SITE]: [],
    [RESPONSE_SET.CUSTOMER]: [],
    [RESPONSE_SET.LOCATION]: [],
    [RESPONSE_SET.BUCKET]: [],
  },

  openSearchArea: true,
  error: null,
} as const;

export const useSalesSiteStore = createPersistedStoreWithTab<SalesSiteState & SalesSiteAction>(
  (set, get) => ({
    ...initSalesSiteStoreState,
    reset: () => set(initSalesSiteStoreState),
    setSiteFilters: () => {
      set(state => {
        state.filters[SHEETS.SITE] = { ...state.searchParams };
        state.filters[SHEETS.CUSTOMER] = undefined;
      });
    },
    setDetailFilters: (filter?: ProcRequest<MENU_ID, SHEETS.CUSTOMER>) => {
      set(state => {
        state.filters[SHEETS.CUSTOMER] = filter ? { ...filter } : undefined;
      });
    },
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
        if (searchParams.divisionId) {
          state.filters = initSalesSiteStoreState.filters;
        }
      });
      // 주의: 컬럼 재조회는 set() 커밋 뒤에, division 을 인자로 넘겨서 호출한다.
      //   producer 안에서 부르면 fetchStaticColumns 의 get() 이 아직 이전 division 을
      //   돌려줘서(immer 커밋 전) 컬럼 메타가 한 스텝 밀린다 — division 을 82 로 바꿔도
      //   40 기준 컬럼셋으로 조회되던 원인.
      if (searchParams.divisionId) void get().fetchStaticColumns(searchParams.divisionId);
    },
    // division 인자는 setSearchParams 가 넘긴다(스토어 커밋 전 stale get() 방지).
    //   미지정이면 현재 조회조건 기준.
    fetchStaticColumns: async divisionId => {
      const division = divisionId ?? get().searchParams.divisionId;
      const fetchColumns = (sheetNm: RESPONSE_SET, divisionFilter?: string) =>
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm,
          divisionId: divisionFilter,
        });

      // Site 시트는 division 별 컬럼 구성이 다르다(admin 메타 Division: End Customer 는 40 제외).
      //   division 을 안 넘기면 SP 가 division 필터를 걸지 않아 40 에서도 End Customer 가 남는다.
      //   종전 코드는 40 일 때만 '40' 을 넘기고 나머지는 undefined 라, 82/81 계열 전용 컬럼이
      //   division 과 무관하게 결정됐다.
      const [siteByDivision, customer, location, bucket] = await Promise.all([
        fetchColumns(RESPONSE_SET.SITE, division),
        fetchColumns(RESPONSE_SET.CUSTOMER),
        fetchColumns(RESPONSE_SET.LOCATION),
        fetchColumns(RESPONSE_SET.BUCKET),
      ]);
      // admin 메타에 해당 division 토큰이 하나도 없으면 컬럼이 0건으로 와 그리드가 통째로 비어버린다.
      //   그때만 division 없이 재조회해 종전 동작(전체 컬럼)으로 되돌린다.
      const site = siteByDivision.data.result?.length
        ? siteByDivision
        : await fetchColumns(RESPONSE_SET.SITE);
      set(state => {
        state.staticColumns = {
          [RESPONSE_SET.SITE]: site.data.result,
          [RESPONSE_SET.CUSTOMER]: customer.data.result,
          [RESPONSE_SET.LOCATION]: location.data.result,
          [RESPONSE_SET.BUCKET]: bucket.data.result,
        };
      });
      if (get().initialized) return;
      const param = await apiClient.get<{ paramNm: keyof SearchParamProps; paramCtn: string }[]>(
        `/admin/menu/${MENU_ID}/search-conditions`
      );
      let savedDivision: string | undefined;
      if (param.data.result?.length > 0) {
        const searchParams = param.data.result.reduce((acc, curr) => {
          acc[curr.paramNm] = curr.paramCtn;
          return acc;
        }, {} as SearchParamProps);

        savedDivision = searchParams.divisionId;
        set(state => {
          state.searchParams = searchParams;
        });
      }
      set(state => {
        state.initialized = true;
      });
      // 저장된 조회조건의 division 이 방금 컬럼을 조회한 division(세션 기본값)과 다르면 다시 맞춘다.
      //   initialized 를 먼저 세우므로 재귀는 1회로 끝난다.
      if (savedDivision && savedDivision !== division)
        await get().fetchStaticColumns(savedDivision);
    },
    setOpenSearchArea: open => {
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      });
    },
  }),
  'sales-site'
);
