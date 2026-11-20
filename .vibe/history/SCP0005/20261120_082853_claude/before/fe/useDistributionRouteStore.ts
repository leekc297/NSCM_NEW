import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './distribution-route.constants';
import type { SearchCondition } from './distribution-route.types';

type FiltersBySheet = {
  [SHEETS.ROUTE]?: ProcRequest<MENU_ID, SHEETS.ROUTE>;
};

type StaticColumnsBySheet = {
  [SHEETS.ROUTE]: RawFlexGridColumnConfig[];
};

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // ui-dynamic-property-management — admin SCM_MST_SHEET_COLUMNS 동적 fetch (미등록 시 빈 배열 →
  //   그리드가 constants 컬럼셋으로 fallback). design 03 §0: PROGRAM_ID=SCP0005, SHEET_NAME='Distribution
  //   Route' 39행(31 'O' + 8 'S') 등록 실측(2026-09-25 ora.py).
  staticColumns: StaticColumnsBySheet;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
}

const initSearch: SearchCondition = {
  fromCountry: '',
  fromCity: '',
  toCountry: '',
  toCity: '',
  transportMode: 'ALL', // clbTransMode 기본 ALL=미선택/전체 (design 02 §4 — NameList="ALL")
  // cboValidYN 기본 = ALL(전체). AS-IS setListBox(dtValidYN, cboValidYN, true, ...) 의 blnAllFlag=true
  //   (CControl.cs:338) 가 ALL 행을 index 0 에 삽입 + DataSource 바인딩 SelectedIndex=0 → 로드 시 ALL.
  //   DMF0004 cboActive 와 동일 패턴. orEmpty 가 'ALL'->''(무필터)로 매핑하므로 p_valid_yn=''.
  validYn: 'ALL',
};

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.ROUTE]: [],
};

const initState: State = {
  initialized: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  staticColumns: emptyStaticColumns,
};

// 'ALL' sentinel / 공백 -> 빈값 치환 (design 02 §2.3/§4 — GET SP 파라미터 'ALL'->'').
const orEmpty = (v: string): string => {
  const t = (v ?? '').trim();
  return !t || t.toUpperCase() === 'ALL' ? '' : t;
};

// F6 저장 조회조건 복원 대상 키 — SearchCondition 필드와 1:1(전부 문자열, 배열 없음).
//   SEARCH_KEYS 밖 paramNm(구버전 잔재)은 버려 SP payload 오염을 막는다.
const SEARCH_KEYS = new Set<string>([
  'fromCountry',
  'fromCity',
  'toCountry',
  'toCity',
  'transportMode',
  'validYn',
]);

export const useDistributionRouteStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        // GET SP SCP.SCP0005_GET_DISTRIBUTION_ROUTE 파라미터 매핑 (design 02 §4 / 03 §4.1 IN 순서):
        //   p_from_country, p_from_city, p_to_country, p_to_city, p_transport_mode, p_valid_yn.
        state.filters = {
          [SHEETS.ROUTE]: {
            fromCountry: orEmpty(c.fromCountry),
            fromCity: orEmpty(c.fromCity),
            toCountry: orEmpty(c.toCountry),
            toCity: orEmpty(c.toCity),
            transportMode: orEmpty(c.transportMode),
            validYn: orEmpty(c.validYn),
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

    // admin SCM_MST_SHEET_COLUMNS 동적 fetch — 미등록/실패 시 빈 배열 유지(그리드 constants fallback).
    //   fetch 키 = ADMIN_SHEET_NAME('Distribution Route') — API 매핑 SHT_NM('route')과 분리(design 03 §6 #1).
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME[SHEETS.ROUTE] }
        );
        const next = res.data.result ?? [];
        if (next.length > 0) {
          set(state => {
            if (JSON.stringify(state.staticColumns[SHEETS.ROUTE]) !== JSON.stringify(next)) {
              state.staticColumns[SHEETS.ROUTE] = next;
            }
          });
        }
      } catch {
        // 미등록/실패 = constants fallback (console 금지 룰)
      }

      // F6 저장 조회조건 복원 — 탭 수명 내 1회(initialized 가드, SSP0014 동형). 이 화면은 기간/달력이
      //   없어 문자열 필드만 복원한다. createPersistedStoreWithTab 은 sessionStorage 미영속이라 전체
      //   새로고침 시 복원이 다시 돈다. F10(초기화)은 MotherStore 가 initialized 를 보존해 재복원 안 됨.
      if (!get().initialized) {
        try {
          const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
            `/admin/menu/${MENU_ID}/search-conditions`
          );
          const rows = res.data.result ?? [];
          if (rows.length > 0) {
            const patch: Record<string, string> = {};
            for (const { paramNm, paramCtn } of rows) {
              if (SEARCH_KEYS.has(paramNm)) patch[paramNm] = paramCtn ?? '';
            }
            set(state => {
              state.searchCondition = {
                ...state.searchCondition,
                ...(patch as Partial<SearchCondition>),
              };
            });
          }
        } catch {
          // 저장조건 미존재/조회 실패 — 기본값 유지 (console 금지 룰)
        }
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'distribution-route-store'
);
