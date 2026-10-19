import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  BUCKET_TYPE,
  DIVISION,
  MENU_ID,
  SHEETS,
  TITLESET_COLUMN_TYPE,
  TITLESET_SHEET,
} from './sales-future-price.constants';
import type { SearchCondition } from './sales-future-price.types';

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

/** ColumnLayoutModal 개인화 1행 — 표시/순서/폭/색. */
export interface ColumnLayoutSetting {
  colNm: string;
  visible: boolean;
  width: number;
  cellColor: string;
  textColor: string;
  order: number;
}

interface State {
  initialized: boolean;
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  openSearchArea: boolean;
  staticColumns: StaticColumnsBySheet;
  originalStaticColumns: StaticColumnsBySheet;
  staticMeasures: StaticMeasuresBySheet;
  // ⭐ ColumnLayoutModal OK 결과 (null = 미설정) — 표시/순서 + 폭/색.
  //   fetchStaticColumns 는 Search 마다 admin 메타를 다시 덮으므로, 이 값으로 재적용하지 않으면
  //   컬럼 설정 직후 조회 한 번에 개인화가 통째로 원복된다.
  userColumnLayout: ColumnLayoutSetting[] | null;
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
  // ⭐ 저장된 컬럼 개인화(titleSet) 복원 — fetchStaticColumns 가 await 후 메타에 적용.
  //   반환값 = 복원된 개인화(없으면 null).
  fetchUserColumnLayout: () => Promise<ColumnLayoutSetting[] | null>;
  /**
   * 컬럼 개인화 무효화 — division 전환 시 필수.
   *
   * ⚠️ SCM_MST_TITLESET_USER 에는 division 컬럼이 없어 개인화가 division 무관 1벌이다. 반면
   *   컬럼 세트는 division 별로 다르다(SP DIVISION_ID 필터). 40 에서 저장한 레이아웃을 82 컬럼에
   *   그대로 적용하면 "목록에 없는 컬럼 = 비표시" 규칙 때문에 전 컬럼이 사라진다.
   *   → division 이 바뀌면 비우고, fetchStaticColumns 가 그 division 기준으로 다시 조회한다.
   */
  clearUserColumnLayout: () => void;
  // ColumnLayoutModal onSave — visible + width + order + cell/text color 를 한 번에 적용.
  applyColumnLayout: (
    sheetName: keyof StaticColumnsBySheet,
    settings: ColumnLayoutSetting[]
  ) => void;
}

// Period 초기값 = 당월 1일 ~ (당월 +5개월)의 말일 — forecast-price(useForecastPriceStore) 와 동일 산식.
//   (구 '당주 월요일 ~ +1년-1일' 기준에서 변경.)
const periodStart = dayjs().startOf('month').format('YYYYMMDD');
// 종료일 = 시작월 +5개월의 말일 (예: 2026.07.01 → 2026.12.31)
const periodEnd = dayjs().startOf('month').add(5, 'month').endOf('month').format('YYYYMMDD');

// Version 조회키 정본화 — 이 화면의 '현재 버전' 정본 값은 'Current' 다 (AS-IS txtVersion 표기 1:1).
//   Version 팝업 SP 가 현재버전 행의 VERSION_NO 를 'Current' 로 내려주고, 조회 SP 도 이 표기를 받는다
//   (2026-08-26 프로시저 수정 반영. 그 전에는 'CURRENT' 만 받아 표기가 어긋나면 0건이었다).
//   조회 SP 파라미터(setFilter versionType)와 편집 게이트(SalesFuturePrice handleInsert/handleSave,
//   validateEdit 의 versionId !== 'Current')가 모두 이 값을 쓴다.
//   표기가 대소문자만 다른 값으로 들어올 수 있는 경계(팝업 선택 / F6 저장조건 복원 — 정본 전환 전에
//   'CURRENT' 로 저장된 조건이 남아 있다)에서 정본으로 접어 게이트 오판을 막는다.
//   버전은 최대 2개까지 콤마로 결합돼 오므로 토큰 단위로 처리한다.
export const normalizeVersionIds = (ids: string): string =>
  ids
    .split(',')
    .map(v => v.trim())
    .filter(Boolean)
    .map(v => (v.toUpperCase() === 'CURRENT' ? 'Current' : v))
    .join(',');

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
  endYyyymmdd: periodEnd,
  bizTypes: [],
  owners: [],
  bucketType: BUCKET_TYPE.WEEKLY,
  searchOverRange: false,
  excludeNoPrice: false,
  versionId: 'Current',
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
  userColumnLayout: null,
};

// BE 가 폭을 안 내려줄 때의 기본 폭 (ColumnLayoutModal DEFAULT_COL_WIDTH 와 동일 계약).
const DEFAULT_COL_WIDTH = 100;

// ColumnLayoutModal 개인화 override — 표시/순서/폭/색을 admin 메타 위에 덧씌운다.
//   ⚠️ 표시 게이트는 이 화면 Grid 의 `visible` (SalesFuturePriceGrid.visibleColumns) — display 는 보지 않는다.
const applyLayoutToColumns = (
  cols: RawFlexGridColumnConfig[],
  settings: ColumnLayoutSetting[]
): RawFlexGridColumnConfig[] => {
  const byCol = new Map(settings.map(s => [s.colNm, s]));
  return (
    cols
      .map(c => {
        // 관리자 비노출 컬럼(visible===false, 예: COL_LIST/GROUP_ID 등 내부 컬럼)은 저장된
        //   개인화에 USER_FLAG='Y' 로 남아 있어도 절대 표시하지 않는다 — titleSet 저장본에 내부
        //   컬럼이 섞여 들어가면 그리드로 새어 나오던 사고 방지(공용 applyGridLayout 와 동일 가드).
        if (c.visible === false) return { ...c, visible: false };
        const s = byCol.get(c.colNm);
        // 개인화 목록에 없는 컬럼 = 사용자가 비표시로 저장한 것.
        if (!s) return { ...c, visible: false };
        return {
          ...c,
          visible: s.visible,
          colWth: s.width,
          cellColor: s.cellColor,
          textColor: s.textColor,
        };
      })
      // 팝업 순서대로 재정렬 — grid 는 배열 순서를 컬럼 순서로 사용. 미매칭 컬럼은 뒤로.
      .sort((a, b) => {
        const orderA =
          a.colNm === 'MEASURE'
            ? Number.MAX_SAFE_INTEGER
            : (byCol.get(a.colNm)?.order ?? Number.MAX_SAFE_INTEGER);
        const orderB =
          b.colNm === 'MEASURE'
            ? Number.MAX_SAFE_INTEGER
            : (byCol.get(b.colNm)?.order ?? Number.MAX_SAFE_INTEGER);
        return orderA - orderB;
      })
  );
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
            versionType: c.versionId || 'Current',
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
        // ⭐ 진입 시 개인화 복원 — 저장된 titleSet 을 먼저 조회해 override 를 확보한 뒤 메타에 적용.
        //   (별도 effect 로 분리하면 메타 응답과 순서 경쟁 → 늦게 온 쪽이 덮어쓰는 사고.)
        //   이미 있으면(모달 OK 직후 재조회) 서버 재조회 없이 그 값을 유지.
        if (get().userColumnLayout === null) await get().fetchUserColumnLayout();

        const next = res.data.result ?? [];
        set(state => {
          // ⭐ 컬럼 설정(OK) 이후 재조회(Search 등)가 개인화를 덮지 않도록 override 재적용.
          const layout = get().userColumnLayout;
          const applied = layout && layout.length > 0 ? applyLayoutToColumns(next, layout) : next;
          // ⭐ 성능(2026-07-08) — 내용 동일(관리자 변경 없음) 시 set 생략 → 참조 유지.
          //   매 Search refetch 가 동일 내용의 새 배열을 set 하면 Grid 의 visibleColumns 참조가 바뀌어
          //   핸들러 재등록 + invalidate(true) 전체 리프레시가 불필요하게 반복됨. admin 변경 시엔 즉시 반영(기존 동작).
          if (JSON.stringify(state.staticColumns[SHEETS.MAIN]) !== JSON.stringify(applied)) {
            state.staticColumns[SHEETS.MAIN] = applied;
          }
          // 원본은 개인화를 적용하지 않은 admin 값 그대로 — 팝업 Default 원복 기준.
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
        // 정본 전환(2026-08-26) 전에 저장된 조회조건에는 현재버전이 'CURRENT' 로 남아 있다 —
        //   조회/편집 게이트가 쓰는 정본 표기로 접는다. normalizeVersionIds 주석 참조.
        if (typeof patch.versionId === 'string') {
          patch.versionId = normalizeVersionIds(patch.versionId);
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

    // ⭐ 저장된 컬럼 개인화 복원 — ColumnLayoutModal 이 쓰는 SP 와 동일 계약
    //   (DMF0002_GET_TITLESET_POPUP). 조회 키(sheetName/columnType)는 팝업·저장과 반드시 같은 상수를 쓴다.
    //   USER_FLAG='Y' 행 = 사용자가 표시로 저장한 컬럼. 저장 이력이 없으면 null → admin 기본값 그대로.
    //   ⚠️ SP 는 관리자 기본값(COLUMN_WIDTH/SORT_ORDER_NO)과 사용자값(USER_* 별칭)을 따로 내려준다 —
    //     사용자값을 우선하지 않으면 저장한 폭/순서가 영원히 안 보인다 (2026-07-27 실측).
    fetchUserColumnLayout: async () => {
      try {
        const res = await apiClient.post<{ o_rc1?: Record<string, string>[] }>(
          `${MENU_ID}/titleSet/SEARCH/call-proc`,
          {
            programId: MENU_ID,
            sheetName: TITLESET_SHEET,
            columnType: TITLESET_COLUMN_TYPE,
            divisionId: get().searchCondition.divisionId,
          }
        );
        const rows = res.data.result?.o_rc1 ?? [];
        const orderOf = (r: Record<string, string>): number =>
          Number(r.USER_SORT_ORDER_NO ?? r.SORT_ORDER_NO ?? 0);
        const layout = rows
          .filter(r => String(r.USER_FLAG ?? '') === 'Y')
          .sort((a, b) => orderOf(a) - orderOf(b))
          .map((r, i) => {
            const width = Number(r.USER_COLUMN_WIDTH ?? r.COLUMN_WIDTH ?? 0);
            return {
              colNm: String(r.COLUMN_NAME ?? ''),
              visible: true,
              width: Number.isFinite(width) && width > 0 ? width : DEFAULT_COL_WIDTH,
              cellColor: String(r.CELL_COLOR ?? ''),
              textColor: String(r.TEXT_COLOR ?? ''),
              order: i + 1,
            };
          })
          .filter(s => s.colNm);
        if (layout.length === 0) return null;
        set(state => {
          state.userColumnLayout = layout;
          // 메타가 이미 도착해 있으면 소급 적용 (호출 순서 무관하게 개인화가 유실되지 않게).
          const cur = state.staticColumns[SHEETS.MAIN];
          if (cur && cur.length > 0) {
            state.staticColumns[SHEETS.MAIN] = applyLayoutToColumns(cur, layout);
          }
        });
        return layout;
      } catch {
        // 개인화 조회 실패 = 기본 컬럼 세트로 동작 (화면 차단 금지, console 금지 룰)
        return null;
      }
    },

    clearUserColumnLayout: () =>
      set(state => {
        state.userColumnLayout = null;
      }),

    // ColumnLayoutModal OK — 표시/순서/폭/색을 grid 에 즉시 반영.
    //   Grid 의 visibleColumns useMemo 가 staticColumns 의 visible flag + 배열 순서를 사용 → 즉시 반영.
    //   ⚠️ 사내 SCM_USR_TITLE_SET 영구 저장은 별도 SP 호출 의무 (Phase 후속) — 현재는 탭 수명 동안만 유지.
    applyColumnLayout: (sheetName, settings) => {
      set(state => {
        // 표시 컬럼만 보관 — fetchStaticColumns 재조회 후 재적용 기준.
        const layout = settings
          .filter(s => s.visible)
          .sort((a, b) => a.order - b.order)
          .map((s, i) => ({ ...s, order: i + 1 }));
        state.userColumnLayout = layout;
        const cur = state.staticColumns[sheetName];
        if (!cur || cur.length === 0) return;
        state.staticColumns[sheetName] = applyLayoutToColumns(cur, layout);
      });
    },
  }),
  'sales-future-price'
);
