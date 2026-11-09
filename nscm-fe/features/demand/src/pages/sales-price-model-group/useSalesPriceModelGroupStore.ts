import type { MeasureMeta } from 'features/master/src/components';

import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { applyGridLayout, fetchGridLayout, type GridLayoutRow } from '@shared/components';
import { createPersistedStoreWithTab } from '@shared/stores';

import {
  BUCKET_TYPE,
  MENU_ID,
  SHEETS,
  TITLESET_COLUMN_TYPE,
} from './sales-price-model-group.constants';
import type { SearchParams } from './sales-price-model-group.types';
import { defaultPeriod } from './utils/sales-price-model-group.util';
import { joinCodes } from './utils/sales-price-model-group.util';

type FiltersBySheet = { [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN> };
type ColumnSheets = SHEETS.MAIN | SHEETS.PRICE_BATCH;
type StaticColumnsBySheet = Record<ColumnSheets, RawFlexGridColumnConfig[]>;

interface State {
  initialized: boolean;
  searchParams: SearchParams;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // 화면에 쓰는 컬럼(개인화 적용) / admin 메타 원본(Column Setting Default 기준)
  staticColumns: StaticColumnsBySheet;
  originalStaticColumns: StaticColumnsBySheet;
  staticMeasures: { [SHEETS.MAIN]: MeasureMeta[] };
  // 저장된 컬럼 개인화 — null = 아직 안 읽음/없음(admin 메타 그대로)
  gridLayout: GridLayoutRow[] | null;
}

interface Action {
  reset: () => void;
  setSearchParams: (params: Partial<SearchParams>) => void;
  setFilters: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: (divisionId?: string) => Promise<void>;
  fetchBatchColumns: (divisionId?: string) => Promise<void>;
  fetchStaticMeasures: (divisionId?: string) => Promise<void>;
  fetchGridLayout: (divisionId?: string) => Promise<void>;
  restoreSearchConditions: () => Promise<void>;
}

const makeInitSearchParams = (): SearchParams => {
  const { from, to } = defaultPeriod();
  return {
    divisionId: '',
    deptIds: [],
    endCustomers: [],
    scmSiteIds: [],
    projectCodes: [],
    mdlGrs: [],
    fromYyyymmdd: from,
    toYyyymmdd: to,
    bucketType: BUCKET_TYPE.WEEKLY,
  };
};

const makeInitState = (): State => ({
  initialized: false,
  searchParams: makeInitSearchParams(),
  filters: {},
  openSearchArea: true,
  staticColumns: { [SHEETS.MAIN]: [], [SHEETS.PRICE_BATCH]: [] },
  originalStaticColumns: { [SHEETS.MAIN]: [], [SHEETS.PRICE_BATCH]: [] },
  staticMeasures: { [SHEETS.MAIN]: [] },
  gridLayout: null,
});

const fetchColumns = async (sheetNm: ColumnSheets, divisionId: string) => {
  const res = await apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
    sheetNm,
    divisionId,
  });
  return res.data.result ?? [];
};

// 저장 조회조건 복원 — 배열 칸은 쉼표로 저장된다(SubTitle F6). 기간은 저장 대상이 아니다(EXCLUDED_DATE_PARAM).
//   Div 는 복원하지 않는다 — 82 고정이고, 화면의 사업부 선택 effect 가 setSearchParams 로 넣어야 컬럼 메타 조회가 걸린다.
const ARRAY_KEYS = new Set(['deptIds', 'endCustomers', 'scmSiteIds', 'projectCodes', 'mdlGrs']);
const SCALAR_KEYS = new Set(['bucketType']);

export const useSalesPriceModelGroupStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...makeInitState(),
    reset: () => set(makeInitState()),

    setSearchParams: params => {
      const divisionChanged =
        params.divisionId !== undefined && params.divisionId !== get().searchParams.divisionId;
      set(state => {
        state.searchParams = { ...get().searchParams, ...params };
      });
      // 컬럼 메타는 division 으로 서버가 거른다(COL-07). set 커밋 뒤 새 값을 인자로 넘긴다(COL-04).
      if (divisionChanged && params.divisionId) {
        void get().fetchGridLayout(params.divisionId);
        void get().fetchStaticColumns(params.divisionId);
        void get().fetchBatchColumns(params.divisionId);
        void get().fetchStaticMeasures(params.divisionId);
      }
    },

    // 조회 버튼 — 조회조건을 프로시저 인자로 옮긴다. 인자 이름 = SCM_ADM_PROC_M COL_NM (STR-12).
    //   Bucket 은 프로시저 인자가 아니다(조회 결과에 주 · 월 칸이 함께 온다) — 화면 표시만 바꾼다.
    setFilters: () =>
      set(state => {
        const p = state.searchParams;
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: p.divisionId,
            deptId: joinCodes(p.deptIds, '^'),
            endCustomer: joinCodes(p.endCustomers, '^'),
            scmSiteId: joinCodes(p.scmSiteIds, '^'),
            projectCode: joinCodes(p.projectCodes, '^'),
            mdlGr: joinCodes(p.mdlGrs, '^'),
            fromYyyymmdd: p.fromYyyymmdd,
            toYyyymmdd: p.toYyyymmdd,
          },
        };
      }),

    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),

    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),

    // 컬럼 메타 — 응답이 같으면 set 하지 않는다(COL-04, 참조가 바뀌면 그리드 컬럼이 다시 만들어진다).
    fetchStaticColumns: async divisionId => {
      const division = divisionId ?? get().searchParams.divisionId;
      if (!division) return;
      try {
        const next = await fetchColumns(SHEETS.MAIN, division);
        const applied = applyGridLayout(next, get().gridLayout);
        set(state => {
          if (JSON.stringify(state.staticColumns[SHEETS.MAIN]) !== JSON.stringify(applied)) {
            state.staticColumns[SHEETS.MAIN] = applied;
          }
          if (JSON.stringify(state.originalStaticColumns[SHEETS.MAIN]) !== JSON.stringify(next)) {
            state.originalStaticColumns[SHEETS.MAIN] = next;
          }
        });
      } catch (e) {
        console.error('[DMF0083] column meta', e);
      }
    },

    fetchBatchColumns: async divisionId => {
      const division = divisionId ?? get().searchParams.divisionId;
      if (!division) return;
      try {
        const next = await fetchColumns(SHEETS.PRICE_BATCH, division);
        set(state => {
          if (JSON.stringify(state.staticColumns[SHEETS.PRICE_BATCH]) !== JSON.stringify(next)) {
            state.staticColumns[SHEETS.PRICE_BATCH] = next;
          }
        });
      } catch (e) {
        console.error('[DMF0083] priceBatch column meta', e);
      }
    },

    // Measure 메타 (SCM_MST_SHEET_MEASURE DMF0083/main = KRW · USD · LOC) — 신규 행 Measure 목록 원천.
    //   divisionId 는 보내지 않는다: PR_GET_SHEET_MEASURE_LIST 는 사업부를 받으면 DIVISION_ID 가 NULL 인 행을 빼는데,
    //   DMF0083 Measure 3행은 모두 NULL 이다(2026-11-06 실측 — 사업부를 보내면 0건, 빼면 KRW · USD · LOC).
    //   원천 DMF0020 도 시트명만 보낸다. 인자는 호출 형태를 다른 메타 조회와 맞추려고 받기만 한다.
    fetchStaticMeasures: async _divisionId => {
      try {
        const res = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
          sheetNm: SHEETS.MAIN,
        });
        const next = res.data.result ?? [];
        set(state => {
          if (JSON.stringify(state.staticMeasures[SHEETS.MAIN]) !== JSON.stringify(next)) {
            state.staticMeasures[SHEETS.MAIN] = next;
          }
        });
      } catch (e) {
        console.error('[DMF0083] measure meta', e);
      }
    },

    // 컬럼 개인화 (SCM_MST_TITLESET_USER, SHEET_PRSL_YN DMF0083/main 등록). 읽은 뒤 현재 메타에 다시 적용한다.
    fetchGridLayout: async divisionId => {
      const division = divisionId ?? get().searchParams.divisionId;
      if (!division) return;
      const layout = await fetchGridLayout({
        menuId: MENU_ID,
        sheetName: SHEETS.MAIN,
        columnType: TITLESET_COLUMN_TYPE,
        divisionId: division,
      });
      set(state => {
        state.gridLayout = layout;
        const original = state.originalStaticColumns[SHEETS.MAIN];
        if (original.length > 0) state.staticColumns[SHEETS.MAIN] = applyGridLayout(original, layout);
      });
    },

    // F6 로 저장한 조회조건을 진입 때 한 번 복원한다(SRCH-12).
    restoreSearchConditions: async () => {
      if (get().initialized) return;
      set(state => {
        state.initialized = true;
      });
      try {
        const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        const patch: Partial<Record<keyof SearchParams, string | string[]>> = {};
        for (const { paramNm, paramCtn } of res.data.result ?? []) {
          const value = paramCtn ?? '';
          if (ARRAY_KEYS.has(paramNm)) {
            patch[paramNm as keyof SearchParams] = value ? value.split(',').filter(Boolean) : [];
          } else if (SCALAR_KEYS.has(paramNm)) {
            patch[paramNm as keyof SearchParams] = value;
          }
        }
        if (patch.bucketType !== BUCKET_TYPE.MONTHLY) delete patch.bucketType;
        set(state => {
          state.searchParams = { ...get().searchParams, ...(patch as Partial<SearchParams>) };
        });
      } catch (e) {
        console.error('[DMF0083] search conditions', e);
      }
    },
  }),
  'sales-price-model-group'
);
