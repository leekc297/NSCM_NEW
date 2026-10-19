import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  BUCKET_DEFAULT,
  DISPLAY_CODE,
  MEASURE_SHEET_NAME,
  MENU_ID,
  PLAN_TYPE_DEFAULT,
  SEARCH_LEVEL_CODE,
  SEARCH_MODE,
  SHEETS,
  type SearchMode,
} from './global-psi-report.constants';
import type { SearchCondition } from './global-psi-report.types';

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
  [SHEETS.REPORT]?: ProcRequest<MENU_ID, SHEETS.REPORT>;
  [SHEETS.SEARCH_LEVEL]?: ProcRequest<MENU_ID, SHEETS.SEARCH_LEVEL>;
  [SHEETS.SEARCH_LEVEL_DETAIL]?: ProcRequest<MENU_ID, SHEETS.SEARCH_LEVEL_DETAIL>;
};

type StaticColumnsBySheet = {
  [SHEETS.REPORT]: RawFlexGridColumnConfig[];
  [SHEETS.SEARCH_LEVEL]: RawFlexGridColumnConfig[];
  [SHEETS.SEARCH_LEVEL_DETAIL]: RawFlexGridColumnConfig[];
};

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // rgrpSearchLevel — SEARCH(idx0 기본)/DETAIL(idx1). 어느 그리드를 노출할지 결정(design 01 R1~R4).
  searchMode: SearchMode;
  // Unit(Qty) 로컬 표시배율 index (design 02 §2.5). 서버 재조회 없이 그리드 클라 나눗셈. 기본 0(배율 1).
  unitScaleIndex: number;
  // admin SCM_MST_SHEET_COLUMNS 동적 fetch (ui-dynamic-property-management §2.3). 3시트 등록 확인됨
  //   (design 03 §1 실측 REPORT 15 / SEARCH_LEVEL 9 / SEARCH_LEVEL_DETAIL 9). 미등록/실패 시 빈 배열.
  staticColumns: StaticColumnsBySheet;
  // SCM_MST_SHEET_MEASURE 동적 fetch ('Global PSI New' 36행, design 03 §1). PIVOT measure 세로축.
  staticMeasures: MeasureMeta[];
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setDivision: (divisionId: string) => void;
  setSearchMode: (mode: SearchMode) => void;
  setUnitScaleIndex: (index: number) => void;
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
  fromYyyymmdd: '',
  toYyyymmdd: '',
  planStartYyyymmdd: '',
  planType: PLAN_TYPE_DEFAULT, // design 02 §4.2 cboPlanType.SelectedValue="FN"
  bucket: BUCKET_DEFAULT, // design 02 §4.2 Monthly 기본
  display: DISPLAY_CODE.GRID, // design 01 D4 cboDisplay.SelectedIndex=2 (OnlyGrid)
  searchLevel: SEARCH_LEVEL_CODE.CELL_GROUP, // design 02 §4.2 cboSearchLevel idx0
  fromSite: '',
  toSite: '',
  itemId: '',
  nickName: '',
  project: '',
  cellGroup: '',
  chkCellQty: false, // design 01 §2 NO-OP 기본 미체크
  chkAs: false, // design 01 §2 NO-OP 기본 미체크
});

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.REPORT]: [],
  [SHEETS.SEARCH_LEVEL]: [],
  [SHEETS.SEARCH_LEVEL_DETAIL]: [],
};

const makeInitState = (): State => ({
  initialized: false,
  searchCondition: makeInitSearch(),
  filters: {},
  openSearchArea: true,
  searchMode: SEARCH_MODE.SEARCH, // rgrpSearchLevel.SelectedIndex=0 기본(design 01)
  unitScaleIndex: 0,
  staticColumns: emptyStaticColumns,
  staticMeasures: [],
});

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
const orEmpty = (v: string): string => (v && v.trim() ? v.trim() : '');

// 3시트 공통 admin 컬럼 fetch — divisionId + 시트별 sheetNm 으로 SCM_MST_SHEET_COLUMNS 조회.
const fetchColumnsFor = async (
  sheet: SHEETS,
  divisionId: string
): Promise<RawFlexGridColumnConfig[]> => {
  try {
    const res = await apiClient.post<RawFlexGridColumnConfig[]>(
      `/admin/menu/${MENU_ID}/column`,
      { sheetNm: ADMIN_SHEET_NAME[sheet], divisionId }
    );
    // 주의: BE 가 200 으로 result:null 을 줄 수 있어 `?? []` 필수(ForecastPrice division 81 실측).
    return res.data.result ?? [];
  } catch {
    // 미등록/실패 = 빈 배열 (console 금지 룰)
    return [];
  }
};

export const useGlobalPsiReportStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...makeInitState(),
    reset: () => set(makeInitState()),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // division 변경 = 하위 cascade 초기화(design 02 §3) + 그리드 clear. Site/PlanDate/Item/Project 리셋.
    setDivision: divisionId =>
      set(state => {
        state.searchCondition = {
          ...get().searchCondition,
          divisionId,
          fromSite: '',
          toSite: '',
          planStartYyyymmdd: '',
          itemId: '',
          project: '',
        };
        state.filters = {}; // 그리드 데이터 clear (design 01 division 변경 = Grid 초기화)
      }),
    setSearchMode: mode =>
      set(state => {
        state.searchMode = mode;
      }),
    setUnitScaleIndex: index =>
      set(state => {
        state.unitScaleIndex = index;
      }),
    // 메인 GET 17-param 매핑 (design 02 §4.4 — SP IN 순번 주석). searchMode 에 따라 대상 시트 filter 세팅.
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        const req = {
          fromYyyymmdd: orEmpty(c.fromYyyymmdd), //  1 P_FROM_YYYYMMDD
          toYyyymmdd: orEmpty(c.toYyyymmdd), //  2 P_TO_YYYYMMDD
          divisionId: orEmpty(c.divisionId), //  3 P_DIVISION_ID
          itemId: str(c.itemId), //  4 P_ITEM_ID
          nickName: str(c.nickName), //  5 P_NICK_NAME
          fromSite: orEmpty(c.fromSite), //  6 P_FROM_SITE
          toSite: orEmpty(c.toSite), //  7 P_TO_SITE
          planStartYyyymmdd: orEmpty(c.planStartYyyymmdd), //  8 P_PLAN_START_YYYYMMDD
          planType: orEmpty(c.planType), //  9 P_PLAN_TYPE
          userId: str(useSessionStore.getState().session.userId), // 10 P_USER_ID
          bucket: orEmpty(c.bucket), // 11 P_BUCKET
          cellGroup: str(c.cellGroup), // 12 P_CELL_GROUP
          project: str(c.project), // 13 P_PROJECT
          searchLevel: orEmpty(c.searchLevel), // 14 P_SEARCH_LEVEL
          chkCellQty: c.chkCellQty ? 'Y' : 'N', // 15 P_CHK_CELL_QTY
          chkAs: c.chkAs ? 'Y' : 'N', // 16 P_CHK_AS
          debugMode: 'N', // 17 DEBUG_MODE
        };
        // searchMode + searchLevel 조합으로 활성 그리드 1개만 조회(design 01 R1~R3). 나머지는 미조회.
        state.filters = {};
        if (state.searchMode === SEARCH_MODE.DETAIL) {
          state.filters[SHEETS.REPORT] = req;
        } else if (c.searchLevel === SEARCH_LEVEL_CODE.CELL_GROUP_DETAIL) {
          state.filters[SHEETS.SEARCH_LEVEL_DETAIL] = req;
        } else {
          state.filters[SHEETS.SEARCH_LEVEL] = req;
        }
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
    // admin SCM_MST_SHEET_COLUMNS 3시트 동적 fetch — 미등록/실패 시 빈 배열(메타 주도, console 금지 룰).
    fetchStaticColumns: async () => {
      const divisionId = get().searchCondition.divisionId;
      const [report, level, levelDetail] = await Promise.all([
        fetchColumnsFor(SHEETS.REPORT, divisionId),
        fetchColumnsFor(SHEETS.SEARCH_LEVEL, divisionId),
        fetchColumnsFor(SHEETS.SEARCH_LEVEL_DETAIL, divisionId),
      ]);
      set(state => {
        const next: StaticColumnsBySheet = {
          [SHEETS.REPORT]: report,
          [SHEETS.SEARCH_LEVEL]: level,
          [SHEETS.SEARCH_LEVEL_DETAIL]: levelDetail,
        };
        // 주의: 참조 안정성 — 동일 내용이면 교체하지 않아 Wijmo 컬럼 재생성을 유발하지 않는다.
        if (JSON.stringify(state.staticColumns) !== JSON.stringify(next)) {
          state.staticColumns = next;
        }
        state.initialized = true;
      });
    },
    // SCM_MST_SHEET_MEASURE('Global PSI New') 동적 fetch — measure 36종(design 03 §1). 실패 시 빈 배열.
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
  'global-psi-report-store'
);
