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
  // 개인화 조회조건(F6 저장분) 복원 1회 가드. initialized 는 컬럼메타 전용이라 분리
  //   (로드 전용 플래그). 형제 화면(shipment-plan-mobility-it) restoreSearchConditions 와 동일 패턴.
  conditionsRestored: boolean;
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
  // F6(개인화 조회조건) 저장분 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchCondition 패치(1회).
  restoreSearchConditions: () => Promise<void>;
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

// F6 복원 역직렬화 키셋. 저장 직렬화(gridAction.personalizeCondition)가 배열을 콤마 join 하므로
//   복원 시 콤마 split 로 되돌린다. 날짜/기간(fromYyyymmdd·toYyyymmdd)은 저장단 EXCLUDED_DATE_PARAM
//   으로 애초에 저장되지 않아 복원 대상이 아니다. 불리언 조회조건은 이 화면에 없다.
const ARRAY_KEYS = new Set<string>(['divisionIds', 'fromSiteIds']);

const initState: State = {
  initialized: false,
  conditionsRestored: false,
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
    // F10(조회조건 초기화): '삭제'(빈값)가 아니라 '기본값 복원'. 공용 resetSearchCondition→reset() 경로가
    //   이 액션을 탄다. initState 는 Period(fromYyyymmdd/toYyyymmdd)가 공백('')이라 그대로 두면 기간이
    //   지워져 Search 가 즉시 MSG00013(필수)으로 막힌다 — AS-IS F10/InitValue=GetDayRange(cs:380) 리셋과
    //   불일치. 그래서 Division/From Site/Model/Sold To/Ship To 는 초기 상수(빈값=기본값)로, Period 만
    //   mount 와 동일한 기본값(오늘~+55영업일)으로 되돌린다.
    reset: () => {
      const { from, to } = defaultPeriod();
      set({
        ...initState,
        searchCondition: { ...initSearch, fromYyyymmdd: from, toYyyymmdd: to },
      });
    },
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
    // F6(개인화 조회조건) 저장분 복원 — 진입/새로고침 시 GET /admin/menu/{MENU_ID}/search-conditions
    //   → PRAM_NM/PRAM_CTN 을 searchCondition 에 역직렬화(1회 가드). 저장분 0건이면 기본값 유지.
    //   날짜/기간축은 저장 제외라 복원 후에도 initPeriodDefault 기본값이 그대로 유지된다.
    restoreSearchConditions: async () => {
      if (get().conditionsRestored) return;
      set(state => {
        state.conditionsRestored = true; // 먼저 세운다(중복/재마운트 재복원 방지)
      });
      try {
        const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        const rows = res.data.result ?? [];
        if (rows.length === 0) return;
        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in initSearch)) continue; // 모르는 키(구버전 잔재) 제외
          const val = paramCtn ?? '';
          if (ARRAY_KEYS.has(paramNm)) patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          else patch[paramNm] = val;
        }
        set(state => {
          state.searchCondition = { ...state.searchCondition, ...patch } as SearchCondition;
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (하드코딩 fallback·console 금지)
      }
    },
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
