import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  MEASURE_SHEET_NAME,
  MENU_ID,
  SHEETS,
} from './integration-psi.constants';
import type { SearchCondition } from './integration-psi.types';

// SCM_MST_SHEET_MEASURE 동적 fetch row — /admin/menu/{MENU_ID}/measure (camelCase, ForecastPrice 선례 1:1).
//   주의: BE GridMeasure DTO 는 DISPLAY_FLAG/USER_SELECTABLE_FLAG 를 boolean 으로 직렬화한다
//   (string 'Y'/'N' 로 오선언 시 === 'Y' 비교가 전부 false → Visible measure 0개 사고).
export interface MeasureMeta {
  colNm: string;
  colLblNm?: string;
  sClsLblNm?: string;
  display?: boolean;
  personalizable?: boolean;
  sortOrd?: number;
}

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
  // admin SCM_MST_SHEET_COLUMNS 동적 fetch (ui-dynamic-property-management §2.3). 'Integration PSI' 24행
  //   등록 확인됨(design 03 §0 실측) → 미등록/실패 시 빈 배열(메타 주도 — 하드코딩 fallback 없음).
  staticColumns: StaticColumnsBySheet;
  // SCM_MST_SHEET_MEASURE 동적 fetch (design 03 §1-M 7행). PIVOT measure 세로축. division=81 은 MKT_FCST 제외.
  staticMeasures: MeasureMeta[];
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setDivision: (divisionId: string) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchStaticMeasures: () => Promise<void>;
}

// 주의: 상수가 아니라 함수다 — 모듈 최상위 상수로 굳히면 청크 최초 로드 시점의 session.div 로 얼어붙어
//   재로그인 시 앞 계정 division 이 고정된다(ForecastPrice makeInitSearchParams 규약 동일).
const makeInitSearch = (): SearchCondition => ({
  // 진입 division 기본값 = 로그인 세션 권한 division. fallback '40' 은 세션 미확립 대비 규칙 기본 1건.
  divisionId: useSessionStore.getState().session.div ?? '40',
  planStartYyyymmdd: '',
  planType: '',
  fromYyyymm: '',
  toYyyymm: '',
  qtyYn: false, // design 02 §4.2 미체크(N)
  nickName: '',
  cellItemId: '',
  itemId: '',
});

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.MAIN]: [],
};

const makeInitState = (): State => ({
  initialized: false,
  searchCondition: makeInitSearch(),
  filters: {},
  openSearchArea: true,
  staticColumns: emptyStaticColumns,
  staticMeasures: [],
});

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
const orEmpty = (v: string): string => (v && v.trim() ? v.trim() : '');

export const useIntegrationPsiStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...makeInitState(),
    reset: () => set(makeInitState()),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // division 변경 = 하위 cascade 초기화(design 02 §3) + 그리드 clear. PlanDate/PlanType/기간 리셋.
    setDivision: divisionId =>
      set(state => {
        state.searchCondition = {
          ...get().searchCondition,
          divisionId,
          planStartYyyymmdd: '',
          planType: '',
          fromYyyymm: '',
          toYyyymm: '',
        };
        state.filters = {}; // 그리드 데이터 clear (design 02 §5.2 division 변경 = Grid 초기화)
      }),
    // 메인 GET 10-param 매핑 (design 02 §4.4 — SP IN 순번 주석). p_plan_type/p_seq "" 고정.
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: orEmpty(c.divisionId), //  1 p_division_id
            planStartYyyymmdd: orEmpty(c.planStartYyyymmdd), //  2 p_plan_start_yyyymmdd
            planType: '', //  3 p_plan_type ("" 고정 — design 02 §4.4 cs:878)
            seq: '', //  4 p_seq ("" 고정 — cs:879)
            fromYyyymm: orEmpty(c.fromYyyymm), //  5 p_from_yyyymm
            toYyyymm: orEmpty(c.toYyyymm), //  6 p_to_yyyymm
            nickName: str(c.nickName), //  7 p_nick_name
            cellItemId: str(c.cellItemId), //  8 p_cellitem_id
            itemId: str(c.itemId), //  9 p_item_id
            qtyYn: c.qtyYn ? 'Y' : 'N', // 10 p_qty_yn (음수 아이템만 조회)
          },
        };
      });
    },
    // Division 전환 시 그리드 초기화 — filters 를 비우면 useTabProcQuery enabled=false 로 이전 응답이 즉시 사라진다.
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),
    // admin SCM_MST_SHEET_COLUMNS('Integration PSI') 동적 fetch — 미등록/실패 시 빈 배열(메타 주도, console 금지 룰).
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? SHEETS.MAIN, divisionId: get().searchCondition.divisionId }
        );
        // 주의: BE 가 200 으로 result:null 을 줄 수 있어 `?? []` 필수(ForecastPrice division 81 실측).
        const next = res.data.result ?? [];
        set(state => {
          if (JSON.stringify(state.staticColumns[SHEETS.MAIN]) !== JSON.stringify(next)) {
            state.staticColumns[SHEETS.MAIN] = next;
          }
        });
      } catch {
        // 미등록/실패 = 빈 배열 유지 (console 금지 룰)
      }
      set(state => {
        state.initialized = true;
      });
    },
    // SCM_MST_SHEET_MEASURE('Integration PSI') 동적 fetch — measure 7종(design 03 §1-M). 실패 시 빈 배열.
    fetchStaticMeasures: async () => {
      try {
        const res = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
          sheetNm: MEASURE_SHEET_NAME,
          divisionId: get().searchCondition.divisionId,
        });
        set(state => {
          state.staticMeasures = res.data.result ?? [];
        });
      } catch {
        // SCM_MST_SHEET_MEASURE 미등록/실패 시 빈 배열 (console 금지 룰)
      }
    },
  }),
  'integration-psi-store'
);
