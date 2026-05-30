/**
 * DMF0072 NNMasterMapping — Zustand 스토어
 */
import { create } from 'zustand';

import { DATA_TYPE_CODE } from './nn-master-mapping.constants';
import type { NNMasterMappingSearchParams } from './nn-master-mapping.types';

interface NNMasterMappingState {
  searchParams: NNMasterMappingSearchParams;
  setSearchParams: (params: Partial<NNMasterMappingSearchParams>) => void;
  filters: NNMasterMappingSearchParams | undefined;
  setFilters: () => void;
  isOpenSearchArea: boolean;
  setOpenSearchArea: (open: boolean) => void;
  // POPUPs
  isOpenProjectPopup: boolean;
  setOpenProjectPopup: (open: boolean) => void;
  isOpenModelPopup: boolean;
  setOpenModelPopup: (open: boolean) => void;
  isOpenCustomerPopup: boolean;
  setOpenCustomerPopup: (open: boolean) => void;
}

const initialSearchParams: NNMasterMappingSearchParams = {
  divisionId: '',
  teamIds: [],
  endCustomers: [],
  salesSiteIds: [],
  projectCode: '',
  modelType: '',
  dataTypeCode: DATA_TYPE_CODE.SCM,
};

export const useNNMasterMappingStore = create<NNMasterMappingState>(set => ({
  searchParams: initialSearchParams,
  setSearchParams: params =>
    set(state => ({ searchParams: { ...state.searchParams, ...params } })),
  filters: undefined,
  setFilters: () => set(state => ({ filters: { ...state.searchParams } })),
  isOpenSearchArea: true,
  setOpenSearchArea: open => set({ isOpenSearchArea: open }),
  isOpenProjectPopup: false,
  setOpenProjectPopup: open => set({ isOpenProjectPopup: open }),
  isOpenModelPopup: false,
  setOpenModelPopup: open => set({ isOpenModelPopup: open }),
  isOpenCustomerPopup: false,
  setOpenCustomerPopup: open => set({ isOpenCustomerPopup: open }),
}));
