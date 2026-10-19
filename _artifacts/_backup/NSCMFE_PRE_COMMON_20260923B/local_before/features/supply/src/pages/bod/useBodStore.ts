import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { DEFAULT_INPUT_STATUS, MENU_ID, SHEETS } from './bod.constants';
import type { SearchParamProps } from './bod.types';

interface BodState {
  initialized: boolean;
  isOpenSearchArea: boolean;
  searchParams: SearchParamProps;
  // BOD 메인 그리드 조회조건 전용 — SHEETS 전체 유니온으로 두면 countryCity/routeCnt request
  // 필드까지 합쳐져 divisionId 등 필수 접근이 깨진다(union 전체를 만족해야 하는 필드만 남음).
  filters?: ProcRequest<MENU_ID, SHEETS.BOD>;
  staticColumn: RawFlexGridColumnConfig[];
}

interface BodAction {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const initBodState: BodState = {
  initialized: false,
  isOpenSearchArea: true,
  searchParams: {
    divisionId: 'ALL',
    fromSite: 'ALL',
    toSite: 'ALL',
    incoterms: 'ALL',
    incotermsSsp: 'ALL',
    transMode: 'ALL',
    inputStatus: DEFAULT_INPUT_STATUS,
    // AS-IS cboValidYN 는 InitControls()에서 SelectedValue 를 세팅하지 않아 최초 진입 시
    // "전체"(미선택) 상태로 조회된다(SCP0007_BOD.cs L217-229) — 'Y' 고정 기본값은 불일치였다.
    validYn: '',
  },
  staticColumn: [],
};

export const useBodStore = createPersistedStoreWithTab<BodState & BodAction>(
  (set, get) => ({
    ...initBodState,
    reset: () => set(initBodState),
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    // Division 변경 시 하위 checklist(From/To Site/Incoterms/Incoterms(SSP)/Trans Mode) 를
    // 'ALL' 로 reset 하고 그리드를 비운다 — cascade-combo-filter.md §1.2/§1.4 의무.
    // AS-IS 는 SetChangeControl()(SCP0007_BOD.cs L238-253)으로 서버 재조회 없이 하위 체크리스트만
    // 재필터하지만, 조회결과 자체는 division 변경 후 재조회 전까지 화면에 남는 구조가 아니라
    // 이 hook 표준을 그대로 따른다(재조회는 Search 버튼으로만).
    setSearchParams: searchParams => {
      set(state => {
        const next = { ...get().searchParams, ...searchParams };
        if (searchParams.divisionId !== undefined && searchParams.divisionId !== get().searchParams.divisionId) {
          next.fromSite = 'ALL';
          next.toSite = 'ALL';
          next.incoterms = 'ALL';
          next.incotermsSsp = 'ALL';
          next.transMode = 'ALL';
          state.filters = undefined; // 그리드 비움 — 재조회는 Search 버튼으로만
        }
        state.searchParams = next;
      });
    },
    setFilters: () => {
      set(state => {
        state.filters = { ...state.searchParams };
      });
    },
    // 컬럼 메타는 admin(SCM_MST_SHEET_COLUMNS)에서 동적 fetch — 하드코딩 금지(ui-category hook).
    fetchStaticColumns: async () => {
      const result = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        {
          sheetNm: SHEETS.BOD,
        }
      );
      set(state => {
        state.staticColumn = result.data.result;
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
  }),
  'bod'
);
