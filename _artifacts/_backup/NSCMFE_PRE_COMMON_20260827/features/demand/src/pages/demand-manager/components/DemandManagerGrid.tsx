import type { FlexGrid as FlexGridType, FormatItemEventArgs } from '@mescius/wijmo.grid';
import { AllowMerging, DataMap } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { FlexGridFilter as FlexGridFilterCtor } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useCallback, useEffect, useMemo, useRef } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { type EditTracker, keepRowVisibleUnderFilter } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  EDITABLE_BINDINGS,
  INSERT_ONLY_BINDINGS,
  MONTH_GROUP_HEADER,
  PAIR_FOLLOW_BINDINGS,
  toCellStr,
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
  gridRef: MutableRefObject<FlexGridType<DemandManagerRow> | undefined>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef?: MutableRefObject<EditTracker<DemandManagerRow> | undefined>;
  staticColumns?: RawFlexGridColumnConfig[];
  monthColumns: MonthColumnMeta[];
  projectOptions?: LookupProjectRow[];
  /** 편집 계열 권한 (그룹 게이트 통과 여부) */
  canEdit: boolean;
}

const toNumber = (v: unknown): number => {
  if (v == null || v === '') return 0;
  const n = typeof v === 'number' ? v : Number(toCellStr(v).replace(/,/g, ''));
  return Number.isFinite(n) ? n : 0;
};

// 음수 값 글자색 (sales-monitoring / customer-fcst-upload 와 동일 톤)
const NEGATIVE_COLOR = '#c0392b';

/**
 * 음수면 빨간 글자, 아니면 원복.
 *
 * 필수: 음수가 아닐 때 반드시 지운다 — Wijmo 는 셀 DOM 을 재사용하므로 칠하기만 하면
 * 스크롤 뒤 엉뚱한 셀에 색이 남는다.
 * 필수: important 로 넣는다 — 잠금 셀 규칙(.wj-cell-non-editable)이 color 를 !important 로
 * 잡고 있어(전역 스타일) 일반 인라인 색은 밀린다.
 */
const paintNegative = (cell: HTMLElement, value: number) => {
  if (value < 0) cell.style.setProperty('color', NEGATIVE_COLOR, 'important');
  else cell.style.removeProperty('color');
};

/** 세트의 첫 행인지 — 바로 위 행과 그룹 키가 다르면 첫 행 */
const isSetHead = (rows: DemandManagerRow[], idx: number): boolean => {
  if (idx <= 0) return true;
  const key = (r: DemandManagerRow | undefined) => String(r?.KEYVALUE2 ?? r?.INSERT_GROUP_ID ?? '');
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
  const staticBindingSet = useMemo(() => new Set(fixedColumns.map(c => c.colNm)), [fixedColumns]);

  // Project 셀 콤보 — PKG_DMF0068.P_DMF0068_GET_LOOKUPPROJECT (CODE/NAME)
  const projectDataMap = useMemo<DataMap | null>(() => {
    const list = (projectOptions ?? []) as unknown as Record<string, unknown>[];
    return list.length > 0 ? new DataMap(list, 'CODE', 'NAME') : null;
  }, [projectOptions]);

  // ⭐ 월 컬럼 — 조회 기간에서 산출. AS-IS 와 동일하게 전체 월을 상위 헤더 하나로 묶고(2단),
  //   leaf 에 yyyy.MM 을 표시한다. 연도별로 쪼개지 않는다.
  const mainDynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
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
  }, [monthColumns]);

  const monthByBinding = useMemo(() => {
    const m = new Map<string, MonthColumnMeta>();
    monthColumns.forEach(x => m.set(x.binding, x));
    return m;
  }, [monthColumns]);

  // 핸들러가 최신 상태를 보도록 ref 미러
  const ctxRef = useRef({ canEdit, rows, monthByBinding });
  ctxRef.current = { canEdit, rows, monthByBinding };

  useEffect(() => {
    const g = gridRef.current;
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
      // Project 는 신규 세트에서만 입력할 수 있다 — 조회된 행에서는 잠근다
      if (
        INSERT_ONLY_BINDINGS.includes(binding as (typeof INSERT_ONLY_BINDINGS)[number]) &&
        row?.CRUD_TYPE !== CRUD_TYPE.INSERT
      ) {
        return false;
      }
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
        // 데이터(월) 컬럼은 정수로만 보여준다 — 소수점 이하는 버린다.
        //   주의: 인자 없는 toLocaleString() 은 maximumFractionDigits 기본이 3 이라
        //   SP 가 소수를 내려주면 그대로 노출된다. business-plan / sales-plan 의 INTEGER 표기와 동일.
        //   0 판정은 자른 뒤에 한다 — -0.4 같은 값이 '-0' 으로 찍히거나 빨갛게 칠해지지 않도록.
        const shown = Math.trunc(n);
        e.cell.textContent = shown === 0 ? '0' : shown.toLocaleString();
        toggleClass(e.cell, 'wj-cell-non-editable', true);
        paintNegative(e.cell, shown);
        return;
      }
      if (staticBindingSet.has(binding)) {
        toggleClass(e.cell, 'wj-cell-editable', editableAt(binding, e.row));
        toggleClass(e.cell, 'wj-cell-non-editable', !editableAt(binding, e.row));
      }
      // 수량 등 숫자 셀 음수 표시. 문자열 컬럼은 toNumber 가 0 을 돌려주므로 자연히 제외된다.
      paintNegative(e.cell, toNumber(rowItem?.[binding]));
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
    // 붙여넣기도 같은 편집 규칙을 태운다. 공통 DataGrid 가 pastingCell 에 관리자 메타 기준
    //   게이트를 걸어 두므로(dataGridUtils setEditableColumns), 화면 규칙으로 덮어쓰지 않으면
    //   편집 가능한 셀인데도 붙여넣기만 막힌다.
    g.pastingCell.addHandler(beginningEditHandler as never);

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
    // cellEditEnded 는 타이핑 편집에만 발생한다. 붙여넣기로 고친 경우에도 짝 행이 따라가야 한다.
    g.pastedCell.addHandler(cellEditEndedHandler as never);

    return () => {
      try {
        g.formatItem.removeHandler(formatHandler);
        g.beginningEdit.removeHandler(beginningEditHandler as never);
        g.pastingCell.removeHandler(beginningEditHandler as never);
        g.cellEditEnded.removeHandler(cellEditEndedHandler as never);
        g.pastedCell.removeHandler(cellEditEndedHandler as never);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, staticBindingSet]);

  // 헤더 높이 48px 고정 (#93) + Project 셀 콤보 배선
  useEffect(() => {
    const g = gridRef.current;
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

  // 필터가 걸린 상태에서 Insert — 값이 빈 신규행은 필터 조건에 걸려 CollectionView 에서 빠진다.
  //   공용 keepRowVisibleUnderFilter 로 wijmo 예외 집합(grid._newAddedRowsSet)에 등록해 보이게 한다.
  //   필터 자체의 보존은 공용 DataGrid 가 담당한다(itemsSourceChanged 의 capture -> clear -> restore).
  //   주의: 등록은 한 번으로 끝나지 않는다. FlexGridFilter.apply() 가 이 Set 을 null 로 비우는데
  //     DataGrid 의 필터 복원이 곧 apply() 라 Insert 마다 예외가 날아가 신규행이 다시 숨는다.
  //     따라서 rows 변경 시와 filterApplied 시 양쪽에서 재등록한다 (DMF0042 배선 1:1).
  const reapplyInsertRowVisibility = useCallback((): boolean => {
    const g = gridRef.current;
    // 컬럼이 없는 그리드에 refresh 를 걸면 wijmo 가 컬럼 인덱스 -1 로 계산하다 예외를 던진다.
    if (!g || g.columns.length === 0) return false;
    const insertRows = ctxRef.current.rows.filter(r => r.CRUD_TYPE === 'I');
    if (insertRows.length === 0) return false;
    insertRows.forEach(row => keepRowVisibleUnderFilter(g, row));
    return true;
  }, [gridRef]);

  /**
   * 선택 행을 붙든 채 CollectionView 를 다시 계산한다.
   *
   * refresh() 는 뷰를 새로 만들고 그리드가 행을 다시 바인딩하는데, 이때 선택은 행 참조가 아니라
   * 인덱스·CollectionView 의 현재 위치를 따라간다. 그래서 필터 복원(apply -> refresh)이
   * 화면단 Insert 포커스 이동보다 늦게 돌면 커서가 방금 만든 행이 아니라 엉뚱한 행
   * (인덱스 보정으로 밀린 그리드 끝 행)에 남는다.
   * refresh 전에 선택 행을 참조로 잡아 두었다가 같은 행에 선택을 되돌린다.
   */
  const refreshKeepingSelection = useCallback(() => {
    const g = gridRef.current;
    const cv = g?.collectionView;
    if (!g || !cv) return;
    const selRow = g.selection?.row ?? -1;
    const selCol = g.selection?.col ?? -1;
    const selItem =
      selRow >= 0 ? (g.rows[selRow]?.dataItem as DemandManagerRow | undefined) : undefined;
    cv.refresh();
    if (!selItem) return;
    for (let i = 0; i < g.rows.length; i++) {
      if (g.rows[i]?.dataItem !== selItem) continue;
      if (g.selection?.row !== i) g.select(i, selCol >= 0 ? selCol : 0);
      return;
    }
  }, [gridRef]);

  useEffect(() => {
    if (reapplyInsertRowVisibility()) refreshKeepingSelection();
  }, [rows, reapplyInsertRowVisibility, refreshKeepingSelection]);

  // F4 Filter — 월 컬럼은 필터 대상에서 제외
  useEffect(() => {
    const g = gridRef.current;
    if (!g || !gridFilterRef) return;
    const onFilterChanging = (
      _s: FlexGridFilter,
      e: { cancel: boolean; getColumn: () => { binding?: string | null } }
    ) => {
      if (/^M\d+$/.test(e.getColumn()?.binding ?? '')) e.cancel = true;
    };
    // 금지: 여기서 새 FlexGridFilter 를 만들지 말 것 (2026-08-22 실측 — "필터 걸고 행추가하면 필터가 풀림").
    //   공용 DataGrid 가 itemsSourceChanged 에 [capture -> FlexGridFilter 생성(=wijmo clear) -> restore]
    //   를 등록 순서로 걸어 필터를 되살린다. 화면이 두 번째 인스턴스를 만들면 그 clear 핸들러가
    //   restore 뒤에 붙어 마지막에 실행되므로 복원분이 도로 지워진다.
    //   필수: DataGrid 에 gridFilterRef 를 넘겨 인스턴스를 공유한다(아래 JSX). 여기서는 없을 때만
    //     안전망으로 만든다 — business-plan / forecast-price 가 쓰는 배선과 동일하다.
    if (!gridFilterRef.current) {
      const created = new FlexGridFilterCtor(g);
      created.filterColumns = [''];
      gridFilterRef.current = created;
    }
    const f = gridFilterRef.current;
    let raf = 0;
    const onFilterApplied = () => {
      g.invalidate(true);
      // apply() 가 방금 비운 신규행 예외 집합을 되살린다.
      //   주의: refresh 를 filterApplied 안에서 바로 부르면 wijmo apply() 도중 재진입이 되어
      //     내부 인덱스가 어긋난다. 다음 프레임으로 미룬다(DMF0082 선례).
      if (!reapplyInsertRowVisibility()) return;
      window.cancelAnimationFrame(raf);
      raf = window.requestAnimationFrame(() => {
        reapplyInsertRowVisibility();
        refreshKeepingSelection();
      });
    };
    f.filterChanging.addHandler(onFilterChanging as never);
    f.filterApplied.addHandler(onFilterApplied);
    return () => {
      window.cancelAnimationFrame(raf);
      try {
        f?.filterChanging.removeHandler(onFilterChanging as never);
        f?.filterApplied.removeHandler(onFilterApplied);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, gridFilterRef, monthColumns, reapplyInsertRowVisibility, refreshKeepingSelection]);

  return (
    // <div className={styles.gridContainer}>
    <DataGrid<DemandManagerRow>
      key={mainStaticColumns.map(c => c.colNm).join(',')}
      className={styles.grid}
      gridRef={gridRef}
      // 필수: 필터 인스턴스를 공용 DataGrid 와 공유한다. 넘기지 않으면 DataGrid 가 필터를
      //   만들지 않아 itemsSourceChanged 의 capture/restore 가 전부 no-op 이 되고,
      //   화면이 뒤늦게 만든 필터의 clear 만 남아 행 추가 때마다 필터가 풀린다.
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      staticColumns={mainStaticColumns}
      dynamicColumns={mainDynamicColumns}
      itemsSource={rows}
      autoGenerateColumns={false}
      allowSorting={false}
      allowMerging={AllowMerging.All}
    />
    // </div>
  );
};
