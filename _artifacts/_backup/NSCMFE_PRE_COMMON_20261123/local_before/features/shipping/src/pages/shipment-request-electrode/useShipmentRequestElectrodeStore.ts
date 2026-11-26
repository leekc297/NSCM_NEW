import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './shipment-request-electrode.constants';
import type { SearchParamProps } from './shipment-request-electrode.types';

/** SCM_MST_SHEET_MEASURE 동적 fetch row — /admin/menu/{MENU_ID}/measure (camelCase, DMF0082 계약 동일). */
export interface MeasureMeta {
  colNm: string;
  colLblNm?: string;
  display?: boolean;
  personalizable?: boolean;
  sortOrd?: number;
}

interface ShipmentRequestElectrodeState {
  searchParams: SearchParamProps;
  // SubTitle F6 저장분(개인화 조회조건) 1회 복원 가드 — mount 중복/재마운트 재복원 방지(로드 전용이라 별도 플래그).
  //   자매 shipment-plan-auto-ess(SSP0021)/shipment-plan-mobility-it restoreSearchConditions 와 동일 패턴.
  conditionsRestored: boolean;
  filters?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  requestDetailFilters?: ProcRequest<MENU_ID, SHEETS.REQUEST_DETAIL>;
  stockDetailFilters?: ProcRequest<MENU_ID, SHEETS.STOCK_DETAIL>;
  spreadTitleFilters?: ProcRequest<MENU_ID, SHEETS.SPREAD_TITLE>;
  isOpenSearchArea: boolean;
  // BOH 표시모드(rdButton1/2/3) — design 01 R4. 기본 선택값은 AS-IS 미확정(확인 필요, 01_layout.md §5-1)
  //   → 잠정 rdButton1(합계) 기본 유지, 사용자 확인 시 정정.
  bohMode: 'rdButton1' | 'rdButton2' | 'rdButton3';
  staticColumns: Record<SHEETS.MAIN | SHEETS.REQUEST_DETAIL | SHEETS.STOCK_DETAIL | SHEETS.REQUEST_DETAIL_EXCEL, RawFlexGridColumnConfig[]>;
  staticMeasures: MeasureMeta[];
  // Measure 설정(btnMeasure) 결과 — 표시 measure 코드 목록(null=전체). 그리드 행(MEASURE) 필터용.
  visibleMeasures: string[] | null;
  // spdDetail 활성 탭(design 01 §2-R14 — 2차 조회조건 6항목 visible 토글 기준).
  activeDetailTab: 'requestDetail' | 'stockDetail';
  // 활성 그리드(design 01 R8/R5 — Save/btnMeasure 라우팅 기준. 없음(null)=포커스 이탈).
  activeGrid: 'spdMain' | 'spdDetail' | null;
  // bRealFlag(AS-IS cs:308/3743-3750) — cboPlanDate 최신(index0) 선택 여부. 메인 pivot 편집·ETA 팝업 가드(MSG00312)
  //   + 조회 SP P_REAL_FLAG 축. AS-IS 초기값 true(로드 시 Form 이 최신 Plan Date 를 자동 선택).
  realFlag: boolean;
}

interface ShipmentRequestElectrodeAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  restoreSearchConditions: () => Promise<void>;
  setDivision: (divisionId: string) => void;
  setFilters: () => boolean;
  // 하단 2차 Search 전용 — 활성 상세 탭(요청/재고)의 filter 만 재구성한다. 상단 main(filters)·spreadTitleFilters
  //   와 비활성 상세 탭 filter 는 절대 건드리지 않는다(활성 탭 그리드만 재조회). 변경 여부를 반환해 활성 상세만 수동 refetch.
  setDetailFilters: (
    activeTab: ShipmentRequestElectrodeState['activeDetailTab']
  ) => { sameReq: boolean; sameStock: boolean };
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setBohMode: (mode: ShipmentRequestElectrodeState['bohMode']) => void;
  setActiveDetailTab: (tab: ShipmentRequestElectrodeState['activeDetailTab']) => void;
  setActiveGrid: (grid: ShipmentRequestElectrodeState['activeGrid']) => void;
  setRealFlag: (realFlag: boolean) => void;
  fetchStaticColumns: () => void;
  fetchStaticMeasures: () => void;
  applyVisibleMeasures: (codes: string[] | null) => void;
}

// 세션 스코프 함수(모듈 상수 아님) — division 등 세션값을 스토어 생성 시점에 읽어야 재로그인 시 얼어붙지 않는다
//   (forecast-price useForecastPriceStore.makeInitSearchParams 선례 1:1).
const makeInitSearchParams = (): SearchParamProps => ({
  // 기본 사업부 = Division 콤보 첫 항목(Form 자동선택). AS-IS SSP0022 는 MyDivision 목록 바인딩 후 첫 행
  //   선택(세션 미사용) — session.div deviation 제거(2026-11-05).
  divisionId: '',
  companyId: '',
  plantSiteIds: [],
  planDate: '',
  bucketType: 'D', // DefineProperty() 기본값 = BucketType.Daily(design 02 §4)
  cellTypes: [],
  myModelChk: false,
  partLeaderChk: false,
  teamLeaderChk: false,
  delegateModelChk: false,
  modelId: '',
  itemId: '',
  nickName: '',
  fromYyyymmdd: '',
  toYyyymmdd: '',
  modelId2: '',
  itemId2: '',
  nickName2: '',
  requestor: '',
  lotId: '',
  fromYyyymmdd2: '',
  toYyyymmdd2: '',
  pastPeriodChecked: false,
  sumChecked: false,
});

const makeInitState = (): ShipmentRequestElectrodeState => ({
  searchParams: makeInitSearchParams(),
  conditionsRestored: false,
  isOpenSearchArea: true,
  bohMode: 'rdButton1',
  staticColumns: {
    [SHEETS.MAIN]: [],
    [SHEETS.REQUEST_DETAIL]: [],
    [SHEETS.STOCK_DETAIL]: [],
    [SHEETS.REQUEST_DETAIL_EXCEL]: [],
  },
  staticMeasures: [],
  visibleMeasures: null,
  activeDetailTab: 'stockDetail', // AS-IS 기본 활성 시트 = Stock Detail(CreateSpread cs:595)
  activeGrid: null,
  realFlag: true, // AS-IS bRealFlag 초기값 true(cs:308) — 로드 시 Form 이 최신 Plan Date(index0) 자동 선택.
});

// 4개 체크박스 전부 미체크(design 02 §6-4, P_NON_CHK='Y' 재현) 판정.
const yn = (v: boolean): string => (v ? 'Y' : 'N');
const joinComma = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join(','));

// F6 저장분 역직렬화 키셋 — 저장 side(GridAction.personalizeCondition)는 배열을 join(','), 불리언을
//   String(bool)='true'/'false' 로 평문화하므로 복원은 각각 split(',')·==='true' 로 되돌린다.
//   SearchParamProps 의 배열 2 / 불리언 6 필드. 그 외(문자열/enum)는 그대로 patch.
const ARRAY_KEYS = new Set<string>(['plantSiteIds', 'cellTypes']);
const BOOL_KEYS = new Set<string>([
  'myModelChk',
  'partLeaderChk',
  'teamLeaderChk',
  'delegateModelChk',
  'pastPeriodChecked',
  'sumChecked',
]);

export const useShipmentRequestElectrodeStore = createPersistedStoreWithTab<
  ShipmentRequestElectrodeState & ShipmentRequestElectrodeAction
>(
  (set, get) => ({
    ...makeInitState(),
    reset: () => set(makeInitState()),
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
      });
    },
    // 개인화 조회조건 복원(SubTitle F6 저장분 되불러오기) — 자매 SSP0021/shipment-plan-mobility-it 파리티.
    //   진입 시 GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 을 searchParams 에 역직렬화.
    //   1회 가드(conditionsRestored) — mount 중복/재마운트 재복원 방지. 저장분 없으면(0건) 기본값 유지.
    //   저장 side(SubTitle searchParam={searchParams})는 이미 배선됨 — 복원 side 누락
    //   ([[f6-restore-path-missing-on-new-scaffolds]]) 보완. 기간(fromYyyymmdd/toYyyymmdd)은 저장 side
    //   EXCLUDED_DATE_PARAM 로 애초에 저장 제외라 복원 대상 아님(의도된 동작, 자매 동일).
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
        const initParams = makeInitSearchParams();
        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in initParams)) continue; // 모르는 키(구버전 잔재) 제외
          const val = paramCtn ?? '';
          if (ARRAY_KEYS.has(paramNm)) patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          else if (BOOL_KEYS.has(paramNm)) patch[paramNm] = val === 'true';
          else patch[paramNm] = val;
        }
        set(state => {
          state.searchParams = { ...state.searchParams, ...patch } as SearchParamProps;
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (하드코딩 fallback·console 금지)
      }
    },
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division 외 검색조건을 전부 초기화하고 그리드도 초기화한다
    //   (사용자 지시 2026-10-02 — TO-BE 공통 요건이 AS-IS 핸들러보다 우선, commit 51d4e9fa 패턴 / SCP0025 선례).
    //   이 화면은 cascade(Division→Company→{PlantSite,PlanDate}→기간)라 기간(fromYyyymmdd/toYyyymmdd)이
    //   PlanDate 파생이므로 Division 변경 시 cascade 와 함께 초기화된다(design 02 §4 — Division 변경 시
    //   Company/PlantSite/PlanDate/기간 초기화). 2차 조회조건·CellType·Model/Item/NickName·체크박스도 함께 init.
    //   그리드 초기화 = 전 시트 filters 무효화(재조회 전까지 빈 상태). 편집중(dirty) 확인 가드(MSG00704)는 Form
    //   onChange 가 confirmIfDirtyKey 로 처리하며, 이 액션 호출 전 EditTracker 는 페이지 effect 가 clearChanges 한다.
    setDivision: divisionId => {
      set(state => {
        state.searchParams = { ...makeInitSearchParams(), divisionId };
        state.filters = undefined;
        state.requestDetailFilters = undefined;
        state.stockDetailFilters = undefined;
        state.spreadTitleFilters = undefined;
      });
    },
    setBohMode: mode => {
      set(state => {
        state.bohMode = mode;
      });
    },
    setActiveDetailTab: tab => {
      set(state => {
        state.activeDetailTab = tab;
      });
    },
    setActiveGrid: grid => {
      set(state => {
        state.activeGrid = grid;
      });
    },
    // bRealFlag(cs:3743-3750) — Form 의 PlanDate 선택 핸들러가 index0(최신) 여부로 세팅.
    setRealFlag: realFlag => {
      set(state => {
        state.realFlag = realFlag;
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    // AS-IS FindButton() → FindData_Main() 단일 호출(cs:1435-1440) — 상단 Find 는 메인 pivot(+3SPAN 헤더)만
    //   재조회한다. 상세(요청/재고)는 하단 2차 Search(setDetailFilters)·엑셀 업로드 경로에서만 조회한다
    //   (자매 SSP0023 setMainFilters/setDetailFilter 분리와 동일 — 상단 Search 가 하단까지 조회하던 AS-IS 이탈
    //   교정 2026-11-03). 파라미터 셋은 design 02 §5, cs L2110-2185.
    setFilters: () => {
      const sesUserId = useSessionStore.getState().session.userId ?? '';
      const sp: SearchParamProps = { ...makeInitSearchParams(), ...get().searchParams };
      const nonChk =
        !sp.myModelChk && !sp.partLeaderChk && !sp.teamLeaderChk && !sp.delegateModelChk ? 'Y' : 'N';

      const newFilters: ProcRequest<MENU_ID, SHEETS.MAIN> = {
        divisionId: sp.divisionId,
        companyId: sp.companyId,
        plantId: joinComma(sp.plantSiteIds),
        cellType: joinComma(sp.cellTypes),
        planStartYyyymmdd: sp.planDate,
        fromYyyymmdd: sp.fromYyyymmdd,
        toYyyymmdd: sp.toYyyymmdd,
        modelId: sp.modelId,
        itemId: sp.itemId,
        nickName: sp.nickName,
        sesUserId,
        mnuId: MENU_ID,
        sheetName: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? '',
        realFlag: get().realFlag ? 'Y' : 'N', // bRealFlag(cs:3743-3750) — Form PlanDate 선택(index0 여부)이 세팅
        myModelChk: yn(sp.myModelChk),
        partLeaderChk: yn(sp.partLeaderChk),
        teamLeaderChk: yn(sp.teamLeaderChk),
        delegateChk: yn(sp.delegateModelChk),
        nonChk,
      };
      const newSpreadTitleFilters: ProcRequest<MENU_ID, SHEETS.SPREAD_TITLE> = {
        fromYyyymmdd: sp.fromYyyymmdd,
        toYyyymmdd: sp.toYyyymmdd,
      };

      const cur = get();
      const sameMain = JSON.stringify(cur.filters) === JSON.stringify(newFilters);
      const sameTitle =
        JSON.stringify(cur.spreadTitleFilters) === JSON.stringify(newSpreadTitleFilters);

      // 변경된 slice 만 재할당해 참조를 보존한다 — useTabProcQuery 는 filters '참조' 변경에 removeQueries→
      //   재조회(useLayoutEffect, useCustomQueryClient). 상세(requestDetail/stockDetail) filters 는 여기서
      //   건드리지 않는다 — 하단 2차 Search(setDetailFilters) 전용. 상단 Find 로 하단이 딸려 조회되던 이탈 교정.
      set(state => {
        if (!sameMain) state.filters = newFilters;
        if (!sameTitle) state.spreadTitleFilters = newSpreadTitleFilters;
      });
      return sameMain && sameTitle;
    },
    // 하단 2차 Search(btnSearch, Lot Id 옆) — AS-IS BtnSearch_Click(cs:3785-3803)은 활성 상세 시트만 재조회.
    //   상단 main(state.filters)·spreadTitleFilters 는 **절대 재할당하지 않는다** → useTabProcQuery 의 filters
    //   참조가 불변이라 상단 pivot 그리드가 재조회되지 않는다(사용자 신고 2026-10-26, setFilters 전체 덮어쓰기 폐기).
    //   비활성 상세 탭의 filter 도 재할당하지 않는다 — 두 상세 filter 가 Material/Model(itemId2/modelId2) 등
    //   공용 필드를 공유해 둘 다 덮으면 비활성 탭 query 까지 참조가 바뀌어 자동 재조회되던 오동작 교정
    //   (활성 탭 그리드만 조회, 사용자 신고 2026-10-26).
    setDetailFilters: activeTab => {
      const sesUserId = useSessionStore.getState().session.userId ?? '';
      const sp: SearchParamProps = { ...makeInitSearchParams(), ...get().searchParams };
      const cur = get();

      if (activeTab === 'requestDetail') {
        const newRequestDetailFilters: ProcRequest<MENU_ID, SHEETS.REQUEST_DETAIL> = {
          divisionId: sp.divisionId,
          companyId: sp.companyId,
          modelId: sp.modelId2,
          itemId: sp.itemId2,
          nickName: sp.nickName2,
          fromYyyymmdd: sp.fromYyyymmdd2,
          toYyyymmdd: sp.toYyyymmdd2,
          // Requestor(txtRequestor) — AS-IS FindData_Request_Detail 가 P_REQUESTOR_ID 로 넘긴다(cs:2294,2355).
          //   요청상세 탭 전용 2차 조건(재고상세는 Lot ID 기반이라 미사용 — AS-IS p_lot_id="" cs:2291-2292).
          requestorId: sp.requestor,
          sesUserId,
          mnuId: MENU_ID,
        };
        const sameReq =
          JSON.stringify(cur.requestDetailFilters) === JSON.stringify(newRequestDetailFilters);
        set(state => {
          if (!sameReq) state.requestDetailFilters = newRequestDetailFilters;
        });
        return { sameReq, sameStock: true };
      }

      const newStockDetailFilters: ProcRequest<MENU_ID, SHEETS.STOCK_DETAIL> = {
        divisionId: sp.divisionId,
        companyId: sp.companyId,
        // 재고상세 SP(P_SSP0022_GET_STOCK_DETAIL)는 PLAN_START_YYYYMMDD 등가가 가드 없는 필수 조건이라 상단
        //   조회조건의 Plan Date 를 반드시 넘긴다 — 누락하면 P_PLAN_START_YYYYMMDD=NULL → 항상 0행(2026-10-28
        //   FE 배선 갭 교정). Plant(From Site)/Cell Type 도 AS-IS FindData_Detail(cs:2466-2470)과 동일하게
        //   상단 필터값을 함께 전달해 등가(둘 다 비면 SP 가 NULL/ALL 가드로 전체 조회).
        planStartYyyymmdd: sp.planDate,
        plantId: joinComma(sp.plantSiteIds),
        cellType: joinComma(sp.cellTypes),
        modelId: sp.modelId2,
        itemId: sp.itemId2,
        lotId: sp.lotId,
        sesUserId,
        mnuId: MENU_ID,
      };
      const sameStock =
        JSON.stringify(cur.stockDetailFilters) === JSON.stringify(newStockDetailFilters);
      set(state => {
        if (!sameStock) state.stockDetailFilters = newStockDetailFilters;
      });
      return { sameReq: true, sameStock };
    },
    // Division/Company 변경 = 그리드 초기화 의무(nscm-patterns.md §5-5) — 전 시트 filters 무효화.
    clearFilters: () => {
      set(state => {
        state.filters = undefined;
        state.requestDetailFilters = undefined;
        state.stockDetailFilters = undefined;
        state.spreadTitleFilters = undefined;
      });
    },
    fetchStaticColumns: () => {
      void (async () => {
        const sheetNames: [SHEETS, string][] = [
          [SHEETS.MAIN, ADMIN_SHEET_NAME[SHEETS.MAIN] ?? ''],
          [SHEETS.REQUEST_DETAIL, ADMIN_SHEET_NAME[SHEETS.REQUEST_DETAIL] ?? ''],
          [SHEETS.STOCK_DETAIL, ADMIN_SHEET_NAME[SHEETS.STOCK_DETAIL] ?? ''],
          [SHEETS.REQUEST_DETAIL_EXCEL, ADMIN_SHEET_NAME[SHEETS.REQUEST_DETAIL_EXCEL] ?? ''],
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
        try {
          const result = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
            sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN],
            divisionId: get().searchParams.divisionId,
          });
          set(state => {
            state.staticMeasures = result.data.result ?? [];
          });
        } catch {
          /* SCM_MST_SHEET_MEASURE 10종 등록 확인(실측) — 실패 시 빈 배열 */
        }
      })();
    },
    applyVisibleMeasures: codes => {
      set(state => {
        state.visibleMeasures = codes;
      });
    },
  }),
  'shipment-request-electrode'
);
