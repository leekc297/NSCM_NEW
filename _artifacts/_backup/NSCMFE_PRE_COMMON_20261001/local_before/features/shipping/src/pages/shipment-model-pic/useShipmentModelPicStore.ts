import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './shipment-model-pic.constants';
import type { SearchCondition } from './shipment-model-pic.types';

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
  // ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch. 미등록/실패 시
  //   빈 배열 -> 그리드가 constants MAIN_COLUMNS fallback. 실측: SSP0014 컬럼메타 21행 배포됨(design 03 §0).
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

// ALL sentinel — 조회콤보 '전체' 선택값. 서버로는 '' (빈값=무시, GET SP TRIM 로직).
const ALL = 'ALL';

const initSearch: SearchCondition = {
  // 기본 사업부 = 세션 division. AS-IS 는 콤보 첫 항목(명시 기본선택 없음, design 02 §4).
  divisionId: useSessionStore.getState().session.div ?? '',
  operationGroup: ALL,
  fromSiteIds: [],
  validYn: ALL,
  itemId: '',
  userId: '',
};

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.MAIN]: [],
};

const initState: State = {
  initialized: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  staticColumns: emptyStaticColumns,
};

// 다중/단일 값 -> SP 파라미터 문자열. ALL/빈값 = '' (전체). GET SP 는 TRIM 비어있으면 무시.
const joinOrEmpty = (arr: string[]): string => (arr.length === 0 ? '' : arr.join(','));
const oneOrEmpty = (v: string): string => (v && v !== ALL ? v : '');
const trimOrEmpty = (v: string): string => (v && v.trim() ? v.trim() : '');
// Model 멀티라인/콤마 다건 -> 콤마 join (AS-IS txtItemId ^다건, GET SP P_ITEM_ID 콤마 IN).
const multiItem = (v: string): string =>
  v
    ? v
        .split(/[\n,]/)
        .map(s => s.trim())
        .filter(Boolean)
        .join(',')
    : '';

export const useShipmentModelPicStore = createPersistedStoreWithTab<State & Action>(
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
        // GET SP P_SSP0014_GET_MODEL_PIC 파라미터 (design 03 §4 / 00 §4):
        //   P_DIVISION_ID(필수 단일) / P_OPERATION_GROUP(콤마 다건) / P_FROM_SITE(콤마 다건) /
        //   P_VALID_YN(콤마 다건) / P_ITEM_ID(콤마 다건) / P_USER_ID(LIKE) / P_LANGUAGE.
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: c.divisionId,
            operationGroup: oneOrEmpty(c.operationGroup),
            fromSite: joinOrEmpty(c.fromSiteIds),
            validYn: oneOrEmpty(c.validYn),
            itemId: multiItem(c.itemId),
            userId: trimOrEmpty(c.userId),
            language: useSessionStore.getState().session.langCd ?? '',
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
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? SHEETS.MAIN }
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
        // 미등록/실패 = constants fallback (console 금지 룰)
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'shipment-model-pic-store'
);
