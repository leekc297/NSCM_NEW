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
    // 'ALL' 로 reset 한다 — cascade-combo-filter.md §1.2/§1.4 의무.
    // AS-IS SetChangeControl()(SCP0007_BOD.cs L238-253)은 서버 재조회 없이 하위 체크리스트만
    // 재필터하고, 조회결과는 재조회(Search) 전까지 화면에 그대로 남는다 — 그리드를 함께 비우면
    // 멀티선택 checklist 에서 항목을 추가/해제할 때마다(각 토글이 onChange 를 즉시 발생시킴)
    // 조회하지 않았는데도 그리드가 사라지는 문제가 생겨(2026-09-23 리뷰 이슈), AS-IS 와 동일하게
    // 그리드는 유지하고 재조회는 Search 버튼으로만 하도록 둔다.
    setSearchParams: searchParams => {
      set(state => {
        const next = { ...get().searchParams, ...searchParams };
        if (searchParams.divisionId !== undefined && searchParams.divisionId !== get().searchParams.divisionId) {
          next.fromSite = 'ALL';
          next.toSite = 'ALL';
          next.incoterms = 'ALL';
          next.incotermsSsp = 'ALL';
          next.transMode = 'ALL';
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
