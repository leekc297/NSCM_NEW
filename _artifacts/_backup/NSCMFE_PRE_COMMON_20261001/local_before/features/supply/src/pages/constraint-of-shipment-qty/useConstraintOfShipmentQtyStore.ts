import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS, VALID_DEFAULT } from './constraint-of-shipment-qty.constants';
import type { SearchCondition } from './constraint-of-shipment-qty.types';

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
  // ui-dynamic-property-management — admin SCM_MST_SHEET_COLUMNS 동적 fetch(실측 23행 등록됨, design 03 §1).
  staticColumns: StaticColumnsBySheet;
  isEditMode: boolean;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  setEditMode: (edit?: boolean) => void;
}

const initSearch: SearchCondition = {
  divisionId: '',
  planGroupIds: [],
  fromSiteIds: [],
  toSiteIds: [],
  stageIds: [],
  modelGroupIds: [],
  itemId: '',
  fromDate: '',
  toDate: '',
  validYn: VALID_DEFAULT,
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
  isEditMode: false,
};

export const useConstraintOfShipmentQtyStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // GET SP 파라미터 매핑(design 03 §4, SCP0132_GET_CONSTRAINT_OF_SHIPMENT_QTY 10 param):
    //   Division/PlanGroup/FromSite/ToSite/ModelGroupName/Item/Stage/FromDate/ToDate/ValidYn
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: c.divisionId,
            planGroupId: c.planGroupIds.join(','),
            fromSiteId: c.fromSiteIds.join(','),
            toSiteId: c.toSiteIds.join(','),
            modelGroupName: c.modelGroupIds.join(','),
            itemId: c.itemId,
            stage: c.stageIds.join(','),
            fromDate: c.fromDate,
            toDate: c.toDate,
            validYn: c.validYn,
          },
        };
        // 조회 성공 시 편집모드는 항상 해제(design 01 §2#7 — 조회 직후 전체 read-only 재현).
        state.isEditMode = false;
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

    // admin SCM_MST_SHEET_COLUMNS 동적 fetch — 미등록/실패 시 빈 배열 유지(그리드 하드코딩 없음).
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
        // 미등록/실패 = 빈 배열 유지(console 금지 룰)
      }
      set(state => {
        state.initialized = true;
      });
    },

    // EditButton 토글(design 01 §2#4 — gridSignals#3,#4,#5 SwitchLock+LockColumn 2건 조합, 실동작
    //   확정). Division·VAL_TP_CD~PRE_KEY_VALUES 구간은 토글 무관 항상잠금 — editLock.isCellEditable
    //   이 별도로 처리하므로 여기선 편집모드 플래그만 관리한다.
    setEditMode: edit =>
      set(state => {
        state.isEditMode = edit ?? !state.isEditMode;
      }),
  }),
  'constraint-of-shipment-qty-store'
);
