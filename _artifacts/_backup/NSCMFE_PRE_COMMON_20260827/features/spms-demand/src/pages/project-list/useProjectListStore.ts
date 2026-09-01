import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { applyGridLayout, fetchGridLayout } from '@shared/components';
import { createPersistedStoreWithTab } from '@shared/stores';

import type { AuthManagementTarget } from '../../components/auth-management-popup';

import { MENU_ID, SHEETS } from './project-list.constants';
import type { SearchCondition } from './project-list.types';
import { defaultRegCompRange, toMultiParam, ymdToDash } from './utils/project-list.validate';
import { toText } from './utils/project-list.value';

// SP filter payload — useTabProcQuery enabled 가드 (store 보관 참조만 전달 — 인라인 객체 금지)
// PROJECT(MAIN) 확정된 조회조건
// 실제 SP 로 넘어가는 파라미터 모양(아래 시트별 filter action 참고)
type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

interface State {
  initialized: boolean;
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  staticColumns: Partial<Record<SHEETS, RawFlexGridColumnConfig[]>>;
  /** SearchArea 열림/닫힘 (MainTitle 우측 토글) */
  openSearchArea: boolean;
  // admin SHEET_COLUMNS 동적 메타 — 시트별 (컬럼명 배열 하드코딩 금지. 조회 결과 data 는 저장하지 않는다)
  //staticColumns: Partial<Record<SHEETS, RawFlexGridColumnConfig[]>>;
  // 권한관리 모달 (SDM1010 공용 승격분) open 상태 + 대상 행 키
  authRegTarget: AuthManagementTarget | null;
  columnSettingOpen: boolean;
}

interface Action {
  reset: () => void;
  /** TAB1 즉시 조회/F5 — 사업부·사용자 조건만 PROJECT filter 로 확정한다 */
  setFilter: () => void;
  clearFilters: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  //setSearchParams: (p: Partial<SearchParamProps>) => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: (sheets: SHEETS[]) => Promise<void>;
  openAuthRegModal: (target: AuthManagementTarget) => void;
  closeAuthRegModal: () => void;
  setColumnSettingOpen: (open: boolean) => void;
}

// 기본 조회조건 (P-27) — Division 은 MyDivision 첫 값 자동 보정(페이지 레벨) / 멀티 3종 = 'ALL' /
//   등록 완료일 = period 시트 수신 후 M-1~Today 세팅 ('' = 미수신)
const initSearch: SearchCondition = {
  divisionId: '',
  endCustomers: 'ALL',
  dpjtAuthTypes: 'ALL',
  dpjtRegStatuses: 'ALL',
  regCompDateFr: '',
  regCompDateTo: '',
};

const resetSearch = (): SearchCondition => {
  const { fr, to } = defaultRegCompRange(undefined);
  return { ...initSearch, regCompDateFr: fr, regCompDateTo: to };
};

const initState: State = {
  initialized: false,
  filters: {},
  searchCondition: initSearch,
  openSearchArea: true,
  staticColumns: {},
  authRegTarget: null,
  columnSettingOpen: false,
};

export const useProjectListStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () =>
      set(state => {
        state.filters = {};
        state.searchCondition = resetSearch();
        state.openSearchArea = true;
        state.authRegTarget = null;
        state.columnSettingOpen = false;
      }),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...state.searchCondition, ...p };
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
            const [result, layout] = await Promise.all([
              apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
                sheetNm: sheet,
                divisionId,
              }),
              fetchGridLayout({
                menuId: MENU_ID,
                sheetName: sheet,
                columnType: 'C',
                divisionId,
              }),
            ]);
            set(state => {
              state.staticColumns[sheet] = applyGridLayout(result.data.result ?? [], layout);
            });
          } catch {
            // BE 메타 미응답 시 silent — 기존 배열 유지 (console 금지 룰 · 하드코딩 fallback 금지)
          }
        })
      );
      if (get().initialized) return;

      let restoredDivision = '';
      try {
        const response = await apiClient.get<
          { paramNm: keyof SearchCondition; paramCtn: string }[]
        >(`/admin/menu/${MENU_ID}/search-conditions`);
        const restored = (response.data.result ?? []).reduce(
          (acc, { paramNm, paramCtn }) => {
            if (!(paramNm in initSearch)) return acc;
            acc[paramNm] =
              paramNm === 'endCustomers' ||
              paramNm === 'dpjtAuthTypes' ||
              paramNm === 'dpjtRegStatuses'
                ? toMultiParam(toText(paramCtn))
                : toText(paramCtn);
            return acc;
          },
          {} as Partial<Record<keyof SearchCondition, string>>
        );
        restoredDivision = restored.divisionId ?? '';
        if (Object.keys(restored).length > 0) {
          set(state => {
            state.searchCondition = { ...state.searchCondition, ...restored };
          });
        }
      } catch {
        // 저장된 조회조건이 없거나 조회에 실패하면 현재 기본값을 유지한다.
      } finally {
        set(state => {
          state.initialized = true;
        });
      }

      if (restoredDivision && restoredDivision !== divisionId) {
        await get().fetchStaticColumns(sheets);
      }
    },

    openAuthRegModal: target =>
      set(state => {
        state.authRegTarget = target;
      }),
    closeAuthRegModal: () =>
      set(state => {
        state.authRegTarget = null;
      }),
    setColumnSettingOpen: open =>
      set(state => {
        state.columnSettingOpen = open;
      }),
  }),
  'project-list'
);
