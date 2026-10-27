import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SEARCH_MODE, SHEETS } from './ending-inventory.constants';
import type { SearchParams } from './ending-inventory.types';

// 모드별 SP filter payload — useTabProcQuery enabled 가드(mode 별로 하나만 채워진다).
//   키명 = SP IN 파라미터 대응(주석). PROC_M 등록은 convert-sp 소관(PKG_SCP0085 미배포).
type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.DAILY]?: ProcRequest<MENU_ID, SHEETS.DAILY>;
};

interface State {
  initialized: boolean;
  // F6 개인화 조회조건 복원 1회 가드(탭 수명 내 1회 — 새로고침 시 새 store 라 재복원).
  conditionsRestored: boolean;
  isOpenSearchArea: boolean;
  searchParams: SearchParams;
  filters: FiltersBySheet;
  staticColumns: RawFlexGridColumnConfig[];
  // 상세 3컬럼(UNRESTRICTED_QTY/BLOCKED_STOCK/IN_TRANSIT) 토글 — QUANTITY 헤더 더블클릭(cs:456~468).
  isHeaderViewDetail: boolean;
  // Division 권한 게이트(R1, cs:188) — MyDivision 결과 0건. Form 이 콤보 조회로 판정해 기록,
  //   page 가 조회 액션(SubTitle search hotkey) 차단에 사용(usrLayoutControl2 Enabled=false 대응).
  noDivisionAuth: boolean;
}

interface Action {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (params: Partial<SearchParams>) => void;
  // F6 저장 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchParams 패치(탭당 1회).
  restoreSearchParams: () => Promise<void>;
  setFilters: () => void;
  clearFilters: () => void;
  toggleHeaderViewDetail: () => void;
  setNoDivisionAuth: (value: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
}

const initState: State = {
  initialized: false,
  conditionsRestored: false,
  isOpenSearchArea: true,
  searchParams: {
    mode: SEARCH_MODE.MONTH, // designer:341 RdoMonth.Checked=true → 기본 MONTH
    month: dayjs().format('YYYYMM'), // 기본 최신월(SCP0084 미배포 폴백 — goal.md C1)
    date: dayjs().format('YYYYMMDD'), // datePicker 기본=오늘(cs:200)
    divisionId: 'ALL', // MyDivision 기본 ALL(designer NoneString="ALL")
    plantId: 'ALL', // PlantByGroup_SCP 기본 ALL
    itemId: '',
    itemType: 'ALL', // Item Type 기본 ALL
    devaluationAge: false, // 재고월령 컬럼 기본 숨김
  },
  filters: {},
  staticColumns: [],
  isHeaderViewDetail: false, // 초기 상세 숨김(cs:198)
  noDivisionAuth: false, // 콤보 미조회 상태 기본 허용(divisions undefined 동안 조회 미차단)
};

export const useEndingInventoryStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setOpenSearchArea: open =>
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      }),
    // Division 변경 시 하위 Plant 를 ALL 로 리셋(재조회형 cascade — design 02 §3, 02 §4.6).
    //   그리드는 유지하고 재조회는 Search 로만(bod 선례 — 멀티선택 토글마다 조회 방지).
    setSearchParams: params =>
      set(state => {
        const prev = get().searchParams;
        const next = { ...prev, ...params };
        if (params.divisionId !== undefined && params.divisionId !== prev.divisionId) {
          next.plantId = 'ALL';
        }
        // 모드 전환 = 그리드 초기화(AS-IS rdButton_Changed → ClearDataSource(spdMain), cs:519~522).
        //   이전 모드 조회결과가 재전환 시 stale 로 재노출되지 않도록 filters 를 비운다(재조회 전 빈 그리드).
        //   page 의 rows 파생도 filters[mode] 유무로 게이트하므로 React Query 캐시가 새어나오지 않는다.
        if (params.mode !== undefined && params.mode !== prev.mode) {
          state.filters = {};
        }
        state.searchParams = next;
      }),
    // F6 개인화 조회조건 복원(SubTitle personalizeCondition 저장분 되불러오기 — 탭 수명 내 1회).
    //   저장분 없으면 기본값 유지. 저장은 값을 평문화(String coerce)하는데 SCP0085 조회조건
    //   (mode/month/date/divisionId/plantId/itemId/itemType)은 문자열이라 그대로, devaluationAge 만 boolean 으로 되돌린다
    //   (divisionId/plantId 는 콤마 다중이지만 store 표현이 이미 콤마 문자열). setSearchParams 를 거치면
    //   divisionId 복원이 plantId 를 ALL 로 리셋하므로 여기서는 searchParams 를 직접 merge 한다(cascade 우회).
    restoreSearchParams: async () => {
      if (get().conditionsRestored) return;
      set(state => {
        state.conditionsRestored = true;
      });
      try {
        const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        const rows = res.data.result ?? [];
        if (rows.length === 0) return;
        const patch: Record<string, string | boolean> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in initState.searchParams)) continue;
          // boolean 조회조건은 저장 시 문자열로 평문화되므로 되돌린다.
          patch[paramNm] =
            paramNm === 'devaluationAge' ? paramCtn === 'true' : (paramCtn ?? '');
        }
        set(state => {
          state.searchParams = { ...state.searchParams, ...(patch as Partial<SearchParams>) };
        });
      } catch {
        // 미저장/조회 실패 = 기본값 유지(console 금지 룰).
      }
    },
    // 모드에 따라 조회 SP·기간 파라미터키를 분기(design 02 §2.2). refetch 직접호출 금지 — 참조 교체.
    setFilters: () =>
      set(state => {
        const c = get().searchParams;
        const common = {
          divisionId: c.divisionId, // p_division_id
          plantId: c.plantId, // p_plant_id
          itemId: c.itemId, // p_item_id
          // p_item_type — SP 는 'ALL' 을 코드로 비교해 0행이 되므로 전체(ALL)는 빈값(NULL=조건 없음)으로 보낸다.
          itemType: c.itemType === 'ALL' ? '' : c.itemType,
          debugMode: 'F', // debug_mode
        };
        state.filters =
          c.mode === SEARCH_MODE.DAILY
            ? { [SHEETS.DAILY]: { ...common, yyyymmdd: c.date } as never } // p_yyyymmdd
            : { [SHEETS.MAIN]: { ...common, yyyymm: c.month } as never }; // p_yyyymm
      }),
    // mount 시 이전 filters cache 무효화 — incomplete payload 자동 발사 회피(nscm-patterns §5-7).
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    toggleHeaderViewDetail: () =>
      set(state => {
        state.isHeaderViewDetail = !state.isHeaderViewDetail;
      }),
    setNoDivisionAuth: value =>
      set(state => {
        state.noDivisionAuth = value;
      }),
    // 컬럼 메타 동적 fetch — SCM_MST_SHEET_COLUMNS(admin) 변경 즉시 반영(ui-category hook, 하드코딩 금지).
    //   월·일 모드 공통 단일 컬럼셋('Ending Inventory Main').
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
  'ending-inventory'
);
