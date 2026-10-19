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
  /** F6 저장 조회조건 복원 1회 가드 (탭 오픈당) — MotherStore PRESERVED_ON_CONDITION_RESET 보존 키 */
  initialized: boolean;
}

interface MktFcstComparisonAction {
  reset: () => void;
  /** [COND 2026-08-27] UI 오픈 시 F6 저장 조회조건(SCM_ADM_USER_MNU_SRCH_COND_M) 복원 — 정본 sales-future-price */
  restoreSearchConditions: () => Promise<void>;
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
  /**
   * UM-08 — bucket 경계 전환(AS-IS InitSpread): 메인 데이터는 비우고 스프레드 타이틀만 새 bucket 으로
   * 즉시 재조회해 빈 그리드에 새 헤더를 그린다 (.cs L1141~1160 — GetSpdTitle + CreateSheetHeaderColumn).
   */
  resetForBucket: (bucket: string) => void;
}

/**
 * Period 기본 종료일 = 이번달 +5개월 말일 (2026-09-01 기준 2027-02-28).
 *
 * AS-IS 실화면 실측 (사용자 확정 2026-09-01). 종전 add(6, 'month') 는 2027-03-31 이 되어
 * 한 달 더 나갔다. ComparisonVersionModal 의 폴백도 이 함수를 쓴다 - 같은 날짜식이 두 곳에
 * 흩어져 있으면 한쪽만 고쳐져 다시 어긋난다.
 */
export const defaultPeriodEnd = (): string =>
  dayjs().add(5, 'month').endOf('month').format('YYYYMMDD');

/** 조회조건 기간 기본값 — 이번달 1일 ~ +5개월 말일 */
const defaultPeriod = () => ({
  startYyyymmdd: dayjs().startOf('month').format('YYYYMMDD'),
  endYyyymmdd: defaultPeriodEnd(),
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
  initialized: false,
};

/** [COND 2026-08-27] 저장 조회조건 역파싱 키 분류 — 저장은 문자열 coerce(배열=콤마 join / 불리언=String) */
const ARRAY_KEYS = new Set<string>(
  Object.entries(initSearchParams)
    .filter(([, v]) => Array.isArray(v))
    .map(([k]) => k)
);
/**
 * 저장 조회조건(F6) 복원에서 제외할 키 — 기간은 조회 시점 기준으로 다시 계산한다.
 *
 * 저장은 절대 날짜(YYYYMMDD)라 그대로 되살리면 저장한 달의 구간이 그대로 뜬다. 지난달에
 * 저장해 두면 이번달에도 지난달 기준 기간이 올라와 "기본값을 고쳤는데 화면은 그대로"가 된다
 * (2026-09-01 실사고 — Period 종료일이 계속 2027-03-31 로 보임).
 *
 * defaultPeriod() 의 키를 그대로 쓴다 - 기간 칸이 늘거나 이름이 바뀌어도 따라온다.
 */
const PERIOD_KEYS = new Set<string>(Object.keys(defaultPeriod()));

const BOOL_KEYS = new Set<string>(
  Object.entries(initSearchParams)
    .filter(([, v]) => typeof v === 'boolean')
    .map(([k]) => k)
);

/** 멀티 필터 → SP 규약: 빈 배열 = 'ALL' (빈 토큰 전멸 계보 — DMF0035 orAll 동일) */
const orAll = (arr: string[]): string => (arr.length > 0 ? arr.join(',') : 'ALL');

export const useMktFcstComparisonStore = createPersistedStoreWithTab<
  MktFcstComparisonState & MktFcstComparisonAction
>(
  (set, get) => ({
    ...initState,
    reset: () =>
      set(state => {
        state.searchParams = { ...initSearchParams, ...defaultPeriod() };
        state.filters = {};
        state.isOpenSearchArea = true;
        state.staticColumns = [];
      }),
    // ⭐ [COND 2026-08-27] F6 저장 조회조건 복원 — 탭 오픈 시 1회(initialized 가드). F10(Reset Condition) 은
    //   SubTitle 공통이 DB 삭제 + MotherStore.resetSearchCondition(reset() 후 initialized 보존) 으로 처리.
    //   복원된 version 이 있으면 Form 의 기본 Version 자동세팅(version 빈값일 때만)은 건너뛴다.
    restoreSearchConditions: async () => {
      if (get().initialized) return;
      set(state => {
        state.initialized = true;
      });
      try {
        const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        const rows = res.data.result ?? [];
        if (rows.length === 0) return;
        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in initSearchParams)) continue;
          if (PERIOD_KEYS.has(paramNm)) continue; // 기간은 항상 오늘 기준 기본값이 이긴다
          const val = paramCtn ?? '';
          if (ARRAY_KEYS.has(paramNm)) patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          else if (BOOL_KEYS.has(paramNm)) patch[paramNm] = val === 'true';
          else patch[paramNm] = val;
        }
        set(state => {
          state.searchParams = { ...state.searchParams, ...(patch as Partial<SearchParams>) };
        });
      } catch {
        // 저장조건 미존재/조회 실패 시 기본값 유지 (console 금지 룰)
      }
    },
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
        // UM-06 (#93) — 정적 컬럼은 1단 헤더: AS-IS 는 3행 헤더에서 정적 컬럼을 세로 병합해 1단으로 보였다.
        //   메타 SMALL/LARGE 가 라벨과 다른 행이 있으면 foundation getColumnDepth 가 정적 블록까지 2~3단으로
        //   벌리므로 라벨로 정규화한다 (DMF0053 정본 useCustFcstWaterfallStore L195~202 동형).
        state.staticColumns = (result.data.result ?? []).map(col => ({
          ...col,
          sClsLblNm: col.colLblNm,
          lClsLblNm: col.colLblNm,
        }));
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
    resetForBucket: bucket =>
      set(state => {
        const title = state.filters[SHEETS.SPREAD_TITLE];
        // 조회 전(타이틀 미조회)이면 비울 것도 없다 — 메인만 제거, 타이틀은 bucket 만 갈아 즉시 재조회
        state.filters = title ? { [SHEETS.SPREAD_TITLE]: { ...title, bucket } } : {};
      }),
  }),
  'mkt-fcst-comparison'
);
