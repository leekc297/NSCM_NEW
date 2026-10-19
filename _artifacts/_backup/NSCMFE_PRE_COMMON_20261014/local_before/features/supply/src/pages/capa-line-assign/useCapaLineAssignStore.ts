import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  ALL,
  ASSIGN_SHEET_BY_DIVISION_TYPE,
  DEFAULT_DIVISION_TYPE,
  DIVISION_TYPE,
  GRID_SHEETS,
  MENU_ID,
  SHEET_PARAM_NAME,
  SHEETS,
  SOP_SHEET_BY_DIVISION_TYPE,
  TAB,
  TIED_COLUMN_ORDER,
  type DivisionType,
  type TabIndex,
} from './capa-line-assign.constants';
import type { CapaLineAssignSearchParams } from './capa-line-assign.types';
import { applyTiedColumnOrder } from './utils/capaLineAssignColumns';

type GridSheet = Exclude<SHEETS, SHEETS.SPREAD_TITLE>;
type StaticColumnsBySheet = Record<GridSheet, RawFlexGridColumnConfig[]>;

/**
 * 시트별 SP payload. Assign(15 IN)과 SOP(14 IN, `p_item_id` 없음)는 계약이 다르므로 한 타입으로
 * 뭉치지 않는다 — `procedures.d.ts` 의 시트별 request 를 그대로 쓴다(SSOT, hook #73).
 * 팝업 2종은 자기 컴포넌트가 로컬 state 로 들고 있어 여기에 담지 않는다.
 */
interface FiltersBySheet {
  [SHEETS.ASSEMBLY]?: ProcRequest<MENU_ID, SHEETS.ASSEMBLY>;
  [SHEETS.ELTR]?: ProcRequest<MENU_ID, SHEETS.ELTR>;
  [SHEETS.SOP_ASSEMBLY]?: ProcRequest<MENU_ID, SHEETS.SOP_ASSEMBLY>;
  [SHEETS.SOP_ELTR]?: ProcRequest<MENU_ID, SHEETS.SOP_ELTR>;
}

/**
 * 다중선택 조건의 현재 후보 코드 전체.
 *
 * AS-IS `CString.GetCheckedListValue`(CString.cs:529-551)는 `"ALL"` 을 **현재 목록 전체 CODE 의
 * 콤마 CSV** 로 치환한다 — 즉 `'ALL'` sentinel 은 서버로 나가지 않는다(design 02 §4.3·V-16).
 * 후보 목록은 조회조건 cascade 훅이 알고 있으므로 Search 시점에 화면이 넘긴다.
 */
export interface CandidateCodes {
  siteIds: string[];
  plantIds: string[];
  factoryIds: string[];
  lineIds: string[];
  operationIds: string[];
  electrodeTypes: string[];
}

/** 확정 조회조건 — Search 로 실제 발사된 값. 신규행 기본값(VER/DIV)은 입력중 값이 아니라 여기서 온다. */
export interface AppliedCondition {
  divisionId: string;
  verId: string;
  verSeq: string;
  divisionType: DivisionType;
}

/** 컬럼 개인화(P04) 결과 — admin 메타 위에 얹는 사용자 오버레이(hook #115). */
export interface ColumnLayoutOverride {
  colNm: string;
  visible: boolean;
  width?: number;
  cellColor?: string;
  textColor?: string;
  order?: number;
}

interface State {
  initialized: boolean;
  searchParams: CapaLineAssignSearchParams;
  applied: AppliedCondition | null;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  staticColumns: StaticColumnsBySheet;
  userColumnLayout: Partial<Record<GridSheet, ColumnLayoutOverride[]>>;
}

interface Action {
  reset: () => void;
  setSearchParams: (patch: Partial<CapaLineAssignSearchParams>) => void;
  changeDivisionType: (next: DivisionType) => void;
  setFilters: (tab: TabIndex, candidates: CandidateCodes) => void;
  clearFilters: () => void;
  clearAssignFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: (divisionId?: string) => Promise<void>;
  applyColumnLayout: (sheet: GridSheet, layout: ColumnLayoutOverride[]) => void;
  clearUserColumnLayout: () => void;
}

const initSearchParams: CapaLineAssignSearchParams = {
  divisionId: '',
  verId: '',
  verSeq: '',
  // U-6 확정 — AS-IS Designer 는 SelectedIndex 미지정(-1)이라 비일관이었다. Electrode 고정.
  divisionType: DEFAULT_DIVISION_TYPE,
  // AS-IS `UsrCheckedList` 는 ALL_VIEW=true 이고 기본 선택이 ALL 이다(design 02 §4.2).
  siteIds: [ALL],
  plantIds: [ALL],
  factoryIds: [ALL],
  lineIds: [ALL],
  // 기본 모드가 ELTR(U-6)이고 그 모드에서는 Operation·Line Type 이 숨겨지므로, U-3 규칙대로
  //   초기값도 비운다 — `changeDivisionType` 의 ELTR 분기와 같은 상태여야 한다(진입/전환 비대칭 방지).
  operationIds: [],
  electrodeTypes: [],
  itemId: '',
  validYn: ALL,
};

const emptyStaticColumns = (): StaticColumnsBySheet =>
  GRID_SHEETS.reduce((acc, sheet) => {
    acc[sheet] = [];
    return acc;
  }, {} as StaticColumnsBySheet);

const initState = (): State => ({
  initialized: false,
  searchParams: initSearchParams,
  applied: null,
  filters: {},
  openSearchArea: true,
  staticColumns: emptyStaticColumns(),
  userColumnLayout: {},
});

/**
 * 다중선택 → SP 파라미터 CSV (design 02 §4.3·§5.3 / V-16·V-17).
 *
 * - `'ALL'` 선택   : 현재 후보 전체 CODE CSV.
 * - 선택 0건       : `emptyFallback` 이면 전체 CSV(Plant/Building/Line/Operation 4개만),
 *                    아니면 빈 문자열(Site·Line Type 은 폴백이 없다 — cs:441-464 vs 503-531).
 */
const toCsv = (selected: string[], candidates: string[], emptyFallback: boolean): string => {
  const picked = selected.filter(code => code && code !== ALL);
  if (selected.includes(ALL)) return candidates.join(',');
  if (picked.length > 0) return picked.join(',');
  return emptyFallback ? candidates.join(',') : '';
};

export const useCapaLineAssignStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState(),
    reset: () => set(initState()),

    setSearchParams: patch =>
      set(state => {
        state.searchParams = { ...get().searchParams, ...patch };
      }),

    /**
     * 축 A 전환 — AS-IS `rgrpDivisionType_SelectedIndexChanged`(cs:5540-5554) 의 전면 초기화.
     *
     * 이 화면에서 **유일하게 두 탭을 모두 비우는** 트리거다(design 01 §3.3 결론1). Division/Version/
     * VerSeq 변경은 Assign 탭만 비운다 — 그 비대칭을 "통일"하면 AS-IS 와 달라진다.
     *
     * 컬럼 메타 재조회(`fetchStaticColumns`)는 이 producer 안에서 하지 않는다. set() 커밋 전
     * `get()` 을 읽으면 컬럼셋이 한 스텝 밀린다(nscm-patterns §5-5) — 화면이 커밋 뒤 새 값으로 호출한다.
     */
    changeDivisionType: next =>
      set(state => {
        state.searchParams = {
          ...get().searchParams,
          divisionType: next,
          // U-3 확정 — 숨겨지는 조건의 값도 비운다. 숨긴 조건이 계속 SP 파라미터로 나가면
          //   사용자가 인지할 수 없는 결과 축소가 된다(design 01 Q-3).
          // Operation·Line Type 은 **같은 방향**이다 — ELTR 에서 둘 다 숨김(R-04·R-05,
          //   AS-IS `SetVisibleOperation` cs:5556-5566 / `SetVisibleElectrodeType` cs:5568-5584).
          operationIds: next === DIVISION_TYPE.ELTR ? [] : [ALL],
          electrodeTypes: next === DIVISION_TYPE.ELTR ? [] : [ALL],
          // 마스터 콤보 SQL_ID 자체가 바뀌므로(테이블이 다르다) 하위 4축 후보가 통째로 교체된다.
          siteIds: [ALL],
          plantIds: [ALL],
          factoryIds: [ALL],
          lineIds: [ALL],
        };
        state.filters = {};
        state.applied = null;
        state.userColumnLayout = {};
      }),

    /**
     * Search(F5) — AS-IS `FindButton` 은 첫 줄에서 `isPageSOP` 로 갈린다(cs:3883·3895).
     * 즉 **활성 탭 1개만** 조회한다. 탭을 바꾸면 사용자가 다시 Search 해야 한다(design 01 R-11).
     */
    setFilters: (tab, candidates) =>
      set(state => {
        const params = state.searchParams;
        const divisionType = params.divisionType;
        const sheetParam = SHEET_PARAM_NAME[divisionType];
        const isSop = tab === TAB.SOP;

        state.applied = {
          divisionId: params.divisionId,
          verId: params.verId,
          verSeq: params.verSeq,
          divisionType,
        };

        // 키 이름·순서 = AS-IS SetQueryInfoGetAssign(cs:4621-4652) / SetQueryInfoGetSOP(cs:4654-4686).
        //   `p_user_id` 는 BE @LoginUser 자동주입이라 싣지 않는다(convert-core §3.5).
        const common = {
          p_version: params.verId, //  1
          p_version_seq: params.verSeq, //  2
          p_division_id: params.divisionId, //  3
          p_site_id: toCsv(params.siteIds, candidates.siteIds, false), //  4 폴백 없음
          p_plant_id: toCsv(params.plantIds, candidates.plantIds, true), //  5 폴백 있음
          p_factory_id: toCsv(params.factoryIds, candidates.factoryIds, true), //  6 폴백 있음
          p_line_id: toCsv(params.lineIds, candidates.lineIds, true), //  7 폴백 있음
          p_operation_id: toCsv(params.operationIds, candidates.operationIds, true), //  8 폴백 있음
          p_electrode_type: toCsv(params.electrodeTypes, candidates.electrodeTypes, false), // 10 폴백 없음
          p_valid_flag: params.validYn === ALL ? '' : params.validYn, // 11 'ALL' → ''
          p_program_id: MENU_ID, // 12
          debug_mode: 'F', // 15 (14 = p_user_id, BE 주입)
        };

        if (isSop) {
          // SOP 는 `p_item_id` 가 없다(IN 14).
          state.filters = {
            ...state.filters,
            [SOP_SHEET_BY_DIVISION_TYPE[divisionType]]: {
              ...common,
              p_sheet_name: `SOP_${sheetParam}`, // 13
            },
          };
          return;
        }
        // Assign 만 Item 조건을 보낸다. SP 는 ASSEMBLY 에서 NICK_NAME, ELTR 에서 ITEM_ID 와 비교한다.
        state.filters = {
          ...state.filters,
          [ASSIGN_SHEET_BY_DIVISION_TYPE[divisionType]]: {
            ...common,
            p_item_id: params.itemId, //  9 (Assign 전용)
            p_sheet_name: sheetParam, // 13
          },
        };
      }),

    /** 탭 재진입 / Division Type 변경 — 두 그리드 모두 공백(자동 재조회 없음, nscm-patterns §5-7). */
    clearFilters: () =>
      set(state => {
        state.filters = {};
        state.applied = null;
      }),

    /**
     * Division / Plan Month / Version 변경 — **Assign 탭만** 비운다.
     * AS-IS 는 `BeforeFindDataAssign` 만 부르고 `BeforeFindDataSOP` 는 부르지 않는다(design 01 §3.3).
     */
    clearAssignFilters: () =>
      set(state => {
        const filters: FiltersBySheet = { ...state.filters };
        delete filters[SHEETS.ASSEMBLY];
        delete filters[SHEETS.ELTR];
        state.filters = filters;
      }),

    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),

    /**
     * admin `SCM_MST_SHEET_COLUMNS` 동적 fetch(8 라우팅 시트 → 7 메타 시트).
     * 미등록/실패 시 빈 배열을 유지한다 — 화면은 컬럼 0개로 뜨고 그 사실이 곧 메타 누락 신호다
     * (constants 하드코딩 fallback 을 두지 않는다 — CLAUDE.md §2 체크4 "속성 단위 덮어쓰기 금지").
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
            const fetched = res.data.result ?? [];
            if (fetched.length === 0) return;
            // `SORT_ORDER_NO` 동점 컬럼만 표시 순서를 고정한다(GAP-06 — SOP_ASSEMBLY 150 중복).
            //   값은 그대로 두고 순서만 결정적으로 만든다. 메타가 정정되면 결과가 같아진다.
            const next = applyTiedColumnOrder(fetched, TIED_COLUMN_ORDER[sheet]);
            set(state => {
              if (JSON.stringify(state.staticColumns[sheet]) !== JSON.stringify(next)) {
                state.staticColumns[sheet] = next;
              }
            });
          } catch {
            // 미등록/실패 = 빈 컬럼셋 유지 (console 금지)
          }
        })
      );
      set(state => {
        state.initialized = true;
      });
    },

    applyColumnLayout: (sheet, layout) =>
      set(state => {
        state.userColumnLayout = { ...state.userColumnLayout, [sheet]: layout };
      }),

    clearUserColumnLayout: () =>
      set(state => {
        state.userColumnLayout = {};
      }),
  }),
  'capa-line-assign-store'
);
