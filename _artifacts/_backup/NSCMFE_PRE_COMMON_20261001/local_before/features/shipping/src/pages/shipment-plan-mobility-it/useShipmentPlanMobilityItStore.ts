import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  BUCKET_TYPE,
  FIXED_DIVISION,
  MENU_ID,
  PERIOD3_FROM_OFFSET,
  PERIOD3_TO_OFFSET,
  PROGRAM_ID,
  SHEETS,
} from './shipment-plan-mobility-it.constants';
import type { ActiveGrid, MainSheet, SearchCondition } from './shipment-plan-mobility-it.types';

type FiltersBySheet = {
  [S in SHEETS]?: ProcRequest<MENU_ID, S>;
};

type StaticColumnsBySheet = Partial<Record<SHEETS, RawFlexGridColumnConfig[]>>;

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // 활성 master 시트 — Plant Site/PlanDate/ResultType cascade 트리거(searchParams 바깥, design 02 §3).
  mainSheet: MainSheet;
  // fps 활성 그리드 (AS-IS) — Save/Insert/Measure 라우팅. Detail 셀 클릭 시 'detail'.
  activeGrid: ActiveGrid;
  activeDetailSheet: SHEETS;
  staticColumns: StaticColumnsBySheet;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setMainSheet: (sheet: MainSheet) => void;
  setActiveGrid: (grid: ActiveGrid) => void;
  setActiveDetailSheet: (sheet: SHEETS) => void;
  setMainFilters: () => void;
  setDetailFilter: (
    sheet: SHEETS,
    dblFlag: 'Y' | 'N',
    overrides?: { itemId?: string; fromSite?: string }
  ) => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: (sheets: SHEETS[]) => Promise<void>;
}

const initSearch: SearchCondition = {
  plantSiteIds: [],
  bucketType: BUCKET_TYPE.DAILY,
  chkSum: false,
  planDate: '',
  periodFrom: '',
  periodTo: '',
  period2From: '',
  period2To: '',
  period3From: dayjs().add(PERIOD3_FROM_OFFSET, 'day').format('YYYYMMDD'),
  period3To: dayjs().add(PERIOD3_TO_OFFSET, 'day').format('YYYYMMDD'),
  itemId: '',
  model: '',
  lotId: '',
  requestorId: '',
  requestorName: '',
  resultTypes: [],
  chkMyModel: false,
  chkPartLeader: false,
  chkTeamLeader: false,
  chkDelegatee: false,
};

const initState: State = {
  initialized: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  mainSheet: 'main',
  activeGrid: 'main',
  activeDetailSheet: SHEETS.CONFIRM_DETAIL,
  staticColumns: {},
};

const joinOrEmpty = (arr: string[]): string => (arr.length === 0 ? '' : arr.join(','));
const multiLine = (v: string): string =>
  v
    ? v
        .split(/[\n,]/)
        .map(s => s.trim())
        .filter(Boolean)
        .join(',')
    : '';
const yn = (b: boolean): string => (b ? 'Y' : 'N');

export const useShipmentPlanMobilityItStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),

    setMainSheet: sheet =>
      set(state => {
        state.mainSheet = sheet;
        // 활성시트 전환 = Plant Site/PlanDate/ResultType 재조회 축 변경 → 그리드 초기화(design 02 §3)
        state.searchCondition.plantSiteIds = [];
        state.searchCondition.resultTypes = [];
        state.filters = {};
      }),

    setActiveGrid: grid =>
      set(state => {
        state.activeGrid = grid;
      }),

    setActiveDetailSheet: sheet =>
      set(state => {
        state.activeDetailSheet = sheet;
      }),

    // master 검색 — 활성시트로 main/mainPacker 분기(design 02 §3, 01 R4)
    setMainFilters: () => {
      set(state => {
        const c = state.searchCondition;
        const session = useSessionStore.getState().session;
        const common = {
          divisionId: FIXED_DIVISION, // 1 P_DIVISION_ID (고정 '40')
          fromSite: joinOrEmpty(c.plantSiteIds), // 2 P_FROM_SITE
          itemId: multiLine(c.itemId), // 3 P_ITEM_ID
          planStartYyyymmdd: c.planDate, // 4 P_PLAN_START_YYYYMMDD
          planType: '', // 5 P_PLAN_TYPE
          fromYyyymmdd: c.periodFrom, // 6 P_FROM_YYYYMMDD
          toYyyymmdd: c.periodTo, // 7 P_TO_YYYYMMDD
          userId: session.userId ?? '', // 8 P_USER_ID
          mymodelchk: yn(c.chkMyModel), // 9 P_MYMODELCHK
          programId: PROGRAM_ID, // 10 P_PROGRAM_ID
          sheetName: ADMIN_SHEET_NAME[state.mainSheet === 'packer' ? SHEETS.MAIN_PACKER : SHEETS.MAIN] ?? '', // 11 P_SHEET_NAME
          debugMode: 'F', // 12 P_DEBUG_MODE
          seq: '', // 13 P_SEQ
          partleaderchk: yn(c.chkPartLeader), // 14 P_PARTLEADERCHK
          teamleaderchk: yn(c.chkTeamLeader), // 15 P_TEAMLEADERCHK
          // nonchk = leader 필터 미선택 시 'Y'(전체) — AS-IS non 파라미터 등가(확인필요, 04_react-gap.md)
          nonchk: !c.chkPartLeader && !c.chkTeamLeader && !c.chkDelegatee ? 'Y' : 'N', // 16 P_NONCHK
          delegateechk: yn(c.chkDelegatee), // 17 P_DELEGATEECHK
        };
        if (state.mainSheet === 'packer') {
          state.filters[SHEETS.MAIN_PACKER] = common;
        } else {
          state.filters[SHEETS.MAIN] = common;
        }
        // 3단 헤더 캘린더 — 조회기간과 동일 구간 (design 03 §2)
        state.filters[SHEETS.CALENDAR] = {
          startYyyymmdd: c.periodFrom,
          endYyyymmdd: c.periodTo,
        };
      });
    },

    // detail 재조회 — 활성 sheet 분기(design 03 §4, 01 R드릴다운/btnSearch)
    setDetailFilter: (sheet, dblFlag, overrides) => {
      set(state => {
        const c = state.searchCondition;
        const session = useSessionStore.getState().session;
        const language = session.langCd ?? '';
        const userId = session.userId ?? '';
        const div = FIXED_DIVISION;
        const fromSite = overrides?.fromSite ?? joinOrEmpty(c.plantSiteIds);
        const itemId = overrides?.itemId ?? multiLine(c.model);
        const my = yn(c.chkMyModel);
        const part = yn(c.chkPartLeader);
        const team = yn(c.chkTeamLeader);
        const deleg = yn(c.chkDelegatee);
        const non = !c.chkPartLeader && !c.chkTeamLeader && !c.chkDelegatee ? 'Y' : 'N';
        const searchYn = dblFlag === 'Y' ? 'N' : 'Y';

        if (sheet === SHEETS.CONFIRM_DETAIL) {
          state.filters[SHEETS.CONFIRM_DETAIL] = {
            divisionId: div, // 1
            fromSite, // 2
            itemId, // 3
            fromYyyymmdd: c.period2From, // 4
            toYyyymmdd: c.period2To, // 5
            planStartYyyymmdd: c.planDate, // 6
            language, // 7
            userId, // 8
            mymodelchk: my, // 9
            requestor: c.requestorId, // 10
            partleaderchk: part, // 11
            teamleaderchk: team, // 12
            searchYn, // 13
            nonchk: non, // 14
            realFlag: 'Y', // 15 (최신 Plan 기준 — Plan Date 최신 판정은 04 확인필요)
            debugMode: 'F', // 16
            delegateechk: deleg, // 17
          };
        } else if (sheet === SHEETS.HOLD_STOCK) {
          state.filters[SHEETS.HOLD_STOCK] = {
            divisionId: div, // 1
            fromSite, // 2
            itemId, // 3
            planStartYyyymmdd: c.planDate, // 4
            planType: '', // 5
            seq: '', // 6
            language, // 7
            searchYn, // 8
            userId, // 9
            mymodelchk: my, // 10
            partleaderchk: part, // 11
            teamleaderchk: team, // 12
            nonchk: non, // 13
            delegateechk: deleg, // 14
          };
        } else if (sheet === SHEETS.MES_STOCK) {
          state.filters[SHEETS.MES_STOCK] = {
            divisionId: div, // 1
            fromSite, // 2
            itemId, // 3
            planStartYyyymmdd: c.planDate, // 4
            userId, // 5
            lotId: multiLine(c.lotId), // 6
            mymodelchk: my, // 7
            partleaderchk: part, // 8
            teamleaderchk: team, // 9
            delegateechk: deleg, // 10
            nonchk: non, // 11
            language, // 12
          };
        } else if (sheet === SHEETS.WH_STOCK) {
          state.filters[SHEETS.WH_STOCK] = {
            divisionId: div, // 1
            itemId, // 2
            planStartYyyymmdd: c.planDate, // 3
            planType: '', // 4
            planSeq: '', // 5
            fromSite, // 6
            userId, // 7
            mymodelchk: my, // 8
            partleaderchk: part, // 9
            teamleaderchk: team, // 10
            searchYn, // 11
            nonchk: non, // 12
            delegateechk: deleg, // 13
          };
        } else if (sheet === SHEETS.SCS_STOCK) {
          state.filters[SHEETS.SCS_STOCK] = {
            divisionId: div, // 1
            planStartYyyymmdd: c.planDate, // 2
            fromSite, // 3
            itemId, // 4
            userId, // 5
            mymodelchk: my, // 6
            partleaderchk: part, // 7
            teamleaderchk: team, // 8
            delegateechk: deleg, // 9
            nonchk: non, // 10
          };
        } else if (sheet === SHEETS.STOCK_LOCATION_DETAIL) {
          state.filters[SHEETS.STOCK_LOCATION_DETAIL] = {
            divisionId: div, // 1
            companyId: '', // 2 (40 사업부 company 미사용)
            fromSite, // 3
            itemId, // 4
            planStartYyyymmdd: c.planDate, // 5
            dblFlag, // 6
            language, // 7
            programId: PROGRAM_ID, // 8
            sheetName: ADMIN_SHEET_NAME[sheet] ?? '', // 9
            debugMode: 'F', // 10
            userId, // 11
            mymodelchk: my, // 12
            partleaderchk: part, // 13
            teamleaderchk: team, // 14
            delegateechk: deleg, // 15
            nonchk: non, // 16
          };
        } else if (sheet === SHEETS.SHIPMENT_RESULT) {
          state.filters[SHEETS.SHIPMENT_RESULT] = {
            divisionId: div, // 1
            fromSite, // 2
            itemId, // 3
            fromYyyymmdd: c.period3From, // 4
            toYyyymmdd: c.period3To, // 5
            type: joinOrEmpty(c.resultTypes), // 6
            userId, // 7
            companyId: '', // 8
            mymodelchk: my, // 9
            partleaderchk: part, // 10
            teamleaderchk: team, // 11
            delegateechk: deleg, // 12
            nonchk: non, // 13
            realFlag: 'Y', // 14
            planStartYyyymmdd: c.planDate, // 15
          };
        }
      });
    },

    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),

    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),

    fetchStaticColumns: async (sheets: SHEETS[]) => {
      for (const sheet of sheets) {
        const sheetNm = ADMIN_SHEET_NAME[sheet];
        if (!sheetNm) continue;
        try {
          const res = await apiClient.post<RawFlexGridColumnConfig[]>(
            `/admin/menu/${MENU_ID}/column`,
            { sheetNm }
          );
          const next = res.data.result ?? [];
          if (next.length > 0) {
            set(state => {
              if (JSON.stringify(state.staticColumns[sheet]) !== JSON.stringify(next)) {
                state.staticColumns[sheet] = next;
              }
            });
          }
        } catch {
          // 미등록/실패 = 기존 값 유지 (console 금지 룰)
        }
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'shipment-plan-mobility-it-store'
);
