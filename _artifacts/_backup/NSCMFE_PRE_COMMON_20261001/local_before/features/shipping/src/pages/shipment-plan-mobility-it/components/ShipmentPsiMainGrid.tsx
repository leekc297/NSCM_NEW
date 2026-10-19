import { AllowMerging, CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, type MutableRefObject } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { BUCKET_TYPE, MENU_ID } from '../shipment-plan-mobility-it.constants';
import type { CalendarRow, MainRow } from '../shipment-plan-mobility-it.types';
import { useShipmentPlanMobilityItStore } from '../useShipmentPlanMobilityItStore';
import { isMainCellEditable } from '../utils/shipment-plan-mobility-it.editLock';

interface Props {
  rows: MainRow[];
  calendar: CalendarRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns?: RawFlexGridColumnConfig[];
  bucketType: BUCKET_TYPE;
  chkSum: boolean;
  // 편집 가능 = canEdit(hasButton('EDIT')) — AS-IS EditButton 토글 미이식(convert-core §2.4).
  editable: boolean;
  curPlanDate: string;
  // 기간셀 더블클릭 드릴다운 (design 03 §3.F) — 페이지가 detail sheet 전환 + 재조회
  onDrilldown: (row: MainRow) => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 세로 merge 대상 (design 03 §3.D — TYPE·PSI_NAME 만 MergePolicy.Always)
const MERGE_COLUMNS = new Set(['TYPE', 'PSI_NAME']);

type DynKind = 'D' | 'W' | 'M' | 'B';
const kindOf = (binding: string): DynKind | undefined =>
  binding.startsWith('D_')
    ? 'D'
    : binding.startsWith('W_')
      ? 'W'
      : binding.startsWith('M_')
        ? 'M'
        : binding.startsWith('B_')
          ? 'B'
          : undefined;

// Bucket/chkSum 표시규칙 (design 03 §2 — D_/W_/M_ 토글, B_ 텍스트는 항상 표시)
const isDynVisible = (kind: DynKind, bucket: BUCKET_TYPE, chkSum: boolean): boolean => {
  if (kind === 'B') return true;
  if (bucket === BUCKET_TYPE.DAILY) return kind === 'D' ? true : chkSum;
  if (bucket === BUCKET_TYPE.WEEKLY) return kind === 'D' ? false : kind === 'W' ? true : chkSum;
  return kind === 'M';
};

// master PSI 그리드 — base 프레임 17열(admin 메타) + D_/W_/M_/B_ 동적(서버 wide + calendar 3단 헤더).
//   편집 표면 = WH_IN 측정치 행의 D_ 기간셀만(design 03 §3.A). W_/M_ Sum·B_ 텍스트는 잠금.
export const ShipmentPsiMainGrid = ({
  rows,
  calendar,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  bucketType,
  chkSum,
  editable,
  curPlanDate,
  onDrilldown,
}: Props) => {
  const columns = adminColumns ?? [];

  const dynColMetas = useMemo(() => {
    const titleRows = calendar.filter(r => !!kindOf(str(r.COLUMN_NAME)));
    if (titleRows.length > 0) {
      return titleRows
        .map(r => ({
          binding: str(r.COLUMN_NAME),
          kind: kindOf(str(r.COLUMN_NAME)) as DynKind,
          large: str(r.LARGE_CLASS_LABEL_NAME),
          small: str(r.SMALL_CLASS_LABEL_NAME),
          leaf: str(r.COLUMN_LABEL_NAME),
          dayCode: str(r.DAY_CODE),
          sort: str(r.SORT_ORDER_NO),
        }))
        .sort((a, b) => a.sort.localeCompare(b.sort));
    }
    const set = new Set<string>();
    rows.forEach(r => {
      Object.keys(r).forEach(k => {
        if (kindOf(k)) set.add(k);
      });
    });
    return [...set].sort().map(b => ({
      binding: b,
      kind: kindOf(b) as DynKind,
      large: b.slice(2, 8),
      small: '',
      leaf: b.slice(8),
      dayCode: '',
      sort: b,
    }));
  }, [calendar, rows]);

  // 토(Blue)/일(Red) 헤더색 (design 03 §3.C)
  const dayColorRef = useRef<Map<string, string>>(new Map());
  dayColorRef.current = useMemo(() => {
    const m = new Map<string, string>();
    dynColMetas.forEach(meta => {
      if (meta.kind !== 'D') return;
      const code = meta.dayCode.toUpperCase();
      if (code.startsWith('SAT') || code === '7') m.set(meta.binding, 'blue');
      else if (code.startsWith('SUN') || code === '1') m.set(meta.binding, 'red');
    });
    return m;
  }, [dynColMetas]);

  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynColMetas.length === 0) return [];
    type LeafCol = FlexGridColumnConfig & { binding: string };
    const largeMap = new Map<string, { label: string; subs: Map<string, LeafCol[]>; order: number }>();
    const kindRank: Record<DynKind, number> = { M: 0, W: 1, D: 2, B: 3 };
    dynColMetas.forEach((m, idx) => {
      const ymKey = m.binding.slice(2, 8);
      let bucket = largeMap.get(ymKey);
      if (!bucket) {
        bucket = { label: m.large || ymKey, subs: new Map(), order: idx };
        largeMap.set(ymKey, bucket);
      }
      const subKey = m.kind === 'M' ? 'SUM' : (m.small || 'SUM').trim() || 'SUM';
      if (!bucket.subs.has(subKey)) bucket.subs.set(subKey, []);
      bucket.subs.get(subKey)?.push({
        binding: m.binding,
        header: m.kind === 'D' ? m.leaf || 'SUM' : m.kind === 'B' ? m.leaf : 'SUM',
        align: m.kind === 'B' ? 'left' : 'right',
        width: 80,
        allowMerging: false,
        allowSorting: false,
        visible: isDynVisible(m.kind, bucketType, chkSum),
        _inputEditType: CELL_INPUT_EDIT_TYPE.OPTIONAL,
        _display: true,
      });
    });
    const subOrder = (k: string): number => (k === 'SUM' ? Number.NEGATIVE_INFINITY : Number(k.replace(/\D/g, '') || 0));
    const leafKind = (b: string): DynKind => kindOf(b) ?? 'D';
    return [...largeMap.values()]
      .sort((a, b) => a.order - b.order)
      .map(bucket => ({
        header: bucket.label,
        align: 'center',
        allowSorting: false,
        allowMerging: false,
        columns: [...bucket.subs.entries()]
          .sort(([a], [b]) => subOrder(a) - subOrder(b))
          .map(([subLabel, leafCols]) => ({
            header: subLabel,
            align: 'center',
            allowSorting: false,
            allowMerging: false,
            columns: leafCols.sort(
              (a, b) =>
                kindRank[leafKind(a.binding)] - kindRank[leafKind(b.binding)] ||
                a.binding.localeCompare(b.binding)
            ),
          })),
      }));
  }, [dynColMetas, bucketType, chkSum]);

  const setActiveGrid = useShipmentPlanMobilityItStore(s => s.setActiveGrid);
  const setActiveGridRef = useRef(setActiveGrid);
  setActiveGridRef.current = setActiveGrid;
  const editableRef = useRef(editable);
  editableRef.current = editable;
  const curPlanDateRef = useRef(curPlanDate);
  curPlanDateRef.current = curPlanDate;
  const onDrilldownRef = useRef(onDrilldown);
  onDrilldownRef.current = onDrilldown;

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 병합 — TYPE·PSI_NAME 세로 merge 만(design 03 §3.D). 동적/그 외 컬럼은 제외.
    const applyMerge = () => {
      g.columns.forEach(col => {
        col.allowMerging = MERGE_COLUMNS.has(col.binding ?? '');
      });
    };
    g.updatedLayout.addHandler(applyMerge);
    applyMerge();

    const beginningEditHandler = (
      sender: FlexGridType,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (!isMainCellEditable(row, binding, editableRef.current, curPlanDateRef.current)) {
        e.cancel = true;
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (e.panel === sender.columnHeaders) {
        const color = dayColorRef.current.get(binding);
        if (color) e.cell.style.color = color;
        return;
      }
      if (e.panel !== sender.cells) return;
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      const cellEditable = isMainCellEditable(row, binding, editableRef.current, curPlanDateRef.current);
      e.cell.style.backgroundColor = cellEditable ? '#FFFDE7' : '';
      // PROD_DATE/LOT 측정치 행 특수 셀표시 (design 03 §2·§3.C L2670/2674/2678 — gap-resolve I14).
      //   PROD_DATE = 날짜텍스트(center), LOT = 텍스트(center)이며 빈값/"0" 은 공백표시.
      if (kindOf(binding)) {
        const measure = str(row?.MEASURE);
        if (measure === 'LOT') {
          e.cell.style.textAlign = 'center';
          const txt = (e.cell.textContent ?? '').trim();
          if (txt === '' || txt === '0') e.cell.textContent = '';
        } else if (measure === 'PROD_DATE') {
          e.cell.style.textAlign = 'center';
        }
      }
    };
    g.formatItem.addHandler(formatItemHandler);

    // 기간셀 더블클릭 → detail 드릴다운 (design 03 §3.F). WH_IN 측정치 행 기간셀만.
    const dblClickHandler = (ev: MouseEvent) => {
      if (g.rows.length === 0) return;
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      if (!kindOf(binding)) return;
      const row = GridUtils.getRow(g, ht.row) as MainRow | undefined;
      if (!row) return;
      onDrilldownRef.current(row);
    };
    g.hostElement.addEventListener('dblclick', dblClickHandler);

    const clickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      setActiveGridRef.current('main');
    };
    g.hostElement.addEventListener('click', clickHandler);

    return () => {
      try {
        g.updatedLayout?.removeHandler(applyMerge);
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.formatItem?.removeHandler(formatItemHandler);
        g.hostElement?.removeEventListener('dblclick', dblClickHandler);
        g.hostElement?.removeEventListener('click', clickHandler);
      } catch {
        // unmount race
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns, dynamicColumns]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      dynamicColumns={dynamicColumns}
      comboParams={{ mnuId: `'${MENU_ID}'` }}
      allowMerging={AllowMerging.Cells}
    />
  );
};
