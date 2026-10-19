import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './shipment-semi-dept-day.constants';
import type { SearchCondition } from './shipment-semi-dept-day.types';

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
  //   -> 그리드가 constants MAIN_COLUMNS fallback. 실측: SCP0033 컬럼메타 11행 배포됨(design 03 §0).
  staticColumns: StaticColumnsBySheet;
  // 권한 Division 후보 전체(Division_SCP 응답 CODE) — Form 이 콤보 로드 후 1회 세팅.
  //   AS-IS 미체크 조회가 "권한 division 전체"로 나가야 해서 조회 payload 의 기본값 원천이 된다(아래 setFilter).
  authDivisionIds: string[];
  // Division_SCP 콤보 응답 도착 여부. 미도착 상태로 조회하면 권한범위를 모른 채 전건이 나가므로 조회를 막는다.
  divisionAuthLoaded: boolean;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  setDivisionAuth: (codes: string[]) => void;
  resetDivisionAuth: () => void;
}

const initSearch: SearchCondition = {
  // 기본선택 없음 — Division 초기 미체크(전건 조회는 빈값→전체, design 02 §4). Model/Valid 도 빈값=전체.
  divisionIds: [],
  itemId: '',
  valid: '',
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

// 다중 체크값 -> 콤마 join. GET SP p_division_id = String_Split(',') IN (design 02 §2 / 03 §4.1). 빈=전체.
const joinOrEmpty = (arr: string[]): string => (arr.length === 0 ? '' : arr.join(','));
const trimOrEmpty = (v: string): string => (v && v.trim() ? v.trim() : '');

export const useShipmentSemiDeptDayStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        // GET SP P_SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY 파라미터 (design 02 §5 / 03 §4.1):
        //   p_item_id(prefix, 빈=전체) / p_valid(정확일치 단일, 빈=전체). cascade 없음.
        //
        // p_division_id 는 빈값을 보내면 안 된다 — AS-IS 와 권한범위가 달라진다.
        //   AS-IS 체인(실측): Designer.cs:149 clbDivision.ALL_VIEW=true -> 체크 0건이면
        //   UsrCheckedList.ValueList(:303~308)='ALL' -> cs:241 CString.GetCheckedListValue(dtMyDivision,'ALL')
        //   (2인자 오버로드 CString.cs:529~551)이 'ALL' 을 dtMyDivision 전 행 CSV 로 "전개"해서 보낸다.
        //   즉 AS-IS 의 미체크 조회 = 권한 division 전체를 명시 나열한 조회다.
        //   반면 GET SP 본문(asis.py 실측)은 `@p_division_id IS NULL OR @p_division_id=''` 이면 필터를 통째로
        //   건너뛴다 -> 빈값 전송 시 권한 밖 division 까지 전부 조회된다(권한범위 확대).
        //   그래서 미선택이면 authDivisionIds(Division_SCP 권한 후보)로 전개해 AS-IS 와 같은 범위를 만든다.
        const picked = c.divisionIds.length > 0 ? c.divisionIds : state.authDivisionIds;
        state.filters = {
          [SHEETS.MAIN]: {
            p_division_id: joinOrEmpty(picked),
            p_item_id: trimOrEmpty(c.itemId),
            p_valid: trimOrEmpty(c.valid),
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

    // Division_SCP 콤보 응답 도착 시 Form 이 호출 — 권한 division 후보 전체를 보관(조회 payload 전개 원천).
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
      // 저장된 조회조건 복원(최초 1회) — F6(SubTitle GridAction.personalizeCondition)로 서버 저장은 되나
      //   복원 경로가 없어 재진입/새로고침 시 사라졌다(자매 shipment-change-request 등 동일 규약).
      //   divisionIds 는 저장 시 콤마 join 되므로(gridAction personalizeCondition) 배열로 되돌린다.
      //   itemId/valid 는 문자열 그대로. 실패/미등록은 무시 — 명시 Search 전엔 조회가 나가지 않는다.
      if (!get().initialized) {
        try {
          const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
            `/admin/menu/${MENU_ID}/search-conditions`
          );
          const list = res.data.result ?? [];
          if (list.length > 0) {
            const restored: Partial<SearchCondition> = {};
            for (const { paramNm, paramCtn } of list) {
              if (paramNm === 'divisionIds') {
                restored.divisionIds = paramCtn ? paramCtn.split(',').filter(Boolean) : [];
              } else if (paramNm === 'itemId' || paramNm === 'valid') {
                restored[paramNm] = paramCtn;
              }
            }
            set(state => {
              state.searchCondition = { ...get().searchCondition, ...restored };
            });
          }
        } catch {
          // 복원 실패 무시
        }
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'shipment-semi-dept-day-store'
);
