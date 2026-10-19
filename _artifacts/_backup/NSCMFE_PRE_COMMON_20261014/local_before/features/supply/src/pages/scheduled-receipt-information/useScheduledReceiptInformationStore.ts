import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { COLUMN_SHEET_NAME, MENU_ID, SHEETS } from './scheduled-receipt-information.constants';
import type { SearchCondition } from './scheduled-receipt-information.types';
import { thisWeekMonday } from './utils/scheduledReceiptInformationDate';

type FiltersBySheet = {
  [key in SHEETS]?: ProcRequest<MENU_ID, key>;
};

interface ScheduledReceiptInformationState {
  initialized: boolean;
  isOpenSearchArea: boolean;
  searchParams: SearchCondition;
  filters: FiltersBySheet;
  staticColumns: {
    [key in SHEETS]: RawFlexGridColumnConfig[];
  };
}

interface ScheduledReceiptInformationAction {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (searchParams: Partial<SearchCondition>) => void;
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const initSearchParams: SearchCondition = {
  divisionId: '',
  planGroupIds: 'ALL',
  siteIds: 'ALL',
  childMaterialIds: 'ALL',
  valid: 'All',
  fromDate: thisWeekMonday(),
  itemId: '',
};

const initState: ScheduledReceiptInformationState = {
  initialized: false,
  isOpenSearchArea: true,
  searchParams: initSearchParams,
  filters: {},
  staticColumns: {
    [SHEETS.VIRTUAL_BOM]: [],
    [SHEETS.SCHEDULED_RECEIPT]: [],
  },
};

export const useScheduledReceiptInformationStore = createPersistedStoreWithTab<
  ScheduledReceiptInformationState & ScheduledReceiptInformationAction
>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    // Division 변경 시 하위 조건(PlanGroup/Site/ChildMaterial) 초기화 — design 02 §3 cascade
    //   필터방식(재조회 아님, 클라 필터만). 그리드/조회 재실행은 Search 버튼으로만.
    setSearchParams: searchParams => {
      set(state => {
        const next = { ...get().searchParams, ...searchParams };
        if (
          searchParams.divisionId !== undefined &&
          searchParams.divisionId !== get().searchParams.divisionId
        ) {
          next.planGroupIds = 'ALL';
          next.siteIds = 'ALL';
          next.childMaterialIds = 'ALL';
        }
        state.searchParams = next;
      });
    },
    // SP 파라미터(design 03 §4 spCalls#2, GET_VIRTUAL_BOM 7파라미터) — 두 시트가 동일 조회조건을
    //   공유한다(design 02 §1 comboCalls/spCalls 근거, 시트별 별도 조회조건 없음).
    setFilters: () => {
      set(state => {
        const { divisionId, planGroupIds, siteIds, childMaterialIds, valid, fromDate, itemId } =
          state.searchParams;
        const payload = {
          divisionId,
          planGroupId: planGroupIds === 'ALL' ? '' : planGroupIds,
          siteId: siteIds === 'ALL' ? '' : siteIds,
          itemIdChild: childMaterialIds === 'ALL' ? '' : childMaterialIds,
          validYn: valid === 'All' ? '' : valid,
          fromDate,
          itemId,
        };
        state.filters = {
          [SHEETS.VIRTUAL_BOM]: payload,
          [SHEETS.SCHEDULED_RECEIPT]: payload,
        };
      });
    },
    // 컬럼 메타는 admin(SCM_MST_SHEET_COLUMNS)에서 동적 fetch — 하드코딩 금지(CLAUDE.md §2).
    //   sheetNm 은 DB SHEET_NAME 원문(공백 포함, design 03 §1 DB 실측)을 그대로 쓴다.
    fetchStaticColumns: async () => {
      const fetchColumns = (sheet: SHEETS) =>
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: COLUMN_SHEET_NAME[sheet],
        });
      const [virtualBom, scheduledReceipt] = await Promise.all([
        fetchColumns(SHEETS.VIRTUAL_BOM),
        fetchColumns(SHEETS.SCHEDULED_RECEIPT),
      ]);
      set(state => {
        state.staticColumns = {
          [SHEETS.VIRTUAL_BOM]: virtualBom.data.result,
          [SHEETS.SCHEDULED_RECEIPT]: scheduledReceipt.data.result,
        };
        state.initialized = true;
      });
    },
  }),
  'scheduled-receipt-information'
);
