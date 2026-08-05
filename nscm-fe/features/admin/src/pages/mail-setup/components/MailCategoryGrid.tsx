import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import type { CategoryRow } from '../mail-setup.types';
import { useMailSetupStore } from '../useMailSetupStore';

import styles from './MailCategoryGrid.module.scss';

interface MailCategoryGridProps {
  gridRef: MutableRefObject<FlexGrid<CategoryRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: CategoryRow[];
  onOpenSqlDialog: (row: CategoryRow) => void;
}

export const MailCategoryGrid = ({
  gridRef,
  gridFilterRef,
  data,
  onOpenSqlDialog,
}: MailCategoryGridProps) => {
  const categoryColumns = useMailSetupStore(state => state.categoryColumns);
  const selectCategory = useMailSetupStore(state => state.selectCategory);

  // 행 선택 → Message / 수신자 디테일 조회 (AS-IS: Category 행 선택 시 두 탭 동시 갱신)
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    const handleSelectionChanged = (sender: FlexGrid<CategoryRow>) => {
      const row = sender.selectedItems?.[0] as CategoryRow | undefined;
      selectCategory(row);
    };

    grid.selectionChanged.addHandler(handleSelectionChanged);
    return () => grid.selectionChanged.removeHandler(handleSelectionChanged);
  }, [gridRef, selectCategory, categoryColumns]);

  // SQL VIEW 셀 더블클릭 → PopSQL (AS-IS: CATEGORY_ID 가 있는 저장된 행만)
  const handleDoubleClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;

    const hitTest = grid.hitTest(mouseEvent);
    if (hitTest.cellType !== CellType.Cell) return;
    if (grid.columns[hitTest.col]?.binding !== 'VIEW') return;

    const row = grid.rows[hitTest.row]?.dataItem as CategoryRow | undefined;
    if (!row?.CATEGORY_ID) return;

    onOpenSqlDialog(row);
  };

  return (
    <div className={styles.gridSection}>
      <div className={styles.gridWrapper}>
        <DataGrid<CategoryRow>
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          itemsSource={data}
          staticColumns={categoryColumns}
          useSummaryTooltip={false}
          dblClick={handleDoubleClick}
        />
      </div>
    </div>
  );
};
