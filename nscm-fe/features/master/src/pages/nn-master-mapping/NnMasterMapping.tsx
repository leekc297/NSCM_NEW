import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';

import { MENU_ID, SHEETS } from './nn-master-mapping.constants';
import styles from './NnMasterMapping.module.scss';
import { useNnMasterMappingStore } from './useNnMasterMappingStore';

export const NnMasterMapping = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGridType<Record<string, unknown>>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);

  const filters = useNnMasterMappingStore(s => s.filters);
  const searchCondition = useNnMasterMappingStore(s => s.searchCondition);
  const setSearchCondition = useNnMasterMappingStore(s => s.setSearchCondition);
  const setFilter = useNnMasterMappingStore(s => s.setFilter);
  const reset = useNnMasterMappingStore(s => s.reset);
  const openSearchArea = useNnMasterMappingStore(s => s.openSearchArea);
  const setOpenSearchArea = useNnMasterMappingStore(s => s.setOpenSearchArea);

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

  const rows = (data?.p_cursor ?? []) as Record<string, unknown>[];

  return (
    <div className={styles.container}>
      <MainTitle title={title} menuId={MENU_ID} openSearchArea={openSearchArea} toggleOpenSearchArea={setOpenSearchArea} />
      {openSearchArea && (
        <div className={styles.searchBar}>
          <div className={styles.searchRow}>
            <label>Data Type <input value={searchCondition.dataTypeCode} onChange={e => setSearchCondition({ dataTypeCode: e.target.value })} /></label>
            <label>Division <input value={searchCondition.divisionId} onChange={e => setSearchCondition({ divisionId: e.target.value })} /></label>
            <label>End Cust <input value={searchCondition.endCustomer} onChange={e => setSearchCondition({ endCustomer: e.target.value })} /></label>
            <label>SCM Site <input value={searchCondition.scmSiteId} onChange={e => setSearchCondition({ scmSiteId: e.target.value })} /></label>
            <label>Project <input value={searchCondition.projectCode} onChange={e => setSearchCondition({ projectCode: e.target.value })} /></label>
          </div>
          <div className={styles.actionRow}>
            <button type='button' className={styles.searchButton} onClick={handleSearch}>🔍 조회 (F5)</button>
            <button type='button' className={styles.resetButton} onClick={() => reset()}>초기화</button>
            <span className={styles.hint}>화면 진입 시 자동 조회됩니다</span>
          </div>
        </div>
      )}
      <SubTitle menuId={MENU_ID} grid={gridRef} gridFilter={gridFilterRef} dataCount={rows.length} excelFileName='NnMasterMapping' useHotkey={true} hotkeyConfig={hotkeyConfig} searchParam={searchCondition} />
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
