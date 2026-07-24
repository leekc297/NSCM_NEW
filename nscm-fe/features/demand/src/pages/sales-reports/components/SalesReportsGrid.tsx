
import type { FlexGrid as FlexGridType, FormatItemEventArgs } from '@mescius/wijmo.grid';
import { AllowMerging, DataMap } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { FlexGridFilter as FlexGridFilterCtor } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, type Ref, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';

import type { SalesReportRow, SpreadTitleRow } from '../sales-reports.types';
import styles from '../SalesReports.module.scss';
import {
  dynKindOf,
  evalSalesReportCell,
  insertStaticEditable,
} from '../utils/sales-reports.editLock';
import {
  buildDataMap,
  filterComboRowsByRow,
  GRID_CASCADE_FILTERS,
  toCellStr,
} from '../utils/sales-reports.gridCombos';
import { SalesReportsMergeManager } from '../utils/sales-reports.merge';

// ⭐ DMF0044 SalesReportsGrid — business-plan Grid 축약 (M_ 단일축 · 2단 헤더[연 span+월 leaf] ·
//   배분/롤업 없음 · 2행 Measure 블록은 행 데이터 차원 — Grid 는 셀 편집만).
//   편집 게이트 = evalSalesReportCell 4변수 매트릭스 (EDIT_FLAG×Measure×Div×시점 + ALL 차단).
//   AS-IS spdMain_Changed L1295~1302: 수치셀 빈값 → '0' 강제 (cellEditEnded 파리티).
//   ITEM_ID 셀 더블클릭 → Item 팝업 (값 '기타매출' 제외 — 제약매트릭스 M-8 L93).

interface Props {
  rows: SalesReportRow[];
  gridRef: Ref<FlexGridType<SalesReportRow>>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef?: MutableRefObject<EditTracker | undefined>;
  onItemCellDblClick?: (row: SalesReportRow) => void;
  divisionId?: string;
  dataType?: string;
  thisMonth?: string; // yyyymm — 조회 시점 고정 (store)
  staticColumns?: RawFlexGridColumnConfig[];
  spreadTitle?: SpreadTitleRow[];
}

const toNumber = (v: unknown): number => {
  if (v == null || v === '') return 0;
  const n = typeof v === 'number' ? v : Number(toCellStr(v).replace(/,/g, ''));
  return Number.isFinite(n) ? n : 0;
};

export const SalesReportsGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  onItemCellDblClick,
  divisionId,
  dataType = 'ALL',
  thisMonth = '',
  staticColumns,
  spreadTitle,
}: Props) => {
  const division = divisionId ?? '';

  // ⭐ 정적 컬럼 — admin 메타 100% 주도 (hook #113 — visible/display 2 boolean 만, FALLBACK 금지)
  const visibleColumns = useMemo<RawFlexGridColumnConfig[]>(
    () => (staticColumns ?? []).filter(c => c.visible !== false && c.display !== false),
    [staticColumns]
  );
  const fixedBindings = useMemo(() => visibleColumns.map(c => c.colNm), [visibleColumns]);
  const staticBindingSet = useMemo(() => new Set(fixedBindings), [fixedBindings]);

  const mainStaticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () => visibleColumns.map(c => ({ ...c, visible: true, display: true })),
    [visibleColumns]
  );

  // ===== Grid 콤보 — UI Category 메타(cellCboDataTp) 기반 (DMF0044_MDF_DEPARTMENT 등 기등록) =====
  const comboColumns = useMemo(
    () =>
      visibleColumns.filter(
        c => (c.cellCtrlObjTpCd as unknown as string) === 'FPComboBox' && !!c.cellCboDataTp
      ),
    [visibleColumns]
  );
  const comboResults = useTabComboQueries({
    filters: comboColumns.map(c => c.cellCboDataTp as string),
  });
  const comboSig = comboColumns
    .map((c, i) => `${c.cellCboDataTp}#${comboResults[i]?.length ?? 'x'}`)
    .join(',');
  const dataMaps = useMemo<Record<string, DataMap | null>>(() => {
    const m: Record<string, DataMap | null> = {};
    comboColumns.forEach((c, i) => {
      const arr = comboResults[i] ?? [];
      m[c.colNm] = arr.length > 0 ? new DataMap(arr, 'CODE', 'NAME') : null;
    });
    return m;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [comboSig]);
  const comboRowsRef = useRef<Record<string, Record<string, unknown>[]>>({});
  const dataMapsRef = useRef<Record<string, DataMap | null>>({});
  useEffect(() => {
    const rowsByBinding: Record<string, Record<string, unknown>[]> = {};
    comboColumns.forEach((c, i) => {
      rowsByBinding[c.colNm] = (comboResults[i] ?? []) as unknown as Record<string, unknown>[];
    });
    comboRowsRef.current = rowsByBinding;
    dataMapsRef.current = dataMaps;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [comboSig, dataMaps]);

  // ===== 동적 컬럼 메타 — GET_SPREAD_TITLE 우선, 부재 시 row 키 union fallback (M_ 단일축) =====
  type DynColMeta = { binding: string; year: string; leaf: string; sort: number };
  const dynColMetas = useMemo<DynColMeta[]>(() => {
    const titleRows = (spreadTitle ?? []).filter(r => dynKindOf(String(r.COLUMN_NAME ?? '')));
    if (titleRows.length > 0) {
      return titleRows
        .map<DynColMeta>(r => ({
          binding: String(r.COLUMN_NAME),
          year: String(r.LARGE_CLASS_LABEL_NAME ?? String(r.COLUMN_NAME).slice(2, 6)),
          leaf: String(r.COLUMN_LABEL_NAME ?? String(r.COLUMN_NAME).slice(6, 8)),
          sort: Number(r.SORT_ORDER_NO ?? 0),
        }))
        .sort((a, b) => a.sort - b.sort || a.binding.localeCompare(b.binding));
    }
    if (!rows || rows.length === 0) return [];
    const set = new Set<string>();
    for (const r of rows) {
      for (const k of Object.keys(r)) if (dynKindOf(k)) set.add(k);
    }
    return [...set].sort().map<DynColMeta>(b => ({
      binding: b,
      year: b.slice(2, 6),
      leaf: b.slice(6, 8),
      sort: 0,
    }));
  }, [spreadTitle, rows]);
  const dynBindings = useMemo(() => dynColMetas.map(m => m.binding), [dynColMetas]);

  // editLock 파라미터 ref 미러 (핸들러 공유)
  const lockCtxRef = useRef({ division, dataType, thisMonth });
  lockCtxRef.current = { division, dataType, thisMonth };

  // ⭐ 동적 PIVOT 컬럼 — 2단 nested (연 span → 월 leaf). AS-IS CreateSheetHeaderColumnDtDiv 대응.
  const mainDynamicColumns = useMemo(() => {
    if (dynColMetas.length === 0) return [];
    const yearMap = new Map<string, { header: string; columns: Record<string, unknown>[] }>();
    dynColMetas.forEach(m => {
      const y = m.binding.slice(2, 6);
      if (!yearMap.has(y)) yearMap.set(y, { header: m.year || y, columns: [] });
      yearMap.get(y)!.columns.push({
        binding: m.binding,
        header: m.leaf || m.binding.slice(6, 8),
        align: 'right',
        width: 90,
        allowDragging: true,
        allowMerging: false,
        allowResizing: true,
        allowSorting: false,
        visible: true,
        height: 48, // 다단 헤더(#93) — 동적 컬럼 명시 의무
        _display: true,
      });
    });
    return [...yearMap.values()].map(yb => ({
      header: yb.header,
      align: 'center',
      height: 48,
      columns: yb.columns,
    }));
  }, [dynColMetas]) as never[];

  // ===== grid 핸들러 + mergeManager =====
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<SalesReportRow> | null } | null)?.current;
    if (!g || !g.columnHeaders || !g.columnHeaders.rows) return;

    if (g.alternatingRowStep !== 1) g.alternatingRowStep = 1; // zebra (#95)
    for (let i = 0; i < g.columnFooters.rows.length; i++) g.columnFooters.rows[i].visible = false;

    const evalDyn = (binding: string, row: SalesReportRow | undefined) =>
      evalSalesReportCell({
        binding,
        row,
        divisionId: lockCtxRef.current.division,
        dataType: lockCtxRef.current.dataType,
        thisMonth: lockCtxRef.current.thisMonth,
      });

    const toggleClass = (el: HTMLElement, cls: string, on: boolean) => {
      if (on) el.classList.add(cls);
      else el.classList.remove(cls);
    };

    const formatHandler = (_s: FlexGridType<SalesReportRow>, e: FormatItemEventArgs) => {
      if (e.panel !== g.cells) return;
      const col = g.columns[e.col];
      const binding = col?.binding ?? '';
      const rowItem = g.rows[e.row]?.dataItem as SalesReportRow | undefined;
      if (dynKindOf(binding)) {
        const st = evalDyn(binding, rowItem);
        toggleClass(e.cell, 'wj-cell-editable', st.editable);
        toggleClass(e.cell, 'wj-cell-non-editable', !st.editable && st.isPast);
        // 숫자 표시 — 0/빈 = 빈칸, 콤마 포맷
        const v = rowItem?.[binding];
        const n = toNumber(v);
        e.cell.textContent = v == null || v === '' || n === 0 ? '' : n.toLocaleString();
        return;
      }
      if (staticBindingSet.has(binding) && rowItem) {
        const editable = rowItem.CRUD_TYPE === 'I' && insertStaticEditable(binding);
        toggleClass(e.cell, 'wj-cell-editable', editable);
      }
    };
    g.formatItem.addHandler(formatHandler);

    // 편집 시작 — 게이트 + cascade 콤보 스왑 (hook #59 §5-G)
    const editingCellRef: { current: { binding: string } | null } = { current: null };
    const beginningEditHandler = (
      s: FlexGridType<SalesReportRow>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = s.columns[e.col]?.binding ?? '';
      const row = s.rows[e.row]?.dataItem as SalesReportRow | undefined;
      if (staticBindingSet.has(binding)) {
        const allowed = !!row && row.CRUD_TYPE === 'I' && insertStaticEditable(binding);
        if (!allowed) {
          e.cancel = true;
          return;
        }
        // cascade 스왑 — DEPT_ID 는 DEPARTMENT_ID 값으로 필터 (AS-IS ComboSelChange M-6)
        const cascade = GRID_CASCADE_FILTERS[binding];
        const src = comboRowsRef.current[binding];
        if (cascade && src && row) {
          const dm = buildDataMap(filterComboRowsByRow(src, row, cascade));
          if (dm) {
            s.columns[e.col].dataMap = dm;
            editingCellRef.current = { binding };
          }
        }
        return;
      }
      if (dynKindOf(binding)) {
        e.cancel = !evalDyn(binding, row).editable;
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    g.pastingCell.addHandler(beginningEditHandler as never);

    // 편집 종료 — 수치셀 빈값 → '0' (AS-IS L1295~1302) + cascade dataMap 원복
    const cellEditEndedHandler = (
      s: FlexGridType<SalesReportRow>,
      e: { row: number; col: number }
    ) => {
      const binding = s.columns[e.col]?.binding ?? '';
      const row = s.rows[e.row]?.dataItem as SalesReportRow | undefined;
      if (dynKindOf(binding) && row && (row[binding] == null || row[binding] === '')) {
        (row as Record<string, unknown>)[binding] = '0';
      }
      // cascade 원복
      if (editingCellRef.current?.binding === binding) {
        const orig = dataMapsRef.current[binding];
        if (orig !== undefined) s.columns[e.col].dataMap = orig;
        editingCellRef.current = null;
      }
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    g.pastedCell.addHandler(cellEditEndedHandler as never);

    // ITEM_ID 셀 더블클릭 — 값 '기타매출' 제외 (제약매트릭스 M-8 L93 — DM0002 Item 팝업)
    const dblclickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (!ht || ht.panel !== g.cells) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      const row = g.rows[ht.row]?.dataItem as SalesReportRow | undefined;
      if (!row || binding !== 'ITEM_ID') return;
      if (toCellStr(row.ITEM_ID).trim() === '기타매출') return;
      onItemCellDblClick?.(row);
    };
    g.hostElement.addEventListener('dblclick', dblclickHandler);

    const handleScrollInvalidate = () => g.invalidate();
    g.scrollPositionChanged.addHandler(handleScrollInvalidate);

    g.allowMerging = AllowMerging.All;
    for (let i = 0; i < g.columns.length; i++) g.columns[i].allowMerging = true;
    g.mergeManager = new SalesReportsMergeManager(fixedBindings);
    g.invalidate(true);

    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(beginningEditHandler as never);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(cellEditEndedHandler as never);
        g.hostElement?.removeEventListener('dblclick', dblclickHandler);
        g.scrollPositionChanged?.removeHandler(handleScrollInvalidate);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [visibleColumns, dynBindings, fixedBindings, onItemCellDblClick]);

  // ⭐ hook #93 — 2단 헤더 총 48px (1단 연 24 + 2단 월 24) + combo dataMap 재적용 + Filter sanitize
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<SalesReportRow> | null } | null)?.current;
    if (!g) return;
    const applyHeaderHeight = () => {
      const f = gridFilterRef?.current;
      if (f) {
        const cleaned = f.filterColumns.filter(b => !/^M_/.test(b));
        if (cleaned.length !== f.filterColumns.length) f.filterColumns = cleaned;
      }
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        const dm = dataMaps[col.binding ?? ''];
        if (dm && col.dataMap !== dm) col.dataMap = dm;
      }
      const headerRows = g.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      const per = Math.round(48 / headerRows.length);
      if (
        Math.round(headerRows.defaultSize) === per &&
        Math.round(headerRows[0]?.height ?? 0) === per
      ) {
        return;
      }
      headerRows.defaultSize = per;
      for (let i = 0; i < headerRows.length; i++) headerRows[i].height = per;
    };
    g.updatedLayout.addHandler(applyHeaderHeight);
    applyHeaderHeight();
    return () => {
      try {
        g.updatedLayout?.removeHandler(applyHeaderHeight);
      } catch {
        /* unmount race */
      }
    };
  }, [dynBindings, visibleColumns, dataMaps, gridRef, gridFilterRef]);

  // F4 Filter — 동적(M_) 컬럼 필터 cancel
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<SalesReportRow> | null } | null)?.current;
    if (!g || !gridFilterRef) return;
    const onFilterChanging = (
      _s: FlexGridFilter,
      e: { cancel: boolean; getColumn: () => { binding?: string | null } }
    ) => {
      if (/^M_/.test(e.getColumn()?.binding ?? '')) e.cancel = true;
    };
    const onFilterApplied = () => g.invalidate(true);
    let f = gridFilterRef.current;
    if (!f || f.grid !== g) {
      f = new FlexGridFilterCtor(g);
      f.filterColumns = [''];
      gridFilterRef.current = f;
    }
    f.filterChanging.addHandler(onFilterChanging as never);
    f.filterApplied.addHandler(onFilterApplied);
    return () => {
      try {
        f?.filterChanging.removeHandler(onFilterChanging as never);
        f?.filterApplied.removeHandler(onFilterApplied);
      } catch {
        /* unmount race */
      }
    };
  }, [dynBindings, visibleColumns, gridRef, gridFilterRef]);

  return (
    <div className={styles.gridContainer}>
      <DataGrid
        key={mainStaticColumns.map(c => c.colNm).join(',')}
        className={styles.grid}
        gridRef={gridRef as never}
        editTrackerRef={editTrackerRef as never}
        staticColumns={mainStaticColumns}
        dynamicColumns={mainDynamicColumns}
        itemsSource={rows as unknown as WijmoRowItem[]}
        autoGenerateColumns={false}
        allowSorting={true}
        allowMerging={AllowMerging.All}
      />
    </div>
  );
};
