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
} from './shipment-plan-semi.constants';
import type { SearchCondition } from './shipment-plan-semi.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.CALENDAR]?: ProcRequest<MENU_ID, SHEETS.CALENDAR>;
};

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  staticColumns: RawFlexGridColumnConfig[];
  // Measure 세트는 OperationGroup 값(A=CELL, 그외=ELECTRODE)에 따라 분기(design 03 §0.1) — sheetNm 별 캐시.
  staticMeasures: Record<'CELL' | 'ELECTRODE', MeasureMeta[]>;
  // 조회 실행 시점의 스냅샷 — 편집잠금(BOD 판정)은 "마지막 조회" 기준을 유지(design 03 §3.1).
  appliedDivisionId: string;
  appliedPlanStartYyyymmdd: string;
  appliedToYyyymmdd: string;
  // 저장 payload(design 03 §4.4)의 p_plan_type/p_seq — 행(row) 에는 이 값이 없다(MAIN_COLUMNS
  //   27건 어디에도 plan_type/seq 컬럼이 없음, 한 화면 조회결과는 항상 단일 Plan 이므로 조회조건
  //   스냅샷에서만 구할 수 있다). appliedDivisionId 와 동일하게 setFilter() 시점에 고정.
  appliedPlanType: string;
  appliedPlanSeq: string;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchStaticMeasures: (group: 'CELL' | 'ELECTRODE') => Promise<void>;
}

const initSearch: SearchCondition = {
  divisionId: '',
  operationGroupId: '',
  fromSiteIds: [],
  toSiteIds: [],
  electrodeTypeIds: [],
  planStartYyyymmdd: '',
  planType: '',
  planSeq: '',
  fromYyyymmdd: '',
  toYyyymmdd: '',
  itemId: '',
  bucketType: BUCKET_TYPE.WEEKLY,
  chkSum: false,
};

const initState: State = {
  initialized: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  staticColumns: [],
  staticMeasures: { CELL: [], ELECTRODE: [] },
  appliedDivisionId: '',
  appliedPlanStartYyyymmdd: '',
  appliedToYyyymmdd: '',
  appliedPlanType: '',
  appliedPlanSeq: '',
};

const joinOrAll = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join(','));
const orAll = (v: string): string => (v && v.trim() ? v.trim() : 'ALL');

export const useShipmentPlanSemiStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // 조회조건 -> GET SP 파라미터(15개, design 02 §2.9 P_SCP0010_GET_SHIP_PLAN_SEMI 순번 근거 주석).
    setFilter: () => {
      const c = get().searchCondition;
      // p_sheet_name — cboOperGroup=='A'(Cell) 면 CELL, 그 외(P/E) 면 ELECTRODE(design 02 §2.9,
      //   design 03 §0.1 — Pack 선택 시에도 ELECTRODE 로 가는 것이 AS-IS 그대로, 사용자 확인 필요 항목).
      const sheetName = c.operationGroupId === 'A' ? 'CELL' : 'ELECTRODE';
      set(state => {
        state.filters = {
          ...state.filters,
          [SHEETS.MAIN]: {
            fromYyyymmdd: c.fromYyyymmdd, // P_FROM_YYYYMMDD
            toYyyymmdd: c.toYyyymmdd, // P_TO_YYYYMMDD
            divisionId: orAll(c.divisionId), // P_DIVISION_ID
            operationGroup: orAll(c.operationGroupId), // P_OPERATION_GROUP
            itemId: orAll(c.itemId), // P_ITEM_ID
            electype: joinOrAll(c.electrodeTypeIds), // P_ELECTYPE
            planStartYyyymmdd: c.planStartYyyymmdd, // P_PLAN_START_YYYYMMDD
            planType: c.planType, // P_PLAN_TYPE
            seq: c.planSeq, // P_SEQ
            fromsite: joinOrAll(c.fromSiteIds), // P_FROMSITE
            tosite: joinOrAll(c.toSiteIds), // P_TOSITE
            programId: MENU_ID, // P_PROGRAM_ID
            // P_SHEET_NAME — Measure 레지스트리(SCM_MST_SHEET_MEASURE) 필터용 CELL/ELECTRODE.
            //   admin 컬럼메타 SHEET_NAME('Shipment Plan SEMI')이 아니다(PKG_SCP0010 PACKAGE BODY
            //   L2122,2172-2196 실측 — 컬럼메타 값을 넣으면 GT_SCP0010_MEASURE 가 항상 0행이 돼
            //   메인 그리드(O_RC1)가 항상 0행으로 나온다, iter-1 gap-audit SCP0010-G-01).
            sheetName,
            sesUserId: useSessionStore.getState().session.userId ?? '', // P_USER_ID(SCM_ADM_PROC_M COL_NM=sesUserId)
            debugMode: 'F', // P_DEBUG_MODE
          },
        };
        state.filters[SHEETS.CALENDAR] = {
          // SCM_ADM_PROC_M(PROC_NM=PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN) 등록 COL_NM은
          //   startYyyymmdd/endYyyymmdd — fromYyyymmdd/toYyyymmdd 로 보내면 name-lookup 바인딩이
          //   NULL 처리되어 헤더(D_/W_/M_) 0열이 된다(iter-1 gap-audit SCP0010-G-02).
          startYyyymmdd: c.fromYyyymmdd,
          endYyyymmdd: c.toYyyymmdd,
        };
        state.appliedDivisionId = c.divisionId;
        state.appliedPlanStartYyyymmdd = c.planStartYyyymmdd;
        state.appliedToYyyymmdd = c.toYyyymmdd;
        state.appliedPlanType = c.planType;
        state.appliedPlanSeq = c.planSeq;
      });
      // Measure 레지스트리는 sheetName(CELL/ELECTRODE) 이 조회조건 값에 종속되므로 조회 시점에 fetch.
      void get().fetchStaticMeasures(sheetName);
    },
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? SHEETS.MAIN,
        });
        const next = res.data.result ?? [];
        if (next.length > 0) {
          set(state => {
            if (JSON.stringify(state.staticColumns) !== JSON.stringify(next)) {
              state.staticColumns = next;
            }
          });
        }
      } catch {
        // 미등록/실패 = constants fallback(console 금지 룰)
      }
      set(state => {
        state.initialized = true;
      });
    },
    fetchStaticMeasures: async group => {
      try {
        const res = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
          sheetNm: MEASURE_SHEET_NAME[group],
        });
        const next = res.data.result ?? [];
        set(state => {
          state.staticMeasures = { ...state.staticMeasures, [group]: next };
        });
      } catch {
        // 미등록/실패 = 빈 배열 유지(그리드는 MEASURE 코드 원본 순서로 표시)
      }
    },
  }),
  'shipment-plan-semi-store'
);
