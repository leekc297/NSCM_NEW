import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './shipment-change-history.constants';
import type { SearchCondition } from './shipment-change-history.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

type StaticColumnsBySheet = {
  [SHEETS.MAIN]: RawFlexGridColumnConfig[];
};

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch. 미등록/실패 시 빈 배열
  //   -> 그리드가 constants MAIN_COLUMNS fallback. 실측: SSP0019 컬럼메타 47행 배포됨(design 03 §0).
  staticColumns: StaticColumnsBySheet;
  // 권한 Division 후보 전체(MyDivisionInEE_SCP 응답 CODE, EE 제외 후) — Form 이 콤보 로드 후 1회 세팅.
  //   0건이면 권한 게이트(design 01 §2#1: 조회영역 disable + MSG00667).
  authDivisionIds: string[];
  // Division 콤보 응답 도착 여부. 미도착 상태로 조회하면 권한범위를 모른 채 나가므로 조회를 막는다.
  divisionAuthLoaded: boolean;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  // p_language 는 세션 언어(page 가 전달) — 그 외 11개는 searchCondition 에서 매핑.
  setFilter: (language: string) => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  setDivisionAuth: (codes: string[]) => void;
  resetDivisionAuth: () => void;
}

const initSearch: SearchCondition = {
  // 기본선택 없음 — Division 초기 미체크(design 02 §4-4 주석처리). 기간만 기본 1개월(page 가 mount 시 세팅).
  divisionIds: [],
  fromSiteIds: [],
  toSiteIds: [],
  incoterms: [],
  transModes: [],
  fromDate: '',
  toDate: '',
  itemId: '',
  soNo: '',
  confirmId: '',
  chkCurrent: false,
};

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.MAIN]: [],
};

const initState: State = {
  initialized: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  staticColumns: emptyStaticColumns,
  authDivisionIds: [],
  divisionAuthLoaded: false,
};

// 다중 체크값 -> 콤마 join. GET SP 가 콤마열을 IN/INSTR 매칭(design 02 §5). 빈=전체(권한범위).
const joinOrEmpty = (arr: string[]): string => (arr.length === 0 ? '' : arr.join(','));
const trimOrEmpty = (v: string): string => (v && v.trim() ? v.trim() : '');

export const useShipmentChangeHistoryStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    setFilter: language => {
      set(state => {
        const c = state.searchCondition;
        // GET SP P_SSP0019_GET_SHIPMENT_CHANGE_HISTORY 파라미터 12개 (design 02 §5 / 03 §4.1 실측):
        //   p_division_id / p_from_site / p_to_site / p_incoterms / p_from_yyyymmdd / p_to_yyyymmdd /
        //   p_item_id / p_sono / p_trans_mode / p_confirm_id / p_language / debug_mode='F'.
        //   다중 콤보는 콤마 join(빈=전체). 텍스트(Model/SoNo/ConfirmId)는 콤마 다중입력을 SP 가 파싱(원문 전달).
        state.filters = {
          [SHEETS.MAIN]: {
            p_division_id: joinOrEmpty(c.divisionIds),
            p_from_site: joinOrEmpty(c.fromSiteIds),
            p_to_site: joinOrEmpty(c.toSiteIds),
            p_incoterms: joinOrEmpty(c.incoterms),
            p_from_yyyymmdd: trimOrEmpty(c.fromDate),
            p_to_yyyymmdd: trimOrEmpty(c.toDate),
            p_item_id: trimOrEmpty(c.itemId),
            p_sono: trimOrEmpty(c.soNo),
            p_trans_mode: joinOrEmpty(c.transModes),
            p_confirm_id: trimOrEmpty(c.confirmId),
            p_language: language,
            debug_mode: 'F',
          } as unknown as ProcRequest<MENU_ID, SHEETS.MAIN>,
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

    // Division 콤보 응답 도착 시 Form 이 호출 — 권한 division 후보(EE 제외 후 CODE)를 보관. 0건이면 권한 게이트.
    setDivisionAuth: codes =>
      set(state => {
        state.authDivisionIds = codes;
        state.divisionAuthLoaded = true;
      }),

    // 탭 재진입 시 초기화 — persist 된 이전 권한 목록으로 조회가 나가지 않게 콤보 재도착 전까지 비운다.
    resetDivisionAuth: () =>
      set(state => {
        state.authDivisionIds = [];
        state.divisionAuthLoaded = false;
      }),

    // admin SCM_MST_SHEET_COLUMNS 동적 fetch — 미등록/실패 시 빈 배열 유지(그리드 constants fallback, console 금지).
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? SHEETS.MAIN }
        );
        const next = res.data.result ?? [];
        if (next.length > 0) {
          set(state => {
            if (JSON.stringify(state.staticColumns[SHEETS.MAIN]) !== JSON.stringify(next)) {
              state.staticColumns[SHEETS.MAIN] = next;
            }
          });
        }
      } catch {
        // 미등록/실패 = constants fallback
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'shipment-change-history-store'
);
