import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS, TAB_INDEX } from './project-reg.constants';
import type { AuthRegTarget, MyWorkTarget, SearchCondition } from './project-reg.types';

// SP filter payload — useTabProcQuery enabled 가드 (store 보관 참조만 전달 — 인라인 객체 금지)
type FiltersBySheet = {
  [SHEETS.TAB1]?: ProcRequest<MENU_ID, SHEETS.TAB1>;
  [SHEETS.TAB2]?: ProcRequest<MENU_ID, SHEETS.TAB2>;
};

// yyyymmdd → 'YYYY-MM-DD' (§5 TO_DATE(SUBSTR(p,1,10),'YYYY-MM-DD') 계약. 빈 값 = '' 그대로 —
//   REG_COMP_DATE NULL 행(미완료) 포함 전체 조회. 한쪽만 빈 값은 validate 가 선차단)
const ymdToDash = (ymd: string): string =>
  /^\d{8}$/.test(ymd) ? `${ymd.slice(0, 4)}-${ymd.slice(4, 6)}-${ymd.slice(6, 8)}` : '';

interface State {
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  openSearchArea: boolean;
  activeTab: TAB_INDEX;
  // admin SHEET_COLUMNS 동적 메타 — 시트별 (컬럼명 배열 하드코딩 금지. 조회 결과 data 는 저장하지 않는다)
  staticColumns: Partial<Record<SHEETS, RawFlexGridColumnConfig[]>>;
  // 모달 open 상태 + 대상 행 키
  authRegTarget: AuthRegTarget | null;
  myWorkTarget: MyWorkTarget | null;
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
  openMyWorkModal: (target: MyWorkTarget) => void;
  closeMyWorkModal: () => void;
}

// 기본 조회조건 — Division 은 MyDivision 첫 값 자동 보정(페이지 레벨) / 콤보 3종 = 'ALL' 단일 선택
//   (§5 등호 매칭 계약) / 등록 완료일 = period 시트(§15 GET_PERIOD) 수신 후 세팅 ('' = 미수신)
const initSearch: SearchCondition = {
  divisionId: '',
  endCustomer: 'ALL',
  dpjtAuthType: 'ALL',
  dpjtRegStatus: 'ALL',
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
  myWorkTarget: null,
};

export const useProjectRegStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // 키명 = PROC_M COL_NM (sesUserId/mnuId 는 BE 세션 자동주입 — payload 미포함)
    setFilter: sheet => {
      set(state => {
        const c: SearchCondition = { ...initSearch, ...state.searchCondition };
        if (sheet === SHEETS.TAB1) {
          // ⭐ TAB1 §1 = 본인(MGMT_USER_ID=sesUserId) 관리 프로젝트만 서버 필터 — 조회조건 비노출.
          //   sesDivisionId(주석 처리)·userGroup(P_SES_USER_GR_ID — 본문 미사용)은 시그니처 충족용 ''
          //   (계약 결정 4 · §18-8 미사용 파라미터도 PROC_M 등재분은 바인딩 필수)
          state.filters[SHEETS.TAB1] = { sesDivisionId: '', userGroup: '' };
        } else {
          // ⭐ TAB2 §5 — 콤보 = 값 OR 'ALL' 등호 매칭 (콤마 다중 불가 — 단일 선택 콤보) /
          //   기간 'YYYY-MM-DD' (둘 다 빈 값 = 전체 · REG_COMP_DATE NULL 미완료 행 포함)
          state.filters[SHEETS.TAB2] = {
            divisionId: c.divisionId,
            endCustomer: c.endCustomer || 'ALL',
            dpjtAuthType: c.dpjtAuthType || 'ALL',
            dpjtRegStatus: c.dpjtRegStatus || 'ALL',
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
    openMyWorkModal: target =>
      set(state => {
        state.myWorkTarget = target;
      }),
    closeMyWorkModal: () =>
      set(state => {
        state.myWorkTarget = null;
      }),
  }),
  // ⭐ persist 키 v2 — SearchCondition 형상 변경(다중배열→단일 'ALL' 문자열, 신본 계약)으로
  //   구본 persist 잔존값과의 충돌 차단 (구 키 'project-reg' 는 자연 소멸)
  'project-reg-v2'
);
