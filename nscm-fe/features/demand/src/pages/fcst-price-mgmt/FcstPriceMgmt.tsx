import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { MENU_ID, SHEETS } from './fcst-price-mgmt.constants';
import type { FcstPriceMgmtRow, MainSpResult } from './fcst-price-mgmt.types';
import { useFcstPriceMgmtStore } from './useFcstPriceMgmtStore';

// AS-IS DMF0082_FcstNPrice_Mgmt.cs (9,418줄 — 12 화면 중 가장 큼)
//   - 6 ResultSet 메인 SP / 5 PKG SP + 1 신규 SAVE
//   - 권한 4 분기 (SCM_FCST/MKT_FCST/LOC/VMI_IN_REQ)
//   - 월간→일별 배분 + Clipboard Paste 최적화 + Mon-Sun 권한 분기
//   - 3 신규 popup (FuturePriceInfo + MeasureCountInfo + WeekData)
//   - Figma: DMF0082.svg + DMF0082_Table_v2.svg
//   - 분석서: Doc/_analysis/domain_DM/screens/DMF0082_FcstNPrice_Mgmt/ (8 MD)
// Phase B-9 SKELETON. 후속 (12 화면 중 가장 복잡):
//   - 6 ResultSet 분리 (FCST + PRICE 병렬 행 + MEASURE/CALENDAR/WEEK 메타)
//   - 권한 4 분기 cell 색상 + 편집 가능/불가 logic
//   - 월간→일별 배분 logic (CalendarDetail)
//   - Clipboard Paste 최적화 (대량 cell + 권한 분기)
//   - Mon-Sun 권한 분기 (월요일 SCM_FCST 입력 시 MKT FCST 잠금)
//   - SAVE SP 재구현 (16 IN + 1 OUT — 주석 처리된 P_DMF0082_SAVE_MAIN_DATA)
//   - 3 신규 modal (FuturePriceInfo / MeasureCountInfo / WeekData)
//   - Figma 1:1 재현 (figma-mapping-check hook)
export const FcstPriceMgmt = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGridType<FcstPriceMgmtRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);
  const setAlert = useMessageStore.getState().setAlert;

  const sc = useFcstPriceMgmtStore(s => s.searchCondition);
  const filters = useFcstPriceMgmtStore(s => s.filters);
  const setFilter = useFcstPriceMgmtStore(s => s.setFilter);
  const editAuth = useFcstPriceMgmtStore(s => s.editAuth);

  const { data, refetch, isLoading } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID, sheetName: SHEETS.MAIN, tabId,
    filters: filters[SHEETS.MAIN], enabled: !!filters[SHEETS.MAIN],
  });

  const result = (data ?? {}) as MainSpResult;
  const fcstRows = result.o_rc1 ?? [];
  const priceRows = result.o_rc2 ?? [];

  useEffect(() => {
    if (!filters[SHEETS.MAIN] && sc.divisionId) setFilter();
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId]);

  const handleSearch = () => {
    if (!sc.divisionId) { void setAlert({ type: 'alert', content: '[MSG00097] Division 을 선택하세요.' }); return; }
    if (!sc.versionType?.trim()) { void setAlert({ type: 'alert', content: '[MSG00283] Version 을 선택하세요.' }); return; }
    setFilter(); refetch?.();
  };

  const hotkeyConfig: HotkeyConfig = {
    insert: () => { void setAlert({ type: 'alert', content: '(TODO Phase B-9 — Insert + 권한 4 분기)' }); },
    delete: () => { void setAlert({ type: 'alert', content: '(TODO Phase B-9 — Delete + 삭제 불가 행 분기)' }); },
    save: () => { void setAlert({ type: 'alert', content: '(TODO Phase B-9 — Save 신규 재구현 16 IN + Clipboard Paste 일괄)' }); },
    condition: false, resetCondition: false, upload: false, manual: false,
  };

  return (
    <div style={{ display: 'flex', flexDirection: 'column', height: '100%' }}>
      <MainTitle title={title} />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef as never}
        gridFilter={gridFilterRef as never}
        dataCount={fcstRows.length + priceRows.length}
        hotkeyConfig={hotkeyConfig}
        searchAction={handleSearch}
      />
      <div style={{ padding: 8, fontSize: 12, color: '#666' }}>
        DMF0082 FCST & PRICE MGMT — Phase B-9 SKELETON (12 화면 중 최복잡).
        <br />
        <strong>6 ResultSet:</strong> FCST [{fcstRows.length}] + PRICE [{priceRows.length}] + MEASURE/CALENDAR/WEEK 메타
        <br />
        <strong>권한 4 분기:</strong> SCM_FCST={String(editAuth.scmFcst)} / MKT_FCST={String(editAuth.mktFcst)} /
        LOC={String(editAuth.loc)} / VMI_IN_REQ={String(editAuth.vmiInReq)}
        <br />
        후속: 권한 분기 cell 색상 + 월간→일별 배분 + Clipboard Paste + SAVE 재구현 + 3 신규 modal + Figma 적용.
        {isLoading ? ' [Loading...]' : ''}
      </div>
    </div>
  );
};
