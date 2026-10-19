import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore } from '@shared/stores';

import { ROUTE_POPUP_MENU_ID, ROUTE_POPUP_SHEETS } from './bod-distribution-route-popup.constants';

interface RouteSearchParamProps {
  fromCountry: string;
  fromCity: string;
  toCountry: string;
  toCity: string;
  transMode: string;
}

interface BodDistributionRoutePopupState {
  searchParams: RouteSearchParamProps;
  // 팝업 그리드 컬럼도 admin(SCM_MST_SHEET_COLUMNS)에서 동적 fetch — 하드코딩 금지(ui-category hook).
  staticColumn: RawFlexGridColumnConfig[];
}

interface BodDistributionRoutePopupAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<RouteSearchParamProps>) => void;
  fetchStaticColumns: () => Promise<void>;
}

const initState: BodDistributionRoutePopupState = {
  searchParams: {
    fromCountry: '',
    fromCity: '',
    toCountry: '',
    toCity: '',
    transMode: 'ALL',
  },
  staticColumn: [],
};

export const useBodDistributionRoutePopupStore = createPersistedStore<
  BodDistributionRoutePopupState & BodDistributionRoutePopupAction
>(
  set => ({
    ...initState,
    reset: () => set(initState),
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...state.searchParams, ...searchParams };
      });
    },
    fetchStaticColumns: async () => {
      const result = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${ROUTE_POPUP_MENU_ID}/column`,
        {
          sheetNm: ROUTE_POPUP_SHEETS.ROUTE,
        }
      );
      set(state => {
        state.staticColumn = result.data.result;
      });
    },
  }),
  'bod-distribution-route-popup'
);
