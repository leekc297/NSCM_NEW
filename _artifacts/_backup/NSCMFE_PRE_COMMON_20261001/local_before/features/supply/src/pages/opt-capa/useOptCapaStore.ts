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
  applied: OptCapaAppliedCondition | null;
  /**
   * 시트별 조회 payload — 8탭이 **서로 독립된 마스터 테이블**이라 탭마다 따로 둔다.
   * `handleSearch` 가 활성 시트 키만 채우고 비활성 시트는 `enabled:false` 로 발사되지 않는다
   * (AS-IS `FindData_Main` 의 `queryId` 8분기도 활성 시트 1건만 조회한다 — design 01 §2.3).
   */
  filters: FiltersBySheet;
  /** 활성 탭 — 탭 전환 가드(R09·R10)가 이 값을 바꾸는 유일 경로다. */
  activeSheet: GridSheet;
  /**
   * 시트별 독립 편집모드 — AS-IS `SpreadInfo` 의 시트별 LockFlag(design 01 §0 축 C).
   * 탭을 바꿔도 다른 시트 편집상태가 그대로 남는다(L-17).
   */
  editMode: Partial<Record<GridSheet, boolean>>;
  openSearchArea: boolean;
  /** admin `SCM_MST_SHEET_COLUMNS` 동적 fetch(8시트) — 미등록/실패 시 빈 배열 유지(hook #113 §1-3). */
  staticColumns: StaticColumnsBySheet;
}

interface Action {
  reset: () => void;
  setSearchParams: (patch: Partial<OptCapaSearchParams>) => void;
  setFilters: (sheet: GridSheet, plantCodes: string[], lineCodes: string[]) => void;
  clearFilters: () => void;
  setActiveSheet: (sheet: GridSheet) => void;
  setEditMode: (sheet: GridSheet, on: boolean) => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: (divisionId?: string) => Promise<void>;
}

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
  applied: null,
  filters: {},
  activeSheet: DEFAULT_SHEET,
  editMode: {},
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
        state.editMode = {};
      }),

    setActiveSheet: sheet =>
      set(state => {
        state.activeSheet = sheet;
      }),

    setEditMode: (sheet, on) =>
      set(state => {
        state.editMode = { ...state.editMode, [sheet]: on };
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
  }),
  'opt-capa-store'
);
