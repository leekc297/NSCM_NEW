import type { MeasureMeta } from 'features/master/src/components';

import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  BUCKET_TYPE,
  MEASURE_SHEET_NAME,
  MENU_ID,
  SHEETS,
} from './shipment-plan-fg.constants';
import type { SearchCondition } from './shipment-plan-fg.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.CALENDAR]?: ProcRequest<MENU_ID, SHEETS.CALENDAR>;
};

type StaticColumnsBySheet = {
  [SHEETS.MAIN]: RawFlexGridColumnConfig[];
};

interface State {
  initialized: boolean;
  // 개인화 조회조건 복원 1회 가드 (SubTitle F6 저장분 mount 복원 — initialized 는 컬럼 fetch 전용이라 별도).
  conditionsRestored: boolean;
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
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchStaticMeasures: () => Promise<void>;
  applyVisibleMeasures: (measureCodes: string[] | null) => void;
  setLatestPlanSeq: (v: string) => void;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchCondition 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

// 개인화 조건 복원 역직렬화 키(SubTitle F6 저장은 배열=콤마join·불리언=String 평문화 — personalizeCondition).
const ARRAY_KEYS = new Set<string>(['fromSiteIds', 'toSiteIds', 'teamIds', 'electrodeTypeIds']);
const BOOL_KEYS = new Set<string>(['chkAll', 'chkSum']);

type DayRange = { fromYyyymmdd: string; toYyyymmdd: string };

// AS-IS GetDayRange(PeriodType.W52)(design 01 §2.9, §4) 이식 — p_from_date(=cboPlanDate 선택값,
//   없으면 서버 현재일) 기준 p_offset_day(=주수*7-1) 만큼의 From:To 범위. Waterfall Shipment Plan FG
//   (useWaterfallShipmentPlanFgStore.ts getDayRange, 12개월 오프셋)와 같은 "anchor + offset - 1day"
//   형태로, PlanDate 등 anchor 기준 미래 방향 범위다.
export const getDayRange = (anchor: ReturnType<typeof dayjs>, weeks: number): DayRange => ({
  fromYyyymmdd: anchor.format('YYYYMMDD'),
  toYyyymmdd: anchor.add(weeks * 7 - 1, 'day').format('YYYYMMDD'),
});

// Form_Load 기본값(design 02 §4, §2.9): dCalendar.InitValue = GetDayRange(W52) — PlanDate 미선택
//   시점이라 anchor 는 서버 현재일(dayjs()) 이다.
const defaultPeriod = (): DayRange => getDayRange(dayjs(), 52);

const initSearch: SearchCondition = {
  divisionId: '',
  operationGroupId: '',
  fromSiteIds: [],
  toSiteIds: [],
  teamIds: [],
  electrodeTypeIds: [],
  planStartYyyymmdd: '',
  planType: '',
  planSeq: '',
  ...defaultPeriod(),
  itemId: '',
  projectCode: '',
  bucketType: BUCKET_TYPE.WEEKLY,
  chkAll: true, // TO-BE 기본 체크(AS-IS chkAll.InitValue 는 "N")
  chkSum: false,
};

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.MAIN]: [],
};

const initState: State = {
  initialized: false,
  conditionsRestored: false,
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
            // P_SHEET_NAME 은 Measure 레지스트리(`SCM_MST_SHEET_MEASURE`) 조회용이다. 컬럼 메타 시트명(ADMIN_SHEET_NAME)을
            //   넘기면 Measure 가 0건이 되어 데이터가 있어도 결과가 비므로 Measure 시트명을 보낸다.
            sheetName: MEASURE_SHEET_NAME,
            userId: useSessionStore.getState().session.userId ?? '', // P_USER_ID
            debugMode: 'F', // P_DEBUG_MODE
          },
        };
        state.filters[SHEETS.CALENDAR] = {
          // 헤더 메타 SP(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN)의 PROC_M COL_NM 은
          //   startYyyymmdd/endYyyymmdd 이며, 이름이 다르면 name-lookup 바인딩이 NULL 로 처리된다.
          startYyyymmdd: c.fromYyyymmdd,
          endYyyymmdd: c.toYyyymmdd,
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
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),
    fetchStaticColumns: async () => {
      const sheets: (keyof StaticColumnsBySheet)[] = [SHEETS.MAIN];
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

    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 형제 화면 파리티.
    //   GET /admin/menu/{MENU_ID}/search-conditions → PRAM_NM/PRAM_CTN 역직렬화(배열 split·불리언 ==='true').
    //   저장분 없으면 기본값(W52 기간·bucket 등) 유지.
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
        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in initSearch)) continue;
          const val = paramCtn ?? '';
          if (ARRAY_KEYS.has(paramNm)) patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          else if (BOOL_KEYS.has(paramNm)) patch[paramNm] = val === 'true';
          else patch[paramNm] = val;
        }
        set(state => {
          state.searchCondition = { ...state.searchCondition, ...patch } as SearchCondition;
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지)
      }
    },
  }),
  'shipment-plan-fg-store'
);
