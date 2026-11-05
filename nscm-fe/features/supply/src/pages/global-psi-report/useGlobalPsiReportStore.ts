import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  BUCKET_DEFAULT,
  DISPLAY_CODE,
  DIVISION_ALL,
  MEASURE_SHEET_NAME,
  MENU_ID,
  normalizeDivision,
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
  lClsLblNm?: string;
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
  // 개인화 조회조건 복원 1회 가드 (SubTitle F6 저장분 mount 복원 — initialized 는 컬럼 fetch 전용이라 별도).
  conditionsRestored: boolean;
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
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchCondition 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

// 개인화 조건 복원 역직렬화 키(SubTitle F6 저장은 배열=콤마join·불리언=String 평문화 — personalizeCondition).
//   chkCellQty/chkAs = 체크박스(String(bool) → ==='true'). 그 외 조회조건은 전부 문자열(divisionId/planType/
//   bucket/display/searchLevel/from·toSite/itemId/nickName/project/cellGroup/planStartYyyymmdd) → 역직렬화
//   불요(그대로 patch). planStartYyyymmdd(Plan Date)는 'yyyymmdd' 로 끝나 EXCLUDED_DATE_PARAM 에 걸리지만
//   SubTitle conditionIncludeKeys opt-in 으로 저장되므로 복원 대상이다(makeInitSearch allowlist 통과 → 자동
//   patch). Period 날짜 키(from·toYyyymmdd)만 여전히 저장 제외 → 복원 응답에 없음(Plan Date 재시드 effect 가
//   기간을 다시 채운다). 멀티셀렉트 배열 조건 없음(From/To Site 는 단일 문자열).
const RESTORE_BOOL_KEYS = new Set<string>(['chkCellQty', 'chkAs']);

// 주의: 상수가 아니라 함수다 — 모듈 최상위 상수로 굳히면 청크 최초 로드 시점의 session.div 로 얼어붙어
//   재로그인 시 앞 계정 division 이 고정된다(ForecastPrice makeInitSearchParams 규약 동일).
const makeInitSearch = (): SearchCondition => ({
  // Division 기본값 = ALL(전체) — AS-IS clbDivision setListBox(...,true) 전체선택 기본(cs:586),
  //   getDivision() 이 ALL→"" 정규화해 전체 division 조회. 특정 division 은 사용자가 콤보에서 선택.
  divisionId: DIVISION_ALL,
  fromYyyymmdd: '',
  toYyyymmdd: '',
  planStartYyyymmdd: '',
  planType: '', // Division/Plan Date 종속 콤보(COMBO.PLAN_TYPE)라 기본값은 Form effect 가 필터 첫 항목으로 세팅(2026-10-26, FN 고정 폐기)
  bucket: BUCKET_DEFAULT, // design 02 §4.2 Monthly 기본
  display: DISPLAY_CODE.GRID, // design 01 D4 cboDisplay.SelectedIndex=2 (OnlyGrid)
  searchLevel: SEARCH_LEVEL_CODE.CELL_GROUP, // design 02 §4.2 cboSearchLevel idx0
  fromSite: '',
  toSite: '',
  itemId: '',
  nickName: '',
  project: '',
  cellGroup: '',
  chkCellQty: true, // AS-IS 화면 스크린샷 기준 기본 체크(2026-10-14 사용자 확인). 값만 Y(NO-OP — 조회 P_CHK_CELL_QTY 로만 반영)
  chkAs: false, // AS-IS 화면 스크린샷 기준 기본 미체크(NO-OP — 조회 P_CHK_AS 로만 반영)
});

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.REPORT]: [],
  [SHEETS.SEARCH_LEVEL]: [],
  [SHEETS.SEARCH_LEVEL_DETAIL]: [],
};

const makeInitState = (): State => ({
  initialized: false,
  conditionsRestored: false,
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
// From/To Site 다중선택 — 전체선택 센티넬('ALL', CustomDropdown multiple allOption 규약)·미선택
//   센티넬('-'/'--')은 빈값으로 정규화해 SP 무필터(전체) 경로를 탄다. AS-IS _from_site/_to_site
//   "ALL"→"" 정규화 파리티(design 02 §4.3). 자매 global-psi(SCP0031) siteParam 과 동일 관례.
//   리터럴 'ALL' 을 그대로 P_FROM_SITE/P_TO_SITE 로 보내면 SP 가 'ALL' 이라는 Site 로 필터해 전체선택
//   조회가 0건이 된다(기본점검 #5). 콤마 다중선택 CSV 는 유지.
const SITE_SENTINELS = new Set(['-', '--']);
const siteParam = (v: string): string =>
  str(v)
    .split(',')
    .map(c => c.trim())
    .filter(c => c && !SITE_SENTINELS.has(c) && c.toUpperCase() !== 'ALL')
    .join(',');

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
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division·조회기간(from/to)을 제외한 검색조건을 전부 초기화하고
    //   그리드도 초기화(filters clear)한다(사용자 지시 2026-10-02 — TO-BE 공통 요건이 AS-IS cascade 보다 넓다).
    //   조회기간(from/to YYYYMMDD)은 division 무관 기간이라 유지. Plan Date(planStartYyyymmdd)는 division cascade
    //   콤보(P_SCP0100_GET_PLAN_DATE)라 초기화 — Form useEffect 가 새 division 첫 Plan Date 로 재시드한다.
    //   편집중(dirty) 가드(MSG00704)는 Form 의 onChange 가 confirmIfDirtyKey 로 처리(commit 51d4e9fa 패턴) —
    //   read-only 리포트라 실제 dirty 는 없지만 공통 패턴을 동일하게 둔다(SCP0025 선례).
    setDivision: divisionId =>
      set(state => {
        const cur = get().searchCondition;
        state.searchCondition = {
          ...makeInitSearch(), // Division·조회기간 제외 전 조건 초기화(planType/bucket/display/searchLevel/site/item/project 등)
          divisionId,
          fromYyyymmdd: cur.fromYyyymmdd,
          toYyyymmdd: cur.toYyyymmdd,
        };
        state.filters = {}; // 그리드 초기화 — 재조회(Search) 전까지 빈 상태
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
          divisionId: normalizeDivision(c.divisionId), //  3 P_DIVISION_ID (ALL→'' 전체, AS-IS getDivision cs:468)
          itemId: str(c.itemId), //  4 P_ITEM_ID
          nickName: str(c.nickName), //  5 P_NICK_NAME (AS-IS Roslyn: txtNickName 컨트롤 부재 — UI 미노출, 항상 '')
          fromSite: siteParam(c.fromSite), //  6 P_FROM_SITE (ALL/'-'→'' 무필터 정규화, 기본점검 #5)
          toSite: siteParam(c.toSite), //  7 P_TO_SITE (ALL/'-'→'' 무필터 정규화, 기본점검 #5)
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
      // ALL(전체)/빈값은 '' 로 정규화 → PR_GET_SHEET_COLUMN_LIST 의 P_DIVISION_ID IS NULL 분기로 공통(DIVISION_ID
      //   NULL) 메타 반환. 'ALL' 그대로 넘기면 division-specific 조인에서 매칭 실패(메인 SP getDivision 과 동일 규약).
      // Division 다중(CSV)이면 공통 메타('')로 fetch — SCP0100 컬럼/measure 메타는 전부 DIVISION_ID NULL(공통,
      //   DB 실측 2026-10-15). CSV/특정 division 을 넘기면 division-specific 조인에서 0건이 될 수 있다. 단일은 종전대로.
      const rawDiv = normalizeDivision(get().searchCondition.divisionId);
      const divisionId = rawDiv.includes(',') ? '' : rawDiv;
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
        // ALL→'' 정규화 필수 — PR_GET_SHEET_MEASURE_LIST 는 measure 의 DIVISION_ID 가 NULL 일 때
        //   P_DIVISION_ID IS NULL 분기로만 반환한다(columns 와 달리 M.DIVISION_ID IS NULL 분기 없음).
        //   'ALL' 그대로면 split(NULL) IN 매칭 실패 → 0건(measure 팝업 빈값 원인, 2026-10-14).
        //   Division 다중(CSV)도 공통 메타('')로 — SCP0100 measure 전부 DIVISION_ID NULL(DB 실측 2026-10-15).
        const rawDiv = normalizeDivision(get().searchCondition.divisionId);
        const res = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
          sheetNm: MEASURE_SHEET_NAME,
          divisionId: rawDiv.includes(',') ? '' : rawDiv,
        });
        set(state => {
          state.staticMeasures = res.data.result ?? [];
        });
      } catch {
        // SCM_MST_SHEET_MEASURE 미등록/실패 시 빈 배열 (console 금지 룰)
      }
    },
    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 정본 scp-bom(SCP0053)·자매 global-psi-elec(SCP0095) 파리티.
    //   GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 역직렬화(불리언 ==='true', 그 외 문자열).
    //   저장분 없거나 조회 실패면 기본값 유지. 저장은 EXCLUDED_DATE_PARAM·빈값 필터 후 재삽입이라
    //   (gridAction.ts personalizeCondition) 응답에 없는 키는 makeInitSearch 기본값 그대로 둔다.
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
        const init = makeInitSearch();
        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in init)) continue; // SearchCondition 필드만 allowlist
          const val = paramCtn ?? '';
          if (RESTORE_BOOL_KEYS.has(paramNm)) patch[paramNm] = val === 'true';
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
  'global-psi-report-store'
);
