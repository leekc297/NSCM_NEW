import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import _ from '@foundation/lodash';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { BUCKET_TYPE, MENU_ID, SHEETS } from './sales-plan-waterfall.constants';
import type { SearchParams } from './sales-plan-waterfall.types';

interface SalesPlanWaterfallState {
  searchParams: SearchParams;
  filters?: ProcRequest<MENU_ID, SHEETS.SALES_PLAN_WATERFALL>;
  titleFilters?: ProcRequest<MENU_ID, SHEETS.SPREAD_TITLE>;
  isOpenSearchArea: boolean;
  staticColumns: RawFlexGridColumnConfig[];
}

interface SalesPlanWaterfallAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParams>) => void;
  setFilters: (input: { userId: string; userDeptId: string; groupId: string }) => boolean;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: (input: { divisionId: string }) => Promise<void>;
}

const initSearchParams: SearchParams = {
  divisionId: '',
  team: '',
  endCustomer: '',
  salesSite: '',
  versionType: '',
  period: [],
  bucket: BUCKET_TYPE.MONTHLY,
  isSumChecked: false,
  isColorChecked: false,
  isCellQtyChecked: false,
  krw: '',
  usd: '',
  loc: '',
  qty: '',
  projectCode: '',
  itemType: '',
  bizType: '',
  isInternalChecked: false,
  plantSiteId: '',
  owner: '',
  itemId: '',
};

const initSalesPlanWaterfallState: SalesPlanWaterfallState = {
  searchParams: initSearchParams,
  isOpenSearchArea: true,
  staticColumns: [],
};

export const useSalesPlanWaterfallStore = createPersistedStoreWithTab<
  SalesPlanWaterfallState & SalesPlanWaterfallAction
>(
  set => ({
    ...initSalesPlanWaterfallState,
    reset: () =>
      set(state => {
        state.searchParams = initSearchParams;
        state.filters = undefined;
        state.titleFilters = undefined;
        state.isOpenSearchArea = true;
        state.staticColumns = [];
      }),
    setSearchParams: searchParams =>
      set(state => {
        state.searchParams = { ...state.searchParams, ...searchParams };
      }),
    setFilters: ({ userId, userDeptId, groupId }) => {
      let changed = false;
      set(state => {
        const p = state.searchParams;
        const fromYyyymmdd = dayjs(p.period?.[0]).format('YYYYMMDD');
        const toYyyymmdd = dayjs(p.period?.[1]).format('YYYYMMDD');
        const nowYyyymmdd = dayjs().format('YYYYMMDD');

        const newFilters = {
          divisionId: p.divisionId,
          deptId: p.team,
          endCustomer: p.endCustomer,
          scmSiteId: p.salesSite,
          projectCode: p.projectCode,
          itemId: p.itemId,
          itemType: p.itemType,
          fromYyyymmdd,
          nowYyyymmdd,
          toYyyymmdd,
          sesUserId: userId,
          plantSiteId: p.plantSiteId,
          bizType: p.bizType,
          owner: p.owner,
          internalYn: p.isInternalChecked ? 'Y' : 'N',
          cellYn: p.isCellQtyChecked ? 'Y' : 'N',
          versionType: p.versionType,
          bucket: p.bucket,
          userDeptId,
          groupId,
          userId,
          menuId: MENU_ID,
        };

        if (!_.isEqual(newFilters, state.filters)) {
          state.filters = newFilters;
          state.titleFilters = {
            divisionId: p.divisionId,
            bucket: p.bucket,
            fromYyyymmdd,
            toYyyymmdd,
            sesUserId: userId,
            userId,
          };
          changed = true;
        }
      });
      return changed;
    },
    setOpenSearchArea: open =>
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      }),
    fetchStaticColumns: async ({ divisionId }) => {
      const result = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        {
          sheetNm: SHEETS.SALES_PLAN_WATERFALL,
          divisionId,
        }
      );
      set(state => {
        state.staticColumns = result.data.result;
      });
    },
  }),
  'sales-plan-waterfall'
);
