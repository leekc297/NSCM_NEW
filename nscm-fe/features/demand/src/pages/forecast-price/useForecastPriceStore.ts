import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { MENU_ID, SHEETS } from './forecast-price.constants';
import type { SearchParamProps } from './forecast-price.types';

interface ForecastPriceState {
  searchParams: SearchParamProps;
  filters?: ProcRequest<MENU_ID, SHEETS.FCST_N_PRICE_40>;
  titleFilters?: ProcRequest<MENU_ID, SHEETS.SPREAD_TITLE>;
  isOpenSearchArea: boolean;
  staticColumns: RawFlexGridColumnConfig[];
  dateColumns: FlexGridColumnConfig[];
}

interface ForecastPriceAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilters: () => boolean;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => void;
  setStaticColumns: (staticColumns: RawFlexGridColumnConfig[]) => void;
  setDateColumns: (dateColumns: FlexGridColumnConfig[]) => void;
}

const initSearchParams: SearchParamProps = {
  divisionId: '40',
  teamId: '',
  endCustomer: '',
  salesSite: '',
  bizType: '',
  itemId: '',
  period: [dayjs(), dayjs().add(6, 'month')],
  bucketType: 'W',
  versionType: 'Current',
  qtyYn: false,
  sumYn: false,
};

const initState: ForecastPriceState = {
  searchParams: initSearchParams,
  isOpenSearchArea: true,
  staticColumns: [],
  dateColumns: [],
};

export const useForecastPriceStore = createPersistedStoreWithTab<
  ForecastPriceState & ForecastPriceAction
>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
      });
    },
    setFilters: () => {
      // userGroup: C# `UserInfoContext.Current["NowGroupID"]` 대응. UserSession 에 groupId 없음 — BE 가
      // 세션에서 추출하는지 확인 필요 (spec.md §11 F8). 확정 전까지 빈 문자열.
      const sesUserId = useSessionStore.getState().session.userId ?? '';
      const userGroup = '';
      const sp = get().searchParams;
      const fromYyyymmdd = sp.period?.[0] ? dayjs(sp.period[0]).format('YYYYMMDD') : '';
      const toYyyymmdd = sp.period?.[1] ? dayjs(sp.period[1]).format('YYYYMMDD') : '';

      const newFilters: ProcRequest<MENU_ID, SHEETS.FCST_N_PRICE_40> = {
        divisionId: sp.divisionId,
        deptId: sp.teamId || 'ALL',
        endCustomer: sp.endCustomer || 'ALL',
        bizType: sp.bizType || 'ALL',
        fromYyyymmdd,
        toYyyymmdd,
        salesSite: sp.salesSite || 'ALL',
        itemId: sp.itemId,
        versionType: sp.versionType,
        qtyYn: sp.qtyYn ? 'Y' : 'N',
        sesUserId,
        userGroup,
      };
      const newTitleFilters: ProcRequest<MENU_ID, SHEETS.SPREAD_TITLE> = {
        startYyyymmdd: fromYyyymmdd,
        endYyyymmdd: toYyyymmdd,
        sesUserId,
        divisionId: sp.divisionId,
      };

      const isSame =
        JSON.stringify(get().filters) === JSON.stringify(newFilters) &&
        JSON.stringify(get().titleFilters) === JSON.stringify(newTitleFilters);

      set(state => {
        state.filters = newFilters;
        state.titleFilters = newTitleFilters;
      });
      return isSame;
    },
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    fetchStaticColumns: () => {
      void (async () => {
        const result = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          {
            sheetNm: SHEETS.FCST_N_PRICE_40,
            divisionId: get().searchParams.divisionId,
          }
        );
        set(state => {
          state.staticColumns = result.data.result;
        });
      })();
    },
    setStaticColumns: staticColumns => {
      set({ staticColumns });
    },
    setDateColumns: dateColumns => {
      set({ dateColumns });
    },
  }),
  'forecast-price'
);
