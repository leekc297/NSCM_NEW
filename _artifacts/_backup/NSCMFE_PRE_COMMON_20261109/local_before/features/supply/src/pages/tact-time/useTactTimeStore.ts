import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS, TACT_MODE } from './tact-time.constants';
import type { MainRow, SearchCondition } from './tact-time.types';

type FiltersBySheet = {
  [SHEETS.PLANT]?: ProcRequest<MENU_ID, SHEETS.PLANT>;
  [SHEETS.PACKER]?: ProcRequest<MENU_ID, SHEETS.PACKER>;
  [SHEETS.EXCEPT]?: ProcRequest<MENU_ID, SHEETS.EXCEPT>;
};

type StaticColumnsBySheet = {
  [SHEETS.PLANT]: RawFlexGridColumnConfig[];
  [SHEETS.PACKER]: RawFlexGridColumnConfig[];
  [SHEETS.EXCEPT]: RawFlexGridColumnConfig[];
};

interface State {
  initialized: boolean;
  // 개인화 조회조건 복원 1회 가드 (SubTitle F6 저장분 mount 복원 — initialized 는 컬럼 fetch 전용이라 별도).
  conditionsRestored: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch (미등록 시 빈 배열 →
  //   그리드가 constants 컬럼셋으로 fallback). 등록 확인완료(2026-10-07 ora.py 실측):
  //   SCP0020 Plant/Packer/Tact Time Except 전부 등록됨 → 실사용은 admin 메타, constants 는 fallback.
  staticColumns: StaticColumnsBySheet;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setDivision: (divisionId: string) => void;
  setMode: (mode: TACT_MODE) => void;
  setFilter: () => void;
  clearFilters: () => void;
  // spdMain 선택행 더블클릭 -> 하단 spdExcept 파생 조회 (design 01 D-5 / 03 §4.2)
  setExceptFilter: (row: MainRow  ) => void;
  clearExceptFilter: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchCondition 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

// 개인화 조건 복원 시 배열 역직렬화 키(SubTitle F6 저장은 배열=콤마join 평문화 — personalizeCondition).
const ARRAY_KEYS = new Set<string>(['plantSiteIds', 'lineIds']);

const initSearch: SearchCondition = {
  // 기본 사업부 = 세션 division (formation 표준). 없으면 '40' fallback.
  divisionId: useSessionStore.getState().session.div ?? '40',
  plantSiteIds: [],
  lineIds: [],
  operationGroupId: 'P', // AS-IS 기본값 = P(Packer). ALL 옵션 없음 (cs:221 setListBox false).
  valid: 'ALL',
  itemId: '',
  mode: TACT_MODE.PACKER, // AS-IS 기본 활성 = Packer (design 01 D-3)
};

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.PLANT]: [],
  [SHEETS.PACKER]: [],
  [SHEETS.EXCEPT]: [],
};

const initState: State = {
  initialized: false,
  conditionsRestored: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  staticColumns: emptyStaticColumns,
};

// 다중 선택 배열 -> SP 파라미터 문자열 (빈 배열 = 'ALL' 센티널, design 02 §5.3)
const joinOrAll = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join(','));
const orAll = (v: string): string => (v && v.trim() ? v.trim() : 'ALL');
const str = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

export const useTactTimeStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division 을 제외한 검색조건을 전부 초기화하고(plantSite/line/
    //   operationGroup/valid/item) 그리드도 초기화(filters clear)한다(사용자 지시 2026-10-02 — TO-BE 공통
    //   요건이 AS-IS cascade-only 핸들러보다 우선). 이 화면엔 기간/날짜 조회조건이 없어 유지 대상은 Division 뿐.
    //   mode(Plant/Packer 활성 탭)는 검색필터가 아니라 뷰 상태라 유지한다(AS-IS Packer 고정). 편집중(dirty)
    //   확인 가드(MSG00704)는 Form 의 onChange 가 confirmIfDirtyKey 로 처리한다(commit 51d4e9fa 패턴).
    setDivision: divisionId =>
      set(state => {
        const cur = get().searchCondition;
        state.searchCondition = {
          ...initSearch, // Division 제외 전 조건 초기화(plantSite/line/operationGroup/valid/item)
          divisionId,
          mode: cur.mode, // 활성 탭(뷰)은 유지 — 검색필터 아님
        };
        state.filters = {}; // 그리드 초기화(Plant/Packer/Except) — 재조회(Search) 전까지 빈 상태
      }),
    setMode: mode =>
      set(state => {
        // 모드 전환 = cascade 공급 경로 변경(design 02 §3) + 하위(plantSite/line) 초기화 + 그리드/필터 리셋.
        state.searchCondition = { ...get().searchCondition, mode, plantSiteIds: [], lineIds: [] };
        state.filters = {};
      }),
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        // design 02 §2.7 — Plant GET 만 p_valid 전달, Packer GET 은 미전달.
        if (c.mode === TACT_MODE.PLANT) {
          state.filters = {
            [SHEETS.PLANT]: {
              divisionId: orAll(c.divisionId),
              plantSiteId: joinOrAll(c.plantSiteIds),
              lineId: joinOrAll(c.lineIds),
              operationGroupId: orAll(c.operationGroupId),
              itemId: orAll(c.itemId),
              valid: orAll(c.valid),
              debugMode: 'N',
            },
          };
        } else {
          state.filters = {
            [SHEETS.PACKER]: {
              divisionId: orAll(c.divisionId),
              plantSiteId: joinOrAll(c.plantSiteIds),
              lineId: joinOrAll(c.lineIds),
              operationGroupId: orAll(c.operationGroupId),
              itemId: orAll(c.itemId),
              debugMode: 'N',
            },
          };
        }
      });
    },
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    setExceptFilter: row =>
      set(state => {
        const r = row as Record<string, unknown>;
        state.filters = {
          ...state.filters,
          [SHEETS.EXCEPT]: {
            divisionId: orAll(str(r.DIVISION_ID)),
            plantSite: orAll(str(r.PLANT_SITE_ID)),
            operationId: orAll(str(r.OPERATION_ID)),
            itemId: orAll(str(r.ITEM_ID)),
            lineId: orAll(str(r.LINE_ID)),
            debugMode: 'N',
          },
        };
      }),
    clearExceptFilter: () =>
      set(state => {
        delete state.filters[SHEETS.EXCEPT];
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),

    // admin SCM_MST_SHEET_COLUMNS 동적 fetch — 미등록/실패 시 빈 배열 유지(그리드 constants fallback).
    fetchStaticColumns: async () => {
      const sheets: (keyof StaticColumnsBySheet)[] = [SHEETS.PLANT, SHEETS.PACKER, SHEETS.EXCEPT];
      await Promise.all(
        sheets.map(async sheet => {
          try {
            const res = await apiClient.post<RawFlexGridColumnConfig[]>(
              `/admin/menu/${MENU_ID}/column`,
              { sheetNm: ADMIN_SHEET_NAME[sheet] ?? sheet }
            );
            const next = res.data.result ?? [];
            if (next.length === 0) return;
            set(state => {
              if (JSON.stringify(state.staticColumns[sheet]) !== JSON.stringify(next)) {
                state.staticColumns[sheet] = next;
              }
            });
          } catch {
            // 미등록/실패 = constants fallback (console 금지 룰)
          }
        })
      );
      set(state => {
        state.initialized = true;
      });
    },

    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 형제 화면 파리티.
    //   GET /admin/menu/{MENU_ID}/search-conditions → PRAM_NM/PRAM_CTN 역직렬화(배열 split, 나머지 그대로).
    //   저장분 없으면 기본값 유지.
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
          patch[paramNm] = ARRAY_KEYS.has(paramNm) ? (val ? val.split(',').filter(Boolean) : []) : val;
        }
        set(state => {
          state.searchCondition = { ...state.searchCondition, ...patch } as SearchCondition;
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지)
      }
    },
  }),
  'tact-time-store'
);
