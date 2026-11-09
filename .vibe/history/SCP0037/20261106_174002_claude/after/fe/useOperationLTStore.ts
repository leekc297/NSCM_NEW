import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, LT_OP, MENU_ID, SHEETS, VALID_ALL } from './operation-lt.constants';
import type { SearchCondition } from './operation-lt.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

type StaticColumnsBySheet = {
  [SHEETS.MAIN]: RawFlexGridColumnConfig[];
};

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // ui-dynamic-property-management — admin SCM_MST_SHEET_COLUMNS 동적 fetch (실측 13행 등록됨, design 03 §1).
  //   미등록/실패 시 빈 배열 -> 그리드가 constants MAIN_COLUMNS fallback.
  staticColumns: StaticColumnsBySheet;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setDivision: (divisionId: string) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchSearchConditions: () => Promise<void>;
}

const initSearch: SearchCondition = {
  divisionIds: [],
  ltOperationIds: [],
  plantSiteIds: [],
  itemId: '',
  validYn: VALID_ALL, // 기본 ALL (design 02 §4)
};

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.MAIN]: [],
};

const initState: State = {
  initialized: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  staticColumns: emptyStaticColumns,
};

// 다중 선택 배열 -> SP 파라미터 문자열 (빈 배열 = 'ALL' 센티널, design 02 §5).
const joinOrAll = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join(','));
const orAll = (v: string): string => (v && v.trim() ? v.trim() : 'ALL');

export const useOperationLTStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division 을 제외한 검색조건 전부 초기화 + 그리드 초기화
    //   (filters clear). 이 화면은 기간/날짜 조회조건이 없어 Division(새 값)만 유지하고 나머지
    //   (LT Operation·Plant Site·Material·Site Item Valid)는 initSearch 로 되돌린다. 재조회(Search) 전까지
    //   그리드는 빈 상태(기존 LT Operation cascade 와 동일한 clearFilters 파이프라인). 편집중(dirty) 확인
    //   가드(MSG00704)는 Form 의 onChange 가 confirmIfDirtyKey 로 처리한다(commit 51d4e9fa / SCP0025 패턴).
    setDivision: divisionId =>
      set(state => {
        state.searchCondition = {
          ...initSearch,
          divisionIds: divisionId ? [divisionId] : [],
        };
        state.filters = {}; // 그리드 초기화 — 재조회(Search) 전까지 빈 상태
      }),
    // GET SP 파라미터 매핑 (design 03 §4-2 SCP0037_GET_OPERATION_LT 5 param):
    //   1 p_division_id  (콤보 체크값 콤마)
    //   2 p_scm_site_id  (clbPlantSite 콤마 다중)
    //   3 p_item_id      (txtItemId 텍스트, NICK_NAME LIKE 도 매칭)
    //   4 p_scm_valid_yn (ALL -> NULL: SITE_ITEM_VALID_YN 무필터)
    //   5 p_lt_operation (cboLTOperation 콤마 다중)
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: joinOrAll(c.divisionIds), // 1
            scmSiteId: joinOrAll(c.plantSiteIds), // 2
            itemId: orAll(c.itemId), // 3
            scmValidYn: c.validYn === VALID_ALL ? 'ALL' : c.validYn, // 4 (ALL -> SP NULL 처리)
            ltOperation: joinOrAll(c.ltOperationIds), // 5
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

    // admin SCM_MST_SHEET_COLUMNS 동적 fetch — 미등록/실패 시 빈 배열 유지(그리드 constants fallback).
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? SHEETS.MAIN }
        );
        const next = res.data.result ?? [];
        if (next.length > 0) {
          set(state => {
            if (JSON.stringify(state.staticColumns[SHEETS.MAIN]) !== JSON.stringify(next)) {
              state.staticColumns[SHEETS.MAIN] = next;
            }
          });
        }
      } catch {
        // 미등록/실패 = constants fallback (console 금지 룰)
      }
      set(state => {
        state.initialized = true;
      });
    },

    // F6(Condition) 로 저장해 둔 개인 조회조건 복원 — SCP0042(BusinessPlan) fetchSearchConditions 1:1.
    //   SubTitle 이 searchParam={sc} 로 저장은 하고 있었는데 복원 경로가 없어서, 저장해도 재진입하면
    //   항상 기본값(Division=첫 항목 / LT Operation=SLITTING)으로 돌아왔다.
    //
    //   paramCtn 은 서버에서 항상 문자열이다. initSearch 의 필드 타입에 맞춰 역직렬화한다 —
    //   SCP0037 조회조건은 배열 3종(divisionIds/ltOperationIds/plantSiteIds)과 문자열 2종(itemId/validYn)뿐.
    //   배열 필드가 문자열로 남으면 setFilter 의 joinOrAll 이 깨진다.
    fetchSearchConditions: async () => {
      if (get().initialized) return;
      try {
        const res = await apiClient.get<{ paramNm: keyof SearchCondition; paramCtn: string }[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        const rows = res.data.result ?? [];
        if (rows.length > 0) {
          const proto = initSearch as unknown as Record<string, unknown>;
          const restored: Record<string, unknown> = {};
          for (const { paramNm, paramCtn } of rows) {
            if (paramNm == null || !(paramNm in proto)) continue;
            const raw = String(paramCtn ?? '').trim();
            if (Array.isArray(proto[paramNm])) {
              // '["40","81"]'(JSON) / '40^81' / '40,81' / '' 모두 수용
              let arr: string[] = [];
              if (raw.startsWith('[')) {
                try {
                  const parsed: unknown = JSON.parse(raw);
                  if (Array.isArray(parsed)) arr = parsed.map(v => String(v)).filter(Boolean);
                } catch {
                  arr = [];
                }
              } else if (raw) {
                arr = raw
                  .split(/[\^,]/)
                  .map(v => v.trim())
                  .filter(Boolean);
              }
              restored[paramNm] = arr;
            } else {
              restored[paramNm] = raw;
            }
          }
          set(state => {
            // 부분 병합 — 저장분에 없는 키는 기본값 유지 (신규 조회조건 추가 시 유실 방지).
            state.searchCondition = {
              ...state.searchCondition,
              ...(restored as Partial<SearchCondition>),
            };
          });
        }
      } catch {
        // 저장 조건 미존재/미응답 = 기본값 유지 (console 금지 룰)
      }
    },
  }),
  'operation-lt-store'
);

// LT Operation 선택이 INV_FLAG 컬럼 조건부 Visible 트리거인지 판정 (design 01 R6 / 03 §2).
//   AS-IS 는 단일 checked 값 == 'PRE_INSP' 비교(cs L854-861). 다중 선택 시 PRE_INSP 단독일 때만 표시.
export const isPreInspSelected = (ltOperationIds: string[]): boolean =>
  ltOperationIds.length === 1 && ltOperationIds[0] === LT_OP.PRE_INSP;
