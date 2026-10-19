import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import type { AuthRegTarget } from '../../components/ProjectAuthRegModal';

import { MENU_ID, SHEETS } from './project-list.constants';
import type { SearchCondition } from './project-list.types';
import { toMultiParam, ymdToDash } from './utils/project-list.validate';

// SP filter payload — useTabProcQuery enabled 가드 (store 보관 참조만 전달 — 인라인 객체 금지)
type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

interface State {
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  openSearchArea: boolean;
  // admin SHEET_COLUMNS 동적 메타 — 시트별 (컬럼명 배열 하드코딩 금지. 조회 결과 data 는 저장하지 않는다)
  staticColumns: Partial<Record<SHEETS, RawFlexGridColumnConfig[]>>;
  // 권한관리 모달 (SDM1010 공용 승격분) open 상태 + 대상 행 키
  authRegTarget: AuthRegTarget | null;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: (sheets: SHEETS[]) => Promise<void>;
  openAuthRegModal: (target: AuthRegTarget) => void;
  closeAuthRegModal: () => void;
}

// 기본 조회조건 (P-27) — Division 은 MyDivision 첫 값 자동 보정(페이지 레벨) / 멀티 3종 = [] (ALL) /
//   등록 완료일 = period 시트 수신 후 M-1~Today 세팅 ('' = 미수신)
const initSearch: SearchCondition = {
  divisionId: '',
  endCustomers: [],
  dpjtAuthTypes: [],
  dpjtRegStatuses: [],
  regCompDateFr: '',
  regCompDateTo: '',
};

const initState: State = {
  filters: {},
  searchCondition: initSearch,
  openSearchArea: true,
  staticColumns: {},
  authRegTarget: null,
};

export const useProjectListStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // 키명 = PROC_M COL_NM (계약 ① — sesUserId/mnuId 는 BE 세션 자동주입, payload 미포함)
    setFilter: () => {
      set(state => {
        const c: SearchCondition = { ...initSearch, ...state.searchCondition };
        // 멀티 3종 = 콤마 연결 or 'ALL' 무필터 센티널 (UC-06 — SP UF_FX_STRING_SPLIT 테이블화 실측) /
        //   기간 = 'YYYY-MM-DD' (SP TO_DATE(SUBSTR(p,1,10),'YYYY-MM-DD') — 필수라 항상 전달)
        state.filters[SHEETS.MAIN] = {
          divisionId: c.divisionId,
          endCustomer: toMultiParam(c.endCustomers),
          dpjtAuthType: toMultiParam(c.dpjtAuthTypes),
          dpjtRegStatus: toMultiParam(c.dpjtRegStatuses),
          regCompDateFr: ymdToDash(c.regCompDateFr),
          regCompDateTo: ymdToDash(c.regCompDateTo),
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

    // ⭐ master hook §2.3 — Column 동적 fetch (SHEET_COLUMNS — 시트별. hook #113 서버 직접 비교.
    //   Division 종속 컬럼 축(계약 ④ — X/Y열 분기는 FE/SP 처리·메타 DIVISION_ID=NULL)도 동일 경로)
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
  'project-list'
);
