import { type FlexGrid as TFlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByDivisionModal } from 'features/master/src/components';
import { useEffect, useRef, useState } from 'react';

import dayjs from '@foundation/dayjs';
import type { PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { ForecastPriceForm } from './components/ForecastPriceForm';
import { ForecastPriceGrid } from './components/ForecastPriceGrid';
import { MENU_ID, SHEETS } from './forecast-price.constants';
import type { ForecastPriceRow } from './forecast-price.types';
import { useForecastPriceStore } from './useForecastPriceStore';

export const ForecastPrice = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<TFlexGrid<ForecastPriceRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const [itemModalOpen, setItemModalOpen] = useState(false);
  // F2 [BLOCKED:CATALOG] DMF0073_VersionBySalesPricePopup 미구현 — trigger state 만 둠
  const [, setVersionModalOpen] = useState(false);
  // F5 [BLOCKED:CATALOG] DMF0082_SaveSalesFuturePrice_Popup 미구현
  const [, setSalesPriceModalOpen] = useState(false);

  const { setAlert } = useMessageStore();

  const filters = useForecastPriceStore(state => state.filters);
  const titleFilters = useForecastPriceStore(state => state.titleFilters);
  const searchParams = useForecastPriceStore(state => state.searchParams);
  const setSearchParams = useForecastPriceStore(state => state.setSearchParams);
  const setFilters = useForecastPriceStore(state => state.setFilters);
  const isOpenSearchArea = useForecastPriceStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useForecastPriceStore(state => state.setOpenSearchArea);
  const fetchStaticColumns = useForecastPriceStore(state => state.fetchStaticColumns);

  useEffect(() => {
    fetchStaticColumns();
  }, []);

  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.FCST_N_PRICE_40>({
    menuId: MENU_ID,
    sheetName: SHEETS.FCST_N_PRICE_40,
    tabId,
    filters,
    enabled: filters !== undefined,
  });

  const { data: titleData } = useTabProcQuery<MENU_ID, SHEETS.SPREAD_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SPREAD_TITLE,
    tabId,
    filters: titleFilters,
    enabled: titleFilters !== undefined,
  });

  // F13 [BLOCKED:BE] titleData → dateColumns 변환은 SPREAD_TITLE BE 응답 cursor 명/스키마 확정 후 (F7).
  void titleData;

  const handleSubmit = async () => {
    // V1: divisionId 빈값
    if (!searchParams.divisionId) {
      await setAlert({ type: 'alert', content: t('', '_Please select Division.') });
      return;
    }
    // V2: versionType 빈값
    if (!searchParams.versionType.trim()) {
      await setAlert({ type: 'alert', content: t('', '_Please select Version.') });
      return;
    }
    // V3: period 시작 > 종료
    const from = searchParams.period?.[0] ? dayjs(searchParams.period[0]) : null;
    const to = searchParams.period?.[1] ? dayjs(searchParams.period[1]) : null;
    if (from && to && from.isAfter(to)) {
      await setAlert({
        type: 'alert',
        content: t('', '_Start date is later than end date.'),
      });
      return;
    }
    // V4: period > 3년 (자동 보정)
    if (from && to && from.add(3, 'year').isBefore(to)) {
      const corrected = from.add(2, 'year');
      setSearchParams({ period: [from, corrected] });
      await setAlert({
        type: 'alert',
        content: t('', '_Search period exceeds 3 years. End date adjusted.'),
      });
      return;
    }

    const isSame = setFilters();
    if (isSame) void refetch();
  };

  // F12 [BLOCKED:DESIGN] Insert/Delete/Save 본체 구현은 그리드 셀 콤보 의존성 + Lock 토글 (F14, F16) 과
  // 함께 별도 후속 사이클에서 진행. 현재는 hotkey 자리만 잡아 두며 클릭 시 안내 alert.
  const noticeNotImplemented = (label: string) =>
    void setAlert({
      type: 'alert',
      content: t('', `_${label} 동작 구현은 후속 사이클에서 진행 예정입니다.`),
    });

  const hotkeyConfig = {
    insert: () => noticeNotImplemented('Insert'),
    delete: () => noticeNotImplemented('Delete'),
    save: () => noticeNotImplemented('Save'),
    excel: false as const,
    manual: false as const,
    upload: false as const,
  };

  const customButtons = [
    {
      label: 'Price 일괄 입력',
      action: () => {
        // V15: Edit 모드 사전 검증 (siMain.IsLock) — Edit Lock 추적 미구현 (F11/F14)
        setSalesPriceModalOpen(true);
      },
    },
  ];

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <ForecastPriceForm
        onSubmit={() => {
          void handleSubmit();
        }}
        onOpenItemLookup={() => setItemModalOpen(true)}
        onOpenVersionLookup={() => setVersionModalOpen(true)}
      />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={data?.fcstNPrice?.length ?? 0}
        excelFileName='FcstPrice'
        hotkeyConfig={hotkeyConfig}
        customButtons={customButtons}
      />
      <ForecastPriceGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        data={data?.fcstNPrice ?? []}
      />
      <ItemByDivisionModal
        open={itemModalOpen}
        modalClose={() => setItemModalOpen(false)}
        setSelectedValue={(items: string) => {
          setSearchParams({ itemId: items });
          setItemModalOpen(false);
        }}
        preSearchParams={{
          divisionId: searchParams.divisionId,
          deptId: searchParams.teamId,
          endCustomer: searchParams.endCustomer,
          salesSite: searchParams.salesSite,
          itemId: searchParams.itemId,
        }}
        callFromCell={false}
      />
    </>
  );
};
