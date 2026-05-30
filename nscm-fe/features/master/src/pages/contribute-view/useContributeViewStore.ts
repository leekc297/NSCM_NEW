/**
 * DMF0043_01 Contribute_View — Zustand 스토어
 */
import { create } from 'zustand';

import type { ContributeViewSearchParams } from './contribute-view.types';

interface ContributeViewState {
  searchParams: ContributeViewSearchParams;
  setSearchParams: (params: Partial<ContributeViewSearchParams>) => void;
  filters: ContributeViewSearchParams | undefined;
  setFilters: () => void;
  isOpenSearchArea: boolean;
  setOpenSearchArea: (open: boolean) => void;
  // ContributeRate 모달 (공유)
  isOpenContributeRate: boolean;
  setOpenContributeRate: (open: boolean) => void;
  // Version 모달 (View 전용)
  isOpenContributeVersion: boolean;
  setOpenContributeVersion: (open: boolean) => void;
  // ColumnTitleSet 모달 (공통)
  isOpenColumnTitleSet: boolean;
  setOpenColumnTitleSet: (open: boolean) => void;
}

const initialSearchParams: ContributeViewSearchParams = {
  yearId: new Date().getFullYear().toString(),
  versionId: '',
  customerIds: [],
  productType: '',
  bizType: '',
  isCheckM: false,
  isUsrCheck: false,
};

export const useContributeViewStore = create<ContributeViewState>(set => ({
  searchParams: initialSearchParams,
  setSearchParams: params =>
    set(state => ({ searchParams: { ...state.searchParams, ...params } })),
  filters: undefined,
  setFilters: () => set(state => ({ filters: { ...state.searchParams } })),
  isOpenSearchArea: true,
  setOpenSearchArea: open => set({ isOpenSearchArea: open }),
  isOpenContributeRate: false,
  setOpenContributeRate: open => set({ isOpenContributeRate: open }),
  isOpenContributeVersion: false,
  setOpenContributeVersion: open => set({ isOpenContributeVersion: open }),
  isOpenColumnTitleSet: false,
  setOpenColumnTitleSet: open => set({ isOpenColumnTitleSet: open }),
}));
