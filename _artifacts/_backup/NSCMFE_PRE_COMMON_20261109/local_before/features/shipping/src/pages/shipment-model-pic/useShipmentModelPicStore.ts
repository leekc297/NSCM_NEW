import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './shipment-model-pic.constants';
import type { SearchCondition } from './shipment-model-pic.types';

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
  // ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch. 미등록/실패 시
  //   빈 배열 -> 그리드가 constants MAIN_COLUMNS fallback. 실측: SSP0014 컬럼메타 21행 배포됨(design 03 §0).
  staticColumns: StaticColumnsBySheet;
  // 컬럼 메타 요청이 **실패**했는지 — "정상 0건"(미등록)과 구분한다. 편집 가부·필수검증이 전부
  //   INPUT_TP_CD 메타에 달려 있어(hook #130) 실패를 0건과 같이 취급하면 검증 없는 편집·저장이 열린다.
  //   true 면 화면이 편집·저장을 잠그고 MSG01052 를 안내한다. 마지막 정상 메타는 보존한다.
  staticColumnsError: boolean;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
}

// ALL sentinel — 조회콤보 '전체' 선택값. 서버로는 '' (빈값=무시, GET SP TRIM 로직).
const ALL = 'ALL';

// F6 저장 조회조건(SCM_ADM_USER_MNU_SRCH_COND_M) 복원 시 키 분류.
//   저장(GridAction.personalizeCondition)은 값을 문자열로 coerce 한다(배열=콤마 join). 복원 시
//   배열 필드는 콤마 split 로 되돌린다. SEARCH_KEYS 에 없는 paramNm(구버전 잔재)은 버린다 —
//   setFilter 가 모르는 필드를 SP payload 로 흘리지 않도록(SearchCondition 필드와 1:1).
const SEARCH_KEYS = new Set<string>([
  'divisionId',
  'operationGroup',
  'fromSiteIds',
  'validYn',
  'itemId',
  'userId',
]);
const ARRAY_KEYS = new Set<string>(['fromSiteIds']);

// 초기 상태는 **호출 시점에 새로 만든다**(모듈 로드 시 1회 상수 금지).
//   ① `session.div` 를 상수로 박으면 계정을 바꿔도 파일이 다시 평가되지 않아 이전 사용자의 division 이
//      남는다(store 가 createPersistedStoreWithTab 이라 더 오래 산다).
//   ② 같은 객체를 reset 에 재사용하면 중첩 객체(searchCondition·filters·staticColumns)가 이전 인스턴스와
//      공유돼, 한 탭의 reset 이 다른 탭 상태를 건드릴 수 있다 — 매번 새 객체로 만든다.
//   주의: 여기서 정한 divisionId 는 "후보"다. 권한 콤보(MyDivision) 로드 후 목록에 없으면 화면이
//     첫 옵션으로 보정한다(ShipmentModelPic.tsx clamp effect). AS-IS 는 콤보 선택값만 넘길 수 있어
//     목록 밖 division 이 구조적으로 불가능했다(design 02 §4).
const makeInitState = (): State => ({
  initialized: false,
  searchCondition: {
    divisionId: useSessionStore.getState().session.div ?? '',
    operationGroup: ALL,
    fromSiteIds: [],
    validYn: ALL,
    itemId: '',
    userId: '',
  },
  filters: {},
  openSearchArea: true,
  staticColumns: { [SHEETS.MAIN]: [] },
  staticColumnsError: false,
});

// 다중/단일 값 -> SP 파라미터 문자열. ALL/빈값 = '' (전체). GET SP 는 TRIM 비어있으면 무시.
const joinOrEmpty = (arr: string[]): string => (arr.length === 0 ? '' : arr.join(','));
const oneOrEmpty = (v: string): string => (v && v !== ALL ? v : '');
const trimOrEmpty = (v: string): string => (v && v.trim() ? v.trim() : '');
// Model 멀티라인/콤마 다건 -> 콤마 join (AS-IS txtItemId ^다건, GET SP P_ITEM_ID 콤마 IN).
const multiItem = (v: string): string =>
  v
    ? v
        .split(/[\n,]/)
        .map(s => s.trim())
        .filter(Boolean)
        .join(',')
    : '';

export const useShipmentModelPicStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...makeInitState(),
    reset: () => set(makeInitState()),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        // GET SP P_SSP0014_GET_MODEL_PIC 파라미터 (design 03 §4 / 00 §4):
        //   P_DIVISION_ID(필수 단일) / P_OPERATION_GROUP(콤마 다건) / P_FROM_SITE(콤마 다건) /
        //   P_VALID_YN(콤마 다건) / P_ITEM_ID(콤마 다건) / P_USER_ID(LIKE) / P_LANGUAGE.
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: c.divisionId,
            operationGroup: oneOrEmpty(c.operationGroup),
            fromSite: joinOrEmpty(c.fromSiteIds),
            validYn: oneOrEmpty(c.validYn),
            itemId: multiItem(c.itemId),
            userId: trimOrEmpty(c.userId),
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

    // admin SCM_MST_SHEET_COLUMNS 동적 fetch.
    //   **"정상 0건"과 "실패"를 구분한다** — 편집 가부(INPUT_TP_CD)와 저장 필수검증이 전부 이 메타에
    //   달려 있어(hook #130, design 03 §1.1), 실패를 0건과 같이 삼키면 "검증 0건 + 전 컬럼 편집" 상태로
    //   저장이 열린다. 정상 0건 = 미등록이므로 constants MAIN_COLUMNS fallback 이 정답이고,
    //   실패 = 알 수 없음이므로 화면이 편집·저장을 잠근다(staticColumnsError).
    //   실패 시 마지막 정상 메타는 **보존**한다(빈 배열로 덮으면 fallback 으로 조용히 강등된다).
    fetchStaticColumns: async () => {
      // 1) 컬럼 메타 — 매 호출 fetch. 성패로 staticColumnsError 갱신(정상 0건도 성공).
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? SHEETS.MAIN }
        );
        const next = res.data.result ?? [];
        set(state => {
          if (next.length > 0 &&
            JSON.stringify(state.staticColumns[SHEETS.MAIN]) !== JSON.stringify(next)) {
            state.staticColumns[SHEETS.MAIN] = next;
          }
          state.staticColumnsError = false;
        });
      } catch {
        // 실패 — 오류 플래그만 세우고 기존 메타는 그대로 둔다(console 금지 룰).
        set(state => {
          state.staticColumnsError = true;
        });
      }

      // 2) F6 저장 조회조건 복원 — 탭 수명 내 1회(initialized 가드, 컬럼 fetch 성패와 독립).
      //    이 화면은 restore 배선이 없어 F6 저장이 재진입 시 반영되지 않았다(정본 erp-edi-master §G1).
      //    createPersistedStoreWithTab 은 sessionStorage 미영속(모듈 Map keep-alive)이라 전체 새로고침
      //    시 새 스토어 → 복원이 다시 돈다. F10(Reset)은 MotherStore 가 initialized 를 보존
      //    (PRESERVED_ON_CONDITION_RESET)하므로 초기화 직후 재복원되지 않는다(searchCondition 은 기본값).
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
  'shipment-model-pic-store'
);
