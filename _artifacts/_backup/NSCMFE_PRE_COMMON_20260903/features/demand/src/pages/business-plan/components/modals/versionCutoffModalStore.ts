import { createPersistedStore } from '@shared/stores';

export interface VersionCutoffPeriod {
  startYmd: string;
  endYmd: string;
}

const initPeriod: VersionCutoffPeriod = { startYmd: '', endYmd: '' };

interface VersionCutoffModalState {
  period: VersionCutoffPeriod;
}

interface VersionCutoffModalAction {
  setPeriod: (next: VersionCutoffPeriod) => void;
}

export const useVersionCutoffModalStore = createPersistedStore<
  VersionCutoffModalState & VersionCutoffModalAction
>(
  set => ({
    period: initPeriod,
    // 기간 변경마다 참조를 새로 만들어 filters useMemo 의 deps 로 쓴다.
    setPeriod: next => {
      set(state => {
        state.period = next;
      });
    },
  }),
  'modal-business-plan-version-cutoff'
);
