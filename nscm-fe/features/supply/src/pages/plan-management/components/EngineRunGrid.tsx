import { CellType, type FlexGrid, type FormatItemEventArgs } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import type { EngineRow } from '../plan-management.types';
import {
  engineRowKey,
  STEP_PROCESS_BINDINGS,
} from '../utils/planManagementEngine';

import styles from './PlanManagementGrid.module.scss';

interface Props {
  gridRef: MutableRefObject<FlexGrid | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  rows: EngineRow[];
  staticColumns: RawFlexGridColumnConfig[];
  /** 행 키(engineRowKey) → 칠해진 진행 칸 수(0~4). 폴링마다 페이지가 갱신(design 03 §3 R20~R22) */
  progress: ReadonlyMap<string, number>;
}

// Engine Run 그리드 — 전 컬럼 읽기전용(R13, admin 메타 전건 INPUT_TP_CD='S').
//   STEP_PROCESS1~4 는 값이 아니라 배경색으로만 쓰는 진행바 캔버스 셀(AS-IS SetBGColor L1622-1646).
export const EngineRunGrid = ({ gridRef, gridFilterRef, rows, staticColumns, progress }: Props) => {
  const progressRef = useRef(progress);
  progressRef.current = progress;

  const processIndex = useMemo(() => {
    const map = new Map<string, number>();
    STEP_PROCESS_BINDINGS.forEach((binding, index) => map.set(binding, index));
    return map;
  }, []);

  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    const handleFormatItem = (sender: FlexGrid, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      const step = processIndex.get(binding);
      if (step === undefined) return;
      const row = sender.rows[e.row]?.dataItem as EngineRow | undefined;
      if (!row) return;
      const filled = progressRef.current.get(engineRowKey(row)) ?? 0;
      e.cell.classList.toggle(styles.processFilled, step < filled);
    };
    grid.formatItem.addHandler(handleFormatItem);
    return () => {
      try {
        grid.formatItem?.removeHandler(handleFormatItem);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns]);

  // 폴링마다 진행색 재도색 — 데이터 참조가 안 바뀌어도 progress 가 바뀌면 formatItem 을 다시 태운다.
  //   refresh(false)=재도색만(레이아웃 재계산 없음 — DataGrid wrapper selectionChanged 와 동일 규약)
  useEffect(() => {
    gridRef.current?.refresh(false);
  }, [gridRef, progress]);

  const itemsSource = useMemo(() => rows, [rows]);

  return (
    <DataGrid<EngineRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={itemsSource}
      staticColumns={staticColumns}
    />
  );
};
