import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  DEFAULT_DIVISION_TYPE,
  DIVISION_TYPE,
  MENU_ID,
  SHEETS,
  SHEET_BY_DIVISION_TYPE,
  type DivisionType,
  type GridSheet,
} from './capa-speed-plan.constants';
import type { FiltersBySheet, SearchCondition } from './capa-speed-plan.types';
import { buildSpreadTitleFilters, toFromYyyymm } from './utils/capaSpeedPlan.dateColumns';

/**
 * `SCM_MST_SHEET_MEASURE` 동적 fetch 행. BE GridMeasure DTO 직렬화라 camelCase 다 —
 * `COLUMN_NAME`/`SORT_ORDER_NO` 는 응답에 없다(sales-future-price 실측 주석과 동일 계약).
 */
export interface MeasureMeta {
  colNm: string;
  colLblNm?: string;
  display?: boolean;
  personalizable?: boolean;
  attribute1?: string;
  attribute2?: string;
  attribute3?: string;
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

interface State {
  initialized: boolean;
  /** F6 저장 조회조건 복원(restore)을 1회만 수행하기 위한 래치. reset()=initState 로 F10 후 재복원 허용. */
  conditionsRestored: boolean;
  searchCondition: SearchCondition;
  /** Search 로 실제 발사된 조회조건 — 그리드/저장이 참조하는 "확정" 값. */
  applied: SearchCondition | null;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  /** Version 3단에서 파생되는 읽기전용 표시값(txtPlanType). */
  planType: string;
  /** 그 버전의 현재 진행상태 — Edit 차단 게이트 기준값(01 L-11). */
  currVersionProgressStatus: string;
  /** admin SCM_MST_SHEET_COLUMNS — 시트별 2벌(ASSEMBLY 32 / ELTR 31). */
  staticColumns: StaticColumnsBySheet;
  /** 개인화 적용 전 admin 원본 — 컬럼설정 모달의 Default 복원 기준. */
  originalStaticColumns: StaticColumnsBySheet;
  /** admin SCM_MST_SHEET_MEASURE — ASSEMBLY 6 / ELTR 1. */
  staticMeasures: StaticMeasuresBySheet;
  userColumnLayout: ColumnLayoutSetting[] | null;
}

interface Action {
  reset: () => void;
  /** 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchCondition 패치(1회). */
  restoreSearchConditions: () => Promise<void>;
  setSearchCondition: (patch: Partial<SearchCondition>) => void;
  setDivision: (divisionId: string) => void;
  setDivisionType: (divisionType: DivisionType) => void;
  setDerivedVersionInfo: (planType: string, currVersionProgressStatus: string) => void;
  setFilters: (payload: Record<string, string>) => void;
  clearFilters: () => void;
  refreshSpreadTitle: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: (divisionId?: string) => Promise<void>;
  fetchStaticMeasures: () => Promise<void>;
  applyColumnLayout: (sheetName: GridSheet, settings: ColumnLayoutSetting[]) => void;
  clearUserColumnLayout: () => void;
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

/**
 * 초기 조회조건 — 다중선택 6축은 `ALL` sentinel(= 무선택 = 전체)로 시작한다(02 §4.2).
 * DivisionType 만 사용자 확정값(Cell)으로 고정하고, 나머지 단일 콤보는 옵션이 로드된 뒤
 * Form 이 "목록 첫 행"을 채운다(AS-IS `cbo.DataSource=dt` 바인딩의 기본 선택 재현).
 */
const initSearch: SearchCondition = {
  divisionType: DEFAULT_DIVISION_TYPE,
  divisionId: '',
  version: '',
  versionSeq: '',
  progressStatus: '',
  siteId: 'ALL',
  plantId: 'ALL',
  factoryId: 'ALL',
  lineId: 'ALL',
  operationId: 'ALL',
  electrodeType: 'ALL',
  itemId: '',
};

/**
 * 복원 시 divisionType(시트/마스터 소스를 가르는 축) 오염 방지용 화이트리스트.
 * gridAction 저장은 문자열 그대로(`String('CELL')='CELL'`) 보존하지만, 저장분이 손상됐을 때
 * 알 수 없는 값이 시트 스위치/셀 콤보를 깨지 않도록 enum 값만 받아들인다.
 */
const VALID_DIVISION_TYPES = new Set<string>(Object.values(DIVISION_TYPE));

const initState: State = {
  initialized: false,
  conditionsRestored: false,
  searchCondition: initSearch,
  applied: null,
  filters: {},
  openSearchArea: true,
  planType: '',
  currVersionProgressStatus: '',
  staticColumns: emptyColumns(),
  originalStaticColumns: emptyColumns(),
  staticMeasures: emptyMeasures(),
  userColumnLayout: null,
};

/** 개인화(표시/순서/폭/색)를 admin 메타 위에 덧씌운다 — 목록에 없는 컬럼은 비표시가 규약이다. */
const applyLayoutToColumns = (
  columns: RawFlexGridColumnConfig[],
  settings: ColumnLayoutSetting[]
): RawFlexGridColumnConfig[] => {
  const byColumn = new Map(settings.map(setting => [setting.colNm, setting]));
  return columns
    .map(column => {
      // 관리자 비노출 컬럼은 저장된 개인화에 남아 있어도 절대 표시하지 않는다.
      if (column.visible === false) return { ...column, visible: false };
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

export const useCapaSpeedPlanStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),

    /**
     * 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 정본 `scp-bom`/자매 `capa-line-assign`.
     *
     * 저장측은 page 가 `<SubTitle searchParam={sc}>` 로 이미 배선돼 있으나([[f6-save-needs-searchparam-prop]]),
     * 복원측이 없으면 저장은 되는데 **새로고침/재진입 시 조건이 사라진다**(basic-check #3 재발 함정,
     * [[f6-restore-path-missing-on-new-scaffolds]]). GET `/admin/menu/{MENU_ID}/search-conditions` →
     * `paramNm/paramCtn` 를 `searchCondition` 에 patch 한다. 이 화면은 13필드가 전부 문자열이라
     * (다중선택 6축도 `,` 결합 문자열·`ALL` sentinel, SCP0104 처럼 배열/숫자 아님) 역직렬화가 불요하고
     * 평문 patch 로 충분하다. 날짜 조회조건이 0건이라 `EXCLUDED_DATE_PARAM` 제외 대상도 없다.
     * `divisionType` 만 시트/마스터 소스를 가르는 축이라 enum 화이트리스트로 가드한다.
     *
     * `searchCondition` 만 patch 하고 `filters` 는 건드리지 않아 진입 자동조회 금지 게이트(§5-7)를
     * 위반하지 않는다. 복원은 직접 `{...searchCondition,...patch}` 병합으로, setDivision/setDivisionType
     * cascade 를 경유하지 않는다(하위 6축을 ALL 로 날리므로 복원값이 지워진다). 콤보 기본선택 effect
     * (useCapaSpeedPlanCombos cs:224~250)는 `options.some` 가드라 복원값이 후보에 있으면 유지하고,
     * 복원이 비동기 후행이라 최종 승리한다.
     *
     * 주의: `PKG_SCP0105`·`SCM_ADM_MNU_M` SCP0105 가 미배포/미등록이면 이 복원 GET 은 런타임 no-op
     *   (기본값 유지)다 — 배선 자체는 파리티 요건이라 배포·등록과 무관하게 선적용한다(goal.md ②).
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
        const patch: Partial<SearchCondition> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in initSearch)) continue; // SearchCondition 필드만 allowlist
          const val = paramCtn ?? '';
          if (paramNm === 'divisionType') {
            // 알 수 없는 값이면 무시한다 — 시트/마스터 축 오염 방지.
            if (VALID_DIVISION_TYPES.has(val)) patch.divisionType = val as DivisionType;
            continue;
          }
          // divisionType 외 12필드는 전부 string 이다(다중선택도 `,` 결합 문자열).
          patch[paramNm as Exclude<keyof SearchCondition, 'divisionType'>] = val;
        }
        set(state => {
          state.searchCondition = { ...state.searchCondition, ...patch };
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지 룰).
      }
    },

    setSearchCondition: patch =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...patch };
      }),

    /**
     * Division 변경(cboDivision, 단일 콤보) = TO-BE 공통 요건(hook cascade-combo-filter §1.4 —
     * 사용자 지시 2026-10-02): Division(새 값)·DivisionType(부모 축)을 제외한 전 검색조건을 초기값으로
     * 되돌리고 그리드를 비운다. AS-IS `cboDivision_SelectedIndexChanged`(cs:2423~2432)도
     * `BeforeFindData()`(시트 비움) -> RefreshVersion -> RefreshVersionSeq -> RefreshPlanType ->
     * RefreshProgressStatus -> `RefreshAll()` 로 Version/Status/하위 6축을 전부 division 기준으로
     * 재구성한다(design 02 §3.1 #1, cascade 그래프 cs:253).
     *
     * 유지: DivisionType(rgrpDivisionType 전용 축이라 cboDivision 핸들러가 건드리지 않는다 — 시트
     * 전환축은 상위라 Division 변경으로 ASSEMBLY<->ELTR 가 뒤집히면 안 된다) + divisionId(새 값).
     * 기간/날짜 필드는 이 화면에 없다 — Plan Month(version)는 AS-IS 가 RefreshVersion 으로 재조회하는
     * 축이라 보존 대상이 아니다. version/versionSeq/progressStatus 는 `''` 로 비워 combos effect 가
     * 새 division 첫 옵션을 다시 채우고(useCapaSpeedPlanCombos cs:224~250), planType/진행상태는 그
     * 파생값이라 함께 갱신된다. 편집중(dirty) 가드(MSG00704)는 Form onChange 의 confirmIfDirtyKey 가
     * 처리한다(commit 51d4e9fa 패턴) — 취소 시 controlled 콤보가 이전 Division 으로 복귀한다.
     */
    setDivision: divisionId =>
      set(state => {
        const spreadTitle = state.filters[SHEETS.SPREAD_TITLE];
        state.searchCondition = {
          ...initSearch,
          divisionType: get().searchCondition.divisionType,
          divisionId,
        };
        // 그리드 비움 — 기간 헤더(spreadTitle)는 남긴다(setDivisionType·clearFilters 와 동일 규약:
        //   AS-IS BeforeFindData 가 시트를 비운 뒤 곧바로 같은 헤더를 다시 만든다, cs:2041~2048).
        state.filters = spreadTitle ? { [SHEETS.SPREAD_TITLE]: spreadTitle } : {};
        state.applied = null;
      }),

    /**
     * DivisionType 변경 — AS-IS `rgrpDivisionType_SelectedIndexChanged`(cs:2453~2460) 는
     * `BeforeFindData()`(시트 재초기화 + 헤더 재구성) -> `RefreshAllPre()`(마스터 전량 재수신) ->
     * `RefreshAll()` 순이다. TO-BE 는 (a) 마스터 comboId 가 바뀌어 react-query 가 자동 재조회하고
     * (b) 여기서 하위 6축을 ALL 로 리셋하며 (c) 그리드를 비운다(hook #5 §1.4 — Grid 비움 + CRUD reset).
     * Version/Status 계열은 AS-IS 도 재조회하지 않으므로 그대로 둔다.
     */
    setDivisionType: divisionType =>
      set(state => {
        state.searchCondition = {
          ...get().searchCondition,
          divisionType,
          siteId: 'ALL',
          plantId: 'ALL',
          factoryId: 'ALL',
          lineId: 'ALL',
          operationId: 'ALL',
          electrodeType: 'ALL',
        };
        // 기간 헤더는 남긴다 — AS-IS 도 시트를 비운 뒤 곧바로 같은 헤더를 다시 만든다
        //   (`BeforeFindData` cs:2041~2048). `p_from_yyyymm` 은 DivisionType 과 무관하다.
        const spreadTitle = state.filters[SHEETS.SPREAD_TITLE];
        state.filters = spreadTitle ? { [SHEETS.SPREAD_TITLE]: spreadTitle } : {};
        state.applied = null;
      }),

    setDerivedVersionInfo: (planType, currVersionProgressStatus) =>
      set(state => {
        if (state.planType !== planType) state.planType = planType;
        if (state.currVersionProgressStatus !== currVersionProgressStatus) {
          state.currVersionProgressStatus = currVersionProgressStatus;
        }
      }),

    /**
     * Search(F5) — 확정 조회조건을 굳히고 GET/TITLE payload 참조를 갈아끼운다.
     * `refetch()` 를 직접 부르지 않는다. filters 참조 교체가 곧 재조회다(nscm-patterns §5-1).
     *
     * payload 키는 AS-IS SP IN 파라미터 이름 그대로다(`SetQueryInfoGet` cs:2233~2257).
     * `PKG_SCP0105` 가 미배포라 `SCM_ADM_PROC_M` 에 COL_NM 이 없다 — 배포 후 `all_arguments`
     * 실측으로 convert-sp 가 확정한다(goal.md BLK-2). 자매 SCP0114 도 같은 규약을 쓴다.
     */
    setFilters: payload =>
      set(state => {
        const condition = state.searchCondition;
        const sheetName = SHEET_BY_DIVISION_TYPE[condition.divisionType];
        const fromYyyymm = toFromYyyymm(condition.version);
        state.applied = { ...condition };
        state.filters = {
          [sheetName]: payload,
          // Version 이 없으면 기간 헤더를 조회하지 않는다(03 §4.1 #3).
          ...(fromYyyymm
            ? { [SHEETS.SPREAD_TITLE]: buildSpreadTitleFilters(fromYyyymm, MENU_ID) }
            : {}),
        };
      }),

    /**
     * 진입/조회조건 변경 — **그리드만** 비운다(자동 재조회 없음, nscm-patterns §5-5/§5-7).
     * 기간 헤더(`spreadTitle`)는 여기서 지우지 않는다 — AS-IS `BeforeFindData`(cs:2041~2048)도
     * `InitSpread()`(시트 비움) 뒤에 `RefreshSheetHeader(true)` 로 헤더를 **즉시 다시 만든다**.
     * 갱신은 `refreshSpreadTitle()` 이 담당한다(03 V-11/V-15).
     */
    clearFilters: () =>
      set(state => {
        const spreadTitle = state.filters[SHEETS.SPREAD_TITLE];
        state.filters = spreadTitle ? { [SHEETS.SPREAD_TITLE]: spreadTitle } : {};
        state.applied = null;
      }),

    /**
     * 기간 헤더 재조회 — AS-IS `RefreshSheetHeader(true)` -> `GetSpdTitle()`(cs:1312~1335).
     * 호출 지점이 조회(F5)가 아니다: `CreateSpread()`(Form_Load, cs:1300~1310)와 5개 콤보의
     * `SelectedIndexChanged` -> `BeforeFindData()`(cs:2041~2048), 컬럼설정 팝업 OK(cs:3173)다.
     * 즉 **헤더는 조회 전에도 최신**이고, 조회 버튼에 묶인 것은 그리드 데이터뿐이다(F-19).
     * 내용이 같으면 그대로 둔다 — 참조가 바뀌면 컬럼이 통째로 재생성된다.
     */
    refreshSpreadTitle: () =>
      set(state => {
        const fromYyyymm = toFromYyyymm(state.searchCondition.version);
        const next = fromYyyymm ? buildSpreadTitleFilters(fromYyyymm, MENU_ID) : undefined;
        const prev = state.filters[SHEETS.SPREAD_TITLE];
        if (JSON.stringify(prev ?? null) === JSON.stringify(next ?? null)) return;
        if (next) state.filters[SHEETS.SPREAD_TITLE] = next;
        else delete state.filters[SHEETS.SPREAD_TITLE];
      }),

    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),

    /**
     * admin 컬럼 메타 fetch(2시트) — mount 1회 + **매 Search 마다** refetch(CLAUDE.md §2 체크3).
     * `divisionId` 인자: division 변경 시 set() 커밋 뒤 새 값을 넘겨 호출한다. producer 안에서
     * `get()` 으로 읽으면 커밋 전 이전 division 이라 컬럼셋이 한 스텝 밀린다(nscm-patterns §5-5).
     */
    fetchStaticColumns: async divisionId => {
      const division = divisionId ?? get().searchCondition.divisionId;
      await Promise.all(
        GRID_SHEETS.map(async sheet => {
          try {
            const response = await apiClient.post<RawFlexGridColumnConfig[]>(
              `/admin/menu/${MENU_ID}/column`,
              { sheetNm: ADMIN_SHEET_NAME[sheet], divisionId: division }
            );
            const next = response.data.result ?? [];
            if (next.length === 0) return;
            set(state => {
              const layout = get().userColumnLayout;
              const applied =
                layout && layout.length > 0 ? applyLayoutToColumns(next, layout) : next;
              // 내용이 같으면 set 을 건너뛴다 — 참조가 바뀌면 그리드가 컬럼을 통째로 재생성한다.
              if (JSON.stringify(state.staticColumns[sheet]) !== JSON.stringify(applied)) {
                state.staticColumns[sheet] = applied;
              }
              state.originalStaticColumns[sheet] = next;
            });
          } catch {
            // 미등록/실패 = 빈 배열 유지(console 금지 룰). 컬럼 0건이면 04 리포트의 메타 게이트가 잡는다.
          }
        })
      );
      set(state => {
        state.initialized = true;
      });
    },

    /** Measure 메타 fetch(PIVOT 화면 의무) — ASSEMBLY 6행 / ELTR 1행. 코드 하드코딩 배열 금지. */
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
            // 미등록/실패 = 빈 배열 유지(console 금지 룰).
          }
        })
      );
    },

    /** 컬럼설정 모달 OK — 표시/순서/폭/색을 즉시 반영하고 이후 refetch 에도 재적용한다. */
    applyColumnLayout: (sheetName, settings) =>
      set(state => {
        const layout = settings
          .filter(setting => setting.visible)
          .sort((a, b) => a.order - b.order)
          .map((setting, index) => ({ ...setting, order: index + 1 }));
        state.userColumnLayout = layout;
        const current = state.staticColumns[sheetName];
        if (!current || current.length === 0) return;
        state.staticColumns[sheetName] = applyLayoutToColumns(current, layout);
      }),

    clearUserColumnLayout: () =>
      set(state => {
        state.userColumnLayout = null;
      }),
  }),
  'capa-speed-plan-store'
);
