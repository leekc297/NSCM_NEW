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
  applyVisibleMeasures: (measureCodes: string[] | null) => void;
}

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
            spVersionNo: c.versionNo, // 4 ⭐ United 팝업 주입 (필수)
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

    applyVisibleMeasures: measureCodes => {
      set(state => {
        state.visibleMeasures = measureCodes;
      });
    },
  }),
  'sales-reports'
);
