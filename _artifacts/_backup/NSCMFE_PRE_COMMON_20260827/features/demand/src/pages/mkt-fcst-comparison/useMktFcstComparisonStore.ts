import type { MeasureMeta } from 'features/master/src/components';

import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import _ from '@foundation/lodash';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { BUCKET_TYPE, MENU_ID, SHEETS } from './mkt-fcst-comparison.constants';
import type { SearchParams } from './mkt-fcst-comparison.types';

interface Filters {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.SPREAD_TITLE]?: ProcRequest<MENU_ID, SHEETS.SPREAD_TITLE>;
}

interface MktFcstComparisonState {
  searchParams: SearchParams;
  filters: Filters;
  isOpenSearchArea: boolean;
  staticColumns: RawFlexGridColumnConfig[];
  staticMeasures: MeasureMeta[];
}

interface MktFcstComparisonAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParams>) => void;
  setFilters: (input: { userId: string }) => boolean;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: (input: { divisionId: string }) => Promise<void>;
  fetchStaticMeasures: (input: { divisionId: string }) => Promise<void>;
  /** ColumnLayoutModal onSave — 표시/순서/폭/색을 staticColumns 에 즉시 반영 (forecast-price 선례). */
  applyColumnLayout: (
    settings: { colNm: string; visible: boolean; width?: number; cellColor?: string; textColor?: string; order?: number }[]
  ) => void;
  /** UC-03 / hook #132 §2-2 — 설정 저장 시 기존 조회 데이터 Reset (그리드 비움, Search 로 재조회). */
  clearData: () => void;
}

/** AS-IS PR_GET_DAY_RANGE(p_month=6) — 당월 1일 ~ +6개월 말일 (.cs GetDayRange L1573~1587) */
const defaultPeriod = () => ({
  startYyyymmdd: dayjs().startOf('month').format('YYYYMMDD'),
  endYyyymmdd: dayjs().add(6, 'month').endOf('month').format('YYYYMMDD'),
});

const initSearchParams: SearchParams = {
  divisionId: '',
  deptIds: [],
  endCustomers: [],
  bizTypes: [],
  salesSiteIds: [],
  plantSiteIds: [],
  projectCodes: [],
  itemIds: [],
  itemTypes: [],
  owners: [],
  version: '', // 기본 = Division 결정 후 최근 MF_W 2개 자동 세팅 (AS-IS GetDefaultVersion — Form 담당)
  ...defaultPeriod(),
  bucket: BUCKET_TYPE.MONTHLY, // AS-IS DefineProperty L370
  qty: '1',
  isSumChecked: false, // AS-IS chkSum.Checked=false (L323)
  isDiffOnly: false,
};

const initState: MktFcstComparisonState = {
  searchParams: initSearchParams,
  filters: {},
  isOpenSearchArea: true,
  staticColumns: [],
  staticMeasures: [],
};

/** 멀티 필터 → SP 규약: 빈 배열 = 'ALL' (빈 토큰 전멸 계보 — DMF0035 orAll 동일) */
const orAll = (arr: string[]): string => (arr.length > 0 ? arr.join(',') : 'ALL');

export const useMktFcstComparisonStore = createPersistedStoreWithTab<
  MktFcstComparisonState & MktFcstComparisonAction
>(
  set => ({
    ...initState,
    reset: () =>
      set(state => {
        state.searchParams = { ...initSearchParams, ...defaultPeriod() };
        state.filters = {};
        state.isOpenSearchArea = true;
        state.staticColumns = [];
      }),
    setSearchParams: searchParams =>
      set(state => {
        state.searchParams = { ...state.searchParams, ...searchParams };
      }),
    setFilters: ({ userId }) => {
      let changed = false;
      set(state => {
        const p = state.searchParams;
        const newFilters: Filters = {
          // PKG_DMF0040.P_DMF0040_GET_MKT_FCST_COMPARISON — PROC_M positional 18 (seed_meta.py 실측)
          [SHEETS.MAIN]: {
            divisionId: p.divisionId,
            scmSiteId: orAll(p.salesSiteIds),
            plantSiteId: orAll(p.plantSiteIds),
            teamId: orAll(p.deptIds),
            customer: orAll(p.endCustomers),
            bizType: orAll(p.bizTypes),
            projectCode: p.projectCodes.join(','),
            itemId: p.itemIds.join(','),
            fromYyyymmdd: p.startYyyymmdd,
            toYyyymmdd: p.endYyyymmdd,
            sesUserId: userId,
            versionNo: p.version,
            itemType: orAll(p.itemTypes),
            owner: p.owners.join(','),
            // AS-IS p_diff_only = cboDiff.Checked bool 직렬화 ('True'/'False' — .cs L735 파리티)
            diffOnly: p.isDiffOnly ? 'True' : 'False',
            bucket: p.bucket,
            userId,
            mnuId: MENU_ID,
          },
          [SHEETS.SPREAD_TITLE]: {
            startYyyymmdd: p.startYyyymmdd,
            endYyyymmdd: p.endYyyymmdd,
            sesUserId: userId,
            divisionId: p.divisionId,
            bucket: p.bucket,
          },
        };
        if (!_.isEqual(newFilters, state.filters)) {
          state.filters = newFilters;
          changed = true;
        }
      });
      return changed;
    },
    setOpenSearchArea: open =>
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      }),
    // ⭐ 정적 컬럼 = 서버 직접 비교 (#113 — divisionId 전송·division 변경 시 재fetch. 정본 DMF0021/DMF0035)
    fetchStaticColumns: async ({ divisionId }) => {
      const result = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        { sheetNm: 'Mkt Fcst Waterfall', divisionId }
      );
      set(state => {
        state.staticColumns = result.data.result ?? [];
      });
    },
    // ⭐ Measure 목록 (SCM_MST_SHEET_MEASURE PROGRAM_ID='DMF0040' — seed_meta.py 49행 시딩) — 서버 직접 비교 (#113)
    fetchStaticMeasures: async ({ divisionId }) => {
      try {
        const result = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
          sheetNm: 'Mkt Fcst Waterfall',
          divisionId,
        });
        set(state => {
          state.staticMeasures = result.data.result ?? [];
        });
      } catch {
        /* 미적재 시 빈 배열 유지 — 모달 fallback */
      }
    },
    applyColumnLayout: settings =>
      set(state => {
        const bySetting = new Map(settings.map(s => [s.colNm, s]));
        const next = state.staticColumns.map(c => {
          const s = bySetting.get(c.colNm);
          if (!s) return c;
          return {
            ...c,
            visible: s.visible,
            display: s.visible,
            ...(s.width ? { colWth: s.width } : {}),
            ...(s.cellColor !== undefined ? { cellColor: s.cellColor } : {}),
            ...(s.textColor !== undefined ? { textColor: s.textColor } : {}),
          };
        });
        const order = new Map(settings.map((s, i) => [s.colNm, s.order ?? i]));
        next.sort((a, b) => (order.get(a.colNm) ?? 9999) - (order.get(b.colNm) ?? 9999));
        state.staticColumns = next;
      }),
    clearData: () =>
      set(state => {
        state.filters = {};
      }),
  }),
  'mkt-fcst-comparison'
);
