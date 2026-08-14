import {
  useEffect,
  useRef,
  useState,
  type MouseEvent as ReactMouseEvent,
  type ReactNode,
} from 'react';

import styles from './ColumnSelectDualList.module.scss';

// 공용 Column Setting dual list (2026-06-20 신설 / 2026-07-01 디자인 개편 + 우측 D&D 순서이동):
//   AS-IS DM0002_TitleSetForm_Popup.cs 의 Base/User dual list 동등 동작.
//   HTML <table> 자체 구현(wijmo 의존 0). 체크박스 다중선택 + No 컬럼 + 이동(▶◀).
//   ⭐ 우측(Visible) grid 는 행을 drag&drop 으로 위/아래 순서 이동 가능.
//   사용 화면: ColumnSettingModal (DMF0020 / DMF0043_01)

export interface DualListColumn<T> {
  key: keyof T;
  header: string;
  width?: number;
  align?: 'left' | 'center' | 'right';
  render?: (row: T, rowKey: string) => ReactNode;
}

// 컬럼 너비 조정(header 경계 드래그) 상수 — 체크/No 는 고정폭, 데이터 컬럼만 resize 대상.
type DualSide = 'left' | 'right';
const FIXED_COL_COUNT = 2; // check + No
const FIXED_COL_WIDTH = 48 + 60; // .checkCol + .noCol
const MIN_COL_WIDTH = 40;

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
}: Props<T>) => {
  // 우측 grid D&D 상태
  const [dragKey, setDragKey] = useState<string | null>(null);
  const [dragOverKey, setDragOverKey] = useState<string | null>(null);

  // 컬럼 너비 조정 상태 — null = 미조정(기존 colgroup width / auto 그대로).
  //   한 번이라도 드래그하면 해당 side 의 모든 데이터 컬럼이 px 확정 + 잔여폭 흡수용 spacer col 추가.
  const [colWidths, setColWidths] = useState<Record<DualSide, number[] | null>>({
    left: null,
    right: null,
  });
  const resizeRef = useRef<{
    side: DualSide;
    index: number;
    startX: number;
    base: number[];
  } | null>(null);

  useEffect(() => {
    const stopResize = () => {
      if (!resizeRef.current) return;
      resizeRef.current = null;
      document.body.style.removeProperty('cursor');
      document.body.style.removeProperty('user-select');
    };
    const handleMove = (e: MouseEvent) => {
      const drag = resizeRef.current;
      if (!drag) return;
      const next = [...drag.base];
      next[drag.index] = Math.max(MIN_COL_WIDTH, drag.base[drag.index] + (e.clientX - drag.startX));
      setColWidths(previous => ({ ...previous, [drag.side]: next }));
    };
    window.addEventListener('mousemove', handleMove);
    window.addEventListener('mouseup', stopResize);
    return () => {
      window.removeEventListener('mousemove', handleMove);
      window.removeEventListener('mouseup', stopResize);
      stopResize();
    };
  }, []);

  // 경계 mousedown — 현재 렌더된 실제 셀 너비를 기준값으로 캡처(최초 auto 너비도 그대로 이어짐).
  //   table-layout:fixed 라 헤더/본문 어느 행에서 재도 컬럼 너비는 같다 → 본문 셀에서 잡아도 동일 동작.
  const beginResize =
    (side: DualSide, index: number, columnCount: number) =>
    (event: ReactMouseEvent<HTMLSpanElement>) => {
      event.preventDefault();
      event.stopPropagation();
      const row = event.currentTarget.closest('tr');
      if (!row) return;
      const base = Array.from(row.children)
        .slice(FIXED_COL_COUNT, FIXED_COL_COUNT + columnCount)
        .map(cell => Math.round(cell.getBoundingClientRect().width));
      resizeRef.current = { side, index, startX: event.clientX, base };
      setColWidths(previous => ({ ...previous, [side]: base }));
      document.body.style.cursor = 'col-resize';
      document.body.style.userSelect = 'none';
    };

  // 컬럼 경계 그랩존 — 구분선 좌우 8px. 헤더뿐 아니라 본문 셀에도 같이 깔아
  //   그리드를 세로로 관통하는 구분선 어디를 잡아도 너비 조정이 되게 한다.
  //   click/dblclick 은 여기서 막는다 — 경계를 만지다 행 선택/이동이 되면 안 된다.
  const resizeHandles = (side: DualSide, index: number, columnCount: number) => (
    <>
      {index > 0 && (
        <span
          className={`${styles.colResizer} ${styles.colResizerLeft}`}
          onMouseDown={beginResize(side, index - 1, columnCount)}
          onClick={event => event.stopPropagation()}
          onDoubleClick={event => event.stopPropagation()}
        />
      )}
      <span
        className={styles.colResizer}
        onMouseDown={beginResize(side, index, columnCount)}
        onClick={event => event.stopPropagation()}
        onDoubleClick={event => event.stopPropagation()}
      />
    </>
  );

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
    side: DualSide,
    items: T[],
    columns: DualListColumn<T>[],
    checked: Set<string>,
    onToggle: (key: string) => void,
    onToggleAll: (checked: boolean) => void,
    dnd = false,
    onRowDoubleClick?: (key: string) => void
  ) => {
    const allChecked = items.length > 0 && items.every(r => checked.has(String(r[itemKey] ?? '')));
    const widths = colWidths[side];
    // 조정 후에는 table 을 px 합계로 고정 — 컨테이너보다 넓어지면 가로 스크롤.
    const minWidth = widths ? FIXED_COL_WIDTH + widths.reduce((sum, w) => sum + w, 0) : undefined;
    return (
      <div className={styles.tableScroll}>
        <table className={styles.table} style={minWidth ? { minWidth } : undefined}>
          <colgroup>
            <col className={styles.checkCol} />
            <col className={styles.noCol} />
            {columns.map((c, i) => {
              const width = widths ? widths[i] : c.width;
              return <col key={i} style={width ? { width } : undefined} />;
            })}
            {widths && <col />}
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
              {columns.map((col, i) => (
                <th key={String(col.key)}>
                  {col.header}
                  {resizeHandles(side, i, columns.length)}
                </th>
              ))}
              {widths && <th aria-hidden='true' />}
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
                  {columns.map((col, colIndex) => (
                    <td key={String(col.key)} style={{ textAlign: col.align ?? 'left' }}>
                      {col.render ? col.render(row, rowKey) : String(row[col.key] ?? '')}
                      {resizeHandles(side, colIndex, columns.length)}
                    </td>
                  ))}
                  {widths && <td aria-hidden='true' />}
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
