import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  ALL,
  DEFAULT_SHEET,
  GRID_SHEETS,
  MENU_ID,
  PERIOD_MONTHS_AHEAD,
  SHEETS,
  type GridSheet,
} from './opt-capa.constants';
import type { OptCapaAppliedCondition, OptCapaSearchParams } from './opt-capa.types';

type FiltersBySheet = Partial<Record<GridSheet, ProcRequest<MENU_ID, SHEETS.NO_WORK>>>;
type StaticColumnsBySheet = Record<GridSheet, RawFlexGridColumnConfig[]>;

interface State {
  searchParams: OptCapaSearchParams;
  // SubTitle F6 저장분 mount 복원 1회 가드 (저장은 searchParam prop, 복원은 별도 배선 — basic-check #3).
  conditionsRestored: boolean;
  applied: OptCapaAppliedCondition | null;
  /**
   * 시트별 조회 payload — 8탭이 **서로 독립된 마스터 테이블**이라 탭마다 따로 둔다.
   * `handleSearch` 가 활성 시트 키만 채우고 비활성 시트는 `enabled:false` 로 발사되지 않는다
   * (AS-IS `FindData_Main` 의 `queryId` 8분기도 활성 시트 1건만 조회한다 — design 01 §2.3).
   */
  filters: FiltersBySheet;
  /** 활성 탭 — 탭 전환 가드(R09·R10)가 이 값을 바꾸는 유일 경로다. */
  activeSheet: GridSheet;
  openSearchArea: boolean;
  /** admin `SCM_MST_SHEET_COLUMNS` 동적 fetch(8시트) — 미등록/실패 시 빈 배열 유지(hook #113 §1-3). */
  staticColumns: StaticColumnsBySheet;
}

interface Action {
  reset: () => void;
  setSearchParams: (patch: Partial<OptCapaSearchParams>) => void;
  setDivision: (divisionId: string) => void;
  setFilters: (sheet: GridSheet, plantCodes: string[], lineCodes: string[]) => void;
  clearFilters: () => void;
  setActiveSheet: (sheet: GridSheet) => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: (divisionId?: string) => Promise<void>;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchParams 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

// 개인화 조건 복원 역직렬화 키(SubTitle F6 저장은 배열=콤마join·불리언=String 평문화 — personalizeCondition).
//   plantIds/lineIds = 멀티셀렉트(콤마 결합 → split). Period(from/to Yyyymm)는 저장측 EXCLUDED_DATE_PARAM
//   (키가 `...yyyymm` 로 끝남)에 걸려 애초에 저장되지 않으므로 복원 응답에 없다(기본 시드값 유지).
const RESTORE_ARRAY_KEYS = new Set<string>(['plantIds', 'lineIds']);

/** 당월 `YYYYMM`(dayjs 로컬 — `toISOString()` UTC 금지, nscm-patterns §5-12). */
const currentYearMonth = (): string => dayjs().format('YYYYMM');
/** 당월 +N개월. AS-IS `mrpPeriod.MonthText2 = DateTime.Now.AddMonths(12)`(cs:227). */
const monthsAhead = (months: number): string => dayjs().add(months, 'month').format('YYYYMM');

const initSearchParams = (): OptCapaSearchParams => ({
  // Division 기본값은 **권한 목록의 첫 행**이다(세션 division 아님 — design 02 §4.2).
  //   목록이 도착한 뒤 Form 이 채운다.
  divisionId: '',
  // Plan Group 기본값 `ALL` — AS-IS `setListBox(..., true, ...)` 가 ALL 행을 index 0 에 넣는다.
  //   조회 payload 에서만 `''` 로 바뀐다(cs:1156) — 화면 표시는 ALL 이 선택된 상태다.
  planGrId: ALL,
  fromYyyymm: currentYearMonth(),
  toYyyymm: monthsAhead(PERIOD_MONTHS_AHEAD),
  // Plant/Line 은 `UsrCheckedList2` 자체가 ALL 보유 + 기본 ALL(cs:383·463). 빈 배열 = ALL 이다.
  plantIds: [],
  lineIds: [],
  nickName: '',
  itemId: '',
});

const emptyStaticColumns = (): StaticColumnsBySheet =>
  GRID_SHEETS.reduce((acc, sheet) => {
    acc[sheet] = [];
    return acc;
  }, {} as StaticColumnsBySheet);

const initState = (): State => ({
  searchParams: initSearchParams(),
  conditionsRestored: false,
  applied: null,
  filters: {},
  activeSheet: DEFAULT_SHEET,
  openSearchArea: true,
  staticColumns: emptyStaticColumns(),
});

export const useOptCapaStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState(),
    reset: () => set(initState()),

    setSearchParams: patch =>
      set(state => {
        state.searchParams = { ...get().searchParams, ...patch };
      }),

    /**
     * Division 변경(싱글 콤보) = TO-BE 공통 요건: Division·기간(from/to)을 제외한 검색조건을 전부
     * 초기화하고 그리드도 초기화(filters clear + applied null)한다(사용자 지시 2026-10-02 —
     * TO-BE 공통 요건이 AS-IS 핸들러보다 우선, 정본 SCP0025 `setDivision`).
     *   · 유지: Division(새 값) + Period(from/to). Period 는 mount 시 당월~+N개월 시드값이라 보존한다.
     *   · 초기화: Plan Group(ALL)·Plant/Line(빈 배열=ALL)·Nick Name·Model(ITEM_ID) → `initSearchParams`.
     * 종전 onChange 는 planGrId/plant/line 만 비우고 nickName·itemId 는 남겨 이전 Division 의 입력이
     *   그대로 유지되던 것을 TO-BE 공통 요건으로 정렬한다(design 02 §3.1·§3.3 의 "이전 선택 소거"를
     *   전 조건으로 확장). 편집중(dirty) 확인 가드(MSG00704)는 Form 의 onChange 가 공용
     *   `confirmIfDirtyKey` 로 처리한다(commit 51d4e9fa 패턴) — 이 화면은 8시트 DataGrid 가 자동
     *   등록한 `tabDirtyKey(tabId)` 를 집계하므로 미저장 편집이 실제로 가드된다.
     * filters/applied 비움은 OptCapa 의 divisionId 변경 effect(clearAllTrackers + clearFilters +
     *   removeQueries)와 겹치지만 멱등이라 무해하다 — 정본 패턴대로 store 가 그리드를 직접 비운다.
     */
    setDivision: divisionId =>
      set(state => {
        const cur = get().searchParams;
        state.searchParams = {
          ...initSearchParams(), // Division·Period 제외 전 조건 초기화(planGr/plant/line/nick/item)
          divisionId,
          fromYyyymm: cur.fromYyyymm,
          toYyyymm: cur.toYyyymm,
        };
        state.filters = {}; // 그리드 초기화 — 재조회(Search) 전까지 빈 상태
        state.applied = null;
      }),

    /**
     * 조회 payload 8키 — `SCM_ADM_PROC_M.COL_NM` 실측 **camelCase**(design 02 §8.1 V2-06).
     * snake `p_division_id` 로 보내면 NULL 바인딩된다(메모리 `scp-proc-m-colnm-is-camelcase`).
     *
     * 변환 규칙(AS-IS `FindData_Main` cs:1155-1180):
     *   · Plan Group `'ALL'` → `''`
     *   · Plant/Line `'ALL'` → `''` — 호출부가 `resolveFilterCodes` 로 **빈 배열**을 넘겨 여기서
     *     `join(',')` 이 `''` 가 된다. 콤보 후처리 경로의 "후보 전 CODE 전개"(`resolvePlantCodes`)와
     *     용도가 정반대다 — 전개값을 실으면 그리드 행 집합이 콤보 후보로 제한된다(iter-3 감사 G3-2)
     *   · Period `YYYY-MM` → `YYYYMM` (store 가 이미 `YYYYMM` 로 보유)
     *   · **No Work 시트는 `nickName`·`itemId` 를 강제 공백**(cs:1104-1107). 두 필드는 화면에
     *     계속 보이고 입력도 되지만 값만 안 간다 — 숨기는 코드는 AS-IS 에서 주석처리됐다(§4.4).
     */
    setFilters: (sheet, plantCodes, lineCodes) =>
      set(state => {
        const params = state.searchParams;
        const isNoWork = sheet === SHEETS.NO_WORK;
        state.applied = { divisionId: params.divisionId, plantIds: plantCodes };
        state.filters = {
          ...state.filters,
          [sheet]: {
            divisionId: params.divisionId,
            planGrId: params.planGrId === ALL ? '' : params.planGrId,
            fromYyyymm: params.fromYyyymm,
            toYyyymm: params.toYyyymm,
            plantId: plantCodes.join(','),
            lineId: lineCodes.join(','),
            nickName: isNoWork ? '' : params.nickName,
            itemId: isNoWork ? '' : params.itemId,
          },
        };
      }),

    /**
     * 그리드 비움 — Division / Plan Group / Plant 변경 시 **전 시트**를 비운다.
     *
     * AS-IS `SpreadInfo.ClearDataSource` 는 ActiveSheet 하나만 비우므로(SpreadInfo.cs:6240-6264)
     * 나머지 7시트에 이전 Division 데이터가 남는다. 문자 그대로 옮기면 "Division 바꾸고 탭
     * 넘기면 옛 데이터" 상태가 되어, 자매 SCP0114 가 같은 상황에서 전 그리드 초기화로
     * **사용자 확정(2026-09-23)** 을 받은 선례를 따른다(design 01 §2.4 / 02 §8.2 V-4 권고).
     * 이 결정은 04 리포트에 "확인 필요(사용자 축)" 로 남겼다.
     *
     * 주의: **Line 변경은 비우지 않는다** — AS-IS `clbLine.SelectedIndexChanged` 가 미배선이다
     * (cs:702-721 / design 02 §3.3 V2-16). 일관성 명분으로 비우면 AS-IS 와 달라진다.
     */
    clearFilters: () =>
      set(state => {
        state.filters = {};
        state.applied = null;
      }),

    setActiveSheet: sheet =>
      set(state => {
        state.activeSheet = sheet;
      }),

    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),

    /**
     * 컬럼 메타 fetch — mount + **매 Search** + Division 변경 시 재조회(hook #65 / #113).
     *
     * 호출부가 mount 축에 `initialized` 같은 1회 가드를 걸지 않는다 — 이 store 는
     * `createPersistedStoreWithTab` 이라 `staticColumns` 가 IndexedDB 에서 함께 복원되므로,
     * 가드가 있으면 **2회차 진입부터 mount 재조회가 죽어** admin 메타 변경이 재진입만으로는
     * 반영되지 않는다(iter-3 감사 G3-17 / hook #65 "mount + 매 Search").
     *
     * `sheetNm` 은 **A축 표시명**(`ADMIN_SHEET_NAME`)이다 — B축 `SHT_NM`(camelCase)로 보내면
     * 131행 메타가 0건으로 나와 그리드가 빈 채로 뜬다(design 03 §0.1).
     * `divisionId` 인자: Division 변경 시 `set()` 커밋 **뒤** 새 값을 넘긴다 — producer 안에서
     * `get()` 하면 커밋 전 값을 읽어 컬럼셋이 한 스텝 밀린다(nscm-patterns §5-5).
     */
    fetchStaticColumns: async divisionId => {
      const division = divisionId ?? get().searchParams.divisionId;
      await Promise.all(
        GRID_SHEETS.map(async sheet => {
          try {
            const res = await apiClient.post<RawFlexGridColumnConfig[]>(
              `/admin/menu/${MENU_ID}/column`,
              { sheetNm: ADMIN_SHEET_NAME[sheet], divisionId: division }
            );
            const next = res.data.result ?? [];
            // 0건이면 빈 배열을 유지한다 — 상수 fallback 금지(hook #113 §1-3).
            if (next.length === 0) return;
            set(state => {
              if (JSON.stringify(state.staticColumns[sheet]) !== JSON.stringify(next)) {
                state.staticColumns[sheet] = next;
              }
            });
          } catch {
            // 미등록/실패 — 빈 배열 유지(console 금지 룰).
          }
        })
      );
    },

    /**
     * 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 형제 scp-bom/plan-control 파리티.
     *   GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 역직렬화(배열 split).
     *   저장분 없거나 조회 실패면 기본값 유지. 저장은 EXCLUDED_DATE_PARAM·빈값 필터 후 재삽입이라
     *   (gridAction.ts personalizeCondition) 응답에 없는 키는 initSearchParams 기본값 그대로 둔다
     *   (Period from/to 는 저장 제외라 당월~+N개월 시드값이 유지된다).
     *   setDivision/setSearchParams 를 쓰지 않는다 — divisionId 변경 cascade 가 planGrId/plantIds/lineIds 를
     *   지워 복원값이 자기파괴된다. 직접 `{...searchParams, ...patch}` 병합한다.
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
        const init = initSearchParams();
        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in init)) continue; // searchParams 필드만 allowlist
          const val = paramCtn ?? '';
          if (RESTORE_ARRAY_KEYS.has(paramNm))
            patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          else patch[paramNm] = val;
        }
        set(state => {
          state.searchParams = { ...state.searchParams, ...patch } as OptCapaSearchParams;
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지 룰)
      }
    },
  }),
  'opt-capa-store'
);
