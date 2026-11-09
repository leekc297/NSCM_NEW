import { AllowMerging, CellType, type FlexGrid as FlexGridType, type FormatItemEventArgs } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { PivotMonthMeta, ShipmentAlloRow } from '../shipment-allo-report.types';
import { buildDerivedColumns, buildFixedColumns, buildPivotColumns } from '../utils/shipment-allo-report.columns';

interface Props {
  rows: ShipmentAlloRow[];
  adminColumns: RawFlexGridColumnConfig[];
  months: PivotMonthMeta[];
  isGapTab: boolean;
  // EditButton 토글 상태(design 01 §2 #14/#17) — 비고(NOTE)만 이 값을 따른다.
  editable: boolean;
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
}

// AS-IS spdMain/spdGap — DB메타 6칼럼(세로병합) + 동적 pivot(월단위 3-way) + SUBTOTAL/GAP(Main만)/비고.
// 비고만 편집대상(design 03 §3 #29) — EditButton 클릭 전(#31)엔 비고도 잠김. 팀명 공백 행은 배경만
// LightGray(#29-부속, 실제 잠금 아님 — 편집 차단하지 않는다).
export const ShipmentAlloReportGrid = ({
  rows,
  adminColumns,
  months,
  isGapTab,
  editable,
  gridRef,
  gridFilterRef,
  editTrackerRef,
}: Props) => {
  const fixedColumns = useMemo(() => buildFixedColumns(adminColumns), [adminColumns]);
  const pivotColumns = useMemo(() => buildPivotColumns(months), [months]);
  const derivedColumns = useMemo(() => buildDerivedColumns(editable, isGapTab), [editable, isGapTab]);
  const dynamicColumns = useMemo(() => [...pivotColumns, ...derivedColumns], [pivotColumns, derivedColumns]);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    const formatHandler = (_sender: FlexGridType, ev: FormatItemEventArgs) => {
      if (ev.panel.cellType !== CellType.Cell) return;
      const row = ev.panel.rows[ev.row]?.dataItem as ShipmentAlloRow | undefined;
      if (!row) return;

      // 요약행(RefreshGridGAP) — 노란 배경(design 03 §3.1).
      if (row.IS_SUMMARY) {
        ev.cell.style.backgroundColor = 'lightyellow';
        return;
      }
      const binding = ev.panel.columns[ev.col]?.binding ?? '';
      // 팀명 공백 행 비고 셀 — 회색 배경(시각효과만, 실제 잠금 아님, design 03 §3 #29-부속).
      if (binding === 'NOTE' && row.IS_TEAM_BLANK) {
        ev.cell.style.backgroundColor = 'lightgray';
      }
    };
    g.formatItem.addHandler(formatHandler);
    g.invalidate(true);

    const beginningEditHandler = (_s: FlexGridType, e: { cancel: boolean; row: number; col: number }) => {
      const col = _s.columns[e.col];
      // FROM_SITE~GAP 구간은 EditButton 상태와 무관하게 항상 잠금 — 비고만 editable 값을 따른다(design 03 §3 #29).
      if (col.binding !== 'NOTE' || !editable) {
        e.cancel = true;
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
        g.beginningEdit?.removeHandler(beginningEditHandler);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, editable]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={fixedColumns}
      dynamicColumns={dynamicColumns}
      allowMerging={AllowMerging.All}
    />
  );
};
