import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './validation-shipment-result.constants';
import type { SearchParams } from './validation-shipment-result.types';

// SP filter payload — useTabProcQuery enabled 가드(setFilters 로 참조 교체 시에만 발사).
//   키명 = SP IN 파라미터 대응(주석). PROC_M 등록은 convert-sp 소관(PKG_SCM0014 미배포).
type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

interface State {
  initialized: boolean;
  isOpenSearchArea: boolean;
  searchParams: SearchParams;
  filters: FiltersBySheet;
  staticColumns: RawFlexGridColumnConfig[];
  // Division 권한 게이트(R1, cs:142~143) — MyDivision 결과 0건. Form 이 콤보 조회로 판정해 기록,
  //   page 가 조회 액션(SubTitle search hotkey) 차단에 사용(usrLayoutControl2 Enabled=false 대응).
  noDivisionAuth: boolean;
}

interface Action {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (params: Partial<SearchParams>) => void;
  setFilters: () => void;
  clearFilters: () => void;
  setNoDivisionAuth: (value: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
}

// Result Date 기본값 — AS-IS GetDayRange(cs:160~170) = 어제 ~ 1개월 전(GET_DATE_RANGE_YESTERDAY_BEFORE_1MONTH).
//   To=어제, From=어제로부터 1개월 전. 로컬 dayjs 계산(toISOString UTC 금지, nscm-patterns §5-12).
const yesterday = dayjs().subtract(1, 'day');
const initState: State = {
  initialized: false,
  isOpenSearchArea: true,
  searchParams: {
    divisionId: '', // 단일 콤보 — 옵션 로드 후 첫 권한 Division 자동선택(Form, AS-IS 바인딩 첫 행)
    plantSiteId: '',
    salesSiteId: '',
    projectCode: '',
    itemId: '',
    resultType: '', // 단일, ALL 없음 — 미선택 허용(AS-IS 필수 아님)
    fromYyyymmdd: yesterday.subtract(1, 'month').format('YYYYMMDD'),
    toYyyymmdd: yesterday.format('YYYYMMDD'),
  },
  filters: {},
  staticColumns: [],
  noDivisionAuth: false, // 콤보 미조회 상태 기본 허용(divisions undefined 동안 조회 미차단)
};

export const useValidationShipmentResultStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setOpenSearchArea: open =>
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      }),
    // Division 변경 = 조회 결과 그리드 비움(R6, design 02 §3 — 재조회 종속 no-op 이나 표준 clearFilters).
    //   읽기전용이라 CRUD/신규행 reset 대상 없음. 데이터 재조회는 Search 로만.
    setSearchParams: params =>
      set(state => {
        const prev = get().searchParams;
        state.searchParams = { ...prev, ...params };
        if (params.divisionId !== undefined && params.divisionId !== prev.divisionId) {
          state.filters = {};
        }
      }),
    // 조회조건 → SP payload(8-IN). refetch 직접호출 금지 — filters 참조 교체로만 발사(nscm-patterns §5-1).
    setFilters: () =>
      set(state => {
        const c = get().searchParams;
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: c.divisionId, // p_division_id (단일)
            plantSiteId: c.plantSiteId, // p_plant_site_id (텍스트, SP LIKE %..%)
            salesSiteId: c.salesSiteId, // p_sales_site_id (텍스트, SP LIKE %..%)
            projectCode: c.projectCode, // p_project_code (콤마 다중)
            itemId: c.itemId, // p_item_id (콤마 다중)
            fromYyyymmdd: c.fromYyyymmdd, // p_from_yyyymmdd
            toYyyymmdd: c.toYyyymmdd, // p_to_yyyymmdd
            resultType: c.resultType, // p_result_type (I/C/B)
          } as never,
        };
      }),
    // mount 시 이전 filters cache 무효화 — incomplete payload 자동 발사 회피(nscm-patterns §5-7).
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    setNoDivisionAuth: value =>
      set(state => {
        state.noDivisionAuth = value;
      }),
    // 컬럼 메타 동적 fetch — SCM_MST_SHEET_COLUMNS(admin) 변경 즉시 반영(ui-category hook, 하드코딩 금지).
    //   단일 컬럼셋('Validation Shipment Rsult', VALID='Y' 23행 + 2단 헤더 SMALL_CLASS 메타 구동).
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] }
        );
        set(state => {
          state.staticColumns = res.data.result ?? [];
          state.initialized = true;
        });
      } catch {
        // BE 메타 미등록 시 화면 미파손 silent fallback(console 금지 룰)
      }
    },
  }),
  'validation-shipment-result'
);
