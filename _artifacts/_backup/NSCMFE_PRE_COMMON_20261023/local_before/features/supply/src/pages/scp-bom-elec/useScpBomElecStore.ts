import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './scp-bom-elec.constants';
import type { SearchCondition } from './scp-bom-elec.types';

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
  // ui-dynamic-property-management — admin SCM_MST_SHEET_COLUMNS 동적 fetch(실측 13행, design 03 §1).
  staticColumns: RawFlexGridColumnConfig[];
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  // Division 변경(싱글 콤보) = Division 제외 검색조건 전부 초기화 + Grid 초기화(TO-BE 공통 요건, design 01 R6c).
  changeDivision: (divisionId: string) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchCondition 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

const initSearch: SearchCondition = {
  divisionId: '', // 콤보 로드 후 '81' 존재 시 선택·미존재 시 마지막 항목 (design 01 R6b — Form effect)
  parentId: '',
  childId: '',
};

const initState: State = {
  initialized: false,
  conditionsRestored: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  staticColumns: [],
};

// 멀티라인 텍스트 → SP 콤마 다중 파라미터 (design 02 §2.3 — AS-IS UsrMultiLineEditor 내장 등가):
//   개행 분리 후 전량 공백 줄만 스킵, 줄 내 공백은 미트림(토큰 trim 추가는 임의 개선 — 금지). 공백=미전달(NULL=전체).
//   단일 라인에 직접 콤마 입력도 그대로 통과(SP UF_FX_STRING_SPLIT 가 콤마 분리).
const normalizeMulti = (v: string): string =>
  v
    .split(/\r?\n/)
    .filter(line => line.trim().length > 0)
    .join(',');

export const useScpBomElecStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division 을 제외한 검색조건(Parent/Child Item)을 전부 초기화하고
    //   그리드도 초기화(filters clear)한다(사용자 지시 2026-10-02 — TO-BE 공통 요건이 AS-IS 핸들러보다 우선).
    //   이 화면은 기간/날짜 조회조건이 없어 유지 대상은 Division(새 값) 뿐. 편집중(dirty) 확인 가드(MSG00704)는
    //   Form 의 onChange 가 confirmIfDirtyKey 로 처리한다(commit 51d4e9fa 패턴).
    changeDivision: divisionId =>
      set(state => {
        state.searchCondition = { ...initSearch, divisionId }; // Division 제외 전 조건 초기화(parentId/childId)
        state.filters = {}; // Grid 비움 + CRUD reset (design 01 R6c)
      }),
    // GET SP 파라미터 매핑 (PKG_SCP0097.P_SCP0097_GET_SCP_BOM_ELEC — all_arguments 실측):
    //   1 P_DIVISION_ID (단일·필수)
    //   2 P_PARENT_ID   (콤마 다중, 공백=전체)
    //   3 P_CHILD_ID    (콤마 다중, 공백=전체)
    //   4 P_DEBUG_MODE  ('F' 고정 — 시그니처 DEFAULT 없음, 생략 불가)
    //   SCM_ADM_PROC_M 등록 완료(05_register.sql (h), 15행 실측). 아래 키 = PROC_M COL_NM 과 1:1 일치.
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: c.divisionId, // 1
            parentId: normalizeMulti(c.parentId), // 2
            childId: normalizeMulti(c.childId), // 3
            debugMode: 'F', // 4
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

    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 자매 scp-bom(SCP0053) 파리티.
    //   GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 를 searchCondition 에 패치.
    //   SearchCondition 3필드(divisionId/parentId/childId)는 전부 문자열이라 역직렬화 불요(배열/불리언/날짜 키 0건)
    //   — 저장(gridAction.ts personalizeCondition)이 값을 String coerce 하므로 그대로 되넣는다.
    //   저장분 없거나 조회 실패면 기본값 유지. 저장은 빈값 필터 후 재삽입이라 응답에 없는 키는 initSearch 기본값 그대로.
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
        const patch: Record<string, string> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in initSearch)) continue; // SearchCondition 필드만 allowlist
          patch[paramNm] = paramCtn ?? '';
        }
        set(state => {
          state.searchCondition = { ...state.searchCondition, ...patch } as SearchCondition;
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지 룰)
      }
    },
  }),
  'scp-bom-elec-store'
);
