import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { MENU_ID, PLAN_RESULT, REPORT_TYPE, SHEETS } from './etc-sales-reports.constants';
import type { SearchCondition } from './etc-sales-reports.types';

// SP filter payload — useTabProcQuery enabled 가드 (Version 필수 게이트 포함)
type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.SPREAD_TITLE]?: ProcRequest<MENU_ID, SHEETS.SPREAD_TITLE>;
  [SHEETS.MEASURE]?: ProcRequest<MENU_ID, SHEETS.MEASURE>;
};

// SCM_MST_SHEET_MEASURE 동적 fetch row (business-plan 동형)
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
  visibleMeasures: string[] | null;
  // ⭐ ColumnLayoutModal 개인화 보관 (null = 미설정). fetchStaticColumns 재조회 후 재적용 기준.
  userColumnLayout: ColumnLayoutSetting[] | null;
  // ⭐ 조회 시점 고정 — 현재월 yyyymm (editLock 시점 경계. AS-IS iCurCol 산정 원천)
  thisMonth: string;
  // Result 조회 시 전월 스냅샷 (저장 P_RESULT_MONTH — AS-IS L602~609)
  resultMonth: string;
  /** F6 저장 조회조건 복원 1회 가드 (탭 오픈당) — MotherStore PRESERVED_ON_CONDITION_RESET 보존 키 */
  initialized: boolean;
}

interface Action {
  reset: () => void;
  /**
   * F6 로 저장한 조회조건(SCM_ADM_USER_MNU_SRCH_COND_M)을 탭 진입 시 1회 복원한다.
   * initialized 가드 — F10(초기화)은 MotherStore 가 initialized 를 보존하므로 재복원되지 않는다.
   */
  restoreSearchConditions: () => Promise<void>;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchStaticMeasures: () => Promise<void>;
  applyColumnVisibility: (visibleKeys: string[]) => void;
  // ⭐ ColumnLayoutModal 개인화 적용 (DMF0003 mkt-fcst 방식 1:1).
  applyColumnLayout: (settings: ColumnLayoutSetting[]) => void;
  applyVisibleMeasures: (measureCodes: string[] | null) => void;
}

/** ColumnLayoutModal 개인화 1행 — 표시/순서/폭/색 (DMF0003 mkt-fcst 방식 1:1, 2026-07-30 교체). */
export interface ColumnLayoutSetting {
  colNm: string;
  visible: boolean;
  width: number;
  cellColor: string;
  textColor: string;
  order: number;
}

// 개인화 목록을 admin 컬럼 메타에 적용 — visible/display 양방향 + 폭·색 + 순서.
//   ⚠️ visible 만 바꾸면 공통 DataGrid 의 display 경로가 남아 컬럼이 안 사라진다 (DMF0003 선례).
const applyLayoutToColumns = (
  cols: RawFlexGridColumnConfig[],
  settings: ColumnLayoutSetting[]
): RawFlexGridColumnConfig[] => {
  const byCol = new Map(settings.map(s => [s.colNm, s]));
  return cols
    .map(c => {
      const s = byCol.get(c.colNm);
      if (!s) return { ...c, visible: false, display: false };
      return {
        ...c,
        visible: s.visible,
        display: s.visible,
        colWth: s.width,
        cellColor: s.cellColor,
        textColor: s.textColor,
      };
    })
    .sort(
      (a, b) =>
        (byCol.get(a.colNm)?.order ?? Number.MAX_SAFE_INTEGER) -
        (byCol.get(b.colNm)?.order ?? Number.MAX_SAFE_INTEGER)
    );
};

const initSearch: SearchCondition = {
  // 빈 값 진입 — 화면 자동선택(FilterMyDivision 첫 행/세션 division)이 채운다. 하드코딩('40')이면
  //   가드(if (sc.divisionId) return)에 걸려 자동선택이 발화하지 않고, '40' 권한이 없는 사용자에게도
  //   '40' 이 세팅된다 (DMF0003/DMF0040/DMF0044 정본 통일 — EtcSalesReports.tsx 참조).
  divisionId: '',
  mdfType: REPORT_TYPE.SP_W, // 기본 Report Type (AS-IS clbType MDF_TYPE 첫 항목)
  yyyy: dayjs().format('YYYY'), // 기본 당해년 (AS-IS usrYear 기본값)
  planResult: PLAN_RESULT.PLAN, // 기본 Plan (AS-IS clbPlanResult SelectedIndex=0 L207)
  versionNo: '', // ⭐ United 팝업 주입 전까지 조회 차단 (MSG00283)
  versionLabel: '',
};

const initState: State = {
  filters: {},
  searchCondition: initSearch,
  openSearchArea: true,
  staticColumns: [],
  staticMeasures: [],
  visibleMeasures: null,
  userColumnLayout: null,
  thisMonth: dayjs().format('YYYYMM'),
  resultMonth: '',
  initialized: false,
};

/**
 * F6 저장 조회조건 역파싱 키 분류.
 *
 * 저장(GridAction.personalizeCondition)은 모든 값을 문자열로 coerce 한다(배열=콤마 join /
 * 불리언=String). 이 화면 SearchCondition 은 현재 전부 문자열이라 두 집합이 실제로는 비지만,
 * 조회조건에 배열/불리언 필드가 추가돼도 자동으로 따라오게 초기값의 실제 타입에서 파생해 둔다.
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
// 열거형은 유효값만 채택 — 구버전 저장값/오염이 들어오면 SP 가 빈 결과를 돌려준다.
//   divisionId 는 여기서 검증하지 않는다: DIVISION 상수는 대표값 3개뿐이고 81 계열은
//   startsWith('81') 로 갈리는(measureCntOf) 열린 집합이라, 상수와 대조하면 정상 division 이 잘린다.
const REPORT_TYPE_VALUES = new Set<string>(Object.values(REPORT_TYPE));
const PLAN_RESULT_VALUES = new Set<string>(Object.values(PLAN_RESULT));

export const useEtcSalesReportsStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    // F6 저장 조회조건 복원 — 탭 수명 내 1회(initialized 가드). 저장조건 없음/조회 실패는
    //   기본값 유지(화면 차단 금지, console 금지 룰). F10(Reset Condition)은 SubTitle 공통이
    //   DB 삭제 + MotherStore.resetSearchCondition 으로 처리하는데, 그 쪽이 initialized 를 보존하므로
    //   초기화 직후 이 함수가 다시 복원해 버리는 일은 없다.
    //   필수: fetchStaticColumns/fetchStaticMeasures 보다 먼저 await 한다 — 둘 다
    //   get().searchCondition.divisionId 를 admin 메타 SP 로 넘기므로, 복원된 division 이
    //   기본값과 다르면 컬럼·메저가 엉뚱한 division 기준으로 잡힌다.
    restoreSearchConditions: async () => {
      if (get().initialized) return;
      set(state => {
        state.initialized = true; // 먼저 세운다 — 마운트 중복 호출/재마운트 재복원 방지.
      });
      try {
        const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        const rows = res.data.result ?? [];
        if (rows.length === 0) return;

        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          // 현재 SearchCondition 에 없는 키(구버전 잔재)는 버린다.
          if (!(paramNm in initSearch)) continue;
          const val = paramCtn ?? '';
          if (ARRAY_KEYS.has(paramNm)) patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          else if (BOOL_KEYS.has(paramNm)) patch[paramNm] = val === 'true';
          else patch[paramNm] = val;
        }
        if (typeof patch.mdfType === 'string' && !REPORT_TYPE_VALUES.has(patch.mdfType))
          delete patch.mdfType;
        if (typeof patch.planResult === 'string' && !PLAN_RESULT_VALUES.has(patch.planResult))
          delete patch.planResult;
        if (typeof patch.yyyy !== 'string' || !/^\d{4}$/.test(patch.yyyy)) delete patch.yyyy;
        // versionNo 는 United 팝업이 주입하는 연도별 스냅샷이라 해가 바뀌면 그 해에 없는 값일 수
        //   있다. 그래도 사용자가 저장한 조건이므로 그대로 복원한다 — 없는 버전이면 SP 가 0건을
        //   돌려줄 뿐이고, 표시문(versionLabel)과 짝을 이뤄 무엇으로 조회했는지는 화면에 남는다.
        //   금지: versionNo 만 살리고 versionLabel 을 버리지 말 것 (버전은 걸렸는데 칸은 빈 상태).
        if (typeof patch.versionNo === 'string' && patch.versionNo && !patch.versionLabel)
          patch.versionLabel = patch.versionNo;

        set(state => {
          state.searchCondition = {
            ...state.searchCondition,
            ...(patch as Partial<SearchCondition>),
          };
        });
      } catch {
        // 저장조건 미존재/조회 실패 시 기본값 유지 (console 금지 룰)
      }
    },
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    setFilter: () => {
      // 키명 = PROC_M COL_NM (P2 ALL_ARGUMENTS 실측 — sesUserId(P_CREATED_BY) BE 자동주입 제외).
      //   userGroup(P_USER_GROUP) = 세션 userId fallback (AS-IS p_user_group=NowGroupID 용법 —
      //   DMF0044 SP 는 GET_ADMIN_GROUP lookup 미사용 실측, 그룹 문자열 그대로 전달).
      const sesUserId = useSessionStore.getState().session.userId ?? '';
      // P_USER_GROUP — 세션 userId fallback (AS-IS NowGroupID 용법. EDIT_AUTH_V 가 그룹/유저 해석)
      const userGroup = sesUserId;
      set(state => {
        const c: SearchCondition = { ...initSearch, ...state.searchCondition };
        state.filters = {
          // ── PKG_DMF0044.P_DMF0044_GET_SALES_REPORTS_DATA (9 IN — 7 FE 전달) ──
          [SHEETS.MAIN]: {
            divisionId: c.divisionId, // 1
            mdfType: c.mdfType, // 2
            yyyy: c.yyyy, // 3
            // 4 United 팝업 주입 또는 직접 입력 (필수). trim 필수 — 직접 입력이라 앞뒤 공백이
            //   섞일 수 있는데 validateFind 는 trim 후 판정하므로 그대로 넘기면 통과한 뒤 0건이 된다.
            spVersionNo: c.versionNo.trim(),
            userGroup: userGroup, // 5 P_USER_GROUP (EDIT_AUTH_V 조인 — 세션 그룹)
            userId: sesUserId, // 7
            mnuId: MENU_ID, // 8
          },
          // ── DMF0044_GET_SPREAD_TITLE (4 IN — 선택연도 1/1~12/31, sesUserId BE주입) ──
          [SHEETS.SPREAD_TITLE]: {
            divisionId: c.divisionId,
            startDt: `${c.yyyy}0101`,
            endDt: `${c.yyyy}1231`,
            userId: sesUserId,
            mnuId: MENU_ID,
          },
          // ── PKG.P_DMF0044_GET_MEASURE (3 IN — 2행 블록 정의) ──
          [SHEETS.MEASURE]: {
            divisionId: c.divisionId,
            userId: sesUserId,
            mnuId: MENU_ID,
          },
        };
        state.thisMonth = dayjs().format('YYYYMM'); // 조회 시점 고정
        // ⭐ resultMonth 스냅샷 — Result 조회 시 전월 yyyymm (AS-IS L602~609) / Plan ''
        state.resultMonth =
          c.planResult === PLAN_RESULT.RESULT ? dayjs().subtract(1, 'month').format('YYYYMM') : '';
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

    // ⭐ master hook §2.3 — Column 동적 fetch (SHEET_COLUMNS 46건 'MDF Reports', hook #113 서버 직접 비교)
    fetchStaticColumns: async () => {
      try {
        const result = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          {
            sheetNm: SHEETS.MAIN, // 'MDF Reports' — 등록명 그대로 (룰 #91)
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

    // ⭐ master hook §5 — Measure 동적 fetch (SHEET_MEASURE 18건 — Measure Select 팝업 대상)
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
        // silent — 하드코딩 fallback 금지
      }
    },

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

    // ⭐ ColumnLayoutModal OK — 표시/순서 + 폭/색 개인화 적용 (DMF0003 방식 교체 2026-07-30).
    applyColumnLayout: settings => {
      set(state => {
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
    applyVisibleMeasures: measureCodes => {
      set(state => {
        state.visibleMeasures = measureCodes;
      });
    },
  }),
  'sales-reports'
);
