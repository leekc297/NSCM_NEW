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
  RESULT_TYPE_BY_SHEET,
  SHEETS,
} from './shipment-plan-mobility-it.constants';
import type { ActiveGrid, MainSheet, SearchCondition } from './shipment-plan-mobility-it.types';

// proc(쿼리) 백엔드가 있는 시트만 filter 보유 — 서브 detail(o_rc2/드릴다운)은 전용 proc 없어 제외.
type ProcBackedSheet = Exclude<
  SHEETS,
  SHEETS.WH_STOCK_DETAIL | SHEETS.HOLD_STOCK_DETAIL | SHEETS.WH_IN_PLAN_DETAIL
>;
type FiltersBySheet = {
  [S in ProcBackedSheet]?: ProcRequest<MENU_ID, S>;
};

type StaticColumnsBySheet = Partial<Record<SHEETS, RawFlexGridColumnConfig[]>>;

// SCM_MST_SHEET_MEASURE 동적 fetch row — /admin/menu/{MENU_ID}/measure (BE GridMeasure camelCase).
//   MeasureSelectModal 의 measures prop(MeasureMeta[]) 과 구조 호환(features/master 직접 import 회피).
export interface MeasureMeta {
  colNm: string;
  colLblNm?: string;
  sClsLblNm?: string;
  lClsLblNm?: string;
  personalizable?: boolean;
  display?: boolean;
}

type StaticMeasuresBySheet = Partial<Record<SHEETS, MeasureMeta[]>>;
// null = 전체 표시 (MeasureSelectModal 규약)
type VisibleMeasuresBySheet = Partial<Record<SHEETS, string[] | null>>;

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // 활성 master 시트 — Plant Site/PlanDate/ResultType cascade 트리거(searchParams 바깥, design 02 §3).
  mainSheet: MainSheet;
  // fps 활성 그리드 (AS-IS) — Save/Insert/Measure 라우팅. Detail 셀 클릭 시 'detail'.
  activeGrid: ActiveGrid;
  // 활성 시트 Plan Date 콤보의 최신(max) 코드 — AS-IS newPlanDate=dtNewPlanDate.Max(code). 편집 가능
  //   판정(선택 planDate == 최신)에 쓴다. Form 이 콤보 로드 시 갱신(MSG00170 이전 Plan 편집차단, R7b).
  latestPlanDate: string;
  activeDetailSheet: SHEETS;
  staticColumns: StaticColumnsBySheet;
  // Measure 선택(MeasureSelectModal) — 시트별 동적 measure 목록 + 표시 코드(null=전체).
  staticMeasures: StaticMeasuresBySheet;
  visibleMeasures: VisibleMeasuresBySheet;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setMainSheet: (sheet: MainSheet) => void;
  setLatestPlanDate: (ymd: string) => void;
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
  fetchStaticMeasures: (sheet: SHEETS) => Promise<void>;
  applyVisibleMeasures: (sheet: SHEETS, measureCodes: string[] | null) => void;
}

// AS-IS clbResultType 기본 체크 = 상위 2개(SetItemChecked(0)plan/(1)owms, .cs L1653-1663).
//   Main[P,O,E]→[P,O] / Packer[P,R]→[P,R].
const defaultResultTypes = (sheet: MainSheet): string[] =>
  (sheet === 'packer' ? RESULT_TYPE_BY_SHEET.PACKER : RESULT_TYPE_BY_SHEET.MAIN).slice(0, 2);

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
  resultTypes: defaultResultTypes('main'), // AS-IS 상위 2개(P,O) 기본 체크

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
  latestPlanDate: '',
  activeDetailSheet: SHEETS.CONFIRM_DETAIL,
  staticColumns: {},
  staticMeasures: {},
  visibleMeasures: {},
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
        // 활성시트(Mobility&IT↔Packer) 전환 — AS-IS SpdMain_ActiveSheetChanged 는 master 재조회/클리어가
        //   없다(시트별 데이터 보존). 따라서 filters(그리드 데이터)는 지우지 않는다 — 지우면 탭 이동마다
        //   상·하단 그리드가 전부 초기화된다(사용자 지시 2026-09-30). Plant Site(시트별 콤보 축)·Plan Date
        //   (시트별 [0] 재선택)·Result Type(시트별 기본체크)만 폼 값을 리셋한다.
        state.searchCondition.plantSiteIds = [];
        state.searchCondition.planDate = '';
        state.searchCondition.resultTypes = defaultResultTypes(sheet);
      }),

    setActiveGrid: grid =>
      set(state => {
        state.activeGrid = grid;
      }),

    setLatestPlanDate: ymd =>
      set(state => {
        if (state.latestPlanDate !== ymd) state.latestPlanDate = ymd;
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
          // SP WHERE 가 A.PLAN_TYPE=P_PLAN_TYPE / A.SEQ=P_SEQ 로 파라미터를 그대로 필터한다.
          //   데이터는 전건 PLAN_TYPE='SP'/SEQ=1 로만 적재(SP 내부 V_PLAN_TYPE:='SP'/V_SEQ:=1 상수와 일치, DB 실측 2026-09-30).
          //   빈값으로 보내면 매칭 0건 → 조회 무결과. 이 화면의 정규 상수값 'SP'/'1' 고정.
          planType: 'SP', // 5 P_PLAN_TYPE
          fromYyyymmdd: c.periodFrom, // 6 P_FROM_YYYYMMDD
          toYyyymmdd: c.periodTo, // 7 P_TO_YYYYMMDD
          userId: session.userId ?? '', // 8 P_USER_ID
          myModelChk: yn(c.chkMyModel), // 9 P_MYMODELCHK
          programId: PROGRAM_ID, // 10 P_PROGRAM_ID
          sheetName: ADMIN_SHEET_NAME[state.mainSheet === 'packer' ? SHEETS.MAIN_PACKER : SHEETS.MAIN] ?? '', // 11 P_SHEET_NAME
          debugMode: 'F', // 12 P_DEBUG_MODE
          seq: '1', // 13 P_SEQ (PLAN_TYPE='SP'와 짝 — 상단 주석 참조. 빈값이면 매칭 0건)
          partLeaderChk: yn(c.chkPartLeader), // 14 P_PARTLEADERCHK
          teamLeaderChk: yn(c.chkTeamLeader), // 15 P_TEAMLEADERCHK
          // nonchk = leader 필터 미선택 시 'Y'(전체) — AS-IS non 파라미터 등가(확인필요, 04_react-gap.md)
          nonChk: !c.chkPartLeader && !c.chkTeamLeader && !c.chkDelegatee ? 'Y' : 'N', // 16 P_NONCHK
          delegateeChk: yn(c.chkDelegatee), // 17 P_DELEGATEECHK
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
            myModelChk: my, // 9
            requestor: c.requestorId, // 10
            partLeaderChk: part, // 11
            teamLeaderChk: team, // 12
            searchYn, // 13
            nonChk: non, // 14
            realFlag: 'Y', // 15 (최신 Plan 기준 — Plan Date 최신 판정은 04 확인필요)
            debugMode: 'F', // 16
            delegateeChk: deleg, // 17
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
            myModelChk: my, // 10
            partLeaderChk: part, // 11
            teamLeaderChk: team, // 12
            nonChk: non, // 13
            delegateeChk: deleg, // 14
          };
        } else if (sheet === SHEETS.MES_STOCK) {
          state.filters[SHEETS.MES_STOCK] = {
            divisionId: div, // 1
            fromSite, // 2
            itemId, // 3
            planStartYyyymmdd: c.planDate, // 4
            userId, // 5
            lotId: multiLine(c.lotId), // 6
            myModelChk: my, // 7
            partLeaderChk: part, // 8
            teamLeaderChk: team, // 9
            delegateeChk: deleg, // 10
            nonChk: non, // 11
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
            myModelChk: my, // 8
            partLeaderChk: part, // 9
            teamLeaderChk: team, // 10
            searchYn, // 11
            nonChk: non, // 12
            delegateeChk: deleg, // 13
          };
        } else if (sheet === SHEETS.SCS_STOCK) {
          state.filters[SHEETS.SCS_STOCK] = {
            divisionId: div, // 1
            planStartYyyymmdd: c.planDate, // 2
            fromSite, // 3
            itemId, // 4
            userId, // 5
            myModelChk: my, // 6
            partLeaderChk: part, // 7
            teamLeaderChk: team, // 8
            delegateeChk: deleg, // 9
            nonChk: non, // 10
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
            myModelChk: my, // 12
            partLeaderChk: part, // 13
            teamLeaderChk: team, // 14
            delegateeChk: deleg, // 15
            nonChk: non, // 16
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
            myModelChk: my, // 9
            partLeaderChk: part, // 10
            teamLeaderChk: team, // 11
            delegateeChk: deleg, // 12
            nonChk: non, // 13
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

    // Measure 동적 fetch (SCM_MST_SHEET_MEASURE) — MeasureSelectModal 대상. 시트별 보관.
    fetchStaticMeasures: async (sheet: SHEETS) => {
      const sheetNm = ADMIN_SHEET_NAME[sheet];
      if (!sheetNm) return;
      try {
        // divisionId 미전달 — SSP0015 measure 는 DIVISION_ID=NULL(전역) 이라 '40' 필터 시 0건(실측).
        //   /column 엔드포인트와 동일하게 sheetNm 만 보낸다.
        const res = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
          sheetNm,
        });
        const next = res.data.result ?? [];
        set(state => {
          if (JSON.stringify(state.staticMeasures[sheet]) !== JSON.stringify(next)) {
            state.staticMeasures[sheet] = next;
          }
        });
      } catch {
        // 미등록/실패 = 기존 값 유지 (하드코딩 fallback 금지, console 금지)
      }
    },

    // MeasureSelectModal OK — 시트별 표시 measure 코드 보관(null=전체). 영구 저장은 화면이 titleSet SAVE.
    applyVisibleMeasures: (sheet, measureCodes) =>
      set(state => {
        state.visibleMeasures[sheet] = measureCodes;
      }),
  }),
  'shipment-plan-mobility-it-store'
);
