import { type ReactNode } from 'react';

import styles from './ColumnSelectDualList.module.scss';

// 신규 공용 컴포넌트 (2026-06-20 신설):
//   AS-IS DM0002_TitleSetForm_Popup.cs 의 Base/User dual list 동등 동작.
//   wijmo FlexGrid + CustomDialog 조합 selection 사고 (click row N → row 0 강제)
//   회피 — HTML <table> 으로 자체 구현. wijmo 의존 0.
//   사용 화면: ColumnSettingModal (DMF0020 / DMF0043_01)

export interface DualListColumn<T> {
  key: keyof T;
  header: string;
  width?: number;
  align?: 'left' | 'center' | 'right';
  render?: (row: T, rowKey: string) => ReactNode;
}

interface Props<T extends Record<string, string | number>> {
  leftItems: T[];
  rightItems: T[];
  leftColumns: DualListColumn<T>[];
  rightColumns: DualListColumn<T>[];
  /** 행 고유 식별 컬럼 (예: 'COLUMN_NAME') */
  itemKey: keyof T;
  selectedLeftKey: string | null;
  selectedRightKey: string | null;
  onSelectLeft: (key: string) => void;
  onSelectRight: (key: string) => void;
  onMoveRight: () => void;
  onMoveLeft: () => void;
  leftTitle?: string;
  rightTitle?: string;
}

export const ColumnSelectDualList = <T extends Record<string, string | number>>({
  leftItems,
  rightItems,
  leftColumns,
  rightColumns,
  itemKey,
  selectedLeftKey,
  selectedRightKey,
  onSelectLeft,
  onSelectRight,
  onMoveRight,
  onMoveLeft,
  leftTitle = 'Hidden',
  rightTitle = 'Visible',
}: Props<T>) => {
  const renderTable = (
    items: T[],
    columns: DualListColumn<T>[],
    selectedKey: string | null,
    onSelect: (key: string) => void
  ) => (
    <div className={styles.tableScroll}>
      <table className={styles.table}>
        <thead>
          <tr>
            {columns.map(col => (
              <th
                key={String(col.key)}
                style={{ width: col.width, textAlign: col.align ?? 'left' }}
              >
                {col.header}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {items.map((row, i) => {
            const rowKey = String(row[itemKey] ?? '');
            const isSelected = rowKey === selectedKey;
            return (
              <tr
                key={rowKey || `row-${i}`}
                className={isSelected ? styles.selected : ''}
                onClick={() => onSelect(rowKey)}
              >
                {columns.map(col => (
                  <td
                    key={String(col.key)}
                    style={{ textAlign: col.align ?? 'left' }}
                  >
                    {col.render ? col.render(row, rowKey) : String(row[col.key] ?? '')}
                  </td>
                ))}
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );

  return (
    <div className={styles.dualListContainer}>
      <div className={styles.sideTable}>
        <div className={styles.tableHeader}>{leftTitle}</div>
        {renderTable(leftItems, leftColumns, selectedLeftKey, onSelectLeft)}
      </div>

      <div className={styles.moveButtons}>
        <button
          type='button'
          onClick={onMoveRight}
          title='우측 추가'
          className={styles.arrowBtn}
        >
          ▶
        </button>
        <button
          type='button'
          onClick={onMoveLeft}
          title='좌측 제거'
          className={styles.arrowBtn}
        >
          ◀
        </button>
      </div>

      <div className={styles.sideTable}>
        <div className={styles.tableHeader}>{rightTitle}</div>
        {renderTable(rightItems, rightColumns, selectedRightKey, onSelectRight)}
      </div>
    </div>
  );
};
