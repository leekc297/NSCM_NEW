import { createPersistedStore } from '@shared/stores';

interface TextboxModalState {
  appliedVersionNo: string;
}

interface TextboxModalAction {
  setAppliedVersionNo: (next: string) => void;
}

export const useTextboxModalStore = createPersistedStore<TextboxModalState & TextboxModalAction>(
  set => ({
    appliedVersionNo: '',
    // 모달 open 시 확정 — useTabProcQuery filters 참조 안정화 원천
    setAppliedVersionNo: next => {
      set(state => {
        state.appliedVersionNo = next;
      });
    },
  }),
  'modal-sales-reports-textbox'
);
