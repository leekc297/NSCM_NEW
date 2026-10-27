import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, ALL, MENU_ID, SHEETS } from './plan-group-master.constants';
import type { PlanGroupSearchParams } from './plan-group-master.types';
import { toParamCsv } from './utils/plan-group-master.searchInfo';

type MainFilter = ProcRequest<MENU_ID, SHEETS.MAIN>;
type SearchInfoFilter = ProcRequest<MENU_ID, SHEETS.SEARCH_INFO>;

interface PlanGroupMasterState {
  initialized: boolean;
  searchParams: PlanGroupSearchParams;
  // 그리드 조회(Search 게이트) — setMainFilters 로만 채워진다.
  filters: { [SHEETS.MAIN]?: MainFilter };
  // 조회조건 6커서 공급(mount 1회 로드, Search 와 분리).
  searchInfoFilters: { [SHEETS.SEARCH_INFO]?: SearchInfoFilter };
  staticColumns: RawFlexGridColumnConfig[];
  openSearchArea: boolean;
}

interface PlanGroupMasterAction {
  reset: () => void;
  setSearchParams: (params: Partial<PlanGroupSearchParams>) => void;
  setMainFilters: () => void;
  clearMainFilters: () => void;
  loadSearchInfo: () => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
}

// 상수가 아니라 함수 — 세션 division 은 스토어 생성(탭별) 시점에 읽어야 재로그인 후에도 현재 계정 기준이 된다
//   (sales-site makeInitSearchParams 규약). fallback '40' 은 세션 미확립 대비. 권한 목록 밖이면 Form 보정 effect 가 교체.
const makeInitSearchParams = (): PlanGroupSearchParams => ({
  divisionId: useSessionStore.getState().session.div ?? '40',
  operation: ALL,
  plant: ALL,
  building: ALL,
  line: ALL,
  planGroup: ALL,
});

const makeInitState = (): PlanGroupMasterState => ({
  initialized: false,
  searchParams: makeInitSearchParams(),
  filters: {},
  searchInfoFilters: {},
  staticColumns: [],
  openSearchArea: true,
});

export const usePlanGroupMasterStore = createPersistedStoreWithTab<
  PlanGroupMasterState & PlanGroupMasterAction
>((set, get) => ({
  ...makeInitState(),
  reset: () => set(makeInitState()),

  setSearchParams: params => {
    set(state => {
      state.searchParams = { ...get().searchParams, ...params };
      // Division 변경 = 하위 체크리스트 초기화 + 그리드 즉시 clear (SRCH-07). 데이터 재조회는 Search 로만.
      if (params.divisionId) {
        state.searchParams = {
          ...state.searchParams,
          operation: ALL,
          plant: ALL,
          building: ALL,
          line: ALL,
          planGroup: ALL,
        };
        state.filters = {};
      }
    });
  },

  // 조회 버튼 → searchParams 를 그리드 SP payload 로 변환(참조 교체 = useTabProcQuery 발사). CSV 각 줄 AS-IS 근거는 주석.
  setMainFilters: () => {
    set(state => {
      const sp = get().searchParams;
      state.filters = {
        [SHEETS.MAIN]: {
          divisionId: sp.divisionId, // 1 단일 Division (cascade root)
          operationId: toParamCsv(sp.operation), // 2 체크리스트 CSV (ALL/미선택 → '')
          plantId: toParamCsv(sp.plant), // 3
          factoryId: toParamCsv(sp.building), // 4 Building
          lineId: toParamCsv(sp.line), // 5
          planGroupId: toParamCsv(sp.planGroup), // 6
        },
      };
    });
  },

  // 조회조건 변경 시 그리드 비움 (keep-alive 탭 stale 발사 방지, SRCH-07).
  clearMainFilters: () => set(state => void (state.filters = {})),

  // mount 1회 — 공용 GET_SEARCH_INFO. userId='' (AS-IS 고정, BE 세션 보정). 참조 1회만 세팅(재발사 없음).
  loadSearchInfo: () =>
    set(state => {
      if (state.searchInfoFilters[SHEETS.SEARCH_INFO]) return;
      state.searchInfoFilters = { [SHEETS.SEARCH_INFO]: { userId: '' } };
    }),

  // 컬럼 메타 admin fetch (SCM_MST_SHEET_COLUMNS, sheet 'Plan Group Master' 11행). division 무관(고정 11컬럼).
  fetchStaticColumns: async () => {
    const res = await apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
      sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN],
    });
    set(state => {
      state.staticColumns = res.data.result ?? [];
      state.initialized = true;
    });
  },

  setOpenSearchArea: open =>
    set(state => void (state.openSearchArea = open ?? !state.openSearchArea)),
}), 'plan-group-master');
