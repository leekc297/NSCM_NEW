import { createPersistedStore } from '@shared/stores';

export interface DivisionModalFilters {
  searchText: string;
}

interface DivisionModalState {
  filters: DivisionModalFilters | undefined;
}

interface DivisionModalAction {
  setFilters: (next: DivisionModalFilters | undefined) => void;
}

export const useDivisionModalStore = createPersistedStore<DivisionModalState & DivisionModalAction>(
  set => ({
    filters: undefined,
    // Search 확정(모달 open 포함)마다 참조를 새로 만들어 filters useMemo 의 deps 로 쓴다.
    setFilters: next => {
      set(state => {
        state.filters = next;
      });
    },
  }),
  'modal-group-user-division'
);
