import {
  AllowMerging,
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import type { BUCKET_TYPE } from '../shipment-plan-fix.constants';
import { WEEKEND_COLOR } from '../shipment-plan-fix.constants';
import type { MainRow } from '../shipment-plan-fix.types';
import { buildFixedColumns, buildPivotColumns } from '../utils/shipmentPlanFixColumns';
import { pivotKind, type VisibilityContext } from '../utils/shipmentPlanFixVisibility';

interface Props {
  rows: MainRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  bucket: BUCKET_TYPE;
  chkSum: boolean;
  visibilityCtx: VisibilityContext;
  adminColumns?: RawFlexGridColumnConfig[];
  onFocus: () => void;
}

const pivotTag = (binding: string): string => binding.slice(2).replace(/[^0-9]/g, '');

// AS-IS GSCM.SCP.Analysis.UIL SCP0025 spdMain — 20 고정(정보/키·measure frozen) + D_/W_/M_ 동적 pivot(3단 헤더).
//   measure=행 축(Ship Plan 위 / Fix Reason 아래). 전 컬럼 read-only(INPUT_TP_CD='S' 전건, LockColumn all — design 03 R-G).
//   편집 그리드가 아니다 → beginningEdit/pastingCell/EditTracker 편집 없음. Unfix 는 셀 선택 → 페이지 handleUnfix(§4.3).
//   버튼-API 배선(DB 실측): SCM_ADM_MNU_BTN_MPG_M 2행(main/SEARCH·main/SAVE) 등록. PKG_SCP0025 VALID.
export const ShipmentPlanFixGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  bucket,
  chkSum,
  visibilityCtx,
  adminColumns,
  onFocus,
}: Props) => {
  const fixedColumns = useMemo(
    () => buildFixedColumns(adminColumns, visibilityCtx),
    [adminColumns, visibilityCtx]
  );
  const pivotColumns = useMemo(
    () => buildPivotColumns(rows as unknown as Record<string, unknown>[], bucket, chkSum),
    [rows, bucket, chkSum]
  );

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 요일 헤더 색(design 03 §2.4 R-A — 토 Blue / 일 Red, gridSignals #29 ForeColor).
    const formatHandler = (_sender: FlexGridType, ev: FormatItemEventArgs) => {
      const binding = ev.panel.columns[ev.col]?.binding ?? '';
      if (ev.panel.cellType === CellType.ColumnHeader) {
        if (pivotKind(binding) !== 'D') return;
        const d = pivotTag(binding);
        if (d.length < 8) return;
        const date = new Date(Date.UTC(+d.slice(0, 4), +d.slice(4, 6) - 1, +d.slice(6, 8)));
        const dow = date.getUTCDay();
        if (dow === 6) ev.cell.style.color = WEEKEND_COLOR.SATURDAY; // 토 Blue
        else if (dow === 0) ev.cell.style.color = WEEKEND_COLOR.SUNDAY; // 일 Red
      }
    };
    g.formatItem.addHandler(formatHandler);

    // 정보/키 컬럼 세로 병합 — AS-IS siMain.SmartColMerge (gridSignals #26/#44, design 03 R-F).
    //   공용 CustomMergeManager 가 좌측 누적 키로 정보/키 컬럼만 계층 병합. pivot(D_/W_/M_)은 병합 대상 아님.
    for (let i = 0; i < g.columns.length; i++) {
      const b = g.columns[i].binding ?? '';
      g.columns[i].allowMerging = pivotKind(b) === null;
    }
    g.invalidate(true);

    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [fixedColumns, pivotColumns]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={fixedColumns}
      dynamicColumns={pivotColumns}
      allowMerging={AllowMerging.All}
      gotFocus={onFocus}
    />
  );
};
