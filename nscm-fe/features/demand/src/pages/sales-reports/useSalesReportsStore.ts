import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { DATA_TYPE, DIVISION, MENU_ID, REPORT_TYPE, SHEETS } from './sales-reports.constants';
import type { SearchCondition } from './sales-reports.types';

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
}

interface Action {
  reset: () => void;
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

/** "조회한" 조건 스냅샷 — 편집·저장 게이트의 단일 기준 (조회조건 폼과 구분). */
export interface SearchedCondition {
  hasSearched: boolean;
  divisionId: string;
  mdfType: string;
  yyyy: string;
  versionNo: string;
  dataType: string;
}

// filters[MAIN] = Search 클릭 시점에 setFilter() 가 굳힌 스냅샷이라 조회조건 폼(searchCondition)을
//   바꿔도 움직이지 않는다. 게이트는 이 값만 본다.
//   금지: 편집/저장 게이트에 searchCondition 을 직접 쓰지 말 것 — ALL 로 조회한 뒤 Data Type 콤보만
//   바꿔도 재조회 없이 그리드가 편집 가능해진다(2026-08-12 사고).
//   미조회 상태는 dataType='ALL' = 전면 잠금으로 떨어뜨린다(게이트0 기본값).
export const resolveSearchedCondition = (
  mainFilter: ProcRequest<MENU_ID, SHEETS.MAIN> | undefined
): SearchedCondition =>
  mainFilter
    ? {
        hasSearched: true,
        divisionId: mainFilter.divisionId,
        mdfType: mainFilter.mdfType,
        yyyy: mainFilter.yyyy,
        versionNo: mainFilter.spVersionNo,
        dataType: mainFilter.dataType,
      }
    : {
        hasSearched: false,
        divisionId: '',
        mdfType: '',
        yyyy: '',
        versionNo: '',
        dataType: DATA_TYPE.ALL,
      };

const initSearch: SearchCondition = {
  divisionId: DIVISION.MOBILITY,
  mdfType: REPORT_TYPE.SP_W, // 기본 Report Type (AS-IS clbType MDF_TYPE 첫 항목)
  yyyy: dayjs().format('YYYY'), // 기본 당해년 (AS-IS usrYear 기본값)
  dataType: DATA_TYPE.ALL, // 기본 ALL (편집 차단 상태 — AS-IS usrDataType 기본)
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
};

export const useSalesReportsStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    setFilter: () => {
      // 키명 = PROC_M COL_NM (P2 ALL_ARGUMENTS 실측 — sesUserId(P_CREATED_BY) BE 자동주입 제외).
      //   userGroup(P_USER_GROUP) = 세션 userId fallback (AS-IS p_user_group=NowGroupID 용법 —
      //   DMF0044 SP 는 GET_ADMIN_GROUP lookup 미사용 실측, 그룹 문자열 그대로 전달).
      const sesUserId = useSessionStore.getState().session.userId ?? '';
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
            dataType: c.dataType, // 5
            userGroup: sesUserId, // 6 P_USER_GROUP
            userId: sesUserId, // 8
            mnuId: MENU_ID, // 9
          },
          // ── DMF0044_GET_SPREAD_TITLE (4 IN — 선택연도 1/1~12/31, sesUserId BE주입) ──
          [SHEETS.SPREAD_TITLE]: {
            divisionId: c.divisionId,
            startDt: `${c.yyyy}0101`,
            endDt: `${c.yyyy}1231`,
          },
          // ── PKG.P_DMF0044_GET_MEASURE (3 IN — 2행 블록 정의) ──
          [SHEETS.MEASURE]: {
            dataType: c.dataType,
            userId: sesUserId,
            mnuId: MENU_ID,
          },
        };
        state.thisMonth = dayjs().format('YYYYMM'); // 조회 시점 고정
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
