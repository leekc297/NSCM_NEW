import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import type { MessageRow } from '../mail-setup.types';
import { useMailSetupStore } from '../useMailSetupStore';

import styles from './MailTabGrid.module.scss';

interface MailMessageGridProps {
  gridRef: MutableRefObject<FlexGrid<MessageRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: MessageRow[];
  onOpenContent: (row: MessageRow) => void;
}

export const MailMessageGrid = ({
  gridRef,
  gridFilterRef,
  data,
  onOpenContent,
}: MailMessageGridProps) => {
  const messageColumns = useMailSetupStore(state => state.messageColumns);

  // Mail Content 셀 더블클릭 → 본문 편집/조회 다이얼로그 (AS-IS PopContent)
  const handleDoubleClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;

    const hitTest = grid.hitTest(mouseEvent);
    if (hitTest.cellType !== CellType.Cell) return;
    if (grid.columns[hitTest.col]?.binding !== 'MESSAGE_CONTENT') return;

    const row = grid.rows[hitTest.row]?.dataItem as MessageRow | undefined;
    if (!row) return;

    onOpenContent(row);
  };

  return (
    <div className={styles.gridWrapper}>
      <DataGrid<MessageRow>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        itemsSource={data}
        staticColumns={messageColumns}
        useSummaryTooltip={false}
        dblClick={handleDoubleClick}
      />
    </div>
  );
};
