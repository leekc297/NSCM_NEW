import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, BUCKET_TYPE, MENU_ID, SHEETS } from './production-plan-line.constants';
import type { MainRow, SearchCondition } from './production-plan-line.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.LOAD]?: ProcRequest<MENU_ID, SHEETS.LOAD>;
};

type StaticColumnsBySheet = {
  [SHEETS.MAIN]: RawFlexGridColumnConfig[];
};

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // admin SCM_MST_SHEET_COLUMNS 동적 fetch (ui-dynamic-property-management §2.3). SCP0013 'Line' 27행 등록
  //   확인됨(ora.py 2026-09-16) → 미등록 시 빈 배열(그리드 constants fallback).
  staticColumns: StaticColumnsBySheet;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setDivision: (divisionId: string) => void;
  setFilter: () => void;
  clearFilters: () => void;
  // Load 팝업 — 부모 조회조건을 파라미터로 주입(design 01 P / BtnLoad_Click cs:944).
  setLoadFilter: () => void;
  clearLoadFilter: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
}

const initSearch: SearchCondition = {
  // 기본 division = 세션 division(권한 division 첫 행 근사). Form 이 콤보 옵션과 대조해 교정.
  divisionId: useSessionStore.getState().session.div ?? '40',
  operationGroupId: '',
  plantSiteIds: [],
  lineIds: [],
  electrodeTypes: [],
  cellTypeGrs: [],
  extraSpecs: [],
  planStartYyyymmdds: [],
  planTypes: [],
  planSeqs: [],
  bucket: BUCKET_TYPE.WEEKLY, // design 01 A1 기본 WEEKLY
  fromYyyymmdd: '',
  toYyyymmdd: '',
  modelId: '',
  itemId: '',
  nickName: '',
  chkAll: false, // design 01 A1
  chkLineAssign: false,
  chkSum: false,
};

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.MAIN]: [],
};

const initState: State = {
  initialized: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  staticColumns: emptyStaticColumns,
};

// 다중 선택 배열 → SP 파라미터 문자열. 빈 배열 = 'ALL' sentinel (design 02 §5.2).
const joinOrAll = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join(','));
const orAll = (v: string): string => (v && v.trim() ? v.trim() : 'ALL');
const str = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');
// electrode: 다중, 전체선택/빈값 = 'ALL'(서버 NULL 특례 — design 02 §5.2 electrode ALL→NULL).
const electrodeParam = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join(','));

export const useProductionPlanLineStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // division 변경 = 하위 cascade 초기화(design 01 B / 02 §3) + 그리드 clear(D2). 버전콤보/사이트/라인 리셋.
    setDivision: divisionId =>
      set(state => {
        state.searchCondition = {
          ...get().searchCondition,
          divisionId,
          operationGroupId: '',
          plantSiteIds: [],
          lineIds: [],
          cellTypeGrs: [],
          extraSpecs: [],
          planStartYyyymmdds: [],
          planTypes: [],
          planSeqs: [],
        };
        state.filters = {}; // 그리드 데이터 clear (design 01 D2)
      }),
    // 메인 GET 22-param 매핑 (design 02 §5.2 — SP IN 순번 주석). p_division_id/p_operation_group 단일값.
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: orAll(c.divisionId), //  1 p_division_id (단일)
            operationGroup: orAll(c.operationGroupId), //  2 p_operation_group (단일)
            scmSiteId: joinOrAll(c.plantSiteIds), //  3 p_scm_site_id (다중)
            lineId: joinOrAll(c.lineIds.filter(v => v !== '-')), //  4 p_line_id ('-'→제외)
            modelId: str(c.modelId), //  5 p_model_id
            itemId: str(c.itemId), //  6 p_item_id
            fromYyyymmdd: c.fromYyyymmdd.replace(/-/g, ''), //  7 p_from_yyyymmdd
            toYyyymmdd: c.toYyyymmdd.replace(/-/g, ''), //  8 p_to_yyyymmdd
            planStartYyyymmdd: joinOrAll(c.planStartYyyymmdds), //  9 p_plan_start_yyyymmdd (다중)
            planType: joinOrAll(c.planTypes), // 10 p_plan_type (다중)
            seq: joinOrAll(c.planSeqs), // 11 p_seq (다중)
            electrodeType: electrodeParam(c.electrodeTypes), // 12 p_electrode_type (ALL→NULL)
            nickName: str(c.nickName), // 13 p_nick_name
            cellTypeGr: joinOrAll(c.cellTypeGrs), // 14 p_cell_type_gr (다중)
            bucket: c.bucket, // 15 p_bucket
            lineAssign: c.chkLineAssign ? 'Y' : 'N', // 16 p_line_assign
            chkAll: c.chkAll ? 'Y' : 'N', // 17 p_chk_all (Y→서버 강제 DAILY)
            extraSpec: joinOrAll(c.extraSpecs), // 18 p_extra_spec (다중)
            programId: MENU_ID, // 19 p_program_id
            sheetName: 'LINE', // 20 p_sheet_name
            debugMode: 'F', // 22 debug_mode (21 p_user_id = 세션 자동)
          },
        };
      });
    },
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    // Load 팝업 조회 — 부모 조회조건 주입(design 01 P3). 팝업은 완전 읽기전용 선택 로드.
    setLoadFilter: () =>
      set(state => {
        const c = state.searchCondition;
        state.filters = {
          ...state.filters,
          [SHEETS.LOAD]: {
            divisionId: orAll(c.divisionId),
            operationGroup: orAll(c.operationGroupId),
            scmSiteId: joinOrAll(c.plantSiteIds),
            planStartYyyymmdd: joinOrAll(c.planStartYyyymmdds),
            planType: joinOrAll(c.planTypes),
            seq: joinOrAll(c.planSeqs),
            fromYyyymmdd: c.fromYyyymmdd.replace(/-/g, ''),
            toYyyymmdd: c.toYyyymmdd.replace(/-/g, ''),
            programId: MENU_ID,
            debugMode: 'F',
          },
        };
      }),
    clearLoadFilter: () =>
      set(state => {
        delete state.filters[SHEETS.LOAD];
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),
    // admin SCM_MST_SHEET_COLUMNS('Line') 동적 fetch — 미등록/실패 시 빈 배열(그리드 constants fallback).
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? SHEETS.MAIN }
        );
        const next = res.data.result ?? [];
        if (next.length > 0) {
          set(state => {
            if (JSON.stringify(state.staticColumns[SHEETS.MAIN]) !== JSON.stringify(next)) {
              state.staticColumns[SHEETS.MAIN] = next;
            }
          });
        }
      } catch {
        // 미등록/실패 = constants fallback (console 금지 룰)
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'production-plan-line-store'
);

// 그리드가 소비할 편집 판정 컨텍스트 파생 — 조회결과에서 최종 PlanType/FN 존재 계산(design 01 F2).
export const deriveEditContext = (rows: MainRow[]): { lastPlanType: string; hasFn: boolean } => {
  let lastPlanType = '';
  let hasFn = false;
  for (const r of rows) {
    const pt = str((r as Record<string, unknown>).PLAN_TYPE);
    if (pt) lastPlanType = pt;
    if (pt === 'FN') hasFn = true;
  }
  return { lastPlanType, hasFn };
};
