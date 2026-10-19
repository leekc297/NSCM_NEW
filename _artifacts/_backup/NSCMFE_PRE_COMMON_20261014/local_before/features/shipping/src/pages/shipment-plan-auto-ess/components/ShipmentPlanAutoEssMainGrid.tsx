import { AllowMerging, CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, type MutableRefObject } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { BUCKET_TYPE, MENU_ID } from '../shipment-plan-auto-ess.constants';
import type { CalendarRow, MainRow } from '../shipment-plan-auto-ess.types';
import { useShipmentPlanAutoEssStore, type MeasureMeta } from '../useShipmentPlanAutoEssStore';
import { isMainCellEditable } from '../utils/shipment-plan-auto-ess.editLock';

interface Props {
  rows: MainRow[];
  calendar: CalendarRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns?: RawFlexGridColumnConfig[];
  // admin SCM_MST_SHEET_MEASURE — measure 세로축 표시/개인화 원천(CLAUDE.md §2 체크3).
  staticMeasures: MeasureMeta[];
  bucketType: BUCKET_TYPE;
  chkSum: boolean;
  // Main 편집 가능 = canEdit(hasButton('EDIT'))·최신Plan(realFlag). 셀 단위 범위는 isMainCellEditable.
  //   AS-IS EditButton 토글 미이식(convert-core §2.4) — 편집 기본 ON, 권한 마운트 1회 판정.
  editable: boolean;
  curPlanDate: string;
  // Main 셀/BOH_QTY 더블클릭 드릴다운 (design 03 §3.7) — 페이지가 sheet 전환 + Detail 재조회
  onDrilldown: (row: MainRow, binding: string) => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

type DynKind = 'D' | 'W' | 'M';
const kindOf = (binding: string): DynKind | undefined =>
  binding.startsWith('D_')
    ? 'D'
    : binding.startsWith('W_')
      ? 'W'
      : binding.startsWith('M_')
        ? 'M'
        : undefined;

// Bucket/chkSum 표시규칙 (design 03 §2.2 표 그대로)
const isDynVisible = (kind: DynKind, bucket: BUCKET_TYPE, chkSum: boolean): boolean => {
  if (bucket === BUCKET_TYPE.DAILY) return kind === 'D' ? true : chkSum;
  if (bucket === BUCKET_TYPE.WEEKLY) return kind === 'D' ? false : kind === 'W' ? true : chkSum;
  return kind === 'M'; // Monthly — M_ 항상, D_/W_ 숨김(chkSum 무관)
};

// Main(PSI) 그리드 — base 13컬럼(admin 메타) + D_/W_/M_ 동적(서버 wide pivot + calendar 3단 헤더).
//   편집 표면은 동적 D_ 셀만(MEASURE=='SHIP_PLAN' 행 + curPlanDate~CONFIRM_DAY 창 — design 03 §1.2/§2.3).
//   W_/M_(Sum) 컬럼은 항상 잠금. 재계산은 Simulation 버튼에서만(편집 즉시 재계산 없음 — 03 §2.3).
//   병합 = base 전 컬럼(FPMerge/SmartColMerge) + 동적 D_/W_/M_ 만 병합 제외(design 03 §3.5).
export const ShipmentPlanAutoEssMainGrid = ({
  rows,
  calendar,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  staticMeasures,
  bucketType,
  chkSum,
  editable,
  curPlanDate,
  onDrilldown,
}: Props) => {
  const columns = adminColumns ?? [];

  // measure 세로축 표시 게이트 (design 03 §1.2 — admin SCM_MST_SHEET_MEASURE display 플래그).
  //   서버 순서(item 그룹 유지)는 보존하고 display=false measure 행만 숨긴다 — 전역 재정렬은 item 그룹을
  //   흩뜨리므로 하지 않는다. 메타가 비었거나 measure 가 메타에 없으면 노출(회귀 0 fallback).
  const hiddenMeasures = useMemo(() => {
    const s = new Set<string>();
    staticMeasures.forEach(m => {
      if (m.display === false) s.add(m.colNm);
    });
    return s;
  }, [staticMeasures]);
  const visibleRows = useMemo(
    () => (hiddenMeasures.size === 0 ? rows : rows.filter(r => !hiddenMeasures.has(str(r.MEASURE)))),
    [rows, hiddenMeasures]
  );

  // 동적 컬럼 메타 — calendar(o_rc1) 우선, 0건이면 데이터 행 키 union fallback
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

  // 토(Blue)/일(Red) 헤더색 대상 — DAY_CODE 실측값 기준 (design 03 §2.1)
  const dayColorRef = useRef<Map<string, string>>(new Map());
  dayColorRef.current = useMemo(() => {
    const m = new Map<string, string>();
    dynColMetas.forEach(meta => {
      const code = meta.dayCode.toUpperCase();
      if (meta.kind !== 'D') return;
      if (code.startsWith('SAT') || code === '7') m.set(meta.binding, 'blue');
      else if (code.startsWith('SUN') || code === '1') m.set(meta.binding, 'red');
    });
    return m;
  }, [dynColMetas]);

  // 3단 nested 동적 컬럼 (월 > 주/SUM > 일)
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynColMetas.length === 0) return [];
    type LeafCol = FlexGridColumnConfig & { binding: string };
    const largeMap = new Map<
      string,
      { label: string; subs: Map<string, LeafCol[]>; order: number }
    >();
    const kindRank: Record<DynKind, number> = { M: 0, W: 1, D: 2 };
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
        header: m.kind === 'D' ? m.leaf || 'SUM' : 'SUM',
        align: 'right',
        width: 80,
        allowMerging: false,
        allowSorting: false,
        visible: isDynVisible(m.kind, bucketType, chkSum),
        _inputEditType: CELL_INPUT_EDIT_TYPE.OPTIONAL,
        _display: true,
      });
    });
    const subOrder = (k: string): number => {
      if (k === 'SUM') return Number.NEGATIVE_INFINITY;
      const n = Number(k.replace(/\D/g, '') || 0);
      return k.trim().startsWith('+') ? n - 1000 : n;
    };
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

  const setActiveGrid = useShipmentPlanAutoEssStore(s => s.setActiveGrid);
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

    // 병합 — base 전 컬럼 허용(FPMerge 등가) / 동적 D_/W_/M_ 만 제외(design 03 §3.5).
    const applyMerge = () => {
      g.columns.forEach(col => {
        const binding = col.binding ?? '';
        col.allowMerging = !kindOf(binding);
      });
    };
    g.updatedLayout.addHandler(applyMerge);
    applyMerge();

    // 편집 잠금 — beginningEdit(e.cancel) + formatItem(편집가능 노랑 + 헤더 토/일 색)
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
      const cellEditable = isMainCellEditable(
        row,
        binding,
        editableRef.current,
        curPlanDateRef.current
      );
      e.cell.style.backgroundColor = cellEditable ? '#FFFDE7' : '';
    };
    g.formatItem.addHandler(formatItemHandler);

    // 붙여넣기 게이트 — OPTIONAL 인 동적 셀 전체가 열리므로 편집창 판정으로 verdict 를 덮어쓴다.
    const pastingCellHandler = (
      sender: FlexGridType,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!kindOf(binding)) return;
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      e.cancel = !isMainCellEditable(row, binding, editableRef.current, curPlanDateRef.current);
    };
    g.pastingCell.addHandler(pastingCellHandler);

    // Delete 키 (AS-IS spdMain_KeyUp 등가 — 편집가능 D_ 셀 "0" 세팅 + EditTracker 기록).
    //   재계산은 Simulation 버튼에서만(design 03 §2.3) — 여기서는 값 세팅·마킹만.
    const deleteKeyHandler = (ev: KeyboardEvent) => {
      if (ev.key !== 'Delete' || ev.altKey || ev.ctrlKey || ev.metaKey || ev.shiftKey) return;
      if (g.activeEditor) return;
      const sel = g.selection;
      if (!sel || sel.row < 0 || sel.col < 0) return;
      ev.preventDefault();
      ev.stopPropagation();
      const tracker = editTrackerRef.current;
      let touched = 0;
      for (let r = sel.topRow; r <= sel.bottomRow; r += 1) {
        const row = GridUtils.getRow(g, r) as Record<string, unknown> | undefined;
        if (!row) continue;
        for (let c = sel.leftCol; c <= sel.rightCol; c += 1) {
          const binding = g.columns[c]?.binding ?? '';
          if (!binding.startsWith('D_')) continue;
          if (!isMainCellEditable(row, binding, editableRef.current, curPlanDateRef.current))
            continue;
          const original = row[binding] as WijmoPrimitive;
          if (Number(original ?? 0) === 0) continue;
          row[binding] = 0;
          tracker?.storeChange(row as WijmoRowItem, binding, original, 0);
          touched += 1;
        }
      }
      if (touched > 0) g.collectionView?.refresh();
    };
    g.hostElement.addEventListener('keydown', deleteKeyHandler, true);

    // 더블클릭 — BOH_QTY(BOH_TYPE 분기) / 데이터 셀(MEASURE 분기) 드릴다운 (design 03 §3.7)
    const dblClickHandler = (ev: MouseEvent) => {
      if (g.rows.length === 0) return;
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      if (binding !== 'BOH_QTY' && !kindOf(binding)) return;
      const row = GridUtils.getRow(g, ht.row) as MainRow | undefined;
      if (!row) return;
      onDrilldownRef.current(row, binding);
    };
    g.hostElement.addEventListener('dblclick', dblClickHandler);

    // 활성 그리드 전환 (AS-IS 프레임워크 클릭 전환 등가) — Main 클릭 시 'main' 복귀
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
        g.pastingCell?.removeHandler(pastingCellHandler);
        g.hostElement?.removeEventListener('keydown', deleteKeyHandler, true);
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
      itemsSource={visibleRows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      dynamicColumns={dynamicColumns}
      comboParams={{ mnuId: `'${MENU_ID}'` }}
      allowMerging={AllowMerging.Cells}
    />
  );
};
