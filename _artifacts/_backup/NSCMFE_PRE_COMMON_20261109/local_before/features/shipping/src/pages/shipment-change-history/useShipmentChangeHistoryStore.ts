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
  // 개인화 조회조건 복원 1회 가드 — SubTitle F6 저장분(search-conditions)을 mount 시 되불러온다.
  //   initialized 는 컬럼메타 fetch 전용이라 별도 플래그. 자매 shipment-plan-mobility-it 와 동일 패턴.
  conditionsRestored: boolean;
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
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchCondition 패치(1회).
  restoreSearchConditions: () => Promise<void>;
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
  conditionsRestored: false,
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

// 개인화 조건 복원 시 역직렬화 키 — SubTitle F6 저장(gridAction.personalizeCondition)은 배열=콤마join·
//   불리언=String('true'/'false') 로 평문화한다. 복원은 그 역: 배열은 split(','), 불리언은 ==='true'.
//   그 외(itemId/soNo/confirmId/fromDate/toDate 등 문자열)는 그대로 patch. 날짜키 fromDate/toDate 는
//   gridAction EXCLUDED_DATE_PARAM 정규식(…yyyymmdd/period…)에 안 걸려 저장·복원 대상(평문 문자열).
const ARRAY_KEYS = new Set<string>([
  'divisionIds',
  'fromSiteIds',
  'toSiteIds',
  'incoterms',
  'transModes',
]);
const BOOL_KEYS = new Set<string>(['chkCurrent']);

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

    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기) — AS-IS/자매 화면 파리티.
    //   진입 시 GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 을 searchCondition 에 역직렬화.
    //   1회 가드(conditionsRestored) — mount 중복/재마운트 재복원 방지. 저장분 없으면(0건) 기본값 유지.
    restoreSearchConditions: async () => {
      if (get().conditionsRestored) return;
      set(state => {
        state.conditionsRestored = true; // 먼저 세운다(중복 호출 방지)
      });
      try {
        const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        const rows = res.data.result ?? [];
        if (rows.length === 0) return;
        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in initSearch)) continue; // 모르는 키(구버전 잔재) 제외
          const val = paramCtn ?? '';
          if (ARRAY_KEYS.has(paramNm)) patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          else if (BOOL_KEYS.has(paramNm)) patch[paramNm] = val === 'true';
          else patch[paramNm] = val;
        }
        set(state => {
          state.searchCondition = { ...state.searchCondition, ...patch } as SearchCondition;
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (하드코딩 fallback·console 금지)
      }
    },

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
