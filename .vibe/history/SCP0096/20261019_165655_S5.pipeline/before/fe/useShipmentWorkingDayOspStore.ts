import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { DAY_WEEK, MENU_ID, SHEETS } from './shipment-working-day-osp.constants';
import type { SearchParamProps } from './shipment-working-day-osp.types';

// SP filter payload — useTabProcQuery enabled 가드.
//   MAIN = PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP (4 IN, OUT O_RC1 데이터 + O_RESULT_CURSOR 상태).
//   커서 실측(all_source BODY, 03_grid-columns §4): O_RC1 = 동적 PIVOT(정적 6 + D_/W_/M_), O_RESULT_CURSOR = 상태.
//   타이틀-메타 커서는 없다 — 동적 컬럼은 데이터 커서 alias 이며 BE 가 o_rc1_columns 로 함께 노출한다.
//   3SPAN 헤더는 별도 공용 SP(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN)이나 헤더 그룹은
//   dynamic-columns 에서 yyyymmdd 로 재현하므로 조회는 이 MAIN 시트 하나로 개통(SCP0019 동형).
type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

interface ShipmentWorkingDayOspState {
  initialized: boolean;
  // 개인화 조회조건 복원 1회 가드 (SubTitle F6 저장분 mount 복원 — initialized 는 컬럼 fetch 전용이라 별도).
  conditionsRestored: boolean;
  isOpenSearchArea: boolean;
  searchParams: SearchParamProps;
  filters: FiltersBySheet;
  staticColumn: RawFlexGridColumnConfig[];
}

interface ShipmentWorkingDayOspAction {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setDivision: (divisionId: string) => void;
  setFilters: () => void;
  clearFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchParams 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

// 개인화 조건 복원 역직렬화 키(SubTitle F6 저장은 배열=콤마join·날짜키 제외 — personalizeCondition).
//   plantSiteIds 는 배열 → 저장 시 콤마 join, 복원 시 split. 기간(startYyyymmdd/endYyyymmdd)은 저장측
//   EXCLUDED_DATE_PARAM 이 제외하므로 복원 rows 에 오지 않는다. 불리언 조회조건 없음.
const ARRAY_KEYS = new Set<string>(['plantSiteIds']);

// dCalendar 기본기간 — 02_search-combo §2 #3 Period(dCalendar GetDayRange DAILY). 데이터·성능 확정 전 기본안으로
//   당월 1일 ~ 익월 말일 — dayjs 로컬 날짜(toISOString UTC 금지, SCP0019 동일).
const initPeriod = {
  start: dayjs().startOf('month').format('YYYYMMDD'),
  end: dayjs().add(1, 'month').endOf('month').format('YYYYMMDD'),
};

const initShipmentWorkingDayOspState: ShipmentWorkingDayOspState = {
  initialized: false,
  conditionsRestored: false,
  isOpenSearchArea: true,
  searchParams: {
    // 마운트 시 첫 권한 division 자동선택 — Form 이 옵션 로드 후 교정(session.div 비어있을 수 있음).
    divisionId: useSessionStore.getState().session.div ?? '',
    plantSiteIds: [],
    // cboDayWeek 기본 SelectDay — btnInput 값입력 전 선택셀 기입 모드(02 §2 #4).
    dayWeekCode: DAY_WEEK.SELECT_DAY,
    startYyyymmdd: initPeriod.start,
    endYyyymmdd: initPeriod.end,
    inputValue: '',
  },
  filters: {},
  staticColumn: [],
};

export const useShipmentWorkingDayOspStore = createPersistedStoreWithTab<
  ShipmentWorkingDayOspState & ShipmentWorkingDayOspAction
>(
  (set, get) => ({
    ...initShipmentWorkingDayOspState,
    reset: () => set(initShipmentWorkingDayOspState),

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
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division·기간(from/to)을 제외한 검색조건을 전부 초기화하고
    //   그리드도 초기화(filters clear)한다(TO-BE 공통 요건이 AS-IS 핸들러보다 우선 — apply-division-reset,
    //   정본 SCP0025 setDivision). 유지: divisionId(새 값)·startYyyymmdd·endYyyymmdd. 초기화:
    //   plantSiteIds(cascade 하위)·dayWeekCode(기본 SelectDay)·inputValue. 편집중(dirty) 가드(MSG00704)는
    //   Form 의 onChange 가 confirmIfDirtyKey 로 처리하고(commit 51d4e9fa 패턴), 미저장 편집 폐기·hasSearched
    //   리셋은 부모 resetGrid(onDivisionChange)가 담당한다.
    setDivision: divisionId =>
      set(state => {
        const cur = get().searchParams;
        state.searchParams = {
          ...initShipmentWorkingDayOspState.searchParams, // plantSite/dayWeek/inputValue 초기화
          divisionId,
          startYyyymmdd: cur.startYyyymmdd,
          endYyyymmdd: cur.endYyyymmdd,
        };
        state.filters = {}; // 그리드 초기화 — 재조회(Search) 전까지 빈 상태
      }),
    setFilters: () => {
      // 키명 = PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP all_arguments COL_NM (03 §4 실측 IN 4).
      //   SP 본문이 plant 를 comma-split IN 필터 + 'ALL' 미필터 처리하므로 멀티 콤보 빈값은 'ALL' sentinel(orAll).
      //   sesUserId/mnuId 는 BE 세션 자동(콤보 권한필터용, GET IN 아님 — 미전송).
      set(state => {
        const p = state.searchParams;
        const orAll = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join(','));
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: p.divisionId, //           1 P_DIVISION_ID (단일 필수)
            plantSiteId: orAll(p.plantSiteIds), //  2 P_PLANT_SITE_ID
            fromYyyymmdd: p.startYyyymmdd, //        3 P_FROM_YYYYMMDD
            toYyyymmdd: p.endYyyymmdd, //            4 P_TO_YYYYMMDD
          },
        };
      });
    },
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),

    // ui-dynamic-property-management — Column 동적 fetch (SCM_MST_SHEET_COLUMNS 6행, admin 즉시 반영).
    fetchStaticColumns: async () => {
      try {
        const result = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          {
            sheetNm: SHEETS.MAIN, // 'Shipment Working Day OSP' — 등록명 그대로 (룰 #91)
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

    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 형제 shipment-plan-fix 파리티.
    //   GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 역직렬화. plantSiteIds 는 콤마 split,
    //   그 외는 문자열 그대로. 저장측이 날짜키(startYyyymmdd/endYyyymmdd)를 제외하므로 기간은 기본값 유지.
    //   저장분 없으면 기본값 유지. divisionId 저장분이 있으면 세션 기본 divisionId 를 덮는다.
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
          if (!(paramNm in initShipmentWorkingDayOspState.searchParams)) continue; // 조회조건 필드만 allowlist
          const val = paramCtn ?? '';
          if (ARRAY_KEYS.has(paramNm)) patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          else patch[paramNm] = val;
        }
        set(state => {
          state.searchParams = { ...state.searchParams, ...patch } as SearchParamProps;
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지 룰)
      }
    },
  }),
  'shipment-working-day-osp-store'
);
