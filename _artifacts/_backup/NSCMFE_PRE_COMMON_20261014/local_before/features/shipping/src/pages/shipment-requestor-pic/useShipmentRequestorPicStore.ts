import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './shipment-requestor-pic.constants';
import type { SearchCondition } from './shipment-requestor-pic.types';

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
  // ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch. 미등록/실패 시 빈 배열
  //   -> 그리드가 constants MAIN_COLUMNS fallback. 실측: SSP0025 컬럼메타 19행 배포됨(design 03 §0).
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
  // 기본 사업부 = 세션 division. AS-IS 는 MyDivision 콤보 기본선택(명시 SelectedIndex 없음, design 02 §4).
  divisionId: useSessionStore.getState().session.div ?? '',
  plantSiteIds: [],
  itemId: '',
  nickName: '',
  modelId: '',
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

// 다건 텍스트(개행/콤마) -> 콤마 join. GET SP P_ITEM_ID/P_MODEL_ID 콤마 IN (design 02 §4 / 07 보완2 정정: 구분자 콤마).
const multi = (v: string): string =>
  v
    ? v
        .split(/[\n,]/)
        .map(s => s.trim())
        .filter(Boolean)
        .join(',')
    : '';

// 다중 체크값 -> 콤마 join. GET SP P_PLANT_SITE 콤마 IN (07 보완2 — plant_site 도 String_Split(',') 콤마).
const joinOrEmpty = (arr: string[]): string => (arr.length === 0 ? '' : arr.join(','));
const trimOrEmpty = (v: string): string => (v && v.trim() ? v.trim() : '');

export const useShipmentRequestorPicStore = createPersistedStoreWithTab<State & Action>(
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
        // GET SP P_SSP0025_GET_SHIPMENT_REQUESTOR_PIC 파라미터 (design 02 §5 / 03 §4.2, 07 보완2):
        //   p_division_id(필수 단일) / p_plant_site(콤마 다건) / p_item_id(콤마 다건) /
        //   p_nick_name(단일) / p_model_id(콤마 다건) / p_language(세션 @sesLangCd 자동, FE 미전달).
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: c.divisionId,
            plantSite: joinOrEmpty(c.plantSiteIds),
            itemId: multi(c.itemId),
            nickName: trimOrEmpty(c.nickName),
            modelId: multi(c.modelId),
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

    // admin SCM_MST_SHEET_COLUMNS 동적 fetch — 미등록/실패 시 빈 배열 유지(그리드 constants fallback, console 금지).
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
        // 미등록/실패 = constants fallback
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'shipment-requestor-pic-store'
);
