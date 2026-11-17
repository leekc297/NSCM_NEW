import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, ALL, MENU_ID, SHEETS } from './validation-shipment-result.constants';
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
  // 개인화 조회조건 복원 1회 가드 (SubTitle F6 저장분 mount 복원 — 저장만 있고 복원 누락 방지, basic-check #3).
  conditionsRestored: boolean;
}

interface Action {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (params: Partial<SearchParams>) => void;
  setDivision: (divisionId: string) => void;
  setFilters: () => void;
  clearFilters: () => void;
  setNoDivisionAuth: (value: boolean) => void;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchParams 패치(1회).
  restoreSearchConditions: () => Promise<void>;
  fetchStaticColumns: () => Promise<void>;
}

// Result Date 기본값 — AS-IS GetDayRange(cs:160~170 → SP GET_DATE_RANGE_YESTERDAY_BEFORE_1MONTH).
//   SP 명은 "1MONTH" 이나 실제 SQL(SCM.foxml) 은 From/To 둘 다 DATEADD(DAY,-1) = 어제로 반환(이름이 거짓).
//   From=To=어제. 로컬 dayjs 계산(toISOString UTC 금지, nscm-patterns §5-12).
const yesterday = dayjs().subtract(1, 'day');
const initState: State = {
  initialized: false,
  isOpenSearchArea: true,
  searchParams: {
    divisionId: '', // 단일 콤보 — 옵션 로드 후 첫 권한 Division 자동선택(Form, AS-IS 바인딩 첫 행)
    plantSiteId: ALL, // Plant Site(BOD From Site, 다중+ALL) — 기본 ALL(무필터), division 변경 시 ALL 리셋
    salesSiteId: ALL, // Sales Site(BOD To Site, 다중+ALL) — 기본 ALL
    projectCode: '',
    itemId: '',
    resultType: '', // 단일, ALL 없음 — 옵션 로드 후 첫 값(I) 자동선택(Form, AS-IS 바인딩 첫 행)
    fromYyyymmdd: yesterday.format('YYYYMMDD'),
    toYyyymmdd: yesterday.format('YYYYMMDD'),
  },
  filters: {},
  staticColumns: [],
  noDivisionAuth: false, // 콤보 미조회 상태 기본 허용(divisions undefined 동안 조회 미차단)
  conditionsRestored: false,
};

export const useValidationShipmentResultStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setOpenSearchArea: open =>
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      }),
    setSearchParams: params =>
      set(state => {
        state.searchParams = { ...get().searchParams, ...params };
      }),
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division·기간(from/to)을 제외한 검색조건을 전부 초기화하고
    //   그리드도 초기화(filters clear)한다(사용자 지시 2026-10-02 — TO-BE 공통 요건이 AS-IS 핸들러보다 우선, SCP0025 정본).
    //   유지: divisionId(새 값) + fromYyyymmdd/toYyyymmdd(어제 기본 기간). 초기화: plantSiteId/salesSiteId(→ALL)
    //   /projectCode/itemId/resultType(→initState 기본, Form 효과가 첫 옵션 재선택). 읽기전용이라 CRUD/신규행 reset
    //   대상 없음, 데이터 재조회는 Search 로만. 편집중(dirty) 확인 가드(MSG00704)는 Form 의 onChange 가
    //   confirmIfDirtyKey 로 처리한다(commit 51d4e9fa 패턴) — 이 화면은 read-only 라 실제 dirty 는 없지만 공통 패턴을 따른다.
    setDivision: divisionId =>
      set(state => {
        const cur = get().searchParams;
        state.searchParams = {
          ...initState.searchParams, // Division·기간 제외 전 조건 초기화(plant/sales/project/item/resultType)
          divisionId,
          fromYyyymmdd: cur.fromYyyymmdd,
          toYyyymmdd: cur.toYyyymmdd,
        };
        state.filters = {}; // 그리드 초기화 — 재조회(Search) 전까지 빈 상태
      }),
    // 조회조건 → SP payload(8-IN). refetch 직접호출 금지 — filters 참조 교체로만 발사(nscm-patterns §5-1).
    setFilters: () =>
      set(state => {
        const c = get().searchParams;
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: c.divisionId, // p_division_id (단일)
            plantSiteId: c.plantSiteId, // p_plant_site_id (BOD From Site 다중 콤마 코드/ALL)
            salesSiteId: c.salesSiteId, // p_sales_site_id (BOD To Site 다중 콤마 코드/ALL)
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
    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 형제 SCP0039(master-validation) 파리티.
    //   GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 역직렬화. 이 화면 조회조건은 전부
    //   문자열(plantSite/salesSite 는 다중이지만 CSV 문자열로 저장/사용 — setDivision 참조) 이라 배열 split 불요.
    //   기간(from/to)은 저장 SP 가 EXCLUDED_DATE_PARAM 로 제외하므로 복원 대상에도 없음(initState 기본 유지).
    //   setDivision/setSearchParams 경유 금지(cascade·초기화 side-effect 회피) — searchParams 직접 병합.
    //   저장분 없으면 기본값 유지. 새로고침/재진입 시 createPersistedStoreWithTab 이 새 store(가드 false) → 재복원.
    restoreSearchConditions: async () => {
      if (get().conditionsRestored) return;
      set(state => {
        state.conditionsRestored = true;
      });
      try {
        const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        const rows = res.data.result ?? [];
        if (rows.length === 0) return;
        const patch: Partial<SearchParams> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in initState.searchParams)) continue;
          patch[paramNm as keyof SearchParams] = paramCtn ?? '';
        }
        set(state => {
          state.searchParams = { ...state.searchParams, ...patch };
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지 룰)
      }
    },
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
