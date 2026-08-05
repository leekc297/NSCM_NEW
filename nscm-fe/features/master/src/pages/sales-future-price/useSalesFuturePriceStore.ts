import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  BUCKET_TYPE,
  DIVISION,
  MENU_ID,
  SHEETS,
} from './sales-future-price.constants';
import type { SearchCondition } from './sales-future-price.types';
import { thisWeekMonday, yyyymmddOf } from './utils/futurePriceDate';

// SP filter 로 변환된 payload — useTabProcQuery enabled 가드
type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

// SCM_MST_SHEET_MEASURE 동적 fetch row 형태.
// ⚠️ BE 는 GridMeasure DTO(admin.menu.dto.GridMeasure)로 직렬화 → camelCase 응답
//   (colNm/colLblNm/display/personalizable/sClsLblNm/lClsLblNm/attribute1~10).
//   COLUMN_NAME/COLUMN_LABEL_NAME/VALID_YN/SORT_ORDER_NO 는 응답에 없음(과거 오타입 → measure 매핑 전멸).
//   정렬은 SP(PR_GET_SHEET_MEASURE_LIST) 반환 순서 = 배열 순서. 노출여부 = display(DISPLAY_FLAG='Y').
export interface MeasureMeta {
  colNm: string;
  colLblNm?: string;
  sClsLblNm?: string;
  lClsLblNm?: string;
  personalizable?: boolean;
  display?: boolean;
  attribute1?: string;
  attribute2?: string;
  attribute3?: string;
}

type StaticColumnsBySheet = { [key in SHEETS]: RawFlexGridColumnConfig[] };
type StaticMeasuresBySheet = { [key in SHEETS]: MeasureMeta[] };

interface State {
  initialized: boolean;
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  openSearchArea: boolean;
  staticColumns: StaticColumnsBySheet;
  originalStaticColumns: StaticColumnsBySheet;
  staticMeasures: StaticMeasuresBySheet;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  // ⭐ divisionId 전달 시 SP(PR_GET_SHEET_COLUMN_LIST) 가 DIVISION_ID 컬럼으로 서버측 필터 (attribute3 미사용).
  fetchStaticColumns: (divisionId?: string) => Promise<void>;
  // Price Batch Input 팝업 전용 시트('Sales Price Save All') 컬럼 fetch → staticColumns[PRICE_BATCH].
  fetchBatchColumns: (divisionId?: string) => Promise<void>;
  fetchStaticMeasures: () => Promise<void>;
  // F6 로 DB 저장한 개인화 조회조건을 진입 시 1회 복원 (initialized 가드 — 세션당 1회).
  restoreSearchConditions: () => Promise<void>;
  // ColumnSettingModal onSave — 사용자 선택 column 만 visible='Y', 나머지 'N'.
  applyColumnVisibility: (sheetName: keyof StaticColumnsBySheet, visibleKeys: string[]) => void;
  // ColumnLayoutModal onSave — visible + width + order + cell/text color 를 한 번에 적용.
  applyColumnLayout: (
    sheetName: keyof StaticColumnsBySheet,
    settings: {
      colNm: string;
      visible: boolean;
      width: number;
      cellColor: string;
      textColor: string;
      order: number;
    }[]
  ) => void;
}

// Period 초기값 = "당주 월요일" ~ (당주 월요일 + 1년 - 1일) (사용자 요구 2026-07-02 — 구 '당일' 기준에서 변경).
//   월요일 산출은 AS-IS GetThisWeekMonday 정합 유틸 재사용 (일요일=이전 주 월요일).
//   yyyymmddOf 는 local 기준 — 구 toISOString(UTC) 방식의 KST 저녁 하루 밀림도 함께 제거.
const monday = thisWeekMonday();
const periodStart = yyyymmddOf(monday);
const oneYearMinusOneDay = (() => {
  const d = new Date(monday);
  d.setFullYear(d.getFullYear() + 1);
  d.setDate(d.getDate() - 1);
  return yyyymmddOf(d);
})();

const initSearch: SearchCondition = {
  divisionId: DIVISION.MOBILITY,
  deptIds: [],
  endCustomers: ['ALL'], // End Customer 초기값 ALL (명시적)
  scmSiteIds: [],
  plantSiteIds: [],
  itemIds: [],
  nickName: '',
  projectCodes: [],
  startYyyymmdd: periodStart,
  endYyyymmdd: oneYearMinusOneDay,
  bizTypes: [],
  owners: [],
  bucketType: BUCKET_TYPE.WEEKLY,
  searchOverRange: false,
  excludeNoPrice: false,
  versionId: 'CURRENT',
};

const makeEmptyCols = (): StaticColumnsBySheet =>
  Object.values(SHEETS).reduce((acc, k) => {
    (acc as Record<string, RawFlexGridColumnConfig[]>)[k] = [];
    return acc;
  }, {} as StaticColumnsBySheet);

const emptyCols: StaticColumnsBySheet = makeEmptyCols();

const emptyMeasures: StaticMeasuresBySheet = Object.values(SHEETS).reduce((acc, k) => {
  (acc as Record<string, MeasureMeta[]>)[k] = [];
  return acc;
}, {} as StaticMeasuresBySheet);

const initState: State = {
  initialized: false,
  filters: {},
  searchCondition: initSearch,
  openSearchArea: true,
  staticColumns: emptyCols,
  originalStaticColumns: makeEmptyCols(),
  staticMeasures: emptyMeasures,
};

export const useSalesFuturePriceStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    setFilter: () => {
      // BE makeProcedure (BaseService.java L357) 가 SCM_ADM_PROC_M.COL_NM 기준 매핑.
      // SP DMF0020_GET_SCM_MST_FUTURE_PRICE 의 IN 18 param (SORT_ORD 1-18) 모두 명시:
      //   8. customerProjectCode  9. customerModel  13. sesUserId(P_CREATED_BY)  14. userInfo(P_USERINFO)
      // 누락 시 BE 가 NULL 전달 → SP V_GROUP_ID 매칭 실패 → AUTHORITY_YN='N' → 0 row.
      const sesUserId = useSessionStore.getState().session.userId ?? '';
      set(state => {
        const c = state.searchCondition;
        const j = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join('^'));
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: c.divisionId,
            deptId: j(c.deptIds),
            endCustomer: j(c.endCustomers),
            scmSiteId: j(c.scmSiteIds),
            plantSiteId: j(c.plantSiteIds),
            projectCode: j(c.projectCodes),
            itemId: j(c.itemIds),
            customerProjectCode: 'ALL',
            customerModel: 'ALL',
            fromYyyymmdd: c.startYyyymmdd,
            toYyyymmdd: c.endYyyymmdd,
            biztype: j(c.bizTypes),
            sesUserId,
            userInfo: sesUserId,
            owner: j(c.owners),
            overRange: c.searchOverRange ? 'Y' : 'N',
            invalidExec: c.excludeNoPrice ? 'Y' : 'N',
            versionType: c.versionId || 'CURRENT',
            bucketType: c.bucketType,
          } as never,
        };
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

    // ⭐ master hook §2.3 "UI 생성의 동적 속성관리" — Column 동적 fetch
    //   SCM_MST_SHEET_COLUMNS 의 admin 변경 즉시 반영 (mount + Search 시 호출)
    fetchStaticColumns: async (divisionId?: string) => {
      try {
        // ⭐ divisionId 전달 → SP 가 SCM_MST_SHEET_COLUMNS.DIVISION_ID 로 서버측 필터 (attribute3 미사용).
        //   미전달(undefined) 시 SP 는 전체 컬럼 반환(기존 동작 = backward compatible).
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? SHEETS.MAIN, divisionId }
        );
        const next = res.data.result ?? [];
        set(state => {
          // ⭐ 성능(2026-07-08) — 내용 동일(관리자 변경 없음) 시 set 생략 → 참조 유지.
          //   매 Search refetch 가 동일 내용의 새 배열을 set 하면 Grid 의 visibleColumns 참조가 바뀌어
          //   핸들러 재등록 + invalidate(true) 전체 리프레시가 불필요하게 반복됨. admin 변경 시엔 즉시 반영(기존 동작).
          if (JSON.stringify(state.staticColumns[SHEETS.MAIN]) !== JSON.stringify(next)) {
            state.staticColumns[SHEETS.MAIN] = next;
          }
          state.originalStaticColumns[SHEETS.MAIN] = next;
        });
      } catch {
        // BE 메타 미등록 시 화면이 안 깨지도록 silent fallback — 기존 MAIN_COLUMNS 하드코딩 유지
        // (master hook §8.3 anti-pattern 5.4 회피 / console 금지 룰)
      }
    },

    // ⭐ Price Batch Input 팝업 — AS-IS 전용 시트('Sales Price Save All') 컬럼 + divisionId 서버측 필터.
    fetchBatchColumns: async (divisionId?: string) => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME[SHEETS.PRICE_BATCH] ?? SHEETS.PRICE_BATCH, divisionId }
        );
        const next = res.data.result ?? [];
        set(state => {
          // 내용 동일 시 set 생략 — 참조 안정화 (MAIN 과 동일 사유, 2026-07-08).
          if (JSON.stringify(state.staticColumns[SHEETS.PRICE_BATCH]) !== JSON.stringify(next)) {
            state.staticColumns[SHEETS.PRICE_BATCH] = next;
          }
        });
      } catch {
        // silent fallback — 배치 모달 FALLBACK_FIXED 유지
      }
    },

    // ⭐ master hook §5 — Measure 동적 fetch (PIVOT 화면 의무)
    fetchStaticMeasures: async () => {
      try {
        const sheets: SHEETS[] = [SHEETS.MAIN];
        // admin SHEET_NAME(AS-IS 'Sales Price')로 조회 — 라우팅 'main' 과 분리 (SHEET_NAME 불변).
        const responses = await Promise.all(
          sheets.map(sheetNm =>
            apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
              sheetNm: ADMIN_SHEET_NAME[sheetNm] ?? sheetNm,
            })
          )
        );
        set(state => {
          sheets.forEach((s, i) => {
            const next = responses[i].data.result ?? [];
            // 내용 동일 시 set 생략 — measureDataMap 재생성/Grid 리렌더 방지 (참조 안정화, 2026-07-08).
            if (JSON.stringify(state.staticMeasures[s]) !== JSON.stringify(next)) {
              state.staticMeasures[s] = next;
            }
          });
        });
      } catch {
        // silent fallback (console 금지 룰) — MEASURE_4 hardcode fallback
      }
    },
    // ⭐ F6 개인화 조회조건 복원 (G1 격차) — 진입 시 1회(initialized 가드, 세션당) DB 저장조건을 적용.
    //   저장(personalizeCondition)은 값을 문자열로 coerce(배열=콤마 join / 불리언=String)하므로,
    //   복원은 필드 타입별로 역파싱: 배열키=콤마 split / 불리언키='true' 비교 / 그 외=문자열.
    //   ⚠️ 저장조건 divisionId 가 초기값과 달라도 form 의 division 종속 reset 이 복원값을 wipe 하지 않도록,
    //      reset 은 DivisionField onChange(사용자 조작)로 이동됨(SalesFuturePriceForm) → 복원(프로그램 변경)은 무영향.
    restoreSearchConditions: async () => {
      if (get().initialized) return;
      set(state => {
        state.initialized = true; // 세션당 1회 (persist) — 재마운트/인세션 변경 덮어쓰기 방지.
      });
      try {
        const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        const rows = res.data.result ?? [];
        if (rows.length === 0) return;

        const ARRAY_KEYS = new Set<string>([
          'deptIds',
          'endCustomers',
          'scmSiteIds',
          'plantSiteIds',
          'itemIds',
          'projectCodes',
          'bizTypes',
          'owners',
        ]);
        const BOOL_KEYS = new Set<string>(['searchOverRange', 'excludeNoPrice']);

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
            ...(patch as unknown as Partial<SearchCondition>),
          };
        });
      } catch {
        // 저장조건 미존재/조회 실패 시 기본값 유지 (console 금지 룰)
      }
    },

    // ColumnSettingModal OK — 사용자 선택 column 만 visible (visible='Y'), 나머지 'N'.
    //   Grid 의 visibleColumns useMemo 가 admin staticColumns 의 visible flag 를 사용 → 즉시 반영.
    //   ⚠️ 사내 SCM_USR_TITLE_SET 영구 저장은 별도 SP 호출 의무 (Phase 후속).
    applyColumnVisibility: (sheetName, visibleKeys) => {
      set(state => {
        const cur = state.staticColumns[sheetName];
        if (!cur || cur.length === 0) return;
        const visibleSet = new Set(visibleKeys);
        state.staticColumns[sheetName] = cur.map(c => ({
          ...c,
          visible: visibleSet.has(c.colNm),
        }));
      });
    },
    applyColumnLayout: (sheetName, settings) => {
      set(state => {
        const cur = state.staticColumns[sheetName];
        if (!cur || cur.length === 0) return;
        const byCol = new Map(settings.map(s => [s.colNm, s]));
        const next = cur.map(c => {
          const s = byCol.get(c.colNm);
          if (!s) return { ...c, visible: false };
          return {
            ...c,
            visible: s.visible,
            colWth: s.width,
            cellColor: s.cellColor,
            textColor: s.textColor,
          };
        });
        // 팝업 순서대로 재정렬 — grid 는 배열 순서를 컬럼 순서로 사용. 미매칭 컬럼은 뒤로.
        next.sort(
          (a, b) =>
            (byCol.get(a.colNm)?.order ?? Number.MAX_SAFE_INTEGER) -
            (byCol.get(b.colNm)?.order ?? Number.MAX_SAFE_INTEGER)
        );
        state.staticColumns[sheetName] = next;
      });
    },
  }),
  'sales-future-price'
);
