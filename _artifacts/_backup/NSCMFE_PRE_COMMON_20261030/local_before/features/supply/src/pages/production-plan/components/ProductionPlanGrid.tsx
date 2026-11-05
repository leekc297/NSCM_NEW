import {
  AllowMerging,
  type CellRange,
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
  type GridPanel,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useCallback, useEffect, useMemo, useRef, useState } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import {
  CustomMergeManager,
  type EditTracker,
  ensureTopLeftMergeManager,
  paintNegativeText,
} from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  CELL_COLOR,
  LINE_TOTAL_LOAD_MEASURE,
  LINE_TOTAL_WARN_THRESHOLD,
  RATIO_DECIMALS,
  RATIO_MEASURES,
} from '../production-plan.constants';
import type { FixedColumnMeta } from '../production-plan.constants';
import type { BUCKET_TYPE } from '../production-plan.constants';
import { buildFixedColumns, buildPivotColumns } from '../utils/productionPlanColumns';
import {
  dailyKeysOfMonth,
  dailyKeysOfWeek,
  distributeWeeklyToDaily,
  isoWeek,
  sumValues,
  toNum,
} from '../utils/productionPlanDerive';
import {
  type DrilldownState,
  EMPTY_DRILLDOWN,
  toggleDrilldown,
} from '../utils/productionPlanDrilldown';
import {
  type EditContext,
  type EditInfoEntry,
  isPastPivot,
  isPivotCellEditable,
  pivotKind,
  thisWeekMonday,
} from '../utils/productionPlanEditLock';

interface Props {
  rows: Record<string, unknown>[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  bucket: BUCKET_TYPE;
  chkSum: boolean;
  chkAll: boolean; // 헤더 더블클릭 드릴다운 게이트(design 03 §2.3/§3 R19) — chkAll 이면 동일단위 토글 허용.
  fallbackColumns: FixedColumnMeta[];
  division: string;
  adminColumns?: RawFlexGridColumnConfig[];
  // 편집 가능 그리드(LINE)만 true — MODEL(master) 그리드는 전건 읽기전용.
  editable: boolean;
  editContext: EditContext;
  editInfo: EditInfoEntry | null;
  // master(MODEL) 데이터 셀 더블클릭 → line drill (design 03 §4.2). 미지정이면 drill 없음.
  onRowDoubleClick?: (row: Record<string, unknown>) => void;
  onFocus?: () => void;
}

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const pivotTag = (binding: string): string => binding.slice(2).replace(/[^0-9]/g, '');

const HEADER_TOTAL_HEIGHT = 48;

// leaf(최하단) pivot 헤더는 가로 병합하지 않는다 — leaf 가 전부 'SUM' 이라 값 기준 병합이 주/월 경계를 넘는다.
class ProductionPlanMergeManager extends CustomMergeManager {
  getMergedRange(panel: GridPanel, currentRow: number, currentCol: number): CellRange | null {
    if (
      panel.cellType === CellType.ColumnHeader &&
      currentRow === panel.rows.length - 1 &&
      pivotKind(panel.columns[currentCol]?.binding ?? '') !== null
    ) {
      return null;
    }
    return super.getMergedRange(panel, currentRow, currentCol);
  }
}

// dailyKeysOfWeek/dailyKeysOfMonth 는 조회 직후 SUM 계산과 공용이라 productionPlanDerive 로 이동.

const isRatioMeasure = (measure: string): boolean =>
  (RATIO_MEASURES as readonly string[]).includes(measure);

// AS-IS GSCM.SCP.Analysis.UIL SCP0011 spdMain/spdLine — 19 고정 + D_/W_/M_ 동적 pivot(3단 헤더).
//   MODEL(master, editable=false 읽기전용) / LINE(detail, editable=true, PROD_PLAN_AMEND 셀 편집).
//   편집셀 판정은 productionPlanEditLock(measure+bucket kind+과거+서버 is_editable). design 03.
export const ProductionPlanGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  bucket,
  chkSum,
  chkAll,
  fallbackColumns,
  division,
  adminColumns,
  editable,
  editContext,
  editInfo,
  onRowDoubleClick,
  onFocus,
}: Props) => {
  const cutoff = useMemo(() => thisWeekMonday(), []);

  const fixedColumns = useMemo(
    () => buildFixedColumns(adminColumns, fallbackColumns, division),
    [adminColumns, fallbackColumns, division]
  );
  const [drilldown, setDrilldown] = useState<DrilldownState>(EMPTY_DRILLDOWN);
  useEffect(() => {
    setDrilldown(EMPTY_DRILLDOWN);
  }, [rows, bucket, chkSum]);

  const allPivotBindings = useMemo(() => {
    const set = new Set<string>();
    for (const r of rows) {
      for (const k of Object.keys(r)) {
        const pk = pivotKind(k);
        if (pk !== null && pk !== 'B') set.add(k);
      }
    }
    return [...set];
  }, [rows]);

  const pivotColumns = useMemo(
    () => buildPivotColumns(rows, bucket, chkSum, drilldown),
    [rows, bucket, chkSum, drilldown]
  );

  const handleGridInitialized = useCallback((grid: FlexGridType) => {
    // eslint-disable-next-line @typescript-eslint/no-unsafe-argument
    grid.mergeManager = new ProductionPlanMergeManager(grid);
    ensureTopLeftMergeManager(grid);
    const applyHeaderHeight = () => {
      const hdrRows = grid.columnHeaders?.rows;
      if (!hdrRows || hdrRows.length === 0) return;
      const targetHeight = Math.round(HEADER_TOTAL_HEIGHT / hdrRows.length);
      let changed = false;
      for (let i = 0; i < hdrRows.length; i += 1) {
        if (Math.round(hdrRows[i].height ?? hdrRows.defaultSize) !== targetHeight) {
          hdrRows[i].height = targetHeight;
          changed = true;
        }
      }
      if (Math.round(hdrRows.defaultSize) !== targetHeight) {
        hdrRows.defaultSize = targetHeight;
        changed = true;
      }
      if (changed) grid.invalidate(true);
    };
    applyHeaderHeight();
    grid.updatedLayout.addHandler(applyHeaderHeight);
  }, []);

  const bucketRef = useRef(bucket);
  bucketRef.current = bucket;
  const ctxRef = useRef(editContext);
  ctxRef.current = editContext;
  const editInfoRef = useRef(editInfo);
  editInfoRef.current = editInfo;
  const editableRef = useRef(editable);
  editableRef.current = editable;
  const bucketStateRef = useRef(bucket);
  bucketStateRef.current = bucket;
  const chkSumRef = useRef(chkSum);
  chkSumRef.current = chkSum;
  const chkAllRef = useRef(chkAll);
  chkAllRef.current = chkAll;
  const allBindingsRef = useRef(allPivotBindings);
  allBindingsRef.current = allPivotBindings;
  const onRowDblRef = useRef(onRowDoubleClick);
  onRowDblRef.current = onRowDoubleClick;

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 조회직후 전 컬럼 읽기전용 + 편집가능 pivot 셀만 해제 (design 03 §3 R9/R10). MODEL 그리드는 editable=false.
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      if (!editableRef.current) {
        e.cancel = true;
        return;
      }
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) {
        e.cancel = true;
        return;
      }
      e.cancel = !isPivotCellEditable(
        binding,
        row,
        bucketRef.current,
        ctxRef.current,
        cutoff,
        editInfoRef.current
      );
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    g.pastingCell.addHandler(beginningEditHandler);

    // 음수 입력 차단 — AS-IS 수치셀 범위 0~99,999,999(design 03 R5). 음수면 입력을 취소해 이전 값 유지.
    const negativeEditHandler = (sender: FlexGridType, e: { cancel: boolean; col: number }) => {
      if (pivotKind(sender.columns[e.col]?.binding ?? '') === null) return;
      const entered = toNum((sender.activeEditor as HTMLInputElement | null)?.value);
      if (entered !== null && entered < 0) e.cancel = true;
    };
    const negativePasteHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; col: number; data?: unknown }
    ) => {
      if (pivotKind(sender.columns[e.col]?.binding ?? '') === null) return;
      const pasted = toNum(e.data);
      if (pasted !== null && pasted < 0) e.cancel = true;
    };
    g.cellEditEnding.addHandler(negativeEditHandler);
    g.pastingCell.addHandler(negativePasteHandler);

    // pivot Auto-Sync (design 03 §2.4) — W_ 편집 시 하위 D_ 균등분배(+음수 원복), D_ 편집 시 상위 W_·M_ 재집계.
    //   비율 measure(FORMATION_YIELD/LINE_TOTAL_LOAD)는 평균이라 재분배 제외(단순 표시).
    const cellEditEndedHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      const kind = pivotKind(binding);
      if (kind === null || kind === 'B') return;
      if (isRatioMeasure(s(row.MEASURE))) return;

      const tracker = editTrackerRef.current;
      const setCell = (key: string, value: number) => {
        const prev = row[key];
        tracker?.storeChange(row as never, key, prev as never, value as never);
        row[key] = value;
      };
      const rowKeys = Object.keys(row);

      if (kind === 'W') {
        const dayKeys = dailyKeysOfWeek(rowKeys, binding);
        const weekVal = toNum(row[binding]) ?? 0;
        if (weekVal < 0) {
          setCell(binding, sumValues(dayKeys.map(k => row[k])));
        } else if (dayKeys.length > 0) {
          const dist = distributeWeeklyToDaily(weekVal, dayKeys.length);
          dayKeys.forEach((k, i) => setCell(k, dist[i]));
        }
      } else if (kind === 'D') {
        const dTag = pivotTag(binding);
        const ym = dTag.slice(0, 6);
        const weekNum = isoWeek(dTag);
        const weekKey = rowKeys.find(
          k =>
            pivotKind(k) === 'W' &&
            pivotTag(k).slice(0, 6) === ym &&
            (Number(pivotTag(k).slice(6)) || Number(pivotTag(k).slice(4, 6))) === weekNum
        );
        if (weekKey) setCell(weekKey, sumValues(dailyKeysOfWeek(rowKeys, weekKey).map(k => row[k])));
        const monthKey = rowKeys.find(k => pivotKind(k) === 'M' && pivotTag(k).slice(0, 6) === ym);
        if (monthKey) setCell(monthKey, sumValues(dailyKeysOfMonth(rowKeys, ym).map(k => row[k])));
      }
      sender.invalidate();
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    g.pastedCell.addHandler(cellEditEndedHandler);

    // 헤더 토(파랑)/일(빨강) 색 + 과거 회색 + 비율 measure 소수2 + LINE_TOTAL_LOAD<100 적색 (design 03 §2.2/§3 R13/R16/R17).
    const formatHandler = (_sender: FlexGridType, ev: FormatItemEventArgs) => {
      const binding = ev.panel.columns[ev.col]?.binding ?? '';
      if (ev.panel.cellType === CellType.ColumnHeader) {
        if (pivotKind(binding) !== 'D') return;
        const d = pivotTag(binding);
        if (d.length < 8) return;
        const date = new Date(Date.UTC(+d.slice(0, 4), +d.slice(4, 6) - 1, +d.slice(6, 8)));
        const dow = date.getUTCDay();
        if (dow === 6) ev.cell.style.color = '#1976d2'; // 토 Blue
        else if (dow === 0) ev.cell.style.color = '#d32f2f'; // 일 Red
        return;
      }
      if (ev.panel.cellType === CellType.Cell) {
        if (pivotKind(binding) === null) return;
        const dataItem = ev.panel.rows[ev.row]?.dataItem as Record<string, unknown> | undefined;
        if (!dataItem) return;
        if (isPastPivot(binding, cutoff)) ev.cell.style.backgroundColor = CELL_COLOR.PAST_GRAY;
        // 편집가능 셀은 노란 배경으로 식별(edit-gate 와 동일 판정 — PROD_PLAN_AMEND·Daily D_·편집시작일 이후).
        else if (
          editableRef.current &&
          isPivotCellEditable(binding, dataItem, bucketRef.current, ctxRef.current, cutoff, editInfoRef.current)
        )
          ev.cell.style.backgroundColor = CELL_COLOR.EDITABLE_YELLOW;
        // 음수 = 빨간 글자(공용 paintNegativeText). 아래 LINE_TOTAL_LOAD<100 강조보다 먼저 호출한다.
        paintNegativeText(ev.cell, toNum(dataItem[binding]) ?? 0);
        const measure = s(dataItem.MEASURE);
        if (isRatioMeasure(measure)) {
          const raw = toNum(dataItem[binding]);
          if (raw !== null) {
            ev.cell.textContent = raw.toFixed(RATIO_DECIMALS);
            if (measure === LINE_TOTAL_LOAD_MEASURE && raw < LINE_TOTAL_WARN_THRESHOLD) {
              ev.cell.style.color = CELL_COLOR.UNDER_100;
              ev.cell.style.fontWeight = 'bold';
            }
          }
        }
      }
    };
    g.formatItem.addHandler(formatHandler);

    // 더블클릭 동작 — leaf 헤더면 드릴다운(월→주→일 전개), 데이터 셀이면 master→line drill(design 03 §4.2 / §2.3).
    const runDblAction = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType === CellType.ColumnHeader) {
        const hdrRows = g.columnHeaders?.rows;
        if (!hdrRows || ht.row !== hdrRows.length - 1) return;
        const binding = g.columns[ht.col]?.binding ?? '';
        setDrilldown(prev =>
          toggleDrilldown(
            prev,
            binding,
            allBindingsRef.current,
            bucketStateRef.current,
            chkSumRef.current,
            chkAllRef.current
          )
        );
        return;
      }
      if (ht.cellType === CellType.Cell && onRowDblRef.current && ht.row >= 0) {
        const row = g.rows[ht.row]?.dataItem as Record<string, unknown> | undefined;
        if (row) onRowDblRef.current(row);
      }
    };
    // 네이티브 dblclick 대신 click 타이밍으로 더블클릭을 판정한다. 고정 식별 컬럼은 세로 병합
    //   (SmartColMerge) 셀이라, 첫 클릭의 선택 재렌더로 두 클릭이 서로 다른 DOM 노드에 떨어져
    //   브라우저가 dblclick 을 합성하지 않는다(병합 안 된 Measure/피벗 셀에서만 dblclick 발생).
    //   click 은 모든 셀에서 정상 발화하므로, 같은 셀(row,col)에서 짧은 간격의 두 클릭을 더블클릭으로
    //   간주해 모든 컬럼에서 동일하게 동작시킨다(AS-IS SpdMain_CellDoubleClick 은 컬럼 무관 발화).
    const DBLCLICK_MS = 500;
    let lastClickAt = 0;
    let lastClickRow = -1;
    let lastClickCol = -1;
    const clickDblHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      const isDouble =
        ev.timeStamp - lastClickAt < DBLCLICK_MS &&
        ht.row === lastClickRow &&
        ht.col === lastClickCol;
      lastClickAt = ev.timeStamp;
      lastClickRow = ht.row;
      lastClickCol = ht.col;
      if (!isDouble) return;
      lastClickAt = 0; // 트리플클릭 재발화 방지
      runDblAction(ev);
    };
    g.hostElement?.addEventListener('click', clickDblHandler);

    // 고정 식별 컬럼 셀 병합 — SmartColMerge (design 03 §3 R1). pivot 컬럼 제외.
    for (let i = 0; i < g.columns.length; i++) {
      const b = g.columns[i].binding ?? '';
      g.columns[i].allowMerging = pivotKind(b) === null;
    }
    g.invalidate(true);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(beginningEditHandler);
        g.cellEditEnding?.removeHandler(negativeEditHandler);
        g.pastingCell?.removeHandler(negativePasteHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(cellEditEndedHandler);
        g.formatItem?.removeHandler(formatHandler);
        g.hostElement?.removeEventListener('click', clickDblHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [fixedColumns, pivotColumns, cutoff]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={fixedColumns}
      dynamicColumns={pivotColumns}
      allowMerging={AllowMerging.All}
      initialized={handleGridInitialized}
      gotFocus={onFocus}
    />
  );
};
