import {
  type FlexGrid,
  AllowMerging,
  CellType,
  SelectionMode,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';
import { useEffect, useMemo, useRef } from 'react';

import dayjs from '@foundation/dayjs';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { EditTracker, paintNegativeText, toGridNumber } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, MEASURE, MENU_ID } from '../capa-mobility-it.constants';
import type { CapaMobilityItRow, CapaRowItem } from '../capa-mobility-it.types';
import {
  buildDynColMetas,
  buildDynamicColumns,
  buildHeaderKeyMap,
  CapaHeaderMergeManager,
  kindOf,
  visibleKinds,
} from '../utils/capa-mobility-it.dynamicColumns';
import { isCellEditable } from '../utils/capa-mobility-it.editLock';

/** 숫자(0-9), 맨 앞 음수 부호, 소수점 하나만 남긴다(붙여넣기·IME 조합 결과 정리용). */
const toNumericText = (value: unknown): string => {
  const raw = typeof value === 'string' || typeof value === 'number' ? String(value) : '';
  const sign = raw.trimStart().startsWith('-') ? '-' : '';
  const [int, ...frac] = raw.replace(/[^0-9.]/g, '').split('.');
  return `${sign}${frac.length > 0 ? `${int}.${frac.join('')}` : int}`;
};

/** PRODUCT_READY Auto-Sync 그룹 키 컬럼 (design 03 §R1 — 동일키 행 전체 값 복제). */
const SYNC_KEY_COLS = ['DIVISION_ID', 'PLANT_ID', 'FACTORY_ID', 'OPERATION_ID', 'LINE_ID'] as const;

/** unknown → 원시 문자열(객체는 '') — no-base-to-string 안전 변환. */
const asStr = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

interface Props {
  gridRef: MutableRefObject<FlexGrid<CapaMobilityItRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | null>;
  data: CapaMobilityItRow[];
  staticColumns: RawFlexGridColumnConfig[];
  bucketType: string;
  canEdit: boolean;
}

export const CapaMobilityItGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  staticColumns,
  bucketType,
  canEdit,
}: Props) => {
  const { t } = useTranslation();
  const { setAlert } = useMessageStore();

  const staticBindingSet = useMemo(() => new Set(staticColumns.map(c => c.colNm)), [staticColumns]);
  const staticBindingRef = useRef(staticBindingSet);
  staticBindingRef.current = staticBindingSet;
  const canEditRef = useRef(canEdit);
  canEditRef.current = canEdit;

  // 핸들러(비 React 콜백)가 최신 행을 보도록 ref 로 전달 — 핸들러 effect 는 data 로 재바인딩하지 않는다.
  const dataRef = useRef(data);
  dataRef.current = data;

  const dynColMetas = useMemo(() => buildDynColMetas(data), [data]);
  const hasDaily = useMemo(() => dynColMetas.some(m => m.kind === 'D'), [dynColMetas]);
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(
    () => buildDynamicColumns(dynColMetas, hasDaily),
    [dynColMetas, hasDaily]
  );

  // 헤더 머지 키 — 매니저는 1회만 생성(super 가 grid 이벤트 바인딩), ref 로 최신 맵 전달.
  const headerKeyMap = useMemo(() => buildHeaderKeyMap(dynColMetas), [dynColMetas]);
  const headerKeyRef = useRef(headerKeyMap);
  headerKeyRef.current = headerKeyMap;

  // 표시 대상 kind (bucket).
  const visibleKindSet = useMemo(() => visibleKinds(bucketType), [bucketType]);
  const dynBindings = useMemo(() => dynColMetas.map(m => m.binding), [dynColMetas]);

  // 편집 가능 판정(canEdit gate 포함) — beginningEdit/formatItem 공통.
  const editableCell = (binding: string, row: CapaRowItem | undefined): boolean =>
    canEditRef.current && isCellEditable(binding, row, staticBindingRef.current);

  // ── 헤더 머지 매니저 설치 ──
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    if (g.mergeManager instanceof CapaHeaderMergeManager) return;
    g.mergeManager = new CapaHeaderMergeManager(g, () => headerKeyRef.current);
    g.invalidate(true);
  }, [gridRef, staticColumns, dynamicColumns]);

  // ── grid 핸들러 (편집잠금 / NO_WORK Y/N / PRODUCT_READY Auto-Sync / 셀 포맷) ──
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // EditTracker 는 화면이 소유·생성한다(ForecastPrice 선례) — beginningEdit/cellEditEnded 자동 추적.
    editTrackerRef.current = new EditTracker(g as unknown as FlexGrid);

    const beginningEditHandler = (
      sender: FlexGrid,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding;
      const row = sender.rows[e.row]?.dataItem as CapaRowItem | undefined;
      // 공용 DataGrid 의 beginningEdit 핸들러가 admin 메타(INPUT_TP_CD) 기준으로 먼저 cancel=true 를 세운다.
      // PRODUCT_READY 는 메타가 'S', 동적 D_/M_ 컬럼은 메타가 없어 그대로 두면 편집이 막힌다.
      // 이 핸들러가 나중에 실행되므로 편집 가능으로 판정한 셀은 cancel=false 로 되돌려야 한다.
      e.cancel = !binding || !row || !editableCell(binding, row);
    };

    const cellEditEndedHandler = (
      sender: FlexGrid,
      e: { row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding;
      const row = sender.rows[e.row]?.dataItem as CapaRowItem | undefined;
      if (!binding || !row) return;
      const tracker = editTrackerRef.current;

      // NO_WORK 의 D_ 셀 — Y/N 만 허용, 그 외는 'N' 으로 되돌림(design 03 §R1).
      if (asStr(row.MEASURE_UI) === MEASURE.NO_WORK && kindOf(binding) === 'D') {
        const v = asStr((row as Record<string, unknown>)[binding]).trim().toUpperCase();
        if (v !== 'Y' && v !== 'N') {
          (row as Record<string, unknown>)[binding] = 'N';
          void setAlert({ type: 'alert', content: t('MSG00000', '_[Y,N] only.') });
          sender.invalidate();
        } else if (v !== (row as Record<string, unknown>)[binding]) {
          (row as Record<string, unknown>)[binding] = v;
        }
        return;
      }

      // PRODUCT_READY — 동일 키(5축) 행 전체에 값 복제(생산준비율 Auto-Sync, design 03 §R1).
      if (binding === 'PRODUCT_READY') {
        // 붙여넣기 등 편집기를 거치지 않은 값도 숫자만 남긴다.
        const typed = (row as Record<string, unknown>)['PRODUCT_READY'];
        const cleaned = toNumericText(typed);
        if (typeof typed === 'string' && typed !== cleaned) {
          (row as Record<string, unknown>)['PRODUCT_READY'] = cleaned;
        }
        const val = (row as Record<string, unknown>)['PRODUCT_READY'];
        const keyOf = (r: CapaRowItem): string =>
          SYNC_KEY_COLS.map(k => asStr((r as Record<string, unknown>)[k])).join('|');
        const myKey = keyOf(row);
        for (const other of dataRef.current as unknown as CapaRowItem[]) {
          if (other === row) continue;
          if (keyOf(other) !== myKey) continue;
          const prev = (other as Record<string, unknown>)['PRODUCT_READY'];
          if (prev === val) continue;
          tracker?.storeChange(other as never, 'PRODUCT_READY', prev as never, val as never);
          (other as Record<string, unknown>)['PRODUCT_READY'] = val;
        }
        sender.invalidate();
      }
    };

    const formatHandler = (
      sender: FlexGrid,
      e: { panel: { cellType: CellType }; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel.cellType === CellType.TopLeft) {
        const label = e.col === 0 ? 'No.' : '';
        if (e.cell.textContent !== label) e.cell.textContent = label;
        return;
      }
      if (e.panel.cellType === CellType.ColumnHeader) {
        // 주말 일자 헤더 색 — 토요일 파랑 / 일요일 빨강 (D_ leaf 헤더 한정, design 03 §2.2).
        const hb = sender.columns[e.col]?.binding ?? '';
        if (!hb.startsWith('D_')) return;
        const leafRow = sender.columnHeaders.rows.length - 1;
        if (e.row !== leafRow) return;
        const ymd = hb.slice(2);
        const dow = dayjs(`${ymd.slice(0, 4)}-${ymd.slice(4, 6)}-${ymd.slice(6, 8)}`).day();
        // wijmo DOM 셀 직접 스타일링(ForecastPrice 선례) — React JSX inline style(Top11 #5)과 별개.
        if (dow === 6) e.cell.style.color = '#1565c0';
        else if (dow === 0) e.cell.style.color = '#d32f2f';
        return;
      }
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = sender.columns[e.col]?.binding;
      const row = sender.rows[e.row]?.dataItem as CapaRowItem | undefined;
      if (!binding || !row) return;

      // 편집 가능 셀 Yellow 표기(공용 클래스).
      e.cell.classList.toggle('wj-cell-editable', editableCell(binding, row));

      const kind = kindOf(binding);
      if (!kind) return;
      const measure = asStr(row.MEASURE_UI);
      const raw = (row as Record<string, unknown>)[binding];
      if (measure === MEASURE.NO_WORK) {
        // 비조업 — 중앙정렬 Blue (design 03 §R5). wijmo DOM 셀 직접 스타일.
        e.cell.style.textAlign = 'center';
        e.cell.style.color = '#1565c0';
        e.cell.innerText = asStr(raw);
        return;
      }
      // 숫자 — DAILY_CAPA = 정수 천단위, LOAD_RATE/RAMP_UP = 소수 그대로. 0/빈값 = 빈칸.
      if (!sender.editRange?.contains(e.row, e.col)) {
        if (raw === undefined || raw === null || raw === 0 || raw === '') {
          e.cell.innerText = '';
        } else {
          const n = toGridNumber(raw);
          e.cell.innerText =
            measure === MEASURE.DAILY_CAPA
              ? n.toLocaleString(undefined, { maximumFractionDigits: 0 })
              : asStr(raw);
          paintNegativeText(e.cell, n);
        }
      }
    };

    // 생산준비(%) 입력은 숫자, 음수 부호, 소수점만 받는다. IME 조합(한글)은 막을 수 없어 입력·조합 종료 때 걸러 낸다.
    const prepareCellForEditHandler = (sender: FlexGrid, e: { col: number }) => {
      if (sender.columns[e.col]?.binding !== 'PRODUCT_READY') return;
      const editor = sender.activeEditor;
      if (!editor) return;
      const keepNumeric = () => {
        const cleaned = toNumericText(editor.value);
        if (cleaned !== editor.value) editor.value = cleaned;
      };
      editor.addEventListener('beforeinput', (ev: InputEvent) => {
        if (!ev.isComposing && ev.data && /[^0-9.-]/.test(ev.data)) ev.preventDefault();
      });
      editor.addEventListener('input', (ev: Event) => {
        if (!(ev as InputEvent).isComposing) keepNumeric();
      });
      editor.addEventListener('compositionend', keepNumeric);
    };

    g.beginningEdit.addHandler(beginningEditHandler);
    g.prepareCellForEdit.addHandler(prepareCellForEditHandler as never);
    g.pastingCell.addHandler(beginningEditHandler);
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    g.pastedCell.addHandler(cellEditEndedHandler);
    g.formatItem.addHandler(formatHandler);
    return () => {
      g.beginningEdit.removeHandler(beginningEditHandler);
      g.prepareCellForEdit.removeHandler(prepareCellForEditHandler as never);
      g.pastingCell.removeHandler(beginningEditHandler);
      g.cellEditEnded.removeHandler(cellEditEndedHandler);
      g.pastedCell.removeHandler(cellEditEndedHandler);
      g.formatItem.removeHandler(formatHandler);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns, dynamicColumns]);

  // ── 다단 헤더 높이 48px 고정 (#93) ──
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const applyHeaderHeight = () => {
      const headerRows = g.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      const per = Math.round(48 / headerRows.length);
      if (Math.round(headerRows.defaultSize) === per) return;
      headerRows.defaultSize = per;
      for (let i = 0; i < headerRows.length; i++) headerRows[i].height = per;
    };
    g.updatedLayout.addHandler(applyHeaderHeight);
    applyHeaderHeight();
    return () => {
      try {
        g.updatedLayout.removeHandler(applyHeaderHeight);
      } catch {
        /* unmount race */
      }
    };
  }, [dynamicColumns, gridRef]);

  // ── 동적 컬럼 가시성 (bucket → visibleKinds) ──
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const dynSet = new Set(dynBindings);
    const applyVisibility = () => {
      let changed = false;
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        const b = col.binding ?? '';
        if (!dynSet.has(b)) continue;
        const kind = kindOf(b);
        const want = kind ? visibleKindSet.has(kind) : false;
        if (col.visible !== want) {
          col.visible = want;
          changed = true;
        }
      }
      if (changed) g.invalidate(true);
    };
    g.updatedLayout.addHandler(applyVisibility);
    applyVisibility();
    return () => {
      try {
        g.updatedLayout.removeHandler(applyVisibility);
      } catch {
        /* unmount race */
      }
    };
  }, [visibleKindSet, dynBindings, dynamicColumns, gridRef]);

  return (
    <DataGrid<CapaMobilityItRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
      dynamicColumns={dynamicColumns}
      comboParams={{ mnuId: `'${MENU_ID}'` }}
      sheetName={ADMIN_SHEET_NAME}
      selectionMode={SelectionMode.MultiRange}
      // 다단 헤더 병합 필요 — Cells 는 헤더 병합이 꺼진다(자매 pivot 화면 동일 All).
      allowMerging={AllowMerging.All}
      alternatingRowStep={1}
      useHotkey
    />
  );
};
