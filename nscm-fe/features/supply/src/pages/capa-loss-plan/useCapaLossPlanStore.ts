import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  DEFAULT_DIVISION_TYPE,
  DEFAULT_SHEET_TYPE,
  DIVISION_TYPE,
  MENU_ID,
  SHEETS,
  SHEET_TYPE,
  type DivisionType,
  type GridSheet,
  type SheetType,
} from './capa-loss-plan.constants';
import type { FiltersBySheet, SearchCondition } from './capa-loss-plan.types';

/**
 * `SCM_MST_SHEET_MEASURE` 동적 fetch 행. BE GridMeasure DTO 직렬화라 camelCase 다 —
 * `COLUMN_NAME`/`SORT_ORDER_NO` 는 응답에 없다(sales-future-price 실측 계약과 동일).
 * 주의: 이 메타는 **표시용**이다. 편집 가능 measure 는 GET 의 measure 결과셋(`*_TARGET_YN`)이
 * 단일 원천이며 이 메타로 대체하지 않는다(03 V-23, hook #130).
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

type StaticColumnsBySheet = Partial<Record<GridSheet, RawFlexGridColumnConfig[]>>;
type StaticMeasuresBySheet = Partial<Record<GridSheet, MeasureMeta[]>>;
type ColumnLayoutBySheet = Partial<Record<GridSheet, ColumnLayoutSetting[]>>;

interface State {
  initialized: boolean;
  /** F6 저장 조회조건 복원(restore)을 1회만 수행하기 위한 래치. reset()=initState 로 F10 후 재복원 허용. */
  conditionsRestored: boolean;
  searchCondition: SearchCondition;
  /** Search 로 실제 발사된 조회조건 — 그리드/저장이 참조하는 "확정" 값. */
  applied: SearchCondition | null;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  /** Version 3단에서 파생되는 읽기전용 표시값(txtPlanType). 라벨 없음. */
  planType: string;
  /** 그 버전의 현재 진행상태(`PROG_STAT`) — Edit 게이트 판정 기준값(01 L-12~L-15). */
  currVersionProgressStatus: string;
  /** admin `SCM_MST_SHEET_COLUMNS` — 시트별(8종) 별도 벌. 시트마다 컬럼 수가 다르다. */
  staticColumns: StaticColumnsBySheet;
  /** 개인화 적용 전 admin 원본 — 컬럼설정 모달의 Default 복원 기준. */
  originalStaticColumns: StaticColumnsBySheet;
  /** admin `SCM_MST_SHEET_MEASURE` — 시트별(20/25/6/6/20/20/6/6). */
  staticMeasures: StaticMeasuresBySheet;
  /**
   * 컬럼 개인화 — **시트별로 보관한다**. AS-IS 팝업 키가 `_sheet_name` 8값이라
   * 시트마다 설정이 따로다(03 §3.3, V-59). 한 벌로 합치면 시트를 바꿀 때 설정이 섞인다.
   */
  userColumnLayout: ColumnLayoutBySheet;
}

interface Action {
  reset: () => void;
  /** 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchCondition 패치(1회). */
  restoreSearchConditions: () => Promise<void>;
  setSearchCondition: (patch: Partial<SearchCondition>) => void;
  setDivision: (divisionId: string) => void;
  setDivisionType: (divisionType: DivisionType) => void;
  setProgressStatus: (progressStatus: string) => void;
  setDerivedVersionInfo: (planType: string, currVersionProgressStatus: string) => void;
  setFilters: (sheetName: GridSheet, payload: Record<string, string>, title?: Record<string, string>) => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: (sheetName: GridSheet, divisionId?: string) => Promise<void>;
  fetchStaticMeasures: (sheetName: GridSheet) => Promise<void>;
  applyColumnLayout: (sheetName: GridSheet, settings: ColumnLayoutSetting[]) => void;
  clearUserColumnLayout: () => void;
}

/**
 * 초기 조회조건 — 다중선택 6축은 `ALL` sentinel(= 무선택 = 전체)로 시작한다(02 §3.4).
 * DivisionType 은 AS-IS 캡처 실측값 `Cell`(decisions §B-1), SheetType 은 AS-IS 기본 `MODEL`,
 * `showRate` 는 캡처가 `☑` 라 `true`(decisions §B-3 — 토글 대상 `M_00` 이 0건이라 실효 무동작).
 * 나머지 단일 콤보는 옵션이 로드된 뒤 훅이 "목록 첫 행"을 채운다(AS-IS `cbo.DataSource` 바인딩 재현).
 */
const initSearch: SearchCondition = {
  divisionType: DEFAULT_DIVISION_TYPE,
  divisionId: '',
  version: '',
  versionSeq: '',
  progressStatus: '',
  sheetType: DEFAULT_SHEET_TYPE,
  siteId: 'ALL',
  plantId: 'ALL',
  factoryId: 'ALL',
  lineId: 'ALL',
  operationId: 'ALL',
  electrodeType: 'ALL',
  nickName: '',
  showRate: true,
};

/** 복원값이 시트/마스터 축을 가르는 enum 필드를 오염시키지 않도록 쓰는 화이트리스트. */
const VALID_DIVISION_TYPES = new Set<string>(Object.values(DIVISION_TYPE));
const VALID_SHEET_TYPES = new Set<string>(Object.values(SHEET_TYPE));

/** divisionType·sheetType(enum)·showRate(boolean)를 뺀 평문 string 조회조건 키. */
type StringSearchKey = Exclude<keyof SearchCondition, 'divisionType' | 'sheetType' | 'showRate'>;

const initState: State = {
  initialized: false,
  conditionsRestored: false,
  searchCondition: initSearch,
  applied: null,
  filters: {},
  openSearchArea: true,
  planType: '',
  currVersionProgressStatus: '',
  staticColumns: {},
  originalStaticColumns: {},
  staticMeasures: {},
  userColumnLayout: {},
};

/**
 * 개인화(표시/순서/폭/색)를 admin 메타 위에 덧씌운다 — 목록에 없는 컬럼은 비표시가 규약이다.
 * 관리자 비노출 컬럼은 저장된 개인화에 남아 있어도 절대 표시하지 않는다(03 V-05).
 */
const applyLayoutToColumns = (
  columns: RawFlexGridColumnConfig[],
  settings: ColumnLayoutSetting[]
): RawFlexGridColumnConfig[] => {
  const byColumn = new Map(settings.map(setting => [setting.colNm, setting]));
  return columns
    .map(column => {
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

export const useCapaLossPlanStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),

    /**
     * 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — basic-check #3, 자매 정본
     * `capa-speed-plan`/`capa-line-assign`.
     *
     * 저장측은 Page 가 `<SubTitle searchParam={sc}>` 로 이미 배선돼 있으나([[f6-save-needs-searchparam-prop]]),
     * 복원측이 없으면 저장은 되는데 **새로고침/재진입 시 조건이 사라진다**(신규 스캐폴드 재발 함정,
     * [[f6-restore-path-missing-on-new-scaffolds]]). GET `/admin/menu/{MENU_ID}/search-conditions`
     * → `paramNm/paramCtn` 을 `searchCondition` 에 patch 한다.
     *
     * 주의: 저장측(`GridAction.personalizeCondition`)은 **모든 값을 String 으로 coerce** 해서 보내므로
     * (`paramCtn` = 배열이면 `,` join / null 이면 `''` / 그 외 `String(value)`), 복원 시 타입 환원이
     * 필요하다 — `showRate` 는 `'true'/'false'` 문자열로 돌아오니 boolean 으로, `sheetType`/`divisionType`
     * 은 시트·마스터 축을 가르는 계산 키라 enum 화이트리스트로 가드한다(알 수 없는 값이면 무시).
     * 나머지 11필드는 다중선택 6축도 `,` 결합 문자열·`ALL` sentinel 이라 평문 patch 로 충분하다.
     * 날짜 조회조건이 0건이라 저장측 `EXCLUDED_DATE_PARAM` 제외 대상도 없다.
     *
     * `searchCondition` 만 patch 하고 `filters` 는 건드리지 않아 진입 자동조회 금지 게이트(F-26)를
     * 위반하지 않는다. 복원은 직접 `{...searchCondition,...patch}` 병합으로 setDivision/setDivisionType
     * cascade 를 경유하지 않는다(하위 6축을 ALL 로 날려 복원값이 지워진다). 콤보 기본선택 effect
     * (useCapaLossPlanCombos 233~259)는 `options.some` 가드라 복원값이 후보에 있으면 유지하고,
     * 복원이 비동기 후행이라 최종 승리한다.
     *
     * 미저장/실패/미등록(`SCM_ADM_MNU_M` 라우트 없음)이면 런타임 no-op(기본값 유지)다 — 배선 자체는
     * 파리티 요건이라 선적용한다.
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
            if (VALID_DIVISION_TYPES.has(val)) patch.divisionType = val as DivisionType;
            continue;
          }
          if (paramNm === 'sheetType') {
            if (VALID_SHEET_TYPES.has(val)) patch.sheetType = val as SheetType;
            continue;
          }
          if (paramNm === 'showRate') {
            patch.showRate = val === 'true'; // String(boolean) 역환원
            continue;
          }
          patch[paramNm as StringSearchKey] = val;
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
     * 되돌리고 그리드를 비운다. AS-IS `cboDivision_SelectedIndexChanged` 도 BeforeFindData(시트 비움)
     * 뒤 Version/Status/하위 6축을 전부 division 기준으로 재구성한다.
     *
     * 유지: DivisionType(rgrpDivisionType 전용 축이라 cboDivision 핸들러가 건드리지 않는다 — 시트
     * 전환축은 상위라 Division 변경으로 시트가 뒤집히면 안 된다) + divisionId(새 값). 기간/날짜 필드는
     * 이 화면에 없다 — Plan Month(version)/Version(versionSeq)/Status 는 AS-IS 가 division 기준으로
     * 재조회하는 축이라 보존 대상이 아니라 `''` 로 비워 combos effect 가 새 division 첫 옵션을 다시
     * 채운다. 편집중(dirty) 가드(MSG00704)는 Form onChange 의 confirmIfDirtyKey 가 처리한다
     * (commit 51d4e9fa 패턴) — 취소 시 controlled 콤보가 이전 Division 으로 복귀한다.
     */
    setDivision: divisionId =>
      set(state => {
        state.searchCondition = {
          ...initSearch,
          divisionType: get().searchCondition.divisionType,
          divisionId,
        };
        // 그리드 비움 — 재조회(Search) 전까지 빈 상태(setDivisionType·clearFilters 와 동일 규약).
        state.filters = {};
        state.applied = null;
      }),

    /**
     * DivisionType 변경 — AS-IS `rgrpDivisionType_SelectedIndexChanged`(cs:3435~3441) 는
     * `RefreshAllPre()`(마스터 전량 재수신) -> `RefreshAll()` -> `BeforeFindData()` 순이다.
     * TO-BE 는 (a) 마스터 comboId 가 바뀌어 react-query 가 자동 재조회하고 (b) 여기서 하위 6축을
     * ALL 로 리셋하며 (c) 그리드를 비운다(hook #5 §1.4 — Grid 비움 + CRUD reset).
     * **재구성 범위가 6축 전부**인 축이다 — Status/SheetType 과 다르다(02 §0 #9, F-20).
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
        state.filters = {};
        state.applied = null;
      }),

    /**
     * Status 변경 — **재구성 범위가 Operation·Line Type 뿐이다**(02 §0 #9, §3.2, F-20).
     * Site/Plant/Building/Line 선택은 **보존**된다. 편의상 `RefreshAll` 로 통일하면 실패한다.
     *
     * AS-IS `cboProgressStatus_SelectedIndexChanged`(cs:3477~3482)는 `RefreshSheetType()` 뒤
     * `cboSheetType_SelectedIndexChanged(null,null)` 를 **직접 호출**한다 — Status 1회 변경이
     * SheetType 가시성 + Operation/LineType 재구성 + ShowRate 가시성 + 그리드 재초기화를 **함께**
     * 일으킨다. `useEffect` 2개로 쪼개면 순서가 어긋나므로 이 액션 하나로 묶는다(02 §5.4).
     */
    setProgressStatus: progressStatus =>
      set(state => {
        state.searchCondition = {
          ...get().searchCondition,
          progressStatus,
          operationId: 'ALL',
          electrodeType: 'ALL',
        };
        // `BeforeFindData` 5트리거 중 SheetType 경유분 — 그리드를 비운다(자동 재조회 없음).
        state.filters = {};
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
     */
    setFilters: (sheetName, payload, title) =>
      set(state => {
        state.applied = { ...state.searchCondition };
        state.filters = {
          [sheetName]: payload,
          ...(title ? { [SHEETS.SPREAD_TITLE]: title } : {}),
        };
      }),

    /** 진입/조회조건 변경 — 그리드를 비운다(자동 재조회 없음, nscm-patterns §5-5/§5-7). */
    clearFilters: () =>
      set(state => {
        state.filters = {};
        state.applied = null;
      }),

    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),

    /**
     * admin 컬럼 메타 fetch — mount 1회 + **매 Search** + **시트 전환 시**(CLAUDE.md §2 체크3).
     *
     * SCP0105 는 2시트라 전 시트를 한 번에 받았지만 이 화면은 **8시트**다. 한 번에 8콜을 던지면
     * 조회마다 8회 왕복인데 화면에 뜨는 시트는 언제나 1개뿐이라, **현재 시트만** 받는다.
     * 시트가 바뀌면 호출부(`CapaLossPlan.tsx`)가 새 시트로 다시 부른다.
     *
     * `divisionId` 인자: division 변경 시 set() 커밋 뒤 새 값을 넘겨 호출한다. producer 안에서
     * `get()` 으로 읽으면 커밋 전 이전 division 이라 컬럼셋이 한 스텝 밀린다(nscm-patterns §5-5).
     */
    fetchStaticColumns: async (sheetName, divisionId) => {
      const division = divisionId ?? get().searchCondition.divisionId;
      try {
        const response = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME[sheetName], divisionId: division }
        );
        const next = response.data.result ?? [];
        if (next.length === 0) return;
        set(state => {
          const layout = get().userColumnLayout[sheetName];
          const applied = layout && layout.length > 0 ? applyLayoutToColumns(next, layout) : next;
          // 내용이 같으면 set 을 건너뛴다 — 참조가 바뀌면 그리드가 컬럼을 통째로 재생성한다.
          if (JSON.stringify(state.staticColumns[sheetName]) !== JSON.stringify(applied)) {
            state.staticColumns[sheetName] = applied;
          }
          state.originalStaticColumns[sheetName] = next;
        });
      } catch {
        // 미등록/실패 = 빈 배열 유지(console 금지 룰). 컬럼 0건이면 04 리포트의 메타 게이트가 잡는다.
      } finally {
        set(state => {
          state.initialized = true;
        });
      }
    },

    /** Measure 메타 fetch(PIVOT 화면 의무) — 현재 시트분만. 코드 하드코딩 배열 금지. */
    fetchStaticMeasures: async sheetName => {
      try {
        const response = await apiClient.post<MeasureMeta[]>(
          `/admin/menu/${MENU_ID}/measure`,
          { sheetNm: ADMIN_SHEET_NAME[sheetName] }
        );
        const next = response.data.result ?? [];
        set(state => {
          if (JSON.stringify(state.staticMeasures[sheetName]) !== JSON.stringify(next)) {
            state.staticMeasures[sheetName] = next;
          }
        });
      } catch {
        // 미등록/실패 = 빈 배열 유지(console 금지 룰).
      }
    },

    /** 컬럼설정 모달 OK — 표시/순서/폭/색을 즉시 반영하고 이후 refetch 에도 재적용한다. */
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

    clearUserColumnLayout: () =>
      set(state => {
        state.userColumnLayout = {};
      }),
  }),
  'capa-loss-plan-store'
);
