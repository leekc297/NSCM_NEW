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
  // 개인화 조회조건 복원 1회 가드 — SubTitle F6 저장분(/admin/menu/{MENU_ID}/search-conditions)을
  //   mount 시 되불러온다. reset()=makeInitState() 가 false 로 되돌려 F10 후 재복원도 허용한다.
  conditionsRestored: boolean;
  searchParams: SearchParamProps;
  filters?: ProcRequest<MENU_ID, SHEETS.PACK>;
  cellFilters?: ProcRequest<MENU_ID, SHEETS.CELL>;
  requestDetailFilters?: ProcRequest<MENU_ID, SHEETS.REQUEST_DETAIL>;
  resultDetailFilters?: ProcRequest<MENU_ID, SHEETS.RESULT_DETAIL>;
  spreadTitleFilters?: ProcRequest<MENU_ID, SHEETS.SPREAD_TITLE>;
  isOpenSearchArea: boolean;
  staticColumns: Record<StaticColumnSheet, RawFlexGridColumnConfig[]>;
  staticMeasures: Record<SHEETS.PACK | SHEETS.CELL, MeasureMeta[]>;
  // Measure 설정(btnMeasure) 결과 — 표시 measure 코드(null = 전체). spdMain 시트별 독립.
  visibleMeasures: Record<SHEETS.PACK | SHEETS.CELL, string[] | null>;
  activeMainSheet: ActiveMainSheet; // Pack Biz ↔ Cell Biz(design 01 R14)
  activeDetailSheet: ActiveDetailSheet; // Request ↔ Result Detail(design 01 R15)
  activeGrid: ActiveGrid;
}

interface ShipmentRequestPackAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  // 상단 Search/F5 — 현재 활성 main 시트(Pack/Cell)의 필터 + spreadTitle 만 세팅(하단 미건드림, SSP0015 동작).
  setMainFilters: () => void;
  // 하단 Search — 현재 활성 detail 시트(Request/Result Detail)의 필터만 세팅.
  setDetailFilters: () => void;
  // 메인(Pack) 그리드 Measure/날짜 셀 더블클릭 → 하단 Request Detail 을 그 행 item/toSite(+날짜)로 재조회
  //   (AS-IS SpdMain_CellDoubleClick→FindData_Detail_DblClick). date=null 이면 상단 Period 전체.
  drillDetailFromMain: (modelId: string, scmSiteId: string, date: string | null) => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setActiveMainSheet: (sheet: ActiveMainSheet) => void;
  setActiveDetailSheet: (sheet: ActiveDetailSheet) => void;
  setActiveGrid: (grid: ActiveGrid) => void;
  fetchStaticColumns: () => void;
  fetchStaticMeasures: () => void;
  applyVisibleMeasures: (sheet: SHEETS.PACK | SHEETS.CELL, codes: string[] | null) => void;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchParams 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

// 개인화 조건 복원 시 역직렬화 키(SubTitle F6 저장은 배열=콤마join·불리언=String 으로 평문화 —
//   gridAction.personalizeCondition). 복원은 그 역: 배열은 split(','), 그 외(enum/문자열)는 그대로.
//   날짜키 fromYyyymmdd/toYyyymmdd 는 EXCLUDED_DATE_PARAM 로 저장 자체가 제외라 복원 대상 아님
//   (fromYyyymmdd2/toYyyymmdd2 는 접미 '2' 때문에 regex 에 안 걸려 저장·복원됨). 불리언 조건 없음.
const ARRAY_KEYS = new Set<string>(['teamIds', 'endCustomerIds', 'salesSiteIds', 'plantSiteIds']);

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
  conditionsRestored: false,
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
  visibleMeasures: {
    [SHEETS.PACK]: null,
    [SHEETS.CELL]: null,
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
    // 상단 Search/F5(AS-IS FindButton→FindData) — **현재 활성 main 시트(Pack/Cell)**의 필터 + 그 시트
    //   spreadTitle 만 세팅한다. 하단(Request/Result Detail) 필터는 건드리지 않아 상단 조회가 하단을
    //   함께 돌리지 않는다(SSP0015 동작 참고). 비활성 시트 필터는 undefined 유지 → 탭 전환해도 그 시트는
    //   자기 Search 전까지 조회되지 않고(enabled 게이트), 이미 조회한 시트는 react-query 캐시로 유지된다.
    setMainFilters: () => {
      const sesUserId = useSessionStore.getState().session.userId ?? '';
      const sp: SearchParamProps = { ...makeInitSearchParams(), ...get().searchParams };
      const activeSheet = get().activeMainSheet;

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
      const newSpreadTitleFilters: ProcRequest<MENU_ID, SHEETS.SPREAD_TITLE> = {
        fromYyyymmdd: sp.fromYyyymmdd,
        toYyyymmdd: sp.toYyyymmdd,
        sesUserId,
        sheetName: ADMIN_SHEET_NAME[activeSheet === 'cell' ? SHEETS.CELL : SHEETS.PACK],
        divisionId: sp.divisionId,
      };

      set(state => {
        if (activeSheet === 'cell') state.cellFilters = common;
        else state.filters = common;
        state.spreadTitleFilters = newSpreadTitleFilters;
      });
    },
    // 하단 Search(AS-IS btnSearch→FindData_Detail/_Result_Detail) — **현재 활성 detail 시트**의 필터만
    //   세팅한다. 상단 main 필터는 건드리지 않는다.
    setDetailFilters: () => {
      const sesUserId = useSessionStore.getState().session.userId ?? '';
      const sp: SearchParamProps = { ...makeInitSearchParams(), ...get().searchParams };
      const activeDetail = get().activeDetailSheet;

      set(state => {
        if (activeDetail === 'resultDetail') {
          state.resultDetailFilters = {
            divisionId: sp.divisionId,
            fromYyyymmdd: sp.fromYyyymmdd2,
            toYyyymmdd: sp.toYyyymmdd2,
            modelId: sp.modelId2,
            nickName: sp.nickName2,
            sesUserId,
            mnuId: MENU_ID,
          };
        } else {
          state.requestDetailFilters = {
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
        }
      });
    },
    // AS-IS SpdMain_CellDoubleClick→FindData_Detail_DblClick(vItem, vToSite, vDate) 이식 — Pack 메인
    //   그리드 SHIP_REQ 행의 Measure/날짜 셀 더블클릭 시 하단 Request Detail 을 그 행 item(MODEL_ID)·
    //   toSite(TO_SITE=P_SCM_SITE_ID)로 좁혀 재조회한다. date 있으면 그 하루, 없으면 상단 Period 전체.
    //   activeDetailSheet 를 requestDetail 로 맞춰 쿼리 enabled 게이트를 연다(SP GET_REQUEST_DETAIL_PACK 배포됨).
    drillDetailFromMain: (modelId, scmSiteId, date) => {
      const sesUserId = useSessionStore.getState().session.userId ?? '';
      const sp: SearchParamProps = { ...makeInitSearchParams(), ...get().searchParams };
      const from = date ?? sp.fromYyyymmdd;
      const to = date ?? sp.toYyyymmdd;
      set(state => {
        state.activeDetailSheet = 'requestDetail';
        state.requestDetailFilters = {
          divisionId: sp.divisionId,
          fromYyyymmdd: from,
          toYyyymmdd: to,
          modelId,
          scmSiteId,
          nickName: sp.nickName2,
          lotId: sp.lotId, // §2.9 dead parameter — 타입상 필수라 전달만 유지(AS-IS 미반영)
          requestorName: sp.requestor,
          sesUserId,
          mnuId: MENU_ID,
        };
      });
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
    // Measure 설정(btnMeasure) 적용 — 활성 시트의 표시 measure 코드 목록(null=전체) 저장. 그리드는
    //   이 목록으로 행(MEASURE)을 필터해 표시한다(페이지 packRowsShown/cellRowsShown).
    applyVisibleMeasures: (sheet, codes) => {
      set(state => {
        state.visibleMeasures = { ...get().visibleMeasures, [sheet]: codes };
      });
    },
    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기) — 형제 화면(shipment-plan-mobility-it) 파리티.
    //   진입 시 GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 을 searchParams 에 역직렬화.
    //   1회 가드(conditionsRestored) — mount 중복/재마운트 재복원 방지. 저장분 없으면(0건) 기본값 유지.
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
        const initKeys = makeInitSearchParams();
        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in initKeys)) continue; // 모르는 키(구버전 잔재) 제외
          const val = paramCtn ?? '';
          if (ARRAY_KEYS.has(paramNm)) patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          else patch[paramNm] = val;
        }
        set(state => {
          state.searchParams = { ...get().searchParams, ...patch } as SearchParamProps;
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (하드코딩 fallback·console 금지)
      }
    },
  }),
  'shipment-request-pack'
);
