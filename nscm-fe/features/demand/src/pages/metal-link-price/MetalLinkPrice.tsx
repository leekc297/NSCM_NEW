import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { MENU_ID, SHEETS } from './metal-link-price.constants';
import type { MetalLinkPriceRow } from './metal-link-price.types';
import { useMetalLinkPriceStore } from './useMetalLinkPriceStore';

// AS-IS DMF0074_MetalLinkPrice.cs (760줄) — METAL LINK PRICE
//   - 3 PKG SP (GET PIVOT + Template + Excel Upload)
//   - 11 events / 6 검증 / 5 popup (3 공용 + 2 신규)
//   - 40 사업부 별도 ID (DMF0074_40)
//   - 자매 DMF0020 SalesFuturePrice (PIVOT 표준)
//   - 분석서: Doc/_analysis/domain_DM/screens/DMF0074_MetalLinkPrice/ (8 MD)
// Phase B-7 SKELETON. 후속:
//   - 2 신규 popup (Template + ExcelUpload)
//   - PIVOT 동적 헤더 (DMF0000_GET_COMMON_SPREAD_TITLE 호출 결과)
//   - MonthRangePicker (G10 신규) wiring
//   - btnSPVer Version popup (DMF0073 — DMF0020 SalesPriceVersionModal 재사용)
export const MetalLinkPrice = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGridType<MetalLinkPriceRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);
  const setAlert = useMessageStore.getState().setAlert;

  const sc = useMetalLinkPriceStore(s => s.searchCondition);
  const filters = useMetalLinkPriceStore(s => s.filters);
  const setFilter = useMetalLinkPriceStore(s => s.setFilter);

  const { data, refetch, isLoading } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID, sheetName: SHEETS.MAIN, tabId,
    filters: filters[SHEETS.MAIN], enabled: !!filters[SHEETS.MAIN],
  });

  const rows = ((data as { o_rc1?: MetalLinkPriceRow[] })?.o_rc1 ?? []) as MetalLinkPriceRow[];

  useEffect(() => {
    if (!filters[SHEETS.MAIN] && sc.divisionId) setFilter();
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId]);

  const handleSearch = () => {
    if (!sc.divisionId) { void setAlert({ type: 'alert', content: '[MSG00097] Division 을 선택하세요.' }); return; }
    if (!sc.versionType?.trim()) { void setAlert({ type: 'alert', content: '[MSG00283] Version 을 선택하세요.' }); return; }
    if (!sc.startYyyymm || !sc.endYyyymm) { void setAlert({ type: 'alert', content: '[MSG00002] Plan Date 는 필수입니다.' }); return; }
    setFilter(); refetch?.();
  };

  // 조회 전용 + Template + Excel Upload
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
        DMF0074 METAL LINK PRICE — Phase B-7 SKELETON.
        <br />
        후속: 2 신규 popup (Template + ExcelUpload) + PIVOT 동적 헤더 + MonthRangePicker + 40 사업부 분기 (DMF0074_40).
        {isLoading ? ' [Loading...]' : ` [${rows.length} rows]`}
      </div>
    </div>
  );
};
