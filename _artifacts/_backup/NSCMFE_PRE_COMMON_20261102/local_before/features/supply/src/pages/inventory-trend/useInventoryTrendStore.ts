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
  // F6(SubTitle) 개인화 조회조건 복원 1회 가드 — initialized(컬럼 fetch 전용)와 분리.
  //   새로고침=새 store 라 재진입마다 다시 복원된다.
  conditionsRestored: boolean;
}

interface Action {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (params: Partial<SearchParams>) => void;
  setFilters: () => void;
  clearFilters: () => void;
  setNoDivisionAuth: (value: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  restoreSearchConditions: () => Promise<void>;
}

const initState: State = {
  initialized: false,
  isOpenSearchArea: true,
  searchParams: {
    // 기본 최신월 — AS-IS SCP0084_GET_MONTH_RANGE.MAX_YYYYMM(cs:645). 콤보(COMBO.MONTH_RANGE) 도착 전
    //   초기 폴백만 현재월이고, Form 이 MAX_YYYYMM 도착 시 1회 덮어쓴다(InventoryTrendForm monthRange effect).
    month: dayjs().format('YYYYMM'),
    divisionId: 'ALL', // Division_SCP 기본 ALL(setListBox blnAllFlag=true, CControl.cs:56~70)
    plantId: 'ALL', // PlantByGroup_SCP 기본 ALL
    itemId: '',
    detail: false, // 상세 22컬럼 기본 숨김 — AS-IS chkDetail.InitValue='N'(.designer:351)
  },
  filters: {},
  staticColumns: [],
  noDivisionAuth: false, // 콤보 미조회 상태 기본 허용(divisions undefined 동안 조회 미차단)
  conditionsRestored: false,
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
    // F6(SubTitle searchParam) 개인화 저장분 복원(1회) — 정본 scp-bom(SCP0053)·자매 global-psi-report(SCP0100) 파리티.
    //   GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 를 searchParams 에 패치.
    //   SearchParams 문자열 4필드(month/divisionId/plantId/itemId)는 그대로, detail(boolean)만 역직렬화한다.
    //   저장은 EXCLUDED_DATE_PARAM·빈값 필터 후 재삽입이라(gridAction.ts personalizeCondition),
    //   응답에 없는 키는 initState 기본값을 그대로 둔다(저장분 없거나 조회 실패도 동일).
    //   주의: setSearchParams(cascade)를 거치지 않고 직접 치환 — 저장된 divisionId·plantId 를 함께 복원한다.
    restoreSearchConditions: async () => {
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
        const init = initState.searchParams;
        const patch: Record<string, string | boolean> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in init)) continue; // SearchParams 필드만 allowlist
          // boolean 조회조건(detail)은 저장 시 문자열로 평문화되므로 되돌린다(형제 ending-inventory 동형).
          patch[paramNm] = paramNm === 'detail' ? paramCtn === 'true' : (paramCtn ?? '');
        }
        set(state => {
          state.searchParams = { ...state.searchParams, ...(patch as Partial<SearchParams>) };
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지 룰)
      }
    },
  }),
  'inventory-trend'
);
