import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { BUCKET_TYPE, BUCKET_WORD, DIVISION, MENU_ID, SHEETS } from './sales-plan.constants';
import type { CalendarInfo, EditAuthInfo, SearchCondition } from './sales-plan.types';

// SP filter 로 변환된 payload — useTabProcQuery enabled 가드
//   MAIN = P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX / SPREAD_TITLE = P_DMF0021_GET_SPREAD_TITLE
type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.SPREAD_TITLE]?: ProcRequest<MENU_ID, SHEETS.SPREAD_TITLE>;
};

// SCM_MST_SHEET_MEASURE 동적 fetch row — /admin/menu/{MENU_ID}/measure (BE GridMeasure camelCase 직렬화.
//   DMF0003 사고 계보: UPPER_SNAKE 가정 금지 — colNm/colLblNm/sClsLblNm/personalizable/display).
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
  // ⭐ MAIN 커서 2/3 보관 — 기준일(calendar)·편집권한(editAuth). editLock cutoff 산출 입력(클라 시계 금지).
  calendarInfo: CalendarInfo | null;
  editAuth: EditAuthInfo | null;
  // PR_GET_DAY_RANGE 1회 적용 가드 (AS-IS drpPeriod.InitValue — DMF0014 dayRangeApplied 동일)
  dayRangeApplied: boolean;
  // ⭐ P_USERINFO 용 권한 그룹 (AS-IS NowGroupID 등가). 세션에 그룹 정보 부재 실측(2026-07-15 —
  //   /user/login·UserSession·PR_GET_NSCM_USER 전 계층 0건) → CMBO 'SalesPlanUserAuthGroup'
  //   (USER_GR_MPG_M × GET_ADMIN_GROUP_MEASURE 교집합, ADMIN 우선) 1행을 SalesPlan.tsx 가 주입.
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
  // MAIN 응답의 calendar/editAuth 커서 보관 (cutoff·권한 산출용).
  setCalendarInfo: (calendar: CalendarInfo | null, editAuth: EditAuthInfo | null) => void;
  // PR_GET_DAY_RANGE o_rc2 DAY_RANGE('yyyymmdd:yyyymmdd') → 기본 Period (당월 1일 ~ +6개월 말일)
  applyDayRange: (range?: string) => void;
  // ColumnSettingModal onSave — 사용자 선택 column 만 visible='Y', 나머지 'N' (로컬 즉시 반영).
  applyColumnVisibility: (visibleKeys: string[]) => void;
  // MeasureSelectModal onSave — 표시할 measure 코드 목록 적용 (null = 전체).
  applyVisibleMeasures: (measureCodes: string[] | null) => void;
  setAuthGroup: (group: string) => void;
}

// 기본 Period — 당월 1일 ~ +6개월 말일 (AS-IS PR_GET_DAY_RANGE p_month=6 동등 dayjs 계산.
//   서버 dayRange(o_rc2) 도착 시 applyDayRange 가 서버값으로 교체 — 동등성 이중 방어).
const monthStart = dayjs().startOf('month').format('YYYYMMDD');
const sixMonthsEnd = dayjs().add(6, 'month').endOf('month').format('YYYYMMDD');

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
  endYyyymmdd: sixMonthsEnd,
  bucketType: BUCKET_TYPE.MONTHLY, // 기본 Monthly (AS-IS DefineProperty L543 — DMF0082 Weekly 와 상이)
  sumYn: false, // AS-IS InitControls L487 uncheck
};

const initState: State = {
  filters: {},
  searchCondition: initSearch,
  openSearchArea: true,
  staticColumns: [],
  staticMeasures: [],
  visibleMeasures: null,
  calendarInfo: null,
  editAuth: null,
  dayRangeApplied: false,
  authGroup: '',
};

export const useSalesPlanStore = createPersistedStoreWithTab<State & Action>(
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
      //   키명 = P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX PROC_M COL_NM (2026-07-14 사내 실측 계약).
      //   sesUserId(P_CREATED_BY) 는 BE 세션 자동주입 — request 미포함.
      //   ⚠ userGroup(P_USERINFO=NowGroupID)·userDeptId(P_USER_DEPT_ID) 는 BE 자동주입 대상이 아님 —
      //   FE payload 필수 (누락 시 SP 권한 필터 오동작. DMF0003 2026-07-02 사고 계보).
      //   2026-07-15 실측: session.groupId 는 전 계층 부재(유령 필드) → authGroup(CMBO 조회 그룹) 사용.
      //   fallback = USER_ID (그룹 미보유 사용자 = lookup 미매칭 = 편집권한 없음, 정상 동작).
      const sesUserId = useSessionStore.getState().session.userId ?? '';
      const userGroup = get().authGroup || sesUserId;
      set(state => {
        // persist(sessionStorage) rehydrate 가 구버전 shape 일 수 있어 기본값 머지로 완전한 조회조건 보장
        //   (누락 필드 → SP NULL payload → ORA 사고 차단. DMF0003 2026-06-29 계보).
        const c: SearchCondition = { ...initSearch, ...state.searchCondition };
        // 멀티선택 콤보 = 콤마 delim (AS-IS CheckedList ControlValues 1:1). 빈 배열 = 'ALL' sentinel.
        const j = (arr?: string[]): string => (!arr || arr.length === 0 ? 'ALL' : arr.join(','));
        // 텍스트+팝업 필드(Project/Model/Owner) = raw 텍스트, 빈값 '' (AS-IS txt*.Text 1:1).
        const raw = (arr?: string[]): string => (!arr || arr.length === 0 ? '' : arr.join(','));
        state.filters = {
          // ── P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX (17 IN, PROC_M SORT_ORD 순) ──
          [SHEETS.MAIN]: {
            divisionId: c.divisionId, // 1
            deptId: j(c.deptIds), // 2  Team
            endCustomer: j(c.endCustomers), // 3
            scmSiteId: j(c.scmSiteIds), // 4  Sales Site
            projectCode: raw(c.projectCodes), // 5  (40 비활성 '')
            itemId: raw(c.itemIds), // 6
            itemType: j(c.itemTypes), // 7
            fromYyyymmdd: c.startYyyymmdd, // 8
            nowYyyymmdd: dayjs().format('YYYYMMDD'), // 9
            toYyyymmdd: c.endYyyymmdd, // 10
            plantSiteId: j(c.plantSiteIds), // 11 (40 비활성 'ALL')
            bizType: j(c.bizTypes), // 12
            owner: raw(c.owners), // 13
            internalYn: 'N', // 14 Include Internal Txn 숨김 — 항상 'N' (AS-IS Visible=false)
            userGroup, // 15 세션 NowGroupID (FE 필수 전달)
            bucket: BUCKET_WORD[c.bucketType], // 16 full-word
            userDeptId: '', // 17 JV Planner 부서 — TO-BE 세션 deptId 부재 → '' (SP 내 무해 분기)
          },
          // ── P_DMF0021_GET_SPREAD_TITLE (4 IN — sesUserId BE주입) ──
          [SHEETS.SPREAD_TITLE]: {
            startYyyymmdd: c.startYyyymmdd,
            endYyyymmdd: c.endYyyymmdd,
            divisionId: c.divisionId,
            bucket: BUCKET_WORD[c.bucketType],
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

    // ⭐ master hook §2.3 "UI 생성의 동적 속성관리" — Column 동적 fetch (SHEET_COLUMNS 66건, division 서버 필터).
    //   admin 변경 즉시 반영 (mount + Search + division 변경 시 호출). 하드코딩 fallback 없음 — 메타 주도.
    fetchStaticColumns: async () => {
      try {
        const result = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          {
            sheetNm: SHEETS.MAIN, // 'Sales Plan' — 등록명 그대로 (룰 #91)
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

    // ⭐ master hook §5 — Measure 동적 fetch (SHEET_MEASURE 31건 — Measure Select 팝업 대상)
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
        // silent — 메타 미응답 시 빈 목록 유지 (하드코딩 fallback 금지, 사용자 룰 2026-07-15)
      }
    },

    // MAIN 커서 2/3 보관 — 편집 cutoff(당월/당주/M+3)·Insert 권한 산출 입력.
    setCalendarInfo: (calendar, editAuth) =>
      set(state => {
        state.calendarInfo = calendar;
        state.editAuth = editAuth;
      }),

    // PR_GET_DAY_RANGE o_rc2 'yyyymmdd:yyyymmdd' → 기본 Period (AS-IS drpPeriod.InitValue L511 1:1)
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

    // ColumnSettingModal OK — 사용자 선택 column 만 visible (영구 저장은 titleSet SAVE 별도).
    applyColumnVisibility: visibleKeys => {
      set(state => {
        const cur = state.staticColumns;
        if (!cur || cur.length === 0) return;
        // 사용자 Column Setup 선택 = DISPLAY_FLAG 의미론 → display 갱신 (visible 은 admin VISIBLE_FLAG
        //   관리 노출 — 사용자 조작으로 덮어쓰지 않음. 2026-07-15 정정).
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
  'sales-plan'
);
