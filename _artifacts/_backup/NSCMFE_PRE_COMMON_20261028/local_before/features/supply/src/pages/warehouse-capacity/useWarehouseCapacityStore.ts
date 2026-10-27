import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './warehouse-capacity.constants';
import type { SearchCondition } from './warehouse-capacity.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

interface StaticColumnsBySheet {
  main: RawFlexGridColumnConfig[];
  itemMapping: RawFlexGridColumnConfig[];
}

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch(31행 등록됨,
  //   design 03 §0/§1). 미등록/실패 시 빈 배열.
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
  restoreSearchCondition: () => Promise<void>;
}

const initSearch: SearchCondition = {
  // 기본 사업부 = 세션 division (supply 표준, outsourcing-capacity/formation 동일 관례).
  divisionId: useSessionStore.getState().session.div ?? '',
  planGroupIds: [],
  siteIds: [],
  stages: [],
  warehouses: [],
  validYn: 'ALL',
  fromYyyymmdd: '',
  toYyyymmdd: '',
  itemId: '',
};

const emptyStaticColumns: StaticColumnsBySheet = {
  main: [],
  itemMapping: [],
};

const initState: State = {
  initialized: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  staticColumns: emptyStaticColumns,
};

// 다중 선택 배열 -> SP 파라미터 문자열. 콤마 결합(design 02 §7 cascade 필터 재현, SCP0129/0130 선례).
//   빈 선택 = 'ALL'(서버 필터 미적용) — AS-IS 필터방식/재조회방식 확정 전까지의 보수적 기본값.
const joinOrAll = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join(','));
const orAll = (v: string): string => (v && v.trim() ? v.trim() : 'ALL');

// F6(조회조건 저장, SubTitle searchParam={sc})로 서버에 저장한 조회조건을 init 기준으로 복원한다.
//   GridAction.personalizeCondition 이 배열을 콤마로 접어 저장하므로 다중 조회조건(planGroup/site/
//   stage/warehouse)은 콤마로 분해하고, 기간(from/to)은 EXCLUDED_DATE_PARAM 로 저장에서 제외되므로
//   init 기본값('')을 유지한다. 저장되지 않은 키는 init 을 그대로 둔다(constraint-mgmt 선례와 동형).
const RESTORE_MULTI_KEYS = ['planGroupIds', 'siteIds', 'stages', 'warehouses'] as const;
const buildSearchConditionFromSaved = (
  saved: readonly { paramNm: string; paramCtn: string }[],
  init: SearchCondition
): SearchCondition => {
  const map = new Map(saved.map(row => [row.paramNm, row.paramCtn]));
  const next: SearchCondition = { ...init };
  const divisionId = map.get('divisionId');
  if (divisionId !== undefined) next.divisionId = divisionId;
  const validYn = map.get('validYn');
  if (validYn !== undefined) next.validYn = validYn;
  const itemId = map.get('itemId');
  if (itemId !== undefined) next.itemId = itemId;
  RESTORE_MULTI_KEYS.forEach(key => {
    const value = map.get(key);
    if (value !== undefined) next[key] = value.split(',').filter(v => v !== '');
  });
  return next;
};

export const useWarehouseCapacityStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division·기간(from/to)을 제외한 검색조건을 전부
    //   초기화하고 그리드도 초기화(filters clear)한다(apply-division-reset, SCP0025 정본 패턴).
    //   유지: divisionId(새 값) + fromYyyymmdd/toYyyymmdd(기간). 초기화: planGroup/site/stage/
    //   warehouse/valid/itemId → initSearch 기본값. 편집중(dirty) 확인 가드(MSG00704)는 Form 의
    //   onChange 가 confirmIfDirtyKey 로 처리한다(commit 51d4e9fa 패턴). filters={} 로 queryKey 가
    //   바뀌어 재조회(Search) 전까지 그리드가 빈 상태가 되고 EditTracker 도 빈 행으로 재바인딩된다.
    setDivision: divisionId =>
      set(state => {
        const cur = get().searchCondition;
        state.searchCondition = {
          ...initSearch,
          divisionId,
          fromYyyymmdd: cur.fromYyyymmdd,
          toYyyymmdd: cur.toYyyymmdd,
        };
        state.filters = {};
      }),
    // GET 파라미터(procedures.d.ts SCP0133.main.request, design 03 §4.2 9파라미터 순서 그대로).
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: orAll(c.divisionId),
            opmzPlanGrId: joinOrAll(c.planGroupIds),
            siteId: joinOrAll(c.siteIds),
            stage: joinOrAll(c.stages),
            whNm: joinOrAll(c.warehouses),
            fromYyyymmdd: c.fromYyyymmdd,
            toYyyymmdd: c.toYyyymmdd,
            itemId: orAll(c.itemId),
            validYn: orAll(c.validYn),
          },
        };
      });
    },
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    // F6 로 저장한 조회조건을 진입 시 1회 되읽어 폼에 복원한다. 스토어
    //   (createPersistedStoreWithTab)는 새로고침 때 영속화하지 않으므로 이 GET 복원이 없으면
    //   F6 저장이 성공해도 재진입/새로고침 후 init 기본값만 뜬다. 저장분이 없으면 기본값을 그대로
    //   둔다. 자동조회는 하지 않는다 — filters 는 비운 채라 사용자가 Search 를 눌러야 조회된다
    //   (AS-IS FindWhenOpen 미설정과 동일, constraint-mgmt 선례).
    restoreSearchCondition: async () => {
      const param = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
        `/admin/menu/${MENU_ID}/search-conditions`
      );
      if (!param.data.result?.length) return;
      set(state => {
        state.searchCondition = buildSearchConditionFromSaved(param.data.result, initSearch);
      });
    },
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),
    // admin SCM_MST_SHEET_COLUMNS 동적 fetch — 2시트(Warehouse Capacity/Warehouse Item Mapping,
    //   design 03 §0). 미등록/실패 시 빈 배열 유지.
    fetchStaticColumns: async () => {
      try {
        const [main, itemMapping] = await Promise.all([
          apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
            sheetNm: ADMIN_SHEET_NAME.MAIN,
          }),
          apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
            sheetNm: ADMIN_SHEET_NAME.ITEM_MAPPING,
          }),
        ]);
        set(state => {
          state.staticColumns = {
            main: main.data.result ?? [],
            itemMapping: itemMapping.data.result ?? [],
          };
        });
      } catch {
        // 미등록/실패 = 빈 배열 유지(console 금지 룰)
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'warehouse-capacity-store'
);
