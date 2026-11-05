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
  // 권한 Division 코드(Form 이 Division 콤보 로드 후 세팅) — setFilters 가 'ALL' 을 이 코드 열거로
  //   펼쳐 조회한다(권한 밖 division 누수 차단, setFilters 주석 참조).
  authDivisions: string[];
}

interface Action {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (params: Partial<SearchParams>) => void;
  setFilters: () => void;
  clearFilters: () => void;
  setNoDivisionAuth: (value: boolean) => void;
  setAuthDivisions: (codes: string[]) => void;
  fetchStaticColumns: () => Promise<void>;
  // 저장된 조회조건(F6 Condition) 불러오기 — Month 제외(월범위/기본값 로직이 소유). mount 1회.
  loadSavedCondition: () => Promise<void>;
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
  authDivisions: [],
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
        // Division 은 'ALL'/미선택을 권한 Division 코드로 '전개'해 보낸다 — AS-IS GetCheckedListValue
        //   2-arg(SCP0084_LongTermStock.cs L294)가 'ALL'을 dtMyDivision(권한) 코드로 열거한 것과 등가.
        //   리터럴 ''(무필터)로 보내면 GET SP 가 권한 밖 division 까지 반환한다(제한 계정 권한 우회,
        //   SCP0001·SSP0005 선례, 실측 2026-10-30). 표시용 searchParams.divisionId 는 'ALL' 유지.
        //   plant/longTermType 은 division 게이트/전역이라 ''(무필터)로 둬도 결과 동일.
        const picked = c.divisionId
          .split(',')
          .map(s => s.trim())
          .filter(x => x !== '' && x.toUpperCase() !== 'ALL');
        const divisionId = picked.length > 0 ? picked.join(',') : get().authDivisions.join(',');
        state.filters = {
          [SHEETS.MAIN]: {
            yyyymm: c.month, // p_yyyymm
            divisionId, // p_division_id (ALL=권한 division 코드 열거)
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
    setAuthDivisions: codes =>
      set(state => {
        if (state.authDivisions.join(',') !== codes.join(',')) state.authDivisions = codes;
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
    // 저장된 조회조건 복원 — GET /admin/menu/{id}/search-conditions 의 [{paramNm,paramCtn}] 를
    //   searchParams 에 병합(project-registration/user-management 선례). Month 는 저장 대상에서
    //   뺐으므로(SubTitle searchParam) 응답에 와도 무시 — 월범위/기본값(최신월) 로직이 소유한다.
    loadSavedCondition: async () => {
      try {
        const res = await apiClient.get<{ paramNm: keyof SearchParams; paramCtn: string }[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        const rows = res.data.result ?? [];
        if (rows.length === 0) return;
        const restored: Partial<SearchParams> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (paramNm === 'month') continue;
          restored[paramNm] = paramCtn;
        }
        set(state => {
          state.searchParams = { ...state.searchParams, ...restored };
        });
      } catch {
        // 저장된 조건 없음/조회 실패 — 기본값 유지(silent, console 금지)
      }
    },
  }),
  'long-term-stock'
);
