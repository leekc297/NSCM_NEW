import type { FlexGrid, FormatItemEventArgs, GridPanel } from '@mescius/wijmo.grid';
import { CellRange } from '@mescius/wijmo.grid';
import {
  AllowMerging,
  CellType,
  MergeManager,
  type FlexGrid as FlexGridType,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useMemo, useRef } from 'react';

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
  // ⭐ ColumnLayoutModal OK 결과(표시/순서/폭/색)는 store 의 applyColumnLayout 이 이미 반영해 둔다.
  //   화면에서 별도 override 하지 않고 그대로 사용한다 (구 visibleBaseColumns 경로 제거).
  const staticColumns = useContributeViewStore(s => s.staticColumns[SHEETS.MAIN]);

  // ⭐ 컬럼 개인화 색 (ColumnLayoutModal 저장값) — binding → {cell, text}.
  //   공용 DataGrid 는 colWth/display 만 옮기고 색은 안 넘기므로 formatItem 이 직접 적용한다
  //   (mkt-fcst/forecast-price 선례 동일). ref 로 최신 맵 전달 — 핸들러 재바인딩 무관.
  const colorMetaRef = useRef<Map<string, { cell: string; text: string }>>(new Map());
  colorMetaRef.current = useMemo(() => {
    const m = new Map<string, { cell: string; text: string }>();
    (staticColumns ?? []).forEach(c => {
      if (c.cellColor || c.textColor) {
        m.set(c.colNm, { cell: c.cellColor ?? '', text: c.textColor ?? '' });
      }
    });
    return m;
  }, [staticColumns]);

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
  //   ⚠️ isBase 판정용 이름 집합 — 비표시 컬럼도 BASE 로 남아야 동적 컬럼으로 새어나가지 않는다.
  //     개인화는 표시/순서만 바꾸고 컬럼 membership 은 그대로라 staticColumns 를 그대로 쓴다.
  const columnMetas = useMemo<ColumnMeta[]>(
    () =>
      buildColumnMeta(
        titleRows,
        (staticColumns ?? []).map(col => col.colNm)
      ),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [titleRows]
  );

  const dynamicColumns = useMemo(() => buildDynamicColumns(columnMetas), [columnMetas]);

  // background: #F7F7F8;
  const fixedBindings = ['YYYYMM', 'DEPARTMENT_NAME', 'DEPT_NAME', 'CUST_REPORT'];

  const onFormatItem = (s: FlexGrid, e: FormatItemEventArgs) => {
    // if (e.panel.cellType === CellType.Cell) {
    //   const colName = s.columns[e.col].binding;

    //   if (fixedBindings.includes(colName as string)) {
    //     e.cell.style.backgroundColor = '#F7F7F8';
    //   }
    // }

    if (e.panel.cellType === CellType.TopLeft) {
      e.panel.setCellData(0, 0, 'No');
      return;
    }

    // ⭐ 개인화 색 (ColumnLayoutModal 저장값) — 조회 전용 그리드라 편집 하이라이트와 경합 없음.
    //   미지정 시 removeProperty 필수 — Wijmo 셀 재활용으로 이전 컬럼 색이 남는다.
    if (e.panel.cellType === CellType.Cell) {
      const personalColor = colorMetaRef.current.get(s.columns[e.col]?.binding ?? '');
      if (personalColor?.cell) {
        e.cell.style.setProperty('background-color', personalColor.cell, 'important');
      } else {
        e.cell.style.removeProperty('background-color');
      }
      if (personalColor?.text) {
        e.cell.style.setProperty('color', personalColor.text, 'important');
      } else {
        e.cell.style.removeProperty('color');
      }
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
      // ⭐ 2026-08-11 — frozenColumns 를 화면에서 지정하지 않는다(사용자 요구). 공용 DataGrid wrapper 가
      //   admin SHEET_COLUMNS 의 Fixed(=_fixed) 마지막 컬럼까지 자동 고정한다
      //   (`DataGrid.tsx` findLastIndex(_fixed)+1, display=false 컬럼 제외 후 계산이라 인덱스도 안전).
      //   → 고정 범위 변경은 코드 수정 없이 admin 컬럼관리에서 Fixed 를 옮기면 된다.
      //   현재 등록: DM_BIZ_TYPE(Biz) = Y → 년월 ~ Biz 고정.
      itemsSource={data}
      isReadOnly
      allowMerging={AllowMerging.All}
      formatItem={onFormatItem}
      mergeManager={new HierarchicalMergeManager()}
    />
  );
};
