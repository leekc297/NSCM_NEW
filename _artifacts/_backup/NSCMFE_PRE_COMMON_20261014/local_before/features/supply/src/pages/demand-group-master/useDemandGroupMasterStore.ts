import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS } from './demand-group-master.constants';
import type { SearchParams } from './demand-group-master.types';

type FiltersBySheet = {
  [K in SHEETS]?: ProcRequest<MENU_ID, K>;
};

interface DemandGroupMasterState {
  initialized: boolean;
  filters: FiltersBySheet;
  searchParams: SearchParams;
  staticColumns: Record<SHEETS, RawFlexGridColumnConfig[]>;
  openSearchArea: boolean;
}

interface DemandGroupMasterAction {
  reset: () => void;
  setSearchParams: (params: Partial<SearchParams>) => void;
  // Search 버튼 — 두 그리드 조회조건을 한 번에 발사(참조 교체). groupId 는 전체(빈값).
  setFilters: () => void;
  // master 더블클릭 — 선택 그룹으로 Model List 만 재조회.
  setModelListFilter: (groupId: string) => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
}

const initSearchParams: SearchParams = {
  divisionId: '',
  operationGroup: '',
  groupName: '',
  projectId: '',
  itemId: '',
};

const initState: DemandGroupMasterState = {
  initialized: false,
  filters: {
    [SHEETS.GROUP_NAME]: undefined,
    [SHEETS.MODEL_LIST]: undefined,
  },
  searchParams: initSearchParams,
  staticColumns: {
    [SHEETS.GROUP_NAME]: [],
    [SHEETS.MODEL_LIST]: [],
  },
  openSearchArea: true,
};

export const useDemandGroupMasterStore = createPersistedStoreWithTab<
  DemandGroupMasterState & DemandGroupMasterAction
>((set, get) => ({
  ...initState,
  reset: () => set(initState),

  setSearchParams: params => {
    set(state => {
      state.searchParams = { ...get().searchParams, ...params };
      // Division 변경 = 그리드 초기화 의무(nscm-patterns §5-5) — filters 참조를 비워 두 그리드 공백.
      if (params.divisionId !== undefined) {
        state.filters = { [SHEETS.GROUP_NAME]: undefined, [SHEETS.MODEL_LIST]: undefined };
      }
    });
  },

  // 조회 파라미터 키 = PKG_SCP0110 PROC_M COL_NM(camelCase) 1:1.
  setFilters: () => {
    set(state => {
      const sp = state.searchParams;
      // GET_GROUP_MASTER IN: divisionId(1) / operationGroup(2) / groupName(3)
      state.filters[SHEETS.GROUP_NAME] = {
        divisionId: sp.divisionId,
        operationGroup: sp.operationGroup,
        groupName: sp.groupName,
      };
      // GET_MODEL_LIST IN: divisionId(1) / operationGroup(2) / groupId(3) / groupName(4) /
      //   projectId(5) / itemId(6). Search 시 groupId 는 전체(빈값).
      state.filters[SHEETS.MODEL_LIST] = {
        divisionId: sp.divisionId,
        operationGroup: sp.operationGroup,
        groupId: '',
        groupName: sp.groupName,
        projectId: sp.projectId,
        itemId: sp.itemId,
      };
    });
  },

  setModelListFilter: groupId => {
    set(state => {
      const sp = state.searchParams;
      state.filters[SHEETS.MODEL_LIST] = {
        divisionId: sp.divisionId,
        operationGroup: sp.operationGroup,
        groupId,
        groupName: sp.groupName,
        projectId: sp.projectId,
        itemId: sp.itemId,
      };
    });
  },

  // 컬럼 메타는 SHEET_NAME 원본('Group Name'/'Model List')으로 조회해야 매칭된다(hook #54).
  fetchStaticColumns: async () => {
    const fetchColumns = (sheetNm: string) =>
      apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, { sheetNm });

    const [groupName, modelList] = await Promise.all([
      fetchColumns(ADMIN_SHEET_NAME[SHEETS.GROUP_NAME]),
      fetchColumns(ADMIN_SHEET_NAME[SHEETS.MODEL_LIST]),
    ]);
    set(state => {
      state.staticColumns = {
        [SHEETS.GROUP_NAME]: groupName.data.result ?? [],
        [SHEETS.MODEL_LIST]: modelList.data.result ?? [],
      };
      state.initialized = true;
    });
  },

  setOpenSearchArea: open => {
    set(state => {
      state.openSearchArea = open ?? !state.openSearchArea;
    });
  },
}), 'demand-group-master');
