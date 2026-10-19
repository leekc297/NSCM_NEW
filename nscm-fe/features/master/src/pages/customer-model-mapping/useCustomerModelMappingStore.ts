import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { MENU_ID, SHEETS } from './customer-model-mapping.constants';
import type { SearchParamProps } from './customer-model-mapping.types';

interface CustomerModelMappingState {
  initialized: boolean;
  isOpenSearchArea: boolean;
  searchParams: SearchParamProps;
  filters?: ProcRequest<MENU_ID, SHEETS>;
  staticColumn: RawFlexGridColumnConfig[];
}

interface CustomerModelMappingAction {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilters: () => void;
  /** 컬럼 메타 조회 — divisionId 를 넘기면 그 사업부 기준(메타 DIVISION_ID 목록 필터·시트 변형)으로 받는다. */
  fetchStaticColumns: (divisionId?: string) => Promise<void>;
}

// 주의: 상수가 아니라 함수다. 모듈 최상위 상수로 굳히면 session.div 를 이 화면 청크가 처음
//   로드되던 그 순간 한 번만 읽는다. 로그아웃은 스토어와 sessionStorage 만 비우고 새로고침을
//   하지 않으므로(useClearAppData.clearAllData) 모듈은 계속 살아 있고, 다른 계정으로 재로그인해도
//   앞 계정의 division 이 그대로 남는다. 스토어는 탭별로 생성되므로 생성 시점에 세션을 읽어야
//   항상 현재 계정 기준이 된다 (sales-site useSalesSiteStore.makeInitSearchParams 와 동일 규약).
//   fallback '40' 은 세션 미확립(로그인 전 진입) 대비 기본값이다. 권한 목록에 없는 값이면
//   폼의 보정 effect 가 콤보 목록 기준으로 다시 고른다.
const makeInitState = (): CustomerModelMappingState => ({
  initialized: false,
  isOpenSearchArea: true,
  searchParams: {
    divisionId: useSessionStore.getState().session.div ?? '40',
    deptId: 'ALL',
    endCustomer: 'ALL',
    salesSite: 'ALL',
    customerPJT: '',
    customerModel: '',
    projectCode: '',
    itemId: '',
    activeFlag: 'Y',
  },
  filters: undefined,
  staticColumn: [],
});

export const useCustomerModelMappingStore = createPersistedStoreWithTab<
  CustomerModelMappingState & CustomerModelMappingAction
>(
  (set, get) => ({
    ...makeInitState(),
    reset: () => set(makeInitState()),
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    setSearchParams: (searchParams: Partial<SearchParamProps>) => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
        if (searchParams.divisionId) {
          state.filters = undefined;
        }
      });
      // division 이 바뀌면 컬럼 메타를 그 사업부 기준으로 다시 받는다. set 콜백 안에서 부르면
      //   커밋 전 옛 division 으로 조회되므로(sales-site-project-model 스토어와 같은 이유) set 뒤에,
      //   바뀐 값을 직접 넘겨 부른다.
      if (searchParams.divisionId) {
        void get().fetchStaticColumns(searchParams.divisionId);
      }
    },
    setFilters: () => {
      set(state => {
        state.filters = { ...state.searchParams };
      });
    },
    fetchStaticColumns: async (divisionId?: string) => {
      // 사업부를 함께 보낸다 — 메타 조회 SP(PR_GET_SHEET_COLUMN_LIST)가 컬럼 행의 DIVISION_ID 목록에
      //   없는 컬럼을 빼고, `시트명_사업부` 변형 시트가 있으면 그것을 쓴다. 종전엔 시트명만 보내
      //   전 사업부가 같은 메타를 받아 UI Category Setup 의 사업부 설정이 이 화면에선 무효였다
      //   (2026-10-07 사용자 결정: PJT Code 필수를 코드가 아니라 메타 입력 구분 M + 사업부 목록으로 건다).
      //   사업부 값은 그대로 보낸다(토큰 정확 일치, isDivisionAllowed 와 같은 규약) — 81 하위 코드까지
      //   허용하려면 메타 DIVISION_ID 목록에 그 코드를 적는다.
      const columnDivision = divisionId ?? get().searchParams.divisionId;
      const result = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        {
          sheetNm: SHEETS.CUSTOMER_MODEL_MAPPING,
          ...(columnDivision ? { divisionId: columnDivision } : {}),
        }
      );
      set(state => {
        state.staticColumn = result.data.result;
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
  'customer-model-mapping'
);
