import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import {
  MENU_ID,
  NULL_FILTER_DIVISION,
  RESPONSE_SET,
  SHEETS,
} from './sales-site-project-model-01.constants';

interface SearchParamProps {
  divisionId: string;
  deptId: string;
  endCustomer: string;
  salesSite: string;
  projectCode: string;
  itemId: string;
  activeFlag: string;
  owner: string;
  // 40 전용 체크박스 — 'Y' / 'N'. 설명은 constants NULL_FILTER_LABEL 주석 참조.
  endCustReportYn: string;
  projectInfoYn: string;
}

type filtersBySheet = {
  [SHEETS.PRODUCTION]?: ProcRequest<MENU_ID, SHEETS.PRODUCTION>;
  [SHEETS.PURCHASE]?: ProcRequest<MENU_ID, SHEETS.PURCHASE>;
};

interface SalesSiteProjectModel01State {
  initialized: boolean;
  filters: filtersBySheet;
  searchParams: SearchParamProps;
  staticColumns: {
    [key in SHEETS]: RawFlexGridColumnConfig[];
  };
  openSearchArea: boolean;
  openPurchaseGrid: boolean;
}

interface SalesSiteProjectModel01Action {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setOpenPurchaseGrid: (open?: boolean) => void;
  setProductionFilter: () => void;
  setPurchaseFilter: (filter?: ProcRequest<MENU_ID, SHEETS.PURCHASE>) => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  fetchStaticColumns: () => Promise<void>;
}

// 주의: 상수가 아니라 함수다. 모듈 최상위 상수로 굳히면 session.div 를 이 화면 청크가 처음
//   로드되던 그 순간 한 번만 읽는다. 로그아웃은 스토어와 sessionStorage 만 비우고 새로고침을
//   하지 않으므로(useClearAppData.clearAllData) 모듈은 계속 살아 있고, 다른 계정으로 재로그인해도
//   앞 계정의 division 이 그대로 남는다. 스토어는 탭별로 생성되므로 생성 시점에 세션을 읽어야
//   항상 현재 계정 기준이 된다 (sales-site useSalesSiteStore.makeInitSearchParams 와 동일 규약).
//   fallback '40' 은 세션 미확립(로그인 전 진입) 대비 기본값이다. 권한 목록에 없는 값이면
//   폼의 보정 effect 가 콤보 목록 기준으로 다시 고른다.
const makeInitSearchParams = (): SearchParamProps => ({
  divisionId: useSessionStore.getState().session.div ?? '40',
  deptId: 'ALL',
  endCustomer: 'ALL',
  salesSite: 'ALL',
  projectCode: '',
  itemId: '',
  activeFlag: 'ALL',
  owner: '',
  endCustReportYn: 'N',
  projectInfoYn: 'N',
});

// filters 도 호출 시점에 새 객체로 만든다. 같은 객체를 reset 과 division 변경에 재사용하면
//   탭마다 따로 만들어진 스토어가 중첩 객체를 공유하게 된다.
const makeInitFilters = (): filtersBySheet => ({
  [SHEETS.PRODUCTION]: undefined,
  [SHEETS.PURCHASE]: undefined,
});

const makeInitState = (): SalesSiteProjectModel01State => ({
  initialized: false,
  openSearchArea: true,
  openPurchaseGrid: true,
  filters: makeInitFilters(),
  searchParams: makeInitSearchParams(),
  staticColumns: {
    [SHEETS.PRODUCTION]: [],
    [SHEETS.PURCHASE]: [],
  },
});

export const useSalesSiteProjectModel01Store = createPersistedStoreWithTab<
  SalesSiteProjectModel01State & SalesSiteProjectModel01Action
>(
  (set, get) => ({
    ...makeInitState(),
    reset: () => set(makeInitState()),
    setOpenSearchArea: open => {
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      });
    },
    setOpenPurchaseGrid: open => {
      set(state => {
        state.openPurchaseGrid = open ?? !state.openPurchaseGrid;
      });
    },
    setProductionFilter: () => {
      set(state => {
        // 체크박스 두 값은 40 에서만 'Y' 가 나간다 — AS-IS 도 40 이 아니면 'N' 고정이었다.
        //   저장해 둔 조회조건을 복원한 경우 이 두 키가 없을 수 있어 여기서 'Y' / 'N' 으로 확정한다.
        const sp = state.searchParams;
        const isNullFilterDivision = sp.divisionId === NULL_FILTER_DIVISION;
        state.filters[SHEETS.PRODUCTION] = {
          ...sp,
          endCustReportYn: isNullFilterDivision && sp.endCustReportYn === 'Y' ? 'Y' : 'N',
          projectInfoYn: isNullFilterDivision && sp.projectInfoYn === 'Y' ? 'Y' : 'N',
        };
        state.filters[SHEETS.PURCHASE] = undefined;
      });
    },
    setPurchaseFilter: (filter?: ProcRequest<MENU_ID, SHEETS.PURCHASE>) => {
      set(state => {
        state.filters[SHEETS.PURCHASE] = filter ? { ...filter } : undefined;
      });
    },
    setSearchParams: searchParams => {
      set(state => {
        // Division 을 바꾸면 40 전용 체크박스도 함께 푼다(다른 하위 조건과 같은 초기화).
        state.searchParams = {
          ...get().searchParams,
          ...(searchParams.divisionId ? { endCustReportYn: 'N', projectInfoYn: 'N' } : {}),
          ...searchParams,
        };
        if (searchParams.divisionId) {
          state.filters = makeInitFilters();
        }
      });
      // division 변경 시 즉시 컬럼(헤더) 재세팅. set 콜백(immer draft) 안에서 호출하면
      //   fetchStaticColumns 가 읽는 get().searchParams.divisionId 가 커밋 전 옛 값이라
      //   이전 division 기준으로 조회됐다. set 이 끝난 뒤(최신 division 커밋 후) 호출한다.
      if (searchParams.divisionId) {
        void get().fetchStaticColumns();
      }
    },
    fetchStaticColumns: async () => {
      const columnDivision = get().searchParams.divisionId ?? '81';
      const [production, purchase] = await Promise.all([
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: RESPONSE_SET.PRODUCTION,
          divisionId: columnDivision.startsWith('81_') ? '81' : columnDivision,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: RESPONSE_SET.PURCHASE,
          divisionId: columnDivision.startsWith('81_') ? '81' : columnDivision,
        }),
      ]);
      set(state => {
        state.staticColumns = {
          [SHEETS.PRODUCTION]: production.data.result,
          [SHEETS.PURCHASE]: purchase.data.result,
        };
      });
      if (get().initialized) return;
      void (async () => {
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
      })();
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'sales-site-project-model-01'
);
