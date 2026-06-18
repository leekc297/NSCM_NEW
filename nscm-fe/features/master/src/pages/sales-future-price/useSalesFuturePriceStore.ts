import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { BUCKET_TYPE, DIVISION, MENU_ID, SHEETS } from './sales-future-price.constants';
import type { SearchCondition } from './sales-future-price.types';

// SP filter 로 변환된 payload — useTabProcQuery enabled 가드
type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

// SCM_MST_SHEET_MEASURE 동적 fetch row 형태
export interface MeasureMeta {
  COLUMN_NAME: string;
  COLUMN_LABEL_NAME?: string;
  SORT_ORDER_NO?: number;
  VALID_YN?: string;
}

type StaticColumnsBySheet = { [key in SHEETS]: RawFlexGridColumnConfig[] };
type StaticMeasuresBySheet = { [key in SHEETS]: MeasureMeta[] };

interface State {
  initialized: boolean;
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  openSearchArea: boolean;
  activeTab: 'main' | 'pivot';
  staticColumns: StaticColumnsBySheet;
  staticMeasures: StaticMeasuresBySheet;
  // ⭐ grid-column-setting-popup-pattern.md (#58) — ColumnSettingModal OK 결과 저장.
  //   빈 array = default (모든 base 컬럼 visible). 값 있음 = list 에 포함된 컬럼만 표시.
  visibleBaseColumns: string[];
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setActiveTab: (tab: 'main' | 'pivot') => void;
  fetchStaticColumns: () => Promise<void>;
  fetchStaticMeasures: () => Promise<void>;
  setVisibleBaseColumns: (names: string[]) => void;
}

const yyyymmdd = (d: Date) => d.toISOString().slice(0, 10).replace(/-/g, '');
const today = yyyymmdd(new Date());
const ninetyDaysAhead = yyyymmdd(new Date(Date.now() + 90 * 24 * 3600 * 1000));

const initSearch: SearchCondition = {
  divisionId: DIVISION.MOBILITY,
  deptIds: [],
  endCustomers: [],
  scmSiteIds: [],
  plantSiteIds: [],
  itemIds: [],
  nickName: '',
  projectCodes: [],
  startYyyymmdd: today,
  endYyyymmdd: ninetyDaysAhead,
  bizTypes: [],
  owners: [],
  bucketType: BUCKET_TYPE.WEEKLY,
  searchOverRange: false,
  excludeNoPrice: false,
  versionId: 'CURRENT',
};

const emptyCols: StaticColumnsBySheet = Object.values(SHEETS).reduce((acc, k) => {
  (acc as Record<string, RawFlexGridColumnConfig[]>)[k] = [];
  return acc;
}, {} as StaticColumnsBySheet);

const emptyMeasures: StaticMeasuresBySheet = Object.values(SHEETS).reduce((acc, k) => {
  (acc as Record<string, MeasureMeta[]>)[k] = [];
  return acc;
}, {} as StaticMeasuresBySheet);

const initState: State = {
  initialized: false,
  filters: {},
  searchCondition: initSearch,
  openSearchArea: true,
  activeTab: 'main',
  staticColumns: emptyCols,
  staticMeasures: emptyMeasures,
  visibleBaseColumns: [],
};

export const useSalesFuturePriceStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p => set(state => {
      state.searchCondition = { ...get().searchCondition, ...p };
    }),
    setFilter: () => set(state => {
      const c = state.searchCondition;
      const j = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join('^'));
      state.filters = {
        [SHEETS.MAIN]: {
          divisionId:   c.divisionId,
          deptId:       j(c.deptIds),
          endCustomer:  j(c.endCustomers),
          scmSiteId:    j(c.scmSiteIds),
          plantSiteId:  j(c.plantSiteIds),
          projectCode:  j(c.projectCodes),
          itemId:       j(c.itemIds),
          fromYyyymmdd: c.startYyyymmdd,
          toYyyymmdd:   c.endYyyymmdd,
          biztype:      j(c.bizTypes),
          owner:        j(c.owners),
          overRange:    c.searchOverRange ? 'Y' : 'N',
          invalidExec:  c.excludeNoPrice ? 'Y' : 'N',
          versionType:  c.versionId || 'CURRENT',
          bucketType:   c.bucketType,
        } as never,
      };
    }),
    setOpenSearchArea: open => set(state => {
      state.openSearchArea = open ?? !state.openSearchArea;
    }),
    setActiveTab: tab => set(state => { state.activeTab = tab; }),

    // ⭐ master hook §2.3 "UI 생성의 동적 속성관리" — Column 동적 fetch
    //   SCM_MST_SHEET_COLUMNS 의 admin 변경 즉시 반영 (mount + Search 시 호출)
    fetchStaticColumns: async () => {
      try {
        const sheets: SHEETS[] = [SHEETS.MAIN];
        const responses = await Promise.all(
          sheets.map(sheetNm =>
            apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, { sheetNm }),
          ),
        );
        set(state => {
          sheets.forEach((s, i) => { state.staticColumns[s] = responses[i].data.result ?? []; });
        });
      } catch (e) {
        // BE 메타 미등록 시 화면이 안 깨지도록 fallback — 기존 MAIN_COLUMNS 하드코딩 유지
        // (master hook §8.3 anti-pattern 5.4 회피)
        console.warn('[DMF0020] fetchStaticColumns failed', e);
      }
    },

    // ⭐ master hook §5 — Measure 동적 fetch (PIVOT 화면 의무)
    fetchStaticMeasures: async () => {
      try {
        const sheets: SHEETS[] = [SHEETS.MAIN];
        const responses = await Promise.all(
          sheets.map(sheetNm =>
            apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, { sheetNm }),
          ),
        );
        set(state => {
          sheets.forEach((s, i) => { state.staticMeasures[s] = responses[i].data.result ?? []; });
        });
      } catch (e) {
        console.warn('[DMF0020] fetchStaticMeasures failed', e);
      }
    },
    // ⭐ grid-column-setting-popup-pattern.md (#58) §1.1 — ColumnSettingModal OK 결과 저장.
    setVisibleBaseColumns: names =>
      set(state => {
        state.visibleBaseColumns = names;
      }),
  }),
  'sales-future-price',
);
