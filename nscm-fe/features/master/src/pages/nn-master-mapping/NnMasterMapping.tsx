import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import {
  AllowMerging,
  CellRange,
  CellType,
  MergeManager,
  type FlexGrid as FlexGridType,
  type GridPanel,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';

import { NnMasterMappingForm } from './components/NnMasterMappingForm';
import { MAIN_COLUMNS, MENU_ID, SHEETS } from './nn-master-mapping.constants';
import styles from './NnMasterMapping.module.scss';
import { useNnMasterMappingStore } from './useNnMasterMappingStore';

// As-Is .cs L515 `siMain.SmartColMerge()` 동작 모사 (사용자 요구 2026-06-02):
// "자신의 column 이 같은 값이어도, 좌측의 모든 allowMerging column 도 같은 값일 때만 머지"
// Wijmo 기본 `AllowMerging.Cells` 는 column-independent — 이 클래스가 계층적 머지로 교체.
class HierarchicalMergeManager extends MergeManager {
  getMergedRange(panel: GridPanel, r: number, c: number, clip: boolean = true): CellRange | null {
    if (panel.cellType !== CellType.Cell) {
      return super.getMergedRange(panel, r, c, clip);
    }
    const col = panel.columns[c];
    if (!col || !col.allowMerging) return null;

    // 좌측 (포함) 의 allowMerging=true column 모음
    const mergeColIdx: number[] = [];
    for (let i = 0; i <= c; i++) {
      if (panel.columns[i] && panel.columns[i].allowMerging) mergeColIdx.push(i);
    }
    if (mergeColIdx.length === 0) return null;

    const sameAcrossKeys = (rowA: number, rowB: number): boolean =>
      mergeColIdx.every(ci => {
        const a = panel.getCellData(rowA, ci, false);
        const b = panel.getCellData(rowB, ci, false);
        return a === b;
      });

    let r1 = r;
    let r2 = r;
    while (r1 > 0 && sameAcrossKeys(r1 - 1, r)) r1--;
    const rowCnt = panel.rows.length;
    while (r2 < rowCnt - 1 && sameAcrossKeys(r2 + 1, r)) r2++;

    if (r1 === r2) return null;
    return new CellRange(r1, c, r2, c);
  }
}

export const NnMasterMapping = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGridType<Record<string, unknown>>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);

  const filters = useNnMasterMappingStore(s => s.filters);
  const searchCondition = useNnMasterMappingStore(s => s.searchCondition);
  const setFilter = useNnMasterMappingStore(s => s.setFilter);
  const openSearchArea = useNnMasterMappingStore(s => s.openSearchArea);
  const setOpenSearchArea = useNnMasterMappingStore(s => s.setOpenSearchArea);

  // 화면 진입 시 자동 조회 (사용자 요구 2026-06-01)
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

  const rows = ((data as { o_rc1?: Record<string, unknown>[] })?.o_rc1 ?? []) as Record<string, unknown>[];

  return (
    <div className={styles.container}>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && <NnMasterMappingForm onSearch={handleSearch} />}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='NnMasterMapping'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchCondition}
      />
      <div className={styles.gridContainer}>
        <FlexGrid
          className={styles.grid}
          initialized={(g: FlexGridType<Record<string, unknown>>) => {
            if (gridRef && 'current' in gridRef) {
              (gridRef as { current: FlexGridType<Record<string, unknown>> | null }).current = g;
            }
            // As-Is .cs L515 `siMain.SmartColMerge()` 계층적 동작 (사용자 요구 2026-06-02):
            //   - allowMerging=true column 의 cell 머지
            //   - 좌측 모든 allowMerging column 도 같은 값일 때만 머지 (column-dependent)
            g.allowMerging = AllowMerging.Cells;
            g.mergeManager = new HierarchicalMergeManager();
          }}
          itemsSource={rows}
          autoGenerateColumns={false}
        >
          {MAIN_COLUMNS.map(c => (
            <FlexGridColumn
              key={c.key}
              binding={c.key}
              header={c.header}
              width={c.width}
              isReadOnly={true}
              allowMerging={c.merge ?? false}
            />
          ))}
        </FlexGrid>
      </div>
    </div>
  );
};
