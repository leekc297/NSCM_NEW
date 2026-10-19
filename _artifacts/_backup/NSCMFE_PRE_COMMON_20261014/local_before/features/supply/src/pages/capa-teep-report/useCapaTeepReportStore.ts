import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  ALL_SENTINEL,
  DEFAULT_DIVISION_TYPE,
  MENU_ID,
  SHEETS,
  type GridSheet,
} from './capa-teep-report.constants';
import type {
  CapaTeepFilters,
  CapaTeepFiltersBySheet,
  CapaTeepSearchParams,
} from './capa-teep-report.types';
import { buildSpreadTitleFilters } from './utils/capaTeepReport.dateColumns';

/**
 * `SCM_MST_SHEET_MEASURE` 동적 fetch 행(BE GridMeasure DTO 직렬화라 camelCase 다).
 * 이 화면은 PIVOT measure 화면이라 메타가 56행(28+28) 존재하므로 **하드코딩 배열을 두지 않고
 * 동적 fetch 한다**(CLAUDE.md §2 체크3 / hook #66 / 03 §4.1). 표시 자체는 GET SP 가 measure 행을
 * 이미 조인해 내려주므로(03 §4.3) 렌더 소비처는 없다 — 값은 Measure Setting 아이콘 배선이 붙을 때
 * 소비된다(현 회차 미노출, 04 리포트 "확인 필요" 참조).
 */
export interface MeasureMeta {
  colNm: string;
  colLblNm?: string;
  display?: boolean;
  personalizable?: boolean;
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

type StaticColumnsBySheet = Record<GridSheet, RawFlexGridColumnConfig[]>;
type StaticMeasuresBySheet = Record<GridSheet, MeasureMeta[]>;

/**
 * 개인화도 **시트별 2벌**이다 — AS-IS 팝업 인자가 `_division_type_name`(ASSEMBLY/ELTR)이라 시트마다
 * 설정이 따로다(03 §0.2, cs:1767). 한 벌로 합치면 ASSEMBLY 전용 컬럼(`ELTR_LN_TP_CD`)이 ELTR 목록에
 * 없다는 이유로 `visible:false` 가 되고 순서가 뒤섞인다(자매 SCP0108 iter-1 G-05).
 */
type ColumnLayoutBySheet = Record<GridSheet, ColumnLayoutSetting[] | null>;

interface State {
  /** 컬럼 메타 fetch 완료 여부 — "컬럼 0건" 과 "아직 안 왔다" 를 구분한다. */
  initialized: boolean;
  searchParams: CapaTeepSearchParams;
  /** Search 로 실제 발사된 payload. 키가 없으면 그 시트 쿼리는 비활성(진입 자동조회 금지). */
  filters: CapaTeepFiltersBySheet;
  openSearchArea: boolean;
  /** Version 3단에서 파생되는 읽기전용 표시값(`txtPlanType`) — 조회 파라미터가 아니다(02 §2.2 C4). */
  planType: string;
  /** 그 버전의 현재 진행상태(`PROG_STAT`) — Search 차단 게이트(02 §4.4)의 판정값. */
  currVersionProgressStatus: string;
  /**
   * Line Type 목록의 Operation 축 **스냅샷**.
   * AS-IS 는 `RefreshElectrodeType`(Division / Plan Month / Version / Operation group / Operation 변경)
   * 에서만 Line Type 목록을 다시 만들고, Site~Line 핸들러는 그 함수를 호출하지 않는다(02 §3.2 비대칭 1).
   * `searchParams.operationId` 를 그대로 쓰면 Site 변경으로 Operation 이 리셋될 때 Line Type 목록까지
   * 따라 바뀌어 AS-IS 와 달라진다. 그래서 갱신 시점을 명시 제어한다.
   */
  lineTypeOperationId: string;
  /** admin `SCM_MST_SHEET_COLUMNS` — 시트별 2벌(ASSEMBLY 25 / ELTR 25행). */
  staticColumns: StaticColumnsBySheet;
  /** 개인화 적용 전 admin 원본 — 컬럼설정 모달의 Default 복원 기준. */
  originalStaticColumns: StaticColumnsBySheet;
  /** admin `SCM_MST_SHEET_MEASURE` — 시트별 2벌(28/28행). */
  staticMeasures: StaticMeasuresBySheet;
  /** 컬럼 개인화 — 시트별(ASSEMBLY/ELTR 분리, 03 §0.2). */
  userColumnLayout: ColumnLayoutBySheet;
  /** 컬럼 메타 조회 실패 여부 — 빈 catch 로 삼키지 않는다. 컬럼 0건의 원인 표시용. */
  columnMetaFailed: boolean;
}

interface Action {
  reset: () => void;
  setSearchParams: (patch: Partial<CapaTeepSearchParams>) => void;
  /** Line Type 목록 축까지 함께 갱신하는 변경(AS-IS `RefreshAll`/`RefreshElectrodeType` 경로). */
  setSearchParamsWithLineTypeRefresh: (patch: Partial<CapaTeepSearchParams>) => void;
  setDerivedVersionInfo: (planType: string, currVersionProgressStatus: string) => void;
  setFilters: (sheetName: GridSheet, payload: CapaTeepFilters) => void;
  clearFilters: () => void;
  refreshSpreadTitle: (fromYyyymm: string, sheetName: GridSheet) => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchStaticMeasures: () => Promise<void>;
  applyColumnLayout: (sheetName: GridSheet, settings: ColumnLayoutSetting[]) => void;
}

const GRID_SHEETS: readonly GridSheet[] = [SHEETS.ASSEMBLY, SHEETS.ELTR];

const emptyColumns = (): StaticColumnsBySheet => ({
  [SHEETS.ASSEMBLY]: [],
  [SHEETS.ELTR]: [],
});

const emptyMeasures = (): StaticMeasuresBySheet => ({
  [SHEETS.ASSEMBLY]: [],
  [SHEETS.ELTR]: [],
});

const emptyLayout = (): ColumnLayoutBySheet => ({
  [SHEETS.ASSEMBLY]: null,
  [SHEETS.ELTR]: null,
});

/**
 * 초기 조회조건 (02 §4.2 기본값 표 전건).
 * 다중선택 6축 + Division 은 `ALL` sentinel(= 무선택 = 전체)로 시작한다 — Designer 6종 전건
 * `ALL_VIEW=true`/`ValueList="ALL"`(02 §1.1). 단일 콤보 2축(Plan Month/Version)은 옵션이 로드된 뒤
 * 훅이 "목록 첫 행"(= 최신 `VER_ID` / 최대 `VER_SEQ`)을 채운다 — AS-IS `setListBox` 가 `DataSource` 만
 * 지정해 `SelectedIndex=0` 이 되는 동작 재현(02 §4.2).
 * `divisionType` 만 사용자 확정값 `Electrode` 로 명시한다(goal D-1 — 재판단 금지).
 */
const initSearch: CapaTeepSearchParams = {
  divisionType: DEFAULT_DIVISION_TYPE,
  divisionId: ALL_SENTINEL,
  verId: '',
  verSeq: '',
  siteId: ALL_SENTINEL,
  plantId: ALL_SENTINEL,
  factoryId: ALL_SENTINEL,
  lineId: ALL_SENTINEL,
  operationId: ALL_SENTINEL,
  electrodeType: ALL_SENTINEL,
};

const initState: State = {
  initialized: false,
  searchParams: initSearch,
  filters: {},
  openSearchArea: true,
  planType: '',
  currVersionProgressStatus: '',
  lineTypeOperationId: ALL_SENTINEL,
  staticColumns: emptyColumns(),
  originalStaticColumns: emptyColumns(),
  staticMeasures: emptyMeasures(),
  userColumnLayout: emptyLayout(),
  columnMetaFailed: false,
};

/**
 * 숨김 컬럼 판정 — **`colWth === 0` 또는 `visible === false` 이중** 이다(03 §0.1 / S-11 / V-03).
 *
 * AS-IS 는 `SCM_SYS_GET_SPREAD_TITLE` 의 개인화 미적용 분기에서 `VISIBLE_FLAG='Y'` 행만 돌려준다 —
 * 즉 `'N'` 컬럼은 그리드에 **생성 자체가 되지 않는다**. 반면 TO-BE `PR_GET_SHEET_COLUMN_LIST` 계열은
 * `VALID_YN='Y'` 만 걸고 전건을 돌려주므로, FE 가 `visible` 을 보지 않으면 AS-IS 에 없는 컬럼이 살아난다.
 * 이 화면에서 그 차이가 드러나는 행은 **ELTR `ELTR_LN_TP_CD`**(폭 100 · `VISIBLE_FLAG='N'` · GET SP 도
 * 미반환)다 — `colWth===0` 만 보면 못 걸러 빈 컬럼 1개가 생긴다(V-02, ora.py 실측 재확인 2026-09-25).
 *
 * `display:false` 까지 내려야 컬럼설정 모달·우클릭 Hide 목록에도 노출되지 않는다(03 §0.2 선택목록 12/11).
 * AS-IS 숨김 컬럼명 배열 13종은 이식하지 않는다(hook #130 / 03 G-15) — 신호는 메타에서만 읽는다.
 */
const hideInvisibleColumns = (
  columns: readonly RawFlexGridColumnConfig[]
): RawFlexGridColumnConfig[] =>
  columns.map(column =>
    (column.colWth ?? 0) === 0 || column.visible === false
      ? { ...column, visible: false, display: false }
      : column
  );

/** 개인화(표시/순서/폭/색)를 admin 메타 위에 덧씌운다 — 목록에 없는 컬럼은 비표시가 규약이다. */
const applyLayoutToColumns = (
  columns: RawFlexGridColumnConfig[],
  settings: ColumnLayoutSetting[]
): RawFlexGridColumnConfig[] => {
  const byColumn = new Map(settings.map(setting => [setting.colNm, setting]));
  return columns
    .map(column => {
      // 관리자 비노출(폭 0 / VISIBLE_FLAG='N') 컬럼은 저장된 개인화에 남아 있어도 절대 표시하지 않는다.
      if (column.visible === false || column.display === false) {
        return { ...column, visible: false, display: false };
      }
      const setting = byColumn.get(column.colNm);
      if (!setting) return { ...column, visible: false };
      return {
        ...column,
        visible: setting.visible,
        colWth: setting.width,
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
 * SCP0107 CAPA TEEP Report 스토어.
 *
 * `createPersistedStoreWithTab` 필수 — MDI 탭 격리(nscm-patterns §3.6). 싱글톤 `create` 금지.
 * **서버 데이터를 담지 않는다**(SSOT = React Query). 그리고 이 화면에는 다음 필드를 만들지 않는다:
 *  - `isEditMode` — `IsEditMode` 가 true 가 되는 경로가 AS-IS 에 0건이다(01 L-21 / 03 §3.4).
 *  - 저장 관련 일체 — `SetQueryInfoSave*` 0건, SAVE SP 부재(03 §4.4 / V-29).
 */
export const useCapaTeepReportStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),

    setSearchParams: patch =>
      set(state => {
        state.searchParams = { ...get().searchParams, ...patch };
      }),

    /**
     * Line Type 목록 축까지 갱신하는 변경.
     * AS-IS 에서 `RefreshElectrodeType` 에 도달하는 경로는 `RefreshAll` 4트리거(Division / Plan Month /
     * Version / Operation group)와 `clbOperation` 변경뿐이다(02 §3.2). Site~Line 변경은 여기로 오지 않는다.
     */
    setSearchParamsWithLineTypeRefresh: patch =>
      set(state => {
        const next = { ...get().searchParams, ...patch };
        state.searchParams = next;
        state.lineTypeOperationId = next.operationId;
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
     * 확정 시트 1건만 담으므로 두 시트 데이터를 동시에 들고 있지 않다(03 G-01).
     * 기간 헤더(`spreadTitle`)는 조회에 묶여 있지 않아 기존 값을 유지한다 — 갱신은 `refreshSpreadTitle`
     * 담당이다(AS-IS `GetSpdTitle` 호출 지점이 `FindButton` 이 아니다, 03 §2.5).
     */
    setFilters: (sheetName, payload) =>
      set(state => {
        const spreadTitle = state.filters.spreadTitle;
        state.filters = {
          [sheetName]: payload,
          ...(spreadTitle ? { spreadTitle } : {}),
        };
      }),

    /**
     * 그리드 비움 = AS-IS `BeforeFindData()`(cs:1422~1429 = `InitSpread` + `RefreshSheetHeader(true)` +
     * `SetVisibleSheetColumns`). 호출 지점은 **Division / Plan Month / Version / Operation group 4개 +
     * Column 설정 OK + 진입** 이다(03 §2.5). Site~Operation 변경은 그리드를 건드리지 않는다(02 §3.2 비대칭 2).
     * 기간 헤더는 지우지 않는다 — AS-IS 도 시트를 비운 직후 헤더를 즉시 다시 만든다.
     * **자동 재조회는 하지 않는다**(hook #132 / V-12 / V-34).
     */
    clearFilters: () =>
      set(state => {
        const keys = Object.keys(state.filters);
        // 이미 비어 있으면 참조를 새로 만들지 않는다 — 조건 축이 연달아 바뀌어도 그리드가 두 번
        //   깜빡이지 않게 한다(공통 QA "조회조건 변경 시 깜빡임").
        if (keys.every(key => key === 'spreadTitle')) return;
        const spreadTitle = state.filters.spreadTitle;
        state.filters = spreadTitle ? { spreadTitle } : {};
      }),

    /**
     * 기간 헤더 재조회 — AS-IS `RefreshSheetHeader(true)` -> `GetSpdTitle()`(cs:1200~1223).
     * 호출 지점이 조회(F5)가 아니라 `CreateSpread`(진입) + 위 4개 조건 변경 + 컬럼설정 OK 다(03 §2.5)
     * — 즉 **헤더는 조회 전에도 최신**이다. 내용이 같으면 참조를 유지한다(참조가 바뀌면 컬럼 전체 재생성).
     */
    refreshSpreadTitle: (fromYyyymm, sheetName) =>
      set(state => {
        const prev = state.filters.spreadTitle;
        if (!fromYyyymm) {
          if (prev) delete state.filters.spreadTitle;
          return;
        }
        if (prev?.fromYyyymm === fromYyyymm && prev?.sheetName === sheetName) return;
        state.filters.spreadTitle = buildSpreadTitleFilters(fromYyyymm, sheetName);
      }),

    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),

    /**
     * admin 컬럼 메타 fetch(2시트) — mount 1회 + **매 Search** refetch(CLAUDE.md §2 체크3 / 03 §4.1).
     * `divisionId` 는 넘기지 않는다: 메타 50행의 `DIVISION_ID` 가 전건 NULL = division 별 컬럼 분기가
     * 없다(03 §1 공통, hook #92/#113 미해당).
     */
    fetchStaticColumns: async () => {
      let failed = false;
      await Promise.all(
        GRID_SHEETS.map(async sheet => {
          try {
            const response = await apiClient.post<RawFlexGridColumnConfig[]>(
              `/admin/menu/${MENU_ID}/column`,
              { sheetNm: ADMIN_SHEET_NAME[sheet] }
            );
            const next = hideInvisibleColumns(response.data.result ?? []);
            if (next.length === 0) return;
            set(state => {
              // 개인화는 **그 시트의 것만** 덧씌운다 — 시트를 섞으면 상대 시트 전용 컬럼이 사라진다.
              const layout = get().userColumnLayout[sheet];
              const applied =
                layout && layout.length > 0 ? applyLayoutToColumns(next, layout) : next;
              // 내용이 같으면 set 을 건너뛴다 — 참조가 바뀌면 그리드가 컬럼을 통째로 재생성한다.
              if (JSON.stringify(state.staticColumns[sheet]) !== JSON.stringify(applied)) {
                state.staticColumns[sheet] = applied;
              }
              state.originalStaticColumns[sheet] = next;
            });
          } catch {
            // 실패를 조용히 삼키지 않는다 — 빈 배열은 유지하되 플래그를 남겨 페이지가 원인을 알린다
            //   (console 금지 룰이라 로그 대신 상태로 표현).
            failed = true;
          }
        })
      );
      set(state => {
        state.initialized = true;
        if (state.columnMetaFailed !== failed) state.columnMetaFailed = failed;
      });
    },

    /**
     * Measure 메타 fetch(PIVOT 화면 의무, 2시트) — mount 1회 + 매 Search(CLAUDE.md §2 체크3 / hook #66).
     * 메타 실측 56행(ASSEMBLY 28 / ELTR 28)이라 코드 하드코딩 배열을 두지 않는다.
     * 주의: 렌더 자체는 GET SP 가 measure 행을 이미 조인해 내려주므로 이 메타에 의존하지 않는다
     * (03 §4.3 — ELTR 은 메타 28행인데 lookup 교집합으로 27행만 렌더되는 것이 AS-IS 파리티다, V-08).
     */
    fetchStaticMeasures: async () => {
      await Promise.all(
        GRID_SHEETS.map(async sheet => {
          try {
            const response = await apiClient.post<MeasureMeta[]>(
              `/admin/menu/${MENU_ID}/measure`,
              { sheetNm: ADMIN_SHEET_NAME[sheet] }
            );
            const next = response.data.result ?? [];
            set(state => {
              if (JSON.stringify(state.staticMeasures[sheet]) !== JSON.stringify(next)) {
                state.staticMeasures[sheet] = next;
              }
            });
          } catch {
            // 미등록/실패 = 빈 배열 유지. 컬럼 메타와 달리 렌더 의존이 없어 별도 안내를 띄우지 않는다.
          }
        })
      );
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
  }),
  'capa-teep-report-store'
);
