import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './long-term-stock.constants';
import type { SearchParams } from './long-term-stock.types';

// SP filter payload — useTabProcQuery enabled 가드. 키명 = SP IN 파라미터 대응(주석).
//   PROC_M 등록은 convert-sp 소관(PKG_SCP0084 미배포).
type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

interface State {
  initialized: boolean;
  isOpenSearchArea: boolean;
  searchParams: SearchParams;
  filters: FiltersBySheet;
  staticColumns: RawFlexGridColumnConfig[];
  // Division 권한 게이트(R8, cs:146~147) — Division_SCP 결과 0건. Form 이 콤보 조회로 판정해 기록,
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
    month: dayjs().format('YYYYMM'), // 기본 최신월(SCP0084_GET_MONTH_RANGE 미배포 폴백 — goal.md ②)
    divisionId: 'ALL', // Division_SCP 기본 ALL(콤보 상단 ALL 항목)
    plantId: 'ALL', // PlantByGroup1_SCP_ALL 기본 ALL
    longTermTypeCode: 'ALL', // Long Term Type 기본 ALL(미선택=전체)
  },
  filters: {},
  staticColumns: [],
  noDivisionAuth: false, // 콤보 미조회 상태 기본 허용(divisions undefined 동안 조회 미차단)
};

export const useLongTermStockStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setOpenSearchArea: open =>
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      }),
    // Division 변경 시 하위 Plant 를 ALL 로 리셋 — AS-IS 는 SetChangedControl 이 clbPlant 를
    //   재바인딩해 체크값을 초기화한다(cs:173~181/808~811). 클라 cascade 필터 방식(재조회 없음).
    setSearchParams: params =>
      set(state => {
        const prev = get().searchParams;
        const next = { ...prev, ...params };
        if (params.divisionId !== undefined && params.divisionId !== prev.divisionId) {
          next.plantId = 'ALL';
        }
        state.searchParams = next;
      }),
    // 조회 payload 조립(refetch 직접호출 금지 — 참조 교체). 다중체크는 콤마결합, ALL/미선택=빈문자열
    //   (전체). AS-IS GetCheckedListValue(cs:293~314) 대응. 각 줄 SP IN 파라미터 주석(design 02 §5).
    setFilters: () =>
      set(state => {
        const c = get().searchParams;
        const csv = (v: string): string => (v === 'ALL' ? '' : v);
        state.filters = {
          [SHEETS.MAIN]: {
            yyyymm: c.month, // p_yyyymm
            divisionId: csv(c.divisionId), // p_division_id (콤마 다중, 전체='')
            plantId: csv(c.plantId), // p_plant_id (콤마 다중, 전체='')
            longTermTypeCode: csv(c.longTermTypeCode), // p_long_term_type_code (콤마 다중, 전체='')
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
  'long-term-stock'
);
