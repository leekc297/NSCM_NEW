import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  MENU_ID,
  PERIOD_BUSINESS_DAYS,
  SHEETS,
} from './shipment-plan-confirm-detail.constants';
import type { SearchCondition } from './shipment-plan-confirm-detail.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

type StaticColumnsBySheet = {
  [SHEETS.MAIN]: RawFlexGridColumnConfig[];
};

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // L1 권한 게이트(design 01 §2) — MyDivision(EE 제외) 콤보 0건이면 false → 조회영역 disable.
  hasDivisionAuth: boolean;
  // ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch(mount + Search).
  staticColumns: StaticColumnsBySheet;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setPeriod: (fromYyyymmdd: string, toYyyymmdd: string) => void;
  // design 02 §3: Division 변경 = From Site cascade 재조회(콤보 payload) + Period 기본값 리셋(cs:380).
  setDivisions: (divisionIds: string[]) => void;
  // mount 시 Period 기본값(오늘 ~ +55영업일) 세팅.
  initPeriodDefault: () => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setDivisionAuth: (has: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
}

const initSearch: SearchCondition = {
  divisionIds: [],
  fromSiteIds: [],
  itemId: '',
  fromYyyymmdd: '',
  toYyyymmdd: '',
  soldToParty: '',
  shipToParty: '',
};

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.MAIN]: [],
};

const initState: State = {
  initialized: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  hasDivisionAuth: true,
  staticColumns: emptyStaticColumns,
};

// design 02 §2/§4: Period 기본 = 오늘 ~ 오늘 +55영업일(주말 제외 근사).
//   주의: AS-IS 는 SCM0001_GET_SCP_DAY_PERIOD(타임존/휴일 반영) 서버계산 — TO-BE 미배포라 클라 근사(dayjs).
//   정밀 영업일(공휴일 포함) 계산은 convert-sp(SP 배포) 후 대조(goal §②/§⑦-1).
const addBusinessDays = (from: dayjs.Dayjs, days: number): dayjs.Dayjs => {
  let cursor = from;
  let remaining = days;
  while (remaining > 0) {
    cursor = cursor.add(1, 'day');
    const dow = cursor.day(); // 0=일, 6=토
    if (dow !== 0 && dow !== 6) remaining -= 1;
  }
  return cursor;
};
const defaultPeriod = (): { from: string; to: string } => {
  const base = dayjs();
  return {
    from: base.format('YYYYMMDD'),
    to: addBusinessDays(base, PERIOD_BUSINESS_DAYS).format('YYYYMMDD'),
  };
};

// 다중/개행 -> SP 파라미터 문자열. 빈값 = '' (전체, GET SP TRIM 무시).
const joinOrEmpty = (arr: string[]): string => (arr.length === 0 ? '' : arr.join(','));
// 개행/콤마 다건 -> 콤마 join (AS-IS UsrMultiLineEditor .Text, GET SP FN_GET_IN_STR IN절).
const multiLine = (v: string): string =>
  v
    ? v
        .split(/[\n,]/)
        .map(s => s.trim())
        .filter(Boolean)
        .join(',')
    : '';

export const useShipmentPlanConfirmDetailStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    setPeriod: (fromYyyymmdd, toYyyymmdd) =>
      set(state => {
        state.searchCondition.fromYyyymmdd = fromYyyymmdd;
        state.searchCondition.toYyyymmdd = toYyyymmdd;
      }),
    // design 02 §3 cascade: Division 변경 시 From Site 초기화(재조회 콤보가 divisionId 로 재발사) +
    //   Period 기본값 리셋(SetChangedControl cs:380).
    setDivisions: divisionIds =>
      set(state => {
        const { from, to } = defaultPeriod();
        state.searchCondition.divisionIds = divisionIds;
        state.searchCondition.fromSiteIds = [];
        state.searchCondition.fromYyyymmdd = from;
        state.searchCondition.toYyyymmdd = to;
      }),
    initPeriodDefault: () =>
      set(state => {
        const { from, to } = defaultPeriod();
        state.searchCondition.fromYyyymmdd = from;
        state.searchCondition.toYyyymmdd = to;
      }),
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        // GET SP P_SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL 파라미터 9종 (design 03 §4, cs:420-428):
        //   p_division_id / p_from_site / p_item_id / p_from_yyyymmdd / p_to_yyyymmdd /
        //   p_Sold_To_Party / p_Ship_To_Party / debug_mode='F' / p_language(@sesLangCd 세션)
        const language = useSessionStore.getState().session.langCd ?? '';
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: joinOrEmpty(c.divisionIds),
            fromSite: joinOrEmpty(c.fromSiteIds),
            itemId: multiLine(c.itemId),
            fromYyyymmdd: c.fromYyyymmdd,
            toYyyymmdd: c.toYyyymmdd,
            soldToParty: c.soldToParty,
            shipToParty: c.shipToParty,
            debugMode: 'F',
            language,
          },
        };
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
    setDivisionAuth: has =>
      set(state => {
        state.hasDivisionAuth = has;
      }),

    fetchStaticColumns: async () => {
      // 단일 시트 컬럼메타 fetch (design 03 §4). 미등록/실패 시 빈 배열 유지(그리드 공백).
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] }
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
        // 미등록/실패 = 빈 배열(console 금지 룰)
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'shipment-plan-confirm-detail-store'
);
