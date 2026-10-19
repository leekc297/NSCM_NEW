import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  BUCKET_TYPE,
  MENU_ID,
  PERIOD3_FROM_OFFSET,
  PERIOD3_TO_OFFSET,
  PROGRAM_ID,
  SHEETS,
} from './shipment-plan-auto-ess.constants';
import type { ActiveGrid, SearchCondition } from './shipment-plan-auto-ess.types';
import {
  fieldSetOf,
  INITIAL_FIELDSET,
  type DetailFieldSet,
} from './utils/shipment-plan-auto-ess.detailSheets';
import { clampPeriod2 } from './utils/shipment-plan-auto-ess.editLock';

type FiltersBySheet = {
  [S in SHEETS]?: ProcRequest<MENU_ID, S>;
};

type StaticColumnsBySheet = Partial<Record<SHEETS, RawFlexGridColumnConfig[]>>;

// SCM_MST_SHEET_MEASURE 동적 fetch row — /admin/menu/{MENU_ID}/measure (camelCase, ForecastPrice 선례 1:1).
//   주의: BE GridMeasure DTO 는 display/personalizable 를 boolean 으로 직렬화한다(string 'Y'/'N' 오선언 금지).
export interface MeasureMeta {
  colNm: string;
  colLblNm?: string;
  sClsLblNm?: string;
  display?: boolean;
  personalizable?: boolean;
  sortOrd?: number;
}

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // bRealFlag — cboPlanDate index0(최신 Plan) 선택 여부. Edit/Simulation 가드 재사용 (design 01 R9).
  realFlag: boolean;
  // fps 활성 그리드 (01 R5) — 저장 라우팅·Measure 팝업 게이트에만 사용.
  activeGrid: ActiveGrid;
  // Detail 활성 sheet + 2차 조회조건 필드셋 (01 R3 — HoldStock 은 직전 유지)
  activeDetailSheet: SHEETS;
  detailFieldSet: DetailFieldSet;
  staticColumns: StaticColumnsBySheet;
  // SCM_MST_SHEET_MEASURE(SSP0021 'Shipment Plan') 동적 fetch — PIVOT measure 세로축 표시/개인화 원천
  //   (CLAUDE.md §2 체크3). Main 그리드가 display 플래그로 measure 행 노출을 가른다.
  staticMeasures: MeasureMeta[];
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  // cascade (design 02 §3): Division 변경 → Company 이하 초기화
  setDivision: (divisionId: string) => void;
  // Company 변경 → FromSite/PlanDate 재조회 + 텍스트류 clear (design 02 §3)
  setCompany: (companyId: string) => void;
  // PlanDate 선택 → drpPeriod/drpPeriod2 파생 + realFlag (design 02 §3/§4)
  setPlanDate: (code: string, fromDate: string, toDate1: string, isLatest: boolean) => void;
  // drpPeriod2 — 범위 이탈 시 무메시지 clamp (buttonGuard #37)
  setPeriod2: (from: string, to: string) => void;
  setActiveGrid: (grid: ActiveGrid) => void;
  setActiveDetailSheet: (sheet: SHEETS) => void;
  setMainFilters: () => void;
  // overrides: Main 드릴다운(dblFlag='Y') 시 클릭 행의 item/fromSite 로 좁힘 (design 03 §3.7)
  setDetailFilter: (
    sheet: SHEETS,
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
  plantSiteIds: [],
  model: '',
  bucketType: BUCKET_TYPE.DAILY,
  chkSum: false,
  planDate: '',
  periodFrom: '',
  periodTo: '',
  period2From: '',
  period2To: '',
  itemId: '',
  requestorId: '',
  requestorName: '',
  resultTypes: [],
  period3From: dayjs().add(PERIOD3_FROM_OFFSET, 'day').format('YYYYMMDD'),
  period3To: dayjs().add(PERIOD3_TO_OFFSET, 'day').format('YYYYMMDD'),
  boxId: '',
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

const joinOrEmpty = (arr: string[]): string => (arr.length === 0 ? '' : arr.join(','));
// 개행/콤마 다건 → 콤마 join (AS-IS UsrMultiLineEditor .Text)
const multiLine = (v: string): string =>
  v
    ? v
        .split(/[\n,]/)
        .map(s => s.trim())
        .filter(Boolean)
        .join(',')
    : '';

export const useShipmentPlanAutoEssStore = createPersistedStoreWithTab<State & Action>(
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
        c.companyId = '';
        c.plantSiteIds = [];
        c.planDate = '';
        c.periodFrom = '';
        c.periodTo = '';
        c.period2From = '';
        c.period2To = '';
        state.realFlag = false;
        // Division 변경 = 그리드 초기화 의무 (np §5-5 / hook #5) — filters 를 비워 잔존 데이터 제거.
        state.filters = {};
      }),

    setCompany: companyId =>
      set(state => {
        const c = state.searchCondition;
        c.companyId = companyId;
        c.plantSiteIds = [];
        c.planDate = '';
        c.periodFrom = '';
        c.periodTo = '';
        c.period2From = '';
        c.period2To = '';
        c.itemId = '';
        c.model = '';
        c.requestorId = '';
        c.requestorName = '';
        state.realFlag = false;
        state.filters = {};
      }),

    setPlanDate: (code, fromDate, toDate1, isLatest) =>
      set(state => {
        const c = state.searchCondition;
        c.planDate = code;
        c.periodFrom = fromDate;
        c.periodTo = toDate1;
        // drpPeriod2 초기값 = drpPeriod 와 동일 (AS-IS L7240 등가)
        c.period2From = fromDate;
        c.period2To = toDate1;
        state.realFlag = isLatest;
      }),

    setPeriod2: (from, to) =>
      set(state => {
        const c = state.searchCondition;
        const clamped = clampPeriod2(from, to, c.periodFrom, c.periodTo);
        c.period2From = clamped.from;
        c.period2To = clamped.to;
      }),

    setActiveGrid: grid =>
      set(state => {
        state.activeGrid = grid;
      }),

    setActiveDetailSheet: sheet =>
      set(state => {
        state.activeDetailSheet = sheet;
        // R3 — HoldStock 는 매핑이 없어 직전 필드셋 유지
        state.detailFieldSet = fieldSetOf(sheet, state.detailFieldSet);
      }),

    setMainFilters: () => {
      set(state => {
        const c = state.searchCondition;
        const session = useSessionStore.getState().session;
        // P_SSP0021_GET_SHIPMENT_PLAN 11 IN (ALL_ARGUMENTS 실측 순서 — Product Level 없음)
        state.filters[SHEETS.MAIN] = {
          divisionId: c.divisionId, // 1 P_DIVISION_ID
          companyId: c.companyId, // 2 P_COMPANY_ID
          fromSite: joinOrEmpty(c.plantSiteIds), // 3 P_FROM_SITE
          planStartYyyymmdd: c.planDate, // 4 P_PLAN_START_YYYYMMDD
          fromYyyymmdd: c.periodFrom, // 5 P_FROM_YYYYMMDD (drpPeriod — PlanDate 파생)
          toYyyymmdd: c.periodTo, // 6 P_TO_YYYYMMDD
          itemId: multiLine(c.itemId), // 7 P_ITEM_ID (1차 Model = txtItemId)
          userId: session.userId ?? '', // 8 P_USER_ID
          programId: PROGRAM_ID, // 9 P_PROGRAM_ID
          sheetName: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? '', // 10 P_SHEET_NAME
          realFlag: state.realFlag ? 'Y' : 'N', // 11 P_REAL_FLAG
        };
        // 3단 헤더 캘린더 — 조회기간과 동일 구간 (design 03 §2.1)
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
        // 공통 IN (stock/owms/mes/planDetail — Product Level 없음)
        const common = {
          divisionId: c.divisionId,
          companyId: c.companyId,
          fromSite: overrides?.fromSite ?? joinOrEmpty(c.plantSiteIds),
          // 2차 Model = txtModel2. 드릴다운은 클릭 행 ITEM_ID 로 좁힘.
          itemId: overrides?.itemId ?? multiLine(c.model),
          planStartYyyymmdd: c.planDate,
          dblFlag,
          language,
          programId: PROGRAM_ID,
          sheetName: ADMIN_SHEET_NAME[sheet] ?? '',
          debugMode: 'F',
        };
        if (sheet === SHEETS.PLAN_DETAIL) {
          // P_SSP0021_GET_SHIPMENT_PLAN_DETAIL 14 IN
          state.filters[SHEETS.PLAN_DETAIL] = {
            divisionId: c.divisionId, // 1
            companyId: c.companyId, // 2
            fromSite: overrides?.fromSite ?? joinOrEmpty(c.plantSiteIds), // 3
            itemId: overrides?.itemId ?? multiLine(c.model), // 4
            requestor: c.requestorId, // 5 P_REQUESTOR
            planStartYyyymmdd: c.planDate, // 6
            fromYyyymmdd: c.period2From, // 7 P_FROM_YYYYMMDD (drpPeriod2 — Shipment Date)
            toYyyymmdd: c.period2To, // 8 P_TO_YYYYMMDD
            dblFlag, // 9 P_DBL_FLAG
            realFlag: state.realFlag ? 'Y' : 'N', // 10 P_REAL_FLAG
            language, // 11
            programId: PROGRAM_ID, // 12
            sheetName: ADMIN_SHEET_NAME[sheet] ?? '', // 13
            debugMode: 'F', // 14
          };
        } else if (sheet === SHEETS.HOLD_STOCK) {
          // P_SSP0021_GET_HOLD_STOCK 9 IN (Product Level 없음)
          state.filters[SHEETS.HOLD_STOCK] = {
            divisionId: c.divisionId, // 1
            fromSite: overrides?.fromSite ?? joinOrEmpty(c.plantSiteIds), // 2
            itemId: overrides?.itemId ?? multiLine(c.model), // 3
            planStartYyyymmdd: c.planDate, // 4
            planType: '', // 5 P_PLAN_TYPE (AS-IS 미지정 공백)
            seq: '', // 6 P_SEQ
            language, // 7
            searchYn: dblFlag === 'Y' ? 'N' : 'Y', // 8 P_SEARCH_YN (드릴다운=행 한정)
            userId, // 9
          };
        } else if (sheet === SHEETS.SHIPMENT_RESULT) {
          // P_SSP0021_GET_SHIPMENT_RESULT 15 IN
          state.filters[SHEETS.SHIPMENT_RESULT] = {
            divisionId: c.divisionId, // 1
            fromSite: overrides?.fromSite ?? joinOrEmpty(c.plantSiteIds), // 2
            itemId: overrides?.itemId ?? multiLine(c.model), // 3
            fromYyyymmdd: c.period3From, // 4 (drpPeriod3 — Shipment Date)
            toYyyymmdd: c.period3To, // 5
            type: joinOrEmpty(c.resultTypes), // 6 P_TYPE (Result Type 다중)
            userId, // 7
            companyId: c.companyId, // 8
            mymodelchk: 'N', // 9~13 — 체크박스 미노출(SSP0021 화면엔 없음) 기본 N/Y
            partleaderchk: 'N', // 10
            teamleaderchk: 'N', // 11
            delegateechk: 'N', // 12
            nonchk: 'Y', // 13
            realFlag: state.realFlag ? 'Y' : 'N', // 14
            planStartYyyymmdd: c.planDate, // 15
          };
        } else if (sheet === SHEETS.MES_STOCK_DETAIL) {
          // P_SSP0021_GET_MES_STOCK_DETAIL 11 IN (+ boxId)
          state.filters[SHEETS.MES_STOCK_DETAIL] = {
            divisionId: common.divisionId, // 1
            companyId: common.companyId, // 2
            fromSite: common.fromSite, // 3
            itemId: common.itemId, // 4
            boxId: multiLine(c.boxId), // 5 P_BOX_ID
            planStartYyyymmdd: common.planStartYyyymmdd, // 6
            dblFlag, // 7
            language, // 8
            programId: PROGRAM_ID, // 9
            sheetName: ADMIN_SHEET_NAME[sheet] ?? '', // 10
            debugMode: 'F', // 11
          };
        } else if (
          sheet === SHEETS.STOCK_DETAIL ||
          sheet === SHEETS.OWMS_DETAIL ||
          sheet === SHEETS.MES_STOCK
        ) {
          // P_SSP0021_GET_STOCK_LOCATION_DETAIL / _OWMS_DETAIL / _MES_STOCK 공통 10 IN
          state.filters[sheet] = { ...common };
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
      // admin SCM_MST_SHEET_COLUMNS fetch (mount + Search — ui-dynamic-property-management).
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
      // SCM_MST_SHEET_MEASURE('Shipment Plan') 동적 fetch — measure 9행(design 03 §1.2). 실패 시 빈 배열
      //   (console 금지 룰 — 메타 미등록/실패면 Main 그리드가 전 measure 노출 fallback).
      try {
        const res = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
          sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? '',
        });
        set(state => {
          state.staticMeasures = res.data.result ?? [];
        });
      } catch {
        // 미등록/실패 = 빈 배열 유지
      }
    },
  }),
  'shipment-plan-auto-ess-store'
);
