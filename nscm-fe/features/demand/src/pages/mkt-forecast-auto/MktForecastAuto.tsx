import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { MENU_ID, SHEETS } from './mkt-forecast-auto.constants';
import type { MktForecastAutoRow } from './mkt-forecast-auto.types';
import { useMktForecastAutoStore } from './useMktForecastAutoStore';

// AS-IS DMF0081_MktFcst_Auto.cs (6,386줄) — MKT FCST (AUTO)
//   - 3 Sheet (Mkt Fcst + PSI + Car Fcst)
//   - 6 PKG SP / 30+ events / 50+ cols / 측정 9 + 누적 18
//   - 1 신규 popup (CustDemandAnlDetail)
//   - 분석서: Doc/_analysis/domain_DM/screens/DMF0081_MktFcst_Auto/ (8 MD)
// Phase B-8 SKELETON. 후속:
//   - Tabs UI (Mkt Fcst / PSI / Car Fcst — Active Sheet 분기)
//   - CustDemandAnlDetailModal (cellDoubleClick — 변경 사유 / 분석 사유 입력)
//   - Excel Upload (Car Fcst 시트) + DDL Template
//   - 50+ DefColumns + 측정 9 + 누적 18 + 동적 시간축
export const MktForecastAuto = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGridType<MktForecastAutoRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);
  const setAlert = useMessageStore.getState().setAlert;

  const sc = useMktForecastAutoStore(s => s.searchCondition);
  const filters = useMktForecastAutoStore(s => s.filters);
  const setFilter = useMktForecastAutoStore(s => s.setFilter);
  const activeSheet = useMktForecastAutoStore(s => s.activeSheet);
  const setActiveSheet = useMktForecastAutoStore(s => s.setActiveSheet);

  const { data, refetch, isLoading } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID, sheetName: SHEETS.MAIN, tabId,
    filters: filters[SHEETS.MAIN], enabled: !!filters[SHEETS.MAIN],
  });

  const rows = ((data as { o_rc1?: MktForecastAutoRow[] })?.o_rc1 ?? []) as MktForecastAutoRow[];

  useEffect(() => {
    if (!filters[SHEETS.MAIN] && sc.divisionId) setFilter();
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId]);

  const handleSearch = () => {
    if (!sc.divisionId) { void setAlert({ type: 'alert', content: '[MSG00097] Division 을 선택하세요.' }); return; }
    setFilter(); refetch?.();
  };

  // 자동 화면 — CRUD 활성 (Insert/Delete/Save)
  const hotkeyConfig: HotkeyConfig = {
    insert: () => { void setAlert({ type: 'alert', content: '(TODO Phase B-8 — Insert)' }); },
    delete: () => { void setAlert({ type: 'alert', content: '(TODO Phase B-8 — Delete)' }); },
    save: () => { void setAlert({ type: 'alert', content: '(TODO Phase B-8 — Save)' }); },
    condition: false, resetCondition: false, upload: false, manual: false,
  };

  return (
    <div style={{ display: 'flex', flexDirection: 'column', height: '100%' }}>
      <MainTitle title={title} />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef as never}
        gridFilter={gridFilterRef as never}
        dataCount={0}
        hotkeyConfig={hotkeyConfig}
        searchAction={handleSearch}
      />
      <div style={{ padding: 8, fontSize: 12, color: '#666' }}>
        DMF0081 MKT FCST (AUTO) — Phase B-8 SKELETON.
        <br />
        <strong>3 Sheet (Tab):</strong> [
        <button onClick={() => setActiveSheet('main')} style={{ marginRight: 4, fontWeight: activeSheet === 'main' ? 'bold' : 'normal' }}>Mkt Fcst</button>|
        <button onClick={() => setActiveSheet('psi')} style={{ margin: '0 4px', fontWeight: activeSheet === 'psi' ? 'bold' : 'normal' }}>PSI</button>|
        <button onClick={() => setActiveSheet('carFcst')} style={{ marginLeft: 4, fontWeight: activeSheet === 'carFcst' ? 'bold' : 'normal' }}>Car Fcst</button>
        ]
        <br />
        후속: 3 Sheet 분리 grid + CustDemandAnlDetail popup + Excel Upload (Car Fcst).
        {isLoading ? ' [Loading...]' : ` [${rows.length} rows in ${activeSheet}]`}
      </div>
    </div>
  );
};
