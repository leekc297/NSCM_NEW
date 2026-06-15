import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { MENU_ID, SHEETS } from './etc-sales-reports.constants';
import type { EtcSalesReportsRow } from './etc-sales-reports.types';
import { useEtcSalesReportsStore } from './useEtcSalesReportsStore';

// AS-IS DMF0049_Sales_ETC_Reports.cs — ETC SALES REPORTS
//   - 4 SP (SAVE 36 param!) / 42 cols (T_prefix ETC 특수)
//   - 0 신규 popup (DMF0044 공유)
// Phase B-6 SKELETON. 후속: SAVE 36 param wiring + 42 cols 정밀 + DMF0044 popup 4 재사용
export const EtcSalesReports = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGridType<EtcSalesReportsRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);
  const setAlert = useMessageStore.getState().setAlert;

  const sc = useEtcSalesReportsStore(s => s.searchCondition);
  const filters = useEtcSalesReportsStore(s => s.filters);
  const setFilter = useEtcSalesReportsStore(s => s.setFilter);

  const { data, refetch, isLoading } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID, sheetName: SHEETS.MAIN, tabId,
    filters: filters[SHEETS.MAIN], enabled: !!filters[SHEETS.MAIN],
  });

  const rows = ((data as { o_rc1?: EtcSalesReportsRow[] })?.o_rc1 ?? []) as EtcSalesReportsRow[];

  useEffect(() => {
    if (!filters[SHEETS.MAIN] && sc.divisionId) setFilter();
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId]);

  const handleSearch = () => {
    if (!sc.divisionId) { void setAlert({ type: 'alert', content: '[MSG00097] Division 을 선택하세요.' }); return; }
    setFilter(); refetch?.();
  };

  const hotkeyConfig: HotkeyConfig = {
    insert: false, delete: false,
    save: () => { void setAlert({ type: 'alert', content: '(TODO Phase B-6 — Save with 36 IN params)' }); },
    condition: false, resetCondition: false, upload: false, manual: false,
  };

  return (
    <div style={{ display: 'flex', flexDirection: 'column', height: '100%' }}>
      <MainTitle title={title} />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef as never}
        gridFilter={gridFilterRef as never}
        dataCount={rows.length}
        hotkeyConfig={hotkeyConfig}
        searchAction={handleSearch}
      />
      <div style={{ padding: 8, fontSize: 12, color: '#666' }}>
        DMF0049 ETC SALES REPORTS — Phase B-6 SKELETON.
        <br />
        후속: SAVE SP 36 param + 42 cols (T_prefix ETC) + DMF0044 4 popup 재사용.
        {isLoading ? ' [Loading...]' : ` [${rows.length} rows]`}
      </div>
    </div>
  );
};
