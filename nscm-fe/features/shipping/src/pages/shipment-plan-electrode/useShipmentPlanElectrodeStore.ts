import dayjs from 'dayjs';

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
  // 개인화 조회조건 복원 1회 가드 (SubTitle F6 저장분을 mount 시 되불러온다 — initialized 는 컬럼/measure
  //   로드 전용이라 별도 플래그). 형제 화면(shipment-plan-mobility-it 등) restoreSearchConditions 와 동일 패턴.
  conditionsRestored: boolean;
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
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchCondition 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

// clbFromSite 다중선택 → SP 는 CSV 로 받음(미선택=전체=''). 자매 shipment-plan-mobility-it 와 동일 규약.
const joinOrEmpty = (arr: string[]): string => (arr.length === 0 ? '' : arr.join(','));

const initSearch: SearchCondition = {
  divisionId: '',
  companyId: '',
  fromSite: [],
  planDateYyyymmdd: '',
  isLatest: false,
  bucketType: BUCKET_TYPE.DAILY,
  bohRadio: BOH_RADIO.GENERAL,
  resultType: ['P', 'O'], // 기본 Plan(P)+oWMS(O) 체크 — AS-IS clbResultType.SetItemChecked(0,true)/(1,true) 재현(cs:914~915)
  chkSum: false,
  chkPastPeriod: false,
  periodFrom: '',
  periodTo: '',
  modelId: '',
  itemId: '',
  nickName: '',
  chkMyModel: false, // 초기 auto-check(R09)는 Form effect 가 서버조회로 설정
  chkPartLeader: false,
  chkTeamLeader: false,
  chkDelegateeModel: false,
  detailModelId: '',
  detailItemId: '',
  detailNickName: '',
  detailLotId: '',
  detailRequestor: '',
  planDetailShipFrom: '',
  planDetailShipTo: '',
  shipResultShipFrom: '',
  shipResultShipTo: '',
};

// 개인화 조건 복원 시 역직렬화 키(SubTitle F6 저장은 배열=콤마 join·불리언=String 으로 평문화 —
//   GridAction.personalizeCondition). 복원은 그 역: 배열은 split(','), 불리언은 ==='true'. 그 외(enum/문자열)는
//   그대로. 기간/날짜 키(periodFrom/To·*Yyyymmdd)는 저장 단계에서 EXCLUDED_DATE_PARAM 로 빠지므로 복원 대상 아님.
const ARRAY_KEYS = new Set<string>(['fromSite', 'resultType']);
const BOOL_KEYS = new Set<string>([
  'isLatest',
  'chkSum',
  'chkPastPeriod',
  'chkMyModel',
  'chkPartLeader',
  'chkTeamLeader',
  'chkDelegateeModel',
]);

// 하단 detail sheet 별 2차 조회조건 필드 노출 (03 §0, AS-IS 각 상세 SP IN 집합 투영).
const fieldSetOf = (sheet: DetailSheet): DetailFieldSet => {
  switch (sheet) {
    // PlanDetail: Model/Material/NickName/Requestor/ShipmentDate(drpPeriod2) + New (cs:5282~5293)
    case SHEETS.PLAN_DETAIL:
      return {
        resultType: false,
        shipmentDate: true,
        newButton: true,
        model: true,
        material: true,
        nickName: true,
        lotId: false,
        requestor: true,
      };
    // StockDetail: Material/NickName/LotID (period·model·requestor 없음, cs:5380~5434)
    case SHEETS.STOCK_DETAIL:
      return {
        resultType: false,
        shipmentDate: false,
        newButton: false,
        model: false,
        material: true,
        nickName: true,
        lotId: true,
        requestor: false,
      };
    // ShipmentResult: Material/ShipmentDate(drpPeriod3)/ResultType (model·nick·lot 없음, cs:5481~5549)
    case SHEETS.SHIPMENT_RESULT:
      return {
        resultType: true,
        shipmentDate: true,
        newButton: false,
        model: false,
        material: true,
        nickName: false,
        lotId: false,
        requestor: false,
      };
    default:
      return fieldSetOf(SHEETS.PLAN_DETAIL);
  }
};

const INITIAL_FIELDSET: DetailFieldSet = fieldSetOf(SHEETS.PLAN_DETAIL);

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
};

export const useShipmentPlanElectrodeStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),

    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division 을 제외한 검색조건을 전부 초기화하고 그리드도
    //   초기화한다(사용자 지시 2026-10-02 — TO-BE 공통 요건이 AS-IS 핸들러보다 우선, SCP0025 정본 패턴).
    //   이 화면의 기간/날짜(Period·PlanDate)는 Division→Company→PlanDate cascade 로 파생되는 종속축이라
    //   따로 유지할 독립 기간필드가 없다 → initSearch(period/planDate 공란)로 리셋하면 Form cascade effect 가
    //   Company→PlanDate→Period 를 재파생한다. 기존엔 cascade 종속축(Company/FromSite/PlanDate/Period)만
    //   비웠으나 공통 요건상 나머지 검색필터(Bucket/BOH/ResultType/Sum/PastPeriod/Model/Material/NickName/
    //   4체크박스·상세 2차필드)도 초기화한다. 그리드 초기화 의무(hook #5)는 filters 비움으로 유지.
    //   EditTracker 정리는 페이지 effect(divisionId·companyId 감시)가 수행. 편집중(dirty) 확인 가드(MSG00704)는
    //   Form 의 onChange 가 confirmIfDirtyKey 로 처리한다(commit 51d4e9fa 패턴).
    setDivision: divisionId =>
      set(state => {
        state.searchCondition = { ...initSearch, divisionId };
        state.realFlag = false;
        state.filters = {};
      }),

    setCompany: companyId =>
      set(state => {
        const c = state.searchCondition;
        c.companyId = companyId;
        c.fromSite = [];
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
        // AS-IS cboPlanDate_SelectedIndexChanged(cs:5765~5767) — PlanDate 선택 시 상세 2차 기간을 파생초기화.
        //   drpPeriod2(PlanDetail): from=선택 PlanDate 당일 / to=기간종료(TO_DATE). 이후 사용자 재편집 가능.
        c.planDetailShipFrom = code;
        c.planDetailShipTo = toDate;
        //   drpPeriod3(ShipmentResult): from=오늘-9일 / to=오늘-1일 고정범위(ShipmentResult_GetDayRange cs:5676~).
        c.shipResultShipFrom = dayjs().subtract(9, 'day').format('YYYYMMDD');
        c.shipResultShipTo = dayjs().subtract(1, 'day').format('YYYYMMDD');
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
        // 4체크박스 모두 미선택이면 P_NON_CHK='Y' (AS-IS FindData_Main cs:4650~4662 파생).
        const nonChk =
          !c.chkMyModel && !c.chkPartLeader && !c.chkTeamLeader && !c.chkDelegateeModel ? 'Y' : 'N';
        // PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN (18 IN + O_RC1 — PROC_M SORT_ORD camelCase COL_NM 실측,
        //   [[ssp0023-main-sp-18in-fe-sends-only-11-missing-model-filters]]). call-proc 는 이름 바인딩이라
        //   순서 무관하나 키는 COL_NM 정확일치. Model/Material/NickName/4체크박스는 검색 필터(02 §2 L64).
        state.filters[SHEETS.MAIN] = {
          divisionId: c.divisionId, // 1
          companyId: c.companyId, // 2
          fromSite: joinOrEmpty(c.fromSite), // 3 (다중선택 CSV, 미선택='')
          planStartYyyymmdd: c.planDateYyyymmdd, // 4
          fromYyyymmdd: c.periodFrom, // 5 (drpPeriod — PlanDate 파생)
          toYyyymmdd: c.periodTo, // 6
          modelId: c.modelId.toUpperCase(), // 7 (AS-IS txtModelId.Text.ToUpper())
          itemId: c.itemId, // 8 (btnItemId 팝업 결과, ToUpper 없음)
          nickName: c.nickName.toUpperCase(), // 9 (AS-IS textNickName.Text.ToUpper())
          userId: session.userId ?? '', // 10
          programId: PROGRAM_ID, // 11
          sheetName: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? '', // 12
          realFlag: state.realFlag ? 'Y' : 'N', // 13
          nonChk, // 14
          myModelChk: c.chkMyModel ? 'Y' : 'N', // 15
          delegateeChk: c.chkDelegateeModel ? 'Y' : 'N', // 16
          partLeaderChk: c.chkPartLeader ? 'Y' : 'N', // 17
          teamLeaderChk: c.chkTeamLeader ? 'Y' : 'N', // 18
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
        const realFlag = state.realFlag ? 'Y' : 'N';
        // itemId: 메인 드릴다운(dblFlag='Y')은 클릭 행 값으로 좁히고, 상세 재검색(dblFlag='N')은
        //   txtItemId2(detailItemId) 를 쓴다. 3-sheet 공통(AS-IS 각 Find*_Detail item_id 원천).
        const detailItemId = overrides?.itemId ?? c.detailItemId;
        const fromSite = overrides?.fromSite ?? joinOrEmpty(c.fromSite);
        // 4체크박스 모두 미선택이면 nonChk='Y'. 상세 3-SP 도 1차 체크박스(chkMyModel 등)를 재사용한다
        //   (AS-IS FindData_Detail/Stock/Result 가 동일 chkMyModel.Checked 를 읽음, cs:5215~/5391~/5489~).
        const nonChk =
          !c.chkMyModel && !c.chkPartLeader && !c.chkTeamLeader && !c.chkDelegateeModel ? 'Y' : 'N';
        const myModelChk = c.chkMyModel ? 'Y' : 'N';
        const delegateeChk = c.chkDelegateeModel ? 'Y' : 'N';
        const partLeaderChk = c.chkPartLeader ? 'Y' : 'N';
        const teamLeaderChk = c.chkTeamLeader ? 'Y' : 'N';
        if (sheet === SHEETS.PLAN_DETAIL) {
          // 22 IN (PROC_M 실측 camelCase). drpPeriod2 독립축 + Model2/NickName2/Requestor
          //   + 1차 4체크박스/nonChk 재사용 (AS-IS FindData_Detail cs:5282~5330).
          state.filters[SHEETS.PLAN_DETAIL] = {
            divisionId: c.divisionId,
            companyId: c.companyId,
            fromSite,
            itemId: detailItemId,
            modelId: c.detailModelId.toUpperCase(),
            nickName: c.detailNickName.toUpperCase(),
            requestor: c.detailRequestor,
            planStartYyyymmdd: c.planDateYyyymmdd,
            fromYyyymmdd: c.planDetailShipFrom,
            toYyyymmdd: c.planDetailShipTo,
            dblFlag,
            realFlag,
            language,
            programId: PROGRAM_ID,
            sheetName: ADMIN_SHEET_NAME[sheet] ?? '',
            nonChk,
            myModelChk,
            delegateeChk,
            partLeaderChk,
            teamLeaderChk,
            userId,
            debugMode: 'F',
          };
        } else if (sheet === SHEETS.SHIPMENT_RESULT) {
          // 15 IN. 체크박스 COL_NM 이 전부 소문자(mymodelchk/nonchk ...)라 키 casing 이 다른 2 SP 와 상이
          //   (PROC_M 실측). drpPeriod3 독립축 + Result Type (AS-IS FindData_Result cs:5481~5552).
          state.filters[SHEETS.SHIPMENT_RESULT] = {
            divisionId: c.divisionId,
            fromSite,
            itemId: detailItemId,
            fromYyyymmdd: c.shipResultShipFrom,
            toYyyymmdd: c.shipResultShipTo,
            type: joinOrEmpty(c.resultType), // Result Type 다중선택 CSV(미선택=''). AS-IS GetCheckedListValue(...,true) 재현. FE 후필터 R 제외
            userId,
            companyId: c.companyId,
            mymodelchk: myModelChk,
            partleaderchk: partLeaderChk,
            teamleaderchk: teamLeaderChk,
            delegateechk: delegateeChk,
            nonchk: nonChk,
            realFlag,
            planStartYyyymmdd: c.planDateYyyymmdd,
          };
        } else if (sheet === SHEETS.STOCK_DETAIL) {
          // 15 IN. NickName2/LotID + 1차 4체크박스/nonChk 재사용. period·model·requestor·dblFlag 없음
          //   (AS-IS FindData_Stock cs:5380~5434).
          state.filters[SHEETS.STOCK_DETAIL] = {
            divisionId: c.divisionId,
            companyId: c.companyId,
            fromSite,
            planStartYyyymmdd: c.planDateYyyymmdd,
            itemId: detailItemId,
            nickName: c.detailNickName.toUpperCase(),
            lotId: c.detailLotId,
            userId,
            programId: PROGRAM_ID,
            sheetName: ADMIN_SHEET_NAME[sheet] ?? '',
            myModelChk,
            delegateeChk,
            partLeaderChk,
            teamLeaderChk,
            nonChk,
          };
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

    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기) — AS-IS/형제 화면 파리티.
    //   진입 시 GET /admin/menu/{MENU_ID}/search-conditions → PRAM_NM/PRAM_CTN 을 searchCondition 에 역직렬화.
    //   1회 가드(conditionsRestored) — mount 중복/재마운트 재복원 방지. 저장분 없으면(0건) 기본값 유지.
    //   날짜/기간(planDateYyyymmdd·periodFrom/To 등)은 저장 단계에서 EXCLUDED_DATE_PARAM 로 빠지므로 복원되지
    //   않고, Form cascade effect 가 Company→PlanDate(최신)→Period 를 재파생한다.
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
  'shipment-plan-electrode-store'
);
