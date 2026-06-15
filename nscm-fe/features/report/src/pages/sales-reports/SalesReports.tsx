import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { MENU_ID, SHEETS } from './sales-reports.constants';
import type { SalesReportsRow } from './sales-reports.types';
import { useSalesReportsStore } from './useSalesReportsStore';

// AS-IS DMF0044_Sales_Reports.cs (~2,000줄) — SALES REPORTS
//   - 18 SP (실호출 6) / SAVE_C_CF 2,896줄
//   - 35 cols / 4 신규 popup / Figma ✅
//   - Figma: Doc/_figma/screens/DMF0044.md + DMF0044.svg + DMF0044_Table.svg
//   - 분석서: Doc/_analysis/domain_DM/screens/DMF0044_Sales_Reports/ (8 MD 기존)
// Phase B-5 SKELETON. 후속:
//   - 4 popup wiring (SalesReportExchange / Textbox / Version / UnitedVersion)
//   - SAVE_C_CF SP wiring (2,896줄 — multi-variant 저장)
//   - 35 cols 정밀 추출
//   - figma-mapping-check hook 의무 적용
export const SalesReports = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGridType<SalesReportsRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);
  const setAlert = useMessageStore.getState().setAlert;

  const sc = useSalesReportsStore(s => s.searchCondition);
  const filters = useSalesReportsStore(s => s.filters);
  const setFilter = useSalesReportsStore(s => s.setFilter);

  const { data, refetch, isLoading } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID, sheetName: SHEETS.MAIN, tabId,
    filters: filters[SHEETS.MAIN], enabled: !!filters[SHEETS.MAIN],
  });

  const rows = ((data as { o_rc1?: SalesReportsRow[] })?.o_rc1 ?? []) as SalesReportsRow[];

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
    save: () => { void setAlert({ type: 'alert', content: '(TODO Phase B-5 — Save with SAVE_C_CF SP 2,896줄)' }); },
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
        DMF0044 SALES REPORTS — Phase B-5 SKELETON.
        <br />
        후속: 4 popup + SAVE_C_CF (2,896줄) wiring + 35 cols + Figma 1:1 재현.
        {isLoading ? ' [Loading...]' : ` [${rows.length} rows]`}
      </div>
    </div>
  );
};
