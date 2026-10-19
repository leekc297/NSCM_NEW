import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { MENU_ID, RESPONSE_SET, SHEETS, resolveSheetNm } from './group-code-management.constants';
import type { GroupCodeSearchFilter, SearchCondition } from './group-code-management.types';

// useTabProcQuery enabled 가드용 — 조회를 눌러야 채워진다(명시조회).
type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

type StaticColumnsBySheet = {
  [key in RESPONSE_SET]: RawFlexGridColumnConfig[];
};

interface State {
  initialized: boolean;
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  openSearchArea: boolean;
  // division 전환마다 admin 메타(SCM_MST_SHEET_COLUMNS)에서 해당 sheetNm 컬럼셋을 다시 받는다.
  staticColumns: StaticColumnsBySheet;
  // 편집토글(EDIT 버튼). AS-IS IsEditMode 재현 — false 면 그리드 read-only + INSERT/DELETE 무동작.
  isEditMode: boolean;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setEditMode: (edit?: boolean) => void;
  // divisionId 전달 시 SP(PR_GET_SHEET_COLUMN_LIST)가 DIVISION_ID 컬럼으로 서버측 필터.
  //   setSearchCondition 이 division 을 바꾼 뒤 커밋 후 호출한다(stale get() 방지).
  fetchStaticColumns: (divisionId?: string) => Promise<void>;
}

const initSearchCondition: SearchCondition = {
  divisionId: useSessionStore.getState().session.div ?? '40',
  operationIds: [],
  model: '',
  nickName: '',
  checkFcst: false,
  checkProduction: false,
  checkActive: false,
  checkBom: false,
};

const initState: State = {
  initialized: false,
  filters: {},
  searchCondition: initSearchCondition,
  openSearchArea: true,
  staticColumns: {
    [RESPONSE_SET.MAIN]: [],
  },
  isEditMode: false,
} as const;

export const useGroupCodeManagementStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    // division 이 바뀌면 filters(조회결과 캐시키)와 선택 operation 을 함께 초기화한다 —
    //   division 과 operation 이 어긋난 중간 상태로 조회 payload 가 조립되지 않게.
    setSearchCondition: p => {
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
        if (p.divisionId !== undefined) {
          state.searchCondition.operationIds = [];
          state.filters = {};
        }
      });
      // 주의: 컬럼 재조회는 set() 커밋 뒤에 division 을 인자로 넘겨서 호출한다.
      //   producer 안에서 부르면 fetchStaticColumns 의 get()이 아직 이전 division 을 돌려줘서
      //   (immer 커밋 전) 컬럼 메타가 한 스텝 밀린다 — SalesSite/SalesFuturePrice 와 동일 idiom.
      if (p.divisionId !== undefined) void get().fetchStaticColumns(p.divisionId);
    },
    // FindButton → 조회조건을 GET SP payload(camelCase, PROC_M COL_NM 매핑)로 변환해 filters 에 커밋.
    //   BE makeProcedure(BaseService.java)가 이 key 를 SP IN 파라미터(P_DIVISION_ID 등)로 매핑한다.
    //   누락 key 는 NULL 전달 → 권한/조건 불일치로 0행. Y/N 체크는 문자열 'Y'/'N' 으로 변환.
    //   Operation 은 다중선택 — AS-IS 와 동일하게 콤마 결합해 SP 에 넘긴다(미선택 시 'ALL').
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        const yn = (b: boolean): string => (b ? 'Y' : 'N');
        const payload: GroupCodeSearchFilter = {
          divisionId: c.divisionId,
          operationId: c.operationIds.length === 0 ? 'ALL' : c.operationIds.join(','),
          modelId: c.model,
          nickName: c.nickName,
          checkFcst: yn(c.checkFcst),
          checkProduction: yn(c.checkProduction),
          checkActive: yn(c.checkActive),
          checkBom: yn(c.checkBom),
        };
        state.filters = { [SHEETS.MAIN]: payload as never };
      });
    },
    // mount 시 sessionStorage 의 이전 filters cache 무효화 — incomplete payload 재사용 회피.
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),
    setEditMode: edit =>
      set(state => {
        state.isEditMode = edit ?? !state.isEditMode;
      }),
    // division 인자는 setSearchCondition 이 넘긴다(스토어 커밋 전 stale get() 방지). 미지정이면 현재 조건 기준.
    //   admin SCM_MST_SHEET_COLUMNS 의 관리자 변경을 즉시 반영(mount + Search 마다 호출).
    fetchStaticColumns: async divisionId => {
      const division = divisionId ?? get().searchCondition.divisionId;
      try {
        // sheetNm 은 division 별로 다르다(base / -40 / -81계열 / -82) — resolveSheetNm 산식.
        //   divisionId 도 함께 넘겨 SP 가 DIVISION_ID 컬럼으로 서버측 필터하도록 한다.
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: resolveSheetNm(division), divisionId: division }
        );
        const next = res.data.result ?? [];
        // admin 메타에 해당 division 토큰이 없어 0건이면 division 없이 재조회(전체 컬럼 fallback).
        const applied = next.length ? next : (await fetchAllColumns(division)) ?? next;
        set(state => {
          // 내용 동일(관리자 변경 없음) 시 set 생략 — Grid staticColumns 참조 churn 방지.
          if (JSON.stringify(state.staticColumns[RESPONSE_SET.MAIN]) !== JSON.stringify(applied)) {
            state.staticColumns[RESPONSE_SET.MAIN] = applied;
          }
        });
      } catch {
        // BE 메타 미등록/조회 실패 시 화면이 안 깨지도록 silent fallback (console 금지 룰).
      }
      // 진입 시 1회 저장 조회조건 복원.
      if (get().initialized) return;
      try {
        const param = await apiClient.get<{ paramNm: keyof SearchCondition; paramCtn: string }[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        const rows = param.data.result ?? [];
        if (rows.length > 0) {
          // 저장은 값을 문자열로 coerce 하므로 필드 타입별 역파싱: 배열키=콤마 split / 불리언키='true' 비교.
          const ARRAY_KEYS = new Set<string>(['operationIds']);
          const BOOL_KEYS = new Set<string>([
            'checkFcst',
            'checkProduction',
            'checkActive',
            'checkBom',
          ]);
          const patch: Record<string, unknown> = {};
          for (const { paramNm, paramCtn } of rows) {
            const val = paramCtn ?? '';
            if (ARRAY_KEYS.has(paramNm)) patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
            else if (BOOL_KEYS.has(paramNm)) patch[paramNm] = val === 'true';
            else patch[paramNm] = val;
          }
          set(state => {
            state.searchCondition = {
              ...get().searchCondition,
              ...(patch as Partial<SearchCondition>),
            };
          });
        }
      } catch {
        // 저장조건 미존재/조회 실패 시 기본값 유지 (console 금지 룰).
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'group-code-management'
);

// division 토큰 매칭이 0건일 때 division 필터 없이 전체 컬럼을 다시 받는 fallback.
const fetchAllColumns = async (division: string): Promise<RawFlexGridColumnConfig[] | undefined> => {
  try {
    const res = await apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
      sheetNm: resolveSheetNm(division),
    });
    return res.data.result ?? undefined;
  } catch {
    return undefined;
  }
};
