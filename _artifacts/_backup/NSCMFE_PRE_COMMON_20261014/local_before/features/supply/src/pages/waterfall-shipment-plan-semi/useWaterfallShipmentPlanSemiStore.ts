import type { MeasureMeta } from 'features/master/src/components';

import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, BUCKET_TYPE, MENU_ID, SHEETS } from './waterfall-shipment-plan-semi.constants';
import type { SearchParams } from './waterfall-shipment-plan-semi.types';

interface Filters {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.SPREAD_TITLE]?: ProcRequest<MENU_ID, SHEETS.SPREAD_TITLE>;
}

interface WaterfallShipmentPlanSemiState {
  searchParams: SearchParams;
  filters: Filters;
  isOpenSearchArea: boolean;
  staticColumns: RawFlexGridColumnConfig[];
  staticMeasures: MeasureMeta[];
  // 조회 가능 Division 0건 시 조회조건 영역 전체 비활성(01_layout.md §2 트리거C, MSG00097).
  divisionAuthChecked: boolean;
  hasDivisionAuth: boolean;
}

interface WaterfallShipmentPlanSemiAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParams>) => void;
  /** 조회 파라미터 조립 — Bucket/Sum 은 SP 미전달(순수 클라 트리거, §2.4/§3). */
  setFilters: (input: { userId: string }) => boolean;
  /** Division 전환 = 그리드 초기화(§5-5 표준 규약, 이 화면은 조회결과만 비운다 — 편집축 없음). */
  clearData: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchStaticMeasures: (sheetName: string) => Promise<void>;
  setDivisionAuth: (hasAuth: boolean) => void;
}

const initSearchParams: SearchParams = {
  divisionId: '',
  operationGroup: '',
  itemId: '',
  electrodeTypes: [],
  bucket: BUCKET_TYPE.DAILY, // AS-IS DefineProperty — cboBucketType.ControlValues = Daily 고정
  versionNos: [],
  startYyyymmdd: '',
  endYyyymmdd: '',
  isSumChecked: false, // AS-IS chkSum InitValue="N"
};

const initState: WaterfallShipmentPlanSemiState = {
  searchParams: initSearchParams,
  filters: {},
  isOpenSearchArea: true,
  staticColumns: [],
  staticMeasures: [],
  divisionAuthChecked: false,
  hasDivisionAuth: true,
};

/** 다중선택 → SP 파라미터 — 02_search-combo.md §7#4 구분자 확인 필요(콤마로 잠정, AS-IS 확인 대기). */
const joinMulti = (arr: string[]): string => arr.join(',');

export const useWaterfallShipmentPlanSemiStore = createPersistedStoreWithTab<
  WaterfallShipmentPlanSemiState & WaterfallShipmentPlanSemiAction
>(
  (set, _get) => ({
    ...initState,
    reset: () =>
      set(state => {
        state.searchParams = initSearchParams;
        state.filters = {};
        state.isOpenSearchArea = true;
      }),
    setSearchParams: searchParams =>
      set(state => {
        state.searchParams = { ...state.searchParams, ...searchParams };
      }),
    setFilters: ({ userId }) => {
      let changed = false;
      set(state => {
        const p = state.searchParams;
        // p_sheet_name 파생값 — OperationGroup=='A' ? 'CELL' : 'ELECTRODE' (02_search-combo.md §5 말미,
        //   03_grid-columns.md §4.2 — 고정값 전달 금지).
        const sheetName = p.operationGroup === 'A' ? 'CELL' : 'ELECTRODE';
        const newFilters: Filters = {
          [SHEETS.MAIN]: {
            fromYyyymmdd: p.startYyyymmdd,
            toYyyymmdd: p.endYyyymmdd,
            divisionId: p.divisionId,
            operationGroup: p.operationGroup,
            itemId: p.itemId.trim(),
            versionNo: joinMulti(p.versionNos),
            electype: joinMulti(p.electrodeTypes),
            programId: MENU_ID,
            sheetName,
            userId,
          },
          [SHEETS.SPREAD_TITLE]: {
            startYyyymmdd: p.startYyyymmdd,
            endYyyymmdd: p.endYyyymmdd,
            userId,
          },
        };
        if (JSON.stringify(newFilters) !== JSON.stringify(state.filters)) {
          state.filters = newFilters;
          changed = true;
        }
      });
      return changed;
    },
    clearData: () =>
      set(state => {
        state.filters = {};
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      }),
    // 03_grid-columns.md §5#1 — SCM_MST_SHEET_COLUMNS(PROGRAM_ID='SCP0018') 24행, 하드코딩 금지.
    fetchStaticColumns: async () => {
      try {
        const result = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME }
        );
        set(state => {
          state.staticColumns = result.data.result ?? [];
        });
      } catch {
        /* 메타 미적재 시 빈 배열 유지 — 화면은 fallback 없이 메타 주도 */
      }
    },
    // SCM_MST_SHEET_MEASURE — p_sheet_name(CELL/ELECTRODE) 파생값별 다른 측도 셋(03_grid-columns.md §4.3).
    fetchStaticMeasures: async sheetName => {
      try {
        const result = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
          sheetNm: sheetName,
        });
        set(state => {
          state.staticMeasures = result.data.result ?? [];
        });
      } catch {
        /* 미적재 시 빈 배열 유지 — 모달 fallback */
      }
    },
    setDivisionAuth: hasAuth =>
      set(state => {
        state.divisionAuthChecked = true;
        state.hasDivisionAuth = hasAuth;
      }),
  }),
  'waterfall-shipment-plan-semi'
);
