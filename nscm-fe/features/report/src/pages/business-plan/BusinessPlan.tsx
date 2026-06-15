import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { MENU_ID, SHEETS } from './business-plan.constants';
import type { BizPlanRow } from './business-plan.types';
import { useBusinessPlanStore } from './useBusinessPlanStore';

// AS-IS DMF0042_BizPlan.cs (3,564줄) — BUSINESS PLAN 메인
//   - 9 SP / 97 Validation / 62 Expression (PIVOT 행잠금 57)
//   - 68 cols / 4 신규 Popup
//   - _bulk_fix_v2 audit 이력 (2026-06-01)
// ⚠️ Phase B-4 SKELETON. 후속: 4 popup wiring + 행잠금 expression + 68 cols 정밀
export const BusinessPlan = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGridType<BizPlanRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;

  const sc = useBusinessPlanStore(s => s.searchCondition);
  const filters = useBusinessPlanStore(s => s.filters);
  const setFilter = useBusinessPlanStore(s => s.setFilter);

  const { data, refetch, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });

  const loading = isLoading || isFetching;
  const rows = ((data as { o_rc1?: BizPlanRow[] })?.o_rc1 ?? []) as BizPlanRow[];

  useEffect(() => {
    if (!filters[SHEETS.MAIN] && sc.divisionId) setFilter();
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId]);

  const handleSearch = () => {
    if (!sc.divisionId) {
      void setAlert({ type: 'alert', content: '[MSG00097] Division 을 선택하세요.' });
      return;
    }
    if (!sc.versionType) {
      void setAlert({ type: 'alert', content: '[MSG00283] Version 을 선택하세요.' });
      return;
    }
    void setToast({ message: '조회 중입니다...', type: 'default', duration: 2000 });
    setFilter();
    refetch?.();
  };

  const hotkeyConfig: HotkeyConfig = {
    insert: () => { void setAlert({ type: 'alert', content: '(TODO Phase B-4 — Insert)' }); },
    delete: () => { void setAlert({ type: 'alert', content: '(TODO Phase B-4 — Delete)' }); },
    save: () => { void setAlert({ type: 'alert', content: '(TODO Phase B-4 — Save)' }); },
    condition: false,
    resetCondition: false,
    upload: false,
    manual: false,
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
        DMF0042 BUSINESS PLAN — Phase B-4 SKELETON.
        <br />
        후속: 4 popup (ExchangeRate/Textbox/Version/UnitedVersion) + PIVOT 행잠금 57 + 68 cols + 9 SP.
        {loading ? ' [Loading...]' : ` [${rows.length} rows]`}
      </div>
    </div>
  );
};
