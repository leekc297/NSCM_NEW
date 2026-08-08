import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, type MutableRefObject } from 'react';

import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import type { MessageRow } from '../mail-setup.types';
import { isOverMailContentLimit } from '../mail-setup.util';
import { useMailSetupStore } from '../useMailSetupStore';

import styles from './MailTabGrid.module.scss';

interface MailMessageGridProps {
  gridRef: MutableRefObject<FlexGrid<MessageRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<MessageRow> | undefined>;
  data: MessageRow[];
  onGridClick: () => void;
  onOpenContent: (row: MessageRow) => void;
}

export const MailMessageGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  onGridClick,
  onOpenContent,
}: MailMessageGridProps) => {
  const { t } = useTranslation();

  const messageColumns = useMailSetupStore(state => state.messageColumns);
  const setAlert = useMessageStore(state => state.setAlert);

  // Mail Content 그리드 직접 입력 4,000바이트 검사 — 초과 시 MSG00698 + 직전 값 원복 (AS-IS E12)
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    const cellEditEnded = (
      s: FlexGrid<MessageRow>,
      e: { row: number; col: number; data?: unknown }
    ) => {
      if (s.columns[e.col]?.binding !== 'MESSAGE_CONTENT') return;
      const row = s.rows[e.row]?.dataItem as MessageRow | undefined;
      if (!row) return;

      const value = String(row.MESSAGE_CONTENT ?? '');
      if (!isOverMailContentLimit(value)) return;

      row.MESSAGE_CONTENT = typeof e.data === 'string' ? e.data : '';
      void setAlert({
        type: 'alert',
        content: t('MSG00698', '_You have exceeded the number of digits you can enter.'),
      });
      s.invalidate(true);
    };

    grid.cellEditEnded.addHandler(cellEditEnded);
    return () => grid.cellEditEnded.removeHandler(cellEditEnded);
  }, [gridRef, messageColumns, setAlert, t]);

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
        editTrackerRef={editTrackerRef}
        itemsSource={data}
        staticColumns={messageColumns}
        useSummaryTooltip={false}
        dblClick={handleDoubleClick}
        click={onGridClick}
      />
    </div>
  );
};
