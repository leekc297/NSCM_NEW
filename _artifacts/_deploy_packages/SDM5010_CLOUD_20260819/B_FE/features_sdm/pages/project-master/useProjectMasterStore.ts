import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import type { AuthRegTarget } from '../../components/ProjectAuthRegModal';
import { MENU_ID, SHEETS, TAB_INDEX } from './project-master.constants';
import type { SearchCondition } from './project-master.types';
import { toMultiParam, ymdToDash } from './utils/project-master.validate';

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
  // 권한관리 모달 (SDM1010 공용 승격분 — F-22) open 상태 + 대상 행 키
  authRegTarget: AuthRegTarget | null;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: (sheet: SHEETS.TAB1 | SHEETS.TAB2) => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setActiveTab: (tab: TAB_INDEX) => void;
  fetchStaticColumns: (sheets: SHEETS[]) => Promise<void>;
  openAuthRegModal: (target: AuthRegTarget) => void;
  closeAuthRegModal: () => void;
}

// 기본 조회조건 — Division 은 MyDivision 첫 값 자동 보정(페이지 레벨 CF-01) / 멀티 4종 = [] (ALL) /
//   등록 완료일 = period 시트 수신 후 M-1~Today 세팅 ('' = 미수신, E01-2)
const initSearch: SearchCondition = {
  divisionId: '',
  endCustomers: [],
  cellTypes: [],
  bizTypes: [],
  developStatuses: [],
  regCompDateFr: '',
  regCompDateTo: '',
};

const initState: State = {
  filters: {},
  searchCondition: initSearch,
  openSearchArea: true,
  activeTab: TAB_INDEX.TAB1,
  staticColumns: {},
  authRegTarget: null,
};

export const useProjectMasterStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
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
          try {
            const result = await apiClient.post<RawFlexGridColumnConfig[]>(
              `/admin/menu/${MENU_ID}/column`,
              { sheetNm: sheet, divisionId }
            );
            set(state => {
              state.staticColumns[sheet] = result.data.result ?? [];
            });
          } catch {
            // BE 메타 미응답 시 silent — 기존 배열 유지 (console 금지 룰 · 하드코딩 fallback 금지)
          }
        })
      );
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
