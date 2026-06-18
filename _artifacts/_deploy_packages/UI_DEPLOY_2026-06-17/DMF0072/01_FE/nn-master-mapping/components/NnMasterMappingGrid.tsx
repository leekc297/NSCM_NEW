import { type CollectionView, toggleClass } from '@mescius/wijmo';
import {
  AllowMerging,
  CellRange,
  CellType,
  MergeManager,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
  type GridPanel,
  type CellRangeEventArgs,
} from '@mescius/wijmo.grid';
import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import { type RefObject, useMemo, useRef } from 'react';

import { MAIN_COLUMNS, SHEETS } from '../nn-master-mapping.constants';
import { useNnMasterMappingStore } from '../useNnMasterMappingStore';

// 신규 행 type — 기존 SP 결과와 합쳐 grid itemsSource 로 사용 (As-Is L538-602 InsertRow 결과)
export type NnRow = Record<string, unknown> & { CRUD_TYPE?: 'I' | 'M' | 'D' };

// As-Is .cs L515 `siMain.SmartColMerge()` 동작 모사:
// "자신의 column 이 같은 값이어도, 좌측의 모든 allowMerging column 도 같은 값일 때만 머지"
class HierarchicalMergeManager extends MergeManager {
  getMergedRange(panel: GridPanel, r: number, c: number, clip: boolean = true): CellRange | null {
    if (panel.cellType !== CellType.Cell) {
      return super.getMergedRange(panel, r, c, clip);
    }
    const col = panel.columns[c];
    if (!col || (col && !col.allowMerging)) return null;

    const mergeColIdx: number[] = [];
    for (let i = 0; i <= c; i++) {
      if (panel.columns[i]?.allowMerging) mergeColIdx.push(i);
    }
    if (mergeColIdx.length === 0) return null;

    const sameAcrossKeys = (rowA: number, rowB: number): boolean =>
      mergeColIdx.every(ci => {
        const a: unknown = panel.getCellData(rowA, ci, false);
        const b: unknown = panel.getCellData(rowB, ci, false);
        return a === b;
      });

    // ⭐ viewport row 제한 (wijmo-merge-sticky-content.md v4 표준, 2026-06-18 적용).
    //   머지 그룹 첫 row 가 viewport 위로 사라지면 → 새 viewport 첫 row 에 content 자동 표시.
    const minRow = panel.viewRange.row;
    const maxRow = panel.viewRange.row2;
    let r1 = r;
    let r2 = r;
    while (r1 > minRow && sameAcrossKeys(r1 - 1, r)) r1--;
    while (r2 < maxRow && sameAcrossKeys(r2 + 1, r)) r2++;

    if (r1 === r2) return null;
    return new CellRange(r1, c, r2, c);
  }
}

interface Props {
  gridRef: RefObject<FlexGridType<NnRow> | null>;
  rows: NnRow[];
  onCellDoubleClick: (g: FlexGridType<NnRow>, e: { row: number; col: number }) => void;
}

// ⭐ 2026-06-17 revert + 사용자 정정 요구 반영:
//   - HierarchicalMergeManager 복원 (cell merge 적용 — 다른 화면 grid 와 유사 시각)
//   - frozenColumns/frozenRows 명시적 0 (cell 고정 해제)
//   - DataGrid wrapper 사용 시 BE 메타 미등록 환경에서 hang 사고 (조회 대기 중 무한)
//     → FlexGrid 직접 사용 + sticky header / scroll bar 는 wijmo default 동작에 의존
export const NnMasterMappingGrid = ({ gridRef, rows, onCellDoubleClick }: Props) => {
  const oldValueRef = useRef<unknown>(null);
  const dblClickRef = useRef(onCellDoubleClick);
  dblClickRef.current = onCellDoubleClick;

  // ⭐ admin SCM_MST_SHEET_COLUMNS 동적 fetch.
  //   transitional fallback: staticColumns 0건 시 MAIN_COLUMNS 그대로 사용.
  const staticColumns = useNnMasterMappingStore(s => s.staticColumns[SHEETS.MAIN]);

  // 2026-06-17 사용자 보고 — column 안 보임 사고 fix.
  //   기존 filter 패턴은 BE 메타 매칭 0건 시 빈 array → grid column 0.
  //   변경: MAIN_COLUMNS 항상 표시 + admin 메타 있으면 width/header 만 override.
  //   admin visible=N 결정 반영은 후속 작업 (메타 등록 완료 후).
  const visibleColumns = useMemo(() => {
    return MAIN_COLUMNS.map(c => {
      const meta = staticColumns?.find(s => {
        const sAny = s as { colNm?: string; binding?: string };
        const colNm = sAny.colNm ?? sAny.binding;
        return colNm === c.key;
      });
      if (!meta) return c;
      const width = (meta as { width?: number }).width ?? c.width;
      const header = (meta as { header?: string }).header ?? c.header;
      return { ...c, width, header };
    });
  }, [staticColumns]);

  return (
    <FlexGrid
      style={{ height: '100%', width: '100%' }}
      initialized={(g: FlexGridType<Record<string, unknown>>) => {
        if (gridRef && 'current' in gridRef) {
          (gridRef as { current: FlexGridType<NnRow> | null }).current = g as FlexGridType<NnRow>;
        }
        // Cell merge (As-Is SmartColMerge) — column 별 allowMerging=true 설정된 컬럼만 머지
        g.allowMerging = AllowMerging.Cells;
        g.mergeManager = new HierarchicalMergeManager();
        // Cell 고정 (frozen columns) 해제
        g.frozenColumns = 0;
        g.frozenRows = 0;
        // ⭐ viewport sticky — scroll 시 머지 재계산 (wijmo-merge-sticky-content.md v4, 2026-06-18)
        g.scrollPositionChanged.addHandler(() => g.invalidate());

        const cv = g.collectionView as CollectionView;
        if (cv) {
          cv.trackChanges = true;
        }

        // 룰 12 §11.7 — column meta 기반 cell coloring (inputTpCd 별)
        g.formatItem.addHandler((_s, e: FormatItemEventArgs) => {
          if (e.panel.cellType !== CellType.Cell) return;
          const col = e.panel.columns[e.col];
          if (!col || (col && !col.binding)) return;
          const meta = MAIN_COLUMNS.find(c => c.key === col.binding);
          if (!meta) return;

          const dataItem = e.panel.rows[e.row]?.dataItem as NnRow | undefined;
          const isInsert = dataItem?.CRUD_TYPE === 'I';

          const isEditable =
            meta._inputEditType === 'M' ||
            meta._inputEditType === 'O' ||
            ((meta._inputEditType === 'IM' || meta._inputEditType === 'IO') && isInsert);
          const isReadOnly =
            meta._inputEditType === 'S' ||
            ((meta._inputEditType === 'IM' || meta._inputEditType === 'IO') && !isInsert);
          const isPopup =
            meta._ctrlType === 'FPModal' && (meta._inputEditType === 'M' || isInsert);

          toggleClass(e.cell, 'wj-cell-editable', isEditable);
          toggleClass(e.cell, 'wj-cell-non-editable', isReadOnly);
          toggleClass(e.cell, 'wj-cell-popup', isPopup);
        });

        g.beginningEdit.addHandler((_s, e: CellRangeEventArgs) => {
          oldValueRef.current = _s.getCellData(e.row, e.col, false);
        });

        g.cellEditEnded.addHandler((_s, e: CellRangeEventArgs) => {
          if (_s.columns[e.col].binding === 'CRUD_TYPE') return;
          const newValue: unknown = _s.getCellData(e.row, e.col, false);
          if (oldValueRef.current !== newValue) {
            const rowDataItem = _s.rows[e.row].dataItem as NnRow;
            if (rowDataItem && !rowDataItem.CRUD_TYPE) {
              rowDataItem.CRUD_TYPE = 'M';
              _s.invalidate();
            }
          }
        });

        // dblClick popup handler
        const dblG = (
          g as unknown as {
            itemDoubleClick?: {
              addHandler?: (
                fn: (
                  s: unknown,
                  e: { panel: { cellType: CellType }; row: number; col: number }
                ) => void
              ) => void;
            };
          }
        ).itemDoubleClick;
        if (dblG && typeof dblG.addHandler === 'function') {
          dblG.addHandler((_s, e) => {
            if (e.panel.cellType !== CellType.Cell) return;
            dblClickRef.current(g as FlexGridType<NnRow>, { row: e.row, col: e.col });
          });
        } else if (g.hostElement) {
          g.hostElement.addEventListener('dblclick', () => {
            const sel = g.selection;
            if (sel && sel.row >= 0 && sel.col >= 0) {
              dblClickRef.current(g as FlexGridType<NnRow>, { row: sel.row, col: sel.col });
            }
          });
        }
      }}
      itemsSource={rows}
      autoGenerateColumns={false}
    >
      {visibleColumns.map(c => (
        <FlexGridColumn
          key={c.key}
          binding={c.key}
          header={c.header}
          width={c.width}
          isReadOnly={c._inputEditType === 'S' || c._ctrlType === 'FPModal'}
          allowMerging={c.merge ?? false}
        />
      ))}
    </FlexGrid>
  );
};
