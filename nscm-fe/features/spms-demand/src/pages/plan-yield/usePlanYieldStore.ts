import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { applyGridLayout, fetchGridLayout } from '@shared/components';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import type { SelectedBuild } from '../../components/sample-status-tree';

import { MENU_ID, SHEETS } from './plan-yield.constants';
import type { SelectedOperationGroup } from './plan-yield.types';
import { isSameOperationGroup } from './utils/plan-yield.payload';

// SP filter payload — useTabProcQuery enabled 가드 (store 보관 참조만 전달 — 인라인 객체 금지).
//   이 화면은 SearchArea 가 없다 — Tree 빌드 No. 선택이 process/build 필터를(요청법인 패널은 build 의
//   2번째 커서), 요청법인 패널의 **구분(공정 그룹)** 선택이 yield 필터를 확정한다. 조회 결과 data 는 store 에 저장하지
//   않는다 (SSOT — 쿼리 캐시).
type FiltersBySheet = {
  [SHEETS.TREE]?: ProcRequest<MENU_ID, SHEETS.TREE>;
  [SHEETS.PROCESS]?: ProcRequest<MENU_ID, SHEETS.PROCESS>;
  [SHEETS.BUILD]?: ProcRequest<MENU_ID, SHEETS.BUILD>;
  [SHEETS.YIELD]?: ProcRequest<MENU_ID, SHEETS.YIELD>;
};

type ColumnSheetName = SHEETS.PLANT | SHEETS.YIELD;

interface State {
  filters: FiltersBySheet;
  /** Tree 에서 선택된 빌드 No. — null 이면 우측(Process/패널/그리드) 미조회 */
  selected: SelectedBuild | null;
  /** 요청법인 패널에서 선택된 구분(공정 그룹) — null 이면 수율 그리드 미조회 */
  selectedOperation: SelectedOperationGroup | null;
  /** 진행 샘플 현황 스위치 (설계서 Tree 시트 기본 On — 커서 IN_PROGRESS 필터) */
  inProgressOnly: boolean;
  // admin SHEET_COLUMNS 동적 메타 — 시트별 (컬럼명 배열 하드코딩 금지)
  staticColumns: Partial<Record<ColumnSheetName, RawFlexGridColumnConfig[]>>;
}

interface Action {
  reset: () => void;
  /** 최초 진입/스위치 변경 — 세션 사업부로 Tree 필터 확정 */
  setTreeFilter: () => void;
  /** Tree 빌드 No. 선택 — process/build 필터 확정 + 구분 선택·yield 필터 해제 */
  selectBuild: (selected: SelectedBuild) => void;
  /** 요청법인 패널 구분 선택 — yield 필터 확정 (동일 값이면 set 건너뜀 — 고빈도 selectionChanged 가드) */
  selectOperation: (group: SelectedOperationGroup | null) => void;
  /** 선택 빌드 기준 재조회 — 필터 참조 교체로 invalidate (yield 는 구분 선택 유지 시 함께) */
  refreshSelected: () => void;
  /** 수율 그리드만 재조회 */
  refreshYield: () => void;
  setInProgressOnly: (on: boolean) => void;
  fetchStaticColumns: (sheets: ColumnSheetName[]) => Promise<void>;
}

const initState: State = {
  filters: {},
  selected: null,
  selectedOperation: null,
  inProgressOnly: true,
  staticColumns: {},
};

const sesDivisionId = () => useSessionStore.getState().session.div ?? '';

// 선택 빌드 기준 필터 2종 — selectBuild/refreshSelected 공용 (항상 새 참조 = 쿼리 invalidate)
const buildSelectedFilters = (selected: SelectedBuild) => {
  const base = {
    dpjtCode: selected.dpjtCode,
    dpjtBuildNo: selected.dpjtBuildNo,
    sesDivisionId: sesDivisionId(),
  };
  return {
    [SHEETS.PROCESS]: { ...base },
    [SHEETS.BUILD]: { ...base },
  };
};

// ⭐ 조회 단위 = 구분(공정 그룹). 법인·공정으로 좁히지 않는다 — 그 구분에 속한 전 공정의 행이 와야 한다.
//   ⚠ SP 변경 필요 (2026-09-04): P_SDM2020_GET_PJT_YIELD 에서 P_PLANT_ID/P_OPERATION_ID 조건을 빼고
//   (P_OPERATION_GROUP + P_MGMT_TYPE) 로만 좁혀 그룹 전 공정을 반환해야 한다.
const buildYieldFilter = (
  selected: SelectedBuild,
  group: SelectedOperationGroup
): ProcRequest<MENU_ID, SHEETS.YIELD> => ({
  dpjtCode: selected.dpjtCode,
  dpjtBuildNo: selected.dpjtBuildNo,
  operationGroup: group.operationGroup,
  mgmtType: group.mgmtType,
  sesDivisionId: sesDivisionId(),
});

export const usePlanYieldStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setTreeFilter: () => {
      set(state => {
        state.filters[SHEETS.TREE] = { sesDivisionId: sesDivisionId() };
      });
    },
    selectBuild: selected => {
      set(state => {
        state.selected = selected;
        state.selectedOperation = null;
        state.filters = {
          [SHEETS.TREE]: state.filters[SHEETS.TREE],
          ...buildSelectedFilters(selected),
        };
      });
    },
    selectOperation: group => {
      const { selected, selectedOperation } = get();
      if (isSameOperationGroup(selectedOperation, group)) return;
      set(state => {
        state.selectedOperation = group;
        if (selected && group) state.filters[SHEETS.YIELD] = buildYieldFilter(selected, group);
        else delete state.filters[SHEETS.YIELD];
      });
    },
    refreshSelected: () => {
      const { selected, selectedOperation } = get();
      if (!selected) return;
      set(state => {
        state.filters = {
          ...state.filters,
          ...buildSelectedFilters(selected),
          ...(selectedOperation
            ? { [SHEETS.YIELD]: buildYieldFilter(selected, selectedOperation) }
            : {}),
        };
      });
    },
    refreshYield: () => {
      const { selected, selectedOperation } = get();
      if (!selected || !selectedOperation) return;
      set(state => {
        state.filters[SHEETS.YIELD] = buildYieldFilter(selected, selectedOperation);
      });
    },
    setInProgressOnly: on => {
      set(state => {
        state.inProgressOnly = on;
      });
    },
    // ⭐ master hook §2.3 — Column 동적 fetch (SHEET_COLUMNS — 시트별. 하드코딩 fallback 금지)
    fetchStaticColumns: async sheets => {
      const divisionId = sesDivisionId();
      await Promise.all(
        sheets.map(async sheet => {
          try {
            const [result, layout] = await Promise.all([
              apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
                sheetNm: sheet,
                divisionId,
              }),
              fetchGridLayout({ menuId: MENU_ID, sheetName: sheet, columnType: 'C', divisionId }),
            ]);
            set(state => {
              state.staticColumns[sheet] = applyGridLayout(result.data.result ?? [], layout);
            });
          } catch {
            // BE 메타 미응답 시 silent — 기존 배열 유지 (console 금지 룰)
          }
        })
      );
    },
  }),
  'plan-yield'
);
