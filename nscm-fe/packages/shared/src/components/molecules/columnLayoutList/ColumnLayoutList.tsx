import { useState } from 'react';

import { clsx } from '@shared/clsx';

import { ColorPickerButton } from '../colorPickerButton/ColorPickerButton';

import styles from './ColumnLayoutList.module.scss';
import { computeReorder } from './columnLayoutList.utils';

export interface ColumnLayoutRow {
  COLUMN_NAME: string;
  COLUMN_LABEL_NAME: string;
  USER_FLAG: 'Y' | 'N';
  SORT_ORDER_NO: number;
  COL_WIDTH: number;
  CELL_COLOR: string;
  TEXT_COLOR: string;
  isKey: boolean;
}

interface Props {
  /** SORT_ORDER_NO 오름차순 정렬된 전체 컬럼 */
  rows: ColumnLayoutRow[];
  onToggleDisplay: (key: string) => void;
  onChangeWidth: (key: string, rawValue: string) => void;
  onChangeCellColor: (key: string, hex: string) => void;
  onChangeTextColor: (key: string, hex: string) => void;
  onReorder: (orderedKeys: string[]) => void;
}

export const ColumnLayoutList = ({
  rows,
  onToggleDisplay,
  onChangeWidth,
  onChangeCellColor,
  onChangeTextColor,
  onReorder,
}: Props) => {
  const [dragKey, setDragKey] = useState<string | null>(null);
  const [dragOverKey, setDragOverKey] = useState<string | null>(null);

  const handleDrop = (targetKey: string) => {
    const dk = dragKey;
    setDragKey(null);
    setDragOverKey(null);
    if (!dk) return;
    const keys = rows.map(r => r.COLUMN_NAME);
    const next = computeReorder(keys, dk, targetKey);
    if (next !== keys) onReorder(next);
  };

  return (
    <div className={styles.tableScroll}>
      <table className={styles.table}>
        <colgroup>
          <col className={styles.orderCol} />
          <col />
          <col className={styles.displayCol} />
          <col className={styles.widthCol} />
          <col className={styles.colorCol} />
          <col className={styles.colorCol} />
        </colgroup>
        <thead>
          <tr>
            <th className={styles.center}>Order</th>
            <th>Columns</th>
            <th className={styles.center}>Display</th>
            <th className={styles.center}>Width</th>
            <th className={styles.center}>Cell Color</th>
            <th className={styles.center}>Text Color</th>
          </tr>
        </thead>
        <tbody>
          {rows.map((row, i) => {
            const key = row.COLUMN_NAME;
            const cls = clsx(styles.draggableRow, {
              [styles.dragOver]: dragOverKey === key,
              [styles.dragging]: dragKey === key,
            });
            return (
              <tr
                key={key}
                className={cls}
                draggable
                onDragStart={() => setDragKey(key)}
                onDragOver={e => {
                  e.preventDefault();
                  if (dragOverKey !== key) setDragOverKey(key);
                }}
                onDrop={e => {
                  e.preventDefault();
                  handleDrop(key);
                }}
                onDragEnd={() => {
                  setDragKey(null);
                  setDragOverKey(null);
                }}
              >
                <td className={styles.orderCell}>{i + 1}</td>
                <td
                  className={clsx(styles.labelCell, { [styles.keyLabel]: row.isKey })}
                  title={row.COLUMN_LABEL_NAME}
                >
                  {row.COLUMN_LABEL_NAME}
                </td>
                <td className={styles.center}>
                  <input
                    type='checkbox'
                    checked={row.USER_FLAG === 'Y'}
                    disabled={row.isKey}
                    onChange={() => onToggleDisplay(key)}
                  />
                </td>
                <td className={styles.center}>
                  <input
                    type='number'
                    min={0}
                    className={styles.widthInput}
                    value={row.COL_WIDTH}
                    onChange={e => onChangeWidth(key, e.target.value)}
                  />
                </td>
                <td className={styles.center}>
                  <ColorPickerButton
                    value={row.CELL_COLOR}
                    onChange={hex => onChangeCellColor(key, hex)}
                    title='Cell Color'
                    autoColor='#ffffff'
                  />
                </td>
                <td className={styles.center}>
                  <ColorPickerButton
                    value={row.TEXT_COLOR}
                    onChange={hex => onChangeTextColor(key, hex)}
                    title='Text Color'
                  />
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
};
