import { CollectionView } from '@mescius/wijmo';
import {
  CellRange, CellType,
  DataMap,
  type FlexGrid as FlexGridType,
  type GridPanel,
  MergeManager,
  Row,
} from '@mescius/wijmo.grid';
import { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import { useEffect, useMemo, useRef } from 'react';

import { FROZEN_COL_COUNT, MAIN_COLUMNS, type MainColumnMeta } from '../mkt-forecast-master.constants';
import { useMktForecastDynamicColumns } from '../hooks/useMktForecastDynamicColumns';
import type { MktFcstRow, SearchCondition } from '../mkt-forecast-master.types';

export interface ComboItem { CODE: string; NAME: string }

interface Props {
  rows: MktFcstRow[];
  gridRef: React.RefObject<unknown>;
  gridFilterRef?: React.RefObject<FlexGridFilter | undefined>;
  divisionId: string;
  searchCondition?: SearchCondition;
  onCellEditEnded?: (sender: unknown, e: { row: number; col: number }) => void;
  comboData?: Record<string, ComboItem[]>;
  onPopupCellDblClick?: (row: MktFcstRow, modalKey: string, binding: string) => void;
}

const NO_MERGE_KEYS = new Set(['MEASURE', 'YYYYMMDD', 'QTY', 'EDIT_FLAG']);
const COL_META: Map<string, MainColumnMeta> = new Map(MAIN_COLUMNS.map(c => [c.key, c]));

const getDynKey = (binding: string): { kind: 'D' | 'W' | 'M' | ''; ym: string; wk: string } => {
  if (binding.startsWith('D_') && binding.length === 10) return { kind: 'D', ym: `${binding.slice(2, 6)}-${binding.slice(6, 8)}`, wk: binding.slice(8, 10) };
  if (binding.startsWith('W_') && binding.length === 10) return { kind: 'W', ym: `${binding.slice(2, 6)}-${binding.slice(6, 8)}`, wk: binding.slice(8, 10) };
  if (binding.startsWith('M_') && binding.length === 8)  return { kind: 'M', ym: `${binding.slice(2, 6)}-${binding.slice(6, 8)}`, wk: '' };
  return { kind: '', ym: '', wk: '' };
};

// 자매 DMF0020 SalesFuturePriceFlexGrid 정확 동등 패턴 (사용자 명시 요구 2026-06-07):
//   - JSX <FlexGridColumn> 으로 columns 평면 정의 (imperative columnLayout JSON 폐기)
//   - 3-row column header — initialized 에서 columnHeaders.rows.push(new Row()) 2개 추가
//   - formatItem 의 ColumnHeader 분기에서 row 0/1/2 별 textContent 직접 설정
//   - DataMap useMemo + useEffect 가 col.binding 으로 dataMaps[binding] reference 할당
//   - g.invalidate(true) 강제 redraw
export const MktForecastMasterGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  divisionId,
  searchCondition,
  onCellEditEnded,
  comboData = {},
  onPopupCellDblClick,
}: Props) => {
  const dynamicCols = useMktForecastDynamicColumns(
    searchCondition ?? ({ divisionId, bucketType: 'W', startYyyymmdd: '', endYyyymmdd: '' } as never),
  );

  // FlexGrid instance ref — beginningEdit/mouseDoubleClick 등 cell handler 가 panel 접근에 사용 (use-before-define 방지)
  const gridInstanceRef = useRef<FlexGridType<MktFcstRow> | null>(null);

  const collectionView = useMemo(() => new CollectionView(rows), [rows]);

  const fixedColumns = useMemo(
    () => dynamicCols.fixedColumns.filter(c => c.visible !== false),
    [dynamicCols.fixedColumns],
  );

  // HierarchicalMergeManager — Data Cell + ColumnHeader 머지
  const mergeManager = useMemo(() => {
    const fixedBindings = fixedColumns.map(c => c.key);

    class HierarchicalMergeManager extends MergeManager {
      override getMergedRange(panel: GridPanel, r: number, c: number): CellRange | null {
        const col = panel.columns[c];
        if (!col) return null;
        const binding = col.binding ?? '';

        if (panel.cellType === CellType.Cell && fixedBindings.includes(binding) && !NO_MERGE_KEYS.has(binding)) {
          const view = panel.rows as unknown as { length: number; [n: number]: { dataItem?: Record<string, string> } };
          const cur = view[r]?.dataItem;
          if (!cur) return null;
          if (String(cur.EDIT_FLAG ?? '') === 'I') return null;
          const fixedIdx = fixedBindings.indexOf(binding);
          const leftBindings = fixedBindings.slice(0, fixedIdx + 1).filter(k => !NO_MERGE_KEYS.has(k));
          const sameRow = (a: number, b: number): boolean => {
            const ra = view[a]?.dataItem; const rb = view[b]?.dataItem;
            if (!ra || !rb) return false;
            if (String(ra.EDIT_FLAG ?? '') === 'I' || String(rb.EDIT_FLAG ?? '') === 'I') return false;
            return leftBindings.every(k => String(ra[k] ?? '') === String(rb[k] ?? ''));
          };
          let r1 = r, r2 = r;
          while (r1 > 0 && sameRow(r1 - 1, r)) r1--;
          while (r2 < view.length - 1 && sameRow(r2 + 1, r)) r2++;
          if (r1 === r2) return null;
          return new CellRange(r1, c, r2, c);
        }

        if (panel.cellType === CellType.ColumnHeader) {
          if (fixedBindings.includes(binding)) return new CellRange(0, c, 2, c);
          const dyn = getDynKey(binding);
          if (dyn.kind === 'D' || dyn.kind === 'W') {
            if (r === 0) {
              let c1 = c, c2 = c;
              while (c1 > 0) {
                const p = getDynKey(panel.columns[c1 - 1].binding ?? '');
                if ((p.kind === 'D' || p.kind === 'W') && p.ym.slice(0, 4) === dyn.ym.slice(0, 4)) c1--; else break;
              }
              while (c2 < panel.columns.length - 1) {
                const n = getDynKey(panel.columns[c2 + 1].binding ?? '');
                if ((n.kind === 'D' || n.kind === 'W') && n.ym.slice(0, 4) === dyn.ym.slice(0, 4)) c2++; else break;
              }
              return new CellRange(0, c1, 0, c2);
            }
            if (r === 1) {
              let c1 = c, c2 = c;
              while (c1 > 0) {
                const p = getDynKey(panel.columns[c1 - 1].binding ?? '');
                if ((p.kind === 'D' || p.kind === 'W') && p.ym === dyn.ym) c1--; else break;
              }
              while (c2 < panel.columns.length - 1) {
                const n = getDynKey(panel.columns[c2 + 1].binding ?? '');
                if ((n.kind === 'D' || n.kind === 'W') && n.ym === dyn.ym) c2++; else break;
              }
              return new CellRange(1, c1, 1, c2);
            }
          } else if (dyn.kind === 'M' && r === 0) {
            const yr = dyn.ym.slice(0, 4);
            let c1 = c, c2 = c;
            while (c1 > 0) {
              const p = getDynKey(panel.columns[c1 - 1].binding ?? '');
              if (p.kind === 'M' && p.ym.slice(0, 4) === yr) c1--; else break;
            }
            while (c2 < panel.columns.length - 1) {
              const n = getDynKey(panel.columns[c2 + 1].binding ?? '');
              if (n.kind === 'M' && n.ym.slice(0, 4) === yr) c2++; else break;
            }
            return new CellRange(0, c1, 0, c2);
          }
        }

        return null;
      }
    }
    return new HierarchicalMergeManager();
  }, [fixedColumns]);

  // formatItem — ColumnHeader 의 row 0/1/2 textContent + cell coloring
  const formatItem = (_g: unknown, e: { panel: GridPanel; row: number; col: number; cell: HTMLElement }) => {
    const col = e.panel.columns[e.col];
    if (!col) return;
    const binding = col.binding ?? '';

    // ColumnHeader — fixed cols (row 0~2 머지 by mergeManager) + dynamic cols 의 row 0/1/2 textContent
    if (e.panel.cellType === CellType.ColumnHeader) {
      const dyn = getDynKey(binding);
      if (dyn.kind) {
        // dynamic col 3-row header
        if (e.row === 0) e.cell.textContent = dyn.ym.slice(0, 4);   // Year
        else if (e.row === 1) e.cell.textContent = dyn.ym.slice(5, 7); // Month
        else if (e.row === 2) {
          if (dyn.kind === 'D') e.cell.textContent = dyn.wk;
          else if (dyn.kind === 'W') e.cell.textContent = `W${dyn.wk}`;
          else e.cell.textContent = '월';
        }
        (e.cell as HTMLElement).style.textAlign = 'center';
      } else if (fixedColumns.some(c => c.key === binding)) {
        // fixed col — mergeManager 가 row 0-2 머지. row 0 의 cell 만 표시
        const meta = COL_META.get(binding);
        e.cell.textContent = meta?.header ?? binding;
        (e.cell as HTMLElement).style.textAlign = 'center';
      }
      return;
    }

    if (e.panel.cellType !== CellType.Cell) return;
    const item = (e.panel.rows[e.row] as unknown as { dataItem?: Record<string, string> })?.dataItem;
    const isNewRow = String(item?.EDIT_FLAG ?? '') === 'I';

    // dynamic cell coloring (D_/W_/M_)
    if (binding.startsWith('D_') || binding.startsWith('W_') || binding.startsWith('M_')) {
      const measure = String(item?.MEASURE ?? '');
      const colIsEditable = col.isReadOnly === false;
      const measureIsEditable = measure === 'MKT_FCST';
      e.cell.style.backgroundColor = (colIsEditable && measureIsEditable) ? '#fff8cd' : '#f1f4f3';
      return;
    }

    // fixed col cell coloring — 신규 row 의 popup/combo cell 노랑
    const meta = COL_META.get(binding);
    if (!meta) return;
    const isInputType = meta._inputEditType === 'IM' || meta._inputEditType === 'IO';
    if (isNewRow && isInputType) {
      e.cell.style.backgroundColor = '#fff8cd';
      if (meta._ctrlType === 'FPModal') {
        e.cell.style.cursor = 'pointer';
        e.cell.title = '더블클릭하여 선택';
      }
    }
  };

  // beginningEdit — 신규 row 가 아니면 fixed col 편집 막기
  const beginningEdit = (_g: unknown, e: { row: number; col: number; cancel: boolean; panel?: GridPanel }) => {
    const panel = e.panel ?? (gridInstanceRef.current as unknown as { cells: GridPanel })?.cells;
    if (!panel) return;
    const col = panel.columns[e.col];
    const binding = col?.binding ?? '';
    const meta = COL_META.get(binding);
    if (!meta) return;
    const item = (panel.rows[e.row] as unknown as { dataItem?: Record<string, string> })?.dataItem;
    const isNewRow = String(item?.EDIT_FLAG ?? '') === 'I';
    const isInputType = meta._inputEditType === 'IM' || meta._inputEditType === 'IO';
    if (!isNewRow || !isInputType) {
      e.cancel = true;
    }
  };

  // mouseDoubleClick — popup cell (FPModal) 더블클릭 시 부모 modal 호출
  const mouseDoubleClick = (g: FlexGridType<MktFcstRow>, e: MouseEvent) => {
    if (!onPopupCellDblClick) return;
    const ht = g.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;
    const col = g.columns[ht.col];
    const binding = col?.binding ?? '';
    const meta = COL_META.get(binding);
    if (!meta || meta._ctrlType !== 'FPModal' || !meta._modalKey) return;
    const item = g.rows[ht.row]?.dataItem;
    if (!item) return;
    if (((item as Record<string, string>).EDIT_FLAG ?? '') !== 'I') return;
    onPopupCellDblClick(item as MktFcstRow, meta._modalKey, binding);
  };

  // DataMap memoize — 자매 DMF0020 정확 동등 패턴
  const dataMaps = useMemo<Record<string, DataMap | null>>(() => {
    const make = (q: ComboItem[] | undefined): DataMap | null => {
      const arr = q ?? [];
      if (arr.length === 0) return null;
      return new DataMap(arr, 'CODE', 'NAME');
    };
    const obj: Record<string, DataMap | null> = {};
    for (const [k, v] of Object.entries(comboData)) {
      obj[k] = make(v);
    }
    return obj;
  }, [comboData]);

  // combo column DataMap 적용 + mergeManager 갱신 — 자매 DMF0020 패턴 동등
  useEffect(() => {
    const g = gridInstanceRef.current;
    if (!g) return;
    try {
      g.mergeManager = mergeManager as never;
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        col.allowMerging = true;
        const binding = col.binding ?? '';
        const dm = dataMaps[binding];
        if (dm) col.dataMap = dm;
      }
      g.invalidate(true);
    } catch { /* noop */ }
  }, [dataMaps, mergeManager, fixedColumns, dynamicCols.dynamicColumns]);

  return (
    <FlexGrid
      style={{ height: '100%', width: '100%' }}
      itemsSource={collectionView}
      allowSorting={true}
      allowAddNew={false}
      allowDelete={false}
      autoGenerateColumns={false}
      headersVisibility='Column'
      // selectionMode='Row' 제거 (사용자 명시 요구 2026-06-07):
      //   자매 DMF0020 SalesFuturePriceFlexGrid 미명시 = default 'MultiRange'
      //   'Row' 는 single click 시 row 만 선택 → cell editor 진입 차단 (dropdown 미표시 원인)
      //   default 'MultiRange' 는 single click 시 cell focus + F2/type 시 ComboBox 진입
      frozenColumns={FROZEN_COL_COUNT}
      cellEditEnded={onCellEditEnded as never}
      beginningEdit={beginningEdit as never}
      formatItem={formatItem as never}
      initialized={(g: FlexGridType<MktFcstRow>) => {
        const r = gridRef as { current: unknown };
        r.current = g;
        gridInstanceRef.current = g;

        // 3-row column header (자매 DMF0020 SalesFuturePriceFlexGrid:130-134 패턴)
        if (g.columnHeaders.rows.length === 1) {
          g.columnHeaders.rows.push(new Row());
          g.columnHeaders.rows.push(new Row());
        }
        g.columnHeaders.rows.defaultSize = 24;

        g.mergeManager = mergeManager as never;
        g.hostElement.addEventListener('dblclick', (ev) => mouseDoubleClick(g, ev as MouseEvent));
      }}
    >
      {/* fixed cols — JSX FlexGridColumn 평면 + dataMap prop 직접 명시 (사용자 명시 요구 2026-06-07) */}
      {fixedColumns.map(c => (
        <FlexGridColumn
          key={c.key}
          binding={c.key}
          header={c.header}
          width={c.width ?? 100}
          align={c.align === 'L' ? 'left' : c.align === 'R' ? 'right' : 'center'}
          isReadOnly={c._inputEditType === 'S'}
          dataMap={dataMaps[c.key] ?? undefined}
        />
      ))}
      {/* dynamic cols — 3-row header 는 formatItem 에서 textContent 설정 */}
      {dynamicCols.dynamicColumns.map(c => (
        <FlexGridColumn
          key={c.key}
          binding={c.key}
          header={c.key}
          width={60}
          align='right'
          isReadOnly={c._inputEditType === 'S'}
        />
      ))}
    </FlexGrid>
  );
};
