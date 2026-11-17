import { Globalize } from '@mescius/wijmo';
import { CellType, Row, type FlexGrid, type FormatItemEventArgs } from '@mescius/wijmo.grid';
import { useEffect, type MutableRefObject } from 'react';

import { safeString } from '@foundation/utils';

// 합계 서식 — AS-IS `SetAggregationFormat(0, iCol, "{0:#,##0.###}")`(cs:3630). ColumnFooter 에만 적용(데이터 셀 불변).
const FOOTER_SUM_FORMAT = '#,##0.###';
// 합계 셀 배경 — AS-IS `ColumnFooter.Cells[0,iCol].BackColor = Color.LightGray`(cs:3632).
const FOOTER_SUM_BACKGROUND = '#d3d3d3';

const toNumber = (v: unknown): number =>
  typeof v === 'number' ? v : Number(safeString(v).replace(/,/g, ''));

/**
 * 하단 상세 그리드 ColumnFooter 합계(Sum) — AS-IS InitSpreadFooterSum(cs:3597-3636) 이식.
 *
 * **동작 검증된 자매 SSP0026 ShipmentRequestPackDetailGrid(QTY Sum)과 동일 패턴**이다. wijmo columnFooters 는
 * 그리드 컨트롤 바닥에 고정(frozen)되므로 별도 위치 보정(pin)이 불필요하다 — 직접 pin 을 걸면 오히려 native
 * 고정을 덮어써 footer 가 어긋난다(2026-10-28 실패 경험).
 *  - `new Row()`(GroupRow 아님 — GroupRow 는 이 환경에서 renderHeight 0)
 *  - 합계 수동계산 `footer.setCellData` (wijmo `column.aggregate` 미사용)
 *  - `g.invalidate()` 로 재레이아웃
 *  - 데이터 0건이면 푸터 행을 비워 **데이터 있을 때만** 표시(사용자 지시 2026-10-28)
 */
export const useFooterSum = <T extends object>(
  gridRef: MutableRefObject<FlexGrid<T> | undefined>,
  staticColumns: readonly unknown[],
  rows: readonly T[],
  aggregateColumns: readonly string[]
) => {
  // 푸터 구성 — 데이터·컬럼메타가 바뀔 때마다(staticColumns 로드 후 컬럼이 생겨야 인덱스를 찾는다).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const footer = g.columnFooters;
    footer.rows.clear();
    if (rows.length === 0) {
      g.invalidate();
      return;
    }
    footer.rows.push(new Row());
    g.bottomLeftCells.setCellData(0, 0, 'Sum');
    for (const binding of aggregateColumns) {
      const colIdx = g.columns.findIndex(c => c.binding === binding);
      if (colIdx < 0) continue;
      let sum = 0;
      for (const r of rows as readonly Record<string, unknown>[]) {
        const n = toNumber(r[binding]);
        if (Number.isFinite(n)) sum += n;
      }
      footer.setCellData(0, colIdx, sum === 0 ? null : sum);
    }
    g.invalidate();
  }, [rows, staticColumns, gridRef, aggregateColumns]);

  // 합계 셀 서식(#,##0.###)·배경(LightGray) — AS-IS 는 ColumnFooter 에만 적용(cs:3630-3632).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const sumSet = new Set<string>(aggregateColumns);
    const fmt = (sender: FlexGrid, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.ColumnFooter) return;
      e.cell.style.backgroundColor = FOOTER_SUM_BACKGROUND;
      if (!sumSet.has(sender.columns[e.col]?.binding ?? '')) return;
      const value = e.panel.getCellData(e.row, e.col, false) as unknown;
      if (typeof value === 'number') e.cell.textContent = Globalize.format(value, FOOTER_SUM_FORMAT);
    };
    g.formatItem.addHandler(fmt);
    g.invalidate();
    return () => {
      try {
        g.formatItem?.removeHandler(fmt);
      } catch {
        /* unmount race */
      }
    };
  }, [rows, staticColumns, gridRef, aggregateColumns]);
};
