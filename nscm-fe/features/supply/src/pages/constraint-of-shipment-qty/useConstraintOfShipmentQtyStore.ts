import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS, VALID_DEFAULT } from './constraint-of-shipment-qty.constants';
import type { SearchCondition } from './constraint-of-shipment-qty.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

type StaticColumnsBySheet = {
  [SHEETS.MAIN]: RawFlexGridColumnConfig[];
};

interface State {
  initialized: boolean;
  // 개인화 조회조건 복원 1회 가드 (SubTitle F6 저장분 mount 복원 — initialized 는 컬럼 fetch 전용이라 별도).
  conditionsRestored: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // ui-dynamic-property-management — admin SCM_MST_SHEET_COLUMNS 동적 fetch(실측 23행 등록됨, design 03 §1).
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
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchCondition 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

// 개인화 조건 복원 역직렬화 키(SubTitle F6 저장은 배열=콤마join·불리언=String 평문화 — personalizeCondition).
//   멀티셀렉트 5종(planGroup/fromSite/toSite/stage/modelGroup) = 콤마 결합 → split 역직렬화.
//   불리언 조회조건 없음. 날짜키 fromDate/toDate 는 EXCLUDED_DATE_PARAM(date(fr|to)$ 등)에 안 걸려
//   저장·복원된다(끝이 "Date" — 자매 SCP0130 fromDate 동형) → 평문 문자열 patch.
const RESTORE_ARRAY_KEYS = new Set<string>([
  'planGroupIds',
  'fromSiteIds',
  'toSiteIds',
  'stageIds',
  'modelGroupIds',
]);

const initSearch: SearchCondition = {
  divisionId: '',
  planGroupIds: [],
  fromSiteIds: [],
  toSiteIds: [],
  stageIds: [],
  modelGroupIds: [],
  itemId: '',
  fromDate: '',
  toDate: '',
  validYn: VALID_DEFAULT,
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
};

export const useConstraintOfShipmentQtyStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division·기간(from/to) 을 제외한 검색조건을 전부 초기화하고
    //   그리드도 초기화(filters clear)한다(사용자 지시 2026-10-02 — TO-BE 공통 요건이 AS-IS 핸들러보다 우선).
    //   기간(fromDate/toDate)·Division(새 값)만 유지하고 planGroup/fromSite/toSite/stage/modelGroup/item/valid 는
    //   initSearch 로 되돌린다(종전 onChange 는 cascade 로 5갈래만 비웠다 — item/valid 잔존 + 그리드 미초기화 결함 해소).
    //   편집중(dirty) 확인 가드(MSG00704)는 Form 의 onChange 가 confirmIfDirtyKey 로 처리한다(commit 51d4e9fa 패턴).
    //   그리드는 itemsSource=rows(=filters 기반 쿼리)라 filters 를 비우면 신규행·미저장 편집이 함께 폐기된다(자매 SCP0131 동형).
    setDivision: divisionId =>
      set(state => {
        const cur = get().searchCondition;
        state.searchCondition = {
          ...initSearch, // Division·기간 제외 전 조건 초기화(planGroup/fromSite/toSite/stage/modelGroup/item/valid)
          divisionId,
          fromDate: cur.fromDate,
          toDate: cur.toDate,
        };
        state.filters = {}; // 그리드 초기화 — 재조회(Search) 전까지 빈 상태
      }),
    // GET SP 파라미터 매핑(design 03 §4, SCP0132_GET_CONSTRAINT_OF_SHIPMENT_QTY 10 param):
    //   Division/PlanGroup/FromSite/ToSite/ModelGroupName/Item/Stage/FromDate/ToDate/ValidYn
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: c.divisionId,
            planGroupId: c.planGroupIds.join(','),
            fromSiteId: c.fromSiteIds.join(','),
            toSiteId: c.toSiteIds.join(','),
            modelGroupName: c.modelGroupIds.join(','),
            itemId: c.itemId,
            stage: c.stageIds.join(','),
            fromDate: c.fromDate,
            toDate: c.toDate,
            validYn: c.validYn,
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

    // admin SCM_MST_SHEET_COLUMNS 동적 fetch — 미등록/실패 시 빈 배열 유지(그리드 하드코딩 없음).
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
        // 미등록/실패 = 빈 배열 유지(console 금지 룰)
      }
      set(state => {
        state.initialized = true;
      });
    },

    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 자매 SCP0053(scp-bom) 파리티.
    //   GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 역직렬화(배열 split).
    //   저장분 없거나 조회 실패면 기본값 유지. 저장은 EXCLUDED_DATE_PARAM·빈값 필터 후 재삽입이라
    //   (gridAction.ts personalizeCondition) 응답에 없는 키는 initSearch 기본값 그대로 둔다.
    //   주의: setDivision(cascade·Div/기간 외 전조건 초기화)·setFilter 경유 금지 — 직접 병합해야 복원값이 산다.
    restoreSearchConditions: async () => {
      if (get().conditionsRestored) return;
      set(state => {
        state.conditionsRestored = true;
      });
      try {
        const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        const rows = res.data.result ?? [];
        if (rows.length === 0) return;
        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in initSearch)) continue; // SearchCondition 필드만 allowlist
          const val = paramCtn ?? '';
          if (RESTORE_ARRAY_KEYS.has(paramNm)) patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          else patch[paramNm] = val;
        }
        set(state => {
          state.searchCondition = { ...state.searchCondition, ...patch } as SearchCondition;
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지 룰)
      }
    },
  }),
  'constraint-of-shipment-qty-store'
);
