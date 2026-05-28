import { type FlexGrid as TFlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import dayjs from '@foundation/dayjs';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { SalesPlanWaterfallForm } from './components/SalesPlanWaterfallForm';
import { SalesPlanWaterfallGrid } from './components/SalesPlanWaterfallGrid';
import { MENU_ID, SHEETS } from './sales-plan-waterfall.constants';
import { useSalesPlanWaterfallStore } from './useSalesPlanWaterfallStore';

export const SalesPlanWaterfall = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<TFlexGrid<ResponseData<MENU_ID, SHEETS.SALES_PLAN_WATERFALL>>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const { t } = useTranslation();
  const session = useSessionStore(state => state.session);
  const { setAlert } = useMessageStore();

  const filters = useSalesPlanWaterfallStore(state => state.filters);
  const searchParams = useSalesPlanWaterfallStore(state => state.searchParams);
  const setSearchParams = useSalesPlanWaterfallStore(state => state.setSearchParams);
  const setFilters = useSalesPlanWaterfallStore(state => state.setFilters);
  const isOpenSearchArea = useSalesPlanWaterfallStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useSalesPlanWaterfallStore(state => state.setOpenSearchArea);
  const fetchStaticColumns = useSalesPlanWaterfallStore(state => state.fetchStaticColumns);

  const { data, refetch, isFetching } = useTabProcQuery<MENU_ID, SHEETS.SALES_PLAN_WATERFALL>({
    menuId: MENU_ID,
    sheetName: SHEETS.SALES_PLAN_WATERFALL,
    tabId,
    filters,
    enabled: filters !== undefined,
  });

  useEffect(() => {
    if (!session.userId || !searchParams.divisionId) return;
    void fetchStaticColumns({ divisionId: searchParams.divisionId });
  }, [tabId, session.userId, searchParams.divisionId, fetchStaticColumns]);

  const handleSubmit = () => {
    if (!session.userId) return;

    if (isFetching) {
      void setAlert({ type: 'alert', content: t('', '_The work is in progress.') });
      return;
    }

    if (!searchParams.divisionId) {
      void setAlert({ type: 'alert', content: t('', '_Please select Division.') });
      return;
    }

    const fromDt = dayjs(searchParams.period?.[0]);
    const toDt = dayjs(searchParams.period?.[1]);
    if (!fromDt.isValid() || !toDt.isValid()) {
      void setAlert({
        type: 'alert',
        content: t('MSG00013', '_Please enter the required fields.'),
      });
      return;
    }

    if (fromDt.isAfter(toDt)) {
      void setAlert({
        type: 'alert',
        content: t('', '_Period.From must not be later than Period.To.'),
      });
      return;
    }

    if (fromDt.add(3, 'year').isBefore(toDt)) {
      void setAlert({ type: 'alert', content: t('', '_Period range must not exceed 3 years.') });
      setSearchParams({ period: [fromDt, fromDt.add(3, 'year')] });
      return;
    }

    const changed = setFilters({
      userId: session.userId,
      userDeptId: '',
      groupId: '',
    });

    if (!changed && filters) void refetch();
  };

  const hotkeyConfig: HotkeyConfig = {
    insert: false,
    delete: false,
    save: false,
    upload: false,
    manual: false,
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <SalesPlanWaterfallForm onSubmit={handleSubmit} />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={data?.o_rc1.length ?? 0}
        excelFileName='SalesPlanWaterfall'
        useHotkey={true}
        searchParam={searchParams}
        hotkeyConfig={hotkeyConfig}
      />
      <SalesPlanWaterfallGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        data={data?.o_rc1 ?? []}
        tabId={tabId}
      />
    </>
  );
};
