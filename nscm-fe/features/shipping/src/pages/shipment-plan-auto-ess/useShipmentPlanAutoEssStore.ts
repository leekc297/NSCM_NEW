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
  // 개인화 조회조건 복원 1회 가드 (SubTitle F6 저장분을 mount 시 되불러온다 — initialized 는 컬럼/measure
  //   로드 전용이라 별도 플래그). 자매 shipment-plan-mobility-it restoreSearchConditions 와 동일 패턴.
  conditionsRestored: boolean;
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
  // Measure 설정 팝업이 OK 로 확정한 표시 measure 코드(순서 포함). null = 개인화 없음(메타 display 기본).
  //   그리드 노출은 staticMeasures[].display 가 가르므로(MainGrid) 이 값은 팝업 좌/우 복원용이다.
  visibleMeasures: string[] | null;
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
  applyVisibleMeasures: (codes: string[] | null) => void;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchCondition 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

// 개인화 조건 복원 시 역직렬화 키(SubTitle F6 저장은 배열=콤마join·불리언=String 으로 평문화 — gridAction
//   personalizeCondition). 복원은 그 역: 배열은 split(','), 불리언은 ==='true'. 그 외(enum/문자열)는 그대로.
//   날짜범위 키(periodFrom/To 등)는 저장측 EXCLUDED_DATE_PARAM 로 애초에 저장 제외라 복원 대상 아님.
const ARRAY_KEYS = new Set<string>(['plantSiteIds', 'resultTypes']);
const BOOL_KEYS = new Set<string>(['chkSum']);

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
  conditionsRestored: false,
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

export const useShipmentPlanAutoEssStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),

    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division·기간/날짜를 제외한 검색조건을 전부 초기화하고
    //   그리드도 초기화(filters clear)한다(사용자 지시 2026-10-02 — TO-BE 공통 요건이 AS-IS cascade
    //   부분초기화보다 우선, commit 51d4e9fa 계열). 유지=Division(새 값)+period3(Shipment Date 독립 기본구간).
    //   period/period2 는 planDate 파생이라 planDate 초기화와 함께 비워진다(realFlag 도 해제).
    //   편집중(dirty) 확인 가드(MSG00704)는 Form 의 onChange 가 confirmIfDirtyKey 로 처리한다.
    setDivision: divisionId =>
      set(state => {
        const cur = get().searchCondition;
        state.searchCondition = {
          // Division·period3 제외 전 조건 초기화
          //   (company/site/model/bucket/sum/item/requestor/resultTypes/boxId/planDate/period)
          ...initSearch,
          divisionId,
          period3From: cur.period3From, // 기간/날짜 유지 — Shipment Date 독립 기본구간
          period3To: cur.period3To,
        };
        state.realFlag = false; // planDate 초기화 동반 — 최신 Plan 플래그 해제
        state.filters = {}; // 그리드 초기화 — 재조회(Search) 전까지 빈 상태
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
        // Main 3단 날짜 헤더(월>주>일)는 Search 가 아니라 **PlanDate 확정 시점**에 만든다.
        //   AS-IS cboPlanDate_SelectedIndexChanged(cs L5947~5960)가 drpPeriod 가 채워지는 즉시
        //   `GetSpdTitle()`(= SCP0009_GET_SHEET_CALENDAR_3SPAN) + `InitSpreadDateColumn(siMain, ...)`
        //   + `SetSpreadColumn()` 을 그 자리에서 실행한다. 그래서 Division→Company cascade 가 끝나
        //   PlanDate index0 이 자동 선택되는 순간, 조회 전에 이미 주차·일자 컬럼이 서 있다.
        //   종전에는 setMainFilters(Search)에서만 CALENDAR 필터를 채워 **조회 전까지 헤더가 비어
        //   있었다**(사용자 신고 2026-10-12 "로드되었을 때 주차 Column 이 생기도록"). 자매 SSP0060 은
        //   같은 수정이 이미 들어가 있어 그 배선을 그대로 맞춘다.
        //   가드: from/to 가 모두 있을 때만 — AS-IS 도 `!IsNullOrWhiteSpace(Text1 && Text2)` 조건이다.
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
            myModelChk: 'N', // 9~13 — 체크박스 미노출(SSP0021 화면엔 없음) 기본 N/Y
            partLeaderChk: 'N', // 10
            teamLeaderChk: 'N', // 11
            delegateeChk: 'N', // 12
            nonChk: 'Y', // 13
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

    applyVisibleMeasures: codes =>
      set(state => {
        state.visibleMeasures = codes;
      }),

    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기) — 자매 shipment-plan-mobility-it 파리티.
    //   진입 시 GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 을 searchCondition 에 역직렬화.
    //   1회 가드(conditionsRestored) — mount 중복/재마운트 재복원 방지. 저장분 없으면(0건) 기본값 유지.
    //   저장 side(searchParam={sc})는 이미 배선됨 — 복원 side 누락([[f6-restore-path-missing-on-new-scaffolds]]) 보완.
    restoreSearchConditions: async () => {
      if (get().conditionsRestored) return;
      set(state => {
        state.conditionsRestored = true; // 먼저 세운다(중복 호출 방지)
      });
      try {
        const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        const rows = res.data.result ?? [];
        if (rows.length === 0) return;
        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in initSearch)) continue; // 모르는 키(구버전 잔재) 제외
          const val = paramCtn ?? '';
          if (ARRAY_KEYS.has(paramNm)) patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          else if (BOOL_KEYS.has(paramNm)) patch[paramNm] = val === 'true';
          else patch[paramNm] = val;
        }
        set(state => {
          state.searchCondition = { ...state.searchCondition, ...patch } as SearchCondition;
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (하드코딩 fallback·console 금지)
      }
    },
  }),
  'shipment-plan-auto-ess-store'
);
