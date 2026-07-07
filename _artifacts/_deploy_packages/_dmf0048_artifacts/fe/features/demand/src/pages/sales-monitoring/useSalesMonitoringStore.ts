import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { BUCKET_TYPE, DIVISION, MENU_ID, SHEETS } from './sales-monitoring.constants';
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

interface State {
  initialized: boolean;
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  openSearchArea: boolean;
  staticColumns: StaticColumnsBySheet;
  staticMeasures: StaticMeasuresBySheet;
  visibleMeasures: VisibleMeasuresBySheet;
  // ColumnSettingModal OK 결과 (표시 컬럼 키 목록). null = 미설정(BE display=DEFAULT/개인화 그대로).
  //   모달 재진입 복원(initialVisibleKeys) + fetchStaticColumns 재조회 후 재적용에 사용.
  userColumnKeys: string[] | null;
  // ⭐ A-4 — PR_GET_DAY_RANGE 기본 Period 적용 1회성 (persist — 탭 재진입 remount 시
  //   사용자가 변경한 Period 를 서버 기본값이 다시 덮던 사고 차단)
  dayRangeApplied: boolean;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchStaticMeasures: () => Promise<void>;
  applyColumnVisibility: (sheetName: keyof StaticColumnsBySheet, visibleKeys: string[]) => void;
  applyVisibleMeasures: (
    sheetName: keyof VisibleMeasuresBySheet,
    measureCodes: string[] | null
  ) => void;
  // PR_GET_DAY_RANGE o_rc2('yyyymmdd:yyyymmdd') → 기본 Period 반영 (AS-IS GetDayRange 1:1)
  applyDayRange: (range: string | undefined) => void;
}

// ⭐ A-3 (2026-07-04): toISOString(UTC) 금지 — KST 00:00~09:00 에 전날로 계산되던 버그. dayjs = 로컬.
const today = dayjs().format('YYYYMMDD');
const sixMonthsAhead = dayjs().add(180, 'day').format('YYYYMMDD');

const initSearch: SearchCondition = {
  divisionId: DIVISION.MOBILITY,
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
  bucketType: BUCKET_TYPE.MONTHLY, // Figma 기본 = Monthly (AS-IS cboBucketType 초기값 동일)
  sumYn: false,
  colorYn: false,
  internalYn: false,
};

const emptyCols: StaticColumnsBySheet = Object.values(SHEETS).reduce((acc, k) => {
  (acc as Record<string, RawFlexGridColumnConfig[]>)[k] = [];
  return acc;
}, {} as StaticColumnsBySheet);

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
  openSearchArea: true,
  staticColumns: emptyCols,
  staticMeasures: emptyMeasures,
  visibleMeasures: emptyVisibleMeasures,
  userColumnKeys: null,
  dayRangeApplied: false,
};

// ColumnSettingModal 선택 override — 선택 컬럼은 display+visible 동시 true (사용자 명시 선택은
//   VISIBLE_FLAG='N' 숨김 데이터 컬럼 게이트보다 우선 — 예: MEASURE), 미선택은 display=false.
const applyUserColumnOverride = (
  cols: RawFlexGridColumnConfig[],
  keys: string[]
): RawFlexGridColumnConfig[] => {
  const keySet = new Set(keys);
  return cols.map(c => ({
    ...c,
    display: keySet.has(c.colNm),
    visible: keySet.has(c.colNm) ? true : c.visible,
  }));
};

export const useSalesMonitoringStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
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
            // 사용자 컬럼설정(OK) 이후 재조회(Search 등)가 선택을 덮지 않도록 override 재적용
            const keys = get().userColumnKeys;
            state.staticColumns[s] =
              keys && keys.length > 0 ? applyUserColumnOverride(fetched, keys) : fetched;
          });
        });
      } catch {
        // BE 메타 미응답 시 silent fallback — MAIN_COLUMNS 하드코딩 유지 (console 금지 룰)
      }
    },

    // ⭐ Measure 동적 fetch (PIVOT 화면 의무 — SCM_MST_SHEET_MEASURE 39행)
    fetchStaticMeasures: async () => {
      try {
        const sheets: SHEETS[] = [SHEETS.MAIN];
        const responses = await Promise.all(
          sheets.map(sheetNm =>
            apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
              sheetNm,
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

    // ColumnSettingModal OK — 선택 column 만 표시 (display 갱신 + 선택 컬럼은 visible 도 true —
    //   사용자 명시 선택이 VISIBLE_FLAG='N' 숨김 게이트보다 우선, 예: MEASURE). 선택 결과는
    //   userColumnKeys 로 보관 → 모달 재진입 복원 + Search 재조회 후 재적용 (2026-07-04 사용자 지적).
    applyColumnVisibility: (sheetName, visibleKeys) => {
      set(state => {
        state.userColumnKeys = visibleKeys;
        const cur = state.staticColumns[sheetName];
        if (!cur || cur.length === 0) return;
        state.staticColumns[sheetName] = applyUserColumnOverride(cur, visibleKeys);
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
        state.searchCondition = { ...state.searchCondition, startYyyymmdd: start, endYyyymmdd: end };
        state.dayRangeApplied = true;
      });
    },
  }),
  'sales-monitoring'
);
