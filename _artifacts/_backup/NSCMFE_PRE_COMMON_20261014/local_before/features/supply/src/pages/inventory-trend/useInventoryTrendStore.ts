import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './inventory-trend.constants';
import type { SearchParams } from './inventory-trend.types';

// SP filter payload — useTabProcQuery enabled 가드. 키명 = SP IN 파라미터 대응(주석).
//   PROC_M 등록은 convert-sp 소관(PKG_SCP0101 미배포).
type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

interface State {
  initialized: boolean;
  isOpenSearchArea: boolean;
  searchParams: SearchParams;
  filters: FiltersBySheet;
  staticColumns: RawFlexGridColumnConfig[];
  // Division 권한 게이트(R1, cs:153~154) — Division_SCP 결과 0건. Form 이 콤보 조회로 판정해 기록,
  //   page 가 조회 액션(SubTitle search hotkey) 차단에 사용(usrLayoutControl2 Enabled=false 대응).
  noDivisionAuth: boolean;
}

interface Action {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (params: Partial<SearchParams>) => void;
  setFilters: () => void;
  clearFilters: () => void;
  setNoDivisionAuth: (value: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
}

const initState: State = {
  initialized: false,
  isOpenSearchArea: true,
  searchParams: {
    // 기본 최신월 — AS-IS 는 SCP0084_GET_MONTH_RANGE.MAX_YYYYMM(cs:645), 미배포(goal.md ②)라
    //   convert-sp 배포 전까지 현재월 폴백(런타임 월범위 초기화는 SP 배포 후 재판정).
    month: dayjs().format('YYYYMM'),
    divisionId: 'ALL', // Division_SCP 기본 ALL(setListBox blnAllFlag=true, CControl.cs:56~70)
    plantId: 'ALL', // PlantByGroup_SCP 기본 ALL
    itemId: '',
  },
  filters: {},
  staticColumns: [],
  noDivisionAuth: false, // 콤보 미조회 상태 기본 허용(divisions undefined 동안 조회 미차단)
};

export const useInventoryTrendStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setOpenSearchArea: open =>
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      }),
    // Division 변경 시 하위 Plant 를 ALL 로 리셋(재조회형 cascade — design 02 §3). 그리드는 유지하고
    //   재조회는 Search 로만(멀티선택 토글마다 조회 방지).
    setSearchParams: params =>
      set(state => {
        const prev = get().searchParams;
        const next = { ...prev, ...params };
        if (params.divisionId !== undefined && params.divisionId !== prev.divisionId) {
          next.plantId = 'ALL';
        }
        state.searchParams = next;
      }),
    // refetch 직접호출 금지 — filters 참조 교체로 useTabProcQuery 자동 발사(nscm-patterns §5-1).
    //   키명 = SP IN 파라미터(design 02 §5): p_yyyymm/p_division_id/p_plant_id/p_item_id/debug_mode.
    setFilters: () =>
      set(state => {
        const c = get().searchParams;
        state.filters = {
          [SHEETS.MAIN]: {
            yyyymm: c.month, // p_yyyymm
            divisionId: c.divisionId, // p_division_id (콤마 다중, ALL)
            plantId: c.plantId, // p_plant_id (콤마 다중, ALL)
            itemId: c.itemId, // p_item_id
            debugMode: 'F', // debug_mode
          } as never,
        };
      }),
    // mount 시 이전 filters cache 무효화 — incomplete payload 자동 발사 회피(nscm-patterns §5-7).
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    setNoDivisionAuth: value =>
      set(state => {
        state.noDivisionAuth = value;
      }),
    // 컬럼 메타 동적 fetch — SCM_MST_SHEET_COLUMNS(admin) 변경 즉시 반영(ui-category hook, 하드코딩 금지).
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] }
        );
        set(state => {
          state.staticColumns = res.data.result ?? [];
          state.initialized = true;
        });
      } catch {
        // BE 메타 미등록 시 화면 미파손 silent fallback(console 금지 룰)
      }
    },
  }),
  'inventory-trend'
);
