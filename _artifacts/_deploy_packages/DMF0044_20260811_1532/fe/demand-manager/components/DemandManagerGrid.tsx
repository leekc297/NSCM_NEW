import type { FlexGrid as FlexGridType, FormatItemEventArgs } from '@mescius/wijmo.grid';
import { AllowMerging, DataMap } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { FlexGridFilter as FlexGridFilterCtor } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, type Ref, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  EDITABLE_BINDINGS,
  MONTH_GROUP_HEADER,
  PAIR_FOLLOW_BINDINGS,
} from '../demand-manager.constants';
import type { DemandManagerRow, LookupProjectRow, MonthColumnMeta } from '../demand-manager.types';
import styles from '../DemandManager.module.scss';
import { DemandManagerMergeManager } from '../utils/demand-manager.merge';
import { isOutOfOrderRange } from '../utils/demand-manager.months';

// ⭐ DMF0068 Grid — 왼쪽 고정 영역(컬럼 메타) + 오른쪽 월 영역(조회 기간에서 산출).
//   한 건 = Measure 2행 1세트. 세트의 첫 행에서만 Project·수주기간·수량을 고칠 수 있고,
//   둘째 행의 Project·수주기간은 첫 행 값을 따라가며 잠긴다(AS-IS Formula 연결 대응).
//   TO-BE 표준에 따라 조회 직후부터 편집 가능하다(AS-IS 의 편집 모드 토글은 이관하지 않는다).

interface Props {
  rows: DemandManagerRow[];
  gridRef: Ref<FlexGridType<DemandManagerRow>>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef?: MutableRefObject<EditTracker | undefined>;
  staticColumns?: RawFlexGridColumnConfig[];
  monthColumns: MonthColumnMeta[];
  projectOptions?: LookupProjectRow[];
  /** 편집 계열 권한 (그룹 게이트 통과 여부) */
  canEdit: boolean;
}

const toNumber = (v: unknown): number => {
  if (v == null || v === '') return 0;
  if (typeof v === 'number') return Number.isFinite(v) ? v : 0;
  // 문자열 외(객체 등)는 0 — String(v) 직행은 '[object Object]'→NaN 경로라 금지 (no-base-to-string)
  const n = typeof v === 'string' ? Number(v.replace(/,/g, '')) : NaN;
  return Number.isFinite(n) ? n : 0;
};

/** 세트의 첫 행인지 — 바로 위 행과 그룹 키가 다르면 첫 행 */
const isSetHead = (rows: DemandManagerRow[], idx: number): boolean => {
  if (idx <= 0) return true;
  const key = (r: DemandManagerRow | undefined) =>
    String(r?.KEYVALUE2 ?? r?.INSERT_GROUP_ID ?? '');
  return key(rows[idx]) !== key(rows[idx - 1]);
};

export const DemandManagerGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  staticColumns,
  monthColumns,
  projectOptions,
  canEdit,
}: Props) => {
  // ⭐ 정적 컬럼 — admin 메타 100% 주도 (hook #113 — visible/display 두 값만, 하드코딩 fallback 금지)
  const visibleColumns = useMemo<RawFlexGridColumnConfig[]>(
    () => (staticColumns ?? []).filter(c => c.visible !== false && c.display !== false),
    [staticColumns]
  );
  // 월 컬럼은 동적으로 만들므로 메타의 M1..M143 은 정적 컬럼에서 제외한다
  const fixedColumns = useMemo<RawFlexGridColumnConfig[]>(
    () => visibleColumns.filter(c => !/^M\d+$/.test(c.colNm)),
    [visibleColumns]
  );
  const mainStaticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () => fixedColumns.map(c => ({ ...c, visible: true, display: true })),
    [fixedColumns]
  );
  const staticBindingSet = useMemo(
    () => new Set(fixedColumns.map(c => c.colNm)),
    [fixedColumns]
  );

  // Project 셀 콤보 — PKG_DMF0068.P_DMF0068_GET_LOOKUPPROJECT (CODE/NAME)
  const projectDataMap = useMemo<DataMap | null>(() => {
    const list = (projectOptions ?? []) as unknown as Record<string, unknown>[];
    return list.length > 0 ? new DataMap(list, 'CODE', 'NAME') : null;
  }, [projectOptions]);

  // ⭐ 월 컬럼 — 조회 기간에서 산출. AS-IS 와 동일하게 전체 월을 상위 헤더 하나로 묶고(2단),
  //   leaf 에 yyyy.MM 을 표시한다. 연도별로 쪼개지 않는다.
  const mainDynamicColumns = useMemo(() => {
    if (monthColumns.length === 0) return [];
    return [
      {
        header: MONTH_GROUP_HEADER,
        align: 'center',
        height: 24, // 2단 헤더 (#93 — 1단 48 / 2단 24)
        columns: monthColumns.map(m => ({
          binding: m.binding,
          header: m.label,
          align: 'right',
          width: 100,
          allowDragging: false,
          allowMerging: false,
          allowResizing: true,
          allowSorting: false,
          visible: true,
          height: 24,
          _display: true,
        })),
      },
    ];
  }, [monthColumns]) as never[];

  const monthByBinding = useMemo(() => {
    const m = new Map<string, MonthColumnMeta>();
    monthColumns.forEach(x => m.set(x.binding, x));
    return m;
  }, [monthColumns]);

  // 핸들러가 최신 상태를 보도록 ref 미러
  const ctxRef = useRef({ canEdit, rows, monthByBinding });
  ctxRef.current = { canEdit, rows, monthByBinding };

  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<DemandManagerRow> | null } | null)?.current;
    if (!g || !g.columnHeaders || !g.columnHeaders.rows) return;

    if (g.alternatingRowStep !== 1) g.alternatingRowStep = 1; // zebra (#95)
    for (let i = 0; i < g.columnFooters.rows.length; i++) g.columnFooters.rows[i].visible = false;
    g.mergeManager = new DemandManagerMergeManager();

    const toggleClass = (el: HTMLElement, cls: string, on: boolean) => {
      if (on) el.classList.add(cls);
      else el.classList.remove(cls);
    };

    /** 셀 편집 가능 여부 — TO-BE 는 조회 직후부터 편집 가능하다(별도 편집 모드 전환 없음).
     *  권한 + 세트 첫 행 + 편집 대상 컬럼 세 조건만 본다. */
    const editableAt = (binding: string, rowIndex: number): boolean => {
      const { canEdit: ce, rows: rs } = ctxRef.current;
      if (!ce) return false;
      if (!EDITABLE_BINDINGS.includes(binding as (typeof EDITABLE_BINDINGS)[number])) return false;
      // 짝 행에서는 Project·수주기간을 고칠 수 없다 (첫 행 값을 따라간다)
      if (
        !isSetHead(rs, rowIndex) &&
        PAIR_FOLLOW_BINDINGS.includes(binding as (typeof PAIR_FOLLOW_BINDINGS)[number])
      ) {
        return false;
      }
      const row = rs[rowIndex];
      // 서버가 내려준 편집 권한(EDIT_YN)이 N 이면 잠근다
      return String(row?.EDIT_YN ?? 'Y').toUpperCase() !== 'N';
    };

    const formatHandler = (_s: FlexGridType<DemandManagerRow>, e: FormatItemEventArgs) => {
      if (e.panel !== g.cells) return;
      const binding = g.columns[e.col]?.binding ?? '';
      const rowItem = g.rows[e.row]?.dataItem as DemandManagerRow | undefined;

      const meta = ctxRef.current.monthByBinding.get(binding);
      if (meta) {
        // 수주 기간을 벗어난 월은 0 으로 보여준다 (AS-IS 범위 밖 0 처리)
        const out = isOutOfOrderRange(meta.yyyymm, rowItem?.ORDERSTART, rowItem?.ORDEREND);
        const n = out ? 0 : toNumber(rowItem?.[binding]);
        e.cell.textContent = n === 0 ? '0' : n.toLocaleString();
        toggleClass(e.cell, 'wj-cell-non-editable', true);
        return;
      }
      if (staticBindingSet.has(binding)) {
        toggleClass(e.cell, 'wj-cell-editable', editableAt(binding, e.row));
        toggleClass(e.cell, 'wj-cell-non-editable', !editableAt(binding, e.row));
      }
    };
    g.formatItem.addHandler(formatHandler);

    const beginningEditHandler = (
      s: FlexGridType<DemandManagerRow>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = s.columns[e.col]?.binding ?? '';
      e.cancel = !editableAt(binding, e.row);
    };
    g.beginningEdit.addHandler(beginningEditHandler as never);

    // 세트 첫 행의 Project·수주기간을 고치면 짝 행에도 같은 값을 넣는다 (AS-IS Formula 연결)
    const cellEditEndedHandler = (
      s: FlexGridType<DemandManagerRow>,
      e: { row: number; col: number }
    ) => {
      const binding = s.columns[e.col]?.binding ?? '';
      if (!PAIR_FOLLOW_BINDINGS.includes(binding as (typeof PAIR_FOLLOW_BINDINGS)[number])) return;
      const head = s.rows[e.row]?.dataItem as DemandManagerRow | undefined;
      if (!head) return;
      const key = String(head.KEYVALUE2 ?? head.INSERT_GROUP_ID ?? '');
      if (!key) return;
      const value = head[binding];
      for (let i = 0; i < s.rows.length; i++) {
        if (i === e.row) continue;
        const item = s.rows[i]?.dataItem as DemandManagerRow | undefined;
        if (!item) continue;
        if (String(item.KEYVALUE2 ?? item.INSERT_GROUP_ID ?? '') === key) {
          (item as Record<string, unknown>)[binding] = value;
        }
      }
      s.invalidate(true);
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler as never);

    return () => {
      try {
        g.formatItem.removeHandler(formatHandler);
        g.beginningEdit.removeHandler(beginningEditHandler as never);
        g.cellEditEnded.removeHandler(cellEditEndedHandler as never);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, staticBindingSet]);

  // 헤더 높이 48px 고정 (#93) + Project 셀 콤보 배선
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<DemandManagerRow> | null } | null)?.current;
    if (!g) return;
    const applyLayout = () => {
      const projectCol = g.columns.getColumn('PROJECT_NAME');
      if (projectCol && projectDataMap && projectCol.dataMap !== projectDataMap) {
        projectCol.dataMap = projectDataMap;
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
    g.updatedLayout.addHandler(applyLayout);
    applyLayout();
    return () => {
      try {
        g.updatedLayout?.removeHandler(applyLayout);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, projectDataMap, monthColumns, fixedColumns]);

  // F4 Filter — 월 컬럼은 필터 대상에서 제외
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<DemandManagerRow> | null } | null)?.current;
    if (!g || !gridFilterRef) return;
    const onFilterChanging = (
      _s: FlexGridFilter,
      e: { cancel: boolean; getColumn: () => { binding?: string | null } }
    ) => {
      if (/^M\d+$/.test(e.getColumn()?.binding ?? '')) e.cancel = true;
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
  }, [gridRef, gridFilterRef, monthColumns]);

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
        allowSorting={false}
        allowMerging={AllowMerging.All}
      />
    </div>
  );
};
