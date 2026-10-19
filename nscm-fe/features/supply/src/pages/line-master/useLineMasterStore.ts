import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, LINE_MODE, MENU_ID, SHEETS } from './line-master.constants';
import type { SearchCondition } from './line-master.types';

type FiltersBySheet = {
  [SHEETS.PLANT]?: ProcRequest<MENU_ID, SHEETS.PLANT>;
  [SHEETS.PACKER]?: ProcRequest<MENU_ID, SHEETS.PACKER>;
};

type StaticColumnsBySheet = {
  [SHEETS.PLANT]: RawFlexGridColumnConfig[];
  [SHEETS.PACKER]: RawFlexGridColumnConfig[];
};

interface State {
  initialized: boolean;
  // 개인화 조회조건 복원 1회 가드 (SubTitle F6 저장분 mount 복원 — initialized 는 컬럼 fetch 전용이라 별도).
  conditionsRestored: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // MyDivision 권한 사업부 0건 잠금 (AS-IS SCP0002_LineMaster.cs:142-143 SetDivisionAuthCheck →
  //   usrLayoutControl2.Enabled=false). 권한 콤보를 소유한 LineMasterForm 이 실측 후 설정하고,
  //   검색 진입점(LineMaster.handleSearch)이 이 값으로 조회를 차단한다(전 시트 공통 단일 소스).
  authLocked: boolean;
  // ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch (미등록 시 빈 배열 →
  //   그리드가 constants 컬럼셋으로 fallback). design 03 §6-3 실측: Plant 17 / Packer 9 등록됨.
  staticColumns: StaticColumnsBySheet;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setMode: (mode: LINE_MODE) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setAuthLocked: (locked: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchCondition 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

// 개인화 조건 복원 시 배열 역직렬화 키(SubTitle F6 저장은 배열=콤마join 평문화 — personalizeCondition).
const ARRAY_KEYS = new Set<string>(['plantSiteIds', 'buildingIds', 'operationIds', 'lineIds']);

const initSearch: SearchCondition = {
  // 기본 사업부 = 빈값. AS-IS(InitControls src 136)는 권한목록(MyDivision) 첫 항목을 기본 선택하므로
  //   세션 division 바이어스 없이 Form 이 콤보 로드 후 첫 division 으로 세팅한다(AS-IS 매 오픈 시 첫 항목).
  divisionId: '',
  plantSiteIds: [],
  buildingIds: [],
  operationIds: [],
  lineIds: [],
  valid: 'ALL', // cboValid 기본 "전체" (design 02 §4 cboValid 기본값)
  mode: LINE_MODE.PLANT, // 초기 활성 = Plant 시트 (design 03 §화면구조전제, cs:228)
};

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.PLANT]: [],
  [SHEETS.PACKER]: [],
};

const initState: State = {
  initialized: false,
  conditionsRestored: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  // 초기 미잠금 — 권한 콤보 로드 후 LineMasterForm 이 재판정해 덮어쓴다(로드 전 오검색 방지).
  authLocked: false,
  staticColumns: emptyStaticColumns,
};

// 다중 선택 배열 -> SP 파라미터 문자열 (빈 배열 = 'ALL' 센티널). 단일 값 = 공백이면 'ALL'.
const joinOrAll = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join(','));
const orAll = (v: string): string => (v && v.trim() ? v.trim() : 'ALL');

export const useLineMasterStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    setMode: mode =>
      set(state => {
        // 시트 전환(Plant/Packer)은 활성 시트만 바꾸고 조회조건·그리드는 초기화하지 않는다(사용자 요청).
        //   공급 콤보(PlantSite/Line)는 mode 로 SQL_ID 가 갈려 자동 교체되고, 그리드는 시트별 filters 로
        //   각각 유지된다(이전 검색 결과 보존). division 등 선택값도 그대로 둔다.
        state.searchCondition.mode = mode;
      }),
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        // 활성 시트의 filters 만 갱신하고 반대 시트 filters 는 보존한다 — Plant/Packer 는 각각
        //   독립 조회되며, 한쪽 조회가 다른 쪽을 초기화하면 안 된다(filters 객체 통째 교체 금지).
        if (c.mode === LINE_MODE.PLANT) {
          // SCP0002_GET_LINE_MASTER 입력 7개 (design 03 §4.2): division/scm_site/location/factory/operation/line/active_flag.
          state.filters[SHEETS.PLANT] = {
            divisionId: orAll(c.divisionId),
            scmSiteId: joinOrAll(c.plantSiteIds),
            locationId: 'ALL', // clbOperation(LocationGroup) 은 location 파라미터 아님 — GET 은 factory/operation 사용, location 은 전량
            factoryId: joinOrAll(c.buildingIds),
            operationId: joinOrAll(c.operationIds),
            lineId: joinOrAll(c.lineIds),
            activeFlag: orAll(c.valid),
          };
        } else {
          // SCP0002_GET_LINE_MASTER_OSP 입력 4개 (design 03 §4.3): division/scm_site/line/valid_yn.
          state.filters[SHEETS.PACKER] = {
            divisionId: orAll(c.divisionId),
            scmSiteId: joinOrAll(c.plantSiteIds),
            lineId: joinOrAll(c.lineIds),
            validYn: orAll(c.valid),
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
    setAuthLocked: locked =>
      set(state => {
        state.authLocked = locked;
      }),

    // admin SCM_MST_SHEET_COLUMNS 동적 fetch — 미등록/실패 시 빈 배열 유지(그리드 constants fallback).
    //   'Line Master' 중복 sheetNm 은 제외 — Plant/Packer 2종만 fetch (design 03 §화면구조전제).
    fetchStaticColumns: async () => {
      const sheets: (keyof StaticColumnsBySheet)[] = [SHEETS.PLANT, SHEETS.PACKER];
      const divisionId = get().searchCondition.divisionId;
      await Promise.all(
        sheets.map(async sheet => {
          try {
            const res = await apiClient.post<RawFlexGridColumnConfig[]>(
              `/admin/menu/${MENU_ID}/column`,
              { sheetNm: ADMIN_SHEET_NAME[sheet], divisionId }
            );
            const next = res.data.result ?? [];
            if (next.length === 0) return;
            set(state => {
              if (JSON.stringify(state.staticColumns[sheet]) !== JSON.stringify(next)) {
                state.staticColumns[sheet] = next;
              }
            });
          } catch {
            // 미등록/실패 = constants fallback (console 금지 룰)
          }
        })
      );
      set(state => {
        state.initialized = true;
      });
    },

    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 형제 화면 파리티.
    //   GET /admin/menu/{MENU_ID}/search-conditions → PRAM_NM/PRAM_CTN 역직렬화(배열 split, 나머지 그대로).
    //   저장분 없으면 기본값 유지.
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
        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in initSearch)) continue;
          const val = paramCtn ?? '';
          patch[paramNm] = ARRAY_KEYS.has(paramNm) ? (val ? val.split(',').filter(Boolean) : []) : val;
        }
        set(state => {
          state.searchCondition = { ...state.searchCondition, ...patch } as SearchCondition;
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지)
      }
    },
  }),
  'line-master-store'
);
