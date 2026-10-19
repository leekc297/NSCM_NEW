import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import type { SHEETS } from './master-validation.constants';
import { MASTER_ADMIN_SHEET_NAME, MENU_ID } from './master-validation.constants';
import type { SearchParamProps } from './master-validation.types';

// detail(결과) 그리드 컬럼 메타 캐시 — 검증유형별 sheetNm 로 admin fetch(design 03 §5 #03).
type ColumnCache = Partial<Record<SHEETS, RawFlexGridColumnConfig[]>>;

interface MasterValidationState {
  searchParams: SearchParamProps;
  // 마스터 "Validation Info" 컬럼 메타(admin fetch — 하드코딩 금지, CLAUDE.md §2 체크3/4).
  //   QUERY/OPEN 액션셀 포함. mount 시 1회 fetch. detail 은 staticColumns 캐시에 sheetNm 별로 담는다.
  masterColumns: RawFlexGridColumnConfig[];
  staticColumns: ColumnCache;
  // 마스터 행 선택 시 CONSTRAINTS01 'Const:PlanGroup' 이면 PlanGroup 조건 잠금(design 01 §2-C R18).
  planGroupLocked: boolean;
  openSearchArea: boolean;
}

interface MasterValidationAction {
  setSearchParams: (params: Partial<SearchParamProps>) => void;
  // Division 변경 = PlanGroup 초기화 + 조회 리셋(그리드 초기화 의무, nscm-patterns §5-5).
  setDivision: (divisionId: string) => void;
  setPlanGroupLocked: (locked: boolean) => void;
  fetchMasterColumns: () => Promise<void>;
  fetchDetailColumns: (sheet: SHEETS, adminSheetName: string) => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
  reset: () => void;
}

// planGroupIds: [] = 전체(ALL) — SP payload p_plan_group_id='' 로 매핑(design 02 §4).
const initSearchParams: SearchParamProps = {
  divisionId: useSessionStore.getState().session.div ?? '',
  planGroupIds: [],
  itemId: '',
};

const initState: MasterValidationState = {
  searchParams: initSearchParams,
  masterColumns: [],
  staticColumns: {},
  planGroupLocked: false,
  openSearchArea: true,
} as const;

const fetchColumns = async (sheetNm: string): Promise<RawFlexGridColumnConfig[]> => {
  const res = await apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
    sheetNm,
  });
  return res.data.result ?? [];
};

export const useMasterValidationStore = createPersistedStoreWithTab<
  MasterValidationState & MasterValidationAction
>((set, get) => ({
  ...initState,
  setSearchParams: params =>
    set(state => {
      state.searchParams = { ...get().searchParams, ...params };
    }),
  setDivision: divisionId =>
    set(state => {
      // Division 변경 시 PlanGroup 은 전체(ALL=[])로 리셋 — cascade 재필터 + 조회 리셋.
      state.searchParams = { ...get().searchParams, divisionId, planGroupIds: [] };
    }),
  setPlanGroupLocked: locked =>
    set(state => {
      state.planGroupLocked = locked;
    }),
  fetchMasterColumns: async () => {
    // 마스터 "Validation Info" 메타 fetch(mount 1회). 이미 있으면 재조회 생략(정적 메타).
    if (get().masterColumns.length) return;
    const cols = await fetchColumns(MASTER_ADMIN_SHEET_NAME);
    set(state => {
      state.masterColumns = cols;
    });
  },
  fetchDetailColumns: async (sheet, adminSheetName) => {
    // 이미 캐시된 시트는 재조회 생략(정적 메타).
    if (get().staticColumns[sheet]?.length) return;
    const cols = await fetchColumns(adminSheetName);
    set(state => {
      state.staticColumns[sheet] = cols;
    });
  },
  setOpenSearchArea: open =>
    set(state => {
      state.openSearchArea = open ?? !state.openSearchArea;
    }),
  reset: () => set(initState),
}), 'master-validation');
