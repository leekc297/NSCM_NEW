import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';

import { MENU_ID, SHEETS } from './erp-edi-master.constants';
import styles from './ErpEdiMaster.module.scss';
import { useErpEdiMasterStore } from './useErpEdiMasterStore';

// AS-IS DMF0008_ErpEdiMaster — 단순 main 형태 (요약 grid)
export const ErpEdiMaster = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGridType<Record<string, unknown>>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);

  const filters = useErpEdiMasterStore(s => s.filters);
  const searchCondition = useErpEdiMasterStore(s => s.searchCondition);
  const setSearchCondition = useErpEdiMasterStore(s => s.setSearchCondition);
  const setFilter = useErpEdiMasterStore(s => s.setFilter);
  const reset = useErpEdiMasterStore(s => s.reset);
  const openSearchArea = useErpEdiMasterStore(s => s.openSearchArea);
  const setOpenSearchArea = useErpEdiMasterStore(s => s.setOpenSearchArea);

  // 자동 초기 조회
  useEffect(() => {
    if (!filters[SHEETS.SUMMARY]) setFilter();
  }, []);

  const { data: summaryData, refetch } = useTabProcQuery<MENU_ID, SHEETS.SUMMARY>({
    menuId: MENU_ID,
    sheetName: SHEETS.SUMMARY,
    tabId,
    filters: filters[SHEETS.SUMMARY],
    enabled: !!filters[SHEETS.SUMMARY],
  });

  const handleSearch = () => {
    setFilter();
    refetch?.();
  };

  const hotkeyConfig: HotkeyConfig = {
    search: handleSearch,
    insert: () => undefined,
    save: () => undefined,
    delete: () => undefined,
    manual: false,
    upload: false,
  };

  const rows = (summaryData?.o_rc1 ?? []) as Record<string, unknown>[];

  return (
    <div className={styles.container}>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <div className={styles.searchBar}>
          <div className={styles.searchRow}>
            <label>Division <input value={searchCondition.divisionId} onChange={e => setSearchCondition({ divisionId: e.target.value })} /></label>
            <label>From <input value={searchCondition.fromYyyymmdd} onChange={e => setSearchCondition({ fromYyyymmdd: e.target.value })} placeholder='YYYYMMDD' /></label>
            <label>To <input value={searchCondition.toYyyymmdd} onChange={e => setSearchCondition({ toYyyymmdd: e.target.value })} placeholder='YYYYMMDD' /></label>
            <label>Sender <input value={searchCondition.senderName} onChange={e => setSearchCondition({ senderName: e.target.value })} /></label>
          </div>
          <div className={styles.actionRow}>
            <button type='button' className={styles.searchButton} onClick={handleSearch}>🔍 조회 (F5)</button>
            <button type='button' className={styles.resetButton} onClick={() => reset()}>초기화</button>
            <span className={styles.hint}>화면 진입 시 자동 조회됩니다</span>
          </div>
        </div>
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ErpEdiMaster'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchCondition}
      />
      <div className={styles.gridContainer}>
        <FlexGrid
          initialized={(g: FlexGridType<Record<string, unknown>>) => {
            if (gridRef && 'current' in gridRef) {
              (gridRef as { current: FlexGridType<Record<string, unknown>> | null }).current = g;
            }
          }}
          itemsSource={rows}
          autoGenerateColumns={true}
          style={{ height: '100%' }}
        >
          <FlexGridColumn binding='DIVISION_ID' header='Division' width={80} />
          <FlexGridColumn binding='SENDER_NAME' header='Sender' width={140} />
          <FlexGridColumn binding='RECEIVE_DATE' header='Receive Date' width={120} />
          <FlexGridColumn binding='STATUS' header='Status' width={100} />
        </FlexGrid>
      </div>
    </div>
  );
};
