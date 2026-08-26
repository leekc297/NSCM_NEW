import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { fetchTitleSet } from '@shared/components';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import {
  BUCKET_TYPE,
  DIVISION,
  MENU_ID,
  SHEETS,
  TITLESET_COLUMN_TYPE,
} from './business-plan.constants';
import type { CutoffWindow, SearchCondition } from './business-plan.types';

/** ColumnLayoutModal 개인화 1행 — 표시/순서/폭/색. */
export interface ColumnLayoutSetting {
  colNm: string;
  visible: boolean;
  width: number;
  cellColor: string;
  textColor: string;
  order: number;
}

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
  // 개인화 적용 전 admin 메타 원본 — 팝업 Default 버튼의 원복 기준.
  //   staticColumns 는 개인화로 덮이므로 별도 스냅샷이 필요하다.
  originalStaticColumns: RawFlexGridColumnConfig[];
  // ⭐ ColumnLayoutModal OK 결과 (null = 미설정) — 표시/순서 + 폭/색.
  //   fetchStaticColumns 는 mount/Search/division 변경마다 admin 메타를 다시 덮으므로, 이 값으로
  //   재적용하지 않으면 컬럼 설정 직후 조회 한 번에 개인화가 통째로 원복된다.
  userColumnLayout: ColumnLayoutSetting[] | null;
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
  /** ColumnLayoutModal onSave — 표시/순서/width/색상을 staticColumns 에 즉시 반영. */
  applyColumnLayout: (settings: ColumnLayoutSetting[]) => void;
  /** 저장된 컬럼 개인화(titleSet) 복원 — fetchStaticColumns 가 await 후 메타에 적용. */
  fetchUserColumnLayout: () => Promise<ColumnLayoutSetting[] | null>;
  /**
   * 컬럼 개인화 무효화 — division 전환 시 필수.
   *
   * ⚠️ SCM_MST_TITLESET_USER 에는 division 컬럼이 없어 개인화가 division 무관 1벌인데,
   *   컬럼 세트는 division 별로 다르다(SP 서버 필터). 이전 division 레이아웃을 새 division
   *   컬럼에 적용하면 "목록에 없는 컬럼 = 비표시" 규칙 때문에 전 컬럼이 사라진다.
   */
  clearUserColumnLayout: () => void;
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
// Div/Team 변경 시에는 리셋하지 않는다 (2026-08-20 사용자 결정 — 사용자가 지정한 기간 유지).
const BUSINESS_PLAN_INIT_PERIOD = {
  start: dayjs().startOf('month').format('YYYYMMDD'),
  end: dayjs().add(7, 'month').endOf('month').format('YYYYMMDD'),
};
const { start: monthStart, end: sevenMonthsEnd } = BUSINESS_PLAN_INIT_PERIOD;

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
  // ⭐ 2026-08-20 교정 — 두 기본값이 AS-IS 와 반대였다. 원본 Designer.cs 실측으로 바로잡는다.
  //   chkSum : this.chkSum.Checked = true         -> 기본 체크
  //   cboQty : Checked 지정 자체가 없음(= false)   -> 기본 해제. btnSearch 에서
  //            p_qty_yn = (cboQty.Checked) ? "Y" : "N" 이므로 'N' 이 전송된다.
  //   앞선 '실화면 대조' 판정이 반대로 적혀 있었다(같은 값이 BusinessPlanForm 의 Division·Team
  //   변경 reset 에도 복사돼 있으니 함께 본다).
  sumYn: true,
  qtyYn: false,
};

const initState: State = {
  filters: {},
  searchCondition: initSearch,
  openSearchArea: true,
  staticColumns: [],
  originalStaticColumns: [],
  userColumnLayout: null,
  staticMeasures: [],
  visibleMeasures: null,
  cutoffWindow: null,
  dayRangeApplied: false,
  authGroup: '',
};

// BE 가 폭을 안 내려줄 때의 기본 폭 (ColumnLayoutModal DEFAULT_COL_WIDTH 와 동일 계약).
const DEFAULT_COL_WIDTH = 100;

// ColumnLayoutModal 개인화 override — 표시/순서/폭/색을 admin 메타 위에 덧씌운다.
//   ⚠️ 표시 게이트는 `display` 만 건드린다 — `visible` 은 admin VISIBLE_FLAG(관리 노출)이라
//     사용자 조작으로 덮어쓰지 않는다 (구 applyColumnVisibility 와 동일 규칙).
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
            // 16 P_QTY_YN — AS-IS Qty≠0 체크박스 1:1 (기본 체크 = 'Y'). 2026-08-06 실화면 대조 교정 —
            //   구 분석의 'Visible=false dead → N 고정' 은 오판정이었고, 'N' 은 수량 0 행까지
            //   조회돼 AS-IS 대비 행수가 부풀던 원인.
            qtyYn: c.qtyYn ? 'Y' : 'N',
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
        // ⭐ 진입 시 개인화 복원 — 저장된 titleSet 을 먼저 조회해 override 를 확보한 뒤 메타에 적용.
        //   (별도 effect 로 분리하면 메타 응답과 순서 경쟁 → 늦게 온 쪽이 덮어쓰는 사고.)
        //   이미 있으면(모달 OK 직후 재조회) 서버 재조회 없이 그 값을 유지.
        if (get().userColumnLayout === null) await get().fetchUserColumnLayout();

        const result = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          {
            sheetNm: SHEETS.MAIN, // 'Biz Plan' — 등록명 그대로 (룰 #91)
            divisionId: get().searchCondition.divisionId,
          }
        );
        set(state => {
          const fetched = result.data.result ?? [];
          // 개인화 적용 전 원본 보관 — 팝업 Default 원복 기준 (개인화로 덮이지 않는다).
          state.originalStaticColumns = fetched;
          // 컬럼 설정(OK) 이후 재조회(Search/division 변경)가 개인화를 덮지 않도록 override 재적용.
          const layout = get().userColumnLayout;
          state.staticColumns =
            layout && layout.length > 0 ? applyLayoutToColumns(fetched, layout) : fetched;
        });
      } catch {
        // BE 메타 미응답 시 silent — 빈 배열 유지 (console 금지 룰)
      }
    },

    // ⭐ 저장된 컬럼 개인화 복원 — ColumnLayoutModal 이 쓰는 SP 와 동일 계약
    //   (DMF0002_GET_TITLESET_POPUP). 조회 키(sheetName/columnType)는 팝업·저장과 반드시 같아야 한다.
    //   ⚠️ SP 는 관리자 기본값(COLUMN_WIDTH/SORT_ORDER_NO)과 사용자값(USER_* 별칭)을 따로 내려준다 —
    //     사용자값을 우선하지 않으면 저장한 폭/순서가 영원히 안 보인다.
    fetchUserColumnLayout: async () => {
      try {
        const rows =
          (await fetchTitleSet({
            menuId: MENU_ID,
            sheetName: SHEETS.MAIN,
            columnType: TITLESET_COLUMN_TYPE,
            divisionId: get().searchCondition.divisionId,
          })) ?? [];
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
          if (state.staticColumns.length > 0) {
            state.staticColumns = applyLayoutToColumns(state.staticColumns, layout);
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

    // ColumnLayoutModal OK — 표시/순서/폭/색을 grid 에 즉시 반영 (영구 저장은 titleSet SAVE 별도).
    applyColumnLayout: settings => {
      set(state => {
        // 표시 컬럼만 보관 — fetchStaticColumns 재조회 후 재적용 기준.
        const layout = settings
          .filter(s => s.visible)
          .sort((a, b) => a.order - b.order)
          .map((s, i) => ({ ...s, order: i + 1 }));
        state.userColumnLayout = layout;
        const cur = state.staticColumns;
        if (!cur || cur.length === 0) return;
        state.staticColumns = applyLayoutToColumns(cur, layout);
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
