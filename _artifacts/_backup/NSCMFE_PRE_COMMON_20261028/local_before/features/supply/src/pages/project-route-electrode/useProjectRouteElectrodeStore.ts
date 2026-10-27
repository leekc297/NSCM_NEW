import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import {
  ALL_SENTINEL,
  COLUMN_SHEET_NAME,
  MENU_ID,
  RESPONSE_SET,
  SHEETS,
} from './project-route-electrode.constants';
import type { SearchParamProps } from './project-route-electrode.types';

type FiltersBySheet = {
  [key in SHEETS]?: ProcRequest<MENU_ID, key>;
};

interface ProjectRouteElectrodeState {
  initialized: boolean;
  filters: FiltersBySheet;
  searchParams: SearchParamProps;
  staticColumns: {
    [key in RESPONSE_SET]: RawFlexGridColumnConfig[];
  };
  openSearchArea: boolean;
}

interface ProjectRouteElectrodeAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  // Search(F5) — MAIN 조회 커밋. ALL sentinel(plantSite/validFlag)은 SP DBNull 치환(design/02 §2-4).
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
}

const initSearchParams = (): SearchParamProps => ({
  // Division 초기값은 빈 문자열 — Form 의 권한목록 교정형 effect 가 MyDivision 콤보 로드 후
  //   session.div 가 목록에 있으면 그 값, 없으면 목록 첫 행으로 채운다. MyDivision SQL 이
  //   ATTRIBUTE3<>'EE' + 권한 subquery 를 내재하므로 화면단 EE 필터가 불필요(design/02 §2-1).
  divisionId: '',
  plantSite: ALL_SENTINEL, // clbPlantSite ALL → SP NULL
  operationGroup: '', // cboOperationGroup 기본 미선택(전체)
  itemId: '',
  validFlag: ALL_SENTINEL, // cboValid ALL → SP NULL
});

const initState = (): ProjectRouteElectrodeState => ({
  initialized: false,
  filters: {
    [SHEETS.MAIN]: undefined,
  },
  searchParams: initSearchParams(),
  staticColumns: {
    [RESPONSE_SET.MAIN]: [],
  },
  openSearchArea: true,
});

export const useProjectRouteElectrodeStore = createPersistedStoreWithTab<
  ProjectRouteElectrodeState & ProjectRouteElectrodeAction
>((set, get) => {
  return {
    ...initState(),
    reset: () => set(initState()),

    setSearchParams: partial =>
      set(state => {
        const prev = get().searchParams;
        const next = { ...prev, ...partial };
        // Division 변경 = 하위 PlantSite 선택 리셋 의무(design/02 §3 cascade C1, nscm-patterns §5-5).
        //   조회 그리드는 setFilters 시점에 filters 로 재조회되므로 여기선 조회조건만 정리한다.
        if (partial.divisionId !== undefined && partial.divisionId !== prev.divisionId) {
          next.plantSite = ALL_SENTINEL;
        }
        state.searchParams = next;
      }),

    setFilters: () =>
      set(state => {
        const p = get().searchParams;
        // GET 파라미터(design/03 §4, P_GET_ProjectRoute_Electrode IN 7).
        //   ALL sentinel → 빈값(BE PROC 가 NULL 치환, design/02 §2-4). FROM/TO_YYYYMM 은
        //   AS-IS FindData 가 항상 "" 전송(design/03 §4) — 이 화면 조회조건에 기간 없음.
        state.filters[SHEETS.MAIN] = {
          divisionId: p.divisionId,
          plantSite: p.plantSite === ALL_SENTINEL ? '' : p.plantSite,
          operationGroup: p.operationGroup,
          itemId: p.itemId,
          fromYyyymm: '',
          toYyyymm: '',
          validFlag: p.validFlag === ALL_SENTINEL ? '' : p.validFlag,
        };
      }),

    // 컬럼 메타는 admin(SCM_MST_SHEET_COLUMNS)에서 동적 fetch(ui-category hook, 하드코딩 금지).
    //   sheetNm = DB SHEET_NAME(COLUMN_SHEET_NAME). Search 마다 + mount 1회 재조회(admin 즉시반영).
    //   measure fetch 불필요(design/03 §2 — PIVOT/measure 0건).
    fetchStaticColumns: async () => {
      const main = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        { sheetNm: COLUMN_SHEET_NAME[RESPONSE_SET.MAIN] }
      );
      set(state => {
        state.staticColumns = {
          [RESPONSE_SET.MAIN]: main.data.result,
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
}, 'project-route-electrode');
