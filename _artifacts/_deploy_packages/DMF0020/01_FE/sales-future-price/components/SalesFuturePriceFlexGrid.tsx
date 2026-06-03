import { FlexGrid, FlexGridColumn, FlexGridColumnGroup } from '@mescius/wijmo.react.grid';
import {
  AllowMerging,
  CellRange,
  CellType,
  MergeManager,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
  type GridPanel,
} from '@mescius/wijmo.grid';
import { toggleClass } from '@mescius/wijmo';
import { useEffect, type Ref } from 'react';

import { FROZEN_COL_COUNT, MAIN_COLUMNS } from '../sales-future-price.constants';
import type { FuturePriceRow, SpreadTitleDateRow } from '../sales-future-price.types';
import { buildHeaderTree } from '../hooks/useSalesFuturePriceExpression';
import { groupKeyOf } from '../utils/wideToLong';

import styles from '../SalesFuturePrice.module.scss';

interface Props {
  rows: FuturePriceRow[];
  titleDate: SpreadTitleDateRow[] | undefined;
  bucketType: 'W' | 'M';
  selectedGroupKey: string;
  gridRef: Ref<FlexGridType<FuturePriceRow>>;
  onSelectGroup: (groupKey: string) => void;
  onCellDoubleClick: (g: FlexGridType<FuturePriceRow>, row: number, col: number) => void;
}

// AS-IS .cs L515 `siMain.SmartColMerge()` 계층적 머지 (사용자 요구 2026-06-02 / 룰 12 §11.6)
//   - allowMerging=true column 의 cell 머지
//   - 좌측 모든 allowMerging column 도 같은 값일 때만 머지 (column-dependent)
class HierarchicalMergeManager extends MergeManager {
  getMergedRange(panel: GridPanel, r: number, c: number, clip: boolean = true): CellRange | null {
    if (panel.cellType !== CellType.Cell) {
      return super.getMergedRange(panel, r, c, clip);
    }
    const col = panel.columns[c];
    if (!col || !col.allowMerging) return null;

    const mergeColIdx: number[] = [];
    for (let i = 0; i <= c; i++) {
      if (panel.columns[i] && panel.columns[i].allowMerging) mergeColIdx.push(i);
    }
    if (mergeColIdx.length === 0) return null;

    const sameAcrossKeys = (rowA: number, rowB: number): boolean =>
      mergeColIdx.every(ci => {
        const a = panel.getCellData(rowA, ci, false);
        const b = panel.getCellData(rowB, ci, false);
        return a === b;
      });

    let r1 = r;
    let r2 = r;
    while (r1 > 0 && sameAcrossKeys(r1 - 1, r)) r1--;
    const rowCnt = panel.rows.length;
    while (r2 < rowCnt - 1 && sameAcrossKeys(r2 + 1, r)) r2++;

    if (r1 === r2) return null;
    return new CellRange(r1, c, r2, c);
  }
}

// AS-IS .cs L645/L673 SetSpreadHeaderSpan + L701/706 SetSpreadColumn (E1~E7) + L515 SmartColMerge
//   주요 변환:
//   - DefColumns 32 cols → FlexGrid <FlexGridColumn> (MAIN_COLUMNS 메타)
//   - 동적 시간축 (W_/M_) → buildHeaderTree → 3단 FlexGridColumnGroup
//   - ColumnHeaderSpan(0/1) → <FlexGridColumnGroup header="YYYY-MM"> > <header="Wxx"> 트리
//   - allowMerging Cells + HierarchicalMergeManager (As-Is SmartColMerge 동등)
//   - formatItem → cell coloring (룰 12 §11.7) + group 동시 선택 highlight
export const SalesFuturePriceFlexGrid = ({
  rows,
  titleDate,
  bucketType,
  selectedGroupKey,
  gridRef,
  onSelectGroup,
  onCellDoubleClick,
}: Props) => {
  const headerTree = buildHeaderTree(titleDate, bucketType);

  // FlexGrid initialize 시 1회만 (mergeManager + handlers 부착)
  // useEffect 로 selectedGroupKey 동적 변경 시에도 invalidate (재렌더 트리거)
  useEffect(() => {
    if (gridRef && 'current' in gridRef && gridRef.current) gridRef.current.invalidate();
  }, [selectedGroupKey, gridRef]);

  return (
    <div className={styles.gridContainer}>
      <FlexGrid
        className={styles.grid}
        initialized={(g: FlexGridType<FuturePriceRow>) => {
          if (gridRef && 'current' in gridRef) {
            (gridRef as { current: FlexGridType<FuturePriceRow> | null }).current = g;
          }

          // E7 — allowMerging Cells + HierarchicalMergeManager (As-Is SmartColMerge)
          g.allowMerging = AllowMerging.Cells;
          g.mergeManager = new HierarchicalMergeManager();

          // E9 — Cell edit ended → CRUD_TYPE='M' (DataModel.Changed 모사)
          g.cellEditEnded.addHandler((_, e) => {
            const dataItem = g.rows[e.row]?.dataItem as FuturePriceRow | undefined;
            if (!dataItem) return;
            if (dataItem.CRUD_TYPE !== 'I' && dataItem.CRUD_TYPE !== 'D') {
              dataItem.CRUD_TYPE = 'M';
            }
          });

          // 룰 12 §11.7 — formatItem cell coloring:
          //   _inputEditType='S'           → wj-cell-non-editable (#f1f4f3)
          //   _inputEditType='M'/'O'       → wj-cell-editable (#fff8cd)
          //   _inputEditType='IM'/'IO'+'I' → wj-cell-editable
          //   _ctrlType='FPModal'+조건     → wj-cell-popup (↗ 아이콘)
          //
          // + 그룹 동시 선택 — selectedGroupKey 와 같은 행 highlight
          g.formatItem.addHandler((_s, e: FormatItemEventArgs) => {
            if (e.panel.cellType !== CellType.Cell) return;
            const col = e.panel.columns[e.col];
            if (!col || !col.binding) return;
            const meta = MAIN_COLUMNS.find(c => c.key === col.binding);
            const dataItem = e.panel.rows[e.row]?.dataItem as FuturePriceRow | undefined;
            if (!dataItem) return;
            const isInsert = dataItem.CRUD_TYPE === 'I';

            // 동적 시간축 컬럼은 메타 없음 → 항상 editable
            if (!meta) {
              toggleClass(e.cell, 'wj-cell-editable', true);
            } else {
              const isEditable =
                meta._inputEditType === 'M' ||
                meta._inputEditType === 'O' ||
                ((meta._inputEditType === 'IM' || meta._inputEditType === 'IO') && isInsert);
              const isReadOnly =
                meta._inputEditType === 'S' ||
                ((meta._inputEditType === 'IM' || meta._inputEditType === 'IO') && !isInsert);
              const isPopup =
                meta._ctrlType === 'FPModal' &&
                ((meta._inputEditType === 'M') || isInsert);
              toggleClass(e.cell, 'wj-cell-editable', isEditable);
              toggleClass(e.cell, 'wj-cell-non-editable', isReadOnly);
              toggleClass(e.cell, 'wj-cell-popup', isPopup);
            }

            // E7 — 그룹 동시 선택 highlight
            if (selectedGroupKey && groupKeyOf(dataItem) === selectedGroupKey) {
              toggleClass(e.cell, 'selected-group', true);
            }
          });

          // 그룹 선택 (CellClick)
          g.selectionChanged.addHandler((_, e) => {
            const row = g.rows[e.row]?.dataItem as FuturePriceRow | undefined;
            if (row) onSelectGroup(groupKeyOf(row));
          });

          // dblClick (popup cell)
          g.itemDoubleClick.addHandler((_s, e) => {
            if (e.panel.cellType !== CellType.Cell) return;
            onCellDoubleClick(g, e.row, e.col);
          });
        }}
        itemsSource={rows}
        autoGenerateColumns={false}
        frozenColumns={FROZEN_COL_COUNT}
        allowSorting={true}
        style={{ height: '100%' }}
      >
        {/* 좌측 32 고정 컬럼 (MAIN_COLUMNS) */}
        {MAIN_COLUMNS.map(c => (
          <FlexGridColumn
            key={c.key}
            binding={c.key}
            header={c.header}
            width={c.width}
            align={c.align === 'C' ? 'center' : c.align === 'R' ? 'right' : 'left'}
            format={c.format}
            visible={c.visible !== false}
            isReadOnly={c._inputEditType === 'S' || c._ctrlType === 'FPModal'}
            allowMerging={c.merge ?? false}
          />
        ))}

        {/* 동적 시간축 컬럼 — 3단 헤더 (E3, E5, E6) */}
        {headerTree.map(ym => (
          <FlexGridColumnGroup key={ym.key} header={ym.label}>
            {ym.weeks.map(w => (
              <FlexGridColumnGroup key={w.key} header={w.label}>
                {w.days.map(d => (
                  <FlexGridColumn
                    key={d.binding}
                    binding={d.binding}
                    header={d.label}
                    width={90}
                    align='right'
                    format='n2'
                  />
                ))}
              </FlexGridColumnGroup>
            ))}
          </FlexGridColumnGroup>
        ))}
      </FlexGrid>
    </div>
  );
};
