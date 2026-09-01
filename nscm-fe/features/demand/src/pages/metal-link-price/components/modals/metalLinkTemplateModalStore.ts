import { createPersistedStore } from '@shared/stores';

interface MetalLinkTemplateModalState {
  hasSearched: boolean;
}

interface MetalLinkTemplateModalAction {
  setHasSearched: (next: boolean) => void;
}

export const useMetalLinkTemplateModalStore = createPersistedStore<
  MetalLinkTemplateModalState & MetalLinkTemplateModalAction
>(
  set => ({
    hasSearched: false,
    // Search 버튼 클릭 시에만 true — useTabProcQuery filters/enabled 게이트 원천
    setHasSearched: next => {
      set(state => {
        state.hasSearched = next;
      });
    },
  }),
  'modal-metal-link-template'
);
