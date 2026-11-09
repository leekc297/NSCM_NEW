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
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
}

// AS-IS spdMain/spdGap — DB메타 6칼럼(세로병합) + 동적 pivot(월단위 3-way) + SUBTOTAL/GAP(Main만)/비고.
// 편집모델: TO-BE 는 EditButton 토글 없이 편집가능 컬럼(비고 NOTE)이 상시 편집가능(사용자 지시 2026-10-30).
//   저장은 공통 Save 버튼. 비고 외 전 컬럼은 읽기전용(AS-IS LockColumn FROM_SITE~GAP 등가, design 03 §3 #29).
//   팀명 공백 행 비고는 배경만 LightGray + 편집 차단(#29-부속).
export const ShipmentAlloReportGrid = ({
  rows,
  adminColumns,
  months,
  isGapTab,
  gridRef,
  gridFilterRef,
  editTrackerRef,
}: Props) => {
  const fixedColumns = useMemo(() => buildFixedColumns(adminColumns), [adminColumns]);
  const pivotColumns = useMemo(() => buildPivotColumns(months), [months]);
  const derivedColumns = useMemo(() => buildDerivedColumns(isGapTab), [isGapTab]);
  const dynamicColumns = useMemo(() => [...pivotColumns, ...derivedColumns], [pivotColumns, derivedColumns]);

  // 색상·편집 핸들러 — deps 에 dynamicColumns/rows 를 넣어 조회(데이터 로드)로 그리드가 준비/재구성된
  //   뒤 재등록한다. deps 가 [gridRef] 뿐이면 마운트 시 1회만 돌아 그리드 준비 전이면 핸들러가 영영 안
  //   붙는다(색상 전부 누락). 정본 패턴: SCP0018 WaterfallShipmentPlanSemiGrid.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 색상(AS-IS 등가):
    //   - 음수 빨강(SetReNumerCellType NegativeRed, cs:201~255): Main·Gap 공통(InitSpread siMain+siGap, cs:382~383).
    //   - 배경색(팀공백 비고 회색 cs:515 / 요약행 노랑 cs:1186 / 편집가능 비고 노랑): Main 전용
    //     (AS-IS svMain 만, siGap 은 RefreshGridGAP·회색 대상 아님). Gap 은 배경색 없음.
    const formatHandler = (_sender: FlexGridType, ev: FormatItemEventArgs) => {
      if (ev.panel.cellType !== CellType.Cell) return;
      const row = ev.panel.rows[ev.row]?.dataItem as ShipmentAlloRow | undefined;
      if (!row) return;
      const binding = ev.panel.columns[ev.col]?.binding ?? '';
      const isNote = binding === 'NOTE';

      if (isGapTab) {
        ev.cell.style.backgroundColor = '';
      } else if (isNote && row.IS_TEAM_BLANK) {
        ev.cell.style.backgroundColor = 'lightgray';
      } else if (row.IS_SUMMARY) {
        ev.cell.style.backgroundColor = 'lightyellow';
      } else if (isNote) {
        ev.cell.style.backgroundColor = '#fffbcc';
      } else {
        ev.cell.style.backgroundColor = '';
      }

      const raw = row[binding];
      const num = typeof raw === 'number' ? raw : raw != null && raw !== '' ? Number(raw) : NaN;
      ev.cell.style.color = Number.isFinite(num) && num < 0 ? '#c62828' : '';
    };
    g.formatItem.addHandler(formatHandler);

    // 상시 편집(더블클릭 불필요, Main 전용) — 비고 셀 선택 즉시 편집 시작(rAF 로 선택 재진입 회피).
    //   편집 가부/변경추적은 columns 의 NOTE._inputEditType=OPTIONAL 가 공통 인프라로 처리한다(editGate 불요).
    const selectionHandler = (_s: FlexGridType) => {
      if (_s.activeEditor) return;
      const sel = _s.selection;
      if (sel.row < 0 || _s.columns[sel.col]?.binding !== 'NOTE') return;
      const r = sel.row;
      const c = sel.col;
      requestAnimationFrame(() => {
        try {
          if (!_s.activeEditor) _s.startEditing(false, r, c);
        } catch {
          /* startEditing race */
        }
      });
    };
    if (!isGapTab) {
      g.selectionChanged.addHandler(selectionHandler);
    }

    g.invalidate(true);

    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
        if (!isGapTab) {
          g.selectionChanged?.removeHandler(selectionHandler);
        }
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, dynamicColumns, rows, isGapTab]);

  // 헤더 높이 강제(#93 총 48px) — 공용 headerRowHeight prop(rows.defaultSize 만)은 정적컬럼의 명시
  //   height(mapRawColumnsToWijmoColumns 가 넣는 48)가 각 헤더 row 에 박혀 무효가 된다. 실제 렌더된
  //   헤더 row 마다 height 를 48/tier 로 직접 박아야 다른 화면과 같은 총높이가 된다(정본: DemandPlanWaterfall).
  //   tier 수는 예측(2단)이 아니라 wijmo 가 실제 만든 rows.length 로 나눈다(전이 중 빈 tier 대비).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const applyHeaderHeight = () => {
      const headerRows = g.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      const target = 48 / headerRows.length;
      let changed = false;
      for (let i = 0; i < headerRows.length; i += 1) {
        if (Math.round(headerRows[i].height ?? headerRows.defaultSize) !== Math.round(target)) {
          headerRows[i].height = target;
          changed = true;
        }
      }
      if (Math.round(headerRows.defaultSize) !== Math.round(target)) {
        headerRows.defaultSize = target;
        changed = true;
      }
      if (changed) g.invalidate(true);
    };
    applyHeaderHeight();
    g.updatedLayout.addHandler(applyHeaderHeight);
    return () => {
      try {
        g.updatedLayout?.removeHandler(applyHeaderHeight);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, dynamicColumns, fixedColumns]);

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
