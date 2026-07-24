import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { BUCKET_TYPE, DIVISION, MENU_ID, SHEETS } from './business-plan.constants';
import type { CutoffWindow, SearchCondition } from './business-plan.types';

// SP filter 로 변환된 payload — useTabProcQuery enabled 가드
//   MAIN = DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA / SPREAD_TITLE = DMF0042_GET_SPREAD_TITLE
type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.SPREAD_TITLE]?: ProcRequest<MENU_ID, SHEETS.SPREAD_TITLE>;
};

// SCM_MST_SHEET_MEASURE 동적 fetch row — /admin/menu/{MENU_ID}/measure (BE GridMeasure camelCase 직렬화)
export interface MeasureMeta {
  colNm: string;
  colLblNm?: string;
  sClsLblNm?: string;
  lClsLblNm?: string;
  personalizable?: boolean;
  display?: boolean;
}

interface State {
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  openSearchArea: boolean;
  staticColumns: RawFlexGridColumnConfig[];
  staticMeasures: MeasureMeta[];
  // MeasureSelectModal 선택 measure(표시 대상). null = 미설정(전체 표시).
  visibleMeasures: string[] | null;
  // ⭐ MAIN 커서 2 보관 — 40 편집 유효구간 (81/82 = lookup DM_LONG_PLAN 미등재 → NULL. FE NULL 방어 승계).
  cutoffWindow: CutoffWindow | null;
  // PR_GET_DAY_RANGE 1회 적용 가드 (AS-IS drpPeriod.InitValue L308 — p_month=7)
  dayRangeApplied: boolean;
  // ⭐ P_USERINFO 용 권한 그룹 (AS-IS NowGroupID 등가) — CMBO 'BizPlanUserAuthGroup'(P5) 1행 주입.
  authGroup: string;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchStaticMeasures: () => Promise<void>;
  setCutoffWindow: (calendar: CutoffWindow | null) => void;
  // PR_GET_DAY_RANGE o_rc2 DAY_RANGE('yyyymmdd:yyyymmdd') → 기본 Period (당월 1일 ~ +7개월 말일)
  applyDayRange: (range?: string) => void;
  applyColumnVisibility: (visibleKeys: string[]) => void;
  applyVisibleMeasures: (measureCodes: string[] | null) => void;
  setAuthGroup: (group: string) => void;
}

// ⭐ 금주 월요일 (AS-IS GetThisWeekMonday L3023~3042 1:1 — p_now_yyyymmdd + editLock cutoff 공통 원천)
export const thisWeekMonday = (): string => {
  const d = dayjs();
  const dow = d.day() === 0 ? 7 : d.day(); // ISO: 월=1 … 일=7
  return d.subtract(dow - 1, 'day').format('YYYYMMDD');
};

// 기본 Period — 당월 1일 ~ +7개월 말일 (AS-IS PR_GET_DAY_RANGE p_month=7 동등 dayjs 계산.
//   서버 dayRange(o_rc2) 도착 시 applyDayRange 가 서버값으로 교체 — 동등성 이중 방어).
const monthStart = dayjs().startOf('month').format('YYYYMMDD');
const sevenMonthsEnd = dayjs().add(7, 'month').endOf('month').format('YYYYMMDD');

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
  startYyyymmdd: monthStart,
  endYyyymmdd: sevenMonthsEnd,
  bucketType: BUCKET_TYPE.MONTHLY, // 기본 Monthly (AS-IS BUCKET2_TYPE_CODE 콤보 로딩)
  sumYn: false, // AS-IS chkSum 기본 uncheck
};

const initState: State = {
  filters: {},
  searchCondition: initSearch,
  openSearchArea: true,
  staticColumns: [],
  staticMeasures: [],
  visibleMeasures: null,
  cutoffWindow: null,
  dayRangeApplied: false,
  authGroup: '',
};

export const useBusinessPlanStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setAuthGroup: group =>
      set(state => {
        state.authGroup = group;
      }),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    setFilter: () => {
      // BE makeProcedure (BaseService.java) 가 SCM_ADM_PROC_M.COL_NM 기준 positional 매핑.
      //   키명 = DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA PROC_M COL_NM (P2 — ALL_ARGUMENTS 실측 계약).
      //   sesUserId(P_CREATED_BY) 는 BE 세션 자동주입 — request 미포함.
      //   ⚠ userGroup(P_USERINFO=NowGroupID) 는 BE 자동주입 대상이 아님 — FE payload 필수
      //   (session.groupId 는 유령 필드 — memory feedback_session_groupid_ghost_field).
      //   fallback = USER_ID (그룹 미보유 사용자 = lookup 미매칭, 정상 동작).
      const sesUserId = useSessionStore.getState().session.userId ?? '';
      const userGroup = get().authGroup || sesUserId;
      set(state => {
        // persist(sessionStorage) rehydrate 가 구버전 shape 일 수 있어 기본값 머지로 완전한 조회조건 보장
        const c: SearchCondition = { ...initSearch, ...state.searchCondition };
        // 멀티선택 콤보 = 콤마 delim (AS-IS CheckedList ControlValues 1:1). 빈 배열 = 'ALL' sentinel.
        const j = (arr?: string[]): string => (!arr || arr.length === 0 ? 'ALL' : arr.join(','));
        // 텍스트+팝업 필드(Project/Model/Owner) = raw 텍스트, 빈값 '' (AS-IS txt*.Text 1:1).
        const raw = (arr?: string[]): string => (!arr || arr.length === 0 ? '' : arr.join(','));
        state.filters = {
          // ── DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA (16 IN, PROC_M SORT_ORD 순 — sesUserId BE주입) ──
          [SHEETS.MAIN]: {
            divisionId: c.divisionId, // 1
            deptId: j(c.deptIds), // 2  Team
            endCustomer: j(c.endCustomers), // 3
            scmSiteId: j(c.scmSiteIds), // 4  Sales Site
            projectCode: raw(c.projectCodes), // 5  (40 비활성 '')
            itemId: raw(c.itemIds), // 6
            itemType: j(c.itemTypes), // 7
            fromYyyymmdd: c.startYyyymmdd, // 8
            nowYyyymmdd: thisWeekMonday(), // 9  ⭐ 금주 월요일 (AS-IS FindData L717 — 클라 산정 파리티)
            toYyyymmdd: c.endYyyymmdd, // 10
            plantSiteId: j(c.plantSiteIds), // 12 (40 비활성 'ALL')
            bizType: j(c.bizTypes), // 13
            userGroup, // 14 P_USERINFO — lookup GET_ADMIN_GROUP(ALL) 해석 (FE 필수 전달)
            owner: raw(c.owners), // 15
            qtyYn: 'N', // 16 P_QTY_YN — AS-IS cboQty Visible=false dead → 'N' 고정 (파리티)
          },
          // ── DMF0042_GET_SPREAD_TITLE (sesUserId BE주입 — userId/mnuId 는 FE 전달) ──
          [SHEETS.SPREAD_TITLE]: {
            startYyyymmdd: c.startYyyymmdd,
            endYyyymmdd: c.endYyyymmdd,
            divisionId: c.divisionId,
            userId: sesUserId,
            mnuId: MENU_ID,
          },
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

    // ⭐ master hook §2.3 — Column 동적 fetch (SHEET_COLUMNS 63건, division 서버 직접 비교 — hook #113).
    fetchStaticColumns: async () => {
      try {
        const result = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          {
            sheetNm: SHEETS.MAIN, // 'Biz Plan' — 등록명 그대로 (룰 #91)
            divisionId: get().searchCondition.divisionId,
          }
        );
        set(state => {
          state.staticColumns = result.data.result ?? [];
        });
      } catch {
        // BE 메타 미응답 시 silent — 빈 배열 유지 (console 금지 룰)
      }
    },

    // ⭐ master hook §5 — Measure 동적 fetch (SHEET_MEASURE 9건 — Measure Select 팝업 대상)
    fetchStaticMeasures: async () => {
      try {
        const result = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
          sheetNm: SHEETS.MAIN,
          divisionId: get().searchCondition.divisionId,
        });
        set(state => {
          state.staticMeasures = result.data.result ?? [];
        });
      } catch {
        // silent — 메타 미응답 시 빈 목록 유지 (하드코딩 fallback 금지)
      }
    },

    // MAIN 커서 2 보관 — 40 편집 유효구간 (editLock R4 입력. 81/82 NULL 방어)
    setCutoffWindow: calendar =>
      set(state => {
        state.cutoffWindow = calendar;
      }),

    // PR_GET_DAY_RANGE o_rc2 'yyyymmdd:yyyymmdd' → 기본 Period (AS-IS drpPeriod.InitValue L308 1:1)
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

    // ColumnSettingModal OK — 사용자 선택 column 만 display (영구 저장은 titleSet SAVE 별도.
    //   visible 은 admin VISIBLE_FLAG 관리 노출 — 사용자 조작으로 덮어쓰지 않음).
    applyColumnVisibility: visibleKeys => {
      set(state => {
        const cur = state.staticColumns;
        if (!cur || cur.length === 0) return;
        const visibleSet = new Set(visibleKeys);
        state.staticColumns = cur.map(c => ({
          ...c,
          display: visibleSet.has(c.colNm),
        }));
      });
    },

    // MeasureSelectModal OK — 표시할 measure 코드만 보관 (null = 전체 표시).
    applyVisibleMeasures: measureCodes => {
      set(state => {
        state.visibleMeasures = measureCodes;
      });
    },
  }),
  'business-plan'
);
