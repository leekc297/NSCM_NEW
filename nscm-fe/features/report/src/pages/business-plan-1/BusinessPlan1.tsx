import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { MENU_ID, SHEETS } from './business-plan-1.constants';
import { useBusinessPlan1Store } from './useBusinessPlan1Store';
import type { BizPlanRow } from '../business-plan/business-plan.types';

// AS-IS DMF0042_1_BizPlan.cs — BUSINESS PLAN variant 1 (구조 메인과 동일)
// Phase B-4-2 SKELETON
export const BusinessPlan1 = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGridType<BizPlanRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);
  const setAlert = useMessageStore.getState().setAlert;

  const sc = useBusinessPlan1Store(s => s.searchCondition);
  const filters = useBusinessPlan1Store(s => s.filters);
  const setFilter = useBusinessPlan1Store(s => s.setFilter);

  const { data, refetch, isLoading } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID, sheetName: SHEETS.MAIN, tabId,
    filters: filters[SHEETS.MAIN], enabled: !!filters[SHEETS.MAIN],
  });

  const rows = ((data as { o_rc1?: BizPlanRow[] })?.o_rc1 ?? []) as BizPlanRow[];

  useEffect(() => {
    if (!filters[SHEETS.MAIN] && sc.divisionId) setFilter();
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId]);

  const handleSearch = () => {
    if (!sc.divisionId) { void setAlert({ type: 'alert', content: '[MSG00097] Division 을 선택하세요.' }); return; }
    setFilter(); refetch?.();
  };

  const hotkeyConfig: HotkeyConfig = {
    insert: false, delete: false, save: false,
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
        DMF0042_1 BUSINESS PLAN variant 1 — Phase B-4-2 SKELETON.
        {isLoading ? ' [Loading...]' : ` [${rows.length} rows]`}
      </div>
    </div>
  );
};
