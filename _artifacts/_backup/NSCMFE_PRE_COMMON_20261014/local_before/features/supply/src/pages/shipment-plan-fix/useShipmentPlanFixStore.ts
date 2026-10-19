import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, BUCKET_TYPE, MENU_ID, SHEETS } from './shipment-plan-fix.constants';
import type { SearchCondition } from './shipment-plan-fix.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

type StaticColumnsBySheet = {
  [SHEETS.MAIN]: RawFlexGridColumnConfig[];
};

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // admin SCM_MST_SHEET_COLUMNS('Shipment Plan Fix') 동적 fetch (ui-dynamic-property-management §2.3). 20행 등록 확인.
  staticColumns: StaticColumnsBySheet;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setDivision: (divisionId: string) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
}

const initSearch: SearchCondition = {
  // 기본 division = 세션 division(권한 division 첫 행 근사). Form 이 콤보 옵션과 대조해 교정.
  divisionId: useSessionStore.getState().session.div ?? '',
  operationGroupId: '',
  electrodeTypes: [],
  bucket: BUCKET_TYPE.DAILY,
  fromYyyymmdd: '',
  toYyyymmdd: '',
  chkSum: false,
  itemId: '',
};

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.MAIN]: [],
};

const initState: State = {
  initialized: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  staticColumns: emptyStaticColumns,
};

// 다중 선택 배열 → SP 파라미터 문자열. 빈 값은 '' 로 전송해 GET SP 무필터 분기를 태운다('ALL' 센티널 금지 —
//   자매 SCP0024 combo-optional-param-omit-safe-empty-null · scp0020-all-sentinel 실사고 동형).
const joinOrEmpty = (arr: string[]): string => arr.join(',');
const orEmpty = (v: string): string => (v && v.trim() ? v.trim() : '');
const str = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

export const useShipmentPlanFixStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // division 변경 = 하위 cascade 초기화(design 02 §3 E1) + 그리드 clear(hook #5). opGroup/electrode 리셋.
    //   기간(from/to)은 유지한다 — AS-IS CboDivision_SelectedIndexChanged(cs L436-444)는 operation group 콤보와
    //   btnWLast 텍스트만 갱신하고 dCalendar 기간은 건드리지 않는다(GetLastRange 는 btnWLast 라벨용). 초기 기간은
    //   mount 시 Page effect 가 한 번 시드하므로(빈 그리드 방지, GAP-02) division 변경 때 기간을 비울 필요가 없다.
    //   (iter gap-resolve: 종전 from/to 리셋은 "AS-IS E1 이 dCalendar 재세팅" 이라는 오독 근거였음 — .cs 로 반증.)
    setDivision: divisionId =>
      set(state => {
        state.searchCondition = {
          ...get().searchCondition,
          divisionId,
          operationGroupId: '',
          electrodeTypes: [],
        };
        state.filters = {}; // 그리드 데이터 clear (design 02 §3 — division 변경=그리드 초기화)
      }),
    // 메인 GET 파라미터 매핑 (PROC_M COL_NM 실측, ora.py 2026-09-24 — SP IN 순번 주석).
    //   mnuId(7)/sheetName(8)/sesUserId(9) 는 call-proc 엔벨로프·@LoginUser 로 BE 가 자동 주입 → FE 미전달(자매 SCP0024 동형).
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: orEmpty(c.divisionId), // 1 divisionId (단일)
            bizType: orEmpty(c.operationGroupId), // 2 bizType = Operation Group (단일)
            itemId: str(c.itemId), // 3 itemId (빈값=무필터, 콤마 다건)
            fromYyyymmdd: c.fromYyyymmdd.replace(/-/g, ''), // 4 fromYyyymmdd
            toYyyymmdd: c.toYyyymmdd.replace(/-/g, ''), // 5 toYyyymmdd
            electype: joinOrEmpty(c.electrodeTypes), // 6 electype (다중 콤마, 빈값=무필터)
            debugMode: 'F', // 10 debugMode
          },
        };
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
    // admin SCM_MST_SHEET_COLUMNS('Shipment Plan Fix') 동적 fetch — 미등록/실패 시 빈 배열(그리드 constants fallback).
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? SHEETS.MAIN,
        });
        const next = res.data.result ?? [];
        if (next.length > 0) {
          set(state => {
            if (JSON.stringify(state.staticColumns[SHEETS.MAIN]) !== JSON.stringify(next)) {
              state.staticColumns[SHEETS.MAIN] = next;
            }
          });
        }
      } catch {
        // 미등록/실패 = constants fallback (console 금지 룰)
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'shipment-plan-fix-store'
);
