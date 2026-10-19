import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './shipment-lot-size.constants';
import type { SearchCondition } from './shipment-lot-size.types';

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
  // ui-dynamic-property-management — admin SCM_MST_SHEET_COLUMNS 동적 fetch(미등록 시 빈 배열 → constants
  //   fallback). design 03 §0: PROGRAM_ID='SCP0028', SHEET_NAME='Shipment Lot Size' 18행 등록 실측(2026-09-26).
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
  divisionId: '', // 첫 권한 사업부로 초기화(Form mount, design 02 §4 line 98)
  operationGroup: 'ALL', // ALL + Pack/Cell/Electrode, 기본 ALL (design 02 §4)
  fromSite: 'ALL', // 다중 ALL (권한 내 전체)
  toSite: 'ALL', // 다중 ALL
  transMode: 'ALL', // 다중 ALL(전체 체크)
  itemId: '', // Model — Item 팝업으로만 채움
  valid: 'ALL', // ALL/Y/N, 기본 ALL (design 02 §4)
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

// 'ALL' sentinel / 공백 -> 빈값 치환 (design 02 §2·§5 — GET SP 파라미터 'ALL'->''/null).
const orEmpty = (v: string): string => {
  const t = (v ?? '').trim();
  return !t || t.toUpperCase() === 'ALL' ? '' : t;
};

export const useShipmentLotSizeStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        const next = { ...get().searchCondition, ...p };
        // cascade(design 02 §3 / convert-core §5-5): Division 변경 = 하위(From/To Site) 선택 reset +
        //   Grid 비움(filters clear → useTabProcQuery 키 변경으로 데이터 커밋 해제). 콤보 재조회는 Form 의
        //   useTabComboQueries divisionId 키가, 편집중 상태(신규 후보·CRUD 추적) 초기화는 Page 의
        //   division 변경 effect 가 담당(G2). 필터 방식 아님(하위 재조회).
        if (p.divisionId !== undefined && p.divisionId !== get().searchCondition.divisionId) {
          next.fromSite = 'ALL';
          next.toSite = 'ALL';
          state.filters = {};
        }
        state.searchCondition = next;
      }),
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        // GET SP PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE 파라미터 매핑(PROC_M COL_NM 실측, IN 순서):
        //   divisionId, operationGroup, fromSite, toSite, transMode, itemId, valid.
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: orEmpty(c.divisionId),
            operationGroup: orEmpty(c.operationGroup),
            fromSite: orEmpty(c.fromSite),
            toSite: orEmpty(c.toSite),
            transMode: orEmpty(c.transMode),
            itemId: (c.itemId ?? '').trim(),
            valid: orEmpty(c.valid), // ALL->'' (BE 가 NULL 치환, design 02 §5)
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
        // 미등록/실패 = constants fallback (console 금지 룰)
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'shipment-lot-size-store'
);
