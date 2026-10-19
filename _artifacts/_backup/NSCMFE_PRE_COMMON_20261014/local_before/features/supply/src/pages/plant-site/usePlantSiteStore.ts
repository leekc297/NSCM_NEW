import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { MENU_ID, SHEETS } from './plant-site.constants';
import { comboAllToNull, expandDivisionAll } from './utils/plant-site.util';

// 조회조건(UI) — Division·Plant Site 다중('ALL' sentinel), Plant/Vendor 텍스트, OSP·Active 콤보.
interface SearchParamProps {
  divisionId: string; // 다중 콤마 or 'ALL'
  plantVendor: string; // 다중 콤마 or 'ALL' — PlantVendorByDivision 콤보 선택값(CODE=PLANT_ID)
  plantSite: string; // 다중 콤마 or 'ALL' — SP 는 아직 단일 LIKE 계약(plant-site.plantSiteCombo.ts COMBO.PLANT_SITE 주석)
  ospYn: string; // 'ALL'/'Y'/'N' — 기본 ALL
  validYn: string; // 'ALL'/'Y'/'N' — 기본 Y
}

// 마스터 선택 행 컨텍스트 — sub 조회 파라미터 + location 셀콤보 comboParams + 편집잠금(OSP_YN) 원천.
interface SelectedSite {
  divisionId: string;
  scmSiteId: string;
  plantId: string;
  operationGroup: string;
  ospYn: string;
  // locationOsp 신규행 표시용 마스터 복사값(R-10, GS-073) — 저장 payload 에는 미포함.
  siteDescription: string;
}

type FiltersBySheet = {
  [key in SHEETS]?: ProcRequest<MENU_ID, key>;
};

type StaticColumnsBySheet = {
  [key in SHEETS]: RawFlexGridColumnConfig[];
};

interface PlantSiteState {
  initialized: boolean;
  filters: FiltersBySheet;
  searchParams: SearchParamProps;
  // Division_SCP(EE 제외) 권한 division 코드 — 조회 시 'ALL' 콤마 확장 원천(권한 함정 방지, design 02 §2-1).
  authDivisions: string[];
  selectedSite: SelectedSite | null;
  staticColumns: StaticColumnsBySheet;
  openSearchArea: boolean;
}

interface PlantSiteAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setAuthDivisions: (codes: string[]) => void;
  setPlantSiteFilters: () => void;
  setDetailContext: (site: SelectedSite | null) => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
}

const initSearchParams: SearchParamProps = {
  divisionId: 'ALL',
  plantVendor: 'ALL',
  plantSite: 'ALL',
  ospYn: 'ALL',
  validYn: 'Y',
};

const initState: PlantSiteState = {
  initialized: false,
  filters: {
    [SHEETS.SITE]: undefined,
    [SHEETS.LOCATION]: undefined,
    [SHEETS.CUSTOMER]: undefined,
    [SHEETS.LOCATION_OSP]: undefined,
  },
  searchParams: initSearchParams,
  authDivisions: [],
  selectedSite: null,
  staticColumns: {
    [SHEETS.SITE]: [],
    [SHEETS.LOCATION]: [],
    [SHEETS.CUSTOMER]: [],
    [SHEETS.LOCATION_OSP]: [],
    [SHEETS.VENDOR]: [],
  },
  openSearchArea: true,
} as const;

export const usePlantSiteStore = createPersistedStoreWithTab<PlantSiteState & PlantSiteAction>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),

    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
        // Division 변경 = 그리드 비움 의무(TO-BE 규범 — AS-IS 에 없던 동작, design 02 §3·§7).
        //   main+sub filters 초기화 + 마스터 선택 해제(CRUD 상태는 조회 재발사로 리셋).
        //   Plant Site/Plant Vendor 는 division cascade 콤보라 division 변경 시 이전 선택값이
        //   무의미해져 함께 리셋.
        if (searchParams.divisionId !== undefined) {
          state.filters = initState.filters;
          state.selectedSite = null;
          state.searchParams.plantSite = 'ALL';
          state.searchParams.plantVendor = 'ALL';
        }
      });
    },

    setAuthDivisions: codes =>
      set(state => {
        state.authDivisions = codes;
      }),

    // 조회 버튼 — searchParams -> site 조회 파라미터. ALL 은 권한 division 콤마 확장(null 금지).
    setPlantSiteFilters: () => {
      const sc = get().searchParams;
      const auth = get().authDivisions;
      set(state => {
        state.filters[SHEETS.SITE] = {
          divisionId: expandDivisionAll(sc.divisionId, auth),
          plantId: comboAllToNull(sc.plantVendor),
          scmSiteId: comboAllToNull(sc.plantSite),
          ospYn: comboAllToNull(sc.ospYn),
          validYn: comboAllToNull(sc.validYn),
          newYn: null,
        };
        // 조회 성공 시 하단은 비운 상태에서 시작(design 01 §2 참고절 — 매 조회 후 하단 리셋).
        state.filters[SHEETS.LOCATION] = undefined;
        state.filters[SHEETS.CUSTOMER] = undefined;
        state.filters[SHEETS.LOCATION_OSP] = undefined;
        state.selectedSite = null;
      });
    },

    // 마스터 행 더블클릭 — sub 3시트 row-context 로드(OSP_YN 에 따라 Location/OSP 배타, design 03 R-32).
    setDetailContext: site => {
      const sc = get().searchParams;
      const { userId, groupId } = useSessionStore.getState().session;
      set(state => {
        state.selectedSite = site;
        if (!site) {
          state.filters[SHEETS.LOCATION] = undefined;
          state.filters[SHEETS.CUSTOMER] = undefined;
          state.filters[SHEETS.LOCATION_OSP] = undefined;
          return;
        }
        const validYn = comboAllToNull(sc.validYn);
        // Customer 는 항상 로드. p_active_flag 는 'ALL'/'Y'/'N' 문자열 그대로(PKG 라인 288 허용).
        state.filters[SHEETS.CUSTOMER] = {
          divisionId: site.divisionId,
          scmSiteId: site.scmSiteId,
          activeFlag: sc.validYn,
          createdBy: userId ?? '',
          userGroup: groupId ?? '',
        };
        // OSP_YN='Y' 외주행이면 Location 은 빈 시트, 'N' 내주행이면 Location(OSP) 가 빈 시트.
        state.filters[SHEETS.LOCATION] =
          site.ospYn === 'Y'
            ? undefined
            : { divisionId: site.divisionId, scmSiteId: site.scmSiteId, validYn };
        state.filters[SHEETS.LOCATION_OSP] =
          site.ospYn === 'Y'
            ? { divisionId: site.divisionId, scmSiteId: site.scmSiteId, validYn }
            : undefined;
      });
    },

    // 컬럼 메타 4시트 fetch(mount + Search refetch — CLAUDE.md §2 체크 3, PIVOT 아님 → measure 불요).
    fetchStaticColumns: async () => {
      const fetchColumns = (sheetNm: SHEETS) =>
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, { sheetNm });

      const [site, location, customer, locationOsp] = await Promise.all([
        fetchColumns(SHEETS.SITE),
        fetchColumns(SHEETS.LOCATION),
        fetchColumns(SHEETS.CUSTOMER),
        fetchColumns(SHEETS.LOCATION_OSP),
      ]);

      set(state => {
        state.staticColumns[SHEETS.SITE] = site.data.result;
        state.staticColumns[SHEETS.LOCATION] = location.data.result;
        state.staticColumns[SHEETS.CUSTOMER] = customer.data.result;
        state.staticColumns[SHEETS.LOCATION_OSP] = locationOsp.data.result;
      });

      if (get().initialized) return;

      const param = await apiClient.get<{ paramNm: keyof SearchParamProps; paramCtn: string }[]>(
        `/admin/menu/${MENU_ID}/search-conditions`
      );
      if (param.data.result?.length > 0) {
        const restored = param.data.result.reduce((acc, curr) => {
          acc[curr.paramNm] = curr.paramCtn;
          return acc;
        }, {} as SearchParamProps);
        set(state => {
          state.searchParams = { ...get().searchParams, ...restored };
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
  }),
  'plant-site'
);
