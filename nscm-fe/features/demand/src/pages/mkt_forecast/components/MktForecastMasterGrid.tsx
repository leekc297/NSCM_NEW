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

import type { RawFlexGridColumnConfig } from '@foundation/models';

import { FROZEN_COL_COUNT, MAIN_COLUMNS, type MainColumnMeta } from '../mkt-forecast-master.constants';
import { useMktForecastDynamicColumns } from '../hooks/useMktForecastDynamicColumns';
import type { MeasureMeta, MktFcstRow, SearchCondition } from '../mkt-forecast-master.types';
import { useMktForecastMasterStore } from '../useMktForecastMasterStore';
import { getMonthWeekIndex } from '../utils/bucketDate';
import { getDivisionVisibility } from '../utils/divisionBranch';

export interface ComboItem { CODE: string; NAME: string }

// ⭐ master hook §11 — FlexGrid 직접 사용 시 통합 column meta (admin 동적 + MAIN_COLUMNS fallback)
interface MergedColumnMeta {
  binding: string;
  header: string;
  width: number;
  align: 'L' | 'R' | 'C';
  visible: boolean;
  fixed: boolean;
  scale?: number;
  _ctrlType?: MainColumnMeta['_ctrlType'];
  _inputEditType?: MainColumnMeta['_inputEditType'];
  _modalKey?: string;
  _comboKey?: string;
}

interface Props {
  rows: MktFcstRow[];
  gridRef: React.RefObject<unknown>;
  gridFilterRef?: React.RefObject<FlexGridFilter | undefined>;
  divisionId: string;
  searchCondition?: SearchCondition;
  onCellEditEnded?: (sender: unknown, e: { row: number; col: number }) => void;
  comboData?: Record<string, ComboItem[]>;
  onPopupCellDblClick?: (row: MktFcstRow, modalKey: string, binding: string) => void;
  // ⭐ master hook §2.5 / §11 — admin SYS0004 UI Category Setup 동적 메타
  staticColumns?: RawFlexGridColumnConfig[];
  staticMeasures?: MeasureMeta[];
  // ⭐ 2026-06-16 — 조회조건 4 checkbox (Sum / Color / Qty / Cell Qty) 보강
  sumYn?: boolean;
  colorYn?: boolean;
}

const NO_MERGE_KEYS = new Set(['MEASURE', 'YYYYMMDD', 'QTY', 'EDIT_FLAG']);
const COL_META: Map<string, MainColumnMeta> = new Map(MAIN_COLUMNS.map(c => [c.key, c]));

// ⭐ 2026-06-18 사용자 명시 — Bucket 3종 다단 헤더 (Daily/Weekly: 3단 / Monthly: 2단)
//   - Daily   : row 0=YYYY-MM / row 1=W{monthWeekIdx} / row 2=DD
//   - Weekly  : row 0=YYYY-MM / row 1=W{monthWeekIdx} / row 2=Sum
//   - Monthly : row 0=YYYY-MM / row 1=Sum / row 2=(빈)
//   - mwi : 월 안 주차 인덱스 (월 변경 시 별도 — 같은 ym + 같은 mwi 일 때만 row 1 머지)
const getDynKey = (binding: string): { kind: 'D' | 'W' | 'M' | ''; ym: string; dd: string; mwi: number } => {
  if (binding.startsWith('D_') && binding.length === 10) {
    return { kind: 'D', ym: `${binding.slice(2, 6)}-${binding.slice(6, 8)}`, dd: binding.slice(8, 10), mwi: getMonthWeekIndex(binding.slice(2, 10)) };
  }
  if (binding.startsWith('W_') && binding.length === 10) {
    return { kind: 'W', ym: `${binding.slice(2, 6)}-${binding.slice(6, 8)}`, dd: binding.slice(8, 10), mwi: getMonthWeekIndex(binding.slice(2, 10)) };
  }
  if (binding.startsWith('M_') && binding.length === 8) {
    return { kind: 'M', ym: `${binding.slice(2, 6)}-${binding.slice(6, 8)}`, dd: '', mwi: 0 };
  }
  return { kind: '', ym: '', dd: '', mwi: 0 };
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
  staticColumns,
  staticMeasures,
  sumYn = false,
  colorYn = false,
}: Props) => {
  void staticMeasures; // staticMeasures 는 부모 MeasureSelectModal 에서 사용 — Grid 는 binding 만 처리
  const dynamicCols = useMktForecastDynamicColumns(
    searchCondition ?? ({ divisionId, bucketType: 'W', startYyyymmdd: '', endYyyymmdd: '' } as never),
  );

  // FlexGrid instance ref — beginningEdit/mouseDoubleClick 등 cell handler 가 panel 접근에 사용 (use-before-define 방지)
  const gridInstanceRef = useRef<FlexGridType<MktFcstRow> | null>(null);

  const collectionView = useMemo(() => new CollectionView(rows), [rows]);

  // ⭐ master hook §11.1 Step 2 — 통합 column meta (staticColumns 우선, MAIN_COLUMNS fallback)
  //   admin SYS0004 변경 시 즉시 반영. BE 실패 / 메타 미등록 시 MAIN_COLUMNS 으로 안전 fallback.
  //
  // ⭐ 2026-06-16 Division 분기 (사용자 신고 5 컬럼 중복 fix):
  //   DB SCM_MST_SHEET_COLUMNS 에는 *40 (Div 40 Mobility 전용) + base (Div 81/82 등) 쌍이
  //   모두 VISIBLE='Y' 로 등록되어 있어, divisionBranch 통과 없이 staticColumns 그대로 fixedColumns
  //   에 들어가면 DIVISION_ID/END_CUSTOMER/SCM_SITE_ID/ITEM_ID 4쌍이 동시 렌더 → 시각적 중복.
  //   isVisibleByDivision 로 한 쪽만 표시.
  const mergedColumns = useMemo<MergedColumnMeta[]>(() => {
    const vis = getDivisionVisibility(divisionId);
    const isVisibleByDivision = (binding: string): boolean => {
      if (binding.endsWith('40')) return vis.showDivision40Cols;
      if (binding === 'DIVISION_ID' || binding === 'END_CUSTOMER'
        || binding === 'SCM_SITE_ID' || binding === 'ITEM_ID') {
        return !vis.showDivision40Cols;
      }
      if (binding === 'CELL_TYPE') return vis.showCellType;
      if (binding === 'VMI_YN') return vis.showEssNewFlag;
      return true;
    };

    if (!staticColumns || staticColumns.length === 0) {
      return MAIN_COLUMNS.map<MergedColumnMeta>(c => ({
        binding: c.key,
        header: c.header,
        width: c.width ?? 100,
        align: c.align ?? 'C',
        visible: (c.visible !== false) && isVisibleByDivision(c.key),
        fixed: c.freeze === true,
        _ctrlType: c._ctrlType,
        _inputEditType: c._inputEditType,
        _modalKey: c._modalKey,
        _comboKey: c._comboKey,
      }));
    }
    return staticColumns.map<MergedColumnMeta>(sc => {
      const fb = MAIN_COLUMNS.find(m => m.key === sc.colNm);
      return {
        binding: sc.colNm,
        header: sc.colLblNm || fb?.header || sc.colNm,
        width: sc.colWth ?? fb?.width ?? 100,
        align: sc.horzAlgnCd ?? fb?.align ?? 'C',
        visible: (sc.visible !== false) && isVisibleByDivision(sc.colNm),
        fixed: sc.fixed === true,
        scale: sc.scale,
        _ctrlType: (sc.cellCtrlObjTpCd as MainColumnMeta['_ctrlType']) ?? fb?._ctrlType,
        _inputEditType: (sc.inputTpCd as MainColumnMeta['_inputEditType']) ?? fb?._inputEditType,
        // ⭐ 2026-06-16 — combo / modal key 표준 위치 = CELL_COMBO_DATA_TYPE (cellCboDataTp)
        //   메모리 룰 feedback_column_lookup_meta_standard.md: ATTRIBUTE 위치 절대 금지
        //   FPComboBox → SCM_ADM_CMBO_SQL_M SQL_ID / FPModal → popup key 둘 다 cellCboDataTp 사용
        _modalKey: sc.cellCboDataTp ?? fb?._modalKey,
        _comboKey: sc.cellCboDataTp ?? fb?._comboKey,
      };
    });
  }, [staticColumns, divisionId]);

  // ⭐ master hook §11.1 Step 3 — visible=true 만 렌더링 (admin VISIBLE_FLAG='N' 즉시 반영)
  //   + grid-column-setting-popup-pattern.md (#58) §4 — ColumnSettingModal 사용자 hidden 적용
  const visibleBaseColumnsList = useMktForecastMasterStore(s => s.visibleBaseColumns);
  const fixedColumns = useMemo(() => {
    const base = mergedColumns.filter(c => c.visible);
    if (visibleBaseColumnsList.length === 0) return base;
    const allowed = new Set(visibleBaseColumnsList);
    return base.filter(c => allowed.has(c.binding));
  }, [mergedColumns, visibleBaseColumnsList]);

  // HierarchicalMergeManager — Data Cell + ColumnHeader 머지
  const mergeManager = useMemo(() => {
    const fixedBindings = fixedColumns.map(c => c.binding);

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
          // ⭐ viewport row 제한 (wijmo-merge-sticky-content.md v4, 2026-06-18 보강)
          //   기존: row 만 viewRange 측 이동 (vrTop) — row2 누락
          //   변경: row + row2 양쪽 viewport 제한 + DMF0020/DMF0043 표준 양식 통일
          const minRow = panel.viewRange.row;
          const maxRow = panel.viewRange.row2;
          let r1 = r, r2 = r;
          while (r1 > minRow && sameRow(r1 - 1, r)) r1--;
          while (r2 < maxRow && sameRow(r2 + 1, r)) r2++;
          if (r1 === r2) return null;
          return new CellRange(r1, c, r2, c);
        }

        if (panel.cellType === CellType.ColumnHeader) {
          if (fixedBindings.includes(binding)) return new CellRange(0, c, 2, c);
          const dyn = getDynKey(binding);
          // ⭐ 2026-06-18 사용자 명시 — Bucket 별 다단 헤더 머지 logic
          //   Daily/Weekly: row 0 = 같은 YYYY-MM 머지 / row 1 = 같은 ym AND 같은 mwi 머지 (월 변경 시 별도)
          //   Monthly: 머지 없음 (각 leaf 가 자기 자신 1 cell — row 0=ym / row 1=Sum)
          if (dyn.kind === 'D' || dyn.kind === 'W') {
            if (r === 0) {
              let c1 = c, c2 = c;
              while (c1 > 0) {
                const p = getDynKey(panel.columns[c1 - 1].binding ?? '');
                if ((p.kind === 'D' || p.kind === 'W') && p.ym === dyn.ym) c1--; else break;
              }
              while (c2 < panel.columns.length - 1) {
                const n = getDynKey(panel.columns[c2 + 1].binding ?? '');
                if ((n.kind === 'D' || n.kind === 'W') && n.ym === dyn.ym) c2++; else break;
              }
              return new CellRange(0, c1, 0, c2);
            }
            if (r === 1) {
              let c1 = c, c2 = c;
              while (c1 > 0) {
                const p = getDynKey(panel.columns[c1 - 1].binding ?? '');
                if ((p.kind === 'D' || p.kind === 'W') && p.ym === dyn.ym && p.mwi === dyn.mwi) c1--; else break;
              }
              while (c2 < panel.columns.length - 1) {
                const n = getDynKey(panel.columns[c2 + 1].binding ?? '');
                if ((n.kind === 'D' || n.kind === 'W') && n.ym === dyn.ym && n.mwi === dyn.mwi) c2++; else break;
              }
              return new CellRange(1, c1, 1, c2);
            }
          }
          // Monthly — 머지 없음 (단일 leaf cell)
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
        // ⭐ 2026-06-18 사용자 명시 — Bucket 3종 다단 헤더 textContent
        //   Daily   : row 0=YYYY-MM / row 1=W{mwi} / row 2=DD
        //   Weekly  : row 0=YYYY-MM / row 1=W{mwi} / row 2=Sum
        //   Monthly : row 0=YYYY-MM / row 1=Sum   / row 2=(빈)
        if (e.row === 0) {
          e.cell.textContent = dyn.ym;
        } else if (e.row === 1) {
          if (dyn.kind === 'M') e.cell.textContent = 'Sum';
          else e.cell.textContent = `W${dyn.mwi}`;
        } else if (e.row === 2) {
          if (dyn.kind === 'D') e.cell.textContent = dyn.dd;
          else if (dyn.kind === 'W') e.cell.textContent = 'Sum';
          else e.cell.textContent = '';
        }
        (e.cell as HTMLElement).style.textAlign = 'center';
      } else if (fixedColumns.some(c => c.binding === binding)) {
        // fixed col — mergeManager 가 row 0-2 머지. row 0 의 cell 만 표시
        //   ⭐ master hook §11 — admin SYS0004 COLUMN_LABEL_NAME (header) 우선, MAIN_COLUMNS fallback
        const merged = fixedColumns.find(c => c.binding === binding);
        e.cell.textContent = merged?.header ?? COL_META.get(binding)?.header ?? binding;
        (e.cell as HTMLElement).style.textAlign = 'center';
      }
      return;
    }

    if (e.panel.cellType !== CellType.Cell) return;
    const item = (e.panel.rows[e.row] as unknown as { dataItem?: Record<string, string> })?.dataItem;
    const isNewRow = String(item?.EDIT_FLAG ?? '') === 'I';

    // ⭐ 2026-06-16 hook wijmo-merge-sticky-content — fixed col vertical merge cell content sticky
    //   merge cell topmost row 가 viewport 위로 나가도 현재 visible row 위치에 텍스트 표시.
    //   매 render 시 wrap 재생성 — wijmo 가 cell.textContent 재설정 시 wrap 사라지므로 항상 재구성.
    if (fixedColumns.some(c => c.binding === binding)) {
      const text = e.cell.textContent ?? '';
      if (text) {
        e.cell.textContent = '';
        const wrap = document.createElement('div');
        wrap.className = 'merge-content';
        wrap.textContent = text;
        wrap.style.cssText = 'padding-top:4px;text-align:center;will-change:transform;';
        e.cell.appendChild(wrap);
        (e.cell as HTMLElement).style.verticalAlign = 'top';
        (e.cell as HTMLElement).style.padding = '0';
      }
    }

    // SUM_TOTAL cell — 합계 column 강조 (옅은 청색)
    if (binding === 'SUM_TOTAL') {
      e.cell.style.backgroundColor = '#e3f2fd';
      e.cell.style.fontWeight = '600';
      return;
    }

    // dynamic cell coloring (D_/W_/M_) — 수정 가능 measure 는 colorYn 무관 항상 노란색
    //   (사용자 명시 2026-06-16 — 수정 가능 cell 시각 표시는 의무, AS-IS 와 동등)
    //   그 외 cell: colorYn=true 시 회색 / colorYn=false 시 흰색 (구분 표시 토글)
    if (binding.startsWith('D_') || binding.startsWith('W_') || binding.startsWith('M_')) {
      const measure = String(item?.MEASURE ?? '');
      const colIsEditable = col.isReadOnly === false;
      const measureIsEditable = measure === 'MKT_FCST';
      if (colIsEditable && measureIsEditable) {
        e.cell.style.backgroundColor = '#fff8cd';   // 수정 가능 — 항상 표시
      } else if (colorYn) {
        e.cell.style.backgroundColor = '#f1f4f3';   // 그 외 + colorYn=true → 회색
      } else {
        e.cell.style.backgroundColor = '';          // 그 외 + colorYn=false → 흰색
      }
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
  }, [dataMaps, mergeManager, fixedColumns, dynamicCols.dynamicColumns, sumYn, colorYn]);

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

        // ⭐ 2026-06-16 — getBoundingClientRect 으로 viewport 안 cell 위치 정확 계산.
        //   wijmo cell.offsetTop 은 row container 안의 offset → 절대 viewport 측 mismatch.
        const adjustMergedContent = () => {
          const root = g.cells.hostElement as HTMLElement | null;
          if (!root) return;
          const cellsRoot = (root.querySelector('.wj-cells') as HTMLElement | null) ?? root;
          const cellsRect = cellsRoot.getBoundingClientRect();
          const viewportTop = cellsRect.top;
          const viewportBottom = cellsRect.bottom;
          const lineH = 22;
          root.querySelectorAll<HTMLElement>('.wj-cell .merge-content').forEach(div => {
            const cellEl = div.parentElement as HTMLElement | null;
            if (!cellEl) return;
            const cellRect = cellEl.getBoundingClientRect();
            const cellH = cellRect.height;
            if (cellRect.top < viewportTop && cellRect.bottom > viewportTop) {
              let offset = viewportTop - cellRect.top;
              const maxOffset = cellH - lineH;
              if (offset > maxOffset) offset = maxOffset;
              const visibleBottom = Math.min(cellRect.bottom, viewportBottom);
              const visibleH = visibleBottom - viewportTop;
              if (visibleH < lineH) offset = Math.max(0, visibleH - lineH);
              div.style.transform = `translateY(${offset}px)`;
            } else {
              div.style.transform = 'translateY(0)';
            }
          });
        };
        g.scrollPositionChanged.addHandler(adjustMergedContent);
        g.updatedView.addHandler(adjustMergedContent);
        // ⭐ 2026-06-16 sticky merge — scroll 시 mergeManager 측 시작 row 재계산 위해 invalidate
        g.scrollPositionChanged.addHandler(() => { g.invalidate(); });
      }}
    >
      {/* fixed cols — JSX FlexGridColumn 평면 + dataMap prop 직접 명시 (사용자 명시 요구 2026-06-07)
            ⭐ master hook §11.1 Step 3 — fixedColumns(=mergedColumns.filter(visible)) 사용
            admin SYS0004 의 colLblNm/colWth/horzAlgnCd/inputTpCd 변경이 자동 반영. */}
      {fixedColumns.map(c => (
        <FlexGridColumn
          key={c.binding}
          binding={c.binding}
          header={c.header}
          width={c.width}
          align={c.align === 'L' ? 'left' : c.align === 'R' ? 'right' : 'center'}
          isReadOnly={c._inputEditType === 'S'}
          dataMap={dataMaps[c.binding] ?? undefined}
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
      {/* ⭐ 2026-06-16 — Sum 컬럼 (AS-IS chkSum) — sumYn=true 시 우측 끝 합계 컬럼 추가 */}
      {sumYn && (
        <FlexGridColumn
          key='SUM_TOTAL'
          binding='SUM_TOTAL'
          header='Sum'
          width={100}
          align='right'
          isReadOnly
          format='n0'
        />
      )}
    </FlexGrid>
  );
};
