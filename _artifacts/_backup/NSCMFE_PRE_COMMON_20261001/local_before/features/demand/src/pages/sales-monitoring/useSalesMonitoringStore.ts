import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { BUCKET_TYPE, MENU_ID, SHEETS } from './sales-monitoring.constants';
import type { SearchCondition } from './sales-monitoring.types';

// SP filter payload — useTabProcQuery enabled 가드
//   MAIN = PKG_DMF0048.P_DMF0048_GET_DM_PLN_SALES_MONITORING / SPREAD_TITLE = DMF0048_GET_SPREAD_TITLE
//   DAY_RANGE = PR_GET_DAY_RANGE (기본 조회구간 — AS-IS GetDayRange p_month=6)
type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.SPREAD_TITLE]?: ProcRequest<MENU_ID, SHEETS.SPREAD_TITLE>;
  [SHEETS.DAY_RANGE]?: ProcRequest<MENU_ID, SHEETS.DAY_RANGE>;
};

// SCM_MST_SHEET_MEASURE 동적 fetch row (BE MenuController — camelCase 직렬화, mkt-fcst 실측 동일)
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
  /**
   * Plant Site 콤보 원천. AS-IS 가 경로마다 다른 목록을 쓴다(문서 §3-2).
   *   'endCustomer' 진입 - FilterPlantSiteByEndCustomer (Division + End Customer)  :398
   *   'division'    Division 변경 - FilterFromSiteByDivision (Division)            :1916
   *
   * searchCondition 바깥에 둔다 - setFilter 가 그 객체를 통째로 proc 요청에 실으므로 안에 두면
   * 서버가 모르는 필드가 조회 파라미터로 새어 나간다.
   */
  plantSiteSource: 'endCustomer' | 'division';
  openSearchArea: boolean;
  staticColumns: StaticColumnsBySheet;
  // 개인화 적용 전 admin 메타 원본 — 팝업 Default 버튼의 원복 기준.
  //   staticColumns 는 개인화로 덮이므로 별도 스냅샷이 필요하다.
  originalStaticColumns: StaticColumnsBySheet;
  staticMeasures: StaticMeasuresBySheet;
  visibleMeasures: VisibleMeasuresBySheet;
  // ColumnLayoutModal OK 결과 (null = 미설정 → BE display=DEFAULT/개인화 그대로) — 표시/순서 + 폭/색.
  //   fetchStaticColumns 재조회 후 재적용 기준.
  userColumnLayout: ColumnLayoutSetting[] | null;
  // ⭐ A-4 — PR_GET_DAY_RANGE 기본 Period 적용 1회성 (persist — 탭 재진입 remount 시
  //   사용자가 변경한 Period 를 서버 기본값이 다시 덮던 사고 차단)
  dayRangeApplied: boolean;
}

interface Action {
  reset: () => void;
  /**
   * F6 로 저장한 조회조건(SCM_ADM_USER_MNU_SRCH_COND_M)을 탭 진입 시 1회 복원한다.
   * initialized 가드 — F10(초기화)은 MotherStore 가 initialized 를 보존하므로 재복원되지 않는다.
   *
   * 반환 = 복원 반영 후의 divisionId. 이 스토어는 탭별 멀티톤이라 getState() 를 쓸 수 없어
   * (createStore.ts createPersistedStoreWithTab 주석), 호출부가 결과 division 을 알 방법이 이것뿐이다.
   */
  restoreSearchConditions: () => Promise<string>;
  setSearchCondition: (
    p: Partial<SearchCondition>,
    plantSiteSource?: 'endCustomer' | 'division'
  ) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchStaticMeasures: () => Promise<void>;
  /** ColumnLayoutModal onSave — 표시/순서/width/색상을 staticColumns 에 즉시 반영. */
  applyColumnLayout: (
    sheetName: keyof StaticColumnsBySheet,
    settings: ColumnLayoutSetting[]
  ) => void;
  /** 저장된 컬럼 개인화(titleSet) 복원 — fetchStaticColumns 가 await 후 메타에 적용. */
  fetchUserColumnLayout: () => Promise<ColumnLayoutSetting[] | null>;
  /**
   * 컬럼 개인화 무효화 — division 전환 시 필수.
   *
   * ⚠️ SCM_MST_TITLESET_USER 에는 division 컬럼이 없어 개인화가 division 무관 1벌인데,
   *   컬럼 세트는 division 별로 다르다. 이전 division 레이아웃을 새 division 컬럼에 적용하면
   *   "목록에 없는 컬럼 = 비표시" 규칙 때문에 전 컬럼이 사라진다.
   */
  clearUserColumnLayout: () => void;
  applyVisibleMeasures: (
    sheetName: keyof VisibleMeasuresBySheet,
    measureCodes: string[] | null
  ) => void;
  // PR_GET_DAY_RANGE o_rc2('yyyymmdd:yyyymmdd') → 기본 Period 반영 (AS-IS GetDayRange 1:1)
  applyDayRange: (range: string | undefined) => void;
}

// ⭐ A-3 (2026-07-04): toISOString(UTC) 금지 — KST 00:00~09:00 에 전날로 계산되던 버그. dayjs = 로컬.
// Period 조회조건 초기값 — dayRange(PR_GET_DAY_RANGE) 응답 도착 전까지의 자리값.
//   Div/Team 변경 시에는 리셋하지 않는다 (2026-08-20 사용자 결정 — 사용자가 지정한 기간 유지).
const SALES_MONITORING_INIT_PERIOD = {
  start: dayjs().format('YYYYMMDD'),
  end: dayjs().add(180, 'day').format('YYYYMMDD'),
};
const { start: today, end: sixMonthsAhead } = SALES_MONITORING_INIT_PERIOD;

const initSearch: SearchCondition = {
  divisionId: useSessionStore.getState().session.div ?? '40',
  deptIds: [],
  endCustomers: [],
  scmSiteIds: [],
  plantSiteIds: [],
  bizTypes: [],
  itemTypes: [],
  projectCodes: [],
  itemIds: [],
  owners: [],
  // 기본 Period = FE 근사값 → 화면 진입 후 PR_GET_DAY_RANGE o_rc2(월 경계, 사용자 timezone)로 교체.
  startYyyymmdd: today,
  endYyyymmdd: sixMonthsAhead,
  bucketType: BUCKET_TYPE.MONTHLY, // 화면 설계 기본 = Monthly (AS-IS cboBucketType 초기값 동일)
  sumYn: false,
  colorYn: false,
  internalYn: false,
};

/**
 * F6 저장 조회조건 역파싱 키 분류.
 *
 * 저장(GridAction.personalizeCondition)은 모든 값을 문자열로 coerce 한다(배열=콤마 join /
 * 불리언=String). 복원은 그 반대로 SearchCondition 타입대로 되돌린다:
 *   배열키 = 콤마 split / 불리언키 = 'true' 비교 / 그 외 = 문자열.
 * 분류는 initSearch 의 실제 값 타입에서 파생한다 — 조회조건 필드가 늘어도 자동 반영된다.
 */
const ARRAY_KEYS = new Set<string>(
  Object.entries(initSearch)
    .filter(([, v]) => Array.isArray(v))
    .map(([k]) => k)
);
const BOOL_KEYS = new Set<string>(
  Object.entries(initSearch)
    .filter(([, v]) => typeof v === 'boolean')
    .map(([k]) => k)
);
// 열거형(Bucket)은 유효값만 채택 — 구버전 저장값/오염이 들어오면 SP 가 빈 결과를 돌려준다.
const BUCKET_VALUES = new Set<string>(Object.values(BUCKET_TYPE));
// 저장 포맷 = yyyymmdd 8자리. 다른 포맷이면 Period 검증(validateFind)이 통과하지 못한다.
const isYyyymmdd = (v: unknown): v is string => typeof v === 'string' && /^\d{8}$/.test(v);

// staticColumns / originalStaticColumns 는 각각 독립 객체여야 한다 (같은 참조를 공유하면 얽힌다).
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

const emptyVisibleMeasures: VisibleMeasuresBySheet = Object.values(SHEETS).reduce((acc, k) => {
  (acc as Record<string, string[] | null>)[k] = null;
  return acc;
}, {} as VisibleMeasuresBySheet);

const initState: State = {
  initialized: false,
  filters: {},
  searchCondition: initSearch,
  plantSiteSource: 'endCustomer',
  openSearchArea: true,
  staticColumns: emptyCols,
  originalStaticColumns: makeEmptyCols(),
  staticMeasures: emptyMeasures,
  visibleMeasures: emptyVisibleMeasures,
  userColumnLayout: null,
  dayRangeApplied: false,
};

// BE 가 폭을 안 내려줄 때의 기본 폭 (ColumnLayoutModal DEFAULT_COL_WIDTH 와 동일 계약).
const DEFAULT_COL_WIDTH = 100;

// ColumnLayoutModal 개인화 override — 표시/순서/폭/색을 admin 메타 위에 덧씌운다.
//   ⚠️ 이 화면 Grid 의 표시 게이트는 `display && visible` 이다. 선택 컬럼은 둘 다 true 로 올린다
//     (사용자 명시 선택은 VISIBLE_FLAG='N' 숨김 데이터 컬럼 게이트보다 우선 — 예: MEASURE).
//     미선택은 display=false 로만 내리고 원본 visible 은 보존한다 (구 applyUserColumnOverride 동일 규칙).
const applyLayoutToColumns = (
  cols: RawFlexGridColumnConfig[],
  settings: ColumnLayoutSetting[]
): RawFlexGridColumnConfig[] => {
  const byCol = new Map(settings.map(s => [s.colNm, s]));
  return (
    cols
      .map(c => {
        const s = byCol.get(c.colNm);
        // 개인화 목록에 없는 컬럼 = 사용자가 비표시로 저장한 것.
        if (!s) return { ...c, display: false };
        return {
          ...c,
          display: s.visible,
          visible: s.visible ? true : c.visible,
          colWth: s.width || DEFAULT_COL_WIDTH,
          cellColor: s.cellColor,
          textColor: s.textColor,
        };
      })
      // 팝업 순서대로 재정렬 — grid 는 배열 순서를 컬럼 순서로 사용. 미매칭 컬럼은 뒤로.
      .sort(
        (a, b) =>
          (byCol.get(a.colNm)?.order ?? Number.MAX_SAFE_INTEGER) -
          (byCol.get(b.colNm)?.order ?? Number.MAX_SAFE_INTEGER)
      )
  );
};

export const useSalesMonitoringStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),

    // F6 저장 조회조건 복원 — 탭 수명 내 1회(initialized 가드). 저장조건 없음/조회 실패는
    //   기본값 유지(화면 차단 금지, console 금지 룰). F10(Reset Condition)은 SubTitle 공통이
    //   DB 삭제 + MotherStore.resetSearchCondition 으로 처리하는데, 그 쪽이 initialized 를 보존하므로
    //   초기화 직후 이 함수가 다시 복원해 버리는 일은 없다.
    restoreSearchConditions: async () => {
      if (get().initialized) return get().searchCondition.divisionId;
      set(state => {
        state.initialized = true; // 먼저 세운다 — 마운트 중복 호출/재마운트 재복원 방지.
      });
      try {
        const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        const rows = res.data.result ?? [];
        if (rows.length === 0) return get().searchCondition.divisionId;

        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          // 현재 SearchCondition 에 없는 키(구버전 잔재)는 버린다 — setFilter 가 조회조건 객체를
          //   통째로 SP payload 로 쓰므로 모르는 필드가 섞이면 그대로 새어 나간다.
          if (!(paramNm in initSearch)) continue;
          const val = paramCtn ?? '';
          if (ARRAY_KEYS.has(paramNm)) patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          else if (BOOL_KEYS.has(paramNm)) patch[paramNm] = val === 'true';
          else patch[paramNm] = val;
        }
        if (typeof patch.bucketType === 'string' && !BUCKET_VALUES.has(patch.bucketType))
          delete patch.bucketType;
        if (!isYyyymmdd(patch.startYyyymmdd)) delete patch.startYyyymmdd;
        if (!isYyyymmdd(patch.endYyyymmdd)) delete patch.endYyyymmdd;

        // 저장된 Period 를 복원했으면 PR_GET_DAY_RANGE 기본 구간이 덮지 못하게 잠근다.
        //   (dayRange 응답은 비동기라 복원보다 늦게 도착할 수 있다.)
        const periodRestored = patch.startYyyymmdd !== undefined || patch.endYyyymmdd !== undefined;

        set(state => {
          state.searchCondition = {
            ...state.searchCondition,
            ...(patch as Partial<SearchCondition>),
          };
          if (periodRestored) state.dayRangeApplied = true;
        });
      } catch {
        // 저장조건 미존재/조회 실패 시 기본값 유지 (console 금지 룰)
      }
      return get().searchCondition.divisionId;
    },
    setSearchCondition: (
      p: Partial<SearchCondition>,
      plantSiteSource?: 'endCustomer' | 'division'
    ) =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
        if (plantSiteSource) state.plantSiteSource = plantSiteSource;
      }),
    setFilter: () => {
      // ⭐ 키명 = PKG_DMF0048.P_DMF0048_GET_DM_PLN_SALES_MONITORING PROC_M COL_NM (ALL_ARGUMENTS 실측
      //   2026-07-04, 04_VERIFY/001_all_arguments.txt). createdBy/sesUserId/mnuId 는 BE 세션 자동(보강 전송).
      //   ⭐ 구분자 = 콤마 (PKG FN_SPLITSTRING(x, ',') 실측 — '^' 아님. 콤보 멀티 빈값 = 'ALL' sentinel,
      //     텍스트(projectCode/itemId/owner) 빈값 = '' → SP IS NOT NULL 가드 통과).
      const sesUserId = useSessionStore.getState().session.userId ?? '';
      // AS-IS p_userinfo = UserInfoContext["NowGroupID"] — To-Be 세션 groupId 미구현 시 USER_ID fallback
      //   (mkt-fcst userGroup 선례 — GET_ADMIN_GROUP lookup 이 USER_ID row 로 운영 등록됨).
      const userinfo = useSessionStore.getState().session.groupId || sesUserId;
      set(state => {
        const c: SearchCondition = { ...initSearch, ...state.searchCondition };
        const jAll = (arr?: string[]): string => (!arr || arr.length === 0 ? 'ALL' : arr.join(','));
        const jTxt = (arr?: string[]): string => (!arr || arr.length === 0 ? '' : arr.join(','));
        const now = dayjs().format('YYYYMMDD'); // AS-IS sNowDate = DateTime.Now (.cs L653) — 로컬 (A-3)
        state.filters = {
          // ── PKG_DMF0048.P_DMF0048_GET_DM_PLN_SALES_MONITORING (18 IN + 세션 2) ──
          [SHEETS.MAIN]: {
            divisionId: c.divisionId, // 1  P_DIVISION_ID
            deptId: jAll(c.deptIds), // 2  P_DEPT_ID (Team)
            endCustomer: jAll(c.endCustomers), // 3  P_END_CUSTOMER
            scmSiteId: jAll(c.scmSiteIds), // 4  P_SCM_SITE_ID (Sales Site)
            projectCode: jTxt(c.projectCodes), // 5  P_PROJECT_CODE ('' = 전체)
            itemId: jTxt(c.itemIds), // 6  P_ITEM_ID (LIKE 부분일치 — SP L1010)
            itemType: jAll(c.itemTypes), // 7  P_ITEM_TYPE
            fromYyyymmdd: c.startYyyymmdd, // 8  P_FROM_YYYYMMDD
            nowYyyymmdd: now, // 9  P_NOW_YYYYMMDD (AS-IS sNowDate)
            toYyyymmdd: c.endYyyymmdd, // 10 P_TO_YYYYMMDD
            createdBy: sesUserId, // 11 BE 자동(보강 전송)
            plantSiteId: jAll(c.plantSiteIds), // 12 P_PLANT_SITE_ID
            biztype: jAll(c.bizTypes), // 13 P_BIZTYPE
            owner: jTxt(c.owners), // 14 P_OWNER
            internalYn: c.internalYn ? 'Y' : 'N', // 15 P_INTERNAL_YN (Include Internal Txn)
            userinfo, // 16 P_USERINFO (AS-IS NowGroupID — GET_ADMIN_GROUP 판정)
            bucket: c.bucketType, // 17 P_BUCKET ('DAILY'/'WEEKLY'/'MONTHLY')
            userDeptId: '', // 18 P_USER_DEPT_ID (JV Planner 전용 — 일반 사용자 공란)
            sesUserId, // 19 P_USER_ID (BE 자동)
            mnuId: MENU_ID, // 20 P_MENU_ID (BE 자동)
          },
          // ── DMF0048_GET_SPREAD_TITLE (5 IN) — 동적 PIVOT 기간 헤더 ──
          [SHEETS.SPREAD_TITLE]: {
            startYyyymmdd: c.startYyyymmdd,
            endYyyymmdd: c.endYyyymmdd,
            createdBy: sesUserId,
            divisionId: c.divisionId,
            bucket: c.bucketType,
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

    // ⭐ ui-dynamic-property-management — Column 동적 fetch (SCM_MST_SHEET_COLUMNS 54행, admin 즉시 반영)
    fetchStaticColumns: async () => {
      try {
        // ⭐ 진입 시 개인화 복원 — 저장된 titleSet 을 먼저 조회해 override 를 확보한 뒤 메타에 적용.
        //   (별도 effect 로 분리하면 메타 응답과 순서 경쟁 → 늦게 온 쪽이 덮어쓰는 사고.)
        //   이미 있으면(모달 OK 직후 재조회) 서버 재조회 없이 그 값을 유지.
        if (get().userColumnLayout === null) await get().fetchUserColumnLayout();

        const sheets: SHEETS[] = [SHEETS.MAIN];
        const responses = await Promise.all(
          sheets.map(sheetNm =>
            apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
              sheetNm, // = SHEETS.MAIN value('Sales Monitoring') — 등록명 그대로 (룰 #91)
              divisionId: get().searchCondition.divisionId,
            })
          )
        );
        set(state => {
          sheets.forEach((s, i) => {
            const fetched = responses[i].data.result ?? [];
            // 개인화 적용 전 원본 보관 — 팝업 Default 원복 기준 (개인화로 덮이지 않는다).
            state.originalStaticColumns[s] = fetched;
            // 사용자 컬럼설정(OK) 이후 재조회(Search 등)가 선택을 덮지 않도록 override 재적용
            const layout = get().userColumnLayout;
            state.staticColumns[s] =
              layout && layout.length > 0 ? applyLayoutToColumns(fetched, layout) : fetched;
          });
        });
      } catch {
        // BE 메타 미응답 시 silent fallback — MAIN_COLUMNS 하드코딩 유지 (console 금지 룰)
      }
    },

    // ⭐ 저장된 컬럼 개인화 복원 — ColumnLayoutModal 이 쓰는 SP 와 동일 계약
    //   (DMF0002_GET_TITLESET_POPUP). 조회 키(sheetName/columnType)는 팝업·저장과 반드시 같아야 한다.
    //   ⚠️ SP 는 관리자 기본값(COLUMN_WIDTH/SORT_ORDER_NO)과 사용자값(USER_* 별칭)을 따로 내려준다 —
    //     사용자값을 우선하지 않으면 저장한 폭/순서가 영원히 안 보인다.
    fetchUserColumnLayout: async () => {
      try {
        const res = await apiClient.post<{ o_rc1?: Record<string, string>[] }>(
          `${MENU_ID}/titleSet/SEARCH/call-proc`,
          {
            programId: MENU_ID,
            sheetName: SHEETS.MAIN,
            columnType: 'C',
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

    // ⭐ Measure 동적 fetch (PIVOT 화면 의무 — SCM_MST_SHEET_MEASURE 39행)
    fetchStaticMeasures: async () => {
      try {
        const sheets: SHEETS[] = [SHEETS.MAIN];
        const responses = await Promise.all(
          sheets.map(sheetNm =>
            apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
              sheetNm,
              // 필수: PR_GET_SHEET_MEASURE_LIST 가 division 별 measure 세트를 서버에서 필터한다.
              //   미전달 시 NULL 로 들어가 measure 목록이 비거나 타 division 세트가 섞인다
              //   (fetchStaticColumns 의 divisionId 전달과 동일 계약).
              divisionId: get().searchCondition.divisionId,
            })
          )
        );
        set(state => {
          sheets.forEach((s, i) => {
            state.staticMeasures[s] = responses[i].data.result ?? [];
          });
        });
      } catch {
        // silent fallback (console 금지 룰)
      }
    },

    // ColumnLayoutModal OK — 표시/순서/폭/색을 grid 에 즉시 반영. 결과는 userColumnLayout 으로
    //   보관 → 모달 재진입 복원 + Search 재조회 후 재적용 (2026-07-04 사용자 지적).
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

    // MeasureSelectModal OK — 표시 measure 목록 (null = 전체)
    applyVisibleMeasures: (sheetName, measureCodes) => {
      set(state => {
        state.visibleMeasures[sheetName] = measureCodes;
      });
    },

    // PR_GET_DAY_RANGE o_rc2 DAY_RANGE('yyyymmdd:yyyymmdd') → 기본 Period 반영 (AS-IS L996 1:1)
    //   ⭐ A-4 — 탭 수명 내 1회만 (dayRangeApplied persist). 이후 remount 는 사용자 Period 보존.
    applyDayRange: range => {
      if (!range || !/^\d{8}:\d{8}$/.test(range)) return;
      if (get().dayRangeApplied) return;
      const [start, end] = range.split(':');
      set(state => {
        state.searchCondition = {
          ...state.searchCondition,
          startYyyymmdd: start,
          endYyyymmdd: end,
        };
        state.dayRangeApplied = true;
      });
    },
  }),
  'sales-monitoring'
);
