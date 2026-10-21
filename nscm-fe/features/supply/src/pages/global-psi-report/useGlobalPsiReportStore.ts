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
import { planDayRange } from './utils/globalPsiReportCalendar';

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
  // 조회기간(SetCalendar)을 마지막으로 시드한 Plan Date. AS-IS 는 Load·PlanDate 변경 때만 기간을 다시 세팅하므로
  //   (SCP0100_Global_PSI_Report.cs:600·1788) 같은 Plan Date 로 리마운트될 때 사용자가 고친 기간을 덮지 않게 가드한다.
  calendarSeedPlan: string;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setDivision: (divisionId: string) => void;
  setSearchMode: (mode: SearchMode) => void;
  setUnitScaleIndex: (index: number) => void;
  setFilter: () => void;
  clearFilters: () => void;
  seedCalendar: (planStartYyyymmdd: string, planEndYyyymmdd: string) => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchStaticMeasures: () => Promise<void>;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchCondition 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

// 개인화 조건 복원 역직렬화 키(SubTitle F6 저장은 배열=콤마join·불리언=String 평문화 — personalizeCondition).
//   chkCellQty/chkAs = 체크박스(String(bool) → ==='true'). 그 외 조회조건은 전부 문자열(divisionId/planType/
//   bucket/display/searchLevel/from·toSite/itemId/project/cellGroup) → 역직렬화 불요(그대로 patch).
//   날짜 키(from·toYyyymmdd/planStartYyyymmdd)는 저장 측 EXCLUDED_DATE_PARAM(gridAction.ts)으로 저장 자체가
//   제외 → 복원 응답에 없음(초기값 유지). 다중선택(Division/From·To Site/Model/PJT)은 콤마 CSV 문자열로 보관.
const RESTORE_BOOL_KEYS = new Set<string>(['chkCellQty', 'chkAs']);

// 주의: 상수가 아니라 함수다 — 매 호출 새 객체(초기화·Division 변경 리셋이 같은 기본값을 새로 만든다).
const makeInitSearch = (): SearchCondition => ({
  // AS-IS clbDivision(UsrCheckedList2) 은 진입 시 체크 0건 = ValueList 'ALL' → getDivision '' (.cs:464-471, 전 Division).
  //   카탈로그 Div. = 선택·다중 + ALL버튼. 기본 미선택('') = ALL.
  divisionId: '',
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
  project: '',
  cellGroup: '',
  chkCellQty: true, // AS-IS designer:248 chkCellQty.Checked=true(CheckState.Checked) — 진입 기본 체크
  chkAs: false, // AS-IS chkAS 기본 미체크(designer Checked 지정 없음)
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
  calendarSeedPlan: '',
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
// Division 다중선택도 같은 정규화 — AS-IS GetCheckedListValue(dt, v, true)(CString.cs:584-600): 빈값·'ALL' → ''.
//   SP P_DIVISION_ID 는 FN_SPLITSTRING(',') 다중 / TRIM IS NULL = 전 Division(PKG_SCP0100 BODY).
export const divisionParam = siteParam;

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
    // Division 변경(다중 콤보) = TO-BE 공통 요건: Division·조회기간(from/to)을 제외한 검색조건을 전부 초기화하고
    //   그리드도 초기화(filters clear)한다(사용자 지시 2026-10-02 — TO-BE 공통 요건이 AS-IS cascade 보다 넓다).
    //   조회기간(from/to YYYYMMDD)은 division 무관 기간이라 유지. Plan Date 도 초기화 대상이라 Form useEffect 가
    //   목록 첫 Plan Date 로 재시드한다(목록 자체는 AS-IS 처럼 division '' 1회 조회라 바뀌지 않는다).
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
        const isDetail = state.searchMode === SEARCH_MODE.DETAIL;
        const req = {
          fromYyyymmdd: orEmpty(c.fromYyyymmdd), //  1 P_FROM_YYYYMMDD
          toYyyymmdd: orEmpty(c.toYyyymmdd), //  2 P_TO_YYYYMMDD
          divisionId: divisionParam(c.divisionId), //  3 P_DIVISION_ID (다중 CSV, ALL→'' 전 Division)
          itemId: str(c.itemId), //  4 P_ITEM_ID
          nickName: '', //  5 P_NICK_NAME — AS-IS FindDataMain(.cs:1245) 고정 "" (입력 컨트롤 없음)
          fromSite: siteParam(c.fromSite), //  6 P_FROM_SITE (ALL/'-'→'' 무필터 정규화, 기본점검 #5)
          toSite: siteParam(c.toSite), //  7 P_TO_SITE (ALL/'-'→'' 무필터 정규화, 기본점검 #5)
          planStartYyyymmdd: orEmpty(c.planStartYyyymmdd), //  8 P_PLAN_START_YYYYMMDD
          planType: orEmpty(c.planType), //  9 P_PLAN_TYPE
          userId: str(useSessionStore.getState().session.userId), // 10 P_USER_ID
          bucket: orEmpty(c.bucket), // 11 P_BUCKET
          cellGroup: str(c.cellGroup), // 12 P_CELL_GROUP
          project: str(c.project), // 13 P_PROJECT
          // 14 P_SEARCH_LEVEL — Detail 모드면 콤보값 대신 'DETAIL'(AS-IS getSearchLevel .cs:414-417 → SP DETAIL 분기)
          searchLevel: isDetail ? SEARCH_LEVEL_CODE.DETAIL : orEmpty(c.searchLevel),
          chkCellQty: c.chkCellQty ? 'Y' : 'N', // 15 P_CHK_CELL_QTY
          chkAs: c.chkAs ? 'Y' : 'N', // 16 P_CHK_AS
          debugMode: 'N', // 17 DEBUG_MODE
        };
        // searchMode + searchLevel 조합으로 활성 그리드 1개만 조회(design 01 R1~R3). 나머지는 미조회.
        state.filters = {};
        if (isDetail) {
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
    // AS-IS SetCalendar(.cs:1317) → GetDayRange "MONTH"(.cs:1409~1423) — 계산은 planDayRange(utils).
    //   종료일이 비면 null → 기간 유지(UsrDateRangePicker3.InitValue('') 무변경 파리티).
    //   어느 쪽이든 이 Plan Date 는 시드 완료로 표시해 재시드하지 않는다.
    seedCalendar: (planStartYyyymmdd, planEndYyyymmdd) =>
      set(state => {
        const range = planDayRange(planStartYyyymmdd, planEndYyyymmdd);
        if (range) state.searchCondition = { ...get().searchCondition, ...range };
        state.calendarSeedPlan = planStartYyyymmdd;
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),
    // admin SCM_MST_SHEET_COLUMNS 3시트 동적 fetch — 미등록/실패 시 빈 배열(메타 주도, console 금지 룰).
    fetchStaticColumns: async () => {
      // 다중 Division 은 PR_GET_SHEET_COLUMN_LIST 의 DIVISION_ID 토큰 비교 대상이 아니므로 ALL→'' 정규화 값으로 보낸다
      //   (SCP0100 3시트 메타 DIVISION_ID 전건 공란 = 전 Division 공통, 사내 sheet_columns 실측).
      const divisionId = divisionParam(get().searchCondition.divisionId);
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
          divisionId: divisionParam(get().searchCondition.divisionId),
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
