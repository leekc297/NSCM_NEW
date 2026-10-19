import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import {
  BUCKET_TYPE,
  BUCKET_WORD,
  // DIVISION, // 미사용 (divisionId 초기값을 '' 로 변경하며 제거)
  MENU_ID,
  SHEETS,
  TITLESET_COLUMN_TYPE,
} from './sales-plan.constants';
import type { CalendarInfo, EditAuthInfo, SearchCondition } from './sales-plan.types';
import type { PlantSiteSource, SearchComboTrigger } from './utils/sales-plan.searchCombos';

// SP filter 로 변환된 payload — useTabProcQuery enabled 가드
//   MAIN = P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX / SPREAD_TITLE = P_DMF0021_GET_SPREAD_TITLE
type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.SPREAD_TITLE]?: ProcRequest<MENU_ID, SHEETS.SPREAD_TITLE>;
};

// SCM_MST_SHEET_MEASURE 동적 fetch row — /admin/menu/{MENU_ID}/measure (BE GridMeasure camelCase 직렬화.
//   DMF0003 사고 계보: UPPER_SNAKE 가정 금지 — colNm/colLblNm/sClsLblNm/personalizable/display).
export interface MeasureMeta {
  colNm: string;
  colLblNm?: string;
  sClsLblNm?: string;
  lClsLblNm?: string;
  personalizable?: boolean;
  display?: boolean;
}

/** ColumnLayoutModal 개인화 1행 — 표시/순서/폭/색. */
export interface ColumnLayoutSetting {
  colNm: string;
  visible: boolean;
  width: number;
  cellColor: string;
  textColor: string;
  order: number;
}

interface State {
  initialized: boolean;
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  // 조회조건 콤보를 다시 만든 계기. AS-IS 는 같은 콤보라도 무엇을 바꿨느냐로 축이 달라진다 -
  //   근거와 라인은 utils/sales-plan.searchCombos 참조. searchCondition 밖에 두는 이유:
  //   setFilter 가 조회조건을 프로시저 파라미터로 옮겨 담아 화면 상태가 새어 나가면 안 된다.
  comboTrigger: SearchComboTrigger;
  // Plant Site 원천 - 진입은 고객 기준, Division 을 한 번이라도 바꾸면 사업부 기준으로 굳는다.
  plantSiteSource: PlantSiteSource;
  openSearchArea: boolean;
  staticColumns: RawFlexGridColumnConfig[];
  // 개인화 적용 전 admin 메타 원본 — 팝업 Default 버튼의 원복 기준.
  //   staticColumns 는 개인화로 덮이므로 별도 스냅샷이 필요하다.
  originalStaticColumns: RawFlexGridColumnConfig[];
  // ColumnLayoutModal OK 결과 (null = 미설정) — 표시/순서 + 폭/색.
  //   fetchStaticColumns 는 mount/Search/division 변경마다 admin 메타를 다시 덮으므로, 이 값으로
  //   재적용하지 않으면 컬럼 설정 직후 조회 한 번에 개인화가 통째로 원복된다.
  userColumnLayout: ColumnLayoutSetting[] | null;
  staticMeasures: MeasureMeta[];
  // MeasureSelectModal 선택 measure(표시 대상). null = 미설정(전체 표시).
  visibleMeasures: string[] | null;
  // ⭐ MAIN 커서 2/3 보관 — 기준일(calendar)·편집권한(editAuth). editLock cutoff 산출 입력(클라 시계 금지).
  calendarInfo: CalendarInfo | null;
  editAuth: EditAuthInfo | null;
  // PR_GET_DAY_RANGE 1회 적용 가드 (AS-IS drpPeriod.InitValue — DMF0014 dayRangeApplied 동일)
  dayRangeApplied: boolean;
  // P_USERINFO 용 권한 그룹 (AS-IS NowGroupID 등가). CMBO 'SalesPlanUserAuthGroup' 결과가 정본이며,
  // session.groupId(유령 필드)는 참조하지 않는다 (UI분석서 v2.1 시트9 C29 — ghost field 사고 대응).
  authGroup: string;
  // Current user department for P_USER_DEPT_ID (JV Planner authority).
  userDeptId: string;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>, comboTrigger?: SearchComboTrigger) => void;
  setFilter: () => void;
  clearFilters: () => void;
  /**
   * Bucket 전환.
   *
   * Daily 전환만 그리드 데이터를 초기화하고 동적 3단 헤더를 일자까지 펼친다
   * (사용자 확정 2026-08-23). Weekly/Monthly 전환은 조회조건만 바꾼다 —
   * 조회해 둔 데이터를 유지한 채 기간 컬럼 표시만 전환된다
   * (AS-IS cboBucketType_SelectedIndexChanged — 조회 없이 D/W/M 컬럼 표시 전환).
   */
  setBucketType: (bucketType: BUCKET_TYPE) => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchStaticMeasures: () => Promise<void>;
  // MAIN 응답의 calendar/editAuth 커서 보관 (cutoff·권한 산출용).
  setCalendarInfo: (calendar: CalendarInfo | null, editAuth: EditAuthInfo | null) => void;
  // PR_GET_DAY_RANGE o_rc2 DAY_RANGE('yyyymmdd:yyyymmdd') → 기본 Period (당월 1일 ~ +6개월 말일)
  applyDayRange: (range?: string) => void;
  /** ColumnLayoutModal onSave — 표시/순서/width/색상을 staticColumns 에 즉시 반영. */
  applyColumnLayout: (settings: ColumnLayoutSetting[]) => void;
  /** 저장된 컬럼 개인화(titleSet) 복원 — fetchStaticColumns 가 await 후 메타에 적용. */
  fetchUserColumnLayout: () => Promise<ColumnLayoutSetting[] | null>;
  /**
   * 컬럼 개인화 무효화 — division 전환 시 필수.
   *
   * 주의: SCM_MST_TITLESET_USER 에는 division 컬럼이 없어 개인화가 division 무관 1벌인데,
   *   컬럼 세트는 division 별로 다르다(SP 서버 필터). 이전 division 레이아웃을 새 division
   *   컬럼에 적용하면 "목록에 없는 컬럼 = 비표시" 규칙 때문에 전 컬럼이 사라진다.
   */
  clearUserColumnLayout: () => void;
  // MeasureSelectModal onSave — 표시할 measure 코드 목록 적용 (null = 전체).
  applyVisibleMeasures: (measureCodes: string[] | null) => void;
  setAuthGroup: (group: string) => void;
  setUserDeptId: (deptId: string) => void;
}

// 기본 Period — 당월 1일 ~ +6개월 말일 (AS-IS PR_GET_DAY_RANGE p_month=6 동등 dayjs 계산.
//   서버 dayRange(o_rc2) 도착 시 applyDayRange 가 서버값으로 교체 — 동등성 이중 방어).
// Div/Team 변경 시에는 리셋하지 않는다 (2026-08-20 사용자 결정 — 사용자가 지정한 기간 유지).
const SALES_PLAN_INIT_PERIOD = {
  start: dayjs().startOf('month').format('YYYYMMDD'),
  end: dayjs().add(6, 'month').endOf('month').format('YYYYMMDD'),
};
const { start: monthStart, end: sixMonthsEnd } = SALES_PLAN_INIT_PERIOD;

const yyyymmddOf = (date: Date): string =>
  `${date.getFullYear()}${String(date.getMonth() + 1).padStart(2, '0')}${String(
    date.getDate()
  ).padStart(2, '0')}`;

export const resolveNowYyyymmdd = (
  startYyyymmdd: string,
  endYyyymmdd: string,
  today = new Date()
): string => {
  const day = today.getDay();
  const monday = new Date(today);
  monday.setDate(today.getDate() + (day === 0 ? -6 : -(day - 1)));

  let nowYyyymmdd = yyyymmddOf(monday);
  if (startYyyymmdd >= nowYyyymmdd) nowYyyymmdd = startYyyymmdd;
  if (endYyyymmdd < nowYyyymmdd) {
    const end = new Date(
      Number(endYyyymmdd.slice(0, 4)),
      Number(endYyyymmdd.slice(4, 6)) - 1,
      Number(endYyyymmdd.slice(6, 8))
    );
    end.setDate(end.getDate() + 1);
    nowYyyymmdd = yyyymmddOf(end);
  }
  return nowYyyymmdd;
};

const initSearch: SearchCondition = {
  // 빈 값으로 시작 — 화면(SalesPlan.tsx)의 division 자동선택 effect 가 세션/콤보 데이터로 채운다
  // (DMF0003/DMF0020/DMF0040/DMF0053 정본과 동일).
  divisionId: '',
  deptIds: [],
  endCustomers: [],
  scmSiteIds: [],
  plantSiteIds: [],
  bizTypes: [],
  itemTypes: [],
  projectCodes: [],
  itemIds: [],
  owners: [],
  startYyyymmdd: monthStart,
  endYyyymmdd: sixMonthsEnd,
  bucketType: BUCKET_TYPE.MONTHLY, // 기본 Monthly (AS-IS DefineProperty L543 — DMF0082 Weekly 와 상이)
  colorYn: false,
  sumYn: false, // AS-IS InitControls L487 uncheck
  internalYn: false,
};

// P_DMF0021_GET_SPREAD_TITLE (4 IN — sesUserId BE주입) payload.
//   조회(setFilter)와 버킷 전환(setBucketType)이 같은 규칙으로 만들어야 헤더 기간 구조가 갈라지지 않는다.
const buildSpreadTitleFilter = (c: SearchCondition): ProcRequest<MENU_ID, SHEETS.SPREAD_TITLE> => ({
  startYyyymmdd: c.startYyyymmdd,
  endYyyymmdd: c.endYyyymmdd,
  divisionId: c.divisionId,
  bucket: BUCKET_WORD[c.bucketType],
});

const initState: State = {
  initialized: false,
  filters: {},
  searchCondition: initSearch,
  comboTrigger: 'entry',
  plantSiteSource: 'entry',
  openSearchArea: true,
  staticColumns: [],
  originalStaticColumns: [],
  userColumnLayout: null,
  staticMeasures: [],
  visibleMeasures: null,
  calendarInfo: null,
  editAuth: null,
  dayRangeApplied: false,
  authGroup: '',
  userDeptId: '',
};

// BE 가 폭을 안 내려줄 때의 기본 폭 (ColumnLayoutModal DEFAULT_COL_WIDTH 와 동일 계약).
const DEFAULT_COL_WIDTH = 100;

// ColumnLayoutModal 개인화 override — 표시/순서/폭/색을 admin 메타 위에 덧씌운다.
//   주의: 표시 게이트는 `display` 만 건드린다 — `visible` 은 admin VISIBLE_FLAG(관리 노출)이라
//     사용자 조작으로 덮어쓰지 않는다 (2026-07-15 정정. Grid 는 visible && display 로 필터).
//   주의: 개인화는 비표시 컬럼(visible:false)까지 전부 담고 있어야 한다 — 표시분만 담으면
//     아래 '미등록 = admin 기본값' 분기가 사용자가 끈 컬럼을 되살린다.
const applyLayoutToColumns = (
  cols: RawFlexGridColumnConfig[],
  settings: ColumnLayoutSetting[]
): RawFlexGridColumnConfig[] => {
  const byCol = new Map(settings.map(s => [s.colNm, s]));
  return (
    cols
      .map(c => {
        const s = byCol.get(c.colNm);
        // 개인화에 없는 컬럼 = 개인화 저장 이후 admin 메타에 추가된 컬럼 — 관리자 기본값
        //   (DEFAULT_FLAG)을 그대로 따른다. 여기서 display:false 로 죽이면 기존에 컬럼 설정을
        //   저장한 사용자에게는 신규 컬럼이 영원히 안 보인다 (2026-08-17 Text/From Site/Plant Site 결함).
        if (!s) return c;
        return {
          ...c,
          display: s.visible,
          colWth: s.width || DEFAULT_COL_WIDTH,
          cellColor: s.cellColor,
          textColor: s.textColor,
        };
      })
      // 팝업 순서대로 재정렬 — grid 는 배열 순서를 컬럼 순서로 사용. 미매칭 컬럼은 뒤로.
      .sort(
        (a, b) =>
          (byCol.get(a.colNm)?.order ?? Number.MAX_SAFE_INTEGER) -
          (byCol.get(b.colNm)?.order ?? Number.MAX_SAFE_INTEGER)
      )
  );
};

type SavedSearchCondition = {
  paramNm: keyof SearchCondition;
  paramCtn: string;
};

const ARRAY_SEARCH_CONDITIONS: ReadonlySet<keyof SearchCondition> = new Set([
  'deptIds',
  'endCustomers',
  'scmSiteIds',
  'plantSiteIds',
  'itemTypes',
  'bizTypes',
  'projectCodes',
  'itemIds',
  'owners',
]);

const BOOLEAN_SEARCH_CONDITIONS: ReadonlySet<keyof SearchCondition> = new Set([
  'colorYn',
  'sumYn',
  'internalYn',
]);

const parseSavedSearchConditions = (params: SavedSearchCondition[]): Partial<SearchCondition> => {
  const restored: Partial<SearchCondition> = {};

  for (const { paramNm, paramCtn } of params) {
    if (!(paramNm in initSearch)) continue;

    if (ARRAY_SEARCH_CONDITIONS.has(paramNm)) {
      const values = paramCtn
        .split(',')
        .map(value => value.trim())
        .filter(Boolean);
      (restored as Record<string, unknown>)[paramNm] = values;
      continue;
    }

    if (BOOLEAN_SEARCH_CONDITIONS.has(paramNm)) {
      (restored as Record<string, unknown>)[paramNm] =
        paramCtn.toLowerCase() === 'true' || paramCtn === 'Y';
      continue;
    }

    if (paramNm === 'bucketType') {
      if (Object.values(BUCKET_TYPE).includes(paramCtn as BUCKET_TYPE)) {
        restored.bucketType = paramCtn as BUCKET_TYPE;
      }
      continue;
    }

    (restored as Record<string, unknown>)[paramNm] = paramCtn;
  }

  return restored;
};

export const useSalesPlanStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () =>
      set(state => {
        const staticMeasures = state.staticMeasures;
        const authGroup = state.authGroup;
        const userDeptId = state.userDeptId;
        Object.assign(state, initState);
        state.staticMeasures = staticMeasures;
        state.authGroup = authGroup;
        state.userDeptId = userDeptId;
      }),
    setAuthGroup: group =>
      set(state => {
        state.authGroup = group;
      }),
    setUserDeptId: deptId =>
      set(state => {
        state.userDeptId = deptId;
      }),
    setSearchCondition: (p, comboTrigger) =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
        if (comboTrigger) state.comboTrigger = comboTrigger;
        // Plant Site 원천은 Division 을 바꾼 뒤로 고정이다 - AS-IS 는 Team·End Customer 변경
        //   핸들러에서 Plant Site 를 다시 만들지 않으므로 직전 목록이 그대로 남는다.
        if (comboTrigger === 'division') state.plantSiteSource = 'division';
      }),
    setFilter: () => {
      // BE makeProcedure (BaseService.java) 가 SCM_ADM_PROC_M.COL_NM 기준 positional 매핑.
      //   키명 = P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX PROC_M COL_NM (2026-07-14 사내 실측 계약).
      //   sesUserId(P_CREATED_BY) 는 BE 세션 자동주입 — request 미포함.
      //   ⚠ userGroup(P_USERINFO=NowGroupID)·userDeptId(P_USER_DEPT_ID) 는 BE 자동주입 대상이 아님 —
      //   FE payload 필수 (누락 시 SP 권한 필터 오동작. DMF0003 2026-07-02 사고 계보).
      //   authGroup(CMBO 'SalesPlanUserAuthGroup' 정본)이 원천. session.groupId 는 유령 필드라 참조 금지
      //   (UI분석서 v2.1 시트9 C29 — 2026-07-15 ghost field 사고 대응). CMBO 0행일 때만 본인 USER_ID로 최종 fallback.
      const session = useSessionStore.getState().session;
      const sesUserId = session.userId ?? '';
      const userGroup = get().authGroup || sesUserId;
      const userDeptId = get().userDeptId;
      set(state => {
        // persist(sessionStorage) rehydrate 가 구버전 shape 일 수 있어 기본값 머지로 완전한 조회조건 보장
        //   (누락 필드 → SP NULL payload → ORA 사고 차단. DMF0003 2026-06-29 계보).
        const c: SearchCondition = { ...initSearch, ...state.searchCondition };
        // 멀티선택 콤보 = 콤마 delim (AS-IS CheckedList ControlValues 1:1). 빈 배열 = 'ALL' sentinel.
        const j = (arr?: string[]): string => (!arr || arr.length === 0 ? 'ALL' : arr.join(','));
        // 텍스트+팝업 필드(Project/Model/Owner) = raw 텍스트, 빈값 '' (AS-IS txt*.Text 1:1).
        const raw = (arr?: string[]): string => (!arr || arr.length === 0 ? '' : arr.join(','));
        state.filters = {
          // ── P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX (17 IN, PROC_M SORT_ORD 순) ──
          [SHEETS.MAIN]: {
            divisionId: c.divisionId, // 1
            deptId: j(c.deptIds), // 2  Team
            endCustomer: j(c.endCustomers), // 3
            scmSiteId: j(c.scmSiteIds), // 4  Sales Site
            projectCode: raw(c.projectCodes), // 5  (40 비활성 '')
            itemId: raw(c.itemIds), // 6
            itemType: j(c.itemTypes), // 7
            fromYyyymmdd: c.startYyyymmdd, // 8
            nowYyyymmdd: resolveNowYyyymmdd(c.startYyyymmdd, c.endYyyymmdd), // 9
            toYyyymmdd: c.endYyyymmdd, // 10
            plantSiteId: j(c.plantSiteIds), // 11 (40 비활성 'ALL')
            bizType: j(c.bizTypes), // 12
            owner: raw(c.owners), // 13
            internalYn: c.internalYn ? 'Y' : 'N', // 14 Include Internal Txn
            userGroup, // 15 세션 NowGroupID (FE 필수 전달)
            bucket: BUCKET_WORD[c.bucketType], // 16 full-word
            userDeptId, // 17 JV Planner 부서 — SalesPlanUserDept 전용 콤보에서 현재 사용자 부서 주입
          },
          // ── P_DMF0021_GET_SPREAD_TITLE (4 IN — sesUserId BE주입) ──
          [SHEETS.SPREAD_TITLE]: buildSpreadTitleFilter(c),
        };
      });
    },

    setBucketType: bucketType =>
      set(state => {
        if (state.searchCondition.bucketType === bucketType) return;
        state.searchCondition = { ...state.searchCondition, bucketType };
        // Daily 전환에서만 그리드를 초기화한다 (사용자 확정 2026-08-23).
        //   Weekly/Monthly 전환은 종전대로 조회조건만 바꾼다 — 조회해 둔 데이터를 그대로 두고
        //   기간 컬럼 표시 전환(SalesPlanGrid applyDynVisibility)만 일어난다.
        if (bucketType !== BUCKET_TYPE.DAILY) return;
        // 그리드 데이터 초기화 — MAIN filters 제거로 조회 게이트를 닫는다(rows 비움).
        //   재조회는 Search 로만 (Division 변경·Column/Measure 설정 저장과 같은 초기화 규약).
        delete state.filters[SHEETS.MAIN];
        // 동적 3단 헤더는 DAILY 로 즉시 다시 그린다 — 헤더가 일자까지 펼쳐진다.
        //   조회 게이트(hasSearched)는 그대로 두므로 SPREAD_TITLE 만 새 queryKey 로 재조회된다.
        //   미조회 상태(SPREAD_TITLE 미보유)면 그릴 헤더 자체가 없으므로 건드리지 않는다.
        if (state.filters[SHEETS.SPREAD_TITLE]) {
          state.filters[SHEETS.SPREAD_TITLE] = buildSpreadTitleFilter({
            ...initSearch,
            ...state.searchCondition,
          });
        }
      }),
    // mount 시 sessionStorage 의 이전 filters cache 무효화 — incomplete payload 재사용 회피.
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),

    // ⭐ master hook §2.3 "UI 생성의 동적 속성관리" — Column 동적 fetch (SHEET_COLUMNS 66건, division 서버 필터).
    //   admin 변경 즉시 반영 (mount + Search + division 변경 시 호출). 하드코딩 fallback 없음 — 메타 주도.
    fetchStaticColumns: async () => {
      try {
        // 진입 시 개인화 복원 — 저장된 titleSet 을 먼저 조회해 override 를 확보한 뒤 메타에 적용.
        //   (별도 effect 로 분리하면 메타 응답과 순서 경쟁 → 늦게 온 쪽이 덮어쓰는 사고.)
        //   이미 있으면(모달 OK 직후 재조회) 서버 재조회 없이 그 값을 유지.
        if (get().userColumnLayout === null) await get().fetchUserColumnLayout();

        const result = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          {
            sheetNm: SHEETS.MAIN, // 'Sales Plan' — 등록명 그대로 (룰 #91)
            divisionId: get().searchCondition.divisionId,
          }
        );
        set(state => {
          const fetched = result.data.result ?? [];
          // 개인화 적용 전 원본 보관 — 팝업 Default 원복 기준 (개인화로 덮이지 않는다).
          state.originalStaticColumns = fetched;
          // 컬럼 설정(OK) 이후 재조회(Search/division 변경)가 개인화를 덮지 않도록 override 재적용.
          const layout = get().userColumnLayout;
          state.staticColumns =
            layout && layout.length > 0 ? applyLayoutToColumns(fetched, layout) : fetched;
        });

        if (get().initialized) return;

        const savedConditions = await apiClient.get<SavedSearchCondition[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        const savedParams = savedConditions.data.result ?? [];
        const restored = parseSavedSearchConditions(savedParams);

        set(state => {
          if (savedParams.length > 0) {
            state.searchCondition = { ...initSearch, ...restored };
          }
          state.filters = {};
          if (restored.startYyyymmdd || restored.endYyyymmdd) {
            state.dayRangeApplied = true;
          }
          state.initialized = true;
        });
      } catch {
        // BE 메타 미응답 시 silent — 빈 배열 유지 (console 금지 룰)
      }
    },

    // ⭐ master hook §5 — Measure 동적 fetch (SHEET_MEASURE 31건 — Measure Select 팝업 대상)
    fetchStaticMeasures: async () => {
      try {
        const result = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
          sheetNm: SHEETS.MAIN,
          divisionId: get().searchCondition.divisionId,
        });
        set(state => {
          state.staticMeasures = result.data.result ?? [];
        });
      } catch {
        // silent — 메타 미응답 시 빈 목록 유지 (하드코딩 fallback 금지, 사용자 룰 2026-07-15)
      }
    },

    // MAIN 커서 2/3 보관 — 편집 cutoff(당월/당주/M+3)·Insert 권한 산출 입력.
    setCalendarInfo: (calendar, editAuth) =>
      set(state => {
        state.calendarInfo = calendar;
        state.editAuth = editAuth;
      }),

    // PR_GET_DAY_RANGE o_rc2 'yyyymmdd:yyyymmdd' → 기본 Period (AS-IS drpPeriod.InitValue L511 1:1)
    applyDayRange: range => {
      if (!range || !/^\d{8}:\d{8}$/.test(range)) return;
      if (get().dayRangeApplied) return;
      const [start, end] = range.split(':');
      set(state => {
        state.searchCondition = {
          ...state.searchCondition,
          startYyyymmdd: start,
          endYyyymmdd: end,
        };
        state.dayRangeApplied = true;
      });
    },

    // 저장된 컬럼 개인화 복원 — ColumnLayoutModal 이 쓰는 SP 와 동일 계약
    //   (DMF0002_GET_TITLESET_POPUP). 조회 키(sheetName/columnType)는 팝업·저장과 반드시 같아야 한다.
    //   주의: SP 는 관리자 기본값(COLUMN_WIDTH/SORT_ORDER_NO)과 사용자값(USER_* 별칭)을 따로 내려준다 —
    //     사용자값을 우선하지 않으면 저장한 폭/순서가 영원히 안 보인다.
    fetchUserColumnLayout: async () => {
      try {
        const res = await apiClient.post<{ o_rc1?: Record<string, string>[] }>(
          `${MENU_ID}/titleSet/SEARCH/call-proc`,
          {
            programId: MENU_ID,
            sheetName: SHEETS.MAIN,
            columnType: TITLESET_COLUMN_TYPE,
            divisionId: get().searchCondition.divisionId,
          }
        );
        const rows = res.data.result?.o_rc1 ?? [];
        const orderOf = (r: Record<string, string>): number =>
          Number(r.USER_SORT_ORDER_NO ?? r.SORT_ORDER_NO ?? 0);
        // 표시 여부 = 사용자 저장값(USER_FLAG) 우선, 없으면 관리자 기본값(DEFAULT_FLAG).
        //   ColumnLayoutModal mapBeRow 와 동일 계약 — VISIBLE_FLAG 는 폴백으로 쓰지 않는다
        //   (그건 관리 노출 여부라, 폴백에 쓰면 기본 미표시 컬럼까지 전부 켜진다).
        const isShown = (r: Record<string, string>): boolean =>
          String(r.USER_FLAG ?? r.DEFAULT_FLAG ?? 'Y')
            .trim()
            .toUpperCase() === 'Y';
        const toSetting = (
          r: Record<string, string>,
          order: number,
          visible: boolean
        ): ColumnLayoutSetting => {
          const width = Number(r.USER_COLUMN_WIDTH ?? r.COLUMN_WIDTH ?? 0);
          return {
            colNm: String(r.COLUMN_NAME ?? ''),
            visible,
            width: Number.isFinite(width) && width > 0 ? width : DEFAULT_COL_WIDTH,
            cellColor: String(r.CELL_COLOR ?? ''),
            textColor: String(r.TEXT_COLOR ?? ''),
            order,
          };
        };
        const shown = rows
          .filter(isShown)
          .sort((a, b) => orderOf(a) - orderOf(b))
          .map((r, i) => toSetting(r, i + 1, true))
          .filter(s => s.colNm);
        // 비표시 컬럼도 함께 보관 — applyLayoutToColumns 는 '개인화에 없는 컬럼 = admin 기본값'
        //   이므로, 빠뜨리면 사용자가 끈 컬럼이 재조회마다 되살아난다.
        const hidden = rows
          .filter(r => !isShown(r))
          .map(r => toSetting(r, Number.MAX_SAFE_INTEGER, false))
          .filter(s => s.colNm);
        // 표시 컬럼이 하나도 없으면 개인화 없음으로 본다 — admin 메타 그대로 두어 빈 그리드 방지.
        if (shown.length === 0) return null;
        const layout = [...shown, ...hidden];
        set(state => {
          state.userColumnLayout = layout;
          // 메타가 이미 도착해 있으면 소급 적용 (호출 순서 무관하게 개인화가 유실되지 않게).
          if (state.staticColumns.length > 0) {
            state.staticColumns = applyLayoutToColumns(state.staticColumns, layout);
          }
        });
        return layout;
      } catch {
        // 개인화 조회 실패 = 기본 컬럼 세트로 동작 (화면 차단 금지, console 금지 룰)
        return null;
      }
    },

    clearUserColumnLayout: () =>
      set(state => {
        state.userColumnLayout = null;
      }),

    // ColumnLayoutModal OK — 표시/순서/폭/색을 grid 에 즉시 반영 (영구 저장은 titleSet SAVE 별도).
    applyColumnLayout: settings => {
      set(state => {
        // fetchStaticColumns 재조회 후 재적용 기준 — 표시 컬럼은 순서대로 1..n.
        //   비표시 컬럼도 visible:false 로 함께 보관한다(applyLayoutToColumns 는 미등록 컬럼을
        //   admin 기본값으로 두므로, 버리면 방금 끈 컬럼이 재조회 때 되살아난다).
        const shown = settings
          .filter(s => s.visible)
          .sort((a, b) => a.order - b.order)
          .map((s, i) => ({ ...s, order: i + 1 }));
        const hidden = settings
          .filter(s => !s.visible)
          .map(s => ({ ...s, order: Number.MAX_SAFE_INTEGER }));
        const layout = [...shown, ...hidden];
        state.userColumnLayout = layout;
        const cur = state.staticColumns;
        if (!cur || cur.length === 0) return;
        state.staticColumns = applyLayoutToColumns(cur, layout);
      });
    },

    // MeasureSelectModal OK — 표시할 measure 코드만 보관 (null = 전체 표시).
    applyVisibleMeasures: measureCodes => {
      set(state => {
        state.visibleMeasures = measureCodes;
      });
    },
  }),
  'sales-plan'
);
