// SCP0125 Workbench 스토어 — UI 상태 + 조회조건만 보유한다. 서버 데이터는 React Query(SSOT)가
//   들고 있다(convert-core §2.4). 접근은 객체 destructuring 없이 개별 selector.
//
// searchParams(입력 중) / filters(발사된 조건)를 분리하는 것이 규약이다 — 조회 버튼이 setFilters 로
//   새 참조를 만들 때만 `useTabProcQuery` 가 발사된다(`refetch()` 직접 호출 금지, nscm-patterns §5-1).
//
// AS-IS 근거: cs:186~226(InitControls) · cs:1991~2005(E01/E02 Division·PlanDate 변경) ·
//             cs:619(조회마다 SetVisibleSheetColumns) · cs:1997·2004(ClearDataSource = 5시트 비움)

import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import type { DataSheet } from './workbench.constants';
import { ADMIN_SHEET_NAME, MENU_ID, TAB_ORDER, TABS } from './workbench.constants';
import type { WorkbenchSearchParams } from './workbench.types';

type FiltersBySheet = {
  [K in DataSheet]?: ProcRequest<MENU_ID, K>;
};

interface WorkbenchState {
  initialized: boolean;
  searchParams: WorkbenchSearchParams;
  /** 시트별 발사 조건. 탭마다 독립이라 다른 탭 결과는 그대로 유지된다(V26/V27 lazy fetch). */
  filters: FiltersBySheet;
  /** 탭별 admin 컬럼 메타(5 ADMIN_SHEET_NAME). mount 1회 + Search 마다 refetch(G08). */
  staticColumns: Record<TABS, RawFlexGridColumnConfig[]>;
  activeTab: TABS;
  // 편집모드 상태는 두지 않는다 — convert-core §2.4 규범(편집 기본 ON, 권한은 화면 오픈 시 1회).
  //   AS-IS 모드토글(`siMain.IsLock` / `override EditButton`)은 미이식이며 화면은 `hasButton('EDIT')`
  //   1개(`canEdit`)만 본다. 판정 근거는 goal.md §8 · design/04_react-gap.md.
  openSearchArea: boolean;
  /** Division 권한 0건 alert 를 1회만 띄우기 위한 플래그(R01). */
  authAlerted: boolean;
}

interface WorkbenchAction {
  reset: () => void;
  setSearchParams: (params: Partial<WorkbenchSearchParams>) => void;
  /** 활성 탭의 조회조건을 커밋한다. `planStartYyyymmdd`·`versionNo` 는 화면이 위젯/탭 규칙으로 확정해 넘긴다. */
  setFilters: (sheet: DataSheet, planStartYyyymmdd: string, versionNo: string) => void;
  /** Division·PlanDate 변경 시 5탭 전부 비움(R05·R06 = AS-IS ClearDataSource). */
  clearFilters: () => void;
  setActiveTab: (tab: TABS) => void;
  setOpenSearchArea: (open?: boolean) => void;
  markAuthAlerted: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const EMPTY_COLUMNS: Record<TABS, RawFlexGridColumnConfig[]> = {
  [TABS.MKT_FCST]: [],
  [TABS.STOCK]: [],
  [TABS.STOCK_ELEC]: [],
  [TABS.ELEC_DEMAND]: [],
  [TABS.STOCK_2ND_OCV]: [],
};

const initSearchParams: WorkbenchSearchParams = {
  // 기본 선택값은 콤보 첫 행이다 — 세션 division 을 끼워넣지 않는다(02 §4.2 W04).
  divisionId: '',
  planStartYyyymmdd: '',
  planDateDaily: '',
  versionNo: '',
  nickName: '',
  itemId: '',
};

const initState: WorkbenchState = {
  initialized: false,
  searchParams: initSearchParams,
  filters: {},
  staticColumns: EMPTY_COLUMNS,
  activeTab: TABS.MKT_FCST,
  openSearchArea: true,
  authAlerted: false,
};

export const useWorkbenchStore = createPersistedStoreWithTab<WorkbenchState & WorkbenchAction>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),

    setSearchParams: params => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...params };
      });
    },

    // 키명 = `SCM_ADM_PROC_M.COL_NM` 실측 camelCase(snake `p_` 접두로 보내면 NULL 바인딩된다 —
    //   메모리 `scp-proc-m-colnm-is-camelcase`). 각 줄의 번호는 SP IN 순번이다.
    setFilters: (sheet, planStartYyyymmdd, versionNo) => {
      set(state => {
        const params = get().searchParams;
        state.filters[sheet] = {
          divisionId: params.divisionId, // 1
          planStartYyyymmdd, // 2 (주단위 콤보 또는 일단위 DatePicker — 화면이 위젯 규칙으로 확정)
          versionNo, // 3 MKT FCST 탭만 값, 그 외 '' (W12)
          nickName: params.nickName.trim(), // 4 Trim only (대소문자 변환 없음, W20)
          itemId: params.itemId.trim(), // 5 Trim only
        };
      });
    },

    clearFilters: () => {
      set(state => {
        state.filters = {};
      });
    },

    setActiveTab: tab => {
      set(state => {
        state.activeTab = tab;
      });
    },

    setOpenSearchArea: open => {
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      });
    },

    markAuthAlerted: () => {
      set(state => {
        state.authAlerted = true;
      });
    },

    // admin 컬럼 메타 — 5 sheetNm 동시 조회. division 별 분기는 없다
    //   (`SCM_MST_SHEET_COLUMNS.DIVISION_ID` 102행 전건 NULL — 03 §6 U10). division 조건부 표시는
    //   `utils/workbench.columns.ts` 가 폭 0 으로 재현한다.
    fetchStaticColumns: async () => {
      const responses = await Promise.all(
        TAB_ORDER.map(tab =>
          apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
            sheetNm: ADMIN_SHEET_NAME[tab],
          })
        )
      );
      set(state => {
        TAB_ORDER.forEach((tab, index) => {
          state.staticColumns[tab] = responses[index].data.result ?? [];
        });
        state.initialized = true;
      });
    },
  }),
  'workbench'
);
