import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { fetchTitleSet } from '@shared/components';
import { createPersistedStoreWithTab } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  ALL_SENTINEL,
  BOTTLENECK_ALL,
  DEFAULT_DIVISION_TYPE,
  DIVISION_TYPE,
  MENU_ID,
  SHEETS,
  TITLESET_COLUMN_TYPE,
  TITLESET_DIVISION_ID,
  sheetOf,
  type DivisionType,
  type GridSheet,
} from './capa-lob-report.constants';
import type {
  CapaLobFilters,
  CapaLobFiltersBySheet,
  CapaLobSearchParams,
} from './capa-lob-report.types';
import { buildSpreadTitleFilters } from './utils/capaLobReport.dateColumns';

/** ColumnLayoutModal 개인화 1행 — 표시/순서/폭/색. */
export interface ColumnLayoutSetting {
  colNm: string;
  visible: boolean;
  width: number;
  cellColor: string;
  textColor: string;
  order: number;
}

/**
 * 개인화 조회 결과 — 실패와 미저장을 **분리**해서 돌려준다(iter-3 감사 G-21).
 * 하나의 `null` 로 접으면 서버 오류가 "저장된 개인화 없음" 과 구분되지 않아 조용히 묻힌다.
 */
interface UserColumnLayoutResult {
  /** 조회 자체가 실패했는가(HTTP/envelope 오류). 컬럼 메타 실패와 같은 경로로 사용자에게 알린다. */
  failed: boolean;
  /** 저장된 개인화. `null` = 미저장. */
  settings: ColumnLayoutSetting[] | null;
}

type StaticColumnsBySheet = Record<GridSheet, RawFlexGridColumnConfig[]>;

/**
 * 개인화도 **시트별 2벌**이다(03 V-36). 단일 배열로 두면 CURRENT 에서 설정한 목록이 CUTOFF 에도
 * 적용돼 CUTOFF 전용 컬럼(`DV`/`SITE_ID`)이 목록에 없다는 이유로 `visible:false` 가 되고 순서가
 * 뒤섞인다(iter-1 G-05). AS-IS 팝업도 `_sheet_name` 을 키로 받는다(cs:1614~1623).
 */
type ColumnLayoutBySheet = Record<GridSheet, ColumnLayoutSetting[] | null>;

interface State {
  /** 컬럼 메타 fetch 완료 여부 — 컬럼 0건 판정의 "아직 안 왔다" 구분용. */
  initialized: boolean;
  /** F6 저장 조회조건 복원을 1회만 돌게 하는 가드(재진입·콤보 재도착 중복 호출 방지). */
  conditionsRestored: boolean;
  searchParams: CapaLobSearchParams;
  /**
   * Line Type 후보를 만든 기준 Operation 스냅샷 — **조회 파라미터가 아니다**(02 V-15).
   * AS-IS 는 `RefreshElectrodeType` 이 불린 시점의 Operation 으로 목록을 만들고, Site/Plant/
   * Building/Line 핸들러(cs:1533~1557)는 그 함수를 부르지 않아 목록을 갱신하지 않는다. 반면
   * 그 핸들러들은 Operation **선택값**은 비우므로(`setListBox` 재바인딩), `searchParams.operationId`
   * 를 그대로 후보 산출에 쓰면 AS-IS 가 갱신하지 않는 목록이 같이 바뀐다(iter-2 G-16).
   * 갱신 시점은 Division / DivisionType / Operation 변경 3곳뿐이다.
   */
  lineTypeOperationId: string;
  /** Search 로 실제 발사된 payload. 키가 없으면 그 시트 쿼리는 비활성(진입 자동조회 금지). */
  filters: CapaLobFiltersBySheet;
  openSearchArea: boolean;
  /** Version 3단에서 파생되는 읽기전용 표시값(`txtPlanType`) — 조회 파라미터가 아니다(01 L-09). */
  planType: string;
  /** 그 버전의 현재 진행상태(`PROG_STAT`) — Search 차단 게이트(01 L-22)의 판정값. */
  currVersionProgressStatus: string;
  /** admin `SCM_MST_SHEET_COLUMNS` — 시트별 2벌(CURRENT 14 / CUTOFF 15행). */
  staticColumns: StaticColumnsBySheet;
  /** 개인화 적용 전 admin 원본 — 컬럼설정 모달의 Default 복원 기준. */
  originalStaticColumns: StaticColumnsBySheet;
  /** 컬럼 개인화 — **시트별**(CURRENT/CUTOFF 분리, 03 V-36). */
  userColumnLayout: ColumnLayoutBySheet;
  /**
   * 컬럼 축 조회 실패 여부 — 빈 catch 로 삼키지 않는다(iter-1 G-11). 컬럼 0건의 원인 표시용.
   * admin 컬럼 메타와 **개인화(titleSet) 조회** 둘 다 이 플래그로 모인다(iter-3 감사 G-21).
   */
  columnMetaFailed: boolean;
}

interface Action {
  reset: () => void;
  /** F6 개인화 조회조건 복원(mount 1회) — GET /admin/menu/{MENU_ID}/search-conditions → searchParams 패치. */
  restoreSearchConditions: () => Promise<void>;
  setSearchParams: (patch: Partial<CapaLobSearchParams>) => void;
  /** Division 변경(싱글 콤보) = Division·부모축 제외 검색조건 전부 초기화 + 그리드 초기화(TO-BE 공통 요건). */
  setDivision: (divisionId: string) => void;
  /** Line Type 후보 재계산 트리거 — Division / DivisionType / Operation 변경에서만 호출한다(02 V-15). */
  syncLineTypeSource: (operationId: string) => void;
  setDerivedVersionInfo: (planType: string, currVersionProgressStatus: string) => void;
  setFilters: (payload: CapaLobFilters) => void;
  clearFilters: () => void;
  refreshSpreadTitle: (fromYyyymm: string) => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  applyColumnLayout: (sheetName: GridSheet, settings: ColumnLayoutSetting[]) => void;
  clearUserColumnLayout: (sheetName: GridSheet) => void;
}

const GRID_SHEETS: readonly GridSheet[] = [SHEETS.CURRENT, SHEETS.CUTOFF];

const emptyColumns = (): StaticColumnsBySheet => ({
  [SHEETS.CURRENT]: [],
  [SHEETS.CUTOFF]: [],
});

const emptyLayout = (): ColumnLayoutBySheet => ({
  [SHEETS.CURRENT]: null,
  [SHEETS.CUTOFF]: null,
});

/**
 * 초기 조회조건 (02 §4.2 기본값 표 전건).
 * DivisionType 만 AS-IS 가 Form_Load 마지막 줄에서 명시 대입하는 `CELL` 로 고정하고(cs:975),
 * 단일 콤보 3축(Division/Plan Month/Version)은 옵션이 로드된 뒤 훅이 "목록 첫 행" 을 채운다
 * (AS-IS `setListBox` 가 `DataSource` 만 지정해 `SelectedIndex=0` 이 되는 동작 재현).
 * 다중선택 6축은 `ALL` sentinel(= 무선택 = 전체), Bottleneck 은 `'ALL'` 선두 옵션이 기본 선택이다.
 */
const initSearch: CapaLobSearchParams = {
  divisionType: DEFAULT_DIVISION_TYPE,
  divisionId: '',
  verId: '',
  verSeq: '',
  progressStatus: '',
  siteId: ALL_SENTINEL,
  plantId: ALL_SENTINEL,
  factoryId: ALL_SENTINEL,
  lineId: ALL_SENTINEL,
  operationId: ALL_SENTINEL,
  electrodeType: ALL_SENTINEL,
  nickName: '',
  bottleneckFlag: BOTTLENECK_ALL,
};

/** 복원 시 DivisionType 유니온 오염 방지 — 알 수 없는 값은 무시한다(시트/마스터 축 결정값). */
const VALID_DIVISION_TYPES = new Set<string>(Object.values(DIVISION_TYPE));

const initState: State = {
  initialized: false,
  conditionsRestored: false,
  searchParams: initSearch,
  lineTypeOperationId: ALL_SENTINEL,
  filters: {},
  openSearchArea: true,
  planType: '',
  currVersionProgressStatus: '',
  staticColumns: emptyColumns(),
  originalStaticColumns: emptyColumns(),
  userColumnLayout: emptyLayout(),
  columnMetaFailed: false,
};

/**
 * 폭 0 -> 비표시 매핑 **규칙 1개** (03 R-22 / V-06).
 * CURRENT/CUTOFF 메타는 `VISIBLE_FLAG='N'` 이 0건이고 숨김이 전부 `COLUMN_WIDTH=0` 으로 표현돼 있다
 * (03 §1.0 실측). AS-IS `SetVisibleSheetColumn` 은 정의 부재(03 C-01)지만 인자 조합상 "조회모드 기본
 * 가시성" 이고 화면 고유 숨김 목록이 없으므로 이 한 규칙으로 재현된다.
 * `display:false` 까지 내려야 컬럼설정 모달·우클릭 Hide 목록에도 노출되지 않는다.
 * 주의: AS-IS 컬럼명 배열을 코드로 이식하지 않는다(hook #130) — 폭은 메타가 준 값이다.
 */
const hideZeroWidthColumns = (
  columns: readonly RawFlexGridColumnConfig[]
): RawFlexGridColumnConfig[] =>
  columns.map(column =>
    (column.colWth ?? 0) > 0 ? column : { ...column, visible: false, display: false }
  );

/** titleSet 응답 1칸 정규화 — SP 가 NULL 을 주는 별칭(`USER_SORT_ORDER_NO` 등)이 있어 한 번 거른다. */
const toText = (value: string | null | undefined): string => value ?? '';

/** 숫자 별칭 파싱 — 0·공백·비수치는 "값 없음"(0)으로 본다(폭 0 은 admin 숨김 규칙 쪽 축이다). */
const toPositiveNumber = (value: string | null | undefined): number => {
  const parsed = Number(toText(value));
  return Number.isFinite(parsed) && parsed > 0 ? parsed : 0;
};

/**
 * 저장된 컬럼 개인화 **복원**(`SCM_MST_TITLESET_USER`, 03 R-17 / V-37 / iter-2 G-15).
 *
 * 저장(`CapaLobReportColumnModal` -> `saveTitleSet`)만 배선하면 서버에 행은 쌓이는데 아무도 읽지
 * 않아 새 탭·새로고침·다른 PC 에서 설정이 사라진다 — 이 store 는 `createPersistedStoreWithTab`
 * 이지만 persist 미들웨어가 없어 탭 메모리 전용이다(`packages/shared/src/stores/createStore.ts`).
 * AS-IS 는 이 개인화를 실제로 154행(CURRENT 88 / CUTOFF 66) 쓰고 있다.
 *
 * `fetchGridLayout`(공용 파서) 대신 `fetchTitleSet` 원시 응답을 직접 읽는 이유: 공용 파서는
 * 표시/순서/폭만 돌려주고 **색(CELL_COLOR/TEXT_COLOR)을 버린다**. 이 화면의 저장 계약에는 색이
 * 들어 있어(모달 onSave) 색까지 복원해야 저장한 그대로 돌아온다.
 * 별칭 우선순위는 `ColumnLayoutModal` 의 `mapBeRow` 와 동일 계약이다 — 사용자 저장값(USER_*) 우선,
 * 없으면 관리자 기본값. **`VISIBLE_FLAG` 폴백 금지**(그건 "목록에 존재하는가" 축이라 기본 미표시
 * 컬럼까지 전부 켜진다).
 *
 * @returns 조회 실패 여부와 저장된 개인화. `settings: null` = 미저장(= 덧씌우지 않고 admin 메타 그대로).
 */
const fetchUserColumnLayout = async (sheetName: string): Promise<UserColumnLayoutResult> => {
  const rows = await fetchTitleSet({
    menuId: MENU_ID,
    sheetName,
    columnType: TITLESET_COLUMN_TYPE,
    divisionId: TITLESET_DIVISION_ID,
  });
  // 공용 계약(`titleSetApi.ts` `fetchTitleSet` 주석): `null` = 조회 실패 / `[]` = 저장된 개인화 없음.
  //   둘을 한 값으로 접으면 서버 오류가 "개인화 없음" 으로 보여 원인을 못 찾는다.
  if (!rows) return { failed: true, settings: null };
  if (rows.length === 0) return { failed: false, settings: null };
  const settings = rows
    .filter(row => toText(row.COLUMN_NAME) !== '')
    .map((row, index) => ({
      colNm: toText(row.COLUMN_NAME),
      visible:
        (toText(row.USER_FLAG) || toText(row.DEFAULT_FLAG) || 'Y').toUpperCase() === 'Y',
      width: toPositiveNumber(row.USER_COLUMN_WIDTH ?? row.COLUMN_WIDTH ?? row.COL_WIDTH),
      cellColor: toText(row.CELL_COLOR),
      textColor: toText(row.TEXT_COLOR),
      order: toPositiveNumber(row.USER_SORT_ORDER_NO ?? row.SORT_ORDER_NO) || index + 1,
    }));
  return { failed: false, settings: settings.length > 0 ? settings : null };
};

/** 개인화(표시/순서/폭/색)를 admin 메타 위에 덧씌운다 — 목록에 없는 컬럼은 비표시가 규약이다. */
const applyLayoutToColumns = (
  columns: RawFlexGridColumnConfig[],
  settings: ColumnLayoutSetting[]
): RawFlexGridColumnConfig[] => {
  const byColumn = new Map(settings.map(setting => [setting.colNm, setting]));
  return columns
    .map(column => {
      // 관리자 비노출(폭 0 포함) 컬럼은 저장된 개인화에 남아 있어도 절대 표시하지 않는다.
      if (column.visible === false || column.display === false) {
        return { ...column, visible: false, display: false };
      }
      const setting = byColumn.get(column.colNm);
      if (!setting) return { ...column, visible: false };
      return {
        ...column,
        visible: setting.visible,
        // 저장 응답이 폭을 안 실어 오는 경우가 있다 — 0 을 그대로 쓰면 컬럼이 시각적으로 사라진다.
        colWth: setting.width > 0 ? setting.width : column.colWth,
        cellColor: setting.cellColor,
        textColor: setting.textColor,
      };
    })
    .sort(
      (a, b) =>
        (byColumn.get(a.colNm)?.order ?? Number.MAX_SAFE_INTEGER) -
        (byColumn.get(b.colNm)?.order ?? Number.MAX_SAFE_INTEGER)
    );
};

/**
 * SCP0108 CAPA LOB Report 스토어.
 *
 * `createPersistedStoreWithTab` 필수 — MDI 탭 격리(hook #72 / 01 V-22). 싱글톤 `create` 금지.
 * **서버 데이터를 담지 않는다**(SSOT = React Query). 그리고 이 화면에는 다음 필드를 만들지 않는다:
 *  - `isEditMode` — `IsEditMode` 가 true 가 되는 경로가 AS-IS 에 없다(01 L-33 / 03 V-31).
 *  - `staticMeasures`/`fetchStaticMeasures` — `SCM_MST_SHEET_MEASURE` 0행이 정답이다(03 §1.5 / V-04).
 */
export const useCapaLobReportStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),

    /**
     * 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 자매 SCP0105 `restoreSearchConditions`.
     *
     * 저장측은 Page 가 `<SubTitle searchParam={sp}>` 로 이미 배선돼 있으나(F6), 복원측이 없으면 저장은
     * 되는데 **새로고침/재진입 시 조건이 사라진다**(basic-check #3 재발 함정). GET
     * `/admin/menu/{MENU_ID}/search-conditions` → `paramNm/paramCtn` 역직렬화.
     * divisionType 만 유니온 검증, 나머지 12필드는 전부 string(다중선택 6축도 `,` 결합 문자열·ALL
     * sentinel 이라 평문 patch). 날짜 조회조건이 0건이라 저장측 `EXCLUDED_DATE_PARAM` 제외 대상도 없다.
     *
     * `searchParams` 만 patch 하고 `filters` 는 건드리지 않아 진입 자동조회 금지 게이트(03 V-21)를
     * 위반하지 않는다. 복원은 `{...searchParams,...patch}` 직접 병합으로 setDivision cascade 를
     * 경유하지 않는다(하위 6축을 ALL 로 날려 복원값이 지워진다). 콤보 기본선택 effect
     * (useCapaLobReportCombos 229~256)는 `options.some` 가드라 복원값이 후보에 있으면 유지하고,
     * 복원이 비동기 후행이라 최종 승리한다.
     *
     * 미저장/실패/미등록(`PKG_SCP0108`·`SCM_ADM_MNU_M` SCP0108 미배포)이면 런타임 no-op(기본값 유지)다
     * — 배선 자체는 파리티 요건이라 배포·등록과 무관하게 선적용한다(goal.md BLK-1/BLK-2).
     */
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
        const patch: Partial<CapaLobSearchParams> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in initSearch)) continue; // SearchParams 필드만 allowlist
          const val = paramCtn ?? '';
          if (paramNm === 'divisionType') {
            if (VALID_DIVISION_TYPES.has(val)) patch.divisionType = val as DivisionType;
            continue;
          }
          patch[paramNm as Exclude<keyof CapaLobSearchParams, 'divisionType'>] = val;
        }
        set(state => {
          state.searchParams = { ...state.searchParams, ...patch };
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지 룰).
      }
    },

    setSearchParams: patch =>
      set(state => {
        state.searchParams = { ...get().searchParams, ...patch };
      }),

    /**
     * Division 변경(싱글 콤보) = TO-BE 공통 요건: Division(새 값)·부모 모드축(divisionType)을 제외한
     *   검색조건을 전부 초기화한다(사용자 지시 2026-10-02 — TO-BE 공통 요건이 AS-IS 핸들러보다 우선, SCP0025 선례).
     *   - 유지: divisionId(새 값) + divisionType(Division 위 shopGroup 모드 축). `...initSearch` 가 divisionType 을
     *     DEFAULT(CELL)로 되돌리므로 명시 유지해야 파리티다(자매 SCP0105 선례 — division-reset-preserve-parent-axis).
     *     이 화면엔 기간/날짜 검색조건이 없다(기간 헤더는 Plan Month 파생 — searchParams 밖).
     *   - 초기화: 그 외 전 조건(Plan Month/Version/Status/6축/Basic Nickname/Bottleneck) + Line Type 후보 스냅샷.
     *     AS-IS `cboDivision_SelectedIndexChanged -> RefreshAll` 은 하위 6축만 비우지만, 공통 요건은 Item/Bottleneck 도
     *     초기화한다(AS-IS 미초기화를 근거로 생략하지 않는다 — skill §검증).
     *   그리드 비움은 조건 effect(useCapaLobReportConditionEffects)가 divisionId 변경을 감지해 clearFilters() 로
     *   수행한다 — 여기서 filters 를 직접 비우지 않아야 기간헤더(spreadTitle) 참조가 보존된다(연쇄 재생성 방지).
     *   편집중(dirty) 가드(MSG00704)는 Form 의 onChange 가 confirmIfDirtyKey 로 처리한다(commit 51d4e9fa).
     *   이 화면은 조회전용(read-only)이라 실제 dirty 는 없지만 공통 패턴을 동일하게 둔다(SCP0025 선례).
     */
    setDivision: divisionId =>
      set(state => {
        state.searchParams = {
          ...initSearch,
          divisionType: get().searchParams.divisionType,
          divisionId,
        };
        state.lineTypeOperationId = ALL_SENTINEL;
      }),

    syncLineTypeSource: operationId =>
      set(state => {
        if (state.lineTypeOperationId !== operationId) state.lineTypeOperationId = operationId;
      }),

    setDerivedVersionInfo: (planType, currVersionProgressStatus) =>
      set(state => {
        if (state.planType !== planType) state.planType = planType;
        if (state.currVersionProgressStatus !== currVersionProgressStatus) {
          state.currVersionProgressStatus = currVersionProgressStatus;
        }
      }),

    /**
     * Search(F5) — payload 참조를 갈아끼운다. `refetch()` 를 직접 부르지 않는다(nscm-patterns §5-1).
     * 시트는 `progressStatus`(사용자 조작 불가 파생값)가 정한다 — `_sheet_name`(cs:376~389) 등가.
     * 기간 헤더는 Plan Month 가 유효할 때만 싣는다(03 §4.1 #2 가드).
     */
    setFilters: payload =>
      set(state => {
        const sheetName = sheetOf(state.searchParams.progressStatus);
        const spreadTitle = state.filters[SHEETS.SPREAD_TITLE];
        state.filters = {
          [sheetName]: payload,
          ...(spreadTitle ? { [SHEETS.SPREAD_TITLE]: spreadTitle } : {}),
        };
      }),

    /**
     * 컬럼셋 재조립 트리거 = **그리드 비움**(03 §2.6 / R-16 / V-43).
     * Division·Plan Month·Version·DivisionType 변경 / Column 설정 OK / 진입 / 시트 전환 7종이 여기로 온다.
     * 기간 헤더(`spreadTitle`)는 지우지 않는다 — AS-IS `BeforeFindData()` 도 `InitSpread()`(시트 비움)
     * 직후 `RefreshSheetHeader(true)` 로 헤더를 즉시 다시 만든다(cs:1312~1319). 갱신은
     * `refreshSpreadTitle()` 이 담당한다. **자동 재조회는 하지 않는다**(hook #132 §2-2).
     */
    clearFilters: () =>
      set(state => {
        const keys = Object.keys(state.filters);
        // 이미 비어 있으면(그리드 payload 가 없으면) 참조를 새로 만들지 않는다 — 조건 축이 연달아
        //   바뀌어도 그리드가 두 번 깜빡이지 않게 한다(공통 QA "조회조건 변경 시 깜빡임").
        if (keys.every(key => key === SHEETS.SPREAD_TITLE)) return;
        const spreadTitle = state.filters[SHEETS.SPREAD_TITLE];
        state.filters = spreadTitle ? { [SHEETS.SPREAD_TITLE]: spreadTitle } : {};
      }),

    /**
     * 기간 헤더 재조회 — AS-IS `RefreshSheetHeader(true)` -> `GetSpdTitle()`(cs:1175~1193).
     * 호출 지점이 조회(F5)가 아니다: Form_Load(`CreateSpread`)와 Division/Plan Month/Version/
     * DivisionType 변경, 컬럼설정 OK 다(03 §2.6) — 즉 **헤더는 조회 전에도 최신**이다.
     * 내용이 같으면 참조를 유지한다(참조가 바뀌면 컬럼이 통째로 재생성된다).
     */
    refreshSpreadTitle: fromYyyymm =>
      set(state => {
        const prev = state.filters[SHEETS.SPREAD_TITLE];
        if (!fromYyyymm) {
          if (prev) delete state.filters[SHEETS.SPREAD_TITLE];
          return;
        }
        if (prev?.fromYyyymm === fromYyyymm) return;
        state.filters[SHEETS.SPREAD_TITLE] = buildSpreadTitleFilters(fromYyyymm);
      }),

    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),

    /**
     * admin 컬럼 메타 fetch(2시트) — mount 1회 + **매 Search 마다** refetch(CLAUDE.md §2 체크3).
     * `MAIN` 15행은 BE 가 `VALID_YN='Y'` 로 걸러 오지 않는다 — `SHEETS` 유니온에도 없다(03 §0.3 / V-05).
     * `divisionId` 는 넘기지 않는다: 메타 44행의 `DIVISION_ID` 가 전건 NULL = division 별 컬럼 분기가
     * 없다(03 §1.0, hook #92/#113).
     * 같은 호출에서 **저장된 컬럼 개인화도 복원**한다(03 R-17 / V-37) — mount·Search·컬럼설정 OK 뒤
     * 모두 이 경로를 지나므로 복원 진입점이 따로 필요하지 않다.
     */
    fetchStaticColumns: async () => {
      let failed = false;
      await Promise.all(
        GRID_SHEETS.map(async sheet => {
          try {
            const sheetNm = ADMIN_SHEET_NAME[sheet];
            // admin 메타와 저장된 개인화를 **함께** 받는다 — 순차로 받으면 컬럼이 두 번 갈린다.
            const [response, userLayout] = await Promise.all([
              apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
                sheetNm,
              }),
              fetchUserColumnLayout(sheetNm),
            ]);
            // 개인화 조회 실패도 컬럼 메타 실패와 같은 축으로 알린다 — 조용히 "미저장" 으로 접지 않는다.
            if (userLayout.failed) failed = true;
            const savedLayout = userLayout.settings;
            const next = hideZeroWidthColumns(response.data.result ?? []);
            if (next.length === 0) return;
            set(state => {
              // 개인화는 **그 시트의 것만** 덧씌운다 — 시트를 섞으면 상대 시트 전용 컬럼이 사라진다(V-36).
              //   서버 저장본이 정본이고, 없으면(미저장·조회실패) 탭 메모리의 직전 적용분을 유지한다.
              const layout = savedLayout ?? get().userColumnLayout[sheet];
              if (savedLayout) state.userColumnLayout[sheet] = savedLayout;
              const applied =
                layout && layout.length > 0 ? applyLayoutToColumns(next, layout) : next;
              // 내용이 같으면 set 을 건너뛴다 — 참조가 바뀌면 그리드가 컬럼을 통째로 재생성한다.
              if (JSON.stringify(state.staticColumns[sheet]) !== JSON.stringify(applied)) {
                state.staticColumns[sheet] = applied;
              }
              state.originalStaticColumns[sheet] = next;
            });
          } catch {
            // 실패를 조용히 삼키지 않는다(iter-1 G-11) — 빈 배열은 유지하되 플래그를 남겨
            //   페이지가 `MSG01052` 로 원인을 알린다(console 금지 룰이라 로그 대신 상태로 표현).
            failed = true;
          }
        })
      );
      set(state => {
        state.initialized = true;
        if (state.columnMetaFailed !== failed) state.columnMetaFailed = failed;
      });
    },

    /** 컬럼설정 모달 OK — 표시/순서/폭/색을 즉시 반영하고 이후 refetch 에도 재적용한다(시트별). */
    applyColumnLayout: (sheetName, settings) =>
      set(state => {
        const layout = settings
          .filter(setting => setting.visible)
          .sort((a, b) => a.order - b.order)
          .map((setting, index) => ({ ...setting, order: index + 1 }));
        state.userColumnLayout[sheetName] = layout;
        const current = state.staticColumns[sheetName];
        if (!current || current.length === 0) return;
        state.staticColumns[sheetName] = applyLayoutToColumns(current, layout);
      }),

    clearUserColumnLayout: sheetName =>
      set(state => {
        state.userColumnLayout[sheetName] = null;
      }),
  }),
  'capa-lob-report-store'
);
