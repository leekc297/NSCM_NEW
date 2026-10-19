import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import type { MeasureMeta } from './components/modals/MeasureSelectModal';
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
  // Measure 축 메타 (SCM_MST_SHEET_MEASURE) — Measure 설정 팝업 목록 원천.
  staticMeasures: MeasureMeta[];
  // 표시 중인 measure 코드(순서 포함). null = 아직 개인화 없음(= 메타 DISPLAY_FLAG 기본).
  //   메인 그리드 행 구성은 서버(PKG_SSP0060 가 titleset 'M' 으로 필터)가 하므로 이 값은
  //   팝업 좌/우 복원용이다 — FE 에서 행을 다시 거르지 않는다.
  visibleMeasures: string[] | null;
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
  fetchStaticMeasures: () => Promise<void>;
  applyVisibleMeasures: (codes: string[] | null) => void;
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

// F6 저장 조회조건(SCM_ADM_USER_MNU_SRCH_COND_M) 복원 시 키 분류.
//   저장(GridAction.personalizeCondition)은 값을 문자열로 coerce 한다(배열=콤마 join / boolean=String).
//   복원은 아래 allowlist(SEARCH_KEYS) 필드만 되돌린다 — SearchCondition 밖/구버전 paramNm 은 버린다.
//   제외: planDate·period* 는 복원하지 않는다. 날짜 필드는 F6 payload 에서 빠지고(EXCLUDED_DATE_PARAM),
//     PlanDate 는 Division→Company cascade 가 재선택하는 파생값이라 복원하면 Period 가 비어 필수조건이
//     깨진다. 대신 복원 직후 planDate/period 를 비워 폼 effect 가 복원된 division/company 기준으로
//     최신 Plan + Period 를 재파생하게 한다(mount 자동선택과 복원의 경합으로 이전 division 의 PlanDate 가
//     남는 것을 막는다).
const SEARCH_KEYS = new Set<string>([
  'divisionId',
  'companyId',
  'plantSiteIds',
  'model',
  'bucketType',
  'chkSum',
  'chkTotPsi',
  'itemId',
  'productLevel11',
  'productLevel12',
  'requestorId',
  'requestorName',
  'resultTypes',
  'boxId',
]);
const ARRAY_KEYS = new Set<string>(['plantSiteIds', 'productLevel11', 'productLevel12', 'resultTypes']);
const BOOL_KEYS = new Set<string>(['chkSum', 'chkTotPsi']);

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
  visibleMeasures: null,
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
        const cur = state.searchCondition;
        // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division·기간/날짜를 제외한 검색조건을 전부 초기화하고
        //   그리드도 초기화한다(commit 51d4e9fa / SCP0025 선례 — TO-BE 공통 요건이 AS-IS 핸들러보다 우선).
        //   종전엔 cascade 축(Company/FromSite/PlanDate/Period/ProductLevel)만 비웠고, 비-cascade 조건
        //   (Bucket/Sum/TotPSI/Model=itemId/Model2=model/Requestor/ResultType)은 이전 Division 값으로 잔존했다 —
        //   공통 요건에 맞춰 전부 초기값으로 되돌린다.
        //   유지: Division(새 값) + 기간/날짜(period3From/To = Shipment Result 전용 Shipment Date, division 무관 독립 시드).
        //   planDate/periodFrom·To/period2 는 Division→Company→PlanDate cascade 가 재선택·재파생하므로 초기화(빈값)가 맞다.
        state.searchCondition = {
          ...initSearch,
          divisionId,
          period3From: cur.period3From,
          period3To: cur.period3To,
        };
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
        // Main 그리드 3단 날짜 헤더는 Search 가 아니라 PlanDate 확정 시점에 생성한다 —
        //   AS-IS cboPlanDate_SelectedIndexChanged(cs L7245~7258)는 drpPeriod 가 채워지면 그 자리에서
        //   GetSpdTitle()(= SCP0009_GET_SHEET_CALENDAR_3SPAN, drpPeriod.Text1~Text2) + InitSpreadDateColumn(siMain)
        //   + SetSpreadColumn() 을 실행해, Division→Company cascade 가 끝나 PlanDate index0 이 자동 선택되는
        //   순간 Grid1 의 날짜 컬럼이 조회 전에 이미 지정 구간으로 셋팅된다(InitSpreadDateColumn L859 가드:
        //   cboPlanDate 가 비면 컬럼 미생성 — setDivision/setCompany 의 filters 초기화가 그 등가).
        //   종전엔 setMainFilters(Search)에서만 CALENDAR 필터를 채워 Search 전까지 헤더가 비어 있었다.
        if (fromDate && toDate1) {
          state.filters[SHEETS.CALENDAR] = { startYyyymmdd: fromDate, endYyyymmdd: toDate1 };
        }
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
            myModelChk: 'N', // 10~14 — AS-IS 체크박스 미노출(SSP0060 화면엔 없음) 기본 N
            partLeaderChk: 'N',
            teamLeaderChk: 'N',
            delegateeChk: 'N',
            nonChk: 'Y',
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
      // 1) admin SCM_MST_SHEET_COLUMNS fetch (mount + Search — ui-dynamic-property-management §2.3).
      //   시트별 개별 POST — 미등록/실패 시 기존 값 유지(그리드 공백, console 금지 룰). 매 호출 fetch.
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

      // 2) F6 저장 조회조건 복원 — 탭 수명 내 1회(initialized 가드, 컬럼 fetch 성패와 독립).
      //    F6(SubTitle Condition) 는 GridAction.personalizeCondition 으로 POST /search-conditions 저장이
      //    되지만, 진입 시 GET 복원 배선이 없어 재진입/새로고침 때 반영되지 않았다(SSP0014 c456d916·SCP0005
      //    efeaaa7b 와 동일 유형, 정본 erp-edi-master §G1). createPersistedStoreWithTab 은 sessionStorage
      //    미영속(모듈 Map keep-alive)이라 전체 새로고침 시 새 스토어 → 복원이 다시 돈다. F10(Reset)은
      //    MotherStore 가 initialized 를 보존(PRESERVED_ON_CONDITION_RESET)하므로 초기화 직후 재복원되지 않는다.
      if (!get().initialized) {
        try {
          const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
            `/admin/menu/${MENU_ID}/search-conditions`
          );
          const rows = res.data.result ?? [];
          if (rows.length > 0) {
            const patch: Record<string, unknown> = {};
            for (const { paramNm, paramCtn } of rows) {
              if (!SEARCH_KEYS.has(paramNm)) continue; // 현재 조회조건 필드만(구버전 잔재 무시)
              const val = paramCtn ?? '';
              patch[paramNm] = ARRAY_KEYS.has(paramNm)
                ? val
                  ? val.split(',').filter(Boolean)
                  : []
                : BOOL_KEYS.has(paramNm)
                  ? val === 'true'
                  : val;
            }
            set(state => {
              state.searchCondition = {
                ...state.searchCondition,
                ...(patch as Partial<SearchCondition>),
                // cascade 파생 재선택 유도 — 복원한 division/company 기준으로 PlanDate(최신)·Period 를
                //   폼 effect 가 다시 고르게 비운다(SEARCH_KEYS 주석 참조). period3(Shipment Date)는 division
                //   무관 독립 시드라 유지.
                planDate: '',
                periodFrom: '',
                periodTo: '',
                period2From: '',
                period2To: '',
              };
              state.realFlag = false;
            });
          }
        } catch {
          // 저장조건 미존재/조회 실패 — 기본값 유지 (console 금지 룰)
        }
        set(state => {
          state.initialized = true;
        });
      }
    },

    fetchStaticMeasures: async () => {
      // Measure 축 메타 — PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_MEASURE_LIST → SCM_MST_SHEET_MEASURE.
      //   필수: divisionId 를 넘기지 않는다. 그 proc 의 division 조건은 `P_DIVISION_ID IS NULL OR
      //   P_DIVISION_ID IN (split(M.DIVISION_ID))` 로 **M.DIVISION_ID IS NULL 탈출이 없다** —
      //   SSP0060 메타는 DIVISION_ID 가 전부 NULL 이라 값을 주면 0행이 된다(실측 2026-10-12:
      //   div=NULL → 20행 / div='40' → 0행). 컬럼 메타 fetch 도 같은 이유로 sheetNm 만 넘긴다.
      try {
        const res = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
          sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN],
        });
        const next = res.data.result ?? [];
        if (next.length > 0) {
          set(state => {
            if (JSON.stringify(state.staticMeasures) !== JSON.stringify(next)) {
              state.staticMeasures = next;
            }
          });
        }
      } catch {
        // 미등록/실패 = 기존 값 유지 (팝업은 빈 목록 — console 금지 룰)
      }
    },

    applyVisibleMeasures: codes =>
      set(state => {
        state.visibleMeasures = codes;
      }),
  }),
  'shipment-plan-store'
);
