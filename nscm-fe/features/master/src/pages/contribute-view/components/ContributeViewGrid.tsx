import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import type { FlexGrid as FlexGridType, FormatItemEventArgs, GridPanel } from '@mescius/wijmo.grid';
import { AllowMerging, CellRange, CellType, MergeManager, Row } from '@mescius/wijmo.grid';
import { toggleClass } from '@mescius/wijmo';
import { type RefObject, useEffect, useMemo, useRef } from 'react';

import { useTabProcQuery } from '@shared/hooks';

import { BASE_COLUMN_COUNT, MENU_ID, SHEETS } from '../contribute-view.constants';
import {
  buildColumnMeta,
  type ColumnMeta,
} from '../hooks/useContributeViewExpression';
import type { SalesViewRow, SpreadTitleRow } from '../types';
import { useContributeViewStore } from '../useContributeViewStore';

import styles from './ContributeViewGrid.module.scss';

interface Props {
  gridRef: RefObject<FlexGridType<SalesViewRow> | null>;
  data: SalesViewRow[];
}

// AS-IS DMF0043_Contribute_View.cs InitSpread + SetSpreadHeaderSpan
//
// 사용자 요구 (2026-06-01):
//   - 좌측 고정 (frozen): 년월(YYYYMM) ~ Biz(DM_BIZ_TYPE) 9 컬럼
//   - 동적: 2-row 헤더
//     * Row 0 (상단): 지역 (대만/중국-화남/.../합계) = LARGE_CLASS_LABEL_NAME
//     * Row 1 (하단): Commission/Markup = COLUMN_LABEL_NAME (leaf)
//   - readonly grid — AS-IS L342: siMain.LockColumn(0, Max, true)
//   - 룰 12 §11.5: frozenColumns = BASE_COLUMN_COUNT (= 9)
//   - 룰 27 §F: FlexGridColumnGroup JSX single-child 회피 — flat 컬럼 + HeaderMergeManager
export const ContributeViewGrid = ({ gridRef, data }: Props) => {
  const internalRef = useRef<FlexGridType<SalesViewRow> | null>(null);
  const columnMetaRef = useRef<ColumnMeta[]>([]);

  const titleFilter = useContributeViewStore(s => s.filters[SHEETS.MAIN_TITLE]);

  // AS-IS InitSpread: DMF0043_GET_SALES_LIST_SPREAD_TITLE
  const { data: titleData } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN_TITLE,
    filters: titleFilter,
    enabled: !!titleFilter,
  });

  // SP body 가 SORT_ORDER_NO 기준 정렬 + DISTINCT 처리됨 → FE dedup 불필요
  const titleRows = useMemo<SpreadTitleRow[]>(
    () => (titleData?.o_rc1 ?? []) as SpreadTitleRow[],
    [titleData]
  );

  // 첫 BASE_COLUMN_COUNT 개 = BASE (고정), 나머지 = dynamic (지역×Type)
  const columnMetas = useMemo<ColumnMeta[]>(
    () => buildColumnMeta(titleRows, BASE_COLUMN_COUNT),
    [titleRows]
  );

  useEffect(() => {
    columnMetaRef.current = columnMetas;
    internalRef.current?.invalidate();
  }, [columnMetas]);

  const baseColumns = useMemo<ColumnMeta[]>(
    () => columnMetas.filter(m => m.isBase),
    [columnMetas]
  );
  const dynamicColumns = useMemo<ColumnMeta[]>(
    () => columnMetas.filter(m => !m.isBase && !m.isHidden),
    [columnMetas]
  );

  return (
    <FlexGrid
      initialized={(g: FlexGridType<SalesViewRow>) => {
        internalRef.current = g;
        if (gridRef && 'current' in gridRef) {
          (gridRef as { current: FlexGridType<SalesViewRow> | null }).current = g;
        }
        g.isReadOnly = true;
        g.allowMerging = AllowMerging.ColumnHeaders;

        // 룰 12 §11.5: BASE 컬럼 좌측 고정
        g.frozenColumns = BASE_COLUMN_COUNT;

        // 2-row 헤더 (Row 0 = 지역, Row 1 = Commission/Markup)
        while (g.columnHeaders.rows.length < 2) {
          g.columnHeaders.rows.unshift(new Row());
        }

        // Custom merge manager — BASE 컬럼 row 0/1 세로 머지 + 동적 컬럼 row 0 (지역) 가로 머지
        const dynStart = BASE_COLUMN_COUNT;
        class HeaderMergeManager extends MergeManager {
          getMergedRange(panel: GridPanel, r: number, c: number, clip = true): CellRange | null {
            if (panel.cellType === CellType.ColumnHeader) {
              // BASE 컬럼: row 0/1 세로 머지
              if (c < dynStart) {
                return new CellRange(0, c, 1, c);
              }
              // 동적 row 0: 같은 LARGE_CLASS_LABEL_NAME 인접 컬럼 가로 머지
              if (r === 0) {
                const metas = columnMetaRef.current;
                const idx = c;
                if (idx >= metas.length) return null;
                const large = metas[idx].large;
                if (!large) return null;
                let left = idx;
                while (left > dynStart && metas[left - 1].large === large && !metas[left - 1].isBase) left--;
                let right = idx;
                while (right < metas.length - 1 && metas[right + 1].large === large && !metas[right + 1].isBase) right++;
                if (left === right) return null;
                return new CellRange(0, left, 0, right);
              }
            }
            return super.getMergedRange(panel, r, c, clip);
          }
        }
        g.mergeManager = new HeaderMergeManager();

        // formatItem — row 0/1 별 텍스트 그리기 + 룰 12 §11.7 (2026-06-02) cell coloring
        // 조회 전용 화면 — 모든 cell 회색 (wj-cell-non-editable)
        g.formatItem.addHandler((_s, e: FormatItemEventArgs) => {
          if (e.panel.cellType === CellType.ColumnHeader) {
            const col = e.panel.columns[e.col];
            if (!col) return;
            const meta = columnMetaRef.current.find(m => m.binding === col.binding);
            if (!meta) return;
            if (meta.isBase) {
              e.cell.textContent = e.row === 0 ? meta.leaf : '';
            } else {
              if (e.row === 0) e.cell.textContent = meta.large;
              else if (e.row === 1) e.cell.textContent = meta.leaf;
            }
            return;
          }
          if (e.panel.cellType === CellType.Cell) {
            toggleClass(e.cell, 'wj-cell-non-editable', true);
          }
        });
      }}
      itemsSource={data}
      autoGenerateColumns={false}
      className={styles.grid}
    >
      {baseColumns.map(c => (
        <FlexGridColumn
          key={c.binding}
          binding={c.binding}
          header={c.leaf}
          width={Math.max(c.width, 110)}
          isReadOnly
        />
      ))}
      {dynamicColumns.map(c => (
        <FlexGridColumn
          key={c.binding}
          binding={c.binding}
          header={c.leaf}
          width={c.width}
          align='right'
          format='n0'
          isReadOnly
        />
      ))}
    </FlexGrid>
  );
};
