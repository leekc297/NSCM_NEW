import { useState, type ReactNode } from 'react';

import styles from './ColumnSelectDualList.module.scss';

// 공용 Column Setting dual list (2026-06-20 신설 / 2026-07-01 디자인 개편 + 우측 D&D 순서이동):
//   AS-IS DM0002_TitleSetForm_Popup.cs 의 Base/User dual list 동등 동작.
//   HTML <table> 자체 구현(wijmo 의존 0). 체크박스 다중선택 + No 컬럼 + 이동(▶◀).
//   ⭐ 우측(Visible) grid 는 행을 drag&drop 으로 위/아래 순서 이동 가능.
//   사용 화면: 공용 ColumnLayoutModal/MeasureSelectModal (구 ColumnSettingModal 폐기 — 2026-08-13)

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
  /** 체크된 좌/우 키 집합 (다중선택) */
  checkedLeft: Set<string>;
  checkedRight: Set<string>;
  onToggleLeft: (key: string) => void;
  onToggleRight: (key: string) => void;
  onToggleAllLeft: (checked: boolean) => void;
  onToggleAllRight: (checked: boolean) => void;
  onMoveRight: () => void;
  onMoveLeft: () => void;
  /** 우측 grid 행 D&D 순서 이동 — 재정렬된 key 배열(위→아래) 전달 */
  onReorderRight?: (orderedKeys: string[]) => void;
  /** 좌측 행 더블클릭 — 해당 행 1개를 우측으로 이동 (▶ 와 동일 동작) */
  onRowDoubleClickLeft?: (key: string) => void;
  /** 우측 행 더블클릭 — 해당 행 1개를 좌측으로 이동 (◀ 와 동일 동작) */
  onRowDoubleClickRight?: (key: string) => void;
  /** 좌측 grid 상단 라벨 (예: 'Invisible') — 미지정 시 라벨 없음(기존 사용처 무영향) */
  leftTitle?: string;
  /** 우측 grid 상단 라벨 (예: 'Visible') */
  rightTitle?: string;
  /**
   * 헤더 경계 드래그로 컬럼 폭 조절 (기본 false — 기존 사용처 무영향).
   * 통합테스트 1st No.40-② "컬럼 사이즈 조절 가능하도록 수정"(Measure Setting 팝업) 대응.
   */
  resizableColumns?: boolean;
}

export const ColumnSelectDualList = <T extends Record<string, string | number>>({
  leftItems,
  rightItems,
  leftColumns,
  rightColumns,
  itemKey,
  checkedLeft,
  checkedRight,
  onToggleLeft,
  onToggleRight,
  onToggleAllLeft,
  onToggleAllRight,
  onMoveRight,
  onMoveLeft,
  onReorderRight,
  onRowDoubleClickLeft,
  onRowDoubleClickRight,
  leftTitle,
  rightTitle,
  resizableColumns = false,
}: Props<T>) => {
  // 우측 grid D&D 상태
  const [dragKey, setDragKey] = useState<string | null>(null);
  const [dragOverKey, setDragOverKey] = useState<string | null>(null);

  // ⭐ [No.40-② 2026-08-11] 컬럼 폭 조절 — 헤더 우측 경계를 잡고 끌면 폭이 바뀐다.
  //   좌/우 grid 를 독립 관리한다(키 = `${side}:${columnKey}`). 값이 없으면 기존 `col.width` 를 그대로 쓴다.
  //   wijmo 를 쓰지 않는 순수 <table> 이라 pointer 이벤트로 직접 구현한다(table-layout: fixed 이므로
  //   <col> 폭만 바꾸면 즉시 반영된다).
  const [colWidths, setColWidths] = useState<Record<string, number>>({});
  const MIN_COL_WIDTH = 48;
  const startResize = (widthKey: string, startX: number, startWidth: number) => {
    const onMove = (ev: PointerEvent) => {
      const next = Math.max(MIN_COL_WIDTH, Math.round(startWidth + (ev.clientX - startX)));
      setColWidths(prev => (prev[widthKey] === next ? prev : { ...prev, [widthKey]: next }));
    };
    const onUp = () => {
      window.removeEventListener('pointermove', onMove);
      window.removeEventListener('pointerup', onUp);
    };
    window.addEventListener('pointermove', onMove);
    window.addEventListener('pointerup', onUp);
  };

  const handleDrop = (targetKey: string) => {
    const dk = dragKey;
    setDragKey(null);
    setDragOverKey(null);
    if (!dk || !onReorderRight) return;
    const keys = rightItems.map(r => String(r[itemKey] ?? ''));
    const from = keys.indexOf(dk);
    const to = keys.indexOf(targetKey);
    if (from < 0 || to < 0 || from === to) return;
    const next = [...keys];
    next.splice(from, 1);
    next.splice(to, 0, dk);
    onReorderRight(next);
  };

  const renderTable = (
    side: 'left' | 'right',
    items: T[],
    columns: DualListColumn<T>[],
    checked: Set<string>,
    onToggle: (key: string) => void,
    onToggleAll: (checked: boolean) => void,
    dnd = false,
    onRowDoubleClick?: (key: string) => void
  ) => {
    const allChecked = items.length > 0 && items.every(r => checked.has(String(r[itemKey] ?? '')));
    return (
      <div className={styles.tableScroll}>
        <table className={styles.table}>
          <colgroup>
            <col className={styles.checkCol} />
            <col className={styles.noCol} />
            {columns.map((c, i) => {
              const w = colWidths[`${side}:${String(c.key)}`] ?? c.width;
              return <col key={i} style={w ? { width: w } : undefined} />;
            })}
          </colgroup>
          <thead>
            <tr>
              <th className={styles.checkCell}>
                <input
                  type='checkbox'
                  className={styles.checkbox}
                  checked={allChecked}
                  onChange={e => onToggleAll(e.target.checked)}
                />
              </th>
              <th className={styles.noCell}>No</th>
              {columns.map(col => {
                const widthKey = `${side}:${String(col.key)}`;
                return (
                  <th key={String(col.key)} className={resizableColumns ? styles.resizableTh : undefined}>
                    {col.header}
                    {resizableColumns && (
                      <span
                        className={styles.resizeGrip}
                        role='separator'
                        aria-orientation='vertical'
                        onClick={ev => ev.stopPropagation()}
                        onPointerDown={ev => {
                          ev.preventDefault();
                          ev.stopPropagation();
                          const th = (ev.target as HTMLElement).parentElement;
                          startResize(
                            widthKey,
                            ev.clientX,
                            colWidths[widthKey] ?? col.width ?? th?.offsetWidth ?? MIN_COL_WIDTH
                          );
                        }}
                      />
                    )}
                  </th>
                );
              })}
            </tr>
          </thead>
          <tbody>
            {items.map((row, i) => {
              const rowKey = String(row[itemKey] ?? '');
              const isChecked = checked.has(rowKey);
              const cls = [
                isChecked ? styles.checkedRow : '',
                dnd && dragOverKey === rowKey ? styles.dragOver : '',
                dnd && dragKey === rowKey ? styles.dragging : '',
                dnd ? styles.draggableRow : '',
              ]
                .filter(Boolean)
                .join(' ');
              return (
                <tr
                  key={rowKey || `row-${i}`}
                  className={cls}
                  draggable={dnd}
                  onClick={() => onToggle(rowKey)}
                  onDoubleClick={onRowDoubleClick ? () => onRowDoubleClick(rowKey) : undefined}
                  onDragStart={dnd ? () => setDragKey(rowKey) : undefined}
                  onDragOver={
                    dnd
                      ? e => {
                          e.preventDefault();
                          if (dragOverKey !== rowKey) setDragOverKey(rowKey);
                        }
                      : undefined
                  }
                  onDrop={
                    dnd
                      ? e => {
                          e.preventDefault();
                          handleDrop(rowKey);
                        }
                      : undefined
                  }
                  onDragEnd={
                    dnd
                      ? () => {
                          setDragKey(null);
                          setDragOverKey(null);
                        }
                      : undefined
                  }
                >
                  <td className={styles.checkCell}>
                    <input
                      type='checkbox'
                      className={styles.checkbox}
                      checked={isChecked}
                      onChange={() => onToggle(rowKey)}
                      onClick={e => e.stopPropagation()}
                    />
                  </td>
                  <td className={styles.noCell}>{i + 1}</td>
                  {columns.map(col => (
                    <td key={String(col.key)} style={{ textAlign: col.align ?? 'left' }}>
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
  };

  return (
    <div className={styles.dualListContainer}>
      <div className={styles.sideTable}>
        {leftTitle && <div className={styles.dualTitle}>{leftTitle}</div>}
        {renderTable(
          'left',
          leftItems,
          leftColumns,
          checkedLeft,
          onToggleLeft,
          onToggleAllLeft,
          false,
          onRowDoubleClickLeft
        )}
      </div>

      <div className={styles.moveButtons}>
        <button type='button' onClick={onMoveRight} title='우측 추가' className={styles.arrowBtn}>
          ▶
        </button>
        <button type='button' onClick={onMoveLeft} title='좌측 제거' className={styles.arrowBtn}>
          ◀
        </button>
      </div>

      <div className={styles.sideTable}>
        {rightTitle && <div className={styles.dualTitle}>{rightTitle}</div>}
        {renderTable(
          'right',
          rightItems,
          rightColumns,
          checkedRight,
          onToggleRight,
          onToggleAllRight,
          true,
          onRowDoubleClickRight
        )}
      </div>
    </div>
  );
};
