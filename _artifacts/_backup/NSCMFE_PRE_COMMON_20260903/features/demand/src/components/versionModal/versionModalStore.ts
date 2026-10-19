import { createPersistedStore } from '@shared/stores';

export interface VersionAppliedFilters {
  versionType: string;
  sdt: string;
  edt: string;
  description: string;
}

const initApplied: VersionAppliedFilters = { versionType: '', sdt: '', edt: '', description: '' };

interface VersionModalState {
  applied: VersionAppliedFilters;
}

interface VersionModalAction {
  setApplied: (next: VersionAppliedFilters) => void;
}

export const useVersionModalStore = createPersistedStore<VersionModalState & VersionModalAction>(
  set => ({
    applied: initApplied,
    // 검색 조건 확정(Search 클릭·모달 open 초기화)마다 참조를 새로 만들어 filters useMemo 의 deps 로 쓴다.
    setApplied: next => {
      set(state => {
        state.applied = next;
      });
    },
  }),
  'modal-version-united'
);
