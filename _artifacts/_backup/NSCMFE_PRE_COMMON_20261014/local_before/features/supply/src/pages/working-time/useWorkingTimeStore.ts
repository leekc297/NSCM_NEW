import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { MENU_ID, SHEETS } from './working-time.constants';
import type { SearchParamProps } from './working-time.types';

// SP filter payload — useTabProcQuery enabled 가드.
//   MAIN = PKG_SCP0019.P_SCP0019_GET_WORKING_TIME (7 IN, OUT O_RC1 데이터 + O_RESULT_CURSOR 상태).
//   커서 실측(all_source BODY, 04_impl-gap-audit #1): O_RC1 = 피벗 데이터(정적 14 + 동적 D_yyyymmdd),
//   O_RESULT_CURSOR = 상태('0'/'SUCCESS'). 타이틀-메타 커서는 없다 — 동적 컬럼은 데이터 커서 alias 이며
//   BE 가 o_rc1_columns 로 함께 노출한다. 별도 타이틀 SP 도 없으므로 시트는 MAIN 하나뿐(03_grid-columns §2-a).
type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

interface WorkingTimeState {
  initialized: boolean;
  isOpenSearchArea: boolean;
  searchParams: SearchParamProps;
  filters: FiltersBySheet;
  staticColumn: RawFlexGridColumnConfig[];
}

interface WorkingTimeAction {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilters: () => void;
  clearFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
}

// dCalendar 기본기간 — 02_search-combo §4 PERIOD_* BIZ 프리셋. 데이터량·성능 확정 전 기본안으로
//   당월 1일 ~ 익월 말일(근무 캘린더는 단기 범위) — dayjs 로컬 날짜(toISOString UTC 금지).
//   PERIOD_* SP 연동은 확인필요 이월(04_react-gap) — 우선 클라 기본값으로 개통.
const initPeriod = {
  start: dayjs().startOf('month').format('YYYYMMDD'),
  end: dayjs().add(1, 'month').endOf('month').format('YYYYMMDD'),
};

const initWorkingTimeState: WorkingTimeState = {
  initialized: false,
  isOpenSearchArea: true,
  searchParams: {
    // 마운트 시 첫 권한 division 자동선택 — Form 이 옵션 로드 후 교정(session.div 비어있을 수 있음).
    divisionId: useSessionStore.getState().session.div ?? '',
    plantSiteIds: [],
    buildingIds: [],
    operationIds: [],
    lineIds: [],
    // cboDayWeek 기본 SelectDay — btnInput 값입력 전 미선택 상태(02 §2-b·§4).
    dayWeekCode: 'SelectDay',
    startYyyymmdd: initPeriod.start,
    endYyyymmdd: initPeriod.end,
    inputValue: '',
  },
  filters: {},
  staticColumn: [],
};

export const useWorkingTimeStore = createPersistedStoreWithTab<
  WorkingTimeState & WorkingTimeAction
>(
  (set, get) => ({
    ...initWorkingTimeState,
    reset: () => set(initWorkingTimeState),

    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
      });
    },
    setFilters: () => {
      // 키명 = PKG_SCP0019.P_SCP0019_GET_WORKING_TIME PROC_M COL_NM (03_grid-columns §2-a 실측 IN 7).
      //   SP 본문이 division/plant/line 을 comma-split(REGEXP_SUBSTR) IN 필터 + 'ALL' 미필터 처리하므로
      //   멀티 콤보 빈값은 'ALL' sentinel(orAll)로 넘긴다. sesUserId/mnuId 는 BE 세션 자동(보강 전송).
      const sesUserId = useSessionStore.getState().session.userId ?? '';
      set(state => {
        const p = state.searchParams;
        const orAll = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join(','));
        state.filters = {
          [SHEETS.MAIN]: {
            fromYyyymmdd: p.startYyyymmdd, //   1 P_FROM_YYYYMMDD
            toYyyymmdd: p.endYyyymmdd, //        2 P_TO_YYYYMMDD
            divisionId: p.divisionId, //         3 P_DIVISION_ID (단일 필수)
            plantSiteId: orAll(p.plantSiteIds),//4 P_PLANT_SITE_ID
            factoryId: orAll(p.buildingIds), //  5 P_FACTORY_ID (Building)
            operationId: orAll(p.operationIds),//6 P_OPERATION_ID
            lineId: orAll(p.lineIds), //         7 P_LINE_ID
            sesUserId, //                        세션 자동(보강)
            mnuId: MENU_ID, //                   세션 자동(보강)
          },
        };
      });
    },
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),

    // ui-dynamic-property-management — Column 동적 fetch (SCM_MST_SHEET_COLUMNS 14행, admin 즉시 반영).
    fetchStaticColumns: async () => {
      try {
        const result = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          {
            sheetNm: SHEETS.MAIN, // 'Working Time' — 등록명 그대로 (룰 #91)
          }
        );
        set(state => {
          state.staticColumn = result.data.result ?? [];
          state.initialized = true;
        });
      } catch {
        // BE 메타 미응답 시 silent — staticColumn 은 빈 배열로 남는다 (console 금지 룰)
      }
    },
  }),
  'working-time-store'
);
