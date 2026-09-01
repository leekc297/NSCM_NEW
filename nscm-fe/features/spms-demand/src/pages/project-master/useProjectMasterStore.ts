import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { fetchTitleSet } from '@shared/components';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import type { AuthManagementTarget } from '../../components/auth-management-popup';

import { MENU_ID, SHEETS, TAB_INDEX } from './project-master.constants';
import type { SearchCondition } from './project-master.types';
import { defaultRegCompDates, toMultiParam, ymdToDash } from './utils/project-master.validate';

type ColumnSheetName = SHEETS.TAB1 | SHEETS.TAB2;

export interface ColumnLayoutSetting {
  colNm: string;
  visible: boolean;
  width: number;
  cellColor: string;
  textColor: string;
  order: number;
}

const DEFAULT_COL_WIDTH = 100;

const applyLayoutToColumns = (
  cols: RawFlexGridColumnConfig[],
  settings: ColumnLayoutSetting[]
): RawFlexGridColumnConfig[] => {
  const byCol = new Map(settings.map(s => [s.colNm, s]));
  return cols
    .map(c => {
      const s = byCol.get(c.colNm);
      if (!s) return c;
      return {
        ...c,
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

// SP filter payload — useTabProcQuery enabled 가드 (store 보관 참조만 전달 — 인라인 객체 금지)
type FiltersBySheet = {
  [SHEETS.TAB1]?: ProcRequest<MENU_ID, SHEETS.TAB1>;
  [SHEETS.TAB2]?: ProcRequest<MENU_ID, SHEETS.TAB2>;
};

interface State {
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  openSearchArea: boolean;
  activeTab: TAB_INDEX;
  // admin SHEET_COLUMNS 동적 메타 — 시트별 (컬럼명 배열 하드코딩 금지. 조회 결과 data 는 저장하지 않는다)
  staticColumns: Partial<Record<SHEETS, RawFlexGridColumnConfig[]>>;
  originalStaticColumns: Partial<Record<ColumnSheetName, RawFlexGridColumnConfig[]>>;
  userColumnLayout: Record<ColumnSheetName, ColumnLayoutSetting[] | null>;
  // 권한관리 모달 (SDM1010 공용 승격분 — F-22) open 상태 + 대상 행 키
  authRegTarget: AuthManagementTarget | null;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: (sheet: SHEETS.TAB1 | SHEETS.TAB2) => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setActiveTab: (tab: TAB_INDEX) => void;
  fetchStaticColumns: (sheets: ColumnSheetName[]) => Promise<void>;
  applyColumnLayout: (sheetName: ColumnSheetName, settings: ColumnLayoutSetting[]) => void;
  fetchUserColumnLayout: (sheetName: ColumnSheetName) => Promise<ColumnLayoutSetting[] | null>;
  openAuthRegModal: (target: AuthManagementTarget) => void;
  closeAuthRegModal: () => void;
}

// 기본 조회조건 — Division 은 MyDivision 첫 값 자동 보정(페이지 레벨 CF-01) / 멀티 4종 = [] (ALL) /
//   등록 완료일 = M-1(한 달 전 같은 날)~Today (FE dayjs 직접 산출 — period 시트 앵커 소비 폐기)
const initSearch: SearchCondition = {
  divisionId: useSessionStore.getState().session.div ?? '',
  endCustomers: [],
  cellTypes: [],
  bizTypes: [],
  developStatuses: [],
  regCompDateFr: '',
  regCompDateTo: '',
};

const resetSearch = (): SearchCondition => {
  const { fr, to } = defaultRegCompDates();
  return { ...initSearch, regCompDateFr: fr, regCompDateTo: to };
};

const initState: State = {
  filters: {},
  searchCondition: resetSearch(),
  openSearchArea: true,
  activeTab: TAB_INDEX.TAB1,
  staticColumns: {},
  originalStaticColumns: {},
  userColumnLayout: {
    [SHEETS.TAB1]: null,
    [SHEETS.TAB2]: null,
  },
  authRegTarget: null,
};

export const useProjectMasterStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set({ ...initState, searchCondition: resetSearch() }),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // 키명 = PROC_M COL_NM (계약 ① — sesUserId/mnuId 는 BE 세션 자동주입, payload 미포함)
    setFilter: sheet => {
      set(state => {
        const c: SearchCondition = { ...initSearch, ...state.searchCondition };
        if (sheet === SHEETS.TAB1) {
          // ⭐ TAB1 = Session 기반 본인 필터 (F-3/P-04 — 조회조건 미소비. SP WHERE 가
          //   P_SES_DIVISION_ID 를 실사용하므로 조회조건 Division(사용자 권한 축)을 전달.
          //   userGroup(P_SES_USER_GR_ID)은 수신만·본문 미사용(D7) — 시그니처 충족용 '')
          state.filters[SHEETS.TAB1] = { sesDivisionId: c.divisionId, userGroup: '' };
        } else {
          // ⭐ TAB2 (CF-09) — 멀티 4종 = 콤마 연결 or 'ALL' 무필터 센티널 (UC-06 —
          //   SP UF_FX_STRING_SPLIT 테이블화) / 기간 = 'YYYY-MM-DD' (REG_COMP_DATE BETWEEN — F-2)
          state.filters[SHEETS.TAB2] = {
            divisionId: c.divisionId,
            endCustomer: toMultiParam(c.endCustomers),
            cellType: toMultiParam(c.cellTypes),
            bizType: toMultiParam(c.bizTypes),
            dpjtDevelopStatus: toMultiParam(c.developStatuses),
            regCompDateFr: ymdToDash(c.regCompDateFr),
            regCompDateTo: ymdToDash(c.regCompDateTo),
          };
        }
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
    setActiveTab: tab =>
      set(state => {
        state.activeTab = tab;
      }),

    // ⭐ master hook §2.3 — Column 동적 fetch (SHEET_COLUMNS — 시트별. hook #113 서버 직접 비교)
    fetchStaticColumns: async sheets => {
      const divisionId = get().searchCondition.divisionId;
      await Promise.all(
        sheets.map(async sheet => {
          if (get().userColumnLayout[sheet] === null) {
            await get().fetchUserColumnLayout(sheet);
          }
          try {
            const result = await apiClient.post<RawFlexGridColumnConfig[]>(
              `/admin/menu/${MENU_ID}/column`,
              { sheetNm: sheet, divisionId }
            );
            set(state => {
              const fetched = result.data.result ?? [];
              state.originalStaticColumns[sheet] = fetched;
              const layout = state.userColumnLayout[sheet];
              state.staticColumns[sheet] =
                layout && layout.length > 0 ? applyLayoutToColumns(fetched, layout) : fetched;
            });
          } catch {
            // BE 메타 미응답 시 silent — 기존 배열 유지 (console 금지 룰 · 하드코딩 fallback 금지)
          }
        })
      );
    },

    applyColumnLayout: (sheetName, settings) => {
      set(state => {
        const shown = settings
          .filter(s => s.visible)
          .sort((a, b) => a.order - b.order)
          .map((s, i) => ({ ...s, order: i + 1 }));
        const hidden = settings
          .filter(s => !s.visible)
          .map(s => ({ ...s, order: Number.MAX_SAFE_INTEGER }));
        const layout = [...shown, ...hidden];
        state.userColumnLayout[sheetName] = layout;
        const current = state.staticColumns[sheetName];
        if (!current || current.length === 0) return;
        state.staticColumns[sheetName] = applyLayoutToColumns(current, layout);
      });
    },

    fetchUserColumnLayout: async sheetName => {
      const rows = await fetchTitleSet({
        menuId: MENU_ID,
        sheetName,
        columnType: 'C',
        divisionId:
          get().searchCondition.divisionId || useSessionStore.getState().session.div || '',
      });
      if (!rows || rows.length === 0) return null;
      const isShown = (row: Record<string, string>) =>
        String(row.USER_FLAG ?? row.DEFAULT_FLAG ?? 'Y')
          .trim()
          .toUpperCase() === 'Y';
      const orderOf = (row: Record<string, string>) =>
        Number(row.USER_SORT_ORDER_NO ?? row.SORT_ORDER_NO ?? 0);
      const toSetting = (
        row: Record<string, string>,
        order: number,
        visible: boolean
      ): ColumnLayoutSetting => {
        const width = Number(row.USER_COLUMN_WIDTH ?? row.COLUMN_WIDTH ?? 0);
        return {
          colNm: String(row.COLUMN_NAME ?? ''),
          visible,
          width: Number.isFinite(width) && width > 0 ? width : DEFAULT_COL_WIDTH,
          cellColor: String(row.CELL_COLOR ?? ''),
          textColor: String(row.TEXT_COLOR ?? ''),
          order,
        };
      };
      const shown = rows
        .filter(isShown)
        .sort((a, b) => orderOf(a) - orderOf(b))
        .map((row, index) => toSetting(row, index + 1, true))
        .filter(setting => setting.colNm);
      const hidden = rows
        .filter(row => !isShown(row))
        .map(row => toSetting(row, Number.MAX_SAFE_INTEGER, false))
        .filter(setting => setting.colNm);
      if (shown.length === 0) return null;
      const layout = [...shown, ...hidden];
      set(state => {
        state.userColumnLayout[sheetName] = layout;
        const current = state.staticColumns[sheetName];
        if (current && current.length > 0) {
          state.staticColumns[sheetName] = applyLayoutToColumns(current, layout);
        }
      });
      return layout;
    },

    openAuthRegModal: target =>
      set(state => {
        state.authRegTarget = target;
      }),
    closeAuthRegModal: () =>
      set(state => {
        state.authRegTarget = null;
      }),
  }),
  'project-master'
);
