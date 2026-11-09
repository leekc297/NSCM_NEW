import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './scp-if-blocking.constants';
import type { ScpIfBlockingSearch } from './scp-if-blocking.types';

interface State {
  initialized: boolean;
  search: ScpIfBlockingSearch;
  filters?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  staticColumns: RawFlexGridColumnConfig[];
  isOpenSearchArea: boolean;
  // Period 기본값(PERIOD_DEFAULT) 1회 적용 가드 — 이후 사용자 입력 보존 (design 02 §5, DMF0014 패턴).
  periodApplied: boolean;
}

interface Action {
  reset: () => void;
  setSearch: (p: Partial<ScpIfBlockingSearch>) => void;
  setFilters: () => void;
  clearFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
  applyPeriodDefault: (from: string, to: string) => void;
}

const initSearch: ScpIfBlockingSearch = {
  divisionIds: [],
  fromYyyymmdd: '',
  toYyyymmdd: '',
};

const initState: State = {
  initialized: false,
  search: initSearch,
  filters: undefined,
  staticColumns: [],
  isOpenSearchArea: true,
  periodApplied: false,
};

// 날짜 문자열 → YYYYMMDD 8자리(숫자만). drpPeriod `-` 제거 등가 (design 02 §5).
const toYmd = (v: string): string => v.replace(/\D/g, '').slice(0, 8);

export const useScpIfBlockingStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearch: p =>
      set(state => {
        state.search = { ...get().search, ...p };
      }),
    // 조회 필터 확정 — setFilter 참조 교체로 useTabProcQuery 자동 발사(refetch 직접호출 금지, nscm-patterns §5-1).
    //   p_division_id = 체크 CODE CSV(배열 금지, SRCH-06) / p_from·to_yyyymmdd(8자리) / language(@sesLangCd).
    //   미선택(빈 배열)은 join('') 빈 문자열이 아니라 'ALL' 센티널로 보낸다 — GET SP 는 빈 문자열을
    //   "매칭 division 없음"(0건)으로 보고 'ALL' 토큰일 때만 전체조회(V_DIV_ALL='Y')한다. 다중+ALL 공통 규약
    //   (SSP0003 선례, [[material-by-division-modal-all-sentinel]]). AS-IS ALL 선택 = 전체 CODE 열거와 등가.
    setFilters: () => {
      const { divisionIds, fromYyyymmdd, toYyyymmdd } = get().search;
      set(state => {
        state.filters = {
          divisionId: divisionIds.length > 0 ? divisionIds.join(',') : 'ALL',
          fromYyyymmdd: toYmd(fromYyyymmdd),
          toYyyymmdd: toYmd(toYyyymmdd),
          language: useSessionStore.getState().session.langCd ?? '',
        };
      });
    },
    clearFilters: () =>
      set(state => {
        state.filters = undefined;
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      }),
    applyPeriodDefault: (from, to) => {
      if (get().periodApplied) return;
      set(state => {
        state.search = { ...state.search, fromYyyymmdd: toYmd(from), toYyyymmdd: toYmd(to) };
        state.periodApplied = true;
      });
    },
    // admin SCM_MST_SHEET_COLUMNS 동적 fetch + F6 개인화 조회조건 복원(mount 1회).
    //   미등록/실패 시 컬럼은 빈 배열(하드코딩 fallback 금지).
    //   복원 대상은 Division(divisionIds) 뿐 — Period(from/to Yyyymmdd)는 공용 personalizeCondition 이
    //   EXCLUDED_DATE_PARAM 로 저장 제외하므로 복원값도 없다(매 진입 PERIOD_DEFAULT 기본값 유지).
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] }
        );
        const next = res.data.result ?? [];
        set(state => {
          if (JSON.stringify(state.staticColumns) !== JSON.stringify(next)) {
            state.staticColumns = next;
          }
        });
      } catch {
        // 미등록/실패 = 빈 배열 유지 (console 금지 룰)
      }

      // 저장된 조회조건 복원 — 최초 1회(initialized 가드). GET /search-conditions 의 divisionIds(CSV)만
      //   배열로 되돌려 search 에 세팅. 저장 SP 가 날짜 조건을 제외하므로 Period 복원 대상은 없다.
      if (!get().initialized) {
        try {
          const saved = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
            `/admin/menu/${MENU_ID}/search-conditions`
          );
          const divisionRow = (saved.data.result ?? []).find(p => p.paramNm === 'divisionIds');
          const ids = divisionRow?.paramCtn.split(',').filter(Boolean) ?? [];
          if (ids.length > 0) {
            set(state => {
              state.search = { ...state.search, divisionIds: ids };
            });
          }
        } catch {
          // 복원 실패 무시 — 저장 이력 없음/BE 오류 시 기본값 유지
        }
      }

      set(state => {
        state.initialized = true;
      });
    },
  }),
  'scp-if-blocking'
);
