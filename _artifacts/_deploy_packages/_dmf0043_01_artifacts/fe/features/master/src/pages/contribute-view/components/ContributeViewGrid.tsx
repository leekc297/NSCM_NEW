import type { FlexGrid, FormatItemEventArgs, GridPanel } from '@mescius/wijmo.grid';
import { CellRange } from '@mescius/wijmo.grid';
import {
  AllowMerging,
  CellType,
  MergeManager,
  type FlexGrid as FlexGridType,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useMemo } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';

import { MENU_ID, SHEETS } from '../contribute-view.constants';
import { buildColumnMeta, type ColumnMeta } from '../hooks/useContributeViewExpression';
import type { SalesViewRow, SpreadTitleRow } from '../types';
import { useContributeViewStore } from '../useContributeViewStore';

interface Props {
  gridRef: MutableRefObject<FlexGridType<SalesViewRow> | undefined>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  data: SalesViewRow[];
}

// AS-IS DMF0043_Contribute_View.cs InitSpread + SetSpreadHeaderSpan
//   - 좌측 9 컬럼 (BASE) = staticColumns + frozen (wrapper 자동)
//   - 우측 동적 (지역 × Commission/Markup) = dynamicColumns (large group + leaf)
//   - read-only grid (AS-IS L342: siMain.LockColumn(0, Max, true))
//   - 룰 #10 datagrid-shared-component-mandatory: 공용 DataGrid wrapper + @foundation/utils
//   - 룰 #70 P3: SalesViewRow extends WijmoRowItem (types.ts)
//   - 룰 #70 P4: dynamicColumns group + leaf 객체에 allowSorting/allowMerging false 명시

// 동적 컬럼 (Row 0 large = 지역, Row 1 leaf = Commission/Markup) → FlexGridColumnConfig
// 인접 같은 large 컬럼은 wijmo `allowMerging: ColumnHeaders` 가 자동 가로 머지.
// 룰 #70 P4 — group + leaf 객체에 allowSorting/allowMerging false 명시.
// ⭐ 동적 컬럼 = 지역(large) group + Commission/Markup(leaf) 로 구성.
//   같은 지역의 인접 leaf 를 **하나의 group(leaf N개)** 으로 묶는다 (2026-07-07).
//   → columnGroups 트리가 UI 다단 헤더와 1:1. 공통 GridAction.excelDownload 다단 경로가
//     상단(지역)=leaf 수 만큼 가로 머지 / 하단(leaf)=colSpan1(미머지) 로 UI 에 보이는 그대로 재현.
//   (구조: 지역×Type 마다 leaf 1개 group → 트리 colSpan=1 → Excel 상단 가로 머지 누락 사고, memory pivot-header)
//   visible:true 명시 — 미명시 시 excelDownload 의 new Column({visible}) 이 hidden 처리(동적 컬럼 누락).
const buildDynamicColumns = (metas: ColumnMeta[]): FlexGridColumnConfig[] => {
  const groups: FlexGridColumnConfig[] = [];
  for (const m of metas) {
    if (m.isBase || m.isHidden) continue;
    const leaf = {
      binding: m.binding,
      header: m.leaf,
      width: m.width,
      align: 'right',
      format: 'n0',
      allowSorting: false,
      allowMerging: false,
      height: 24,
      visible: true,
      _inputEditType: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
    } as FlexGridColumnConfig;
    const last = groups[groups.length - 1];
    // 인접 동일 지역이면 leaf 를 기존 group 에 추가(가로 머지 대상), 아니면 새 group.
    if (last && last.header === m.large) {
      last.columns!.push(leaf);
    } else {
      groups.push({
        header: m.large,
        align: 'center',
        allowSorting: false,
        allowMerging: false,
        height: 24,
        visible: true,
        columns: [leaf],
      } as FlexGridColumnConfig);
    }
  }
  return groups;
};

export const ContributeViewGrid = ({ gridRef, gridFilterRef, data }: Props) => {
  const titleFilter = useContributeViewStore(s => s.filters[SHEETS.MAIN_TITLE]);
  // BASE 컬럼 = admin SHEET_COLUMNS (UI Category Setup) 동적 fetch — VISIBLE/WIDTH/ALIGN
  // 즉시 반영 (룰 #65 ui-category-setup-column-meta). 하드코딩 0.
  // ⚠️ hook #70 P1 — `?? []` fallback 금지 (매 render 새 array → re-render loop).
  //    store init 에 `[SHEETS.MAIN]: []` 명시 → undefined 안 됨.
  const staticColumnsAll = useContributeViewStore(s => s.staticColumns[SHEETS.MAIN]);
  const visibleBaseColumns = useContributeViewStore(s => s.visibleBaseColumns);

  // ColumnSettingModal OK 결과 (visibleBaseColumns) 반영 — display flag 동적 override.
  // 빈배열 = popup 사용 전 (전체 표시).
  const staticColumns = useMemo(() => {
    if (!staticColumnsAll || visibleBaseColumns.length === 0) return staticColumnsAll;
    return staticColumnsAll.map(c => ({
      ...c,
      display: visibleBaseColumns.includes(c.colNm),
    }));
  }, [staticColumnsAll, visibleBaseColumns]);

  // AS-IS InitSpread: DMF0043_GET_SALES_LIST_SPREAD_TITLE — 동적 컬럼 (지역×Type) 메타 fetch
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

  // SP titleData 의 dynamic 컬럼만 build (BASE 9 = admin staticColumns 가 처리)
  const columnMetas = useMemo<ColumnMeta[]>(
    () => buildColumnMeta(titleRows, staticColumnsAll?.map(col => col.colNm) as string[]),
    [titleRows]
  );

  const dynamicColumns = useMemo(() => buildDynamicColumns(columnMetas), [columnMetas]);

  // background: #F7F7F8;
  const fixedBindings = ['YYYYMM', 'DEPARTMENT_NAME', 'DEPT_NAME', 'CUST_REPORT'];

  const onFormatItem = (s: FlexGrid, e: FormatItemEventArgs) => {
    if (e.panel.cellType === CellType.Cell) {
      const colName = s.columns[e.col].binding;

      if (fixedBindings.includes(colName as string)) {
        e.cell.style.backgroundColor = '#F7F7F8';
      }
    }

    if (e.panel.cellType === CellType.TopLeft) {
      e.panel.setCellData(0, 0, 'No');
    }
  };

  class HierarchicalMergeManager extends MergeManager {
    getMergedRange(panel: GridPanel, r: number, c: number, _clip = true): CellRange | null {
      const col = panel.columns[c];
      if (!col) return null;
      const binding = col.binding ?? '';

      // 2줄 고정이라 일단 하드코딩으로 세팅
      if (panel.cellType === CellType.TopLeft) {
        return new CellRange(0, c, 1, c);
      }

      if (panel.cellType === CellType.ColumnHeader) {
        const rg = new CellRange(r, c);
        // 위쪽 방향으로 헤더 텍스트가 같은 행이 있는지 탐색
        for (let i = r; i > 0; i--) {
          if (panel.getCellData(i, c, false) === panel.getCellData(i - 1, c, false)) {
            rg.row = i - 1;
          } else {
            break;
          }
        }
        // 아래쪽 방향으로 헤더 텍스트가 같은 행이 있는지 탐색
        for (let i = r; i < panel.rows.length - 1; i++) {
          if (panel.getCellData(i, c, false) === panel.getCellData(i + 1, c, false)) {
            rg.row2 = i + 1;
          } else {
            break;
          }
        }

        for (let i = c; i > 0; i--) {
          if (panel.getCellData(r, i, false) === panel.getCellData(r, i - 1, false)) {
            rg.col = i - 1;
          } else {
            break;
          }
        }
        // 💡 오른쪽 방향으로 헤더 텍스트가 같은 열이 있는지 탐색
        for (let i = c; i < panel.columns.length - 1; i++) {
          if (panel.getCellData(r, i, false) === panel.getCellData(r, i + 1, false)) {
            rg.col2 = i + 1;
          } else {
            break;
          }
        }
        return rg;
      }

      if (panel.cellType === CellType.Cell && fixedBindings.includes(binding)) {
        const view = panel.rows;
        const rowItem = (i: number): Record<string, unknown> | undefined =>
          (view[i] as unknown as { dataItem?: Record<string, unknown> })?.dataItem;
        const cur = rowItem(r);
        if (!cur) return null;
        const fixedIdx = fixedBindings.indexOf(binding);
        const leftBindings = fixedBindings.slice(0, fixedIdx + 1);
        const sameRow = (a: number, b: number): boolean => {
          const ra = rowItem(a);
          const rb = rowItem(b);
          if (!ra || !rb) return false;
          return leftBindings.every(
            k =>
              ((ra as Record<string, string>)[k] ?? '') ===
              ((rb as Record<string, string>)[k] ?? '')
          );
        };
        const minRow = panel.viewRange.row;
        const maxRow = panel.viewRange.row2;
        let r1 = r,
          r2 = r;
        while (r1 > minRow && sameRow(r1 - 1, r)) r1--;
        while (r2 < maxRow && sameRow(r2 + 1, r)) r2++;
        if (r1 === r2) return null;
        return new CellRange(r1, c, r2, c);
      }
      return new CellRange(r, c);
    }
  }

  return (
    <DataGrid<SalesViewRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      staticColumns={staticColumns}
      dynamicColumns={dynamicColumns}
      frozenColumns={staticColumns?.length ? staticColumns?.length - 1 : 0}
      itemsSource={data}
      isReadOnly
      allowMerging={AllowMerging.All}
      formatItem={onFormatItem}
      mergeManager={new HierarchicalMergeManager()}
    />
  );
};
