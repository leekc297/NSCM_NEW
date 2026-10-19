import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  BOH_RADIO,
  BUCKET_TYPE,
  MENU_ID,
  PROGRAM_ID,
  SHEETS,
} from './shipment-plan-electrode.constants';
import type { ActiveGrid, DetailFieldSet, DetailSheet, SearchCondition } from './shipment-plan-electrode.types';

type FiltersBySheet = {
  [S in SHEETS]?: ProcRequest<MENU_ID, S>;
};

type StaticColumnsBySheet = Partial<Record<SHEETS, RawFlexGridColumnConfig[]>>;
type StaticMeasures = RawFlexGridColumnConfig[];

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // bRealFlag (AS-IS L7261~) — cboPlanDate index0(최신 Plan) 선택 여부. Edit/Simulation 가드 재사용.
  realFlag: boolean;
  // fps sticky 활성 그리드 (01 R5) — 초기 'main', Detail 셀 클릭(잠금해제)에서만 'detail'.
  activeGrid: ActiveGrid;
  // 하단 detail 활성 sheet (shtPlanDetail/StockDetail/ShipmentResult 전환)
  activeDetailSheet: DetailSheet;
  detailFieldSet: DetailFieldSet;
  staticColumns: StaticColumnsBySheet;
  // 측정치 pivot 11 (SCM_MST_SHEET_MEASURE) — btnMeasure 커스터마이즈 대상 (03 §1.8)
  staticMeasures: StaticMeasures;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  // cascade (design 02 §3): Division 변경 → Company 이하 초기화 (하위 콤보는 재조회 방식)
  setDivision: (divisionId: string) => void;
  // Company 변경 → FromSite/PlanDate 초기화 (02 §3)
  setCompany: (companyId: string) => void;
  // PlanDate 선택 → drpPeriod 파생 + realFlag (AS-IS L7232~7268)
  setPlanDate: (code: string, fromDate: string, toDate: string, isLatest: boolean) => void;
  // BOH 3-radio — 표시 BOH 3칸 + 활성 기간 span prefix 동시 선택 (03 §2.1/§2.2)
  setBohRadio: (radio: BOH_RADIO) => void;
  setBucketType: (bucketType: BUCKET_TYPE) => void;
  setChkSum: (checked: boolean) => void;
  setChkPastPeriod: (checked: boolean) => void;
  setActiveGrid: (grid: ActiveGrid) => void;
  setActiveDetailSheet: (sheet: DetailSheet) => void;
  setMainFilters: () => void;
  // overrides: Main 드릴다운(P_DBL_FLAG='Y') 시 클릭 행의 item/fromSite 로 좁힘 (03 §3-D)
  setDetailFilter: (
    sheet: DetailSheet,
    dblFlag: 'Y' | 'N',
    overrides?: { itemId?: string; fromSite?: string }
  ) => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: (sheets: SHEETS[]) => Promise<void>;
  fetchStaticMeasures: () => Promise<void>;
}

const initSearch: SearchCondition = {
  divisionId: '',
  companyId: '',
  fromSite: '',
  planDateYyyymmdd: '',
  isLatest: false,
  bucketType: BUCKET_TYPE.DAILY,
  bohRadio: BOH_RADIO.GENERAL,
  resultType: '',
  chkSum: false,
  chkPastPeriod: false,
  periodFrom: '',
  periodTo: '',
};

const INITIAL_FIELDSET: DetailFieldSet = {
  resultType: false,
  shipmentDate: true,
  newButton: true,
};

// 하단 detail sheet 별 2차 조회조건 필드 노출 (03 §0).
const fieldSetOf = (sheet: DetailSheet): DetailFieldSet => {
  switch (sheet) {
    case SHEETS.PLAN_DETAIL:
      return { resultType: false, shipmentDate: true, newButton: true };
    case SHEETS.STOCK_DETAIL:
      return { resultType: false, shipmentDate: false, newButton: false };
    case SHEETS.SHIPMENT_RESULT:
      return { resultType: true, shipmentDate: true, newButton: false };
    default:
      return INITIAL_FIELDSET;
  }
};

const initState: State = {
  initialized: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  realFlag: false,
  activeGrid: 'main',
  activeDetailSheet: SHEETS.PLAN_DETAIL,
  detailFieldSet: INITIAL_FIELDSET,
  staticColumns: {},
  staticMeasures: [],
};

export const useShipmentPlanElectrodeStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),

    setDivision: divisionId =>
      set(state => {
        const c = state.searchCondition;
        c.divisionId = divisionId;
        // Company 는 Form 이 division 필터 결과 첫 행 재선택(02 §3).
        c.companyId = '';
        c.fromSite = '';
        c.planDateYyyymmdd = '';
        c.periodFrom = '';
        c.periodTo = '';
        state.realFlag = false;
        // Division 변경 = 그리드 초기화 의무 (hook #5) — 이전 Division 데이터 잔존 방지.
        //   EditTracker 정리는 페이지 effect(divisionId·companyId 감시)가 수행.
        state.filters = {};
      }),

    setCompany: companyId =>
      set(state => {
        const c = state.searchCondition;
        c.companyId = companyId;
        c.fromSite = '';
        c.planDateYyyymmdd = '';
        c.periodFrom = '';
        c.periodTo = '';
        state.realFlag = false;
        // Company 변경도 조회조건 축이 갈리므로 filters 초기화.
        state.filters = {};
      }),

    setPlanDate: (code, fromDate, toDate, isLatest) =>
      set(state => {
        const c = state.searchCondition;
        c.planDateYyyymmdd = code;
        c.periodFrom = fromDate;
        c.periodTo = toDate;
        state.realFlag = isLatest;
      }),

    setBohRadio: radio =>
      set(state => {
        // 표시 BOH 3칸 + 활성 span prefix 동시 선택. 컬럼 표시규칙만 전환(재조회 없음).
        state.searchCondition.bohRadio = radio;
      }),

    setBucketType: bucketType =>
      set(state => {
        state.searchCondition.bucketType = bucketType;
      }),

    setChkSum: checked =>
      set(state => {
        state.searchCondition.chkSum = checked;
      }),

    setChkPastPeriod: checked =>
      set(state => {
        state.searchCondition.chkPastPeriod = checked;
      }),

    setActiveGrid: grid =>
      set(state => {
        state.activeGrid = grid;
      }),

    setActiveDetailSheet: sheet =>
      set(state => {
        state.activeDetailSheet = sheet;
        state.detailFieldSet = fieldSetOf(sheet);
      }),

    setMainFilters: () => {
      set(state => {
        const c = state.searchCondition;
        const session = useSessionStore.getState().session;
        // PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN (19 IN — PROC_M COL_NM camelCase, ALL_ARGUMENTS 실측 순서).
        state.filters[SHEETS.MAIN] = {
          divisionId: c.divisionId, // 1 P_DIVISION_ID
          companyId: c.companyId, // 2 P_COMPANY_ID
          fromSite: c.fromSite, // 3 P_FROM_SITE
          planStartYyyymmdd: c.planDateYyyymmdd, // 4 P_PLAN_START_YYYYMMDD
          fromYyyymmdd: c.periodFrom, // 5 P_FROM_YYYYMMDD (drpPeriod — PlanDate 파생)
          toYyyymmdd: c.periodTo, // 6 P_TO_YYYYMMDD
          bucketType: c.bucketType, // 7 P_BUCKET_TYPE (DAILY/WEEKLY/MONTHLY)
          userId: session.userId ?? '', // 8 P_USER_ID
          programId: PROGRAM_ID, // 9 P_PROGRAM_ID
          sheetName: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? '', // 10 P_SHEET_NAME
          realFlag: state.realFlag ? 'Y' : 'N', // 11 P_REAL_FLAG
        };
        // 3단 머지헤더 캘린더 (X_/Y_/Z_ × D_/W_/M_) — 조회기간과 동일 구간 (03 §2.2 3SPAN).
        state.filters[SHEETS.CALENDAR] = {
          startYyyymmdd: c.periodFrom,
          endYyyymmdd: c.periodTo,
        };
      });
    },

    setDetailFilter: (sheet, dblFlag, overrides) => {
      set(state => {
        const c = state.searchCondition;
        const session = useSessionStore.getState().session;
        const language = session.langCd ?? '';
        const userId = session.userId ?? '';
        const common = {
          divisionId: c.divisionId,
          companyId: c.companyId,
          fromSite: overrides?.fromSite ?? c.fromSite,
          itemId: overrides?.itemId ?? '',
          planStartYyyymmdd: c.planDateYyyymmdd,
          fromYyyymmdd: c.periodFrom,
          toYyyymmdd: c.periodTo,
          dblFlag,
          language,
          userId,
          programId: PROGRAM_ID,
          sheetName: ADMIN_SHEET_NAME[sheet] ?? '',
          debugMode: 'F',
        };
        if (sheet === SHEETS.PLAN_DETAIL) {
          state.filters[SHEETS.PLAN_DETAIL] = {
            ...common,
            realFlag: state.realFlag ? 'Y' : 'N',
          };
        } else if (sheet === SHEETS.SHIPMENT_RESULT) {
          state.filters[SHEETS.SHIPMENT_RESULT] = {
            ...common,
            type: c.resultType, // Result Type (FE 후필터 R 제외)
            realFlag: state.realFlag ? 'Y' : 'N',
          };
        } else if (sheet === SHEETS.STOCK_DETAIL) {
          state.filters[SHEETS.STOCK_DETAIL] = { ...common };
        }
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

    fetchStaticColumns: async (sheets: SHEETS[]) => {
      // admin SCM_MST_SHEET_COLUMNS fetch (mount + Search — ui-dynamic-property-management §2.3).
      //   시트별 개별 POST — 미등록/실패 시 기존 값 유지(그리드 공백, console 금지 룰).
      for (const sheet of sheets) {
        const sheetNm = ADMIN_SHEET_NAME[sheet];
        if (!sheetNm) continue;
        try {
          const res = await apiClient.post<RawFlexGridColumnConfig[]>(
            `/admin/menu/${MENU_ID}/column`,
            { sheetNm }
          );
          const next = res.data.result ?? [];
          if (next.length > 0) {
            set(state => {
              if (JSON.stringify(state.staticColumns[sheet]) !== JSON.stringify(next)) {
                state.staticColumns[sheet] = next;
              }
            });
          }
        } catch {
          // 미등록/실패 = 기존 값 유지
        }
      }
      set(state => {
        state.initialized = true;
      });
    },

    fetchStaticMeasures: async () => {
      // 측정치 pivot 11 (SCM_MST_SHEET_MEASURE) — btnMeasure 커스터마이즈 원천 (03 §1.8).
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/measure`,
          { sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] }
        );
        const next = res.data.result ?? [];
        if (next.length > 0) {
          set(state => {
            if (JSON.stringify(state.staticMeasures) !== JSON.stringify(next)) {
              state.staticMeasures = next;
            }
          });
        }
      } catch {
        // 미등록/실패 = 기존 값 유지
      }
    },
  }),
  'shipment-plan-electrode-store'
);
