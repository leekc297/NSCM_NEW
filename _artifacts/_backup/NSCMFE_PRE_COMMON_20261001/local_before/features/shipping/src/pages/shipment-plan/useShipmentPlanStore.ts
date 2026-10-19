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
} from './shipment-plan.constants';
import type { ActiveGrid, SearchCondition } from './shipment-plan.types';
import { fieldSetOf, INITIAL_FIELDSET, type DetailFieldSet } from './utils/shipment-plan.detailSheets';
import { clampPeriod2 } from './utils/shipment-plan.editLock';

type FiltersBySheet = {
  [S in SHEETS]?: ProcRequest<MENU_ID, S>;
};

type StaticColumnsBySheet = Partial<Record<SHEETS, RawFlexGridColumnConfig[]>>;

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // bRealFlag (AS-IS L7261~7268) — cboPlanDate index0(최신 Plan) 선택 여부. Edit/Simulation 가드 재사용.
  realFlag: boolean;
  // fps sticky 활성 그리드 (01 R5) — 초기 'main', Detail 셀 클릭(잠금해제)에서만 'detail'.
  //   main 클릭 복귀 핸들러는 추가하지 않는다(AS-IS parity).
  activeGrid: ActiveGrid;
  // Detail 활성 sheet + 2차 조회조건 필드셋 (01 R1 — HoldStock 계열은 직전 유지 R1f)
  activeDetailSheet: SHEETS;
  detailFieldSet: DetailFieldSet;
  staticColumns: StaticColumnsBySheet;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  // cascade (design 02 §3): Division 변경 → Company 이하 초기화 (하위 콤보는 재조회 방식이라 payload 변경으로 재발사)
  setDivision: (divisionId: string) => void;
  // Company 변경 → FromSite/PlanDate/ProductLevel1 초기화 + 텍스트류 clear (AS-IS L7166~7229)
  setCompany: (companyId: string) => void;
  // PlanDate 선택 → drpPeriod/drpPeriod2 파생 + realFlag (AS-IS L7232~7268)
  setPlanDate: (code: string, fromDate: string, toDate1: string, isLatest: boolean) => void;
  // drpPeriod2 — 범위 이탈 시 무메시지 clamp (buttonGuard #37)
  setPeriod2: (from: string, to: string) => void;
  setActiveGrid: (grid: ActiveGrid) => void;
  setActiveDetailSheet: (sheet: SHEETS) => void;
  setMainFilters: () => void;
  // overrides: Main 드릴다운(P_DBL_FLAG='Y') 시 클릭 행의 item/fromSite 로 좁힘 (03 §3-D)
  setDetailFilter: (
    sheet: SHEETS,
    dblFlag: 'Y' | 'N',
    overrides?: { itemId?: string; fromSite?: string }
  ) => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: (sheets: SHEETS[]) => Promise<void>;
}

const initSearch: SearchCondition = {
  divisionId: '',
  companyId: '',
  plantSiteIds: [],
  model: '',
  bucketType: BUCKET_TYPE.DAILY,
  chkSum: false,
  chkTotPsi: false,
  planDate: '',
  periodFrom: '',
  periodTo: '',
  period2From: '',
  period2To: '',
  itemId: '',
  productLevel11: [],
  productLevel12: [],
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

export const useShipmentPlanStore = createPersistedStoreWithTab<State & Action>(
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
        // Company 는 Form 이 division 필터 결과에서 첫 행 재선택(02 §4.1-3 — I7 확인필요 참조).
        c.companyId = '';
        c.plantSiteIds = [];
        c.planDate = '';
        c.periodFrom = '';
        c.periodTo = '';
        c.period2From = '';
        c.period2To = '';
        c.productLevel11 = [];
        c.productLevel12 = [];
        state.realFlag = false;
        // Division 변경 = 그리드 초기화 의무 (np §5-5 / hook #5, gap-audit I9) —
        //   filters 를 비워 이전 Division 데이터가 그리드에 잔존하지 않게 한다.
        //   EditTracker 정리는 페이지 effect(divisionId·companyId 감시)가 수행.
        state.filters = {};
      }),

    setCompany: companyId =>
      set(state => {
        const c = state.searchCondition;
        c.companyId = companyId;
        // AS-IS L7197~7229: PlanDate 재조회 + txtItemId/txtModel2/txtRequestor clear + Period clear.
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
        // Company 변경도 조회조건 축이 갈리므로 동일하게 filters 초기화 (I9)
        state.filters = {};
      }),

    setPlanDate: (code, fromDate, toDate1, isLatest) =>
      set(state => {
        const c = state.searchCondition;
        c.planDate = code;
        c.periodFrom = fromDate;
        c.periodTo = toDate1;
        // drpPeriod2 초기값 = drpPeriod 와 동일 (AS-IS L7240~7243)
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
        // R1/R1a~R1f — HoldStock 계열은 매핑이 없어 직전 필드셋 유지
        state.detailFieldSet = fieldSetOf(sheet, state.detailFieldSet);
      }),

    setMainFilters: () => {
      set(state => {
        const c = state.searchCondition;
        const session = useSessionStore.getState().session;
        // P_SSP0060_GET_SHIPMENT_PLAN 12 IN (ALL_ARGUMENTS 실측 순서 주석 — PROC_M COL_NM camelCase)
        state.filters[SHEETS.MAIN] = {
          divisionId: c.divisionId, // 1 P_DIVISION_ID
          companyId: c.companyId, // 2 P_COMPANY_ID
          fromSite: joinOrEmpty(c.plantSiteIds), // 3 P_FROM_SITE
          planStartYyyymmdd: c.planDate, // 4 P_PLAN_START_YYYYMMDD
          fromYyyymmdd: c.periodFrom, // 5 P_FROM_YYYYMMDD (drpPeriod — PlanDate 파생)
          toYyyymmdd: c.periodTo, // 6 P_TO_YYYYMMDD
          itemId: multiLine(c.itemId), // 7 P_ITEM_ID (1차 Model = txtItemId, 01 §1 좌표 실측)
          productLevel1: joinOrEmpty(c.productLevel11), // 8 P_PRODUCT_LEVEL1
          userId: session.userId ?? '', // 9 P_USER_ID
          programId: PROGRAM_ID, // 10 P_PROGRAM_ID
          sheetName: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? '', // 11 P_SHEET_NAME
          realFlag: state.realFlag ? 'Y' : 'N', // 12 P_REAL_FLAG
        };
        // 3단 헤더 캘린더 — 조회기간과 동일 구간 (03 §4.1)
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
          fromSite: overrides?.fromSite ?? joinOrEmpty(c.plantSiteIds),
          // 2차 Model = txtModel2 (01 §1 좌표 실측). 드릴다운은 클릭 행 ITEM_ID 로 좁힘.
          itemId: overrides?.itemId ?? multiLine(c.model),
          productLevel1: joinOrEmpty(c.productLevel12),
          planStartYyyymmdd: c.planDate,
          dblFlag,
          language,
          programId: PROGRAM_ID,
          sheetName: ADMIN_SHEET_NAME[sheet] ?? '',
          debugMode: 'F',
        };
        if (sheet === SHEETS.PLAN_DETAIL) {
          state.filters[SHEETS.PLAN_DETAIL] = {
            ...common,
            requestor: c.requestorId, // 6 P_REQUESTOR
            toSite: '', // 7 P_TO_SITE (조회조건 없음 — 전체)
            transportMode: '', // 8 P_TRANSPORT_MODE
            incoterms: '', // 9 P_INCOTERMS
            fcstType: '', // 10 P_FCST_TYPE
            fromYyyymmdd: c.period2From, // 12 P_FROM_YYYYMMDD
            toYyyymmdd: c.period2To, // 13 P_TO_YYYYMMDD
            realFlag: state.realFlag ? 'Y' : 'N', // 15 P_REAL_FLAG
          };
        } else if (sheet === SHEETS.HOLD_STOCK) {
          state.filters[SHEETS.HOLD_STOCK] = {
            divisionId: c.divisionId, // 1 P_DIVISION_ID
            fromSite: overrides?.fromSite ?? joinOrEmpty(c.plantSiteIds), // 2 P_FROM_SITE
            itemId: overrides?.itemId ?? multiLine(c.model), // 3 P_ITEM_ID
            productLevel1: joinOrEmpty(c.productLevel12), // 4 P_PRODUCT_LEVEL1
            planStartYyyymmdd: c.planDate, // 5 P_PLAN_START_YYYYMMDD
            planType: '', // 6 P_PLAN_TYPE (AS-IS 미지정 공백)
            seq: '', // 7 P_SEQ
            language, // 8 P_LANGUAGE
            searchYn: dblFlag === 'Y' ? 'N' : 'Y', // 9 P_SEARCH_YN (드릴다운=행 한정)
            userId, // 10 P_USER_ID
          };
        } else if (sheet === SHEETS.SHIPMENT_RESULT) {
          state.filters[SHEETS.SHIPMENT_RESULT] = {
            divisionId: c.divisionId, // 1
            fromSite: overrides?.fromSite ?? joinOrEmpty(c.plantSiteIds), // 2
            itemId: overrides?.itemId ?? multiLine(c.model), // 3
            productLevel1: joinOrEmpty(c.productLevel12), // 4
            fromYyyymmdd: c.period3From, // 5 (drpPeriod3 — Shipment Date)
            toYyyymmdd: c.period3To, // 6
            type: joinOrEmpty(c.resultTypes), // 7 P_TYPE (Result Type 다중)
            userId, // 8
            companyId: c.companyId, // 9
            mymodelchk: 'N', // 10~14 — AS-IS 체크박스 미노출(SSP0060 화면엔 없음) 기본 N
            partleaderchk: 'N',
            teamleaderchk: 'N',
            delegateechk: 'N',
            nonchk: 'Y',
            realFlag: state.realFlag ? 'Y' : 'N', // 15
            planStartYyyymmdd: c.planDate, // 16
          };
        } else if (sheet === SHEETS.MES_STOCK_DETAIL) {
          state.filters[SHEETS.MES_STOCK_DETAIL] = {
            ...common,
            boxId: multiLine(c.boxId), // 6 P_BOX_ID
          };
        } else if (
          sheet === SHEETS.STOCK_DETAIL ||
          sheet === SHEETS.OWMS_DETAIL ||
          sheet === SHEETS.MES_STOCK
        ) {
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
  }),
  'shipment-plan-store'
);
