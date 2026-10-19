import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, DEFAULT_DIVISION, MENU_ID, SHEETS } from './scp-bom.constants';
import type { SearchCondition } from './scp-bom.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

interface State {
  initialized: boolean;
  // 개인화 조회조건 복원 1회 가드 (SubTitle F6 저장분 mount 복원 — initialized 는 컬럼 fetch 전용이라 별도).
  conditionsRestored: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // ui-dynamic-property-management — admin SCM_MST_SHEET_COLUMNS 동적 fetch(실측 27행, design 03 §1).
  staticColumns: RawFlexGridColumnConfig[];
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setDivision: (divisionId: string) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchCondition 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

// 개인화 조건 복원 역직렬화 키(SubTitle F6 저장은 배열=콤마join·불리언=String 평문화 — personalizeCondition).
//   plantSiteIds = 멀티셀렉트(콤마 결합 → split), alterBom = 체크박스(String(bool) → ==='true').
//   날짜 조회조건 없음 → EXCLUDED_DATE_PARAM 대상 0건(전 조건 복원 가능).
const RESTORE_ARRAY_KEYS = new Set<string>(['plantSiteIds']);
const RESTORE_BOOL_KEYS = new Set<string>(['alterBom']);

const initSearch: SearchCondition = {
  divisionId: DEFAULT_DIVISION, // '81' 고정 (design 01 R7)
  plantSiteIds: [],
  modelId: '',
  parentId: '',
  childId: '',
  alterBom: false, // 기본 미체크 = 'ALL' (design 02 §4)
};

const initState: State = {
  initialized: false,
  conditionsRestored: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  staticColumns: [],
};

const trim = (v: string): string => (v && v.trim() ? v.trim() : '');
// 다중 Plant Site → SP 파라미터. 전체선택/미선택(빈 배열) = 빈 문자열(NULL=전체), 부분선택 = 콤마 결합
//   (design 02 §2.3 — 'ALL' 문자열 전달 금지).
const plantSiteParam = (ids: string[]): string => (ids.length === 0 ? '' : ids.join(','));

export const useScpBomStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division 을 제외한 검색조건을 전부 초기화하고 그리드도
    //   초기화(filters clear)한다(사용자 지시 2026-10-02 — TO-BE 공통 요건이 AS-IS 핸들러보다 우선, SCP0025 선례).
    //   이 화면은 기간/날짜 조회조건이 없어 유지 대상은 Division(새 값)뿐이고, 나머지(PlantSite/Model/Parent/Child/
    //   AlterBOM)는 initSearch 로 초기화된다. PlantSite cascade 초기화도 이로써 포함된다(design 02 §3).
    //   편집중(dirty) 확인 가드(MSG00704)는 Form 의 Division onChange 가 confirmIfDirtyKey 로 처리한다(commit 51d4e9fa).
    setDivision: divisionId =>
      set(state => {
        state.searchCondition = {
          ...initSearch, // Division 제외 전 조건 초기화(plantSite/model/parent/child/alterBom)
          divisionId,
        };
        state.filters = {}; // 그리드 초기화 — 재조회(Search) 전까지 빈 상태
      }),
    // GET SP 파라미터 매핑 (PROC_M COL_NM 실측, design 03 §4.1 — PKG_SCP0053.P_SCP0053_GET_SCP_BOM):
    //   1 divisionId  ('81' 고정)
    //   2 plantSiteId (콤마 다중, 빈=전체)
    //   3 modelId / 4 parentId / 5 childId (각 단일값)
    //   6 alterBom    ('ALTER' | 'ALL')
    //   7 debugMode   (미전달 — DEFAULT 'F')
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: c.divisionId, // 1
            plantSiteId: plantSiteParam(c.plantSiteIds), // 2
            modelId: trim(c.modelId), // 3
            parentId: trim(c.parentId), // 4
            childId: trim(c.childId), // 5
            alterBom: c.alterBom ? 'ALTER' : 'ALL', // 6
          },
        };
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

    // admin SCM_MST_SHEET_COLUMNS 동적 fetch — 미등록/실패 시 빈 배열 유지(그리드 컬럼 없음).
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] }
        );
        const next = res.data.result ?? [];
        if (next.length > 0) {
          set(state => {
            if (JSON.stringify(state.staticColumns) !== JSON.stringify(next)) {
              state.staticColumns = next;
            }
          });
        }
      } catch {
        // 미등록/실패 (console 금지 룰)
      }
      set(state => {
        state.initialized = true;
      });
    },

    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 형제 shipment-plan-fix 파리티.
    //   GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 역직렬화(배열 split·불리언 ==='true').
    //   저장분 없거나 조회 실패면 기본값 유지. 저장은 EXCLUDED_DATE_PARAM·빈값 필터 후 재삽입이라
    //   (gridAction.ts personalizeCondition) 응답에 없는 키는 initSearch 기본값 그대로 둔다.
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
          if (!(paramNm in initSearch)) continue; // SearchCondition 필드만 allowlist
          const val = paramCtn ?? '';
          if (RESTORE_ARRAY_KEYS.has(paramNm)) patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          else if (RESTORE_BOOL_KEYS.has(paramNm)) patch[paramNm] = val === 'true';
          else patch[paramNm] = val;
        }
        set(state => {
          state.searchCondition = { ...state.searchCondition, ...patch } as SearchCondition;
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지 룰)
      }
    },
  }),
  'scp-bom-store'
);
