import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';

import { MENU_ID, SHEETS } from './sales-future-price.constants';
import styles from './SalesFuturePrice.module.scss';
import { useSalesFuturePriceStore } from './useSalesFuturePriceStore';

// AS-IS DMF0020 SalesFuturePrice (단순 메인 grid 패턴, INVALID 4 SP 보강 전 핵심 흐름)
export const SalesFuturePrice = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGridType<Record<string, unknown>>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);

  const filters = useSalesFuturePriceStore(s => s.filters);
  const searchCondition = useSalesFuturePriceStore(s => s.searchCondition);
  const setSearchCondition = useSalesFuturePriceStore(s => s.setSearchCondition);
  const setFilter = useSalesFuturePriceStore(s => s.setFilter);
  const reset = useSalesFuturePriceStore(s => s.reset);
  const openSearchArea = useSalesFuturePriceStore(s => s.openSearchArea);
  const setOpenSearchArea = useSalesFuturePriceStore(s => s.setOpenSearchArea);

  useEffect(() => { if (!filters[SHEETS.MAIN]) setFilter(); }, []);

  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });

  const handleSearch = () => { setFilter(); refetch?.(); };

  const hotkeyConfig: HotkeyConfig = {
    search: handleSearch,
    insert: () => undefined,
    save: () => undefined,
    delete: () => undefined,
    manual: false,
    upload: false,
  };

  const rows = (data?.o_rc1 ?? []) as Record<string, unknown>[];

  return (
    <div className={styles.container}>
      <MainTitle title={title} menuId={MENU_ID} openSearchArea={openSearchArea} toggleOpenSearchArea={setOpenSearchArea} />
      {openSearchArea && (
        <div className={styles.searchBar}>
          <div className={styles.searchRow}>
            <label>Start <input value={searchCondition.startYyyymmdd} onChange={e => setSearchCondition({ startYyyymmdd: e.target.value })} placeholder='YYYYMMDD' /></label>
            <label>End <input value={searchCondition.endYyyymmdd} onChange={e => setSearchCondition({ endYyyymmdd: e.target.value })} placeholder='YYYYMMDD' /></label>
            <label>Division <input value={searchCondition.divisionId} onChange={e => setSearchCondition({ divisionId: e.target.value })} /></label>
          </div>
          <div className={styles.actionRow}>
            <button type='button' className={styles.searchButton} onClick={handleSearch}>🔍 조회 (F5)</button>
            <button type='button' className={styles.resetButton} onClick={() => reset()}>초기화</button>
            <span className={styles.hint}>화면 진입 시 자동 조회됩니다</span>
          </div>
        </div>
      )}
      <SubTitle menuId={MENU_ID} grid={gridRef} gridFilter={gridFilterRef} dataCount={rows.length} excelFileName='SalesFuturePrice' useHotkey={true} hotkeyConfig={hotkeyConfig} searchParam={searchCondition} />
      <div className={styles.gridContainer}>
        <FlexGrid
          initialized={(g: FlexGridType<Record<string, unknown>>) => {
            if (gridRef && 'current' in gridRef) (gridRef as { current: FlexGridType<Record<string, unknown>> | null }).current = g;
          }}
          itemsSource={rows}
          autoGenerateColumns={true}
          style={{ height: '100%' }}
        />
      </div>
    </div>
  );
};
