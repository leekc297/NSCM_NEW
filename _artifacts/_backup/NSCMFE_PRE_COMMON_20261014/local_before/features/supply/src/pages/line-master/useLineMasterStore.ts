import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

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
}

const initSearch: SearchCondition = {
  // 기본 사업부 = 세션 division (formation 표준). 없으면 '40' fallback (권한 목록 첫 항목으로 Form 이 교정).
  divisionId: useSessionStore.getState().session.div ?? '40',
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
        // 시트 전환 = cascade 공급 콤보(PlantSite/Line) 교체 + 하위 초기화 + 그리드/필터 리셋 (design 02 §3 시트분기).
        state.searchCondition = {
          ...get().searchCondition,
          mode,
          plantSiteIds: [],
          buildingIds: [],
          operationIds: [],
          lineIds: [],
        };
        state.filters = {};
      }),
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        if (c.mode === LINE_MODE.PLANT) {
          // SCP0002_GET_LINE_MASTER 입력 7개 (design 03 §4.2): division/scm_site/location/factory/operation/line/active_flag.
          state.filters = {
            [SHEETS.PLANT]: {
              divisionId: orAll(c.divisionId),
              scmSiteId: joinOrAll(c.plantSiteIds),
              locationId: 'ALL', // clbOperation(LocationGroup) 은 location 파라미터 아님 — GET 은 factory/operation 사용, location 은 전량
              factoryId: joinOrAll(c.buildingIds),
              operationId: joinOrAll(c.operationIds),
              lineId: joinOrAll(c.lineIds),
              activeFlag: orAll(c.valid),
            },
          };
        } else {
          // SCP0002_GET_LINE_MASTER_OSP 입력 4개 (design 03 §4.3): division/scm_site/line/valid_yn.
          state.filters = {
            [SHEETS.PACKER]: {
              divisionId: orAll(c.divisionId),
              scmSiteId: joinOrAll(c.plantSiteIds),
              lineId: joinOrAll(c.lineIds),
              validYn: orAll(c.valid),
            },
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
  }),
  'line-master-store'
);
