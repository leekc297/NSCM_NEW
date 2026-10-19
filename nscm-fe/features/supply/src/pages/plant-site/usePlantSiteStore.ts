import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { MENU_ID, SHEETS } from './plant-site.constants';
import { comboAllToNull, expandDivisionAll, textToNull } from './utils/plant-site.util';

// 조회조건(UI) — Division 다중('ALL' sentinel), Plant/Vendor·Plant Site 텍스트(AS-IS 패리티),
//   OSP·Active 콤보.
interface SearchParamProps {
  divisionId: string; // 다중 콤마 or 'ALL'
  plantVendor: string; // 자유 텍스트 — SP 가 PLANT_ID+PLANT_NAME UPPER LIKE 부분일치(design 02 §2-3)
  plantSite: string; // 자유 텍스트 — SP 가 SCM_SITE_ID+SITE_DESCRIPTION UPPER LIKE 부분일치(design 02 §2-3)
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
  plantVendor: '',
  plantSite: '',
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
        // AS-IS 파리티(사용자 결정 2026-10-01): Division 변경만으로는 그리드를 비우지 않는다.
        //   AS-IS 는 ClbDivision_SelectedIndexChanged 에서 셀 콤보 데이터소스만 갱신하고 메인/하위
        //   그리드는 유지한다(SCP0001_PlantSite.cs:1514~1516 SetChangedControl, InitSpread 없음).
        //   재조회는 Search 버튼으로만. (과거엔 TO-BE 규범 hook #5 로 division 변경=그리드 비움을
        //   적용했으나, 본 화면은 AS-IS 동작 유지로 변경 — design 02 §3 결정 기록.)
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
          // Division 은 'ALL' 을 그대로 보내지 않고 권한 division(EE 제외) 코드로 전개한다.
          //   GET SP 에 권한필터(@sesUserId)가 없어 'ALL'(UPPER(TRIM)='ALL') 이면 권한 무관 전체
          //   division 을 반환한다 → 제한 계정에서 권한 우회(design 02 §2-1, 실측 2026-10-06).
          divisionId: expandDivisionAll(sc.divisionId, auth),
          // 텍스트 조회조건 — 빈 입력은 null(SP IS NULL=전체), 입력값은 그대로(SP UPPER LIKE).
          plantId: textToNull(sc.plantVendor),
          scmSiteId: textToNull(sc.plantSite),
          // OSP/Active 는 'ALL' 을 그대로 보낸다 — SP 가 UPPER(TRIM)='ALL' 을 '필터 없음'으로 처리해
          //   null 과 결과 동일(실측 2026-10-06). 화면 표시(ALL)와 전송값을 일치시킨다(사용자 지시).
          ospYn: sc.ospYn || 'ALL',
          validYn: sc.validYn || 'ALL',
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
