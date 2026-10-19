import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './shipment-request-pack.constants';
import type { ActiveDetailSheet, ActiveGrid, ActiveMainSheet, SearchParamProps } from './shipment-request-pack.types';

/** SCM_MST_SHEET_MEASURE 동적 fetch row — /admin/menu/{MENU_ID}/measure. */
export interface MeasureMeta {
  colNm: string;
  colLblNm?: string;
  display?: boolean;
  personalizable?: boolean;
  sortOrd?: number;
}

type StaticColumnSheet =
  | SHEETS.PACK
  | SHEETS.CELL
  | SHEETS.REQUEST_DETAIL
  | SHEETS.RESULT_DETAIL
  | SHEETS.REQUEST_DETAIL_EXCEL;

interface ShipmentRequestPackState {
  searchParams: SearchParamProps;
  filters?: ProcRequest<MENU_ID, SHEETS.PACK>;
  cellFilters?: ProcRequest<MENU_ID, SHEETS.CELL>;
  requestDetailFilters?: ProcRequest<MENU_ID, SHEETS.REQUEST_DETAIL>;
  resultDetailFilters?: ProcRequest<MENU_ID, SHEETS.RESULT_DETAIL>;
  spreadTitleFilters?: ProcRequest<MENU_ID, SHEETS.SPREAD_TITLE>;
  isOpenSearchArea: boolean;
  staticColumns: Record<StaticColumnSheet, RawFlexGridColumnConfig[]>;
  staticMeasures: Record<SHEETS.PACK | SHEETS.CELL, MeasureMeta[]>;
  activeMainSheet: ActiveMainSheet; // Pack Biz ↔ Cell Biz(design 01 R14)
  activeDetailSheet: ActiveDetailSheet; // Request ↔ Result Detail(design 01 R15)
  activeGrid: ActiveGrid;
}

interface ShipmentRequestPackAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilters: () => boolean;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setActiveMainSheet: (sheet: ActiveMainSheet) => void;
  setActiveDetailSheet: (sheet: ActiveDetailSheet) => void;
  setActiveGrid: (grid: ActiveGrid) => void;
  fetchStaticColumns: () => void;
  fetchStaticMeasures: () => void;
}

// 세션 스코프 함수(모듈 상수 아님) — division 등 세션값을 스토어 생성 시점에 읽어야 재로그인 시 얼어붙지 않는다.
const makeInitSearchParams = (): SearchParamProps => ({
  divisionId: '40', // R2 — 항상 "40" 고정, Enabled=false(design 02 §2.1)
  teamIds: [],
  endCustomerIds: [],
  salesSiteIds: [],
  plantSiteIds: [],
  bucketType: 'Daily', // OnShown() 강제값(design 02 §4.1)
  fromYyyymmdd: '',
  toYyyymmdd: '',
  projectCode: '',
  modelId: '',
  fromYyyymmdd2: '',
  toYyyymmdd2: '',
  modelId2: '',
  nickName2: '',
  lotId: '',
  requestor: '',
});

const makeInitState = (): ShipmentRequestPackState => ({
  searchParams: makeInitSearchParams(),
  isOpenSearchArea: true,
  staticColumns: {
    [SHEETS.PACK]: [],
    [SHEETS.CELL]: [],
    [SHEETS.REQUEST_DETAIL]: [],
    [SHEETS.RESULT_DETAIL]: [],
    [SHEETS.REQUEST_DETAIL_EXCEL]: [],
  },
  staticMeasures: {
    [SHEETS.PACK]: [],
    [SHEETS.CELL]: [],
  },
  activeMainSheet: 'pack',
  activeDetailSheet: 'requestDetail',
  activeGrid: null,
});

const joinComma = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join(','));

export const useShipmentRequestPackStore = createPersistedStoreWithTab<
  ShipmentRequestPackState & ShipmentRequestPackAction
>(
  (set, get) => ({
    ...makeInitState(),
    reset: () => set(makeInitState()),
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    setActiveMainSheet: sheet => {
      set(state => {
        state.activeMainSheet = sheet;
      });
    },
    setActiveDetailSheet: sheet => {
      set(state => {
        state.activeDetailSheet = sheet;
      });
    },
    setActiveGrid: grid => {
      set(state => {
        state.activeGrid = grid;
      });
    },
    // AS-IS FindData/FindData_Detail 파라미터 조립(design 02 §2/§5). 메인 그리드 조회 SP(PACK/CELL)
    //   2건이 미배포(goal.md ②)라 필터 셋만 정확히 재현하고 실제 커서 반환은 확인하지 못했다.
    setFilters: () => {
      const sesUserId = useSessionStore.getState().session.userId ?? '';
      const sp: SearchParamProps = { ...makeInitSearchParams(), ...get().searchParams };

      const common = {
        divisionId: sp.divisionId,
        teamIds: joinComma(sp.teamIds),
        endCustomerIds: joinComma(sp.endCustomerIds),
        salesSiteIds: joinComma(sp.salesSiteIds),
        plantSiteIds: joinComma(sp.plantSiteIds),
        bucketType: sp.bucketType,
        fromYyyymmdd: sp.fromYyyymmdd,
        toYyyymmdd: sp.toYyyymmdd,
        projectCode: sp.projectCode,
        modelId: sp.modelId,
        sesUserId,
        mnuId: MENU_ID,
      };
      const newFilters: ProcRequest<MENU_ID, SHEETS.PACK> = common;
      const newCellFilters: ProcRequest<MENU_ID, SHEETS.CELL> = common;
      const newRequestDetailFilters: ProcRequest<MENU_ID, SHEETS.REQUEST_DETAIL> = {
        divisionId: sp.divisionId,
        fromYyyymmdd: sp.fromYyyymmdd2,
        toYyyymmdd: sp.toYyyymmdd2,
        modelId: sp.modelId2,
        nickName: sp.nickName2,
        lotId: sp.lotId, // §2.9 dead parameter — SP 파라미터 목록에 없음, AS-IS 그대로 전달만 유지
        requestorName: sp.requestor,
        sesUserId,
        mnuId: MENU_ID,
      };
      const newResultDetailFilters: ProcRequest<MENU_ID, SHEETS.RESULT_DETAIL> = {
        divisionId: sp.divisionId,
        fromYyyymmdd: sp.fromYyyymmdd2,
        toYyyymmdd: sp.toYyyymmdd2,
        modelId: sp.modelId2,
        nickName: sp.nickName2,
        sesUserId,
        mnuId: MENU_ID,
      };
      const newSpreadTitleFilters: ProcRequest<MENU_ID, SHEETS.SPREAD_TITLE> = {
        fromYyyymmdd: sp.fromYyyymmdd,
        toYyyymmdd: sp.toYyyymmdd,
        sesUserId,
        sheetName: ADMIN_SHEET_NAME[get().activeMainSheet === 'cell' ? SHEETS.CELL : SHEETS.PACK],
        divisionId: sp.divisionId,
      };

      const isSame =
        JSON.stringify(get().filters) === JSON.stringify(newFilters) &&
        JSON.stringify(get().cellFilters) === JSON.stringify(newCellFilters) &&
        JSON.stringify(get().requestDetailFilters) === JSON.stringify(newRequestDetailFilters) &&
        JSON.stringify(get().resultDetailFilters) === JSON.stringify(newResultDetailFilters) &&
        JSON.stringify(get().spreadTitleFilters) === JSON.stringify(newSpreadTitleFilters);

      set(state => {
        state.filters = newFilters;
        state.cellFilters = newCellFilters;
        state.requestDetailFilters = newRequestDetailFilters;
        state.resultDetailFilters = newResultDetailFilters;
        state.spreadTitleFilters = newSpreadTitleFilters;
      });
      return isSame;
    },
    // Division 은 고정값이라 재선택 트리거는 없으나, 화면 재진입/그리드 탭 전환 시 전 시트
    //   filters 무효화(nscm-patterns.md §5-5 준용).
    clearFilters: () => {
      set(state => {
        state.filters = undefined;
        state.cellFilters = undefined;
        state.requestDetailFilters = undefined;
        state.resultDetailFilters = undefined;
        state.spreadTitleFilters = undefined;
      });
    },
    fetchStaticColumns: () => {
      void (async () => {
        const sheetNames: [StaticColumnSheet, string][] = [
          [SHEETS.PACK, ADMIN_SHEET_NAME[SHEETS.PACK]],
          [SHEETS.CELL, ADMIN_SHEET_NAME[SHEETS.CELL]],
          [SHEETS.REQUEST_DETAIL, ADMIN_SHEET_NAME[SHEETS.REQUEST_DETAIL]],
          [SHEETS.RESULT_DETAIL, ADMIN_SHEET_NAME[SHEETS.RESULT_DETAIL]],
          [SHEETS.REQUEST_DETAIL_EXCEL, ADMIN_SHEET_NAME[SHEETS.REQUEST_DETAIL_EXCEL]],
        ];
        for (const [sheet, sheetNm] of sheetNames) {
          try {
            const result = await apiClient.post<RawFlexGridColumnConfig[]>(
              `/admin/menu/${MENU_ID}/column`,
              { sheetNm, divisionId: get().searchParams.divisionId }
            );
            set(state => {
              state.staticColumns = { ...state.staticColumns, [sheet]: result.data.result ?? [] };
            });
          } catch {
            /* 메타 미적재 시 빈 배열 유지 — 화면은 fallback 없이 메타 주도 */
          }
        }
      })();
    },
    fetchStaticMeasures: () => {
      void (async () => {
        for (const sheet of [SHEETS.PACK, SHEETS.CELL] as const) {
          try {
            const result = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
              sheetNm: ADMIN_SHEET_NAME[sheet],
              divisionId: get().searchParams.divisionId,
            });
            set(state => {
              state.staticMeasures = { ...state.staticMeasures, [sheet]: result.data.result ?? [] };
            });
          } catch {
            /* SCM_MST_SHEET_MEASURE 8/10종 등록 확인(실측) — 실패 시 빈 배열 */
          }
        }
      })();
    },
  }),
  'shipment-request-pack'
);
