import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './delegate.constants';
import type { DelegateInput } from './delegate.types';

type FiltersBySheet = {
  [SHEETS.DELEGATE]?: ProcRequest<MENU_ID, SHEETS.DELEGATE>;
};

type StaticColumnsBySheet = Record<SHEETS, RawFlexGridColumnConfig[]>;

interface State {
  initialized: boolean;
  input: DelegateInput;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  activeSheet: SHEETS; // R1/R2 — Delegate 일 때만 SAVE/UnSet 노출 (design 01 §2)
  // ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch. 미등록/실패 시
  //   빈 배열 -> 그리드 constants fallback. 실측: SSP0020 컬럼메타 16행 배포됨(design 03 §0).
  staticColumns: StaticColumnsBySheet;
}

interface Action {
  reset: () => void;
  setInput: (p: Partial<DelegateInput>) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setActiveSheet: (sheet: SHEETS) => void;
  fetchStaticColumns: () => Promise<void>;
}

const initInput: DelegateInput = {
  divisionIds: [],
  fromDate: '',
  toDate: '',
  delegatee: '',
  delegateeId: '',
};

// F6 저장 입력(SCM_ADM_USER_MNU_SRCH_COND_M) 복원 시 키 분류 (자매 SSP0014 선례).
//   저장(GridAction.personalizeCondition)은 값을 문자열로 coerce(배열=콤마 join)하고 빈값은 skip 한다.
//   복원 시 배열 필드(divisionIds)는 콤마 split 로 되돌린다. INPUT_KEYS 밖 paramNm(구버전 잔재)은
//   버린다 — setInput/저장 payload 가 모르는 필드를 흘리지 않도록 DelegateInput 과 1:1.
const INPUT_KEYS = new Set<string>(['divisionIds', 'fromDate', 'toDate', 'delegatee', 'delegateeId']);
const ARRAY_KEYS = new Set<string>(['divisionIds']);

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.DELEGATE]: [],
  [SHEETS.DELEGATED]: [],
};

const initState: State = {
  initialized: false,
  input: initInput,
  filters: {},
  openSearchArea: true,
  activeSheet: SHEETS.DELEGATE,
  staticColumns: emptyStaticColumns,
};

export const useDelegateStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setInput: p =>
      set(state => {
        state.input = { ...get().input, ...p };
      }),
    // GET(SSP0020_GET_DELEGATE) 파라미터 = p_user_id(BE @LoginUser 세션 주입)/p_language 만.
    //   입력영역(division/period/delegatee)은 조회 필터 아님(design 02 §5) — SAVE/UNSET payload 전용.
    setFilter: () => {
      set(state => {
        state.filters = {
          [SHEETS.DELEGATE]: {
            language: useSessionStore.getState().session.langCd ?? '',
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
    setActiveSheet: sheet =>
      set(state => {
        state.activeSheet = sheet;
      }),

    // admin SCM_MST_SHEET_COLUMNS 동적 fetch (2시트) — 미등록/실패 시 빈 배열(그리드 constants fallback).
    fetchStaticColumns: async () => {
      for (const sheet of [SHEETS.DELEGATE, SHEETS.DELEGATED]) {
        try {
          const res = await apiClient.post<RawFlexGridColumnConfig[]>(
            `/admin/menu/${MENU_ID}/column`,
            { sheetNm: ADMIN_SHEET_NAME[sheet] }
          );
          const next = res.data.result ?? [];
          if (next.length > 0) {
            set(state => {
              if (JSON.stringify(state.staticColumns[sheet]) !== JSON.stringify(next)) {
                state.staticColumns[sheet] = next;
              }
            });
          }
        } catch {
          // 미등록/실패 = constants fallback (console 금지 룰)
        }
      }

      // F6 저장 입력 복원 — 탭 수명 내 1회(initialized 가드, 컬럼 fetch 성패와 독립).
      //   이 화면은 SubTitle searchParam={input} 로 F6 저장만 있고 복원 배선이 없어 재진입/새로고침 시
      //   저장 입력(division/delegatee/period)이 반영되지 않았다(basic-check #3, 자매 SSP0014 선례).
      //   createPersistedStoreWithTab 은 모듈 Map keep-alive(세션스토리지 미영속)라 전체 새로고침 시
      //   새 스토어 → 복원이 다시 돈다. 저장이 divisionIds 를 복원하면 R5 "All" 기본체크(Delegate.tsx)는
      //   input.divisionIds.length!==0 가드로 덮어쓰지 않는다. F10(Reset)은 MotherStore 가 initialized 를
      //   보존(PRESERVED_ON_CONDITION_RESET)하므로 초기화 직후 재복원되지 않는다.
      if (!get().initialized) {
        try {
          const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
            `/admin/menu/${MENU_ID}/search-conditions`
          );
          const rows = res.data.result ?? [];
          if (rows.length > 0) {
            const patch: Record<string, unknown> = {};
            for (const { paramNm, paramCtn } of rows) {
              if (!INPUT_KEYS.has(paramNm)) continue; // 현재 입력 필드만(구버전 잔재 무시)
              const val = paramCtn ?? '';
              patch[paramNm] = ARRAY_KEYS.has(paramNm)
                ? val
                  ? val.split(',').filter(Boolean)
                  : []
                : val;
            }
            set(state => {
              state.input = { ...state.input, ...(patch as Partial<DelegateInput>) };
            });
          }
        } catch {
          // 저장조건 미존재/조회 실패 — 기본값 유지 (console 금지 룰)
        }
      }

      set(state => {
        state.initialized = true;
      });
    },
  }),
  'delegate-store'
);
