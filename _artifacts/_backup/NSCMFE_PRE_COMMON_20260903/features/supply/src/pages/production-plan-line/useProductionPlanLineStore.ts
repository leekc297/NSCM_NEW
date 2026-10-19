import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { BUCKET_TYPE, MENU_ID, SHEET_PARAM_NAME, SHEETS } from './production-plan-line.constants';
import type { SearchCondition } from './production-plan-line.types';

// SP filter payload — useTabProcQuery enabled 가드.
//   MAIN = SCP0013_GET_PRODUCTION_PLAN_LINEBY (22 IN, AS-IS FindData_Main L2053~2074 1:1).
type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

// SCM_MST_SHEET_MEASURE 동적 fetch row (BE GridMeasure — camelCase 직렬화. mkt-fcst 실측 동일).
export interface MeasureMeta {
  colNm: string;
  colLblNm?: string;
  sClsLblNm?: string;
  lClsLblNm?: string;
  personalizable?: boolean;
  display?: boolean;
}

type StaticColumnsBySheet = { [key in SHEETS]: RawFlexGridColumnConfig[] };
type StaticMeasuresBySheet = { [key in SHEETS]: MeasureMeta[] };
type VisibleMeasuresBySheet = { [key in SHEETS]: string[] | null };

interface State {
  initialized: boolean;
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  openSearchArea: boolean;
  staticColumns: StaticColumnsBySheet;
  staticMeasures: StaticMeasuresBySheet;
  // MeasureSelectModal 선택 measure(표시 대상). null = 전체 표시.
  visibleMeasures: VisibleMeasuresBySheet;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchStaticMeasures: () => Promise<void>;
  applyVisibleMeasures: (sheetName: keyof VisibleMeasuresBySheet, measureCodes: string[] | null) => void;
}

const yyyymmdd = (d: Date) => d.toISOString().slice(0, 10).replace(/-/g, '');
const today = yyyymmdd(new Date());
// AS-IS Form_Load: dCalendar.InitValue = GetDayRange(W52) — Plan date 미선택 초기엔 오늘 기준 52주.
const w52Ahead = yyyymmdd(new Date(Date.now() + (52 * 7 - 1) * 24 * 3600 * 1000));

const initSearch: SearchCondition = {
  divisionId: '',
  operationGroup: '',
  cellTypeGrs: [],
  electrodes: [],
  extraSpecs: [],
  plantSiteIds: [],
  lineIds: [],
  modelId: '',
  itemIds: [],
  nickName: '',
  planDate: '',
  planType: '',
  planSeq: '',
  fromYyyymmdd: today,
  toYyyymmdd: w52Ahead,
  // AS-IS DefineProperty: bucket 기본 Weekly (.cs L290).
  bucketType: BUCKET_TYPE.WEEKLY,
  // AS-IS 초기값: chkAll InitValue 'N' / chkSum·chkLineAssign Checked=false (.cs L246~247).
  chkAll: false,
  lineAssign: false,
  sumYn: false,
};

export const useProductionPlanLineStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    initialized: false,
    filters: {},
    searchCondition: initSearch,
    openSearchArea: true,
    staticColumns: { [SHEETS.MAIN]: [] },
    staticMeasures: { [SHEETS.MAIN]: [] },
    visibleMeasures: { [SHEETS.MAIN]: null },

    reset: () =>
      set(state => {
        state.filters = {};
        state.searchCondition = initSearch;
      }),

    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...state.searchCondition, ...p };
      }),

    // 조회 payload — AS-IS FindData_Main request.Parameters 22개 positional 1:1 (camelCase).
    //   멀티선택은 AS-IS UsrCheckedList2.ControlValues(콤마) 1:1 — 콤마 join.
    //   ⚠️ Phase A: SP INVALID(T19 변환 대기) — useTabProcQuery enabled 게이트로 호출 자체가 차단됨.
    setFilter: () =>
      set(state => {
        const sc = state.searchCondition;
        const sesUserId = useSessionStore.getState().session.userId ?? '';
        state.filters[SHEETS.MAIN] = {
          divisionId: sc.divisionId,
          operationGroup: sc.operationGroup,
          scmSiteId: sc.plantSiteIds.join(','),
          lineId: sc.lineIds.join(','),
          modelId: sc.modelId,
          itemId: sc.itemIds.join(','),
          fromYyyymmdd: sc.fromYyyymmdd,
          toYyyymmdd: sc.toYyyymmdd,
          planStartYyyymmdd: sc.planDate,
          planType: sc.planType,
          seq: sc.planSeq,
          programId: MENU_ID,
          sheetName: SHEET_PARAM_NAME, // AS-IS 하드코딩 "LINE" (.cs L2024)
          userId: sesUserId,
          electrodeType: sc.electrodes.join(','),
          nickName: sc.nickName,
          cellTypeGr: sc.cellTypeGrs.join(','),
          lineAssign: sc.lineAssign ? 'Y' : 'N',
          bucket: sc.bucketType,
          chkAll: sc.chkAll ? 'Y' : 'N',
          extraSpec: sc.extraSpecs.join(','),
          debugMode: 'F',
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

    // ⭐ master hook §2.3 — Column 동적 fetch (SCM_MST_SHEET_COLUMNS PROGRAM_ID='SCP0013', SHEET_NAME='Line'
    //   — 사내 27행 실측 2026-07-13). admin 변경 즉시 반영, 하드코딩 금지 (MAIN_COLUMNS 는 fallback 한정).
    fetchStaticColumns: async () => {
      try {
        const sheets: SHEETS[] = [SHEETS.MAIN];
        const responses = await Promise.all(
          sheets.map(sheetNm =>
            apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
              sheetNm,
              divisionId: get().searchCondition.divisionId,
            })
          )
        );
        set(state => {
          sheets.forEach((s, i) => {
            state.staticColumns[s] = responses[i].data.result ?? [];
          });
        });
      } catch {
        // BE 메타 미응답 시 화면이 안 깨지도록 silent fallback — MAIN_COLUMNS 유지 (console 금지 룰)
      }
    },

    // ⭐ master hook §5 — Measure 동적 fetch (SCM_MST_SHEET_MEASURE SHEET_NAME='LINE' 6행 실측).
    fetchStaticMeasures: async () => {
      try {
        const responses = await Promise.all(
          [SHEET_PARAM_NAME].map(sheetNm =>
            apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, { sheetNm })
          )
        );
        set(state => {
          state.staticMeasures[SHEETS.MAIN] = responses[0].data.result ?? [];
        });
      } catch {
        // silent fallback (console 금지 룰) — MEASURE_FALLBACK 사용
      }
    },

    // MeasureSelectModal OK — 표시할 measure 코드만 보관 (null = 전체 표시).
    applyVisibleMeasures: (sheetName, measureCodes) => {
      set(state => {
        state.visibleMeasures[sheetName] = measureCodes;
      });
    },
  }),
  'production-plan-line'
);
