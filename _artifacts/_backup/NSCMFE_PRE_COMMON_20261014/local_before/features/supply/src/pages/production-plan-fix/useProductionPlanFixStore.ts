import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, BUCKET_TYPE, MEASURE_SHEET_NAME, MENU_ID, SHEETS } from './production-plan-fix.constants';
import type { SearchCondition } from './production-plan-fix.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

type StaticColumnsBySheet = {
  [SHEETS.MAIN]: RawFlexGridColumnConfig[];
};

// Measure 메타(admin SCM_MST_SHEET_MEASURE) — pivot measure 축 정의(Prod Plan / Fix Reason).
export interface StaticMeasure {
  measureId: string;
  measureNm: string;
  [key: string]: string | number | boolean | null;
}

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // admin SCM_MST_SHEET_COLUMNS('Model') 동적 fetch (ui-dynamic-property-management §2.3). 12행 등록 확인.
  staticColumns: StaticColumnsBySheet;
  // admin SCM_MST_SHEET_MEASURE('PRODUCTION_PLAN_FIX') 동적 fetch — measure 축(2행).
  staticMeasures: StaticMeasure[];
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setDivision: (divisionId: string) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchStaticMeasures: () => Promise<void>;
}

const initSearch: SearchCondition = {
  // 기본 division = 세션 division(권한 division 첫 행 근사). Form 이 콤보 옵션과 대조해 교정.
  divisionId: useSessionStore.getState().session.div ?? '',
  operationGroupId: '',
  plantSiteIds: [],
  lineIds: [],
  electrodeTypes: [],
  bucket: BUCKET_TYPE.DAILY, // design 03 §3-보강 편집 band=D_ → 진입 시 D_ 노출·편집 가능
  fromYyyymmdd: '',
  toYyyymmdd: '',
  itemId: '',
  chkSum: false,
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
  staticMeasures: [],
};

// 다중 선택 배열 → SP 파라미터 문자열. 빈 값은 '' 로 전송해 GET SP 무필터 분기(:Bx1 IS NULL)를 태운다.
//   주의: 'ALL' 센티널 금지 — GET SP body 는 `:Bx1 IS NULL OR col IN STRING_SPLIT(:Bx2)` 뿐 `='ALL'` 분기가
//   없어, 'ALL' 을 보내면 STRING_SPLIT('ALL') 이 원소 1건('ALL')만 반환해 실 코드와 매칭 0 → 기본 조회 0행
//   (react-gap-audit iter-3 NF1, div82 baseline 9720행 → 'ALL' 0행 실측). Oracle 은 '' IS NULL=TRUE 라
//   빈 문자열이 곧 무필터(memory combo-optional-param-omit-safe-empty-null · scp0020-all-sentinel 실사고 동형).
const joinOrEmpty = (arr: string[]): string => arr.join(',');
const orEmpty = (v: string): string => (v && v.trim() ? v.trim() : '');
const str = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

export const useProductionPlanFixStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // division 변경 = 하위 cascade 초기화(design 02 §3 E1) + 그리드 clear(hook #5). opGroup/site/line/electrode 리셋.
    setDivision: divisionId =>
      set(state => {
        state.searchCondition = {
          ...get().searchCondition,
          divisionId,
          operationGroupId: '',
          plantSiteIds: [],
          lineIds: [],
          electrodeTypes: [],
        };
        state.filters = {}; // 그리드 데이터 clear (design 02 §3 — division 변경=그리드 초기화)
      }),
    // 메인 GET 9-param 매핑 (design 02 §5.3 / 03 §4.2 — SP IN 순번 주석). division/operationGroup 단일값.
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: orEmpty(c.divisionId), // 1 P_DIVISION_ID (단일)
            operationGroup: orEmpty(c.operationGroupId), // 2 P_OPERATION_GROUP (단일)
            scmSiteId: joinOrEmpty(c.plantSiteIds), // 3 P_SCM_SITE_ID (다중 콤마, 빈값=무필터)
            lineId: joinOrEmpty(c.lineIds.filter(v => v !== '-')), // 4 P_LINE_ID ('-'→제외, 다중, 빈값=무필터)
            itemId: str(c.itemId), // 5 P_ITEM_ID (빈값=무필터)
            fromYyyymmdd: c.fromYyyymmdd.replace(/-/g, ''), // 6 P_FROM_YYYYMMDD
            toYyyymmdd: c.toYyyymmdd.replace(/-/g, ''), // 7 P_TO_YYYYMMDD
            electrodeType: joinOrEmpty(c.electrodeTypes), // 8 P_ELECTRODE_TYPE (다중 콤마, 빈값=무필터)
            debugMode: 'F', // 9 P_DEBUG_MODE
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
    // admin SCM_MST_SHEET_COLUMNS('Model') 동적 fetch — 미등록/실패 시 빈 배열(그리드 constants fallback).
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? SHEETS.MAIN,
        });
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
    // admin SCM_MST_SHEET_MEASURE('PRODUCTION_PLAN_FIX') 동적 fetch — measure 축(Prod Plan/Fix Reason).
    fetchStaticMeasures: async () => {
      try {
        const res = await apiClient.post<StaticMeasure[]>(`/admin/menu/${MENU_ID}/measure`, {
          sheetNm: MEASURE_SHEET_NAME,
        });
        const next = res.data.result ?? [];
        set(state => {
          if (JSON.stringify(state.staticMeasures) !== JSON.stringify(next)) {
            state.staticMeasures = next;
          }
        });
      } catch {
        // 미등록/실패 = 그리드 measure 행 자체는 GET SP 반환(MEASURE 컬럼)으로 렌더 (console 금지 룰)
      }
    },
  }),
  'production-plan-fix-store'
);
