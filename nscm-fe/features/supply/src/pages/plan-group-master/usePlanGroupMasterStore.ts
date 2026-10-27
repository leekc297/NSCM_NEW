import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, ALL, MENU_ID, SHEETS } from './plan-group-master.constants';
import type { PlanGroupSearchParams } from './plan-group-master.types';
import { toParamCsv } from './utils/plan-group-master.searchInfo';

type MainFilter = ProcRequest<MENU_ID, SHEETS.MAIN>;
type SearchInfoFilter = ProcRequest<MENU_ID, SHEETS.SEARCH_INFO>;

interface PlanGroupMasterState {
  initialized: boolean;
  // F6 저장 조회조건 복원 1회 가드 (basic-check #3). 복원은 재진입/새로고침당 1회.
  conditionsRestored: boolean;
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
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchParams 패치(1회).
  restoreSearchConditions: () => Promise<void>;
  setSearchParams: (params: Partial<PlanGroupSearchParams>) => void;
  setMainFilters: () => void;
  clearMainFilters: () => void;
  loadSearchInfo: () => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
}

// AS-IS 기본 Division = 콤보 첫 행(권한내 첫 사업부, 02 §4) — 세션 div 강제선택 없음(GAP-10 해소).
//   divisionId 는 빈값으로 두고 권한 콤보 도착 후 Form 보정 effect 가 첫 행으로 채운다. F6 복원값이 권한 내면 유지.
const makeInitSearchParams = (): PlanGroupSearchParams => ({
  divisionId: '',
  operation: ALL,
  plant: ALL,
  building: ALL,
  line: ALL,
  planGroup: ALL,
});

const makeInitState = (): PlanGroupMasterState => ({
  initialized: false,
  conditionsRestored: false,
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

  /**
   * F6(조회조건 저장)로 저장한 개인화 조회조건을 재진입/새로고침 시 1회 복원한다(basic-check #3).
   * 저장측은 SubTitle `searchParam={searchParams}` → `GridAction.personalizeCondition` 으로, 전 값을
   * String coerce 해 보낸다(paramNm=searchParams 키). 이 화면 searchParams 6필드는 전부 string
   * (divisionId + 체크리스트 5개는 'ALL' sentinel / CSV 문자열)이라 평문 allowlist patch 로 충분하다
   * (날짜/불리언/enum 축 없음 → capa-loss-plan 류 타입 환원 불요).
   *
   * `searchParams` 만 patch 하고 `filters` 는 건드리지 않아 진입 자동조회 게이트(filters[MAIN] 미설정)를
   * 유지한다. 복원은 `setSearchParams` 를 경유하지 않고 직접 병합한다 — setSearchParams 는 divisionId
   * 변경 시 하위 5축을 ALL 로 cascade 리셋해 복원값을 지우기 때문. 권한 목록 밖 divisionId 는 Form 의
   * 보정 effect(권한 콤보 도착 후)가 교체하므로 여기서 가드하지 않는다.
   *
   * 미저장/실패/미등록(SCM_ADM_MNU_M 라우트 없음)이면 런타임 no-op(기본값 유지) — 배선 자체가
   * 파리티 요건이라 선적용한다.
   */
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
      const allow = makeInitSearchParams(); // searchParams 키만 allowlist
      const patch: Partial<PlanGroupSearchParams> = {};
      for (const { paramNm, paramCtn } of rows) {
        if (!(paramNm in allow)) continue;
        patch[paramNm as keyof PlanGroupSearchParams] = paramCtn ?? '';
      }
      set(state => {
        state.searchParams = { ...state.searchParams, ...patch };
      });
    } catch {
      // 미저장/실패 = 기본값 유지 (console 금지 룰).
    }
  },

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
