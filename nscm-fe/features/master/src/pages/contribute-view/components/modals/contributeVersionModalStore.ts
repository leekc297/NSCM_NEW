import { createPersistedStore } from '@shared/stores';

// interface 는 암묵적 index signature 가 없어 useTabProcQuery 의
// Record<string, JsonPrimitive> 파라미터에 직접 할당할 수 없다 (TS2322) — type 으로 선언.
export type ContributeVersionPopupFilters = {
  startYyyymmdd: string;
  endYyyymmdd: string;
  divisionId: string;
  versionType: string;
  description: string;
};

interface ContributeVersionModalState {
  filters: ContributeVersionPopupFilters | undefined;
}

interface ContributeVersionModalAction {
  setFilters: (next: ContributeVersionPopupFilters | undefined) => void;
}

export const useContributeVersionModalStore = createPersistedStore<
  ContributeVersionModalState & ContributeVersionModalAction
>(
  set => ({
    filters: undefined,
    // Search 확정(모달 open 자동조회 포함)마다 참조를 새로 만들어 filters useMemo 의 deps 로 쓴다.
    setFilters: next => {
      set(state => {
        state.filters = next;
      });
    },
  }),
  'modal-contribute-view-version-popup'
);
