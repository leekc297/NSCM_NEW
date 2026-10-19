import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { applyGridLayout, fetchGridLayout } from '@shared/components';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { MENU_ID, SHEETS } from './production-request.constants';
import type { SelectedBuild } from './production-request.types';

// SP filter payload — useTabProcQuery enabled 가드 (store 보관 참조만 전달 — 인라인 객체 금지).
//   이 화면은 SearchArea 가 없다 — Tree 빌드 No. 선택이 process/build/demand 필터를 확정한다.
type FiltersBySheet = {
  [SHEETS.TREE]?: ProcRequest<MENU_ID, SHEETS.TREE>;
  [SHEETS.PROCESS]?: ProcRequest<MENU_ID, SHEETS.PROCESS>;
  [SHEETS.BUILD]?: ProcRequest<MENU_ID, SHEETS.BUILD>;
  [SHEETS.DEMAND]?: ProcRequest<MENU_ID, SHEETS.DEMAND>;
};

interface State {
  filters: FiltersBySheet;
  /** Tree 에서 선택된 빌드 No. — null 이면 우측(빌드 패널/수요 그리드) 미조회 */
  selected: SelectedBuild | null;
  /** 진행 샘플 현황 스위치 (설계서 레이아웃 기본 On — SP 필터 계약은 미확정, tree util 참고) */
  inProgressOnly: boolean;
  /** 샘플 빌드 등록 패널 편집 모드 — 신규 버튼으로 진입, 취소/저장으로 복귀 (§확인사항 1.1) */
  buildInsertMode: boolean;
  // admin SHEET_COLUMNS 동적 메타 — 시트별 (컬럼명 배열 하드코딩 금지)
  staticColumns: Partial<Record<SHEETS, RawFlexGridColumnConfig[]>>;
}

interface Action {
  reset: () => void;
  /** 최초 진입/스위치 변경 — 세션 사업부로 Tree 필터 확정 */
  setTreeFilter: () => void;
  /** Tree 빌드 No. 선택 — process/build/demand 필터를 한 번에 확정 */
  selectBuild: (selected: SelectedBuild) => void;
  /** build/demand 재조회 — 저장 성공 후 필터 참조 교체로 invalidate */
  refreshSelected: () => void;
  setInProgressOnly: (on: boolean) => void;
  setBuildInsertMode: (on: boolean) => void;
  fetchStaticColumns: (sheets: SHEETS[]) => Promise<void>;
}

const initState: State = {
  filters: {},
  selected: null,
  inProgressOnly: true,
  buildInsertMode: false,
  staticColumns: {},
};

// 선택 빌드 기준 필터 3종 — selectBuild/refreshSelected 공용 (항상 새 참조 = 쿼리 invalidate)
const buildSelectedFilters = (selected: SelectedBuild, sesDivisionId: string) => {
  const base = {
    dpjtCode: selected.dpjtCode,
    // 빌드 번호가 있으면 조합 키를 쓰고, 없으면 빈 값으로 전달하여 프로젝트 전체 조회를 보장
    dpjtBuildNo: selected.dpjtBuildNo ? `${selected.dpjtCode}-${selected.dpjtBuildNo}` : '',
    sesDivisionId,
  };
  return {
    [SHEETS.PROCESS]: { ...base },
    [SHEETS.BUILD]: { ...base },
    [SHEETS.DEMAND]: { ...base },
  };
};

export const useProductionRequestStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setTreeFilter: () => {
      const sesDivisionId = useSessionStore.getState().session.div ?? '';
      set(state => {
        state.filters[SHEETS.TREE] = { sesDivisionId };
      });
    },
    selectBuild: selected => {
      const sesDivisionId = useSessionStore.getState().session.div ?? '';
      set(state => {
        state.selected = selected;
        state.buildInsertMode = false;
        state.filters = {
          ...state.filters,
          ...buildSelectedFilters(selected, sesDivisionId),
        };
      });
    },
    refreshSelected: () => {
      const selected = get().selected;
      if (!selected) return;
      const sesDivisionId = useSessionStore.getState().session.div ?? '';
      set(state => {
        state.filters = {
          ...state.filters,
          ...buildSelectedFilters(selected, sesDivisionId),
        };
      });
    },
    setInProgressOnly: on => {
      set(state => {
        state.inProgressOnly = on;
      });
    },
    setBuildInsertMode: on => {
      set(state => {
        state.buildInsertMode = on;
      });
    },
    // ⭐ master hook §2.3 — Column 동적 fetch (SHEET_COLUMNS — 시트별. 하드코딩 fallback 금지)
    fetchStaticColumns: async sheets => {
      const divisionId = useSessionStore.getState().session.div ?? '';
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
  'production-request'
);
