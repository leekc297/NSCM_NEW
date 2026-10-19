import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { MENU_ID, SHEETS } from './contribute-main.constants';
import type { SearchParamProps } from './types';

type FiltersBySheet = {
  [key in SHEETS]?: ProcRequest<MENU_ID, key>;
};

type StaticColumnsBySheet = {
  [key in SHEETS]?: RawFlexGridColumnConfig[];
};

interface ContributeMainState {
  initialized: boolean;
  filters: FiltersBySheet;
  searchParams: SearchParamProps;
  staticColumns: StaticColumnsBySheet;
  openSearchArea: boolean;
  // Year SP 는 조회조건을 받지 않는다. store 필드로 참조를 고정해 다른 조회조건 변경 시
  // Year 콤보가 불필요하게 재조회되는 걸 막는다.
  noFilters: Record<string, never>;
}

interface ContributeMainAction {
  reset: () => void;
  setSearchParams: (params: Partial<SearchParamProps>) => void;
  setFilters: () => void;
  /**
   * 조회 filters 무효화 — useTabProcQuery 의 enabled=false + queryKey 변경으로 그리드가 비워진다.
   * 조회 결과가 현재 조회조건과 어긋나는 순간(Year 변경 등)에 호출한다. 재조회는 Search 로만.
   */
  clearFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
}

const currentYear = new Date().getFullYear();

const initSearchParams: SearchParamProps = {
  yyyy: String(currentYear),
  verSeq: '',
  his: 'N',
  dis: 'ALL',
  chkYear: false,
};

const initState: ContributeMainState = {
  initialized: false,
  filters: {},
  searchParams: initSearchParams,
  staticColumns: {
    [SHEETS.MAIN]: [],
    [SHEETS.MAIN_TITLE]: [],
    [SHEETS.VERSION]: [],
  },
  openSearchArea: true,
  noFilters: {},
};

export const useContributeMainStore = createPersistedStoreWithTab<
  ContributeMainState & ContributeMainAction
>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchParams: params => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...params };
      });
    },
    setFilters: () => {
      set(state => {
        const cond = state.searchParams;
        state.filters = {
          [SHEETS.MAIN]: {
            yyyy: cond.yyyy,
            verSeq: cond.verSeq,
            dis: cond.dis,
            his: cond.his,
            userGroup: '',
          },
          // 칸 제목 SP 는 P_CREATED_BY 로 사용자 칸 설정(SCM_MST_TITLESET_USER)을 찾는다.
          //   BE 가 자동 주입하는 키는 sesUserId/userId 뿐이라 createdBy 는 화면이 실어야
          //   개인화 분기가 산다(없으면 항상 기본 칸).
          [SHEETS.MAIN_TITLE]: {
            divisionId: '40',
            yyyy: cond.yyyy,
            createdBy: useSessionStore.getState().session.userId ?? '',
          },
        };
      });
    },
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    fetchStaticColumns: async () => {
      const [main, mainTitle, version] = await Promise.all([
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.MAIN,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.MAIN_TITLE,
        }),
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: SHEETS.VERSION,
        }),
      ]);
      set(state => {
        state.staticColumns = {
          [SHEETS.MAIN]: main.data.result,
          [SHEETS.MAIN_TITLE]: mainTitle.data.result,
          [SHEETS.VERSION]: version.data.result,
        };
      });

      // F6 personalizeCondition / F10 reset 으로 저장된 조회조건 복원 (DMF0007 패턴).
      if (get().initialized) return;
      const param = await apiClient.get<{ paramNm: keyof SearchParamProps; paramCtn: string }[]>(
        `/admin/menu/${MENU_ID}/search-conditions`
      );
      if (param.data.result?.length > 0) {
        const restored = param.data.result.reduce<SearchParamProps>(
          (acc, curr) => {
            // chkYear 는 boolean 이므로 'true'/'false' 문자열 → boolean 변환
            if (curr.paramNm === 'chkYear') {
              acc.chkYear = curr.paramCtn === 'true';
            } else {
              (acc as unknown as Record<string, string>)[curr.paramNm] = curr.paramCtn;
            }
            return acc;
          },
          { ...initSearchParams }
        );
        set(state => {
          state.searchParams = restored;
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
  }),
  'contribute-main'
);
