import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS, TAB_INDEX } from './stock-osp.constants';
import type { SearchCondition } from './stock-osp.types';

// useTabProcQuery enabled 가드용 filter payload — store 보관 참조만 전달(인라인 객체 금지, 참조비교 함정).
type FiltersBySheet = {
  [SHEETS.OSP]?: ProcRequest<MENU_ID, SHEETS.OSP>;
  [SHEETS.PACK]?: ProcRequest<MENU_ID, SHEETS.PACK>;
};

interface State {
  initialized: boolean;
  // 개인화 조회조건 복원 1회 가드 (SubTitle F6 저장분 mount 복원 — initialized 는 컬럼 fetch 전용이라 별도).
  conditionsRestored: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  activeTab: TAB_INDEX;
  // admin SCM_MST_SHEET_COLUMNS 동적 fetch — 시트별(Osp 14 / Pack 15, design 03 §1). 컬럼명 하드코딩 금지.
  staticColumns: Partial<Record<SHEETS, RawFlexGridColumnConfig[]>>;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setDivision: (divisionId: string) => void;
  setFilter: (sheet: SHEETS) => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setActiveTab: (tab: TAB_INDEX) => void;
  fetchStaticColumns: (sheets: SHEETS[]) => Promise<void>;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchCondition 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

// 개인화 조건 복원 역직렬화 키 — SubTitle F6 저장(personalizeCondition)은 배열을 콤마join 으로 평문화하므로
//   복원 시 split 해 배열로 되돌린다(불리언 조회조건은 없음). 날짜 4종(from/to·cutoff from/to)은
//   공용 EXCLUDED_DATE_PARAM(/yyyymmdd$/)에 걸려 저장 자체가 안 되므로 복원 응답에도 없음 → 기간 유지.
const RESTORE_ARRAY_KEYS = new Set<string>(['plantSiteIds']);

// 기본 조회조건 — Division 은 세션 사업부 기본(페이지 mount 시 권한 첫 항목으로 재보정) / 멀티 = [](ALL) /
//   Status = ''(전체) / 날짜는 Form PeriodField 기본 로직에 위임(빈 값 시작).
const initSearch: SearchCondition = {
  divisionId: useSessionStore.getState().session.div ?? '',
  plantSiteIds: [],
  itemId: '',
  fromYyyymmdd: '',
  toYyyymmdd: '',
  inspectionId: '',
  status: '',
  cutoffFromYyyymmdd: '',
  cutoffToYyyymmdd: '',
};

const initState: State = {
  initialized: false,
  conditionsRestored: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  activeTab: TAB_INDEX.OSP,
  staticColumns: {},
};

const trim = (v: string): string => (v && v.trim() ? v.trim() : '');
// 다중 Plant Site → SP 파라미터. 전체선택/미선택(빈 배열) = 빈 문자열(NULL=전체), 부분선택 = 콤마 결합
//   (design 02 §Osp/§Pack — 콤보 SQL 이 INSTR/등호로 파싱. 'ALL' 문자열 전달 금지).
const multiParam = (ids: string[]): string => (ids.length === 0 ? '' : ids.join(','));

export const useStockOspStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division·기간/날짜(Period from/to·Cutoff Date from/to)를 제외한
    //   검색조건(PlantSite/Model/Inspection/Status)을 전부 초기화하고 그리드도 초기화(filters clear)한다
    //   (사용자 지시 2026-10-02 — TO-BE 공통 요건이 AS-IS 핸들러보다 우선, SCP0025 정본 패턴 1:1).
    //   편집중(dirty) 확인 가드(MSG00704)는 Form 의 onChange 가 confirmIfDirtyKey 로 처리한다(commit 51d4e9fa).
    //   PlantSite 는 비워지고 useTabComboQueries 의 divisionId 파라미터로 cascade 재조회된다.
    setDivision: divisionId =>
      set(state => {
        const cur = get().searchCondition;
        state.searchCondition = {
          ...initSearch, // Division·기간/날짜 제외 전 조건 초기화(plantSite/item/inspection/status)
          divisionId,
          fromYyyymmdd: cur.fromYyyymmdd,
          toYyyymmdd: cur.toYyyymmdd,
          cutoffFromYyyymmdd: cur.cutoffFromYyyymmdd,
          cutoffToYyyymmdd: cur.cutoffToYyyymmdd,
        };
        state.filters = {}; // 그리드 초기화 — 재조회(Search) 전까지 빈 상태(queryKey 가 바뀌어 빈 캐시 엔트리로 전환)
      }),
    // GET SP 파라미터 매핑 (PROC_M COL_NM = P_ 제거 camelCase, ALL_ARGUMENTS 실측):
    //   Osp  P_SCP0041_GET_STOCK_OSP(5)      : divisionId/plantSiteId/itemId/fromYyyymmdd/toYyyymmdd
    //   Pack P_SCP0041_GET_PACK_HOLD_STOCK(9): + inspectionId/status/cutoffFromYyyymmdd/cutoffToYyyymmdd
    //   sesUserId/mnuId 는 BE 세션 자동주입 — payload 미포함.
    setFilter: sheet => {
      set(state => {
        const c = state.searchCondition;
        if (sheet === SHEETS.OSP) {
          state.filters[SHEETS.OSP] = {
            divisionId: c.divisionId,
            plantSiteId: multiParam(c.plantSiteIds),
            itemId: trim(c.itemId),
            fromYyyymmdd: trim(c.fromYyyymmdd),
            toYyyymmdd: trim(c.toYyyymmdd),
          };
        } else {
          state.filters[SHEETS.PACK] = {
            divisionId: c.divisionId,
            plantSiteId: multiParam(c.plantSiteIds),
            itemId: trim(c.itemId),
            fromYyyymmdd: trim(c.fromYyyymmdd),
            toYyyymmdd: trim(c.toYyyymmdd),
            inspectionId: trim(c.inspectionId),
            status: trim(c.status),
            cutoffFromYyyymmdd: trim(c.cutoffFromYyyymmdd),
            cutoffToYyyymmdd: trim(c.cutoffToYyyymmdd),
          };
        }
      });
    },
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),
    setActiveTab: tab =>
      set(state => {
        state.activeTab = tab;
      }),

    // admin SCM_MST_SHEET_COLUMNS 동적 fetch — 시트별. 미등록/실패 시 기존 배열 유지(하드코딩 fallback 금지).
    fetchStaticColumns: async sheets => {
      await Promise.all(
        sheets.map(async sheet => {
          try {
            const res = await apiClient.post<RawFlexGridColumnConfig[]>(
              `/admin/menu/${MENU_ID}/column`,
              { sheetNm: ADMIN_SHEET_NAME[sheet] }
            );
            const next = res.data.result ?? [];
            if (next.length > 0) {
              set(state => {
                if (JSON.stringify(state.staticColumns[sheet]) !== JSON.stringify(next)) {
                  state.staticColumns[sheet] = next;
                }
              });
            }
          } catch {
            // 미등록/실패 (console 금지 룰 · 하드코딩 fallback 금지)
          }
        })
      );
      set(state => {
        state.initialized = true;
      });
    },

    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 형제 shipment-plan-fix 파리티.
    //   GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 역직렬화(배열 split, 그 외 문자열).
    //   저장분 없으면/실패 시 기본값 유지. 날짜 4종은 저장 제외라 응답에 없음(기간은 Form PeriodField 기본값 유지).
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
        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in initSearch)) continue;
          const val = paramCtn ?? '';
          if (RESTORE_ARRAY_KEYS.has(paramNm)) patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          else patch[paramNm] = val;
        }
        set(state => {
          state.searchCondition = { ...state.searchCondition, ...patch } as SearchCondition;
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지)
      }
    },
  }),
  'stock-osp-store'
);
