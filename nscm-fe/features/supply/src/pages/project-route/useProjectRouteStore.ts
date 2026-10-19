import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import {
  COLUMN_SHEET_NAME,
  MENU_ID,
  PERIOD_MONTHS_SPAN,
  RESPONSE_SET,
  SHEETS,
} from './project-route.constants';
import type { BomKey, SearchParamProps, SiteKey } from './project-route.types';

type FiltersBySheet = {
  [key in SHEETS]?: ProcRequest<MENU_ID, key>;
};

interface ProjectRouteState {
  initialized: boolean;
  filters: FiltersBySheet;
  searchParams: SearchParamProps;
  // Main/BOM 더블클릭으로 확정된 연쇄조회 키(design/00 A2/A3). 신규행 기본값·BOM/Plant 파라미터 원천.
  siteKey: SiteKey | null;
  bomKey: BomKey | null;
  // BOM 더블클릭이 선행됐는지 — Insert 가드(design/03 R-INS-DEF, MSG00116).
  isBomClicked: boolean;
  staticColumns: {
    [key in RESPONSE_SET]: RawFlexGridColumnConfig[];
  };
  openSearchArea: boolean;
}

interface ProjectRouteAction {
  reset: () => void;
  // Reset Condition(F10) 전용 — 사용자 지시(2026-09-23)로 Period 만 보존한 채 나머지(조회조건/그리드/
  //   연쇄조회 키)는 initState() 와 동일하게 초기화. staticColumns/initialized 는 공용 F10 경로
  //   (useGloablStore.resetSearchCondition, PRESERVED_ON_CONDITION_RESET)와 동일하게 건드리지 않는다.
  resetKeepPeriod: () => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  // Search(F5) — SITE 조회만 커밋. BOM/Plant 는 더블클릭 연쇄로 조회하므로 자식 필터/키는 비운다.
  setFilters: () => void;
  // Main 더블클릭 — site key 확정 + BOM 필터 커밋(+ Plant/BOM 하위 초기화).
  applySiteKey: (siteKey: SiteKey) => void;
  // BOM 더블클릭 — bom key 확정 + Plant 필터 커밋.
  applyBomKey: (bomKey: BomKey) => void;
  clearChain: () => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
}

// YYYYMM 월 인덱스 산술(toISOString(UTC) 금지, nscm-patterns §5-12) — defaultPeriod 와
//   PERIOD_DEFAULT 서버 교정(ProjectRouteForm G6) 양쪽이 공유하는 월 연산.
const yyyymmToIdx = (yyyymm: string): number => {
  const year = Number(yyyymm.slice(0, 4));
  const month = Number(yyyymm.slice(4, 6)); // 1-based
  return year * 12 + (month - 1);
};
const idxToYyyymm = (idx: number): string =>
  `${Math.floor(idx / 12)}${String((idx % 12) + 1).padStart(2, '0')}`;
export const addMonthsToYyyymm = (yyyymm: string, months: number): string =>
  idxToYyyymm(yyyymmToIdx(yyyymm) + months);

// Period 기본값 — AS-IS 는 CallBizCommonData('PERIOD_DEFAULT') From + 11M To(design/02 §4).
//   렌더 즉시 필요한 초기값이라 클라 계산으로 근사(현재월 From). 실제 SP 기준 From 은
//   ProjectRouteForm 의 PERIOD_DEFAULT 콤보 교정 effect(G6)가 마운트 후 1회 덮어쓴다.
const defaultPeriod = (): { fromYyyymm: string; toYyyymm: string } => {
  const now = new Date();
  const baseIdx = now.getFullYear() * 12 + now.getMonth(); // 0-based month index
  return {
    fromYyyymm: idxToYyyymm(baseIdx),
    toYyyymm: idxToYyyymm(baseIdx + PERIOD_MONTHS_SPAN),
  };
};

const initSearchParams = (): SearchParamProps => ({
  // Division 초기값은 빈 문자열 — ProjectRouteForm 의 권한목록 교정형 effect(sales-reports 등
  //   8개 화면과 동일 패턴, 04_react-gap.md G5)가 MyDivision 콤보 로드 후 session.div 가 권한
  //   목록에 있으면 그 값, 없으면 목록 첫 행으로 채운다(AS-IS 권한 division 첫 행과 동등).
  divisionId: '',
  scmSiteId: 'ALL', // clbSalesSite 死필터 — 항상 ALL(design/02 C2/R4)
  projectCode: '',
  itemId: '',
  status: 'ALL', // cboStatus 기본 ALL(design/02 §4)
  ...defaultPeriod(),
});

const initState = (): ProjectRouteState => ({
  initialized: false,
  filters: {
    [SHEETS.SITE]: undefined,
    [SHEETS.BOM]: undefined,
    [SHEETS.PLANT]: undefined,
  },
  searchParams: initSearchParams(),
  siteKey: null,
  bomKey: null,
  isBomClicked: false,
  staticColumns: {
    [RESPONSE_SET.SITE]: [],
    [RESPONSE_SET.BOM]: [],
    [RESPONSE_SET.PLANT]: [],
  },
  openSearchArea: true,
});

export const useProjectRouteStore = createPersistedStoreWithTab<
  ProjectRouteState & ProjectRouteAction
>((set, get) => {
  const clearChainState = (state: ProjectRouteState) => {
    state.filters[SHEETS.BOM] = undefined;
    state.filters[SHEETS.PLANT] = undefined;
    state.siteKey = null;
    state.bomKey = null;
    state.isBomClicked = false;
  };

  return {
    ...initState(),
    reset: () => set(initState()),

    resetKeepPeriod: () =>
      set(state => {
        const { fromYyyymm, toYyyymm } = state.searchParams;
        const fresh = initState();
        state.filters = fresh.filters;
        state.searchParams = { ...fresh.searchParams, fromYyyymm, toYyyymm };
        state.siteKey = fresh.siteKey;
        state.bomKey = fresh.bomKey;
        state.isBomClicked = fresh.isBomClicked;
        state.openSearchArea = fresh.openSearchArea;
      }),

    setSearchParams: partial =>
      set(state => {
        const prev = get().searchParams;
        const next = { ...prev, ...partial };
        // Sales Site 는 항상 ALL 고정(design/02 R4).
        next.scmSiteId = 'ALL';
        // Division 변경 = 연쇄조회/그리드 초기화 의무(nscm-patterns §5-5) + 82/40 부수효과(design/01 R2)
        //   + 다른 조회조건 리셋(사용자 지시 2026-09-23 — BOD/Production Plan Line 의 division-change
        //   cascade 관례와 동일하게 PJT/Model/Status 를 초기값으로 되돌린다. Period 는 division 과
        //   무관한 조건이라 제외 — 사용자 확인).
        if (partial.divisionId !== undefined && partial.divisionId !== prev.divisionId) {
          next.projectCode = '';
          next.itemId = '';
          next.status = 'ALL';
          state.filters = initState().filters;
          clearChainState(state);
        }
        state.searchParams = next;
      }),

    setFilters: () =>
      set(state => {
        const p = get().searchParams;
        // SITE GET 파라미터(design/02 §2.3). 82/40 SP 분기는 divisionId 로 BE PROC 가 처리(design/03 §4.1).
        state.filters[SHEETS.SITE] = {
          divisionId: p.divisionId,
          scmSiteId: p.scmSiteId, // 항상 'ALL'
          projectCode: p.projectCode,
          itemId: p.itemId,
          fromYyyymm: p.fromYyyymm,
          toYyyymm: p.toYyyymm,
          status: p.status,
        };
        // 새 조회 = BOM/Plant 연쇄 리셋(이전 site/bom 선택 무효).
        clearChainState(state);
      }),

    applySiteKey: siteKey =>
      set(state => {
        state.siteKey = siteKey;
        // BOM GET 파라미터(design/03 §4.2): division/scm_site/model_id(=itemId)/project.
        state.filters[SHEETS.BOM] = {
          divisionId: siteKey.divisionId,
          scmSiteId: siteKey.scmSiteId,
          modelId: siteKey.itemId,
          projectCode: siteKey.projectCode,
        };
        // Main 재선택 = Plant/BOM 클릭 상태 리셋.
        state.filters[SHEETS.PLANT] = undefined;
        state.bomKey = null;
        state.isBomClicked = false;
      }),

    applyBomKey: bomKey =>
      set(state => {
        const site = get().siteKey;
        if (!site) return;
        state.bomKey = bomKey;
        state.isBomClicked = true;
        // Plant GET 파라미터(design/03 §4.3): division/scm_site/project/item(=bomItemId).
        state.filters[SHEETS.PLANT] = {
          divisionId: site.divisionId,
          scmSiteId: site.scmSiteId,
          projectCode: site.projectCode,
          itemId: bomKey.itemId,
        };
      }),

    clearChain: () => set(state => clearChainState(state)),

    // 컬럼 메타는 admin(SCM_MST_SHEET_COLUMNS)에서 동적 fetch(ui-category hook, 하드코딩 금지).
    //   sheetNm = DB SHEET_NAME(COLUMN_SHEET_NAME). Search 마다 + mount 1회 재조회(admin 즉시반영).
    fetchStaticColumns: async () => {
      const fetchColumns = (rs: RESPONSE_SET) =>
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: COLUMN_SHEET_NAME[rs],
        });

      const [site, bom, plant] = await Promise.all([
        fetchColumns(RESPONSE_SET.SITE),
        fetchColumns(RESPONSE_SET.BOM),
        fetchColumns(RESPONSE_SET.PLANT),
      ]);
      set(state => {
        state.staticColumns = {
          [RESPONSE_SET.SITE]: site.data.result,
          [RESPONSE_SET.BOM]: bom.data.result,
          [RESPONSE_SET.PLANT]: plant.data.result,
        };
      });

      if (get().initialized) return;
      const param = await apiClient.get<{ paramNm: keyof SearchParamProps; paramCtn: string }[]>(
        `/admin/menu/${MENU_ID}/search-conditions`
      );
      if (param.data.result?.length > 0) {
        const restored = param.data.result.reduce(
          (acc, curr) => {
            acc[curr.paramNm] = curr.paramCtn;
            return acc;
          },
          { ...get().searchParams }
        );
        set(state => {
          state.searchParams = restored;
        });
      }
      set(state => {
        state.initialized = true;
      });
    },

    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),
  };
}, 'project-route');
