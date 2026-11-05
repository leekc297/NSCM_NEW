import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { DEFAULT_INPUT_STATUS, MENU_ID, SHEETS } from './bod.constants';
import type { SearchParamProps } from './bod.types';
import { resolveDivisionQueryValue } from './bod.util';

interface BodState {
  initialized: boolean;
  isOpenSearchArea: boolean;
  searchParams: SearchParamProps;
  // 권한 Division 코드(BodForm 이 Division 콤보 로드 후 세팅) — setFilters 가 'ALL' 을 이 코드
  //   열거로 펼쳐 조회한다(권한 밖 Division 누수 차단, 아래 setFilters 주석 참조).
  allowedDivisionIds: string[];
  // BOD 메인 그리드 조회조건 전용 — SHEETS 전체 유니온으로 두면 countryCity/routeCnt request
  // 필드까지 합쳐져 divisionId 등 필수 접근이 깨진다(union 전체를 만족해야 하는 필드만 남음).
  filters?: ProcRequest<MENU_ID, SHEETS.BOD>;
  staticColumn: RawFlexGridColumnConfig[];
}

interface BodAction {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setAllowedDivisionIds: (ids: string[]) => void;
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
  allowedDivisionIds: [],
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
    setAllowedDivisionIds: ids => {
      set(state => {
        state.allowedDivisionIds = ids;
      });
    },
    // 조회조건을 filters 로 확정한다. Division 'ALL'(미조작 기본값)은 권한 Division 코드 열거로
    //   펼쳐 보낸다 — 'ALL' 센티널을 그대로 보내면 조회 SP 가 무필터(DB 전체 Division)로 풀어 권한
    //   밖까지 조회된다(bod.util.ts resolveDivisionQueryValue). 표시용 searchParams.divisionId 는
    //   'ALL' 로 그대로 둔다. 검색 경로가 둘(BodForm Search 버튼·툴바 SEARCH 핫키)이라 양쪽이 모두
    //   거치는 이 지점에서 중앙 처리한다.
    setFilters: () => {
      set(state => {
        state.filters = {
          ...state.searchParams,
          divisionId: resolveDivisionQueryValue(state.searchParams.divisionId, state.allowedDivisionIds),
        };
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
        // 기본값 위에 저장값을 덮는다 — 저장 시 빈 값('')은 제외되므로(gridAction.personalizeCondition)
        //   통째로 교체하면 Active ALL(validYn '')처럼 저장되지 않은 조건이 undefined 가 되어 빈칸으로 보인다.
        set(state => {
          state.searchParams = { ...initBodState.searchParams, ...searchParams };
        });
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'bod'
);
