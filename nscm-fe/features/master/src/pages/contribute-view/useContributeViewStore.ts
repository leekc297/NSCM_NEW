import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import {
  MENU_ID,
  SHEETS,
  TITLESET_COLUMN_TYPE,
  TITLESET_DIVISION,
  TITLESET_SHEET,
} from './contribute-view.constants';
import type { ViewSearchCondition } from './types';

type StaticColumnsBySheet = {
  [key in SHEETS]?: RawFlexGridColumnConfig[];
};

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.MAIN_TITLE]?: ProcRequest<MENU_ID, SHEETS.MAIN_TITLE>;
  [SHEETS.VERSION]?: ProcRequest<MENU_ID, SHEETS.VERSION>;
};

/** ColumnLayoutModal 개인화 1행 — 표시/순서/폭/색 (mkt-fcst/forecast-price 선례 1:1). */
export interface ColumnLayoutSetting {
  colNm: string;
  visible: boolean;
  width: number;
  cellColor: string;
  textColor: string;
  order: number;
}

interface ContributeViewState {
  initialized: boolean;
  filters: FiltersBySheet;
  searchParams: ViewSearchCondition;
  // 개인화(ColumnLayoutModal) 가 반영된 BASE 컬럼 메타 — 그리드가 그대로 사용한다.
  staticColumns: StaticColumnsBySheet;
  // 개인화 적용 전 admin 메타 원본 — 팝업 Default 버튼의 원복 기준.
  //   staticColumns 는 개인화로 덮이므로 별도 스냅샷이 필요하다.
  originalStaticColumns: StaticColumnsBySheet;
  openSearchArea: boolean;
  versionPopupOpen: boolean; // AS-IS btnSPVer_Click (.cs L453)
  ratePopupOpen: boolean; // AS-IS btnCutOff_Click (.cs L444)
  columnSetPopupOpen: boolean; // AS-IS btnColumn_Click (.cs L473)
  // ColumnLayoutModal OK 결과 (null = 미설정) — 표시/순서 + 폭/색.
  //   fetchStaticColumns 재조회 후 재적용 기준.
  userColumnLayout: ColumnLayoutSetting[] | null;
  // Year SP 는 조회조건을 받지 않는다. store 필드로 참조를 고정해 다른 조회조건 변경 시
  // Year 콤보가 불필요하게 재조회되는 걸 막는다.
  noFilters: Record<string, never>;
}

interface ContributeViewAction {
  reset: () => void;
  setSearchParams: (params: Partial<ViewSearchCondition>) => void;
  setFilters: () => void;
  /**
   * 조회 filters 무효화 — useTabProcQuery 의 enabled=false + queryKey 변경으로 그리드가 비워진다.
   * 조회 결과가 현재 화면 설정과 어긋나는 순간(컬럼 설정 저장 등)에 호출한다. 재조회는 Search 로만.
   */
  clearFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
  setVersionPopupOpen: (open: boolean) => void;
  setRatePopupOpen: (open: boolean) => void;
  setColumnSetPopupOpen: (open: boolean) => void;
  /** ColumnLayoutModal onSave — 표시/순서/width/색상을 staticColumns 에 즉시 반영. */
  applyColumnLayout: (settings: ColumnLayoutSetting[]) => void;
  /**
   * 저장된 컬럼 개인화(titleSet) 복원 — fetchStaticColumns 가 await 후 메타에 적용.
   * 반환값 = 복원된 개인화(없으면 null).
   */
  fetchUserColumnLayout: () => Promise<ColumnLayoutSetting[] | null>;
}

const currentYear = new Date().getFullYear();

const initSearchParams: ViewSearchCondition = {
  yyyy: String(currentYear),
  verSeq: '',
  versionNo: '',
  divisionId: '40',
  endCustReport: '',
  productGroup: 'ALL',
  bizType: 'ALL',
  millionYn: 'N',
  compatibilityYn: 'N',
};

const initState: ContributeViewState = {
  initialized: false,
  filters: {},
  searchParams: initSearchParams,
  // ⚠️ hook #70 P1 — 그리드가 `?? []` fallback 없이 쓰도록 항상 배열을 보장한다.
  staticColumns: {
    [SHEETS.MAIN]: [],
  },
  originalStaticColumns: {
    [SHEETS.MAIN]: [],
  },
  openSearchArea: true,
  versionPopupOpen: false,
  ratePopupOpen: false,
  columnSetPopupOpen: false,
  userColumnLayout: null,
  noFilters: {},
};

// BE 가 폭을 안 내려줄 때의 기본 폭 (ColumnLayoutModal DEFAULT_COL_WIDTH 와 동일 계약).
const DEFAULT_COL_WIDTH = 100;

// ColumnLayoutModal 개인화 override — 표시/순서/폭/색을 admin 메타 위에 덧씌운다.
//   표시 게이트는 공용 DataGrid 의 `display` 지만, 화면 자체 필터(visible) 와도 어긋나지 않게 둘 다 세팅한다.
const applyLayoutToColumns = (
  cols: RawFlexGridColumnConfig[],
  settings: ColumnLayoutSetting[]
): RawFlexGridColumnConfig[] => {
  const byCol = new Map(settings.map(s => [s.colNm, s]));
  return cols
    .map(c => {
      const s = byCol.get(c.colNm);
      // 개인화 목록에 없는 컬럼 = 사용자가 비표시로 저장한 것.
      if (!s) return { ...c, visible: false, display: false };
      return {
        ...c,
        visible: s.visible,
        display: s.visible,
        colWth: s.width || DEFAULT_COL_WIDTH,
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

export const useContributeViewStore = createPersistedStoreWithTab<
  ContributeViewState & ContributeViewAction
>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchParams: params => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...params };
      });
    },
    // AS-IS FindData (.cs L283) 의 SP 파라미터 전체 매핑
    setFilters: () => {
      set(state => {
        const c = state.searchParams;
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: c.divisionId,
            verSeq: c.verSeq,
            versionNo: c.versionNo,
            endCustReport: c.endCustReport,
            productGroup: c.productGroup,
            bizType: c.bizType,
            millionYn: c.millionYn,
            compatibilityYn: c.compatibilityYn,
          },
          // AS-IS InitSpread (.cs L146): p_division_id = '40'
          [SHEETS.MAIN_TITLE]: { divisionId: c.divisionId },
        };
      });
    },
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    // admin SHEET_COLUMNS (UI Category Setup) 동적 fetch — VISIBLE/WIDTH/ALIGN 즉시 반영.
    // BE endpoint: POST /admin/menu/{programId}/column with body { sheetNm }.
    // SHEET_COLUMNS 의 PROGRAM_ID='DMF0043_01' 자체 row 9 (LRG=NULL → wrapper TWO_DEPTH 정합).
    fetchStaticColumns: async () => {
      const main = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        { sheetNm: TITLESET_SHEET }
      );

      // ⭐ 진입 시 개인화 복원 — 저장된 titleSet 을 먼저 조회해 override 를 확보한 뒤 메타에 적용.
      //   (별도 effect 로 분리하면 메타 응답과 순서 경쟁 → 늦게 온 쪽이 덮어쓰는 사고.)
      //   이미 있으면(모달 OK 직후 재조회) 서버 재조회 없이 그 값을 유지.
      if (get().userColumnLayout === null) await get().fetchUserColumnLayout();

      set(state => {
        const fetched = main.data.result ?? [];
        // 개인화 적용 전 원본 보관 — 팝업 Default 원복 기준 (개인화로 덮이지 않는다).
        state.originalStaticColumns = { [SHEETS.MAIN]: fetched };
        // 사용자 컬럼설정(OK) 이후 재조회가 선택을 덮지 않도록 override 재적용.
        const layout = get().userColumnLayout;
        state.staticColumns = {
          [SHEETS.MAIN]:
            layout && layout.length > 0 ? applyLayoutToColumns(fetched, layout) : fetched,
        };
        state.initialized = true;
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      });
    },
    setVersionPopupOpen: open =>
      set(state => {
        state.versionPopupOpen = open;
      }),
    setRatePopupOpen: open =>
      set(state => {
        state.ratePopupOpen = open;
      }),
    setColumnSetPopupOpen: open =>
      set(state => {
        state.columnSetPopupOpen = open;
      }),
    // ⭐ 저장된 컬럼 개인화 복원 — ColumnLayoutModal 이 쓰는 SP 와 동일 계약
    //   (DMF0002_GET_TITLESET_POPUP). 조회 키는 팝업·저장과 반드시 같은 상수를 쓴다.
    //   USER_FLAG='Y' 행 = 사용자가 표시로 저장한 컬럼. 저장 이력이 없으면 null → admin 기본값 그대로.
    //   ⚠️ SP 는 관리자 기본값(COLUMN_WIDTH/SORT_ORDER_NO)과 사용자값(USER_* 별칭)을 따로 내려준다 —
    //     사용자값을 우선하지 않으면 저장한 폭/순서가 영원히 안 보인다.
    fetchUserColumnLayout: async () => {
      try {
        const res = await apiClient.post<{ o_rc1?: Record<string, string>[] }>(
          `${MENU_ID}/titleSet/SEARCH/call-proc`,
          {
            programId: MENU_ID,
            sheetName: TITLESET_SHEET,
            columnType: TITLESET_COLUMN_TYPE,
            divisionId: TITLESET_DIVISION,
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
            state.staticColumns = { [SHEETS.MAIN]: applyLayoutToColumns(cur, layout) };
          }
        });
        return layout;
      } catch {
        // 개인화 조회 실패 = 기본 컬럼 세트로 동작 (화면 차단 금지, console 금지 룰)
        return null;
      }
    },

    // ColumnLayoutModal OK — 표시/순서/폭/색을 grid 에 즉시 반영.
    //   서버 영구 저장은 화면(ContributeView.onSave)의 saveTitleSet 이 담당한다.
    applyColumnLayout: settings =>
      set(state => {
        // 표시 컬럼만 보관 — fetchStaticColumns 재조회 후 재적용 기준.
        const layout = settings
          .filter(s => s.visible)
          .sort((a, b) => a.order - b.order)
          .map((s, i) => ({ ...s, order: i + 1 }));
        state.userColumnLayout = layout;
        const cur = state.staticColumns[SHEETS.MAIN];
        if (!cur || cur.length === 0) return;
        state.staticColumns = { [SHEETS.MAIN]: applyLayoutToColumns(cur, layout) };
      }),
  }),
  'contribute-view'
);
