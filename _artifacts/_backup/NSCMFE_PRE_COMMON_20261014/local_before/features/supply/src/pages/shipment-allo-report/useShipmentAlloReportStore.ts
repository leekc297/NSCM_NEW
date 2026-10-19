import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { FIXED_SEARCH, MENU_ID } from './shipment-allo-report.constants';
import type { SearchCondition } from './shipment-allo-report.types';

// admin SCM_MST_SHEET_COLUMNS 실측 SHEET_NAME(design 03 §0 — Main/Gap 탭 공유 1종).
const ADMIN_SHEET_NAME = 'Shipment(Allo) Report';

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  openSearchArea: boolean;
  // 조회 실행 시점 스냅샷 — useTabProcQuery filters(Main/Gap 각각 기준일만 다름, design 02 §3).
  mainFilter?: ProcRequest<MENU_ID, 'main'>;
  gapFilter?: ProcRequest<MENU_ID, 'main'>;
  // 편집모드 — 조회 직후 항상 false(전체 잠금, design 01 §2 #17). EditButton 클릭으로만 true.
  editable: boolean;
  staticColumns: RawFlexGridColumnConfig[];
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setOpenSearchArea: (open?: boolean) => void;
  runSearch: (userId: string) => void;
  clearFilters: () => void;
  setEditable: (v: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
}

const makeInitSearch = (): SearchCondition => ({
  divisionId: FIXED_SEARCH.DIVISION_ID,
  operationGroup: FIXED_SEARCH.OPERATION_GROUP,
  bucketType: FIXED_SEARCH.BUCKET_TYPE,
  cellTypeGr: FIXED_SEARCH.CELL_TYPE_GR,
  team: '',
  fromSite: '',
  fcstYn: false,
  planDate: '',
  gapDate: '',
  fromYyyymm: '',
  toYyyymm: '',
  itemId: '',
  nickName: '',
});

const makeInitState = (): State => ({
  initialized: false,
  searchCondition: makeInitSearch(),
  openSearchArea: true,
  editable: false,
  staticColumns: [],
});

const toMmddFirstDay = (yyyymm: string): string => (yyyymm ? `${yyyymm}01` : '');
const toMmddLastDay = (yyyymm: string): string => {
  if (!yyyymm || yyyymm.length !== 6) return '';
  const y = Number(yyyymm.slice(0, 4));
  const m = Number(yyyymm.slice(4, 6));
  const lastDay = new Date(Date.UTC(y, m, 0)).getUTCDate();
  return `${yyyymm}${String(lastDay).padStart(2, '0')}`;
};

export const useShipmentAlloReportStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...makeInitState(),
    reset: () => set(makeInitState()),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),
    // 조회(Search) 실행 — Main/Gap 각각 기준일(PlanDate/GapDate)만 다른 동일 파라미터 세트(design 02 §3).
    // 조회 성공 시 그리드 전체 재잠금(design 01 §2 #17) — editable 을 여기서 false 로 리셋한다.
    runSearch: userId => {
      const c = get().searchCondition;
      const base = {
        divisionId: c.divisionId,
        bizType: c.operationGroup,
        cellTypeGr: c.cellTypeGr,
        fromYyyymmdd: toMmddFirstDay(c.fromYyyymm),
        toYyyymmdd: toMmddLastDay(c.toYyyymm),
        fromsite: c.fromSite,
        teamId: c.team,
        itemId: c.itemId,
        nickname: c.nickName,
        programId: MENU_ID,
        sheetName: ADMIN_SHEET_NAME,
        userId,
        fcstYn: c.fcstYn ? 'Y' : 'N',
        debugMode: 'N',
      };
      set(state => {
        state.mainFilter = { ...base, planStartYyyymmdd: c.planDate };
        state.gapFilter = { ...base, planStartYyyymmdd: c.gapDate };
        state.editable = false;
      });
    },
    clearFilters: () =>
      set(state => {
        state.mainFilter = undefined;
        state.gapFilter = undefined;
      }),
    // EditButton — fps(조회 결과) 존재 시에만 토글하는 가드는 화면(Page)이 담당(design 01 §2 #14).
    setEditable: v =>
      set(state => {
        state.editable = v;
      }),
    // admin SCM_MST_SHEET_COLUMNS 동적 fetch(6칼럼, design 03 §1.1) — 미등록/실패 시 빈 배열.
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: ADMIN_SHEET_NAME,
          divisionId: get().searchCondition.divisionId,
        });
        set(state => {
          state.staticColumns = res.data.result ?? [];
          state.initialized = true;
        });
      } catch {
        // 미등록/실패 = 빈 배열(console 금지 룰)
      }
    },
  }),
  'shipment-allo-report-store'
);
