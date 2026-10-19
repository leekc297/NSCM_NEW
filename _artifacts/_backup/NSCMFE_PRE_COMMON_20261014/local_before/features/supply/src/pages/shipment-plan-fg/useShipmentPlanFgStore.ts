import type { MeasureMeta } from 'features/master/src/components';

import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  BUCKET_TYPE,
  MEASURE_SHEET_NAME,
  MENU_ID,
  SHEETS,
} from './shipment-plan-fg.constants';
import type { MainRow, SearchCondition } from './shipment-plan-fg.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.PEGGING]?: ProcRequest<MENU_ID, SHEETS.PEGGING>;
  [SHEETS.PROBLEM]?: ProcRequest<MENU_ID, SHEETS.PROBLEM>;
  [SHEETS.CALENDAR]?: ProcRequest<MENU_ID, SHEETS.CALENDAR>;
};

type StaticColumnsBySheet = {
  [SHEETS.MAIN]: RawFlexGridColumnConfig[];
  [SHEETS.PEGGING]: RawFlexGridColumnConfig[];
  [SHEETS.PROBLEM]: RawFlexGridColumnConfig[];
};

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  staticColumns: StaticColumnsBySheet;
  staticMeasures: MeasureMeta[];
  // btnMeasure(MeasureSelectModal) OK 결과 — 표시할 measure 코드 목록(null = 전체 표시, design 00 §1#7).
  visibleMeasures: string[] | null;
  // 조회 실행 시점의 스냅샷 — cboPlanDate/dCalendar 값이 조회 후 바뀌어도 편집잠금(BOD 판정)은
  //   "마지막 조회" 기준을 유지해야 한다(design 03 §3.1 blockStartDate 는 조회조건의 값을 쓴다).
  appliedPlanStartYyyymmdd: string;
  appliedFromYyyymmdd: string;
  appliedToYyyymmdd: string;
  // Plan Seq 콤보 후보 중 최댓값(design 01 §2 #2 Set_FixButtonEnabled 판정용) —
  //   ShipmentPlanFgForm 이 콤보 재계산 시마다 갱신한다(gap-resolve iter-1 NEW7).
  latestPlanSeq: string;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setPeggingFilter: (row: MainRow, dueDateYyyymmdd: string) => void;
  setProblemFilter: (row: MainRow, dueDateYyyymmdd: string) => void;
  clearDetailFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchStaticMeasures: () => Promise<void>;
  applyVisibleMeasures: (measureCodes: string[] | null) => void;
  setLatestPlanSeq: (v: string) => void;
}

const initSearch: SearchCondition = {
  divisionId: '',
  operationGroupId: '',
  fromSiteIds: [],
  toSiteIds: [],
  teamIds: [],
  endCustomerIds: [],
  electrodeTypeIds: [],
  planStartYyyymmdd: '',
  planType: '',
  planSeq: '',
  fromYyyymmdd: '',
  toYyyymmdd: '',
  itemId: '',
  projectCode: '',
  bucketType: BUCKET_TYPE.WEEKLY,
  chkAll: false,
  chkSum: false,
};

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.MAIN]: [],
  [SHEETS.PEGGING]: [],
  [SHEETS.PROBLEM]: [],
};

const initState: State = {
  initialized: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  staticColumns: emptyStaticColumns,
  staticMeasures: [],
  visibleMeasures: null,
  appliedPlanStartYyyymmdd: '',
  appliedFromYyyymmdd: '',
  appliedToYyyymmdd: '',
  latestPlanSeq: '',
};

const joinOrAll = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join(','));
const orAll = (v: string): string => (v && v.trim() ? v.trim() : 'ALL');
const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

export const useShipmentPlanFgStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // 조회조건 -> GET SP 파라미터(20개, design 03 §4.2 P_SCP0009_GET_SHIPMENT_PLAN_FG 순번 근거 주석).
    setFilter: () => {
      const c = get().searchCondition;
      set(state => {
        state.filters = {
          ...state.filters,
          [SHEETS.MAIN]: {
            fromYyyymmdd: c.fromYyyymmdd, // P_FROM_YYYYMMDD
            toYyyymmdd: c.toYyyymmdd, // P_TO_YYYYMMDD
            divisionId: orAll(c.divisionId), // P_DIVISION_ID
            bizType: orAll(c.operationGroupId), // P_BIZ_TYPE
            projectCode: orAll(c.projectCode), // P_PROJECT_CODE
            itemId: orAll(c.itemId), // P_ITEM_ID
            electype: joinOrAll(c.electrodeTypeIds), // P_ELECTYPE
            planStartYyyymmdd: c.planStartYyyymmdd, // P_PLAN_START_YYYYMMDD
            planType: c.planType, // P_PLAN_TYPE
            seq: c.planSeq, // P_SEQ
            fromsite: joinOrAll(c.fromSiteIds), // P_FROMSITE
            teamId: joinOrAll(c.teamIds), // P_TEAM_ID
            tosite: joinOrAll(c.toSiteIds), // P_TOSITE
            bucket: c.bucketType, // P_BUCKET
            toPeriod: '', // P_TO_PERIOD — 용도 확인 필요(design 02/03 미상세)
            chkAll: c.chkAll ? 'Y' : 'N', // P_CHK_ALL
            programId: MENU_ID, // P_PROGRAM_ID
            sheetName: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? '', // P_SHEET_NAME
            userId: useSessionStore.getState().session.userId ?? '', // P_USER_ID
            debugMode: 'F', // P_DEBUG_MODE
          },
        };
        state.filters[SHEETS.CALENDAR] = {
          fromYyyymmdd: c.fromYyyymmdd,
          toYyyymmdd: c.toYyyymmdd,
        };
        state.appliedPlanStartYyyymmdd = c.planStartYyyymmdd;
        state.appliedFromYyyymmdd = c.fromYyyymmdd;
        state.appliedToYyyymmdd = c.toYyyymmdd;
      });
    },
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    // 더블클릭 5-가드 통과 후 Pegging 상세 조회(design 03 §4.5 — 12 파라미터).
    setPeggingFilter: (row, dueDateYyyymmdd) =>
      set(state => {
        const r = row as unknown as Record<string, unknown>;
        state.filters = {
          ...state.filters,
          [SHEETS.PEGGING]: {
            divisionId: str(r.DIVISION_ID),
            planStartYyyymmdd: str(r.plan_start_yyyymmdd),
            planType: str(r.plan_type),
            seq: str(r.seq),
            itemId: str(r.ITEM_ID),
            bizType: str(r.biz_type),
            tosite: str(r.to_site),
            dueDate: dueDateYyyymmdd,
            projectCode: str(r.project_code),
            originFromDivisionId: str(r.ORIGIN_FROM_DIVISION_ID),
            originToDivisionId: str(r.ORIGIN_TO_DIVISION_ID),
            electrodeType: str(r.ELECTRODE_TYPE),
          },
        };
      }),
    // PlanProblem 상세 조회(design 03 §4.5 — 8 파라미터).
    setProblemFilter: (row, dueDateYyyymmdd) =>
      set(state => {
        const r = row as unknown as Record<string, unknown>;
        state.filters = {
          ...state.filters,
          [SHEETS.PROBLEM]: {
            divisionId: str(r.DIVISION_ID),
            planStartYyyymmdd: str(r.plan_start_yyyymmdd),
            planType: str(r.plan_type),
            seq: str(r.seq),
            itemId: str(r.ITEM_ID),
            projectCode: str(r.project_code),
            tosite: str(r.to_site),
            dueDate: dueDateYyyymmdd,
          },
        };
      }),
    clearDetailFilters: () =>
      set(state => {
        delete state.filters[SHEETS.PEGGING];
        delete state.filters[SHEETS.PROBLEM];
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),
    fetchStaticColumns: async () => {
      const sheets: (keyof StaticColumnsBySheet)[] = [SHEETS.MAIN, SHEETS.PEGGING, SHEETS.PROBLEM];
      await Promise.all(
        sheets.map(async sheet => {
          try {
            const res = await apiClient.post<RawFlexGridColumnConfig[]>(
              `/admin/menu/${MENU_ID}/column`,
              { sheetNm: ADMIN_SHEET_NAME[sheet] ?? sheet }
            );
            const next = res.data.result ?? [];
            if (next.length === 0) return;
            set(state => {
              if (JSON.stringify(state.staticColumns[sheet]) !== JSON.stringify(next)) {
                state.staticColumns[sheet] = next;
              }
            });
          } catch {
            // 미등록/실패 = constants fallback (console 금지 룰)
          }
        })
      );
      set(state => {
        state.initialized = true;
      });
    },
    fetchStaticMeasures: async () => {
      try {
        const res = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
          sheetNm: MEASURE_SHEET_NAME,
        });
        const next = res.data.result ?? [];
        set(state => {
          state.staticMeasures = next;
        });
      } catch {
        // 미등록/실패 = 빈 배열 유지(그리드는 MEASURE 코드 원본 순서로 표시)
      }
    },
    // MeasureSelectModal OK — 표시할 measure 코드만 보관(null = 전체 표시). 영구 저장(SCM_MST_TITLESET_USER)은
    //   호출측(ShipmentPlanFg.tsx)이 saveTitleSet 으로 별도 수행 — 이 액션은 화면 상태만 갱신한다.
    applyVisibleMeasures: measureCodes =>
      set(state => {
        state.visibleMeasures = measureCodes;
      }),
    setLatestPlanSeq: v =>
      set(state => {
        if (state.latestPlanSeq !== v) state.latestPlanSeq = v;
      }),
  }),
  'shipment-plan-fg-store'
);
