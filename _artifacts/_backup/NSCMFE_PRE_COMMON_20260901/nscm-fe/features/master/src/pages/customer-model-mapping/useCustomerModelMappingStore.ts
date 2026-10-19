import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { MENU_ID, SHEETS } from './customer-model-mapping.constants';
import type { SearchComboTrigger } from './customer-model-mapping.constants';
import type { SearchParamProps } from './customer-model-mapping.types';

interface CustomerModelMappingState {
  initialized: boolean;
  isOpenSearchArea: boolean;
  searchParams: SearchParamProps;
  filters?: ProcRequest<MENU_ID, SHEETS>;
  staticColumn: RawFlexGridColumnConfig[];

  /**
   * 마지막으로 바뀐 조회조건. End Customer / Sales Site 콤보 원천을 정한다 - 규칙은
   * customer-model-mapping.constants 의 SearchComboTrigger 주석 참조.
   *
   * searchParams 바깥에 두는 이유: setFilters 가 { ...searchParams } 를 그대로 proc 요청에 실어
   * 보낸다. 안에 두면 서버가 모르는 필드가 조회 파라미터로 새어 나간다.
   */
  comboTrigger: SearchComboTrigger;
}

interface CustomerModelMappingAction {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (
    searchParams: Partial<SearchParamProps>,
    comboTrigger?: SearchComboTrigger
  ) => void;
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const initCustomerModelMappingState: CustomerModelMappingState = {
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
  staticColumn: [],
  comboTrigger: 'division',
};

export const useCustomerModelMappingStore = createPersistedStoreWithTab<
  CustomerModelMappingState & CustomerModelMappingAction
>(
  (set, get) => ({
    ...initCustomerModelMappingState,
    reset: () => set(initCustomerModelMappingState),
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    // comboTrigger 는 콤보 원천을 바꾸는 조회조건(Division / Team / End Customer)의 핸들러만
    //   넘긴다. 값과 트리거를 한 번의 set() 으로 커밋해야 둘이 어긋난 중간 상태로 콤보
    //   파라미터가 조립되지 않는다.
    // 인자 타입을 명시한다. BaseTabState 가 1인자 setSearchParams 를 선언해 두어, 추론에 맡기면
    //   교차 타입 중 그쪽 시그니처가 잡혀 "인자가 모자란다"로 컴파일이 깨진다(DMF0004 동일 처방).
    setSearchParams: (
      searchParams: Partial<SearchParamProps>,
      comboTrigger?: SearchComboTrigger
    ) => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
        if (comboTrigger) state.comboTrigger = comboTrigger;
        if (searchParams.divisionId) {
          void state.fetchStaticColumns();
          state.filters = initCustomerModelMappingState.filters;
        }
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
        {
          sheetNm: SHEETS.CUSTOMER_MODEL_MAPPING,
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
