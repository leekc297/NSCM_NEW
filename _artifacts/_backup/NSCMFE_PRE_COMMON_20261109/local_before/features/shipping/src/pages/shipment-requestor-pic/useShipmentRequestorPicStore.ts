import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './shipment-requestor-pic.constants';
import type { SearchCondition } from './shipment-requestor-pic.types';

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
  //   -> 그리드가 constants MAIN_COLUMNS fallback. 실측: SSP0025 컬럼메타 19행 배포됨(design 03 §0).
  staticColumns: StaticColumnsBySheet;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setDivision: (divisionId: string) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
}

const initSearch: SearchCondition = {
  // 기본 사업부 = 세션 division. AS-IS 는 MyDivision 콤보 기본선택(명시 SelectedIndex 없음, design 02 §4).
  divisionId: useSessionStore.getState().session.div ?? '',
  plantSiteIds: [],
  itemId: '',
  nickName: '',
  modelId: '',
};

// F6 저장 조회조건(SCM_ADM_USER_MNU_SRCH_COND_M) 복원 시 키 분류 (정본 자매 SSP0014).
//   저장(GridAction.personalizeCondition)은 값을 문자열로 coerce 한다(배열=콤마 join). 복원 시
//   배열 필드(plantSiteIds)는 콤마 split 로 되돌린다. SEARCH_KEYS 에 없는 paramNm(구버전 잔재)은
//   버린다 — setFilter 가 모르는 필드를 SP payload 로 흘리지 않도록(SearchCondition 필드와 1:1).
const SEARCH_KEYS = new Set<string>([
  'divisionId',
  'plantSiteIds',
  'itemId',
  'nickName',
  'modelId',
]);
const ARRAY_KEYS = new Set<string>(['plantSiteIds']);

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.MAIN]: [],
};

const initState: State = {
  initialized: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  staticColumns: emptyStaticColumns,
};

// 다건 텍스트(개행/콤마) -> 콤마 join. GET SP P_ITEM_ID/P_MODEL_ID 콤마 IN (design 02 §4 / 07 보완2 정정: 구분자 콤마).
const multi = (v: string): string =>
  v
    ? v
        .split(/[\n,]/)
        .map(s => s.trim())
        .filter(Boolean)
        .join(',')
    : '';

// 다중 체크값 -> 콤마 join. GET SP P_PLANT_SITE 콤마 IN (07 보완2 — plant_site 도 String_Split(',') 콤마).
const joinOrEmpty = (arr: string[]): string => (arr.length === 0 ? '' : arr.join(','));
const trimOrEmpty = (v: string): string => (v && v.trim() ? v.trim() : '');

export const useShipmentRequestorPicStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division 을 제외한 검색조건을 전부 초기화하고 그리드도
    //   초기화(filters clear)한다(사용자 지시 2026-10-02 — TO-BE 공통 요건이 AS-IS 핸들러보다 우선, 정본 SCP0025
    //   setDivision). 이 화면은 기간/날짜 조회조건이 없어 유지 대상은 Division 뿐이고 나머지(plantSite/item/
    //   nickName/model)는 전부 initSearch 값으로 되돌린다. 편집중(dirty) 확인 가드(MSG00704)는 Form 의
    //   onChange 가 confirmIfDirtyKey 로 처리한다(commit 51d4e9fa 패턴). 그리드 신규행·EditTracker 미저장분은
    //   divisionId 변화를 감지하는 페이지 effect(prevDivisionRef)가 함께 비운다(gridRef 접근은 store 밖).
    setDivision: divisionId =>
      set(state => {
        state.searchCondition = {
          ...initSearch, // Division 제외 전 조건 초기화(plantSite/item/nickName/model)
          divisionId,
        };
        state.filters = {}; // 그리드 초기화 — 재조회(Search) 전까지 빈 상태
      }),
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        // GET SP P_SSP0025_GET_SHIPMENT_REQUESTOR_PIC 파라미터 (design 02 §5 / 03 §4.2, 07 보완2):
        //   p_division_id(필수 단일) / p_plant_site(콤마 다건) / p_item_id(콤마 다건) /
        //   p_nick_name(단일) / p_model_id(콤마 다건) / p_language(세션 @sesLangCd 자동, FE 미전달).
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: c.divisionId,
            plantSite: joinOrEmpty(c.plantSiteIds),
            itemId: multi(c.itemId),
            nickName: trimOrEmpty(c.nickName),
            modelId: multi(c.modelId),
          },
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

      // F6 저장 조회조건 복원 — 탭 수명 내 1회(initialized 가드, 컬럼 fetch 성패와 독립, 정본 자매 SSP0014).
      //   이 화면은 restore 배선이 누락돼 F6 저장(SubTitle searchParam)이 재진입/새로고침 시 반영되지
      //   않았다(basic-check #3, memory f6-restore-path-missing-on-new-scaffolds).
      //   createPersistedStoreWithTab 은 sessionStorage 미영속(모듈 Map keep-alive)이라 전체 새로고침
      //   시 새 스토어 → 복원이 다시 돈다. F10(Reset)은 MotherStore 가 initialized 를 보존
      //   (PRESERVED_ON_CONDITION_RESET)하므로 초기화 직후 재복원되지 않는다(searchCondition 은 기본값).
      if (!get().initialized) {
        try {
          const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
            `/admin/menu/${MENU_ID}/search-conditions`
          );
          const rows = res.data.result ?? [];
          if (rows.length > 0) {
            const patch: Record<string, unknown> = {};
            for (const { paramNm, paramCtn } of rows) {
              if (!SEARCH_KEYS.has(paramNm)) continue; // 현재 조회조건 필드만(구버전 잔재 무시)
              const val = paramCtn ?? '';
              patch[paramNm] = ARRAY_KEYS.has(paramNm)
                ? val
                  ? val.split(',').filter(Boolean)
                  : []
                : val;
            }
            set(state => {
              state.searchCondition = {
                ...state.searchCondition,
                ...(patch as Partial<SearchCondition>),
              };
            });
          }
        } catch {
          // 저장조건 미존재/조회 실패 — 기본값 유지 (console 금지 룰)
        }
        set(state => {
          state.initialized = true;
        });
      }
    },
  }),
  'shipment-requestor-pic-store'
);
