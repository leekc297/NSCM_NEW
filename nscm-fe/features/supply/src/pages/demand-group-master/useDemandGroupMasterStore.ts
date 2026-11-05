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
      const prev = get().searchParams;
      const next = { ...prev, ...params };
      // Division 변경 = 그리드 초기화 의무(nscm-patterns §5-5) + 다른 조회조건 전부 초기화
      //   (사용자 지시 2026-10-02 — project-route/BOD 의 division-change cascade 관례와 동일. 이
      //   화면엔 Period 류 일자조건이 없어 operationGroup/groupName/projectId/itemId 전부 대상).
      //   operationGroup 을 비우면 DemandGroupMasterForm 의 기본값 effect 가 첫 항목으로 재세팅한다.
      if (params.divisionId !== undefined && params.divisionId !== prev.divisionId) {
        // 같은 호출에 명시적으로 넘어온 필드는 리셋하지 않는다 — 최초 기본값 시딩이 division 과
        //   operationGroup 을 한 번에 세팅할 때(Form 의 통합 시딩 effect) operationGroup 이 방금 넣은
        //   값으로 유지돼야 한다. 이게 없으면 division 변경 리셋이 같은 호출의 operationGroup 을
        //   되돌려 기본값이 빈 채로 남는다(개발서버 프로덕션 빌드 실사고 2026-10-29).
        if (params.operationGroup === undefined) next.operationGroup = '';
        if (params.groupName === undefined) next.groupName = '';
        if (params.projectId === undefined) next.projectId = '';
        if (params.itemId === undefined) next.itemId = '';
        state.filters = { [SHEETS.GROUP_NAME]: undefined, [SHEETS.MODEL_LIST]: undefined };
      } else if (
        params.operationGroup !== undefined &&
        prev.operationGroup !== '' &&
        params.operationGroup !== prev.operationGroup
      ) {
        // Operation Group 변경 = 두 그리드 초기화(PI 2026-10-30). Model List 의 GROUP_ID 셀 콤보 후보는
        //   현재 Operation Group 으로 좁혀지므로, Pack 조회 결과를 남긴 채 Cell 로 바꾸면 남은 행의
        //   GROUP_ID 가 후보에 없어 그룹명이 빈칸이 된다. 다른 조회조건은 유지한다.
        //   최초 기본값 시딩('' → 첫 항목)은 화면 초기화 대상이 아니다.
        state.filters = { [SHEETS.GROUP_NAME]: undefined, [SHEETS.MODEL_LIST]: undefined };
      }
      state.searchParams = next;
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
  //   admin 즉시반영 위해 Search 마다 + mount 1회 재조회.
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
    });

    // Condition(F6, GridAction.personalizeCondition) 으로 저장한 조회조건 복원 — 최초 mount 1회만
    //   (project-route 패턴과 동일). 이 복원이 없으면 F6 저장은 되어도 탭 재진입 시 늘 초기화된다.
    if (get().initialized) return;
    const param = await apiClient.get<{ paramNm: keyof SearchParams; paramCtn: string }[]>(
      `/admin/menu/${MENU_ID}/search-conditions`
    );
    if (param.data.result?.length > 0) {
      const restored = param.data.result.reduce(
        (acc, curr) => {
          acc[curr.paramNm] = curr.paramCtn;
          return acc;
        },
        { ...get().searchParams }
      );
      set(state => {
        state.searchParams = restored;
      });
    }
    set(state => {
      state.initialized = true;
    });
  },

  setOpenSearchArea: open => {
    set(state => {
      state.openSearchArea = open ?? !state.openSearchArea;
    });
  },
}), 'demand-group-master');
