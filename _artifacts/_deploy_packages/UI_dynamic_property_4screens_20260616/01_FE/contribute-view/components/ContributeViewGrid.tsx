import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import type { FlexGrid as FlexGridType, FormatItemEventArgs, GridPanel } from '@mescius/wijmo.grid';
import { AllowMerging, CellRange, CellType, MergeManager, Row } from '@mescius/wijmo.grid';
import { toggleClass } from '@mescius/wijmo';
import { type RefObject, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
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
  // ⭐ UI 동적 속성관리 (master hook §4) — admin SYS0004 메타 (BASE 컬럼 visible/width/label override)
  staticColumns?: RawFlexGridColumnConfig[];
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
export const ContributeViewGrid = ({ gridRef, data, staticColumns }: Props) => {
  const internalRef = useRef<FlexGridType<SalesViewRow> | null>(null);
  const columnMetaRef = useRef<ColumnMeta[]>([]);

  const titleFilter = useContributeViewStore(s => s.filters[SHEETS.MAIN_TITLE]);

  // AS-IS InitSpread: DMF0043_GET_SALES_LIST_SPREAD_TITLE
  const { data: titleData } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN_TITLE,
    tabId: MENU_ID,
    filters: titleFilter,
    enabled: !!titleFilter,
  });

  // SP body 가 SORT_ORDER_NO 기준 정렬 + DISTINCT 처리됨 → FE dedup 불필요
  const titleRows = useMemo<SpreadTitleRow[]>(
    () => (titleData?.o_rc1 ?? []) as unknown as SpreadTitleRow[],
    [titleData]
  );

  // 첫 BASE_COLUMN_COUNT 개 = BASE (고정), 나머지 = dynamic (지역×Type)
  const columnMetas = useMemo<ColumnMeta[]>(
    () => buildColumnMeta(titleRows, BASE_COLUMN_COUNT),
    [titleRows]
  );

  useEffect(() => {
    columnMetaRef.current = columnMetas;
    const g = internalRef.current;
    // Wijmo refresh() 가 내부 finishEditing() 을 호출하는데, edit cycle 중간이면
    // null 접근으로 폭발. read-only grid 라도 발생 가능 (rAF 로 deferral).
    if (g && g.hostElement && g.hostElement.isConnected) {
      requestAnimationFrame(() => {
        try {
          g.invalidate();
        } catch {
          /* Wijmo internal refresh timing — safe to ignore */
        }
      });
    }
  }, [columnMetas]);

  // ⭐ master hook §4 — admin 메타 (visible/width/label) override + buildColumnMeta fallback
  const baseColumns = useMemo<ColumnMeta[]>(() => {
    const base = columnMetas.filter(m => m.isBase);
    if (!staticColumns || staticColumns.length === 0) return base;
    return base
      .map(c => {
        const sc = staticColumns.find(s => s.colNm === c.binding);
        if (!sc) return c;
        return {
          ...c,
          leaf: sc.colLblNm || c.leaf,
          width: sc.colWth ?? c.width,
          isHidden: sc.visible === false,
        };
      })
      .filter(c => !c.isHidden);
  }, [columnMetas, staticColumns]);
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
        // 사용자 요구 (2026-06-11): BASE 9 컬럼 (YYYYMM~DM_BIZ_TYPE) 좌측-누적 cell 머지
        // → ColumnHeaders + Cells 모두 머지 활성
        g.allowMerging = AllowMerging.ColumnHeaders | AllowMerging.Cells;

        // 룰 12 §11.5: BASE 컬럼 좌측 고정
        g.frozenColumns = BASE_COLUMN_COUNT;

        // 2-row 헤더 (Row 0 = 지역, Row 1 = Commission/Markup)
        while (g.columnHeaders.rows.length < 2) {
          g.columnHeaders.rows.unshift(new Row());
        }

        // Custom merge manager:
        //   - ColumnHeader: BASE 컬럼 row 0/1 세로 머지 + 동적 컬럼 row 0 (지역) 가로 머지
        //   - Cell: BASE 9 컬럼 (YYYYMM~DM_BIZ_TYPE) — 좌측-누적 cell 세로 머지 (DMF0072/DMF0043 패턴)
        //     자신 컬럼 단독이 아닌 YYYYMM 부터 자신까지 모든 컬럼 값 동일 row 만 머지
        const dynStart = BASE_COLUMN_COUNT;
        class HierarchicalMergeManager extends MergeManager {
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
              return null;
            }
            // Cell hierarchical merge — BASE 9 컬럼 만 대상
            if (panel.cellType === CellType.Cell) {
              if (c >= dynStart) return null; // 동적 컬럼은 머지 X
              const col = panel.columns[c];
              if (!col || !col.allowMerging) return null;
              // 좌측 0..c 모두 allowMerging + 값 동일 row 끼리 세로 머지
              const sameAcrossKeys = (rowA: number, rowB: number): boolean => {
                for (let ci = 0; ci <= c; ci++) {
                  if (!panel.columns[ci]?.allowMerging) continue;
                  const a: unknown = panel.getCellData(rowA, ci, false);
                  const b: unknown = panel.getCellData(rowB, ci, false);
                  if (a !== b) return false;
                }
                return true;
              };
              let r1 = r;
              let r2 = r;
              while (r1 > 0 && sameAcrossKeys(r1 - 1, r)) r1--;
              const rowCnt = panel.rows.length;
              while (r2 < rowCnt - 1 && sameAcrossKeys(r2 + 1, r)) r2++;
              if (r1 === r2) return null;
              return new CellRange(r1, c, r2, c);
            }
            return super.getMergedRange(panel, r, c, clip);
          }
        }
        g.mergeManager = new HierarchicalMergeManager();

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
          allowMerging
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
